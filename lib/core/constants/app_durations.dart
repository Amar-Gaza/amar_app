abstract final class AppDurations {
  static const Duration splashMin = Duration(milliseconds: 2200);
  static const Duration connect = Duration(seconds: 15);
  static const Duration receive = Duration(seconds: 30);
  static const Duration locationFix = Duration(seconds: 12);
  static const Duration locationGeocode = Duration(seconds: 8);
  static const Duration locationDebounce = Duration(milliseconds: 350);
  static const Duration addressLoad = Duration(seconds: 20);
  static const Duration tick = Duration(seconds: 1);
  static const Duration press = Duration(milliseconds: 120);
  static const Duration splashBar = Duration(seconds: 2);
  static const Duration splashPop = Duration(milliseconds: 800);
  static const Duration page = Duration(milliseconds: 500);
  static const Duration dot = Duration(milliseconds: 300);
  static const Duration mapPulse = Duration(milliseconds: 1600);
  static const Duration navSlide = Duration(milliseconds: 480);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration segment = Duration(milliseconds: 250);
  static const Duration blink = Duration(milliseconds: 700);
}