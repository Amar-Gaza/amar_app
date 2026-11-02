abstract final class ApiQuery {
  static const String app = 'app';
  static const String appUser = 'user';
  static const String appDriver = 'driver';
  static const String perPage = 'per_page';
  static const String page = 'page';
  static const String scope = 'scope';
  static const String unread = 'unread';
  static const String since = 'since';
  static const String period = 'period';
  static const String category = 'category';
  static const String vendor = 'vendor';
  static const String kind = 'kind';
  static const String search = 'q';
  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String openNow = 'open_now';
}

/// Keys of AppConfig.polling.
abstract final class PollKeys {
  static const String tracking = 'tracking_seconds';
  static const String events = 'events_seconds';
  static const String availableOrders = 'available_orders_seconds';
  static const String notifications = 'notifications_seconds';
}

/// Customer order actions from Order.available_actions.
abstract final class OrderActions {
  static const String cancel = 'cancel';
  static const String track = 'track';
  static const String rate = 'rate';
}

/// Offer.status values.
abstract final class OfferStatus {
  static const String sent = 'sent';
}

/// Driver NextAction.action values.
abstract final class DriverActions {
  static const String accept = 'accept';
  static const String transition = 'transition';
  static const String deliver = 'deliver';
}

/// NextAction.requires values.
abstract final class ActionRequires {
  static const String photo = 'photo';
  static const String otp = 'otp';
  static const String location = 'location';
}

/// AppConfig.delivery_confirmation values.
abstract final class DeliveryConfirmation {
  static const String photo = 'photo';
  static const String otp = 'otp';
}

/// Vehicle types accepted by PUT /driver/me.
abstract final class VehicleTypes {
  static const List<String> all = [
    'motorcycle',
    'car',
    'bicycle',
    'van',
    'tuk_tuk',
    'on_foot',
  ];
}

/// Module keys from AppConfig.modules.
abstract final class ApiModules {
  static const String attachments = 'attachments';
  static const String coupons = 'coupons';
  static const String catalog = 'catalog';
  static const String vendors = 'vendors';
  static const String publicTracking = 'public_tracking';
}

/// Payment method keys from AppConfig.payment_methods.
abstract final class PaymentMethods {
  static const String cashOnDelivery = 'cash_on_delivery';
  static const String bankTransfer = 'bank_transfer';
}

/// Allowed values for `scope` on GET /orders.
abstract final class OrderScope {
  static const String active = 'active';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
}

/// Allowed values for `period` on GET /driver/earnings.
abstract final class EarningsPeriod {
  static const String day = 'day';
  static const String week = 'week';
  static const String month = 'month';
}

/// Response meta keys of paginated lists.
abstract final class ApiMeta {
  static const String page = 'page';
  static const String perPage = 'per_page';
  static const String total = 'total';
  static const String lastPage = 'last_page';
}

abstract final class ApiBody {
  static const String phone = 'phone';
  static const String code = 'code';
  static const String name = 'name';
  static const String deviceName = 'device_name';
  static const String locale = 'locale';
  static const String avatarUploadId = 'avatar_upload_id';
  static const String token = 'token';
  static const String password = 'password';
  static const String isOnline = 'is_online';
  static const String vehicleType = 'vehicle_type';
  static const String couponCode = 'code';
  static const String vendorId = 'vendor_id';
  static const String offerId = 'offer_id';
  static const String quoteId = 'quote_id';
  static const String uploadId = 'upload_id';
  static const String reason = 'reason';
  static const String file = 'file';
  static const String purpose = 'purpose';
}

abstract final class ApiExtra {
  static const String idempotent = 'idempotent';
  static const String skipAuth = 'skip_auth';

  /// Forces the session whose token is attached (shared endpoints).
  static const String role = 'role';
}

abstract final class ApiErrorCodes {
  static const String unauthenticated = 'unauthenticated';
  static const String userBlocked = 'user_blocked';
  static const String otpInvalid = 'otp_invalid';
  static const String otpExpired = 'otp_expired';
  static const String validationFailed = 'validation_failed';
  static const String networkError = 'network_error';
  static const String timeout = 'timeout';
  static const String serverError = 'server_error';
  static const String quoteExpired = 'quote_expired';
  static const String quoteUsed = 'quote_used';
  static const String quoteChanged = 'quote_changed';
  static const String outOfZone = 'out_of_zone';
  static const String alreadyTaken = 'already_taken';
  static const String invalidTransition = 'invalid_transition';
  static const String cashLimitReached = 'cash_limit_reached';
  static const String maintenance = 'maintenance';
  static const String appUpdateRequired = 'app_update_required';
  static const String emptyResponse = 'empty_response';
  static const String missingProjectKey = 'missing_project_key';

  static bool isConnectivity(String code) =>
      code == networkError || code == timeout;

  static bool isUnavailable(String code) =>
      code == serverError || code == maintenance;
}

abstract final class ProductKinds {
  static const String product = 'product';
  static const String service = 'service';
}

abstract final class PriceModes {
  static const String inspection = 'inspection';
}

abstract final class OrderStatusKeys {
  static const String _servicePrefix = 'service_';
  static const String technicianOnWay = 'technician_on_way';
  static const String awaitingPayment = 'awaiting_payment';
  static const String quoteSent = 'sent';

  static bool isService(String key) =>
      key.startsWith(_servicePrefix) || key == technicianOnWay;
}
