import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/network/api_failure.dart';
import '../../data/models/masar/masar_models.dart';
import '../../data/services/customer/order_service.dart';

/// Shared tracking link viewer (designs 16B and account 13).
class PublicTrackingController extends GetxController {
  PublicTrackingController(this._orders, {String? token}) : _initial = token;

  final OrderService _orders;
  final String? _initial;
  final TextEditingController input = TextEditingController();
  final Rxn<PublicTracking> data = Rxn<PublicTracking>();
  final RxBool isLoading = false.obs;
  final Rxn<ApiFailure> failure = Rxn<ApiFailure>();
  Timer? _timer;
  String? _token;

  @override
  void onInit() {
    super.onInit();
    if (_initial != null) {
      input.text = _initial;
      open();
    }
  }

  /// Accepts a bare token or a full link ending with /track/<token>.
  static String tokenFrom(String value) {
    final trimmed = value.trim();
    final uri = Uri.tryParse(trimmed);
    final segments = uri?.pathSegments ?? const <String>[];
    return segments.isEmpty ? trimmed : segments.last;
  }

  Future<void> open() async {
    final token = tokenFrom(input.text);
    if (token.isEmpty) return;
    _token = token;
    await _fetch();
  }

  Future<void> _fetch() async {
    _timer?.cancel();
    final token = _token;
    if (token == null) return;
    isLoading.value = data.value == null;
    failure.value = null;
    try {
      data.value = await _orders.publicTracking(token);
    } on ApiFailure catch (e) {
      failure.value = e;
    } finally {
      isLoading.value = false;
    }
    final current = data.value;
    if (current == null || current.order.status.isTerminal) return;
    _timer = Timer(Duration(seconds: current.pollSeconds), _fetch);
  }

  @override
  void onClose() {
    _timer?.cancel();
    input.dispose();
    super.onClose();
  }
}
