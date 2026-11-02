import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/bindings/checkout_binding.dart';
import '../../../../controllers/customer/checkout_controller.dart';
import '../../checkout/cart_screen.dart';

/// Owns the checkout controller while the cart tab is open, so each visit
/// starts from a clean checkout state.
class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  @override
  void initState() {
    super.initState();
    CheckoutBinding().dependencies();
  }

  @override
  void dispose() {
    Get.delete<CheckoutController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const CartScreen();
}
