import 'vision.dart';

/// Every message the customer sees, in one place.
abstract final class T {
  // Menu buttons (also matched as incoming text).
  static const newOrder = '🛒 طلب جديد';
  static const myOrders = '📦 طلباتي';
  static const myCart = '🧺 سلتي';
  static const logout = '🚪 تسجيل خروج';
  static const back = '↩️ رجوع';

  static const shareContact = '📱 مشاركة رقمي';
  static const sendLocation = '📍 إرسال موقعي';

  static const welcome = 'أهلاً بك في عمّار 👋\n'
      'من هنا بتقدر تطلب بدون ما تفتح التطبيق.\n\n'
      'أول إشي، اضغط «مشاركة رقمي» تحت عشان نسجل دخولك.';
  static const welcomeBack = 'أهلاً فيك من جديد 👋 شو حابب تعمل؟';
  static const contactNotYours =
      'لازم تشارك رقمك انت، استخدم زر «مشاركة رقمي».';
  static String otpSent(String phone) =>
      'بعتنالك كود تحقق برسالة على الرقم $phone\nاكتب الكود هون:';
  static const otpWrong = 'الكود غلط أو انتهى، جرب مرة ثانية أو ابعت /start';
  static const signedIn = 'تم تسجيل الدخول ✅';
  static const loginFirst = 'لازم تسجل دخول أول، ابعت /start';
  static const sessionExpired = 'انتهت الجلسة، ابعت /start وسجل دخول من جديد.';
  static const loggedOut = 'تم تسجيل الخروج. لترجع ابعت /start';

  static const pickVendor = 'اختار المتجر:';
  static const noVendors = 'ما في متاجر متاحة هلأ.';
  static String pickProduct(String vendor) => 'منتجات $vendor، اختار منتج:';
  static const noProducts = 'ما في منتجات متاحة بهاد المتجر هلأ.';
  static String pickQty(String product, String price) =>
      '$product\nالسعر: $price\n\nكم القطعة/العدد؟';
  static const otherVendorReset =
      'سلتك كانت من متجر ثاني، فضيناها وبلشنا سلة جديدة.';
  static const addMore = '➕ أضف منتج';
  static const checkout = '✅ إتمام الطلب';
  static const clearCart = '🗑 إفراغ السلة';
  static const cartEmpty = 'سلتك فاضية. اضغط «طلب جديد» لتبلش.';
  static const cartCleared = 'فضينا السلة.';
  static String cart(String vendor, String lines) =>
      '🧺 سلتك من $vendor:\n$lines';

  static const pickAddress =
      'وين نوصلك؟ اختار عنوان محفوظ أو ابعت موقعك من زر «إرسال موقعي».';
  static const askLocation = 'ابعت موقعك من زر «إرسال موقعي» تحت 👇\n'
      'من الكمبيوتر الزر ما بيشتغل: ابعت رابط خرائط جوجل أو الإحداثيات '
      'مثل: 31.5017, 34.4668';
  static const askDetails =
      'اكتب وصف للعنوان (الحي، أقرب معلم، رقم العمارة)، أو اضغط تخطي.';
  static const skip = 'تخطي';
  static const addressLabel = 'عنوان التوصيل';

  static const quoting = 'لحظة، عم نحسب السعر...';
  static String quote(String lines, String total) =>
      '🧾 ملخص الطلب:\n$lines\n\nالإجمالي: $total\n💵 الدفع: كاش عند الاستلام';
  static const confirm = '✅ تأكيد الطلب';
  static const cancel = '❌ إلغاء';
  static const cancelled = 'لغينا التأكيد، سلتك لسا محفوظة.';
  static String placed(String code, String status) =>
      '🎉 تم إرسال طلبك!\nرقم الطلب: $code\nالحالة: $status\n\n'
      'رح نبعتلك هون كل ما تتغير حالة الطلب.';
  static const quoteAgain = 'السعر انتهت صلاحيته، حسبناه من جديد:';

  static const noOrders = 'ما عندك طلبات لسا.';
  static String orderLine(String code, String status, String total) =>
      '• $code — $status${total.isEmpty ? '' : ' — $total'}';
  static const lastOrders = 'آخر طلباتك:';
  static String statusChanged(String code, String status) =>
      '🔔 طلبك $code صار: $status';

  static String offer(String code, String total) =>
      '💬 وصلك عرض سعر لطلب $code\nالإجمالي: $total\nبتوافق؟';
  static const approve = '✅ موافق';
  static const reject = '❌ رفض';
  static const offerApproved = 'تمت الموافقة على العرض ✅';
  static const offerRejected = 'رفضنا العرض.';

  static const unknown = 'ما فهمت عليك 🙂 استخدم الأزرار تحت.';
  static const failed = 'صار خطأ، جرب كمان شوي.';
  static String error(String? message) =>
      message == null || message.isEmpty ? failed : '⚠️ $message';

  // ---- photo diagnosis ----
  static const analyzing = '📸 وصلت الصورة! لحظة، عم نحللها...';
  static const visionOff = 'تحليل الصور مش مفعّل هلأ، جرب بعد شوي.';
  static const visionFailed = 'ما قدرنا نحلل الصورة هلأ 😕 جرب تبعتها كمان '
      'مرة، ويفضل تكون واضحة وقريبة.';
  static String notAJob(String seen) => '${seen.isEmpty ? '' : '👀 $seen\n\n'}'
      'هاي الصورة ما بتبين مشكلة أو شغلة بالبيت. '
      'صوّر المكان أو الشي يلي بدك تصلحه أو تركبه وابعته هون.';
  static const bookInspection = '📅 اطلب معاينة';
  static const anotherPhoto = '📸 أبعت صورة ثانية';
  static const sendPhoto = 'تمام، ابعت الصورة هون 👇';
  static const pickProvider = 'ممتاز! اختار مزوّد الخدمة، وهو بيتواصل معك '
      'ليحدد موعد المعاينة والسعر:';
  static const inspectionLogin =
      'عشان نحجزلك معاينة لازم تسجل دخول أول، ابعت /start';
  static const photoHint = '📸 جديد: ابعتلنا صورة لأي مشكلة بالبيت (شادر، '
      'خيمة، تسريب مي، كهربا...) وبنحللها وبنحكيلك مين الفني المناسب.';

  static String diagnosis(Diagnosis d) {
    String bullets(List<String> items) => items.map((e) => '• $e').join('\n');
    final icon = switch (d.severity) {
      'عاجل' => '🔴',
      'متوسط' => '🟠',
      _ => '🟢',
    };
    final reason = d.inspectionReason.isEmpty ? '' : ' — ${d.inspectionReason}';
    return [
      '🔍 تحليل الصورة',
      if (d.category.isNotEmpty) '🏷 الخدمة: ${d.category}',
      if (d.seen.isNotEmpty) '👀 ${d.seen}',
      if (d.problem.isNotEmpty) '\n🛠 المشكلة:\n${d.problem}',
      if (d.severity.isNotEmpty) '$icon الأولوية: ${d.severity}',
      if (d.technician.isNotEmpty) '\n👷 الفني المناسب: ${d.technician}',
      if (d.materials.isNotEmpty) '🧰 مواد متوقعة:\n${bullets(d.materials)}',
      if (d.tips.isNotEmpty) '\n💡 لحد ما يوصل الفني:\n${bullets(d.tips)}',
      if (d.questions.isNotEmpty)
        '\n❓ عشان نجهّز الفني صح:\n${bullets(d.questions)}',
      '\n💰 السعر: بيتحدد بعد المعاينة$reason',
    ].join('\n');
  }
}
