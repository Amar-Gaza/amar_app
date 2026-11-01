// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get statusAwaitingPricing => 'بانتظار التسعير';

  @override
  String get statusPriced => 'تم التسعير';

  @override
  String get statusAwaitingVendor => 'بانتظار المتجر';

  @override
  String get statusPreparing => 'قيد التحضير';

  @override
  String get statusPending => 'بانتظار سائق';

  @override
  String get statusAccepted => 'تم القبول';

  @override
  String get statusPickedUp => 'تم الاستلام';

  @override
  String get statusOnTheWay => 'في الطريق';

  @override
  String get statusArrived => 'السائق وصل';

  @override
  String get statusDelivered => 'تم التوصيل';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get actionAwaitingVendorToPreparingVendor => 'قبول الطلب';

  @override
  String get actionAwaitingPricingToPricedAdmin => 'أرسل العرض';

  @override
  String get actionPreparingToPendingVendor => 'جاهز للاستلام';

  @override
  String get actionPendingToAcceptedDriver => 'اقبل الطلب';

  @override
  String get actionAcceptedToPickedUpDriver => 'استلمت الطلب';

  @override
  String get confirmAcceptedToPickedUpDriver => 'متأكد إنك استلمت الطلب؟';

  @override
  String get actionPickedUpToOnTheWayDriver => 'انطلقت للزبون';

  @override
  String get actionOnTheWayToArrivedDriver => 'وصلت';

  @override
  String get actionArrivedToDeliveredDriver => 'تم التسليم';

  @override
  String get confirmArrivedToDeliveredDriver => 'تأكد من استلام الزبون للطلب';

  @override
  String get actionPendingToCancelledUser => 'إلغاء الطلب';

  @override
  String get actionAwaitingVendorToCancelledUser => 'إلغاء الطلب';

  @override
  String get actionPreparingToCancelledUser => 'إلغاء الطلب';

  @override
  String get actionAwaitingPricingToCancelledUser => 'إلغاء الطلب';

  @override
  String get actionAcceptedToCancelledUser => 'إلغاء الطلب';

  @override
  String get actionAwaitingVendorToCancelledVendor => 'رفض الطلب';

  @override
  String get actionAwaitingPricingToCancelledVendor => 'رفض الطلب';

  @override
  String get actionPricedToCancelledVendor => 'رفض الطلب';

  @override
  String get actionPricedToCancelledUser => 'رفض العرض';

  @override
  String get cancelReasonUserChangedMind => 'غيّرت رأيي';

  @override
  String get cancelReasonUserWrongAddress => 'العنوان غير صحيح';

  @override
  String get cancelReasonUserTooSlow => 'الانتظار طويل';

  @override
  String get cancelReasonUserOther => 'سبب آخر';

  @override
  String get cancelReasonAdminCustomerRequest => 'بطلب من الزبون';

  @override
  String get cancelReasonAdminNoDriver => 'لا يوجد سائق متاح';

  @override
  String get cancelReasonAdminOther => 'سبب آخر';

  @override
  String get errorMissingProjectKey => 'الترويسة X-Project-Key مطلوبة';

  @override
  String get errorInvalidProjectKey => 'مفتاح المشروع غير صالح أو تم إلغاؤه';

  @override
  String get errorUnauthenticated => 'سجّل الدخول للمتابعة';

  @override
  String get errorOtpInvalid => 'رمز التحقق غير صحيح';

  @override
  String get errorOtpExpired => 'انتهت صلاحية رمز التحقق';

  @override
  String get errorForbidden => 'غير مسموح لك بتنفيذ هذا الإجراء';

  @override
  String get errorModuleDisabled => 'هذه الميزة غير مفعّلة في هذا المشروع';

  @override
  String get errorProjectFrozen => 'هذا المشروع مجمّد';

  @override
  String get errorProjectInactive => 'هذا المشروع غير مفعّل بعد';

  @override
  String get errorUserBlocked => 'تم حظر هذا الحساب';

  @override
  String get errorNotFound => 'العنصر المطلوب غير موجود';

  @override
  String get errorMethodNotAllowed => 'طريقة الطلب هذه غير مسموحة هنا';

  @override
  String get errorAlreadyTaken => 'سبقك أحد آخر إلى هذا الطلب';

  @override
  String get errorConflict => 'الطلب يتعارض مع الحالة الحالية';

  @override
  String get errorBidClosed => 'تم إغلاق العروض على هذا الطلب';

  @override
  String get errorIdempotencyMismatch =>
      'مفتاح Idempotency-Key مستخدم سابقًا مع طلب مختلف';

  @override
  String get errorQuoteExpired => 'انتهت صلاحية عرض السعر، اطلب عرضًا جديدًا';

  @override
  String get errorQuoteUsed => 'تم استخدام عرض السعر هذا مسبقًا';

  @override
  String get errorValidationFailed => 'بعض الحقول غير صحيحة';

  @override
  String get errorInvalidTransition => 'لا يمكن تغيير الحالة بهذا الشكل الآن';

  @override
  String get errorOutOfZone => 'هذا الموقع خارج منطقة الخدمة';

  @override
  String get errorOutOfStock => 'الكمية المتوفرة غير كافية';

  @override
  String get errorSlotFull => 'موعد التوصيل هذا ممتلئ';

  @override
  String get errorCashLimitReached =>
      'وصلت للحد الأعلى للنقد، قم بالتسوية أولًا';

  @override
  String get errorVendorClosed => 'المتجر مغلق حاليًا';

  @override
  String get errorAppUpdateRequired => 'حدّث التطبيق للمتابعة';

  @override
  String get errorTooManyRequests => 'طلبات كثيرة جدًا، تمهّل قليلًا';

  @override
  String get errorServerError => 'حدث خطأ من جهتنا';

  @override
  String get errorMaintenance => 'الخدمة تحت الصيانة';

  @override
  String get errorChaosInjected => 'عطل مؤقت (وضع الفوضى)، أعد المحاولة';

  @override
  String get splashTagline => 'نبني الثقة، ونصونها.';

  @override
  String get onboardingTitle => 'خدمات منزلية موثوقة بكل سهولة';

  @override
  String get onboardingSubtitle =>
      'من التنظيف والصيانة إلى خدمات السباكة والكهرباء وأكثر.';

  @override
  String get onboardingStart => 'ابدأ الآن';

  @override
  String get phoneTitle => 'أهلاً بك في عَمار';

  @override
  String get phoneSubtitle => 'أدخل رقم جوالك وسنرسل لك رمزاً للتحقق من هويتك.';

  @override
  String get phoneHint => '59 123 4567';

  @override
  String get phoneSend => 'إرسال رمز التحقق';

  @override
  String get otpTitle => 'أدخل رمز التحقق';

  @override
  String get otpResend => 'إعادة إرسال الرمز';

  @override
  String get otpChangePhone => 'تغيير الرقم';

  @override
  String get otpVerify => 'تحقق ومتابعة';

  @override
  String get otpExpiredTitle => 'انتهت صلاحية الرمز';

  @override
  String get otpExpiredHint =>
      'اطلب رمزاً جديداً للمتابعة وتسجيل الدخول بأمان.';

  @override
  String get profileTitle => 'كيف نناديك؟';

  @override
  String get profileSubtitle => 'ساعدنا في تخصيص تجربتك داخل عَمار.';

  @override
  String get profileNameLabel => 'الاسم';

  @override
  String get profileNameHint => 'اكتب اسمك';

  @override
  String get profileContinue => 'حفظ وبدء الاستخدام';

  @override
  String get homeGreetingGuest => 'مرحباً بك';

  @override
  String get homeCategoriesTitle => 'ماذا تحتاج اليوم؟';

  @override
  String get homeCategoriesSubtitle => 'خدمات منزلية موثوقة';

  @override
  String get homeLogout => 'تسجيل الخروج';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonLoading => 'يرجى الانتظار لحظة';

  @override
  String get commonOfflineTitle => 'تعذر الاتصال بالخدمة';

  @override
  String get commonOfflineHint => 'تأكد من اتصالك بالإنترنت ثم حاول مرة أخرى';

  @override
  String get commonGenericError => 'حدث خطأ غير متوقع';

  @override
  String get logoutDialogMessage => 'هل تريد تسجيل الخروج من حسابك؟';

  @override
  String get validationPhoneInvalid => 'رقم الجوال غير صحيح';

  @override
  String get validationNameInvalid => 'الاسم يجب أن يكون حرفين على الأقل';

  @override
  String get validationOtpIncomplete => 'أدخل الرمز كاملاً';

  @override
  String get brandName => 'عَمار';

  @override
  String get splashFooter => 'عَمار · كل ما يحتاجه بيتك';

  @override
  String get configLoadingTitle => 'نجهّز تجربتك';

  @override
  String get configLoadingMessage =>
      'جارٍ تحميل إعدادات التطبيق والخدمات المتاحة...';

  @override
  String get configStepVersion => 'التحقق من نسخة التطبيق';

  @override
  String get configStepSettings => 'تحميل إعدادات عَمار';

  @override
  String get configStepModules => 'تجهيز الوحدات والخدمات';

  @override
  String get languageToggle => 'EN';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get phoneLabel => 'رقم الجوال';

  @override
  String get phoneHelper => 'أدخل رقمك بدون رمز الدولة';

  @override
  String get consentPrefix => 'بمتابعتك، أنت توافق على ';

  @override
  String get consentTerms => 'الشروط والأحكام';

  @override
  String get consentAnd => ' و';

  @override
  String get consentPrivacy => 'سياسة الخصوصية';

  @override
  String get otpScreenTitle => 'التحقق من الجوال';

  @override
  String get otpResendWithin => 'إعادة الإرسال خلال';

  @override
  String get otpTryAgain => 'حاول مرة أخرى';

  @override
  String get otpSendNew => 'إرسال رمز جديد';

  @override
  String get otpUseDifferentNumber => 'استخدام رقم مختلف';

  @override
  String get otpInvalidTitle => 'الرمز غير صحيح';

  @override
  String get otpInvalidMessage =>
      'تحقق من الرمز وحاول مرة أخرى، لديك عدد محدود من المحاولات.';

  @override
  String get otpInvalidBannerTitle => 'تعذّر التحقق';

  @override
  String get authLoadingTitle => 'جارٍ تسجيل الدخول';

  @override
  String get authLoadingMessage => 'نتحقق من الرمز ونجهّز حسابك بأمان...';

  @override
  String get authLoadingStep => 'التحقق من الهوية';

  @override
  String get authLoadingKeepOpen => 'يرجى عدم إغلاق التطبيق';

  @override
  String get profileScreenTitle => 'أكمل ملفك';

  @override
  String get profileStepLabel => 'خطوة أخيرة';

  @override
  String get profileLanguageLabel => 'لغة التطبيق';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navOrders => 'طلباتي';

  @override
  String get navNotifications => 'الإشعارات';

  @override
  String get navAccount => 'حسابي';

  @override
  String get homeSearchHint => 'ما الخدمة التي تبحث عنها؟';

  @override
  String get homeVendorsTitle => 'مزوّدون مقترحون';

  @override
  String get homeVendorsSubtitle => 'مختارون بعناية لك';

  @override
  String get homeProductsTitle => 'منتجات شائعة';

  @override
  String get homeProductsSubtitle => 'الأكثر طلباً';

  @override
  String get homeEmptyTitle => 'لا توجد خدمات متاحة حالياً';

  @override
  String get homeEmptyMessage => 'سنعرض الخدمات هنا فور توفرها.';

  @override
  String get vendorOpenNow => 'مفتوح الآن';

  @override
  String get vendorClosedNow => 'مغلق حالياً';

  @override
  String get ordersEmptyTitle => 'لا توجد طلبات بعد';

  @override
  String get ordersEmptyMessage =>
      'ابدأ باستكشاف خدمات عَمار، وستجد طلباتك هنا.';

  @override
  String get ordersExplore => 'استكشف الخدمات';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات';

  @override
  String get notificationsEmptyMessage =>
      'ستظهر هنا تحديثات طلباتك والعروض الجديدة.';

  @override
  String get commonRefresh => 'تحديث الصفحة';

  @override
  String get commonErrorTitle => 'تعذّر إتمام الطلب';

  @override
  String get commonContactSupport => 'تواصل مع الدعم';

  @override
  String get stateOfflineTitle => 'أنت غير متصل';

  @override
  String get stateOfflineMessage =>
      'تحقق من اتصالك بالإنترنت ثم حاول مرة أخرى.';

  @override
  String get stateOfflineFootnote =>
      'سنعيد تحميل آخر محتوى متاح بعد عودة الاتصال.';

  @override
  String get stateOfflineBanner => 'لا يوجد اتصال بالإنترنت';

  @override
  String get stateUnavailableTitle => 'الخدمة غير متاحة حالياً';

  @override
  String get stateUnavailableMessage =>
      'لم نتمكن من إكمال طلبك. حاول مرة أخرى بعد قليل.';

  @override
  String get stateErrorTitle => 'لحظة واحدة';

  @override
  String get stateSupportReference => 'مرجع الدعم';

  @override
  String get stateLoadingContent => 'جارٍ تحميل المحتوى';

  @override
  String orderCode(String code) {
    return 'طلب #$code';
  }

  @override
  String orderItemsCount(int count) {
    return '$count عناصر';
  }

  @override
  String get ordersScopeActive => 'النشطة';

  @override
  String get ordersScopeCompleted => 'المكتملة';

  @override
  String get ordersScopeCancelled => 'الملغاة';

  @override
  String get notificationsReadAll => 'تحديد الكل كمقروء';

  @override
  String get homeActiveOrderTitle => 'طلبك الحالي';

  @override
  String get commonViewAll => 'عرض الكل';

  @override
  String get cartTitle => 'السلة';

  @override
  String get cartAdd => 'إضافة للسلة';

  @override
  String cartAddCount(int count) {
    return 'إضافة $count للسلة';
  }

  @override
  String get cartAdded => 'تمت الإضافة إلى السلة';

  @override
  String get cartOtherVendorMessage =>
      'سلتك فيها منتجات من متجر آخر. هل تريد تفريغها والبدء بهذا المنتج؟';

  @override
  String get searchTitle => 'البحث';

  @override
  String get searchHint => 'ابحث عن منتج أو خدمة';

  @override
  String get searchIdleTitle => 'عن ماذا تبحث؟';

  @override
  String get searchIdleMessage => 'اكتب اسم المنتج أو الخدمة ثم اضغط بحث.';

  @override
  String get searchResultsTitle => 'نتائج البحث';

  @override
  String resultsCount(int count) {
    return '$count نتيجة';
  }

  @override
  String get searchEmptyTitle => 'لم نجد نتائج';

  @override
  String get searchEmptyMessage => 'جرّب كلمة أقصر أو تصفّح التصنيفات المتاحة.';

  @override
  String get searchBrowseCategories => 'تصفّح التصنيفات';

  @override
  String get searchClear => 'مسح البحث';

  @override
  String get categoriesTitle => 'كل التصنيفات';

  @override
  String get categoriesSearchHint => 'ابحث داخل التصنيفات';

  @override
  String get categoriesEmpty => 'لا توجد تصنيفات مطابقة';

  @override
  String categoryProductsCount(int count) {
    return '$count منتجاً';
  }

  @override
  String get vendorsTitle => 'المتاجر';

  @override
  String get vendorsEmpty => 'لا توجد متاجر متاحة حالياً';

  @override
  String vendorRating(String average, int count) {
    return '$average ($count)';
  }

  @override
  String vendorRatingsCount(int count) {
    return '$count تقييم';
  }

  @override
  String vendorDistance(String km) {
    return '$km كم';
  }

  @override
  String get vendorDistanceLabel => 'عن موقعك';

  @override
  String vendorPrepMinutes(int minutes) {
    return 'التحضير خلال $minutes دقيقة';
  }

  @override
  String vendorMinutesShort(int minutes) {
    return '$minutes د';
  }

  @override
  String get vendorPrepLabel => 'وقت التحضير';

  @override
  String get vendorAddress => 'العنوان';

  @override
  String get vendorAddressUnknown => 'لم يضف المتجر عنواناً بعد';

  @override
  String get vendorTabProducts => 'المنتجات';

  @override
  String get vendorTabHours => 'أوقات العمل';

  @override
  String get vendorTabAbout => 'عن المتجر';

  @override
  String get vendorNoDescription => 'لا يوجد وصف لهذا المتجر بعد.';

  @override
  String get vendorHoursTitle => 'أوقات العمل';

  @override
  String get vendorHoursUnknown => 'لم يحدد المتجر أوقات العمل.';

  @override
  String get vendorDayClosed => 'مغلق';

  @override
  String get vendorToday => 'اليوم';

  @override
  String get vendorOpenTitle => 'المتجر مفتوح الآن';

  @override
  String get vendorClosedTitle => 'المتجر مغلق الآن';

  @override
  String get vendorClosedHint => 'راجع أوقات العمل لمعرفة موعد الفتح.';

  @override
  String get productsSearchHint => 'ابحث داخل المنتجات';

  @override
  String productsCount(int count) {
    return '$count منتجاً';
  }

  @override
  String get productsEmpty => 'لا توجد منتجات هنا بعد';

  @override
  String get productAvailable => 'متوفر';

  @override
  String get productUnavailable => 'غير متوفر';

  @override
  String get productUnavailableNow => 'غير متوفر حالياً';

  @override
  String get productVendor => 'المتجر';

  @override
  String get productCategory => 'الفئة';

  @override
  String get productIndicativePrice =>
      'السعر المبدئي، يعتمده الخادم عند التسعير';

  @override
  String get productPriceAfterInspection => 'السعر النهائي بعد المعاينة';

  @override
  String get productOptionsTitle => 'خيارات المنتج';

  @override
  String get productOptionsHint => 'حدد المواصفات المطلوبة';

  @override
  String get productOutOfStockTitle => 'نفد المخزون';

  @override
  String get productOutOfStockMessage =>
      'لا يمكن إضافته للسلة حتى يصبح متوفراً.';

  @override
  String get productAlternatives => 'استكشف منتجات بديلة';

  @override
  String get productOptionsScreenTitle => 'اختر المواصفات';

  @override
  String productBasePrice(String price) {
    return 'السعر الأساسي: $price';
  }

  @override
  String get optionSingle => 'اختيار واحد';

  @override
  String get optionMulti => 'اختيارات متعددة';

  @override
  String get optionRequired => 'مطلوب';

  @override
  String get optionOptional => 'اختياري';

  @override
  String optionExtraPrice(String price) {
    return '+$price';
  }

  @override
  String get optionsContinue => 'متابعة لاختيار الكمية';

  @override
  String get quantityTitle => 'الكمية';

  @override
  String get quantityLabel => 'الكمية';

  @override
  String get quantityServerPriced => 'يُعاد التسعير من الخادم';

  @override
  String quantityStock(int count) {
    return 'المتوفر: $count';
  }

  @override
  String get quantityStockHint => 'لا يمكن تجاوز الكمية المتوفرة.';

  @override
  String get quantityPriceNote =>
      'الأسعار تقديرية، والخادم يحسب السعر النهائي عند طلب التسعيرة.';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get checkoutStepCart => 'السلة';

  @override
  String get checkoutStepDelivery => 'التوصيل';

  @override
  String get checkoutStepQuote => 'التسعيرة';

  @override
  String get checkoutStepConfirm => 'التأكيد';

  @override
  String get checkoutPayment => 'طريقة الدفع';

  @override
  String get paymentCashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get cartEmptyTitle => 'سلتك فارغة';

  @override
  String get cartEmptyMessage => 'أضف منتجات من المتاجر وستظهر هنا.';

  @override
  String get cartVendorFallback => 'المتجر';

  @override
  String cartLinesCount(int count) {
    return '$count عناصر في السلة';
  }

  @override
  String get cartClear => 'تفريغ السلة';

  @override
  String get cartRemove => 'حذف';

  @override
  String get cartNoOptions => 'بدون خيارات';

  @override
  String get cartPriceByServer => 'السعر يعتمد من التسعيرة';

  @override
  String cartQty(int qty) {
    return 'الكمية: $qty';
  }

  @override
  String get cartTotalNote =>
      'لا نعرض إجمالياً معتمداً قبل طلب التسعيرة. الخادم يسعّر كل سطر وخياراته.';

  @override
  String get cartTotalLabel => 'الإجمالي';

  @override
  String get cartTotalLater => 'يُحسب في الخطوة التالية';

  @override
  String get deliveryTitle => 'الاستلام والتوصيل';

  @override
  String get deliveryPickup => 'الاستلام';

  @override
  String get deliveryAddress => 'عنوان التوصيل';

  @override
  String get deliveryChooseAddress => 'اختر العنوان';

  @override
  String get deliveryTime => 'موعد التوصيل';

  @override
  String get deliveryRequestQuote => 'طلب التسعيرة';

  @override
  String get scheduleNow => 'الآن';

  @override
  String get schedulePick => 'تحديد موعد';

  @override
  String get detailsTitle => 'تفاصيل إضافية';

  @override
  String get detailsHint => 'ملاحظة ومرفقات اختيارية';

  @override
  String detailsAttachedCount(int count) {
    return '$count مرفقات';
  }

  @override
  String get detailsNote => 'ملاحظة عامة';

  @override
  String get detailsNoteHint => 'اختياري، حتى 1000 حرف';

  @override
  String get attachTitle => 'المرفقات';

  @override
  String get attachPick => 'اختر صورة للرفع';

  @override
  String attachLimits(int max) {
    return 'حتى $max ملفات، الحد الأقصى 10MB للملف';
  }

  @override
  String get attachCamera => 'التقاط صورة';

  @override
  String get attachGallery => 'من المعرض';

  @override
  String get attachUploading => 'جارٍ رفع الملفات...';

  @override
  String get uploadDone => 'تم الرفع';

  @override
  String get addressPickerTitle => 'اختر عنوان التوصيل';

  @override
  String get addressAddNew => 'إضافة عنوان جديد';

  @override
  String get addressInsideZone => 'داخل منطقة الخدمة';

  @override
  String get addressUse => 'استخدام هذا العنوان';

  @override
  String get addressNewTitle => 'إضافة عنوان';

  @override
  String get addressLocating => 'نحدد موقعك...';

  @override
  String get addressLocated => 'تم تحديد موقعك';

  @override
  String get addressUseMyLocation => 'استخدام موقعي الحالي';

  @override
  String get addressLabel => 'اسم العنوان';

  @override
  String get addressLabelHint => 'مثال: المنزل';

  @override
  String get addressLabelRequired => 'اكتب اسماً للعنوان';

  @override
  String get addressDetails => 'تفاصيل إضافية';

  @override
  String get addressDetailsHint => 'الشارع، المبنى، الطابق...';

  @override
  String get addressMakeDefault => 'تعيين كعنوان افتراضي';

  @override
  String get addressZoneNote =>
      'إذا كانت النقطة خارج منطقة الخدمة سيرفض الخادم حفظ العنوان.';

  @override
  String get addressSave => 'حفظ العنوان';

  @override
  String get locationServiceOff => 'خدمة الموقع متوقفة. فعّلها ثم حاول مجدداً.';

  @override
  String get locationDenied => 'نحتاج إذن الموقع لتحديد العنوان.';

  @override
  String get locationDeniedForever => 'إذن الموقع مرفوض. فعّله من الإعدادات.';

  @override
  String get locationOpenSettings => 'فتح الإعدادات';

  @override
  String get couponTitle => 'كوبون الخصم';

  @override
  String get couponHint => 'أضف كوبوناً إن وجد';

  @override
  String get couponHero => 'خصمك يبدأ هنا';

  @override
  String get couponCodeLabel => 'رمز الكوبون';

  @override
  String get couponCodeHint => 'AMAR30';

  @override
  String get couponCheck => 'تحقق';

  @override
  String get couponCheckNote =>
      'التحقق يؤكد صلاحية الرمز فقط، وقيمة الخصم النهائية تظهر في التسعيرة.';

  @override
  String get couponInvalidTitle => 'الكوبون غير صالح';

  @override
  String get couponValidTitle => 'الكوبون صالح';

  @override
  String get couponValidMessage =>
      'سيُرسل الرمز مع طلب التسعيرة ليحسب الخادم الخصم النهائي.';

  @override
  String get couponValue => 'القيمة';

  @override
  String get couponMaxDiscount => 'أقصى خصم';

  @override
  String get couponMinTotal => 'الحد الأدنى للطلب';

  @override
  String get couponUsesLeft => 'الاستخدامات المتبقية';

  @override
  String get couponExpires => 'ينتهي في';

  @override
  String get couponApply => 'تطبيق الكوبون';

  @override
  String couponRemove(String code) {
    return 'إزالة الكوبون $code';
  }

  @override
  String get quoteTitle => 'التسعيرة';

  @override
  String quoteValidFor(String time) {
    return 'التسعيرة صالحة لمدة $time';
  }

  @override
  String get quoteValidHint => 'بعد انتهاء المدة يلزم طلب تسعيرة جديدة.';

  @override
  String get quoteDetailsTitle => 'تفاصيل التسعيرة';

  @override
  String get quoteItemsTotal => 'إجمالي المنتجات';

  @override
  String get quoteDeliveryFee => 'رسوم التوصيل';

  @override
  String get quoteDiscount => 'الخصم';

  @override
  String get quoteTotal => 'الإجمالي النهائي';

  @override
  String get quoteDistance => 'المسافة';

  @override
  String get quoteReview => 'مراجعة الطلب';

  @override
  String get quoteExpiredTitle => 'انتهت صلاحية التسعيرة';

  @override
  String get quoteUsedTitle => 'التسعيرة مستخدمة مسبقاً';

  @override
  String get quoteExpiredMessage =>
      'الأسعار تتغير، اطلب تسعيرة جديدة للمتابعة.';

  @override
  String get quoteRefresh => 'طلب تسعيرة جديدة';

  @override
  String get quoteBackToCart => 'العودة';

  @override
  String get reviewTitle => 'مراجعة الطلب';

  @override
  String get reviewProducts => 'المنتجات';

  @override
  String get reviewDeliveryPayment => 'التوصيل والدفع';

  @override
  String reviewConfirm(String total) {
    return 'تأكيد الطلب · $total';
  }

  @override
  String get placeFailedTitle => 'تعذّر إنشاء الطلب';

  @override
  String get placingTitle => 'جارٍ إنشاء طلبك';

  @override
  String get placingMessage =>
      'لا تغلق التطبيق. لن يتكرر الطلب حتى لو أعدت المحاولة.';

  @override
  String get successCaption => 'تم إنشاء الطلب';

  @override
  String get successTitle => 'طلبك في أيدٍ أمينة';

  @override
  String get successMessage => 'يمكنك متابعة الحالة والتحديثات من صفحة طلباتي.';

  @override
  String get successOrderNumber => 'رقم الطلب';

  @override
  String get successStatus => 'الحالة';

  @override
  String get successDeliverTo => 'التوصيل إلى';

  @override
  String get successTrack => 'تتبع الطلب';

  @override
  String get successBackHome => 'العودة للرئيسية';

  @override
  String orderStepOf(int step, int total) {
    return 'المرحلة $step من $total';
  }

  @override
  String get orderRoute => 'المسار';

  @override
  String get orderPickup => 'الاستلام';

  @override
  String get orderDropoff => 'التوصيل';

  @override
  String get orderPlaceUnknown => 'غير محدد';

  @override
  String get orderDirections => 'الاتجاهات';

  @override
  String get orderDetailsTitle => 'تفاصيل الطلب';

  @override
  String get orderTimelineTitle => 'سجل الطلب';

  @override
  String get orderDeliveryCode => 'رمز التسليم';

  @override
  String get orderCancelledTitle => 'تم إلغاء الطلب';

  @override
  String get offerPendingTitle => 'لديك عرض سعر بانتظار موافقتك';

  @override
  String get offerPendingMessage => 'راجع البنود ووافق أو ارفض العرض.';

  @override
  String get offerView => 'عرض السعر';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get receiptTitle => 'الإيصال';

  @override
  String get shareTitle => 'مشاركة رابط التتبع';

  @override
  String get rateTitle => 'تقييم الطلب';

  @override
  String trackingDriverRating(String rating) {
    return '★ $rating';
  }

  @override
  String get cancelHint => 'اختر سبب الإلغاء. لا يمكن التراجع بعد التأكيد.';

  @override
  String get cancelNote => 'ملاحظة';

  @override
  String get cancelSubmit => 'تأكيد الإلغاء';

  @override
  String get cancelConfirm => 'هل أنت متأكد من إلغاء هذا الطلب؟';

  @override
  String get offerClosed => 'تم التعامل مع هذا العرض.';

  @override
  String get offerItemUnavailable => 'غير متوفر';

  @override
  String get offerApprove => 'الموافقة';

  @override
  String get offerReject => 'رفض العرض';

  @override
  String get offerApproveConfirm =>
      'هل توافق على هذا العرض؟ سيبدأ تنفيذ الطلب.';

  @override
  String get offerRejectConfirm => 'رفض العرض';

  @override
  String get offerRejectReason => 'سبب الرفض (اختياري)';

  @override
  String offerSubstitute(String name, String price) {
    return 'بديل: $name · $price';
  }

  @override
  String offerExpires(String time) {
    return 'ينتهي العرض $time';
  }

  @override
  String get trackingEmptyTitle => 'لا يوجد تتبع بعد';

  @override
  String get trackingEmptyMessage => 'سيظهر التتبع عندما يستلم السائق طلبك.';

  @override
  String get trackingNoLocation => 'لم يشارك السائق موقعه بعد';

  @override
  String get trackingOpenMap => 'فتح في الخرائط';

  @override
  String get trackingNoDriver => 'لم يتم تعيين سائق بعد.';

  @override
  String get trackingNextUpdate => 'التحديث التالي';

  @override
  String trackingEta(int minutes) {
    return 'الوصول المتوقع خلال $minutes دقيقة';
  }

  @override
  String trackingSeconds(int seconds) {
    return '$seconds ث';
  }

  @override
  String get receiptDate => 'التاريخ';

  @override
  String get receiptDriver => 'السائق';

  @override
  String get rateDriver => 'كيف كانت تجربة التوصيل؟';

  @override
  String get rateStore => 'تقييم المتجر (اختياري)';

  @override
  String get rateComment => 'تعليق';

  @override
  String get rateCommentHint => 'شاركنا رأيك (اختياري)';

  @override
  String get rateSubmit => 'إرسال التقييم';

  @override
  String get shareIntroTitle => 'شارك تتبع طلبك';

  @override
  String get shareIntroMessage =>
      'أنشئ رابطاً مؤقتاً يتيح لأي شخص متابعة حالة الطلب دون تسجيل دخول.';

  @override
  String get shareCreate => 'إنشاء رابط';

  @override
  String get shareCopy => 'نسخ الرابط';

  @override
  String get shareCopied => 'تم نسخ الرابط';

  @override
  String get shareRevoke => 'إلغاء الرابط';

  @override
  String shareExpires(String time) {
    return 'ينتهي الرابط $time';
  }

  @override
  String get publicTrackingTitle => 'تتبع طلب';

  @override
  String get publicTrackingLabel => 'رابط أو رمز التتبع';

  @override
  String get publicTrackingHint => 'https://…/track/…';

  @override
  String get publicTrackingOpen => 'تتبع';

  @override
  String get publicTrackingEta => 'الوصول المتوقع';

  @override
  String get publicTrackingUpdated => 'آخر تحديث';

  @override
  String get addressEditTitle => 'تعديل العنوان';

  @override
  String get accountEditProfile => 'الملف الشخصي';

  @override
  String get accountEditProfileHint => 'الاسم، الصورة، واللغة';

  @override
  String get accountAddresses => 'العناوين المحفوظة';

  @override
  String get accountTerms => 'الشروط وسياسة الخصوصية';

  @override
  String get accountDelete => 'حذف الحساب';

  @override
  String get accountDeleteConfirm =>
      'سيتم حذف حسابك وبياناتك نهائياً. هل أنت متأكد؟';

  @override
  String get vendorApplyTitle => 'انضم كمتجر';

  @override
  String get vendorApplyHint => 'قدّم طلب انضمام لمتجرك';

  @override
  String get supportTitle => 'المساعدة والدعم';

  @override
  String get commonSave => 'حفظ';

  @override
  String get addressesEmpty => 'لا توجد عناوين محفوظة';

  @override
  String get addressDefault => 'افتراضي';

  @override
  String get addressDeleteConfirm => 'هل تريد حذف هذا العنوان؟';

  @override
  String get vendorApplyIntro =>
      'عرّفنا بمتجرك وسيتواصل معك فريق عَمار لمراجعة الطلب.';

  @override
  String get vendorApplyBusiness => 'اسم المتجر';

  @override
  String get vendorApplyBusinessHint => 'مثال: متجر الأمل';

  @override
  String get vendorApplyContact => 'اسم المسؤول';

  @override
  String get vendorApplyLocation => 'إرفاق موقعي الحالي';

  @override
  String get vendorApplySubmit => 'إرسال الطلب';

  @override
  String get vendorApplySentTitle => 'تم إرسال طلبك';

  @override
  String get vendorApplySentMessage => 'سنراجع الطلب ونتواصل معك قريباً.';

  @override
  String get commonRequired => 'هذا الحقل مطلوب';

  @override
  String get supportCall => 'اتصل بالدعم';

  @override
  String get supportOrderIssue => 'مشكلة في طلب';

  @override
  String get supportOrderIssueHint =>
      'افتح الطلب من طلباتي وتواصل مع السائق أو الدعم';

  @override
  String get driverLoginTitle => 'دخول السائقين';

  @override
  String get driverLoginSubtitle =>
      'استخدم رقم جوالك وكلمة المرور التي أعطتك إياها الإدارة.';

  @override
  String get driverPassword => 'كلمة المرور';

  @override
  String get driverPasswordHint => 'أدخل كلمة المرور';

  @override
  String get driverLoginSubmit => 'تسجيل الدخول';

  @override
  String get driverIAmCustomer => 'لست سائقاً؟ دخول العملاء';

  @override
  String get driverEntry => 'أنت سائق؟ سجّل دخولك من هنا';

  @override
  String get driverCollect => 'المبلغ المطلوب تحصيله';

  @override
  String get driverEarning => 'أرباحك';

  @override
  String get driverLocationSending => 'جارٍ إرسال موقعك...';

  @override
  String get driverLocationOk => 'موقعك يُشارك بنجاح';

  @override
  String get driverLocationPermission => 'نحتاج إذن الموقع للعمل';

  @override
  String get driverLocationPermissionHint => 'اضغط للسماح أو فتح الإعدادات';

  @override
  String get driverLocationFailed => 'تعذّر إرسال الموقع، اضغط لإعادة المحاولة';

  @override
  String driverLocationLast(String time) {
    return 'آخر إرسال: $time';
  }

  @override
  String get driverNavOrders => 'المهام';

  @override
  String get driverNavWallet => 'الأرباح';

  @override
  String get driverGreeting => 'صباح الخير';

  @override
  String get driverOnline => 'متصل';

  @override
  String get driverOffline => 'غير متصل';

  @override
  String get driverOnlineHint => 'تستقبل الطلبات الآن';

  @override
  String get driverOfflineHint => 'ابدأ يومك عند الاستعداد';

  @override
  String get driverGoOnline => 'بدء العمل';

  @override
  String get driverGoOffline => 'إيقاف';

  @override
  String get driverCurrentTask => 'المهمة الحالية';

  @override
  String get driverNoTask => 'لا توجد مهمة حالية.';

  @override
  String get driverTodaySummary => 'ملخص اليوم';

  @override
  String get driverTodayOrders => 'طلبات اليوم';

  @override
  String get driverTodayEarnings => 'أرباح اليوم';

  @override
  String get driverAvailable => 'المتاحة';

  @override
  String get driverHistory => 'السجل';

  @override
  String get driverNoAvailable => 'لا توجد طلبات متاحة حالياً';

  @override
  String get driverNoHistory => 'لا توجد طلبات سابقة';

  @override
  String get driverOrderTitle => 'تفاصيل الطلب';

  @override
  String get driverReject => 'رفض';

  @override
  String get driverRejectConfirm => 'هل تريد رفض هذا الطلب؟';

  @override
  String get driverAlreadyTaken => 'الطلب أُسند لسائق آخر';

  @override
  String get driverCustomer => 'الزبون';

  @override
  String get driverDeliveredTitle => 'تم التسليم بنجاح';

  @override
  String driverDeliveredMessage(String amount) {
    return 'أُضيف $amount إلى أرباحك.';
  }

  @override
  String driverActionConfirm(String action) {
    return 'تأكيد: $action؟';
  }

  @override
  String get driverProofPhoto => 'صورة الإثبات';

  @override
  String get driverDeliveryCode => 'رمز التسليم';

  @override
  String get driverDeliveryCodeHint => 'اطلبه من الزبون';

  @override
  String get driverCashTitle => 'النقد بحوزتك';

  @override
  String get driverCashLimit => 'الحد الأقصى';

  @override
  String get driverCashRemaining => 'المتبقي قبل الحد';

  @override
  String get driverUnsettled => 'طلبات غير مسواة';

  @override
  String get driverCashLimitReached =>
      'وصلت للحد الأقصى، سلّم النقد للإدارة لتستقبل طلبات جديدة.';

  @override
  String get driverSettlements => 'التسويات';

  @override
  String get driverNoSettlements => 'لا توجد تسويات بعد.';

  @override
  String get driverPeriodDay => 'اليوم';

  @override
  String get driverPeriodWeek => 'الأسبوع';

  @override
  String get driverPeriodMonth => 'الشهر';

  @override
  String get driverEarnings => 'الأرباح';

  @override
  String get driverEarningsHistory => 'سجل الأرباح';

  @override
  String get driverProfileHint => 'اللغة، المركبة، والصورة';

  @override
  String get driverVehicle => 'نوع المركبة';
}
