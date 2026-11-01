import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/customer/splash_controller.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/splash/config_loading_view.dart';
import '../../widgets/splash/splash_brand_view.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Obx(() {
        final failure = controller.failure.value;
        if (failure != null) {
          return Scaffold(
            body: SafeArea(
              child: ErrorView(failure: failure, onRetry: controller.start),
            ),
          );
        }
        if (controller.isRetrying.value) return const ConfigLoadingView();
        return const SplashBrandView();
      });
}
