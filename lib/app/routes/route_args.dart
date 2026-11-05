import '../../data/models/catalog/picked_location.dart';

/// Typed arguments passed with [Get.toNamed].
class ProductsArgs {
  const ProductsArgs({
    this.categoryIds = const [],
    this.vendorId,
    required this.title,
  });

  /// A unified category can span several server ids (one per vendor).
  final List<int> categoryIds;
  final int? vendorId;
  final String title;
}

/// Kind of the providers shown by the "view all" list.
class ProvidersArgs {
  const ProvidersArgs({
    required this.kind,
    required this.title,
  });

  final String kind;
  final String title;
}

class VendorsArgs {
  const VendorsArgs({this.category});

  final String? category;
}

/// Product id; also the tag of the shared [ProductController].
class ProductArgs {
  const ProductArgs(this.productId);

  final int productId;

  String get tag => productId.toString();
}

/// Initial draft for a new delivery address; saved Address arguments still edit.
class AddressFormArgs {
  const AddressFormArgs({
    this.point,
    this.useCurrentLocation = false,
  });

  final PickedLocation? point;
  final bool useCurrentLocation;
}