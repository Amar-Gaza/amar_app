/// Keys and values Masar sends in a push's `message.data`.
/// Every value arrives as a string.
abstract final class PushKeys {
  static const String notificationId = 'notification_id';
  static const String event = 'event';
  static const String type = 'type';
  static const String orderId = 'order_id';
  static const String status = 'status';

  /// `type` of a nearby order offered to drivers.
  static const String orderAvailable = 'order.available';
}
