import 'package:get/get.dart';

import '../../presentation/screens/auth/otp/otp_screen.dart';
import '../../presentation/screens/account/addresses_screen.dart';
import '../../presentation/screens/account/edit_profile_screen.dart';
import '../../presentation/screens/account/support_screen.dart';
import '../../presentation/screens/account/vendor_application_screen.dart';
import '../../presentation/screens/catalog/categories_screen.dart';
import '../../presentation/screens/driver/driver_login_screen.dart';
import '../../presentation/screens/driver/driver_notifications_screen.dart';
import '../../presentation/screens/driver/driver_order_screen.dart';
import '../../presentation/screens/driver/driver_profile_screen.dart';
import '../../presentation/screens/driver/driver_shell_screen.dart';
import '../../presentation/screens/orders/cancel_order_screen.dart';
import '../../presentation/screens/orders/offer_screen.dart';
import '../../presentation/screens/orders/order_details_screen.dart';
import '../../presentation/screens/orders/public_tracking_screen.dart';
import '../../presentation/screens/orders/rate_order_screen.dart';
import '../../presentation/screens/orders/receipt_screen.dart';
import '../../presentation/screens/orders/share_link_screen.dart';
import '../../presentation/screens/orders/tracking_screen.dart';
import '../../presentation/screens/checkout/address_form_screen.dart';
import '../../presentation/screens/checkout/address_picker_screen.dart';
import '../../presentation/screens/checkout/cart_screen.dart';
import '../../presentation/screens/checkout/coupon_screen.dart';
import '../../presentation/screens/checkout/delivery_screen.dart';
import '../../presentation/screens/checkout/checkout_details_screen.dart';
import '../../presentation/screens/checkout/order_success_screen.dart';
import '../../presentation/screens/checkout/quote_screen.dart';
import '../../presentation/screens/checkout/review_screen.dart';
import '../../presentation/screens/catalog/product_details_screen.dart';
import '../../presentation/screens/catalog/product_options_screen.dart';
import '../../presentation/screens/catalog/product_quantity_screen.dart';
import '../../presentation/screens/catalog/products_screen.dart';
import '../../presentation/screens/catalog/search_screen.dart';
import '../../presentation/screens/catalog/vendor_details_screen.dart';
import '../../presentation/screens/catalog/vendors_screen.dart';
import '../../presentation/screens/auth/phone/phone_screen.dart';
import '../../presentation/screens/auth/profile/profile_setup_screen.dart';
import '../../presentation/screens/customer/shell/customer_shell_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../bindings/account_binding.dart';
import '../bindings/catalog_binding.dart';
import '../bindings/checkout_binding.dart';
import '../bindings/customer_binding.dart';
import '../bindings/driver_binding.dart';
import '../bindings/orders_binding.dart';
import 'app_routes.dart';
import 'middleware/customer_auth_middleware.dart';
import 'middleware/driver_auth_middleware.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage<void>(
      name: AppRoutes.splash,
      page: SplashScreen.new,
      binding: SplashBinding(),
    ),
    GetPage<void>(name: AppRoutes.onboarding, page: OnboardingScreen.new),
    GetPage<void>(
      name: AppRoutes.phone,
      page: PhoneScreen.new,
      binding: AuthBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.otp,
      page: OtpScreen.new,
      binding: AuthBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.profile,
      page: ProfileSetupScreen.new,
      binding: ProfileSetupBinding(),
      middlewares: [CustomerAuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.home,
      page: CustomerShellScreen.new,
      binding: HomeBinding(),
      middlewares: [CustomerAuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.search,
      page: SearchScreen.new,
      binding: SearchBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.categories,
      page: CategoriesScreen.new,
      binding: CategoriesBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.vendors,
      page: VendorsScreen.new,
      binding: VendorsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.vendor,
      page: VendorDetailsScreen.new,
      binding: VendorDetailsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.products,
      page: ProductsScreen.new,
      binding: ProductsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.product,
      page: ProductDetailsScreen.new,
      binding: ProductBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.productOptions,
      page: ProductOptionsScreen.new,
    ),
    GetPage<void>(
      name: AppRoutes.productQuantity,
      page: ProductQuantityScreen.new,
    ),
    GetPage<void>(
      name: AppRoutes.cart,
      page: CartScreen.new,
      binding: CheckoutBinding(),
      middlewares: [CustomerAuthMiddleware()],
    ),
    GetPage<void>(name: AppRoutes.checkoutDelivery, page: DeliveryScreen.new),
    GetPage<void>(
      name: AppRoutes.checkoutAddresses,
      page: AddressPickerScreen.new,
    ),
    GetPage<void>(
      name: AppRoutes.checkoutAddressNew,
      page: AddressFormScreen.new,
      binding: AddressFormBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.checkoutDetails,
      page: CheckoutDetailsScreen.new,
    ),
    GetPage<void>(name: AppRoutes.checkoutCoupon, page: CouponScreen.new),
    GetPage<void>(name: AppRoutes.checkoutQuote, page: QuoteScreen.new),
    GetPage<void>(name: AppRoutes.checkoutReview, page: ReviewScreen.new),
    GetPage<void>(
      name: AppRoutes.checkoutSuccess,
      page: OrderSuccessScreen.new,
    ),
    GetPage<void>(
      name: AppRoutes.order,
      page: OrderDetailsScreen.new,
      binding: OrderDetailsBinding(),
      middlewares: [CustomerAuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.orderCancel,
      page: CancelOrderScreen.new,
      binding: OrderActionsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.orderOffer,
      page: OfferScreen.new,
      binding: OrderActionsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.orderTracking,
      page: TrackingScreen.new,
      binding: TrackingBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.orderReceipt,
      page: ReceiptScreen.new,
      binding: OrderActionsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.orderRate,
      page: RateOrderScreen.new,
      binding: OrderActionsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.orderShare,
      page: ShareLinkScreen.new,
      binding: OrderActionsBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.publicTracking,
      page: PublicTrackingScreen.new,
      binding: PublicTrackingBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.editProfile,
      page: EditProfileScreen.new,
      binding: EditProfileBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.addresses,
      page: AddressesScreen.new,
      binding: AddressesBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.addressForm,
      page: AddressFormScreen.new,
      binding: AddressFormBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.vendorApplication,
      page: VendorApplicationScreen.new,
      binding: VendorApplicationBinding(),
    ),
    GetPage<void>(name: AppRoutes.support, page: SupportScreen.new),
    GetPage<void>(name: AppRoutes.driverLogin, page: DriverLoginScreen.new),
    GetPage<void>(
      name: AppRoutes.driverHome,
      page: DriverShellScreen.new,
      binding: DriverShellBinding(),
      middlewares: [DriverAuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.driverOrder,
      page: DriverOrderScreen.new,
      binding: DriverOrderBinding(),
      middlewares: [DriverAuthMiddleware()],
    ),
    GetPage<void>(
      name: AppRoutes.driverProfile,
      page: DriverProfileScreen.new,
      binding: DriverProfileBinding(),
    ),
    GetPage<void>(
      name: AppRoutes.driverNotifications,
      page: DriverNotificationsScreen.new,
      binding: DriverNotificationsBinding(),
    ),
  ];
}
