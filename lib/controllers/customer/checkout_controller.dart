import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/app_durations.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/models/requests/place_order_request.dart';
import '../../data/models/requests/quote_request.dart';
import '../../data/services/customer/address_service.dart';
import '../../data/services/customer/catalog_service.dart';
import '../../data/services/customer/order_service.dart';
import '../../data/services/shared/upload_service.dart';
import '../shared/app_config_controller.dart';
import 'cart_controller.dart';

/// One attachment while it uploads, after it uploads, or when it failed.
class PendingUpload {
  PendingUpload(this.path);

  final String path;
  final RxDouble progress = 0.0.obs;
  final Rxn<Upload> upload = Rxn<Upload>();
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  bool get isDone => upload.value != null;
  String get name => path.split(RegExp(r'[\\/]')).last;
}

/// Whole checkout: cart → delivery → quote → place order.
/// Lives with the cart route so every checkout screen shares it.
class CheckoutController extends GetxController {
  CheckoutController({
    required CartController cart,
    required AddressService addresses,
    required OrderService orders,
    required UploadService uploads,
    required CatalogService catalog,
    required AppConfigController config,
  })  : _cart = cart,
        _addresses = addresses,
        _orders = orders,
        _uploads = uploads,
        _catalog = catalog,
        _config = config;

  static const Uuid _uuid = Uuid();

  final CartController _cart;
  final AddressService _addresses;
  final OrderService _orders;
  final UploadService _uploads;
  final CatalogService _catalog;
  final AppConfigController _config;

  // Delivery
  final RxList<Address> addresses = <Address>[].obs;
  final Rxn<Address> address = Rxn<Address>();
  final RxBool isLoadingAddresses = false.obs;
  final Rxn<ApiFailure> addressesFailure = Rxn<ApiFailure>();
  final Rxn<DateTime> scheduledFor = Rxn<DateTime>();
  final RxString paymentMethod = ''.obs;
  final Rxn<Vendor> vendor = Rxn<Vendor>();

  // Details
  final TextEditingController note = TextEditingController();
  final RxList<PendingUpload> attachments = <PendingUpload>[].obs;

  // Coupon
  final TextEditingController couponInput = TextEditingController();
  final RxnString coupon = RxnString();
  final Rxn<CouponCheck> couponCheck = Rxn<CouponCheck>();
  final Rxn<ApiFailure> couponFailure = Rxn<ApiFailure>();
  final RxBool isCheckingCoupon = false.obs;

  // Quote
  final Rxn<Quote> quote = Rxn<Quote>();
  final RxBool isQuoting = false.obs;
  final Rxn<ApiFailure> quoteFailure = Rxn<ApiFailure>();
  final RxInt quoteSecondsLeft = 0.obs;
  Timer? _quoteTimer;

  // Place
  final RxBool isPlacing = false.obs;
  final Rxn<ApiFailure> placeFailure = Rxn<ApiFailure>();
  final Rxn<Order> placedOrder = Rxn<Order>();
  String? _idempotencyKey;

  List<String> get paymentMethods =>
      _config.config.value?.paymentMethods ?? const [];
  bool get attachmentsEnabled =>
      _config.config.value?.modules.contains(ApiModules.attachments) ?? false;
  bool get couponsEnabled =>
      _config.config.value?.modules.contains(ApiModules.coupons) ?? false;
  bool get isQuoteExpired => quote.value != null && quoteSecondsLeft.value <= 0;
  bool get hasPendingUploads =>
      attachments.any((a) => !a.isDone && a.failure.value == null);
  bool get canRequestQuote =>
      _cart.items.isNotEmpty && address.value != null && !hasPendingUploads;

  @override
  void onInit() {
    super.onInit();
    if (paymentMethods.isNotEmpty) paymentMethod.value = paymentMethods.first;
    loadAddresses();
    _loadVendor();
  }

  Future<void> _loadVendor() async {
    final id = _cart.vendorId;
    if (id == null) return;
    try {
      vendor.value = await _catalog.vendor(id);
    } on ApiFailure {
      // The pickup row falls back to a generic label.
    }
  }

  Future<void> loadAddresses() async {
    if (isLoadingAddresses.value) return;
    isLoadingAddresses.value = true;
    addressesFailure.value = null;
    try {
      final list = await _addresses.list();
      addresses.assignAll(list);
      address.value ??=
          list.firstWhereOrNull((a) => a.isDefault) ?? list.firstOrNull;
    } on ApiFailure catch (e) {
      addressesFailure.value = e;
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  void selectAddress(Address value) {
    address.value = value;
    _invalidateQuote();
  }

  void addAddress(Address value) {
    addresses.add(value);
    selectAddress(value);
  }

  void setSchedule(DateTime? value) {
    scheduledFor.value = value;
    _invalidateQuote();
  }

  void setPayment(String value) {
    paymentMethod.value = value;
    _invalidateQuote();
  }

  // ---------------- attachments ----------------

  Future<void> attach(String path) async {
    if (attachments.length >= AppDefaults.maxAttachments) return;
    final pending = PendingUpload(path);
    attachments.add(pending);
    await _upload(pending);
  }

  Future<void> retryUpload(PendingUpload pending) => _upload(pending);

  void removeAttachment(PendingUpload pending) => attachments.remove(pending);

  Future<void> _upload(PendingUpload pending) async {
    pending
      ..failure.value = null
      ..progress.value = 0;
    attachments.refresh();
    try {
      pending.upload.value = await _uploads.upload(
        filePath: pending.path,
        purpose: AppDefaults.uploadPurposeAttachment,
        onProgress: (sent, total) {
          if (total > 0) pending.progress.value = sent / total;
        },
      );
    } on ApiFailure catch (e) {
      pending.failure.value = e;
    } on DioException {
      pending.failure.value =
          const ApiFailure(code: ApiErrorCodes.networkError);
    } finally {
      attachments.refresh();
    }
  }

  // ---------------- coupon ----------------

  Future<void> checkCoupon() async {
    final code = couponInput.text.trim();
    if (code.isEmpty || isCheckingCoupon.value) return;
    isCheckingCoupon.value = true;
    couponFailure.value = null;
    couponCheck.value = null;
    try {
      couponCheck.value =
          await _orders.validateCoupon(code, vendorId: _cart.vendorId);
    } on ApiFailure catch (e) {
      couponFailure.value = e;
    } finally {
      isCheckingCoupon.value = false;
    }
  }

  void applyCoupon() {
    final check = couponCheck.value;
    if (check == null) return;
    coupon.value = check.code;
    _invalidateQuote();
  }

  void removeCoupon() {
    coupon.value = null;
    couponCheck.value = null;
    couponInput.clear();
    _invalidateQuote();
  }

  // ---------------- quote ----------------

  Future<bool> requestQuote() async {
    if (!canRequestQuote || isQuoting.value) return false;
    isQuoting.value = true;
    quoteFailure.value = null;
    try {
      final result = await _orders.quote(
        QuoteRequest(
          vendorId: _cart.vendorId,
          cart: _cart.items.map((e) => e.toCartLine()).toList(),
          dropoffAddressId: address.value!.id,
          paymentMethod:
              paymentMethod.value.isEmpty ? null : paymentMethod.value,
          scheduledFor: scheduledFor.value,
          coupon: coupon.value,
        ),
      );
      quote.value = result;
      _idempotencyKey = _uuid.v4();
      _startQuoteTimer(result.expiresIn);
      return true;
    } on ApiFailure catch (e) {
      quoteFailure.value = e;
      return false;
    } finally {
      isQuoting.value = false;
    }
  }

  void _startQuoteTimer(int seconds) {
    _quoteTimer?.cancel();
    quoteSecondsLeft.value = seconds;
    _quoteTimer = Timer.periodic(AppDurations.tick, (timer) {
      if (quoteSecondsLeft.value <= 1) {
        quoteSecondsLeft.value = 0;
        timer.cancel();
      } else {
        quoteSecondsLeft.value--;
      }
    });
  }

  void _invalidateQuote() {
    _quoteTimer?.cancel();
    quote.value = null;
    quoteSecondsLeft.value = 0;
    _idempotencyKey = null;
  }

  // ---------------- place ----------------

  bool get quoteNeedsRefresh {
    final code = placeFailure.value?.code;
    return isQuoteExpired ||
        code == ApiErrorCodes.quoteExpired ||
        code == ApiErrorCodes.quoteUsed;
  }

  Future<bool> placeOrder() async {
    final current = quote.value;
    if (current == null || isPlacing.value || isQuoteExpired) return false;
    isPlacing.value = true;
    placeFailure.value = null;
    try {
      final order = await _orders.place(
        PlaceOrderRequest(
          quoteToken: current.quoteToken,
          uploadIds: attachments
              .where((a) => a.isDone)
              .map((a) => a.upload.value!.uploadId)
              .toList(),
          note: note.text.trim().isEmpty ? null : note.text.trim(),
        ),
        idempotencyKey: _idempotencyKey ??= _uuid.v4(),
      );
      placedOrder.value = order;
      _cart.clear();
      return true;
    } on ApiFailure catch (e) {
      placeFailure.value = e;
      return false;
    } finally {
      isPlacing.value = false;
    }
  }

  /// After quote_expired / quote_used: fetch a fresh quote.
  Future<bool> refreshQuote() async {
    placeFailure.value = null;
    _invalidateQuote();
    return requestQuote();
  }

  @override
  void onClose() {
    _quoteTimer?.cancel();
    note.dispose();
    couponInput.dispose();
    super.onClose();
  }
}
