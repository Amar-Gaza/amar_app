import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/order_service.dart';
import '../../data/services/shared/upload_service.dart';
import '../shared/app_config_controller.dart';

/// Order page (designs 05 and 06). Polls events while the order is open
/// and reloads it when anything happens.
class OrderDetailsController extends GetxController {
  OrderDetailsController(
    this._orders,
    this._config,
    this._uploads,
    this.orderId,
  );

  final OrderService _orders;
  final AppConfigController _config;
  final UploadService _uploads;
  final int orderId;

  final Rxn<Order> order = Rxn<Order>();
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final Rxn<ServiceQuote> serviceQuote = Rxn<ServiceQuote>();
  final RxBool isAnsweringQuote = false.obs;
  final Rxn<ApiFailure> quoteFailure = Rxn<ApiFailure>();
  final RxBool isSendingReceipt = false.obs;
  final Rxn<ApiFailure> receiptFailure = Rxn<ApiFailure>();
  Timer? _poll;
  String? _lastEvent;

  /// Steps of this order's own flow, and the current one.
  (int total, int index) get progress =>
      _config.progressOf(order.value?.status.key ?? '');

  bool get needsReceipt =>
      order.value?.status.key == OrderStatusKeys.awaitingPayment;

  /// The vendor's latest price while it waits for the customer's answer.
  ServiceQuote? get openQuote {
    final quote = serviceQuote.value;
    return quote?.status == OrderStatusKeys.quoteSent ? quote : null;
  }

  bool can(String action) =>
      order.value?.availableActions.any((a) => a.action == action) ?? false;

  OrderAction? action(String action) =>
      order.value?.availableActions.firstWhereOrNull((a) => a.action == action);

  bool get hasOffer => order.value?.status.key == AppDefaults.pricedStatus;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (isLoading.value) return;
    isLoading.value = true;
    failure.value = null;
    try {
      order.value = await _orders.show(orderId);
      await _loadServiceQuote();
      _schedule();
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  void _schedule() {
    _poll?.cancel();
    if (order.value?.status.isTerminal ?? true) return;
    _poll = Timer.periodic(
      _config.poll(PollKeys.events, AppDefaults.pollFallbackSeconds),
      (_) => _checkEvents(),
    );
  }

  Future<void> _checkEvents() async {
    try {
      final events = await _orders.events(orderId, since: _lastEvent);
      if (events.isEmpty) return;
      _lastEvent = '${events.last.id}';
      order.value = await _orders.show(orderId);
      await _loadServiceQuote();
      if (order.value?.status.isTerminal ?? false) _poll?.cancel();
    } on ApiFailure {
      // Polling is best-effort; the next tick retries.
    }
  }

  /// A 404 means the vendor has not priced the service yet.
  Future<void> _loadServiceQuote() async {
    final status = order.value?.status;
    if (status == null ||
        status.isTerminal ||
        !OrderStatusKeys.isService(status.key)) {
      serviceQuote.value = null;
      return;
    }
    try {
      serviceQuote.value = await _orders.serviceQuote(orderId);
    } on ApiFailure {
      serviceQuote.value = null;
    }
  }

  Future<void> acceptQuote() => _answerQuote(_orders.acceptServiceQuote);

  Future<void> rejectQuote() => _answerQuote(_orders.rejectServiceQuote);

  Future<void> _answerQuote(
    Future<ServiceQuote> Function(int id, {required int quoteId}) answer,
  ) async {
    final quote = openQuote;
    if (quote == null || isAnsweringQuote.value) return;
    isAnsweringQuote.value = true;
    quoteFailure.value = null;
    try {
      await answer(orderId, quoteId: quote.id);
      await load();
    } on ApiFailure catch (e) {
      quoteFailure.value = e;
      // quote_changed: show the vendor's new price for a fresh answer.
      if (e.code == ApiErrorCodes.quoteChanged) await _loadServiceQuote();
    } finally {
      isAnsweringQuote.value = false;
    }
  }

  Future<void> sendReceipt(String path) async {
    if (isSendingReceipt.value) return;
    isSendingReceipt.value = true;
    receiptFailure.value = null;
    try {
      final upload = await _uploads.upload(
        filePath: path,
        purpose: AppDefaults.uploadPurposeReceipt,
      );
      order.value = await _orders.sendPaymentReceipt(
        orderId,
        uploadId: upload.uploadId,
      );
    } on ApiFailure catch (e) {
      receiptFailure.value = e;
    } on DioException {
      receiptFailure.value = const ApiFailure(code: ApiErrorCodes.networkError);
    } finally {
      isSendingReceipt.value = false;
    }
  }

  @override
  void onClose() {
    _poll?.cancel();
    super.onClose();
  }
}
