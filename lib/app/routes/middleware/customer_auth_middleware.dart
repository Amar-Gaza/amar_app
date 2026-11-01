import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controllers/shared/session_controller.dart';
import '../app_routes.dart';

class CustomerAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final signedIn = Get.find<SessionController>().isAuthenticated.value;
    return signedIn ? null : const RouteSettings(name: AppRoutes.phone);
  }
}
