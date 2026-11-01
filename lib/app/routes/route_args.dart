/// Typed arguments passed with [Get.toNamed].
class ProductsArgs {
  const ProductsArgs({this.categoryId, this.vendorId, required this.title});

  final int? categoryId;
  final int? vendorId;
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
