import 'package:get/get.dart';

enum CustomerTab { home, orders, notifications, account }

class ShellController extends GetxController {
  final Rx<CustomerTab> tab = CustomerTab.home.obs;

  void select(CustomerTab value) => tab.value = value;
}
