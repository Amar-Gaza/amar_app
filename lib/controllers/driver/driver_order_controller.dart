import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/constants/api_query.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/network/api_failure.dart';
import '../../core/storage/secure_token_storage.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/models/requests/transition_request.dart';
import '../../data/services/driver/driver_order_service.dart';
import '../../data/services/shared/upload_service.dart';
import 'driver_location_controller.dart';
import 'driver_session_controller.dart';

/// One job: details, accept/reject, transitions and delivery (10–22).
class DriverOrderController extends GetxController {
  DriverOrderController(
    this._orders,
    this._uploads,
    this._location,
    this._session,
    this.orderId, {
    DriverOrder? initial,
  }) {
    order.value = initial;
  }

  final DriverOrderService _orders;
  final UploadService _uploads;
  final DriverLocationController _location;
  final DriverSessionController _session;
  final int orderId;

  final Rxn<DriverOrder> order = Rxn<DriverOrder>();
  final RxBool isLoading = false.obs;
  final RxBool isBusy = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  final RxBool delivered = false.obs;

  // Inputs for the next action / delivery.
  final RxnString photoPath = RxnString();
  final TextEditingController otp = TextEditingController();
  final TextEditingController note = TextEditingController();
  final Map<String, TextEditingController> fields = {};

  NextAction? get next => order.value?.nextAction;

  bool get needsPhoto =>
      (next?.requires.contains(ActionRequires.photo) ?? false) ||
      (next?.action == DriverActions.deliver &&
          _session.config.value?.deliveryConfirmation ==
              DeliveryConfirmation.photo);

  bool get needsOtp =>
      (next?.requires.contains(ActionRequires.otp) ?? false) ||
      (next?.action == DriverActions.deliver &&
          _session.config.value?.deliveryConfirmation ==
              DeliveryConfirmation.otp);

  bool get needsLocation =>
      next?.requires.contains(ActionRequires.location) ?? false;

  bool get hasInputs =>
      needsPhoto || needsOtp || (next?.fields.isNotEmpty ?? false);

  TextEditingController field(String key) =>
      fields.putIfAbsent(key, TextEditingController.new);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    // The server shows an order's details only after the driver accepts
    // it; an offer keeps the data from the available list.
    if (order.value?.isMine == false) return;
    isLoading.value = order.value == null;
    failure.value = null;
    try {
      order.value = await _orders.show(orderId);
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _run(Future<DriverOrder?> Function() task) async {
    if (isBusy.value) return false;
    isBusy.value = true;
    failure.value = null;
    try {
      final updated = await task();
      if (updated != null) order.value = updated;
      return true;
    } on ApiFailure catch (e) {
      failure.value = e;
      if (e.code == ApiErrorCodes.invalidTransition) await load();
      return false;
    } finally {
      isBusy.value = false;
    }
  }

  Future<bool> accept() => _run(() => _orders.accept(orderId));

  Future<bool> reject() => _run(() async {
        await _orders.reject(orderId);
        return null;
      });

  Future<List<int>> _uploadPhoto(String purpose) async {
    final path = photoPath.value;
    if (path == null) return const [];
    final upload = await _uploads.upload(
      filePath: path,
      purpose: purpose,
      role: SessionRole.driver,
    );
    return [upload.uploadId];
  }

  Map<String, dynamic> _fieldValues() => {
        for (final key in next?.fields ?? const <String>[])
          if (field(key).text.trim().isNotEmpty) key: field(key).text.trim(),
      };

  /// Runs [next]: accept, a status transition, or the final delivery.
  Future<bool> runNext() async {
    final action = next;
    if (action == null) return false;
    if (needsPhoto && photoPath.value == null) return false;
    if (needsLocation) await _location.sendNow();
    switch (action.action) {
      case DriverActions.accept:
        return accept();
      case DriverActions.deliver:
        final ok = await _run(() async => _orders.deliver(
              orderId,
              DeliverRequest(
                otp: otp.text.trim().isEmpty ? null : otp.text.trim(),
                fields: _fieldValues(),
                uploadIds: await _uploadPhoto(AppDefaults.deliveryProofPurpose),
                note: note.text.trim().isEmpty ? null : note.text.trim(),
              ),
            ));
        if (ok) delivered.value = true;
        _resetInputs();
        return ok;
      default:
        final ok = await _run(() async => _orders.transition(
              orderId,
              TransitionRequest(
                to: action.to,
                fields: _fieldValues(),
                uploadIds: await _uploadPhoto(AppDefaults.transitionPurpose),
                otp: otp.text.trim().isEmpty ? null : otp.text.trim(),
                note: note.text.trim().isEmpty ? null : note.text.trim(),
              ),
            ));
        if (ok) _resetInputs();
        return ok;
    }
  }

  void _resetInputs() {
    photoPath.value = null;
    otp.clear();
    note.clear();
    for (final c in fields.values) {
      c.clear();
    }
  }

  @override
  void onClose() {
    otp.dispose();
    note.dispose();
    for (final c in fields.values) {
      c.dispose();
    }
    super.onClose();
  }
}
