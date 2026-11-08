import 'http_json.dart';

/// Reverse geocoding through OpenStreetMap Nominatim, so a dropoff gets the
/// same "city، neighborhood، street" label the app builds on the phone.
class Geocoder {
  Geocoder(this._http);

  final HttpJson _http;

  static const int labelMax = 60;

  /// Returns null when the lookup fails or finds nothing useful.
  Future<String?> label(double lat, double lng) async {
    try {
      final res = await _http.send(
        'GET',
        Uri.https('nominatim.openstreetmap.org', '/reverse', {
          'format': 'jsonv2',
          'lat': '$lat',
          'lon': '$lng',
          'zoom': '18',
          'addressdetails': '1',
          'accept-language': 'ar',
        }),
        headers: {'User-Agent': 'AmarTelegramBot/1.0'},
        timeout: const Duration(seconds: 8),
      );
      final address = res.body['address'];
      if (res.status != 200 || address is! Map) return null;
      String? pick(List<String> keys) => keys
          .map((k) => address[k])
          .whereType<String>()
          .map((v) => v.trim())
          .firstWhere((v) => v.isNotEmpty, orElse: () => '');
      final parts = <String>[];
      for (final part in [
        pick(['city', 'town', 'village', 'municipality', 'state_district']),
        pick(['suburb', 'neighbourhood', 'quarter', 'city_district']),
        pick(['road', 'pedestrian', 'square']),
        pick(['house_number']),
      ]) {
        if (part != null && part.isNotEmpty && !parts.contains(part)) {
          parts.add(part);
        }
      }
      if (parts.isEmpty) return null;
      return String.fromCharCodes(parts.join('، ').runes.take(labelMax));
    } catch (_) {
      return null;
    }
  }
}
