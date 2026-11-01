import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../models/api/paged.dart';
import '../../models/masar/masar_models.dart';
import '../../models/requests/vendor_application_request.dart';

/// Public catalog: categories, vendors, products, vendor applications.
class CatalogService {
  CatalogService(this._client);

  final ApiClient _client;

  Future<List<Category>> categories({int? vendorId, String? kind}) =>
      _client.data<List<Category>>(
        HttpMethod.get,
        ApiEndpoints.categories,
        query: {
          if (vendorId != null) ApiQuery.vendor: vendorId,
          if (kind != null) ApiQuery.kind: kind,
        },
        parse: (data) => ApiClient.parseList(data, Category.fromJson),
      );

  Future<Paged<Vendor>> vendors({
    double? lat,
    double? lng,
    String? category,
    bool? openNow,
    int? page,
    int? perPage,
  }) =>
      _client.page<Vendor>(
        ApiEndpoints.vendors,
        item: Vendor.fromJson,
        query: {
          if (lat != null) ApiQuery.lat: lat,
          if (lng != null) ApiQuery.lng: lng,
          if (category != null) ApiQuery.category: category,
          if (openNow != null) ApiQuery.openNow: openNow ? 1 : 0,
          if (page != null) ApiQuery.page: page,
          if (perPage != null) ApiQuery.perPage: perPage,
        },
      );

  Future<Vendor> vendor(int id) => _client.data<Vendor>(
        HttpMethod.get,
        ApiEndpoints.vendor(id),
        parse: (data) => ApiClient.parseObject(data, Vendor.fromJson),
      );

  Future<Paged<Product>> products({
    int? categoryId,
    int? vendorId,
    String? kind,
    String? search,
    int? page,
    int? perPage,
  }) =>
      _client.page<Product>(
        ApiEndpoints.products,
        item: Product.fromJson,
        query: {
          if (categoryId != null) ApiQuery.category: categoryId,
          if (vendorId != null) ApiQuery.vendor: vendorId,
          if (kind != null) ApiQuery.kind: kind,
          if (search != null && search.isNotEmpty) ApiQuery.search: search,
          if (page != null) ApiQuery.page: page,
          if (perPage != null) ApiQuery.perPage: perPage,
        },
      );

  Future<Product> product(int id) => _client.data<Product>(
        HttpMethod.get,
        ApiEndpoints.product(id),
        parse: (data) => ApiClient.parseObject(data, Product.fromJson),
      );

  Future<VendorApplication> applyAsVendor(VendorApplicationRequest request) =>
      _client.data<VendorApplication>(
        HttpMethod.post,
        ApiEndpoints.vendorApplications,
        body: request.toJson(),
        parse: (data) =>
            ApiClient.parseObject(data, VendorApplication.fromJson),
      );
}
