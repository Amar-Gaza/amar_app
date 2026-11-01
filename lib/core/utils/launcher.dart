import 'package:url_launcher/url_launcher.dart';

/// Opens dialer, maps and web pages outside the app.
abstract final class Launcher {
  static Future<bool> call(String phone) =>
      launchUrl(Uri(scheme: 'tel', path: phone));

  static Future<bool> web(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  /// Directions to a point in the default maps app.
  static Future<bool> map(double lat, double lng) => launchUrl(
        Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'),
        mode: LaunchMode.externalApplication,
      );
}
