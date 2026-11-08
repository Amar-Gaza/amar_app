import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AiSpeechService {
  final SpeechToText _stt = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;
  bool _available = false;

  void Function(String)? _onStatus;
  void Function(String)? _onError;

  Future<bool> initialize({
    required void Function(String) onStatus,
    required void Function(String) onError,
  }) async {
    _onStatus = onStatus;
    _onError = onError;

    if (_initialized) return _available;

    _initialized = true;

    try {
      _available = await _stt.initialize(
        debugLogging: kDebugMode,
        onStatus: (status) {
          _onStatus?.call(status);
        },
        onError: (error) {
          if (kDebugMode) {
            debugPrint(
              'AMAR_STT: ${error.errorMsg}',
            );
          }

          _onError?.call(
            error.errorMsg.contains('timeout') ||
                    error.errorMsg.contains('no_match')
                ? 'speech_timeout'
                : 'speech_error',
          );
        },
      );

      return _available;
    } catch (_) {
      _initialized = false;
      _available = false;
      _onError?.call('speech_unavailable');
      return false;
    }
  }

  Future<void> listen({
    required String language,
    required void Function(
      SpeechRecognitionResult,
    ) onResult,
  }) async {
    if (!_available) {
      _onError?.call('speech_unavailable');
      return;
    }

    try {
      await _tts.stop();

      final locales = await _stt.locales();

      final matches = locales
          .where(
            (locale) => locale.localeId.toLowerCase().startsWith(
                  language.toLowerCase(),
                ),
          )
          .toList();

      if (language == 'ar' && matches.isEmpty) {
        _onError?.call(
          'speech_language_missing',
        );
        return;
      }

      final preferred = matches
          .where(
            (locale) =>
                locale.localeId.toLowerCase().replaceAll('_', '-') == 'ar-ps',
          )
          .toList();

      final locale = preferred.isNotEmpty
          ? preferred.first.localeId
          : (matches.isNotEmpty ? matches.first.localeId : null);

      if (kDebugMode) {
        debugPrint(
          'AMAR_STT_LOCALE: '
          '${locale ?? 'default'}',
        );
      }

      await _stt.listen(
        localeId: locale,
        listenFor: const Duration(seconds: 35),
        pauseFor: const Duration(seconds: 4),
        onResult: onResult,
      );
    } catch (_) {
      _onError?.call('speech_error');
    }
  }

  Future<void> stopListening() async {
    try {
      await _stt.stop();
    } catch (_) {}
  }

  Future<bool> speak(
    String text, {
    required String language,
  }) async {
    try {
      final available = await _tts.getLanguages;

      if (available is! List) return false;

      final options = available
          .whereType<String>()
          .where(
            (value) => value.toLowerCase().startsWith(
                  language.toLowerCase(),
                ),
          )
          .toList();

      if (options.isEmpty) return false;

      final target = options.first;

      await _tts.stop();
      await _tts.setLanguage(target);
      await _tts.setSpeechRate(0.48);
      await _tts.setVolume(1.0);
      await _tts.speak(text);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> detach() async {
    _onError = null;
    _onStatus = null;

    try {
      await _stt.cancel();
    } catch (_) {}

    await stopSpeaking();
  }
}
