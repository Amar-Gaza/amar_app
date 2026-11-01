import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/api/paged.dart';
import '../../models/masar/masar_models.dart';

/// Notification inbox. Customer and driver share the same shape under
/// different base paths, so each app gets its own instance.
class NotificationService {
  NotificationService(this._client, this._base);

  NotificationService.customer(ApiClient client)
      : this(client, ApiEndpoints.notifications);

  NotificationService.driver(ApiClient client)
      : this(client, ApiEndpoints.driverNotifications);

  final ApiClient _client;
  final String _base;

  Future<Paged<AppNotification>> list({
    bool? unread,
    int? page,
    int? perPage,
  }) =>
      _client.page<AppNotification>(
        _base,
        item: AppNotification.fromJson,
        query: {
          if (unread != null) ApiQuery.unread: unread ? 1 : 0,
          if (page != null) ApiQuery.page: page,
          if (perPage != null) ApiQuery.perPage: perPage,
        },
      );

  /// Returns how many notifications were marked as read.
  Future<int> readAll() => _client.data<int>(
        HttpMethod.post,
        ApiEndpoints.readAll(_base),
        parse: (data) => ((data! as Map)['marked'] as num).toInt(),
      );

  Future<AppNotification> markOpened(int id) => _client.data<AppNotification>(
        HttpMethod.post,
        ApiEndpoints.opened(_base, id),
        parse: (data) => ApiClient.parseObject(data, AppNotification.fromJson),
      );
}
