abstract final class DurationFormatter {
  static const int _secondsPerMinute = 60;
  static const int _pad = 2;

  static String clock(int totalSeconds) {
    final minutes = totalSeconds ~/ _secondsPerMinute;
    final seconds = totalSeconds % _secondsPerMinute;
    return '${minutes.toString().padLeft(_pad, '0')}:'
        '${seconds.toString().padLeft(_pad, '0')}';
  }
}
