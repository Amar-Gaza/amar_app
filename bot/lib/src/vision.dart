import 'dart:convert';
import 'dart:io';

import 'http_json.dart';

/// What the model saw in a customer's photo of a job.
class Diagnosis {
  const Diagnosis({
    required this.relevant,
    required this.category,
    required this.seen,
    required this.problem,
    required this.severity,
    required this.technician,
    required this.materials,
    required this.inspectionReason,
    required this.tips,
    required this.questions,
  });

  final bool relevant;
  final String category;
  final String seen;
  final String problem;
  final String severity;
  final String technician;
  final List<String> materials;
  final String inspectionReason;
  final List<String> tips;
  final List<String> questions;

  factory Diagnosis.fromJson(Map<String, dynamic> j) {
    List<String> list(String key) => [
          for (final v in (j[key] as List? ?? const []))
            if (v.toString().trim().isNotEmpty) v.toString().trim(),
        ];
    String str(String key) => (j[key] ?? '').toString().trim();
    return Diagnosis(
      relevant: j['is_relevant'] != false,
      category: str('category'),
      seen: str('what_i_see'),
      problem: str('problem'),
      severity: str('severity'),
      technician: str('technician'),
      materials: list('materials'),
      inspectionReason: str('inspection_reason'),
      tips: list('tips'),
      questions: list('questions'),
    );
  }
}

class VisionFailure implements Exception {
  const VisionFailure(this.message);
  final String message;

  @override
  String toString() => 'VisionFailure: $message';
}

/// Looks at a photo with Gemini and returns a first diagnosis. Pricing
/// and the exact technician still need an on-site inspection.
class Vision {
  Vision(this._apiKey, this._model, this._http);

  final String _apiKey;
  final String _model;
  final HttpJson _http;

  bool get enabled => _apiKey.isNotEmpty;

  static const String _prompt = '''
أنت مساعد خبير في تطبيق "عمّار" لخدمات البيوت في غزة: شوادر وخيم، سباكة، كهرباء، طاقة شمسية، تكييف وتبريد، نجارة، ألمنيوم، دهان، بناء وترميم.
الزبون بعت صورة لمشكلة أو لشي بدو يعمله. حلّل الصورة بدقة وبصدق، وما تخترع تفاصيل مش ظاهرة.
السعر النهائي والفني بالضبط بيتحددوا بعد معاينة، فلا تعطِ أي سعر.
اكتب بالعربي بلهجة شامية بسيطة وودودة وجمل قصيرة.
رجّع JSON فقط بهالشكل:
{
  "is_relevant": true أو false (false إذا الصورة ما إلها علاقة بخدمة منزلية),
  "category": "واحدة من: شوادر وخيم، سباكة، كهرباء، طاقة شمسية، تكييف وتبريد، نجارة، ألمنيوم، دهان، بناء وترميم، أخرى",
  "what_i_see": "جملة وحدة عن شو ظاهر بالصورة",
  "problem": "المشكلة أو الشغل المطلوب بجملة أو جملتين",
  "severity": "بسيط أو متوسط أو عاجل",
  "technician": "نوع الفني المناسب",
  "materials": ["مواد متوقعة، 2 لـ 4 عناصر"],
  "inspection_reason": "ليش لازم معاينة لتحديد السعر، جملة وحدة",
  "tips": ["نصيحة أمان أو تصرف سريع لحد ما يوصل الفني، 1 لـ 2"],
  "questions": ["سؤال أو سؤالين بيساعدوا الفني قبل المعاينة"]
}''';

  Future<Diagnosis> analyze(List<int> image, {String? caption}) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '$_model:generateContent',
    );
    final res = await _http.send(
      'POST',
      uri,
      headers: {'x-goog-api-key': _apiKey},
      timeout: const Duration(seconds: 60),
      body: {
        'contents': [
          {
            'parts': [
              {'text': _prompt},
              if (caption != null && caption.isNotEmpty)
                {'text': 'تعليق الزبون على الصورة: $caption'},
              {
                'inline_data': {
                  'mime_type': 'image/jpeg',
                  'data': base64Encode(image),
                },
              },
            ],
          },
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
          'temperature': 0.3,
        },
      },
    );
    if (res.status != 200) {
      final error = res.body['error'];
      throw VisionFailure(
        error is Map ? '${res.status} ${error['message']}' : '${res.status}',
      );
    }
    final candidates = res.body['candidates'] as List? ?? const [];
    final content = candidates.isEmpty
        ? null
        : (candidates.first as Map)['content'] as Map?;
    final parts = content?['parts'] as List? ?? const [];
    final text = parts.map((p) => (p as Map)['text'] ?? '').join();
    if (text.isEmpty) throw const VisionFailure('empty reply');
    try {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      return Diagnosis.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(text.substring(start, end + 1)) as Map,
        ),
      );
    } on Object {
      throw const VisionFailure('invalid json');
    }
  }

  /// Downloads a Telegram file by id.
  Future<List<int>> telegramFile(String token, String fileId) async {
    final meta = await _http.send(
      'POST',
      Uri.parse('https://api.telegram.org/bot$token/getFile'),
      body: {'file_id': fileId},
    );
    final path = (meta.body['result'] as Map?)?['file_path'] as String?;
    if (path == null) throw const VisionFailure('file not found');
    final client = HttpClient();
    try {
      final req = await client
          .getUrl(Uri.parse('https://api.telegram.org/file/bot$token/$path'));
      final res = await req.close();
      final bytes = <int>[];
      await for (final chunk in res) {
        bytes.addAll(chunk);
      }
      return bytes;
    } finally {
      client.close(force: true);
    }
  }
}
