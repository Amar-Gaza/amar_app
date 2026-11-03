import '../../l10n/app_localizations.dart';
import '../constants/api_query.dart';

/// Display name of a driver vehicle type; unknown types show as sent.
abstract final class VehicleLabel {
  static String of(String type, AppLocalizations l10n) => switch (type) {
        VehicleTypes.motorcycle => l10n.driverVehicleMotorcycle,
        VehicleTypes.car => l10n.driverVehicleCar,
        VehicleTypes.bicycle => l10n.driverVehicleBicycle,
        VehicleTypes.van => l10n.driverVehicleVan,
        VehicleTypes.tukTuk => l10n.driverVehicleTukTuk,
        VehicleTypes.onFoot => l10n.driverVehicleOnFoot,
        _ => type,
      };
}
