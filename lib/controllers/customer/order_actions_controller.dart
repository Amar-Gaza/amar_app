import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/network/api_failure.dart';
import '../../data/models/api/cancel_reason.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/models/requests/rate_order_request.dart';
import '../../data/services/customer/order_service.dart';

/// Cancel (07, 08), offer (09–11), rate (15), receipt (14), share (16).
class OrderActionsController extends GetxController {
  OrderActionsController(this._orders, this.orderId);

  final OrderService _orders;
  final int orderId;

  final RxBool isBusy = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();

  // Cancel
  final RxList<CancelReason> reasons = <CancelReason>[].obs;
  final RxnString reason = RxnString();
  final TextEditingController note = TextEditingController();

  // Offer
  final Rxn<Offer> offer = Rxn<Offer>();

  // Rate
  final RxInt stars = 0.obs;
  final RxInt vendorStars = 0.obs;
  final TextEditingController comment = TextEditingController();

  // Receipt
  final Rxn<Receipt> receipt = Rxn<Receipt>();

  // Share
  final Rxn<ShareLink> shareLink = Rxn<ShareLink>();

  Future<T?> _run<T>(Future<T> Function() task) async {
    if (isBusy.value) return null;
    isBusy.value = true;
    failure.value = null;
    try {
      return await task();
    } on ApiFailure catch (e) {
      failure.value = e;
      return null;
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> loadReasons() async {
    final list = await _run(_orders.cancelReasons);
    if (list != null) reasons.assignAll(list);
  }

  Future<Order?> cancel() {
    final key = reason.value;
    if (key == null) return Future.value();
    return _run(
      () => _orders.cancel(
        orderId,
        reason: key,
        note: note.text.trim().isEmpty ? null : note.text.trim(),
      ),
    );
  }

  Future<void> loadOffer() async {
    final value = await _run(() => _orders.offer(orderId));
    if (value != null) offer.value = value;
  }

  Future<bool> approveOffer() async {
    final current = offer.value;
    if (current == null) return false;
    final value =
        await _run(() => _orders.approveOffer(orderId, offerId: current.id));
    if (value != null) {
      offer.value = value;
      return true;
    }
    final error = failure.value;
    if (error != null &&
        (error.hasReason(ApiErrorCodes.offerChanged) ||
            error.hasReason(ApiErrorCodes.offerExpired))) {
      await _refreshOffer();
    }
    return false;
  }

  /// Shows the store's latest offer while keeping the failure banner, so
  /// the customer reads why and answers the new price.
  Future<void> _refreshOffer() async {
    try {
      offer.value = await _orders.offer(orderId);
    } on ApiFailure {
      // The banner already explains the conflict; retry stays available.
    }
  }

  Future<bool> rejectOffer(String? why) async {
    final value = await _run(
      () => _orders.rejectOffer(
        orderId,
        offerId: offer.value?.id,
        reason: why,
      ),
    );
    if (value != null) offer.value = value;
    return value != null;
  }

  Future<bool> rate({required bool hasVendor}) async {
    if (stars.value == 0) return false;
    final value = await _run(
      () => _orders.rate(
        orderId,
        RateOrderRequest(
          stars: stars.value,
          comment: comment.text.trim().isEmpty ? null : comment.text.trim(),
          vendorStars:
              hasVendor && vendorStars.value > 0 ? vendorStars.value : null,
        ),
      ),
    );
    return value != null;
  }

  Future<void> loadReceipt() async {
    final value = await _run(() => _orders.receipt(orderId));
    if (value != null) receipt.value = value;
  }

  Future<void> createShareLink() async {
    final value = await _run(() => _orders.createShareLink(orderId));
    if (value != null) shareLink.value = value;
  }

  Future<void> revokeShareLink() async {
    final ok = await _run(() async {
      await _orders.revokeShareLink(orderId);
      return true;
    });
    if (ok ?? false) shareLink.value = null;
  }

  @override
  void onClose() {
    note.dispose();
    comment.dispose();
    super.onClose();
  }
}
