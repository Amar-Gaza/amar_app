import '../../data/models/masar/masar_models.dart';
import '../../l10n/app_localizations.dart';
import '../constants/api_query.dart';

/// Price text of a catalog item; inspection services have no fixed price.
abstract final class PriceLabel {
  static String of(Product item, AppLocalizations l10n) =>
      item.priceMode == PriceModes.inspection
          ? l10n.priceAfterInspection
          : item.price.formatted;
}
