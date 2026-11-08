/// A restricted, app-owned schema for interactive chat questions.
/// IDs and choice values are generated from server-verified records; the
/// language model cannot invent an executable form or API action.
abstract final class AiFormType {
  static const String single = 'single';
  static const String multi = 'multi';
  static const String integer = 'integer';
  static const String text = 'text';
}

class AiFormChoice {
  const AiFormChoice({required this.value, required this.label, this.detail});
  final String value;
  final String label;
  final String? detail;

  Map<String, dynamic> toJson() => {
    'value': value, 'label': label, 'detail': detail,
  };

  factory AiFormChoice.fromJson(Map<String, dynamic> json) => AiFormChoice(
    value: json['value'] as String,
    label: json['label'] as String,
    detail: json['detail'] as String?,
  );
}

class AiFormField {
  const AiFormField({
    required this.key,
    required this.label,
    required this.type,
    this.choices = const [],
    this.required = true,
    this.min = 1,
    this.max = 20,
    this.initialNumber,
    this.hint,
  });

  final String key;
  final String label;
  final String type;
  final List<AiFormChoice> choices;
  final bool required;
  final int min;
  final int max;
  final int? initialNumber;
  final String? hint;

  Map<String, dynamic> toJson() => {
    'key': key,
    'label': label,
    'type': type,
    'choices': choices.map((e) => e.toJson()).toList(),
    'required': required,
    'min': min,
    'max': max,
    'initial_number': initialNumber,
    'hint': hint,
  };

  factory AiFormField.fromJson(Map<String, dynamic> json) => AiFormField(
    key: json['key'] as String,
    label: json['label'] as String,
    type: json['type'] as String,
    choices: ((json['choices'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => AiFormChoice.fromJson(Map<String, dynamic>.from(e)))
        .take(30).toList(),
    required: json['required'] != false,
    min: (json['min'] as num?)?.toInt() ?? 1,
    max: (json['max'] as num?)?.toInt() ?? 20,
    initialNumber: (json['initial_number'] as num?)?.toInt(),
    hint: json['hint'] as String?,
  );
}

class AiChatForm {
  const AiChatForm({
    required this.id,
    required this.purpose,
    required this.title,
    required this.fields,
    this.submitLabel = 'متابعة',
    this.help,
  });

  final String id;
  final String purpose;
  final String title;
  final List<AiFormField> fields;
  final String submitLabel;
  final String? help;

  Map<String, dynamic> toJson() => {
    'id': id,
    'purpose': purpose,
    'title': title,
    'fields': fields.map((e) => e.toJson()).toList(),
    'submit_label': submitLabel,
    'help': help,
  };

  factory AiChatForm.fromJson(Map<String, dynamic> json) => AiChatForm(
    id: json['id'] as String,
    purpose: json['purpose'] as String,
    title: json['title'] as String,
    fields: ((json['fields'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => AiFormField.fromJson(Map<String, dynamic>.from(e)))
        .take(12).toList(),
    submitLabel: json['submit_label'] as String? ?? 'متابعة',
    help: json['help'] as String?,
  );

  /// Does not trust a form submission just because it came from our own UI.
  /// Returns field-specific validation errors or an empty map.
  Map<String, String> validate(Map<String, dynamic> answer) {
    final errors = <String, String>{};
    for (final f in fields) {
      final value = answer[f.key];
      if (f.type == AiFormType.single) {
        if (value == null || value == '') {
          if (f.required) errors[f.key] = 'اختار واحد من الخيارات';
        } else if (value is! String ||
            !f.choices.any((choice) => choice.value == value)) {
          errors[f.key] = 'الاختيار مش موجود ضمن الخيارات';
        }
      } else if (f.type == AiFormType.multi) {
        final values = value is List ? value : const [];
        if (f.required && values.isEmpty) {
          errors[f.key] = 'اختار خيار واحد على الأقل';
        } else if (values.length > f.choices.length ||
            values.length != values.toSet().length ||
            values.any((v) => v is! String ||
                !f.choices.any((choice) => choice.value == v))) {
          errors[f.key] = 'في اختيارات غير صالحة';
        }
      } else if (f.type == AiFormType.integer) {
        final number = value is int ? value : int.tryParse('$value');
        if (number == null || number < f.min || number > f.max) {
          errors[f.key] = 'اكتب عدد صحيح من ${f.min} إلى ${f.max}';
        }
      } else if (f.type == AiFormType.text) {
        final text = value is String ? value.trim() : '';
        if ((f.required && text.isEmpty) || text.length > f.max) {
          errors[f.key] = 'اكتب إجابة لا تتجاوز ${f.max} حرف';
        }
      } else {
        errors[f.key] = 'نوع الحقل غير مدعوم';
      }
    }
    return errors;
  }

  /// Human-readable summary in chat history (never secrets or payment data).
  String describe(Map<String, dynamic> answer) {
    final lines = <String>[];
    for (final f in fields) {
      final value = answer[f.key];
      if (value == null) continue;
      if (f.type == AiFormType.single) {
        final matching = f.choices.where((c) => c.value == value);
        if (matching.isNotEmpty) lines.add('${f.label}: ${matching.first.label}');
      } else if (f.type == AiFormType.multi) {
        final values = value is List ? value : const [];
        final labels = f.choices.where((c) => values.contains(c.value))
            .map((c) => c.label).join('، ');
        if (labels.isNotEmpty) lines.add('${f.label}: $labels');
      } else {
        lines.add('${f.label}: $value');
      }
    }
    return lines.join('\n');
  }
}
