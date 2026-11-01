import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/routes/app_routes.dart';
import '../../../controllers/customer/cart_controller.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/theme_context.dart';
import '../../../l10n/app_localizations.dart';

/// Cart icon with the item count; opens the cart.
class CartButton extends StatelessWidget {
  const CartButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final colors = context.appColors;
    return Obx(
      () => IconButton(
        tooltip: AppLocalizations.of(context).cartTitle,
        onPressed: onPressed ?? () => Get.toNamed<void>(AppRoutes.cart),
        icon: Badge(
          isLabelVisible: cart.count > 0,
          backgroundColor: colors.danger,
          label: Text('${cart.count}'),
          child: Icon(
            LucideIcons.shoppingCart,
            size: AppSizes.iconMd,
            color: colors.ink,
          ),
        ),
      ),
    );
  }
}
