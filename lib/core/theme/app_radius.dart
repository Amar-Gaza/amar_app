import 'package:flutter/painting.dart';

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 14;
  static const double segmentInner = 12;
  static const double button = 16;
  static const double lg = 18;
  static const double card = 22;
  static const double xl = 28;
  static const double illustration = 32;
  static const double pill = 999;
  static const double sheet = 24;
  static const double hero = 30;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius segmentInnerAll =
      BorderRadius.all(Radius.circular(segmentInner));
  static const BorderRadius buttonAll =
      BorderRadius.all(Radius.circular(button));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius illustrationAll =
      BorderRadius.all(Radius.circular(illustration));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius sheetAll = BorderRadius.all(Radius.circular(sheet));
  static const BorderRadius heroAll = BorderRadius.all(Radius.circular(hero));
}
