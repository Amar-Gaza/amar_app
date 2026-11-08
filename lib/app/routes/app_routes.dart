abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String phone = '/phone';
  static const String otp = '/otp';
  static const String profile = '/profile';
  static const String location = '/location';
  static const String mapPicker = '/map-picker';
  static const String serviceRequest = '/service-request';
  static const String notifications = '/notifications';
  static const String home = '/home';

  // Catalog
  static const String search = '/search';
  static const String aiAssistant = '/ai-assistant';
  static const String categories = '/categories';
  static const String vendors = '/vendors';
  static const String providers = '/providers';
  static const String vendor = '/vendor';
  static const String products = '/products';
  static const String product = '/product';
  static const String productOptions = '/product/options';
  static const String productQuantity = '/product/quantity';

  // Checkout
  static const String checkoutDelivery = '/checkout/delivery';
  static const String checkoutAddresses = '/checkout/addresses';
  static const String checkoutAddressNew = '/checkout/addresses/new';
  static const String checkoutDetails = '/checkout/details';
  static const String checkoutCoupon = '/checkout/coupon';
  static const String checkoutQuote = '/checkout/quote';
  static const String checkoutReview = '/checkout/review';
  static const String checkoutSuccess = '/checkout/success';

  // Orders
  static const String order = '/order';
  static const String orderCancel = '/order/cancel';
  static const String orderOffer = '/order/offer';
  static const String orderTracking = '/order/tracking';
  static const String orderReceipt = '/order/receipt';
  static const String orderRate = '/order/rate';
  static const String orderShare = '/order/share';
  static const String publicTracking = '/track';

  // Account
  static const String editProfile = '/account/profile';
  static const String addresses = '/account/addresses';
  static const String addressForm = '/account/addresses/form';
  static const String vendorApplication = '/account/vendor-application';
  static const String support = '/account/support';

  // Driver
  static const String driverLogin = '/driver/login';
  static const String driverHome = '/driver';
  static const String driverOrder = '/driver/order';
  static const String driverProfile = '/driver/profile';
  static const String driverNotifications = '/driver/notifications';
}
