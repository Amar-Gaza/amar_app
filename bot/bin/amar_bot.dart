import 'package:amar_bot/src/bot.dart';
import 'package:amar_bot/src/config.dart';
import 'package:amar_bot/src/geocoder.dart';
import 'package:amar_bot/src/http_json.dart';
import 'package:amar_bot/src/masar.dart';
import 'package:amar_bot/src/store.dart';
import 'package:amar_bot/src/telegram.dart';

/// Usage: dart run bin/amar_bot.dart [env/bot.json]
Future<void> main(List<String> args) async {
  final config = BotConfig.load(args.isEmpty ? 'env/bot.json' : args.first);
  final http = HttpJson();
  final bot = AmarBot(
    Telegram(config.telegramToken, http),
    Masar(config, http),
    SessionStore(config.dataDir),
    Geocoder(http),
  );
  await bot.run();
}
