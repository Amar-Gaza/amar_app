import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../controllers/driver/driver_session_controller.dart';
import '../app_routes.dart';

class DriverAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) =>
      Get.find<DriverSessionController>().isSignedIn
          ? null
          : const RouteSettings(name: AppRoutes.driverLogin);
}
