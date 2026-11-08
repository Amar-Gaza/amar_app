/// Local, user-initiated address navigation. This never permits an LLM to
/// silently save or change a user's delivery address.
enum AiAddressCommand { add, select, map }

AiAddressCommand? parseAiAddressCommand(String text) {
  final q = text.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  if (q.isEmpty) return null;
  // A mixed product-order request must remain an order, not be stolen by the
  // trailing phrase 'then choose an address'.
  if (RegExp(r'(?:بدي\s+(?:اطلب|أطلب|اشتري|أشتري)|اطلبلي|أطلبلي|جهزلي\s+طلب|order\s+(?:a|an|the)|want\s+to\s+(?:order|buy))',
      caseSensitive: false).hasMatch(q) &&
      RegExp(r'بعدها|بعدين|ثم|then|afterwards|after that',
        caseSensitive: false).hasMatch(q)) {
    return null;
  }
  if (q.contains('?') || q.contains('؟') ||
      RegExp(r'^(?:شو|ايش|إيش|كيف|ليش|هل|وين|what|why|how|when)\s', caseSensitive: false).hasMatch(q)) {
    return null;
  }
  if (RegExp(r'(?:لا|مش|بدون|ما بدي|لازم ما)\s+(?:تضيف|تضيفلي|تحفظ|تفتح|تروح|تنقل|اضيف|اختار|تختار)', caseSensitive: false).hasMatch(q)) {
    return null;
  }

  final mentionsAddress = RegExp(
    r'عنوان|عناوين|العناوين|العنوان|address|addresses|location|موقع|مكاني|الخريطة|خريطة|ماب|map',
    caseSensitive: false,
  ).hasMatch(q);
  if (!mentionsAddress) return null;
  // Business locations are catalog searches, not delivery-address edits.
  if (RegExp(r'(?:موقع|عنوان)\s+(?:شركة|محل|متجر|مؤسسة|مؤسسه|vendor|company|shop)',
    caseSensitive: false).hasMatch(q)) return null;

  // A question about an address is a chat question, not consent to navigate.
  if (RegExp(r'^(?:شو|ايش|إيش|ليش|لماذا|هل|كيف|what|why|how|is|can you explain)(?:\s|$)',
      caseSensitive: false).hasMatch(q)) {
    return null;
  }

  final request = RegExp(
    r'بدي|بدنا|عايز|محتاج|اريد|أريد|افتح|روح|وديني|وريني|اعرض|اختار|اختر|حدد|تحديد|اضف|أضف|ضيف|إضافة|اضافة|انشئ|أنشئ|سجل|احفظ|غير|غيّر|use|want|need|add|new|create|open|show|select|choose|pick|change|save',
    caseSensitive: false,
  );
  if (!request.hasMatch(q)) return null;

  final map = RegExp(r'الخريطة|خريطة|الماب| map\b|^map\b|على الخريط|على الماب|حدد موقع|تحديد موقع', caseSensitive: false);
  if (map.hasMatch(q)) return AiAddressCommand.map;

  final newAddress = RegExp(
    r'عنوان جديد|عنوان ثاني|إضافة عنوان|اضافة عنوان|ضيف عنوان|اضف عنوان|أضف عنوان|انشئ عنوان|أنشئ عنوان|يضيف عنوان|تضيف عنوان|سجل عنوان|احفظ عنوان|new address|add address|create address|another address',
    caseSensitive: false,
  );
  if (newAddress.hasMatch(q)) return AiAddressCommand.add;

  final choose = RegExp(
    r'اختار|اختر|اختيار|حدد|تحديد|غير|غيّر|شوف|اعرض|افتح|وريني|وديني|بدي|عناوين|choose|select|pick|show|open|change|my address|saved address',
    caseSensitive: false,
  );
  return choose.hasMatch(q) ? AiAddressCommand.select : null;
}

/// Language of the actual spoken response, not only the UI locale.
String aiSpeechLanguageFor(String text, {String fallback = 'ar'}) {
  final arCount = RegExp(r'[\u0621-\u064A]').allMatches(text).length;
  final enCount = RegExp(r'[a-zA-Z]').allMatches(text).length;
  if (arCount > enCount) return 'ar';
  if (enCount > arCount) return 'en';
  return fallback == 'en' ? 'en' : 'ar';
}
