import 'dart:convert';
import 'dart:io';

/// Bot settings. Environment variables win over the env file, so a host
/// can configure the bot without shipping the file.
class BotConfig {
  const BotConfig({
    required this.telegramToken,
    required this.projectKey,
    required this.devMember,
    required this.baseUrl,
    required this.dataDir,
    this.geminiKey = '',
    this.geminiModel = defaultGeminiModel,
  });

  final String telegramToken;
  final String projectKey;
  final String devMember;
  final String baseUrl;
  final String dataDir;
  final String geminiKey;
  final String geminiModel;

  static const String defaultGeminiModel = 'gemini-2.5-flash';

  static const String defaultBaseUrl = 'https://masar.toldpath.com/api';

  static BotConfig load(String envPath) {
    final file = File(envPath);
    final fromFile = file.existsSync()
        ? Map<String, dynamic>.from(jsonDecode(file.readAsStringSync()) as Map)
        : <String, dynamic>{};

    String read(String key, [String fallback = '']) {
      final env = Platform.environment[key];
      if (env != null && env.isNotEmpty) return env;
      final value = fromFile[key];
      return value is String && value.isNotEmpty ? value : fallback;
    }

    final config = BotConfig(
      telegramToken: read('TELEGRAM_BOT_TOKEN'),
      projectKey: read('AMAR_PROJECT_KEY'),
      devMember: read('AMAR_DEV_MEMBER'),
      baseUrl: read('AMAR_BASE_URL', defaultBaseUrl),
      dataDir: read('BOT_DATA_DIR', 'data'),
      geminiKey: read('GEMINI_API_KEY'),
      geminiModel: read('GEMINI_MODEL', defaultGeminiModel),
    );
    if (config.telegramToken.isEmpty || config.projectKey.isEmpty) {
      throw StateError(
        'Missing TELEGRAM_BOT_TOKEN or AMAR_PROJECT_KEY ($envPath).',
      );
    }
    return config;
  }
}
