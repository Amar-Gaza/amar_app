import 'package:flutter/widgets.dart';

class AiLabels {
  AiLabels(BuildContext context)
      : isArabic = Localizations.localeOf(context).languageCode == 'ar';

  final bool isArabic;

  String _tr(String ar, String en) => isArabic ? ar : en;

  String get title => _tr(
        'مساعد عَمّار الذكي',
        'Amar AI Assistant',
      );

  String get welcome => _tr(
        'أهلاً! اسألني أي سؤال، أو اطلب مني البحث عن المنتجات والخدمات والشركات المتوفرة فعلياً في عَمّار.',
        'Hello! Ask me anything or search real products, services and companies on Amar.',
      );

  String get hint => _tr(
        'احكي أو اكتب رسالتك...',
        'Type or speak your message...',
      );

  String get send => _tr('إرسال', 'Send');

  String get listen => _tr(
        'اضغط للتحدث',
        'Tap to speak',
      );

  String get stopListen => _tr(
        'إيقاف التسجيل',
        'Stop recording',
      );

  String get listening => _tr(
        'عم بسمعك...',
        'Listening...',
      );

  String get clear => _tr(
        'مسح المحادثة',
        'Clear chat',
      );

  String get speakerOn => _tr(
        'إيقاف الرد الصوتي',
        'Turn off spoken replies',
      );

  String get speakerOff => _tr(
        'تفعيل الرد الصوتي',
        'Turn on spoken replies',
      );

  String get tryAgain => _tr(
        'حاول مرة ثانية',
        'Try again',
      );

  String get more => _tr(
        'افتح التفاصيل',
        'Open details',
      );

  String get noSpeech => _tr(
        'ما سمعت كلام واضح. جرّب ميكروفون الهاتف أو فعّل ميكروفون الكمبيوتر بالمحاكي.',
        'No speech detected; check the microphone.',
      );

  String get missingLanguage => _tr(
        'التعرف على الكلام بالعربي غير متوفر على هذا الجهاز. ثبّت اللغة العربية لخدمة Google أو جرّب هاتف حقيقي.',
        'Arabic speech recognition is unavailable on this device.',
      );

  String get wrongLanguage => _tr(
        'طلع نص بلغة مختلفة. جرّب الكلام بوضوح أو صحّح النص قبل الإرسال.',
        'Speech was recognized in the wrong language.',
      );

  String get unavailable => _tr(
        'المساعد مش متاح حالياً؛ جرّب مرة ثانية.',
        'Assistant unavailable, please try again.',
      );

  String get login => _tr(
        'سجّل دخولك في عَمّار أولاً.',
        'Please sign in to Amar.',
      );

  String get noVoice => _tr(
        'ما في صوت عربي مثبت على الجهاز؛ الرد المكتوب بيضل شغّال.',
        'No voice installed for this language; text remains available.',
      );

  String get disclaimer => _tr(
        'العروض والأسعار من سيرفر عَمّار. تأكيد الطلب والدفع بيدك فقط.',
        'Catalog data comes from Amar. Only you confirm orders and payments.',
      );
}
