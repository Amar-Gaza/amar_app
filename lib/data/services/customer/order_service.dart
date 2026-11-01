import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/api/cancel_reason.dart';
import '../../models/api/paged.dart';
import '../../models/masar/masar_models.dart';
import '../../models/requests/place_order_request.dart';
import '../../models/requests/quote_request.dart';
import '../../models/requests/rate_order_request.dart';

/// Customer orders: quote → place → follow → offer → rate.
class OrderService {
  OrderService(this._client);

  final ApiClient _client;

  Order _order(Object? data) => ApiClient.parseObject(data, Order.fromJson);
  Offer _offer(Object? data) => ApiClient.parseObject(data, Offer.fromJson);

  Future<Paged<OrderSummary>> list({String? scope, int? page, int? perPage}) =>
      _client.page<OrderSummary>(
        ApiEndpoints.orders,
        item: OrderSummary.fromJson,
        query: {
          if (scope != null) ApiQuery.scope: scope,
          if (page != null) ApiQuery.page: page,
          if (perPage != null) ApiQuery.perPage: perPage,
        },
      );

  Future<Order> show(int id) => _client.data<Order>(
        HttpMethod.get,
        ApiEndpoints.order(id),
        parse: _order,
      );

  Future<Quote> quote(QuoteRequest request) => _client.data<Quote>(
        HttpMethod.post,
        ApiEndpoints.quote,
        body: request.toJson(),
        parse: (data) => ApiClient.parseObject(data, Quote.fromJson),
      );

  /// Reuse the same [idempotencyKey] when retrying the same checkout so
  /// the server never creates the order twice.
  Future<Order> place(
    PlaceOrderRequest request, {
    required String idempotencyKey,
  }) =>
      _client.data<Order>(
        HttpMethod.post,
        ApiEndpoints.orders,
        body: request.toJson(),
        idempotencyKey: idempotencyKey,
        parse: _order,
      );

  Future<CouponCheck> validateCoupon(String code, {int? vendorId}) =>
      _client.data<CouponCheck>(
        HttpMethod.post,
        ApiEndpoints.validateCoupon,
        body: {
          ApiBody.couponCode: code,
          if (vendorId != null) ApiBody.vendorId: vendorId,
        },
        parse: (data) => ApiClient.parseObject(data, CouponCheck.fromJson),
      );

  Future<List<CancelReason>> cancelReasons() =>
      _client.data<List<CancelReason>>(
        HttpMethod.get,
        ApiEndpoints.cancelReasons,
        parse: (data) => ApiClient.parseList(data, CancelReason.fromJson),
      );

  Future<Order> cancel(int id, {required String reason, String? note}) =>
      _client.data<Order>(
        HttpMethod.post,
        ApiEndpoints.orderCancel(id),
        body: {
          ApiBody.reason: reason,
          if (note != null) 'note': note,
        },
        parse: _order,
      );

  /// Events after [since] (an event id or timestamp from the last poll).
  Future<List<OrderEvent>> events(int id, {String? since}) =>
      _client.data<List<OrderEvent>>(
        HttpMethod.get,
        ApiEndpoints.orderEvents(id),
        query: {if (since != null) ApiQuery.since: since},
        parse: (data) => ApiClient.parseList(data, OrderEvent.fromJson),
      );

  Future<Offer> offer(int id) => _client.data<Offer>(
        HttpMethod.get,
        ApiEndpoints.orderOffer(id),
        parse: _offer,
      );

  Future<Offer> approveOffer(int id, {required int offerId}) =>
      _client.data<Offer>(
        HttpMethod.post,
        ApiEndpoints.orderOfferApprove(id),
        body: {ApiBody.offerId: offerId},
        idempotent: true,
        parse: _offer,
      );

  Future<Offer> rejectOffer(int id, {int? offerId, String? reason}) =>
      _client.data<Offer>(
        HttpMethod.post,
        ApiEndpoints.orderOfferReject(id),
        body: {
          if (offerId != null) ApiBody.offerId: offerId,
          if (reason != null) ApiBody.reason: reason,
        },
        parse: _offer,
      );

  Future<Order> rate(int id, RateOrderRequest request) => _client.data<Order>(
        HttpMethod.post,
        ApiEndpoints.orderRate(id),
        body: request.toJson(),
        parse: _order,
      );

  Future<Receipt> receipt(int id) => _client.data<Receipt>(
        HttpMethod.get,
        ApiEndpoints.orderReceipt(id),
        parse: (data) => ApiClient.parseObject(data, Receipt.fromJson),
      );

  Future<Tracking> tracking(int id) => _client.data<Tracking>(
        HttpMethod.get,
        ApiEndpoints.orderTracking(id),
        parse: (data) => ApiClient.parseObject(data, Tracking.fromJson),
      );

  Future<ShareLink> createShareLink(int id) => _client.data<ShareLink>(
        HttpMethod.post,
        ApiEndpoints.orderShareLink(id),
        parse: (data) => ApiClient.parseObject(data, ShareLink.fromJson),
      );

  Future<void> revokeShareLink(int id) =>
      _client.command(HttpMethod.delete, ApiEndpoints.orderShareLink(id));

  /// Public tracking page data; works without a session.
  Future<PublicTracking> publicTracking(String token) =>
      _client.data<PublicTracking>(
        HttpMethod.get,
        ApiEndpoints.publicTracking(token),
        skipAuth: true,
        parse: (data) => ApiClient.parseObject(data, PublicTracking.fromJson),
      );

  /// Sandbox projects only: moves the order to its next status.
  Future<Order> sandboxAdvance(int id) => _client.data<Order>(
        HttpMethod.post,
        ApiEndpoints.sandboxAdvance(id),
        parse: _order,
      );
}
