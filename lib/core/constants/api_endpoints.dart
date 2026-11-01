/// Paths from api/amar-openapi.json (config v4).
abstract final class ApiEndpoints {
  static const String _v1 = '/v1';
  static const String driverPrefix = '$_v1/driver';

  // Shared
  static const String appConfig = '$_v1/app/config';
  static const String uploads = '$_v1/uploads';
  static String publicTracking(String token) => '$_v1/track/$token';

  // Customer auth and profile
  static const String sendOtp = '$_v1/auth/send-otp';
  static const String verifyOtp = '$_v1/auth/verify-otp';
  static const String logout = '$_v1/auth/logout';
  static const String me = '$_v1/me';
  static const String meFcmToken = '$_v1/me/fcm-token';

  // Catalog
  static const String categories = '$_v1/categories';
  static const String vendors = '$_v1/vendors';
  static String vendor(int id) => '$vendors/$id';
  static const String products = '$_v1/products';
  static String product(int id) => '$products/$id';
  static const String vendorApplications = '$_v1/vendor-applications';

  // Addresses
  static const String addresses = '$_v1/addresses';
  static String address(int id) => '$addresses/$id';

  // Orders
  static const String orders = '$_v1/orders';
  static const String quote = '$orders/quote';
  static const String cancelReasons = '$_v1/cancel-reasons';
  static const String validateCoupon = '$_v1/coupons/validate';
  static String order(int id) => '$orders/$id';
  static String orderCancel(int id) => '${order(id)}/cancel';
  static String orderEvents(int id) => '${order(id)}/events';
  static String orderOffer(int id) => '${order(id)}/offer';
  static String orderOfferApprove(int id) => '${orderOffer(id)}/approve';
  static String orderOfferReject(int id) => '${orderOffer(id)}/reject';
  static String orderRate(int id) => '${order(id)}/rate';
  static String orderReceipt(int id) => '${order(id)}/receipt';
  static String orderShareLink(int id) => '${order(id)}/share-link';
  static String orderTracking(int id) => '${order(id)}/tracking';
  static String sandboxAdvance(int id) => '$_v1/sandbox/orders/$id/advance';

  // Customer notifications
  static const String notifications = '$_v1/notifications';

  // Driver
  static const String driverLogin = '$driverPrefix/auth/login';
  static const String driverLogout = '$driverPrefix/auth/logout';
  static const String driverMe = '$driverPrefix/me';
  static const String driverFcmToken = '$driverPrefix/me/fcm-token';
  static const String driverStatus = '$driverPrefix/status';
  static const String driverLocation = '$driverPrefix/location';
  static const String driverCash = '$driverPrefix/cash';
  static const String driverEarnings = '$driverPrefix/earnings';
  static const String driverSettleCash = '$driverPrefix/sandbox/settle-cash';
  static const String driverNotifications = '$driverPrefix/notifications';
  static const String driverOrdersAvailable = '$driverPrefix/orders/available';
  static const String driverOrdersCurrent = '$driverPrefix/orders/current';
  static const String driverOrdersHistory = '$driverPrefix/orders/history';
  static String driverOrder(int id) => '$driverPrefix/orders/$id';
  static String driverOrderAccept(int id) => '${driverOrder(id)}/accept';
  static String driverOrderReject(int id) => '${driverOrder(id)}/reject';
  static String driverOrderTransition(int id) =>
      '${driverOrder(id)}/transition';
  static String driverOrderDeliver(int id) => '${driverOrder(id)}/deliver';

  // Notification sub-paths (customer and driver share the shape).
  static String readAll(String base) => '$base/read-all';
  static String opened(String base, int id) => '$base/$id/opened';
}
