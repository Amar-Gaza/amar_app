import '../masar/masar_models.dart';

/// A vendor listed with one of its items in a home section.
class ProviderEntry {
  const ProviderEntry({required this.vendor, required this.item});

  final Vendor vendor;
  final Product item;

  /// Keeps the vendors' order; a vendor without items of this kind is dropped.
  static List<ProviderEntry> build(List<Vendor> vendors, List<Product> items) {
    final firstByVendor = <int, Product>{};
    for (final item in items) {
      final vendorId = item.vendorId;
      if (vendorId != null) firstByVendor.putIfAbsent(vendorId, () => item);
    }
    return [
      for (final vendor in vendors)
        if (firstByVendor[vendor.id] case final item?)
          ProviderEntry(vendor: vendor, item: item),
    ];
  }
}
