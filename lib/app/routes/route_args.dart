import '../../data/models/catalog/picked_location.dart';

/// Typed arguments passed with Get.toNamed.
class ProductsArgs {
  const ProductsArgs({
    this.categoryIds = const [],
    this.vendorId,
    required this.title,
  });

  final List<int> categoryIds;
  final int? vendorId;
  final String title;
}

class ProvidersArgs {
  const ProvidersArgs({
    required this.kind,
    required this.title,
    this.query,
  });

  final String kind;
  final String title;
  final String? query;
}

class VendorsArgs {
  const VendorsArgs({
    this.category,
  });

  final String? category;
}

class ProductArgs {
  const ProductArgs(this.productId);

  final int productId;

  String get tag => productId.toString();
}

class AddressFormArgs {
  const AddressFormArgs({
    this.point,
    this.useCurrentLocation = false,
  });

  final PickedLocation? point;
  final bool useCurrentLocation;
}

class AiSearchArgs {
  const AiSearchArgs({
    required this.query,
    this.kind,
  });

  final String query;
  final String? kind;
}
