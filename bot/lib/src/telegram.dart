import 'http_json.dart';

/// Minimal Telegram Bot API client (long polling, plain-text messages).
class Telegram {
  Telegram(String token, this._http)
      : _base = 'https://api.telegram.org/bot$token';

  final String _base;
  final HttpJson _http;

  Future<Object?> _call(String method, Map<String, dynamic> body,
      {Duration timeout = const Duration(seconds: 30)}) async {
    final res = await _http.send('POST', Uri.parse('$_base/$method'),
        body: body, timeout: timeout);
    if (res.body['ok'] != true) {
      throw TelegramFailure(res.body['description']?.toString() ?? 'error');
    }
    return res.body['result'];
  }

  Future<List<Map<String, dynamic>>> getUpdates(int offset) async {
    final result = await _call(
      'getUpdates',
      {
        'offset': offset,
        'timeout': 50,
        'allowed_updates': ['message', 'callback_query'],
      },
      timeout: const Duration(seconds: 70),
    );
    return (result as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> send(int chatId, String text, {Map<String, dynamic>? markup}) =>
      _call('sendMessage', {
        'chat_id': chatId,
        'text': text,
        if (markup != null) 'reply_markup': markup,
      });

  Future<void> answer(String callbackId, [String? text]) =>
      _call('answerCallbackQuery', {
        'callback_query_id': callbackId,
        if (text != null) 'text': text,
      });

  // ---- keyboards ----

  static Map<String, dynamic> inline(List<List<(String, String)>> rows) => {
        'inline_keyboard': [
          for (final row in rows)
            [
              for (final (text, data) in row)
                {'text': text, 'callback_data': data},
            ],
        ],
      };

  static Map<String, dynamic> reply(List<List<String>> rows) => {
        'keyboard': [
          for (final row in rows)
            [
              for (final text in row) {'text': text}
            ],
        ],
        'resize_keyboard': true,
      };

  static Map<String, dynamic> requestContact(String label) => {
        'keyboard': [
          [
            {'text': label, 'request_contact': true},
          ],
        ],
        'resize_keyboard': true,
        'one_time_keyboard': true,
      };

  static Map<String, dynamic> requestLocation(String label, String back) => {
        'keyboard': [
          [
            {'text': label, 'request_location': true},
          ],
          [
            {'text': back},
          ],
        ],
        'resize_keyboard': true,
      };

  static const Map<String, dynamic> removeKeyboard = {'remove_keyboard': true};
}

class TelegramFailure implements Exception {
  const TelegramFailure(this.message);
  final String message;

  @override
  String toString() => 'TelegramFailure: $message';
}
