# Amar · Dart models

Copy `lib/masar/masar_models.dart` into your Flutter app. No packages and no code generation are needed.
Download it again from the Developer Center after a new config version is published.

Parse a response like this:

```dart
final envelope = ApiEnvelope.fromJson(jsonDecode(body) as Map<String, dynamic>,
    (data) => Order.fromJson(Map<String, dynamic>.from(data as Map)));
```

انسخ الملف `lib/masar/masar_models.dart` إلى تطبيقك. لا يحتاج أي حزمة أو توليد كود.
أعد تنزيله من مركز المطوّرين بعد نشر إصدار إعدادات جديد.