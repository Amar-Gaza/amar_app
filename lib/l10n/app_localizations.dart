import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// Order status "awaiting_payment"
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الدفع'**
  String get statusAwaitingPayment;

  /// Order status "awaiting_pricing"
  ///
  /// In ar, this message translates to:
  /// **'بانتظار التسعير'**
  String get statusAwaitingPricing;

  /// Order status "payment_review"
  ///
  /// In ar, this message translates to:
  /// **'مراجعة الدفع'**
  String get statusPaymentReview;

  /// Order status "priced"
  ///
  /// In ar, this message translates to:
  /// **'تم التسعير'**
  String get statusPriced;

  /// Order status "awaiting_vendor"
  ///
  /// In ar, this message translates to:
  /// **'بانتظار المتجر'**
  String get statusAwaitingVendor;

  /// Order status "preparing"
  ///
  /// In ar, this message translates to:
  /// **'قيد التحضير'**
  String get statusPreparing;

  /// Order status "pending"
  ///
  /// In ar, this message translates to:
  /// **'بانتظار سائق'**
  String get statusPending;

  /// Order status "accepted"
  ///
  /// In ar, this message translates to:
  /// **'تم القبول'**
  String get statusAccepted;

  /// Order status "picked_up"
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام'**
  String get statusPickedUp;

  /// Order status "on_the_way"
  ///
  /// In ar, this message translates to:
  /// **'في الطريق'**
  String get statusOnTheWay;

  /// Order status "arrived"
  ///
  /// In ar, this message translates to:
  /// **'السائق وصل'**
  String get statusArrived;

  /// Order status "delivered"
  ///
  /// In ar, this message translates to:
  /// **'تم التوصيل'**
  String get statusDelivered;

  /// Order status "cancelled"
  ///
  /// In ar, this message translates to:
  /// **'ملغي'**
  String get statusCancelled;

  /// Order status "service_requested"
  ///
  /// In ar, this message translates to:
  /// **'تم طلب الخدمة'**
  String get statusServiceRequested;

  /// Order status "service_inspection"
  ///
  /// In ar, this message translates to:
  /// **'بانتظار سعر المتجر'**
  String get statusServiceInspection;

  /// Order status "service_quoted"
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال السعر'**
  String get statusServiceQuoted;

  /// Order status "service_scheduled"
  ///
  /// In ar, this message translates to:
  /// **'تم تحديد موعد الزيارة'**
  String get statusServiceScheduled;

  /// Order status "technician_on_way"
  ///
  /// In ar, this message translates to:
  /// **'الفنّي في الطريق'**
  String get statusTechnicianOnWay;

  /// Order status "service_in_progress"
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تنفيذ العمل'**
  String get statusServiceInProgress;

  /// Order status "service_completed"
  ///
  /// In ar, this message translates to:
  /// **'اكتملت الخدمة'**
  String get statusServiceCompleted;

  /// Button for awaiting_vendor → preparing (vendor)
  ///
  /// In ar, this message translates to:
  /// **'قبول الطلب'**
  String get actionAwaitingVendorToPreparingVendor;

  /// Button for awaiting_pricing → priced (admin)
  ///
  /// In ar, this message translates to:
  /// **'أرسل العرض'**
  String get actionAwaitingPricingToPricedAdmin;

  /// Button for preparing → pending (vendor)
  ///
  /// In ar, this message translates to:
  /// **'جاهز للاستلام'**
  String get actionPreparingToPendingVendor;

  /// Button for pending → accepted (driver)
  ///
  /// In ar, this message translates to:
  /// **'اقبل الطلب'**
  String get actionPendingToAcceptedDriver;

  /// Button for service_requested → service_scheduled (vendor)
  ///
  /// In ar, this message translates to:
  /// **'قبول الطلب'**
  String get actionServiceRequestedToServiceScheduledVendor;

  /// Button for service_inspection → service_quoted (vendor)
  ///
  /// In ar, this message translates to:
  /// **'إرسال السعر'**
  String get actionServiceInspectionToServiceQuotedVendor;

  /// Button for service_quoted → service_scheduled (user)
  ///
  /// In ar, this message translates to:
  /// **'الموافقة على السعر'**
  String get actionServiceQuotedToServiceScheduledUser;

  /// Button for service_scheduled → technician_on_way (vendor)
  ///
  /// In ar, this message translates to:
  /// **'الفنّي في الطريق'**
  String get actionServiceScheduledToTechnicianOnWayVendor;

  /// Button for technician_on_way → service_in_progress (vendor)
  ///
  /// In ar, this message translates to:
  /// **'بدء العمل'**
  String get actionTechnicianOnWayToServiceInProgressVendor;

  /// Button for service_in_progress → service_completed (vendor)
  ///
  /// In ar, this message translates to:
  /// **'إنهاء الخدمة'**
  String get actionServiceInProgressToServiceCompletedVendor;

  /// Button for payment_review → pending (admin)
  ///
  /// In ar, this message translates to:
  /// **'اعتماد الدفع'**
  String get actionPaymentReviewToPendingAdmin;

  /// Button for awaiting_payment → payment_review (user)
  ///
  /// In ar, this message translates to:
  /// **'إرسال إشعار التحويل'**
  String get actionAwaitingPaymentToPaymentReviewUser;

  /// Button for payment_review → pending (vendor)
  ///
  /// In ar, this message translates to:
  /// **'اعتماد الدفع'**
  String get actionPaymentReviewToPendingVendor;

  /// Button for priced → awaiting_payment (user)
  ///
  /// In ar, this message translates to:
  /// **'الموافقة على السعر والدفع'**
  String get actionPricedToAwaitingPaymentUser;

  /// Button for service_quoted → awaiting_payment (user)
  ///
  /// In ar, this message translates to:
  /// **'الموافقة على السعر'**
  String get actionServiceQuotedToAwaitingPaymentUser;

  /// Button for payment_review → service_requested (admin)
  ///
  /// In ar, this message translates to:
  /// **'اعتماد الدفع'**
  String get actionPaymentReviewToServiceRequestedAdmin;

  /// Button for payment_review → service_requested (vendor)
  ///
  /// In ar, this message translates to:
  /// **'اعتماد الدفع'**
  String get actionPaymentReviewToServiceRequestedVendor;

  /// Button for payment_review → service_scheduled (admin)
  ///
  /// In ar, this message translates to:
  /// **'اعتماد الدفع'**
  String get actionPaymentReviewToServiceScheduledAdmin;

  /// Button for payment_review → service_scheduled (vendor)
  ///
  /// In ar, this message translates to:
  /// **'اعتماد الدفع'**
  String get actionPaymentReviewToServiceScheduledVendor;

  /// Button for accepted → picked_up (driver)
  ///
  /// In ar, this message translates to:
  /// **'استلمت الطلب'**
  String get actionAcceptedToPickedUpDriver;

  /// Confirmation before accepted → picked_up
  ///
  /// In ar, this message translates to:
  /// **'متأكد إنك استلمت الطلب؟'**
  String get confirmAcceptedToPickedUpDriver;

  /// Button for payment_review → awaiting_payment (admin)
  ///
  /// In ar, this message translates to:
  /// **'طلب تصحيح الإشعار'**
  String get actionPaymentReviewToAwaitingPaymentAdmin;

  /// Button for payment_review → awaiting_payment (vendor)
  ///
  /// In ar, this message translates to:
  /// **'طلب تصحيح الإشعار'**
  String get actionPaymentReviewToAwaitingPaymentVendor;

  /// Button for picked_up → on_the_way (driver)
  ///
  /// In ar, this message translates to:
  /// **'انطلقت للزبون'**
  String get actionPickedUpToOnTheWayDriver;

  /// Button for on_the_way → arrived (driver)
  ///
  /// In ar, this message translates to:
  /// **'وصلت'**
  String get actionOnTheWayToArrivedDriver;

  /// Button for arrived → delivered (driver)
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get actionArrivedToDeliveredDriver;

  /// Confirmation before arrived → delivered
  ///
  /// In ar, this message translates to:
  /// **'تأكد من استلام الزبون للطلب'**
  String get confirmArrivedToDeliveredDriver;

  /// Button for pending → cancelled (user)
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get actionPendingToCancelledUser;

  /// Button for awaiting_vendor → cancelled (user)
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get actionAwaitingVendorToCancelledUser;

  /// Button for preparing → cancelled (user)
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get actionPreparingToCancelledUser;

  /// Button for awaiting_pricing → cancelled (user)
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get actionAwaitingPricingToCancelledUser;

  /// Button for service_quoted → cancelled (user)
  ///
  /// In ar, this message translates to:
  /// **'رفض السعر'**
  String get actionServiceQuotedToCancelledUser;

  /// Button for service_requested → cancelled (vendor)
  ///
  /// In ar, this message translates to:
  /// **'رفض الطلب'**
  String get actionServiceRequestedToCancelledVendor;

  /// Button for service_inspection → cancelled (vendor)
  ///
  /// In ar, this message translates to:
  /// **'رفض الطلب'**
  String get actionServiceInspectionToCancelledVendor;

  /// Button for service_scheduled → cancelled (vendor)
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الزيارة'**
  String get actionServiceScheduledToCancelledVendor;

  /// Button for accepted → cancelled (user)
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get actionAcceptedToCancelledUser;

  /// Button for awaiting_vendor → cancelled (vendor)
  ///
  /// In ar, this message translates to:
  /// **'رفض الطلب'**
  String get actionAwaitingVendorToCancelledVendor;

  /// Button for awaiting_pricing → cancelled (vendor)
  ///
  /// In ar, this message translates to:
  /// **'رفض الطلب'**
  String get actionAwaitingPricingToCancelledVendor;

  /// Button for priced → cancelled (vendor)
  ///
  /// In ar, this message translates to:
  /// **'رفض الطلب'**
  String get actionPricedToCancelledVendor;

  /// Button for priced → cancelled (user)
  ///
  /// In ar, this message translates to:
  /// **'رفض العرض'**
  String get actionPricedToCancelledUser;

  /// Cancel reason "changed_mind" (user)
  ///
  /// In ar, this message translates to:
  /// **'غيّرت رأيي'**
  String get cancelReasonUserChangedMind;

  /// Cancel reason "wrong_address" (user)
  ///
  /// In ar, this message translates to:
  /// **'العنوان غير صحيح'**
  String get cancelReasonUserWrongAddress;

  /// Cancel reason "too_slow" (user)
  ///
  /// In ar, this message translates to:
  /// **'الانتظار طويل'**
  String get cancelReasonUserTooSlow;

  /// Cancel reason "other" (user)
  ///
  /// In ar, this message translates to:
  /// **'سبب آخر'**
  String get cancelReasonUserOther;

  /// Cancel reason "customer_request" (admin)
  ///
  /// In ar, this message translates to:
  /// **'بطلب من الزبون'**
  String get cancelReasonAdminCustomerRequest;

  /// Cancel reason "no_driver" (admin)
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد سائق متاح'**
  String get cancelReasonAdminNoDriver;

  /// Cancel reason "other" (admin)
  ///
  /// In ar, this message translates to:
  /// **'سبب آخر'**
  String get cancelReasonAdminOther;

  /// Message for the API error code "missing_project_key"
  ///
  /// In ar, this message translates to:
  /// **'الترويسة X-Project-Key مطلوبة'**
  String get errorMissingProjectKey;

  /// Message for the API error code "invalid_project_key"
  ///
  /// In ar, this message translates to:
  /// **'مفتاح المشروع غير صالح أو تم إلغاؤه'**
  String get errorInvalidProjectKey;

  /// Message for the API error code "unauthenticated"
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول للمتابعة'**
  String get errorUnauthenticated;

  /// Message for the API error code "otp_invalid"
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق غير صحيح'**
  String get errorOtpInvalid;

  /// Message for the API error code "otp_expired"
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية رمز التحقق'**
  String get errorOtpExpired;

  /// Message for the API error code "forbidden"
  ///
  /// In ar, this message translates to:
  /// **'غير مسموح لك بتنفيذ هذا الإجراء'**
  String get errorForbidden;

  /// Message for the API error code "module_disabled"
  ///
  /// In ar, this message translates to:
  /// **'هذه الميزة غير مفعّلة في هذا المشروع'**
  String get errorModuleDisabled;

  /// Message for the API error code "project_frozen"
  ///
  /// In ar, this message translates to:
  /// **'هذا المشروع مجمّد'**
  String get errorProjectFrozen;

  /// Message for the API error code "project_inactive"
  ///
  /// In ar, this message translates to:
  /// **'هذا المشروع غير مفعّل بعد'**
  String get errorProjectInactive;

  /// Message for the API error code "user_blocked"
  ///
  /// In ar, this message translates to:
  /// **'تم حظر هذا الحساب'**
  String get errorUserBlocked;

  /// Message for the API error code "not_found"
  ///
  /// In ar, this message translates to:
  /// **'العنصر المطلوب غير موجود'**
  String get errorNotFound;

  /// Message for the API error code "method_not_allowed"
  ///
  /// In ar, this message translates to:
  /// **'طريقة الطلب هذه غير مسموحة هنا'**
  String get errorMethodNotAllowed;

  /// Message for the API error code "already_taken"
  ///
  /// In ar, this message translates to:
  /// **'سبقك أحد آخر إلى هذا الطلب'**
  String get errorAlreadyTaken;

  /// Message for the API error code "conflict"
  ///
  /// In ar, this message translates to:
  /// **'الطلب يتعارض مع الحالة الحالية'**
  String get errorConflict;

  /// Message for the API error code "bid_closed"
  ///
  /// In ar, this message translates to:
  /// **'تم إغلاق العروض على هذا الطلب'**
  String get errorBidClosed;

  /// Message for the API error code "idempotency_mismatch"
  ///
  /// In ar, this message translates to:
  /// **'مفتاح Idempotency-Key مستخدم سابقًا مع طلب مختلف'**
  String get errorIdempotencyMismatch;

  /// Message for the API error code "quote_expired"
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية عرض السعر، اطلب عرضًا جديدًا'**
  String get errorQuoteExpired;

  /// Message for the API error code "quote_used"
  ///
  /// In ar, this message translates to:
  /// **'تم استخدام عرض السعر هذا مسبقًا'**
  String get errorQuoteUsed;

  /// Message for the API error code "validation_failed"
  ///
  /// In ar, this message translates to:
  /// **'بعض الحقول غير صحيحة'**
  String get errorValidationFailed;

  /// Message for the API error code "invalid_transition"
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تغيير الحالة بهذا الشكل الآن'**
  String get errorInvalidTransition;

  /// Message for the API error code "out_of_zone"
  ///
  /// In ar, this message translates to:
  /// **'هذا الموقع خارج منطقة الخدمة'**
  String get errorOutOfZone;

  /// Message for the API error code "out_of_stock"
  ///
  /// In ar, this message translates to:
  /// **'الكمية المتوفرة غير كافية'**
  String get errorOutOfStock;

  /// Message for the API error code "slot_full"
  ///
  /// In ar, this message translates to:
  /// **'موعد التوصيل هذا ممتلئ'**
  String get errorSlotFull;

  /// Message for the API error code "cash_limit_reached"
  ///
  /// In ar, this message translates to:
  /// **'وصلت للحد الأعلى للنقد، قم بالتسوية أولًا'**
  String get errorCashLimitReached;

  /// Message for the API error code "vendor_closed"
  ///
  /// In ar, this message translates to:
  /// **'المتجر مغلق حاليًا'**
  String get errorVendorClosed;

  /// Message for the API error code "app_update_required"
  ///
  /// In ar, this message translates to:
  /// **'حدّث التطبيق للمتابعة'**
  String get errorAppUpdateRequired;

  /// Message for the API error code "too_many_requests"
  ///
  /// In ar, this message translates to:
  /// **'طلبات كثيرة جدًا، تمهّل قليلًا'**
  String get errorTooManyRequests;

  /// Message for the API error code "server_error"
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ من جهتنا'**
  String get errorServerError;

  /// Message for the API error code "maintenance"
  ///
  /// In ar, this message translates to:
  /// **'الخدمة تحت الصيانة'**
  String get errorMaintenance;

  /// Message for the API error code "chaos_injected"
  ///
  /// In ar, this message translates to:
  /// **'عطل مؤقت (وضع الفوضى)، أعد المحاولة'**
  String get errorChaosInjected;

  /// No description provided for @splashTagline.
  ///
  /// In ar, this message translates to:
  /// **'بإيدينا بنعمّرها'**
  String get splashTagline;

  /// No description provided for @onboardingTitle.
  ///
  /// In ar, this message translates to:
  /// **'خدمات منزلية موثوقة بكل سهولة'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'من التنظيف والصيانة إلى خدمات السباكة والكهرباء وأكثر.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingStart.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get onboardingStart;

  /// No description provided for @phoneTitle.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك في عَمار'**
  String get phoneTitle;

  /// No description provided for @phoneSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم جوالك وسنرسل لك رمزاً للتحقق من هويتك.'**
  String get phoneSubtitle;

  /// No description provided for @phoneHint.
  ///
  /// In ar, this message translates to:
  /// **'59 123 4567'**
  String get phoneHint;

  /// No description provided for @phoneSend.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز التحقق'**
  String get phoneSend;

  /// No description provided for @otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز التحقق'**
  String get otpTitle;

  /// No description provided for @otpResend.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الرمز'**
  String get otpResend;

  /// No description provided for @otpChangePhone.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الرقم'**
  String get otpChangePhone;

  /// No description provided for @otpVerify.
  ///
  /// In ar, this message translates to:
  /// **'تحقق ومتابعة'**
  String get otpVerify;

  /// No description provided for @otpExpiredTitle.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية الرمز'**
  String get otpExpiredTitle;

  /// No description provided for @otpExpiredHint.
  ///
  /// In ar, this message translates to:
  /// **'اطلب رمزاً جديداً للمتابعة وتسجيل الدخول بأمان.'**
  String get otpExpiredHint;

  /// No description provided for @profileTitle.
  ///
  /// In ar, this message translates to:
  /// **'كيف نناديك؟'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'ساعدنا في تخصيص تجربتك داخل عَمار.'**
  String get profileSubtitle;

  /// No description provided for @profileNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get profileNameLabel;

  /// No description provided for @profileNameHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسمك'**
  String get profileNameHint;

  /// No description provided for @profileContinue.
  ///
  /// In ar, this message translates to:
  /// **'حفظ وبدء الاستخدام'**
  String get profileContinue;

  /// No description provided for @homeGreetingGuest.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بك'**
  String get homeGreetingGuest;

  /// No description provided for @homeCategoriesTitle.
  ///
  /// In ar, this message translates to:
  /// **'ماذا تحتاج اليوم؟'**
  String get homeCategoriesTitle;

  /// No description provided for @homeCategoriesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'خدمات منزلية موثوقة'**
  String get homeCategoriesSubtitle;

  /// No description provided for @homeLogout.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get homeLogout;

  /// No description provided for @commonRetry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get commonConfirm;

  /// No description provided for @commonLoading.
  ///
  /// In ar, this message translates to:
  /// **'يرجى الانتظار لحظة'**
  String get commonLoading;

  /// No description provided for @commonOfflineTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذر الاتصال بالخدمة'**
  String get commonOfflineTitle;

  /// No description provided for @commonOfflineHint.
  ///
  /// In ar, this message translates to:
  /// **'تأكد من اتصالك بالإنترنت ثم حاول مرة أخرى'**
  String get commonOfflineHint;

  /// No description provided for @commonGenericError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع'**
  String get commonGenericError;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد تسجيل الخروج من حسابك؟'**
  String get logoutDialogMessage;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال غير صحيح'**
  String get validationPhoneInvalid;

  /// No description provided for @validationNameInvalid.
  ///
  /// In ar, this message translates to:
  /// **'الاسم يجب أن يكون حرفين على الأقل'**
  String get validationNameInvalid;

  /// No description provided for @validationOtpIncomplete.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز كاملاً'**
  String get validationOtpIncomplete;

  /// No description provided for @brandName.
  ///
  /// In ar, this message translates to:
  /// **'عَمَار'**
  String get brandName;

  /// No description provided for @splashFooter.
  ///
  /// In ar, this message translates to:
  /// **'عَمار · كل ما يحتاجه بيتك'**
  String get splashFooter;

  /// No description provided for @configLoadingTitle.
  ///
  /// In ar, this message translates to:
  /// **'نجهّز تجربتك'**
  String get configLoadingTitle;

  /// No description provided for @configLoadingMessage.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحميل إعدادات التطبيق والخدمات المتاحة...'**
  String get configLoadingMessage;

  /// No description provided for @configStepVersion.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من نسخة التطبيق'**
  String get configStepVersion;

  /// No description provided for @configStepSettings.
  ///
  /// In ar, this message translates to:
  /// **'تحميل إعدادات عَمار'**
  String get configStepSettings;

  /// No description provided for @configStepModules.
  ///
  /// In ar, this message translates to:
  /// **'تجهيز الوحدات والخدمات'**
  String get configStepModules;

  /// No description provided for @languageToggle.
  ///
  /// In ar, this message translates to:
  /// **'EN'**
  String get languageToggle;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @phoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الجوال'**
  String get phoneLabel;

  /// No description provided for @phoneHelper.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقمك بدون رمز الدولة'**
  String get phoneHelper;

  /// No description provided for @consentPrefix.
  ///
  /// In ar, this message translates to:
  /// **'بمتابعتك، أنت توافق على '**
  String get consentPrefix;

  /// No description provided for @consentTerms.
  ///
  /// In ar, this message translates to:
  /// **'الشروط والأحكام'**
  String get consentTerms;

  /// No description provided for @consentAnd.
  ///
  /// In ar, this message translates to:
  /// **' و'**
  String get consentAnd;

  /// No description provided for @consentPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة الخصوصية'**
  String get consentPrivacy;

  /// No description provided for @otpScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من الجوال'**
  String get otpScreenTitle;

  /// No description provided for @otpResendWithin.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال خلال'**
  String get otpResendWithin;

  /// No description provided for @otpTryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get otpTryAgain;

  /// No description provided for @otpSendNew.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز جديد'**
  String get otpSendNew;

  /// No description provided for @otpUseDifferentNumber.
  ///
  /// In ar, this message translates to:
  /// **'استخدام رقم مختلف'**
  String get otpUseDifferentNumber;

  /// No description provided for @otpInvalidTitle.
  ///
  /// In ar, this message translates to:
  /// **'الرمز غير صحيح'**
  String get otpInvalidTitle;

  /// No description provided for @otpInvalidMessage.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من الرمز وحاول مرة أخرى، لديك عدد محدود من المحاولات.'**
  String get otpInvalidMessage;

  /// No description provided for @otpInvalidBannerTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التحقق'**
  String get otpInvalidBannerTitle;

  /// No description provided for @authLoadingTitle.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تسجيل الدخول'**
  String get authLoadingTitle;

  /// No description provided for @authLoadingMessage.
  ///
  /// In ar, this message translates to:
  /// **'نتحقق من الرمز ونجهّز حسابك بأمان...'**
  String get authLoadingMessage;

  /// No description provided for @authLoadingStep.
  ///
  /// In ar, this message translates to:
  /// **'التحقق من الهوية'**
  String get authLoadingStep;

  /// No description provided for @authLoadingKeepOpen.
  ///
  /// In ar, this message translates to:
  /// **'يرجى عدم إغلاق التطبيق'**
  String get authLoadingKeepOpen;

  /// No description provided for @profileScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'أكمل ملفك'**
  String get profileScreenTitle;

  /// No description provided for @profileStepLabel.
  ///
  /// In ar, this message translates to:
  /// **'خطوة أخيرة'**
  String get profileStepLabel;

  /// No description provided for @profileLanguageLabel.
  ///
  /// In ar, this message translates to:
  /// **'لغة التطبيق'**
  String get profileLanguageLabel;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get navOrders;

  /// No description provided for @navNotifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get navNotifications;

  /// No description provided for @navAccount.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navAccount;

  /// No description provided for @homeSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن خدمة أو منتج أو متجر'**
  String get homeSearchHint;

  /// No description provided for @homeVendorsTitle.
  ///
  /// In ar, this message translates to:
  /// **'مزوّدون مقترحون'**
  String get homeVendorsTitle;

  /// No description provided for @homeVendorsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'مختارون بعناية لك'**
  String get homeVendorsSubtitle;

  /// No description provided for @homeProductsTitle.
  ///
  /// In ar, this message translates to:
  /// **'منتجات شائعة'**
  String get homeProductsTitle;

  /// No description provided for @homeProductsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'الأكثر طلباً'**
  String get homeProductsSubtitle;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد خدمات متاحة حالياً'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'سنعرض الخدمات هنا فور توفرها.'**
  String get homeEmptyMessage;

  /// No description provided for @vendorOpenNow.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح الآن'**
  String get vendorOpenNow;

  /// No description provided for @vendorClosedNow.
  ///
  /// In ar, this message translates to:
  /// **'مغلق حالياً'**
  String get vendorClosedNow;

  /// No description provided for @ordersEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات بعد'**
  String get ordersEmptyTitle;

  /// No description provided for @ordersEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ باستكشاف خدمات عَمار، وستجد طلباتك هنا.'**
  String get ordersEmptyMessage;

  /// No description provided for @ordersExplore.
  ///
  /// In ar, this message translates to:
  /// **'استكشف الخدمات'**
  String get ordersExplore;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هنا تحديثات طلباتك والعروض الجديدة.'**
  String get notificationsEmptyMessage;

  /// No description provided for @commonRefresh.
  ///
  /// In ar, this message translates to:
  /// **'تحديث الصفحة'**
  String get commonRefresh;

  /// No description provided for @commonErrorTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إتمام الطلب'**
  String get commonErrorTitle;

  /// No description provided for @commonContactSupport.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع الدعم'**
  String get commonContactSupport;

  /// No description provided for @stateOfflineTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل'**
  String get stateOfflineTitle;

  /// No description provided for @stateOfflineMessage.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من اتصالك بالإنترنت ثم حاول مرة أخرى.'**
  String get stateOfflineMessage;

  /// No description provided for @stateOfflineFootnote.
  ///
  /// In ar, this message translates to:
  /// **'سنعيد تحميل آخر محتوى متاح بعد عودة الاتصال.'**
  String get stateOfflineFootnote;

  /// No description provided for @stateOfflineBanner.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت'**
  String get stateOfflineBanner;

  /// No description provided for @stateUnavailableTitle.
  ///
  /// In ar, this message translates to:
  /// **'الخدمة غير متاحة حالياً'**
  String get stateUnavailableTitle;

  /// No description provided for @stateUnavailableMessage.
  ///
  /// In ar, this message translates to:
  /// **'لم نتمكن من إكمال طلبك. حاول مرة أخرى بعد قليل.'**
  String get stateUnavailableMessage;

  /// No description provided for @stateErrorTitle.
  ///
  /// In ar, this message translates to:
  /// **'لحظة واحدة'**
  String get stateErrorTitle;

  /// No description provided for @stateSupportReference.
  ///
  /// In ar, this message translates to:
  /// **'مرجع الدعم'**
  String get stateSupportReference;

  /// No description provided for @stateLoadingContent.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ تحميل المحتوى'**
  String get stateLoadingContent;

  /// No description provided for @orderCode.
  ///
  /// In ar, this message translates to:
  /// **'طلب #{code}'**
  String orderCode(String code);

  /// No description provided for @orderItemsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} عناصر'**
  String orderItemsCount(int count);

  /// No description provided for @ordersScopeActive.
  ///
  /// In ar, this message translates to:
  /// **'النشطة'**
  String get ordersScopeActive;

  /// No description provided for @ordersScopeCompleted.
  ///
  /// In ar, this message translates to:
  /// **'المكتملة'**
  String get ordersScopeCompleted;

  /// No description provided for @ordersScopeCancelled.
  ///
  /// In ar, this message translates to:
  /// **'الملغاة'**
  String get ordersScopeCancelled;

  /// No description provided for @notificationsReadAll.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل كمقروء'**
  String get notificationsReadAll;

  /// No description provided for @homeActiveOrderTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبك الحالي'**
  String get homeActiveOrderTitle;

  /// No description provided for @commonViewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get commonViewAll;

  /// No description provided for @cartTitle.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get cartTitle;

  /// No description provided for @cartAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة للسلة'**
  String get cartAdd;

  /// No description provided for @cartAddCount.
  ///
  /// In ar, this message translates to:
  /// **'إضافة {count} للسلة'**
  String cartAddCount(int count);

  /// No description provided for @cartAdded.
  ///
  /// In ar, this message translates to:
  /// **'تمت الإضافة إلى السلة'**
  String get cartAdded;

  /// No description provided for @cartOtherVendorMessage.
  ///
  /// In ar, this message translates to:
  /// **'سلتك فيها منتجات من متجر آخر. هل تريد تفريغها والبدء بهذا المنتج؟'**
  String get cartOtherVendorMessage;

  /// No description provided for @searchTitle.
  ///
  /// In ar, this message translates to:
  /// **'البحث'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن منتج أو خدمة'**
  String get searchHint;

  /// No description provided for @searchIdleTitle.
  ///
  /// In ar, this message translates to:
  /// **'عن ماذا تبحث؟'**
  String get searchIdleTitle;

  /// No description provided for @searchIdleMessage.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسم المنتج أو الخدمة ثم اضغط بحث.'**
  String get searchIdleMessage;

  /// No description provided for @searchResultsTitle.
  ///
  /// In ar, this message translates to:
  /// **'نتائج البحث'**
  String get searchResultsTitle;

  /// No description provided for @resultsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} نتيجة'**
  String resultsCount(int count);

  /// No description provided for @searchEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد نتائج'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'جرّب كلمة أقصر أو تصفّح التصنيفات المتاحة.'**
  String get searchEmptyMessage;

  /// No description provided for @searchBrowseCategories.
  ///
  /// In ar, this message translates to:
  /// **'تصفّح التصنيفات'**
  String get searchBrowseCategories;

  /// No description provided for @searchClear.
  ///
  /// In ar, this message translates to:
  /// **'مسح البحث'**
  String get searchClear;

  /// No description provided for @categoriesTitle.
  ///
  /// In ar, this message translates to:
  /// **'كل التصنيفات'**
  String get categoriesTitle;

  /// No description provided for @categoriesSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث داخل التصنيفات'**
  String get categoriesSearchHint;

  /// No description provided for @categoriesEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تصنيفات مطابقة'**
  String get categoriesEmpty;

  /// No description provided for @categoryProductsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} منتجاً'**
  String categoryProductsCount(int count);

  /// No description provided for @vendorsTitle.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر'**
  String get vendorsTitle;

  /// No description provided for @vendorsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد متاجر متاحة حالياً'**
  String get vendorsEmpty;

  /// No description provided for @vendorRating.
  ///
  /// In ar, this message translates to:
  /// **'{average} ({count})'**
  String vendorRating(String average, int count);

  /// No description provided for @vendorRatingsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} تقييم'**
  String vendorRatingsCount(int count);

  /// No description provided for @vendorDistance.
  ///
  /// In ar, this message translates to:
  /// **'{km} كم'**
  String vendorDistance(String km);

  /// No description provided for @vendorDistanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'عن موقعك'**
  String get vendorDistanceLabel;

  /// No description provided for @vendorPrepMinutes.
  ///
  /// In ar, this message translates to:
  /// **'التحضير خلال {minutes} دقيقة'**
  String vendorPrepMinutes(int minutes);

  /// No description provided for @vendorMinutesShort.
  ///
  /// In ar, this message translates to:
  /// **'{minutes} د'**
  String vendorMinutesShort(int minutes);

  /// No description provided for @vendorPrepLabel.
  ///
  /// In ar, this message translates to:
  /// **'وقت التحضير'**
  String get vendorPrepLabel;

  /// No description provided for @vendorAddress.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get vendorAddress;

  /// No description provided for @vendorAddressUnknown.
  ///
  /// In ar, this message translates to:
  /// **'لم يضف المتجر عنواناً بعد'**
  String get vendorAddressUnknown;

  /// No description provided for @vendorTabProducts.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get vendorTabProducts;

  /// No description provided for @vendorTabHours.
  ///
  /// In ar, this message translates to:
  /// **'أوقات العمل'**
  String get vendorTabHours;

  /// No description provided for @vendorTabAbout.
  ///
  /// In ar, this message translates to:
  /// **'عن المتجر'**
  String get vendorTabAbout;

  /// No description provided for @vendorNoDescription.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد وصف لهذا المتجر بعد.'**
  String get vendorNoDescription;

  /// No description provided for @vendorHoursTitle.
  ///
  /// In ar, this message translates to:
  /// **'أوقات العمل'**
  String get vendorHoursTitle;

  /// No description provided for @vendorHoursUnknown.
  ///
  /// In ar, this message translates to:
  /// **'لم يحدد المتجر أوقات العمل.'**
  String get vendorHoursUnknown;

  /// No description provided for @vendorDayClosed.
  ///
  /// In ar, this message translates to:
  /// **'مغلق'**
  String get vendorDayClosed;

  /// No description provided for @vendorToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get vendorToday;

  /// No description provided for @vendorOpenTitle.
  ///
  /// In ar, this message translates to:
  /// **'المتجر مفتوح الآن'**
  String get vendorOpenTitle;

  /// No description provided for @vendorClosedTitle.
  ///
  /// In ar, this message translates to:
  /// **'المتجر مغلق الآن'**
  String get vendorClosedTitle;

  /// No description provided for @vendorClosedHint.
  ///
  /// In ar, this message translates to:
  /// **'راجع أوقات العمل لمعرفة موعد الفتح.'**
  String get vendorClosedHint;

  /// No description provided for @productsSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث داخل المنتجات'**
  String get productsSearchHint;

  /// No description provided for @productsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} منتجاً'**
  String productsCount(int count);

  /// No description provided for @productsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منتجات هنا بعد'**
  String get productsEmpty;

  /// No description provided for @productAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متوفر'**
  String get productAvailable;

  /// No description provided for @productUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر'**
  String get productUnavailable;

  /// No description provided for @productUnavailableNow.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر حالياً'**
  String get productUnavailableNow;

  /// No description provided for @productVendor.
  ///
  /// In ar, this message translates to:
  /// **'المتجر'**
  String get productVendor;

  /// No description provided for @productCategory.
  ///
  /// In ar, this message translates to:
  /// **'الفئة'**
  String get productCategory;

  /// No description provided for @productIndicativePrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر المبدئي، يعتمده الخادم عند التسعير'**
  String get productIndicativePrice;

  /// No description provided for @productPriceAfterInspection.
  ///
  /// In ar, this message translates to:
  /// **'السعر النهائي بعد المعاينة'**
  String get productPriceAfterInspection;

  /// No description provided for @productOptionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'خيارات المنتج'**
  String get productOptionsTitle;

  /// No description provided for @productOptionsHint.
  ///
  /// In ar, this message translates to:
  /// **'حدد المواصفات المطلوبة'**
  String get productOptionsHint;

  /// No description provided for @productOutOfStockTitle.
  ///
  /// In ar, this message translates to:
  /// **'نفد المخزون'**
  String get productOutOfStockTitle;

  /// No description provided for @productOutOfStockMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن إضافته للسلة حتى يصبح متوفراً.'**
  String get productOutOfStockMessage;

  /// No description provided for @productAlternatives.
  ///
  /// In ar, this message translates to:
  /// **'استكشف منتجات بديلة'**
  String get productAlternatives;

  /// No description provided for @productOptionsScreenTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر المواصفات'**
  String get productOptionsScreenTitle;

  /// No description provided for @productBasePrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر الأساسي: {price}'**
  String productBasePrice(String price);

  /// No description provided for @optionSingle.
  ///
  /// In ar, this message translates to:
  /// **'اختيار واحد'**
  String get optionSingle;

  /// No description provided for @optionMulti.
  ///
  /// In ar, this message translates to:
  /// **'اختيارات متعددة'**
  String get optionMulti;

  /// No description provided for @optionRequired.
  ///
  /// In ar, this message translates to:
  /// **'مطلوب'**
  String get optionRequired;

  /// No description provided for @optionOptional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get optionOptional;

  /// No description provided for @optionExtraPrice.
  ///
  /// In ar, this message translates to:
  /// **'+{price}'**
  String optionExtraPrice(String price);

  /// No description provided for @optionsContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة لاختيار الكمية'**
  String get optionsContinue;

  /// No description provided for @quantityTitle.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get quantityTitle;

  /// No description provided for @quantityLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get quantityLabel;

  /// No description provided for @quantityServerPriced.
  ///
  /// In ar, this message translates to:
  /// **'يُعاد التسعير من الخادم'**
  String get quantityServerPriced;

  /// No description provided for @quantityStock.
  ///
  /// In ar, this message translates to:
  /// **'المتوفر: {count}'**
  String quantityStock(int count);

  /// No description provided for @quantityStockHint.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن تجاوز الكمية المتوفرة.'**
  String get quantityStockHint;

  /// No description provided for @quantityPriceNote.
  ///
  /// In ar, this message translates to:
  /// **'الأسعار تقديرية، والخادم يحسب السعر النهائي عند طلب التسعيرة.'**
  String get quantityPriceNote;

  /// No description provided for @commonContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get commonContinue;

  /// No description provided for @checkoutStepCart.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get checkoutStepCart;

  /// No description provided for @checkoutStepDelivery.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل'**
  String get checkoutStepDelivery;

  /// No description provided for @checkoutStepQuote.
  ///
  /// In ar, this message translates to:
  /// **'التسعيرة'**
  String get checkoutStepQuote;

  /// No description provided for @checkoutStepConfirm.
  ///
  /// In ar, this message translates to:
  /// **'التأكيد'**
  String get checkoutStepConfirm;

  /// No description provided for @checkoutPayment.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get checkoutPayment;

  /// No description provided for @paymentCashOnDelivery.
  ///
  /// In ar, this message translates to:
  /// **'الدفع عند الاستلام'**
  String get paymentCashOnDelivery;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'سلتك فارغة'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'أضف منتجات من المتاجر وستظهر هنا.'**
  String get cartEmptyMessage;

  /// No description provided for @cartVendorFallback.
  ///
  /// In ar, this message translates to:
  /// **'المتجر'**
  String get cartVendorFallback;

  /// No description provided for @cartLinesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} عناصر في السلة'**
  String cartLinesCount(int count);

  /// No description provided for @cartClear.
  ///
  /// In ar, this message translates to:
  /// **'تفريغ السلة'**
  String get cartClear;

  /// No description provided for @cartRemove.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get cartRemove;

  /// No description provided for @cartNoOptions.
  ///
  /// In ar, this message translates to:
  /// **'بدون خيارات'**
  String get cartNoOptions;

  /// No description provided for @cartPriceByServer.
  ///
  /// In ar, this message translates to:
  /// **'السعر يعتمد من التسعيرة'**
  String get cartPriceByServer;

  /// No description provided for @cartQty.
  ///
  /// In ar, this message translates to:
  /// **'الكمية: {qty}'**
  String cartQty(int qty);

  /// No description provided for @cartTotalNote.
  ///
  /// In ar, this message translates to:
  /// **'لا نعرض إجمالياً معتمداً قبل طلب التسعيرة. الخادم يسعّر كل سطر وخياراته.'**
  String get cartTotalNote;

  /// No description provided for @cartTotalLabel.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get cartTotalLabel;

  /// No description provided for @cartTotalLater.
  ///
  /// In ar, this message translates to:
  /// **'يُحسب في الخطوة التالية'**
  String get cartTotalLater;

  /// No description provided for @deliveryTitle.
  ///
  /// In ar, this message translates to:
  /// **'الاستلام والتوصيل'**
  String get deliveryTitle;

  /// No description provided for @deliveryPickup.
  ///
  /// In ar, this message translates to:
  /// **'الاستلام'**
  String get deliveryPickup;

  /// No description provided for @deliveryAddress.
  ///
  /// In ar, this message translates to:
  /// **'عنوان التوصيل'**
  String get deliveryAddress;

  /// No description provided for @deliveryChooseAddress.
  ///
  /// In ar, this message translates to:
  /// **'اختر العنوان'**
  String get deliveryChooseAddress;

  /// No description provided for @deliveryTime.
  ///
  /// In ar, this message translates to:
  /// **'موعد التوصيل'**
  String get deliveryTime;

  /// No description provided for @deliveryRequestQuote.
  ///
  /// In ar, this message translates to:
  /// **'طلب التسعيرة'**
  String get deliveryRequestQuote;

  /// No description provided for @scheduleNow.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get scheduleNow;

  /// No description provided for @schedulePick.
  ///
  /// In ar, this message translates to:
  /// **'تحديد موعد'**
  String get schedulePick;

  /// No description provided for @detailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل إضافية'**
  String get detailsTitle;

  /// No description provided for @detailsHint.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة ومرفقات اختيارية'**
  String get detailsHint;

  /// No description provided for @detailsAttachedCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} مرفقات'**
  String detailsAttachedCount(int count);

  /// No description provided for @detailsNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة عامة'**
  String get detailsNote;

  /// No description provided for @detailsNoteHint.
  ///
  /// In ar, this message translates to:
  /// **'اختياري، حتى 1000 حرف'**
  String get detailsNoteHint;

  /// No description provided for @attachTitle.
  ///
  /// In ar, this message translates to:
  /// **'المرفقات'**
  String get attachTitle;

  /// No description provided for @attachPick.
  ///
  /// In ar, this message translates to:
  /// **'اختر صورة للرفع'**
  String get attachPick;

  /// No description provided for @attachLimits.
  ///
  /// In ar, this message translates to:
  /// **'حتى {max} ملفات، الحد الأقصى 10MB للملف'**
  String attachLimits(int max);

  /// No description provided for @attachCamera.
  ///
  /// In ar, this message translates to:
  /// **'التقاط صورة'**
  String get attachCamera;

  /// No description provided for @attachGallery.
  ///
  /// In ar, this message translates to:
  /// **'من المعرض'**
  String get attachGallery;

  /// No description provided for @attachUploading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ رفع الملفات...'**
  String get attachUploading;

  /// No description provided for @uploadDone.
  ///
  /// In ar, this message translates to:
  /// **'تم الرفع'**
  String get uploadDone;

  /// No description provided for @addressPickerTitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر عنوان التوصيل'**
  String get addressPickerTitle;

  /// No description provided for @addressAddNew.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عنوان جديد'**
  String get addressAddNew;

  /// No description provided for @addressInsideZone.
  ///
  /// In ar, this message translates to:
  /// **'داخل منطقة الخدمة'**
  String get addressInsideZone;

  /// No description provided for @addressUse.
  ///
  /// In ar, this message translates to:
  /// **'استخدام هذا العنوان'**
  String get addressUse;

  /// No description provided for @addressNewTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عنوان'**
  String get addressNewTitle;

  /// No description provided for @addressLocating.
  ///
  /// In ar, this message translates to:
  /// **'نحدد موقعك...'**
  String get addressLocating;

  /// No description provided for @addressLocated.
  ///
  /// In ar, this message translates to:
  /// **'تم تحديد موقعك'**
  String get addressLocated;

  /// No description provided for @addressUseMyLocation.
  ///
  /// In ar, this message translates to:
  /// **'استخدام موقعي الحالي'**
  String get addressUseMyLocation;

  /// No description provided for @addressLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم العنوان'**
  String get addressLabel;

  /// No description provided for @addressLabelHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: المنزل'**
  String get addressLabelHint;

  /// No description provided for @addressLabelRequired.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسماً للعنوان'**
  String get addressLabelRequired;

  /// No description provided for @addressDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل إضافية'**
  String get addressDetails;

  /// No description provided for @addressDetailsHint.
  ///
  /// In ar, this message translates to:
  /// **'الشارع، المبنى، الطابق...'**
  String get addressDetailsHint;

  /// No description provided for @addressMakeDefault.
  ///
  /// In ar, this message translates to:
  /// **'تعيين كعنوان افتراضي'**
  String get addressMakeDefault;

  /// No description provided for @addressZoneNote.
  ///
  /// In ar, this message translates to:
  /// **'إذا كانت النقطة خارج منطقة الخدمة سيرفض الخادم حفظ العنوان.'**
  String get addressZoneNote;

  /// No description provided for @addressSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ العنوان'**
  String get addressSave;

  /// No description provided for @locationServiceOff.
  ///
  /// In ar, this message translates to:
  /// **'خدمة الموقع متوقفة. فعّلها ثم حاول مجدداً.'**
  String get locationServiceOff;

  /// No description provided for @locationDenied.
  ///
  /// In ar, this message translates to:
  /// **'نحتاج إذن الموقع لتحديد العنوان.'**
  String get locationDenied;

  /// No description provided for @locationDeniedForever.
  ///
  /// In ar, this message translates to:
  /// **'إذن الموقع مرفوض. فعّله من الإعدادات.'**
  String get locationDeniedForever;

  /// No description provided for @locationUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر الحصول على موقع حديث. حاول مرة أخرى.'**
  String get locationUnavailable;

  /// No description provided for @locationOpenSettings.
  ///
  /// In ar, this message translates to:
  /// **'فتح الإعدادات'**
  String get locationOpenSettings;

  /// No description provided for @locationAddressUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر معرفة اسم المدينة أو الشارع لهذا الموقع.'**
  String get locationAddressUnavailable;

  /// No description provided for @couponTitle.
  ///
  /// In ar, this message translates to:
  /// **'كوبون الخصم'**
  String get couponTitle;

  /// No description provided for @couponHint.
  ///
  /// In ar, this message translates to:
  /// **'أضف كوبوناً إن وجد'**
  String get couponHint;

  /// No description provided for @couponHero.
  ///
  /// In ar, this message translates to:
  /// **'خصمك يبدأ هنا'**
  String get couponHero;

  /// No description provided for @couponCodeLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز الكوبون'**
  String get couponCodeLabel;

  /// No description provided for @couponCodeHint.
  ///
  /// In ar, this message translates to:
  /// **'AMAR30'**
  String get couponCodeHint;

  /// No description provided for @couponCheck.
  ///
  /// In ar, this message translates to:
  /// **'تحقق'**
  String get couponCheck;

  /// No description provided for @couponCheckNote.
  ///
  /// In ar, this message translates to:
  /// **'التحقق يؤكد صلاحية الرمز فقط، وقيمة الخصم النهائية تظهر في التسعيرة.'**
  String get couponCheckNote;

  /// No description provided for @couponInvalidTitle.
  ///
  /// In ar, this message translates to:
  /// **'الكوبون غير صالح'**
  String get couponInvalidTitle;

  /// No description provided for @couponValidTitle.
  ///
  /// In ar, this message translates to:
  /// **'الكوبون صالح'**
  String get couponValidTitle;

  /// No description provided for @couponValidMessage.
  ///
  /// In ar, this message translates to:
  /// **'سيُرسل الرمز مع طلب التسعيرة ليحسب الخادم الخصم النهائي.'**
  String get couponValidMessage;

  /// No description provided for @couponValue.
  ///
  /// In ar, this message translates to:
  /// **'القيمة'**
  String get couponValue;

  /// No description provided for @couponMaxDiscount.
  ///
  /// In ar, this message translates to:
  /// **'أقصى خصم'**
  String get couponMaxDiscount;

  /// No description provided for @couponMinTotal.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأدنى للطلب'**
  String get couponMinTotal;

  /// No description provided for @couponUsesLeft.
  ///
  /// In ar, this message translates to:
  /// **'الاستخدامات المتبقية'**
  String get couponUsesLeft;

  /// No description provided for @couponExpires.
  ///
  /// In ar, this message translates to:
  /// **'ينتهي في'**
  String get couponExpires;

  /// No description provided for @couponApply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق الكوبون'**
  String get couponApply;

  /// No description provided for @couponRemove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة الكوبون {code}'**
  String couponRemove(String code);

  /// No description provided for @quoteTitle.
  ///
  /// In ar, this message translates to:
  /// **'التسعيرة'**
  String get quoteTitle;

  /// No description provided for @quoteValidFor.
  ///
  /// In ar, this message translates to:
  /// **'التسعيرة صالحة لمدة {time}'**
  String quoteValidFor(String time);

  /// No description provided for @quoteValidHint.
  ///
  /// In ar, this message translates to:
  /// **'بعد انتهاء المدة يلزم طلب تسعيرة جديدة.'**
  String get quoteValidHint;

  /// No description provided for @quoteDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل التسعيرة'**
  String get quoteDetailsTitle;

  /// No description provided for @quoteItemsTotal.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي المنتجات'**
  String get quoteItemsTotal;

  /// No description provided for @quoteDeliveryFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم التوصيل'**
  String get quoteDeliveryFee;

  /// No description provided for @quoteDiscount.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get quoteDiscount;

  /// No description provided for @quoteTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي النهائي'**
  String get quoteTotal;

  /// No description provided for @quoteDistance.
  ///
  /// In ar, this message translates to:
  /// **'المسافة'**
  String get quoteDistance;

  /// No description provided for @quoteReview.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة الطلب'**
  String get quoteReview;

  /// No description provided for @quoteExpiredTitle.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية التسعيرة'**
  String get quoteExpiredTitle;

  /// No description provided for @quoteUsedTitle.
  ///
  /// In ar, this message translates to:
  /// **'التسعيرة مستخدمة مسبقاً'**
  String get quoteUsedTitle;

  /// No description provided for @quoteExpiredMessage.
  ///
  /// In ar, this message translates to:
  /// **'الأسعار تتغير، اطلب تسعيرة جديدة للمتابعة.'**
  String get quoteExpiredMessage;

  /// No description provided for @quoteRefresh.
  ///
  /// In ar, this message translates to:
  /// **'طلب تسعيرة جديدة'**
  String get quoteRefresh;

  /// No description provided for @quoteBackToCart.
  ///
  /// In ar, this message translates to:
  /// **'العودة'**
  String get quoteBackToCart;

  /// No description provided for @reviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'مراجعة الطلب'**
  String get reviewTitle;

  /// No description provided for @reviewProducts.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get reviewProducts;

  /// No description provided for @reviewDeliveryPayment.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل والدفع'**
  String get reviewDeliveryPayment;

  /// No description provided for @reviewConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب · {total}'**
  String reviewConfirm(String total);

  /// No description provided for @placeFailedTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إنشاء الطلب'**
  String get placeFailedTitle;

  /// No description provided for @placingTitle.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ إنشاء طلبك'**
  String get placingTitle;

  /// No description provided for @placingMessage.
  ///
  /// In ar, this message translates to:
  /// **'لا تغلق التطبيق. لن يتكرر الطلب حتى لو أعدت المحاولة.'**
  String get placingMessage;

  /// No description provided for @successCaption.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الطلب'**
  String get successCaption;

  /// No description provided for @successTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبك في أيدٍ أمينة'**
  String get successTitle;

  /// No description provided for @successMessage.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك متابعة الحالة والتحديثات من صفحة طلباتي.'**
  String get successMessage;

  /// No description provided for @successOrderNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب'**
  String get successOrderNumber;

  /// No description provided for @successStatus.
  ///
  /// In ar, this message translates to:
  /// **'الحالة'**
  String get successStatus;

  /// No description provided for @successDeliverTo.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل إلى'**
  String get successDeliverTo;

  /// No description provided for @successTrack.
  ///
  /// In ar, this message translates to:
  /// **'تتبع الطلب'**
  String get successTrack;

  /// No description provided for @successBackHome.
  ///
  /// In ar, this message translates to:
  /// **'العودة للرئيسية'**
  String get successBackHome;

  /// No description provided for @orderStepOf.
  ///
  /// In ar, this message translates to:
  /// **'المرحلة {step} من {total}'**
  String orderStepOf(int step, int total);

  /// No description provided for @orderRoute.
  ///
  /// In ar, this message translates to:
  /// **'المسار'**
  String get orderRoute;

  /// No description provided for @orderPickup.
  ///
  /// In ar, this message translates to:
  /// **'الاستلام'**
  String get orderPickup;

  /// No description provided for @orderDropoff.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل'**
  String get orderDropoff;

  /// No description provided for @orderPlaceUnknown.
  ///
  /// In ar, this message translates to:
  /// **'غير محدد'**
  String get orderPlaceUnknown;

  /// No description provided for @orderDirections.
  ///
  /// In ar, this message translates to:
  /// **'الاتجاهات'**
  String get orderDirections;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get orderDetailsTitle;

  /// No description provided for @orderTimelineTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجل الطلب'**
  String get orderTimelineTitle;

  /// No description provided for @orderDeliveryCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز التسليم'**
  String get orderDeliveryCode;

  /// No description provided for @orderCancelledTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء الطلب'**
  String get orderCancelledTitle;

  /// No description provided for @offerPendingTitle.
  ///
  /// In ar, this message translates to:
  /// **'لديك عرض سعر بانتظار موافقتك'**
  String get offerPendingTitle;

  /// No description provided for @offerPendingMessage.
  ///
  /// In ar, this message translates to:
  /// **'راجع البنود ووافق أو ارفض العرض.'**
  String get offerPendingMessage;

  /// No description provided for @offerView.
  ///
  /// In ar, this message translates to:
  /// **'عرض السعر'**
  String get offerView;

  /// No description provided for @cancelOrder.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get cancelOrder;

  /// No description provided for @receiptTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإيصال'**
  String get receiptTitle;

  /// No description provided for @shareTitle.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة رابط التتبع'**
  String get shareTitle;

  /// No description provided for @rateTitle.
  ///
  /// In ar, this message translates to:
  /// **'تقييم الطلب'**
  String get rateTitle;

  /// No description provided for @trackingDriverRating.
  ///
  /// In ar, this message translates to:
  /// **'★ {rating}'**
  String trackingDriverRating(String rating);

  /// No description provided for @cancelHint.
  ///
  /// In ar, this message translates to:
  /// **'اختر سبب الإلغاء. لا يمكن التراجع بعد التأكيد.'**
  String get cancelHint;

  /// No description provided for @cancelNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة'**
  String get cancelNote;

  /// No description provided for @cancelSubmit.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الإلغاء'**
  String get cancelSubmit;

  /// No description provided for @cancelConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من إلغاء هذا الطلب؟'**
  String get cancelConfirm;

  /// No description provided for @offerClosed.
  ///
  /// In ar, this message translates to:
  /// **'تم التعامل مع هذا العرض.'**
  String get offerClosed;

  /// No description provided for @offerItemUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر'**
  String get offerItemUnavailable;

  /// No description provided for @offerApprove.
  ///
  /// In ar, this message translates to:
  /// **'الموافقة'**
  String get offerApprove;

  /// No description provided for @offerReject.
  ///
  /// In ar, this message translates to:
  /// **'رفض العرض'**
  String get offerReject;

  /// No description provided for @offerApproveConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل توافق على هذا العرض؟ سيبدأ تنفيذ الطلب.'**
  String get offerApproveConfirm;

  /// No description provided for @offerRejectConfirm.
  ///
  /// In ar, this message translates to:
  /// **'رفض العرض'**
  String get offerRejectConfirm;

  /// No description provided for @offerRejectReason.
  ///
  /// In ar, this message translates to:
  /// **'سبب الرفض (اختياري)'**
  String get offerRejectReason;

  /// No description provided for @offerSubstitute.
  ///
  /// In ar, this message translates to:
  /// **'بديل: {name} · {price}'**
  String offerSubstitute(String name, String price);

  /// No description provided for @offerExpires.
  ///
  /// In ar, this message translates to:
  /// **'ينتهي العرض {time}'**
  String offerExpires(String time);

  /// No description provided for @trackingEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد تتبع بعد'**
  String get trackingEmptyTitle;

  /// No description provided for @trackingEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'سيظهر التتبع عندما يستلم السائق طلبك.'**
  String get trackingEmptyMessage;

  /// No description provided for @trackingNoLocation.
  ///
  /// In ar, this message translates to:
  /// **'لم يشارك السائق موقعه بعد'**
  String get trackingNoLocation;

  /// No description provided for @trackingOpenMap.
  ///
  /// In ar, this message translates to:
  /// **'فتح في الخرائط'**
  String get trackingOpenMap;

  /// No description provided for @trackingNoDriver.
  ///
  /// In ar, this message translates to:
  /// **'لم يتم تعيين سائق بعد.'**
  String get trackingNoDriver;

  /// No description provided for @trackingNextUpdate.
  ///
  /// In ar, this message translates to:
  /// **'التحديث التالي'**
  String get trackingNextUpdate;

  /// No description provided for @trackingEta.
  ///
  /// In ar, this message translates to:
  /// **'الوصول المتوقع خلال {minutes} دقيقة'**
  String trackingEta(int minutes);

  /// No description provided for @trackingSeconds.
  ///
  /// In ar, this message translates to:
  /// **'{seconds} ث'**
  String trackingSeconds(int seconds);

  /// No description provided for @receiptDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get receiptDate;

  /// No description provided for @receiptDriver.
  ///
  /// In ar, this message translates to:
  /// **'السائق'**
  String get receiptDriver;

  /// No description provided for @rateDriver.
  ///
  /// In ar, this message translates to:
  /// **'كيف كانت تجربة التوصيل؟'**
  String get rateDriver;

  /// No description provided for @rateStore.
  ///
  /// In ar, this message translates to:
  /// **'تقييم المتجر (اختياري)'**
  String get rateStore;

  /// No description provided for @rateComment.
  ///
  /// In ar, this message translates to:
  /// **'تعليق'**
  String get rateComment;

  /// No description provided for @rateCommentHint.
  ///
  /// In ar, this message translates to:
  /// **'شاركنا رأيك (اختياري)'**
  String get rateCommentHint;

  /// No description provided for @rateSubmit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال التقييم'**
  String get rateSubmit;

  /// No description provided for @shareIntroTitle.
  ///
  /// In ar, this message translates to:
  /// **'شارك تتبع طلبك'**
  String get shareIntroTitle;

  /// No description provided for @shareIntroMessage.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ رابطاً مؤقتاً يتيح لأي شخص متابعة حالة الطلب دون تسجيل دخول.'**
  String get shareIntroMessage;

  /// No description provided for @shareCreate.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء رابط'**
  String get shareCreate;

  /// No description provided for @shareCopy.
  ///
  /// In ar, this message translates to:
  /// **'نسخ الرابط'**
  String get shareCopy;

  /// No description provided for @shareCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ الرابط'**
  String get shareCopied;

  /// No description provided for @shareRevoke.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الرابط'**
  String get shareRevoke;

  /// No description provided for @shareExpires.
  ///
  /// In ar, this message translates to:
  /// **'ينتهي الرابط {time}'**
  String shareExpires(String time);

  /// No description provided for @publicTrackingTitle.
  ///
  /// In ar, this message translates to:
  /// **'تتبع طلب'**
  String get publicTrackingTitle;

  /// No description provided for @publicTrackingLabel.
  ///
  /// In ar, this message translates to:
  /// **'رابط أو رمز التتبع'**
  String get publicTrackingLabel;

  /// No description provided for @publicTrackingHint.
  ///
  /// In ar, this message translates to:
  /// **'https://…/track/…'**
  String get publicTrackingHint;

  /// No description provided for @publicTrackingOpen.
  ///
  /// In ar, this message translates to:
  /// **'تتبع'**
  String get publicTrackingOpen;

  /// No description provided for @publicTrackingEta.
  ///
  /// In ar, this message translates to:
  /// **'الوصول المتوقع'**
  String get publicTrackingEta;

  /// No description provided for @publicTrackingUpdated.
  ///
  /// In ar, this message translates to:
  /// **'آخر تحديث'**
  String get publicTrackingUpdated;

  /// No description provided for @addressEditTitle.
  ///
  /// In ar, this message translates to:
  /// **'تعديل العنوان'**
  String get addressEditTitle;

  /// No description provided for @accountEditProfile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get accountEditProfile;

  /// No description provided for @accountEditProfileHint.
  ///
  /// In ar, this message translates to:
  /// **'الاسم، الصورة، واللغة'**
  String get accountEditProfileHint;

  /// No description provided for @accountAddresses.
  ///
  /// In ar, this message translates to:
  /// **'العناوين المحفوظة'**
  String get accountAddresses;

  /// No description provided for @accountTerms.
  ///
  /// In ar, this message translates to:
  /// **'الشروط وسياسة الخصوصية'**
  String get accountTerms;

  /// No description provided for @accountDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get accountDelete;

  /// No description provided for @accountDeleteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'سيتم حذف حسابك وبياناتك نهائياً. هل أنت متأكد؟'**
  String get accountDeleteConfirm;

  /// No description provided for @vendorApplyTitle.
  ///
  /// In ar, this message translates to:
  /// **'انضم كمتجر'**
  String get vendorApplyTitle;

  /// No description provided for @vendorApplyHint.
  ///
  /// In ar, this message translates to:
  /// **'قدّم طلب انضمام لمتجرك'**
  String get vendorApplyHint;

  /// No description provided for @supportTitle.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get supportTitle;

  /// No description provided for @commonSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get commonSave;

  /// No description provided for @addressesEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد عناوين محفوظة'**
  String get addressesEmpty;

  /// No description provided for @addressDefault.
  ///
  /// In ar, this message translates to:
  /// **'افتراضي'**
  String get addressDefault;

  /// No description provided for @addressDeleteConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد حذف هذا العنوان؟'**
  String get addressDeleteConfirm;

  /// No description provided for @vendorApplyIntro.
  ///
  /// In ar, this message translates to:
  /// **'عرّفنا بمتجرك وسيتواصل معك فريق عَمار لمراجعة الطلب.'**
  String get vendorApplyIntro;

  /// No description provided for @vendorApplyBusiness.
  ///
  /// In ar, this message translates to:
  /// **'اسم المتجر'**
  String get vendorApplyBusiness;

  /// No description provided for @vendorApplyBusinessHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: متجر الأمل'**
  String get vendorApplyBusinessHint;

  /// No description provided for @vendorApplyContact.
  ///
  /// In ar, this message translates to:
  /// **'اسم المسؤول'**
  String get vendorApplyContact;

  /// No description provided for @vendorApplyLocation.
  ///
  /// In ar, this message translates to:
  /// **'إرفاق موقعي الحالي'**
  String get vendorApplyLocation;

  /// No description provided for @vendorApplySubmit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الطلب'**
  String get vendorApplySubmit;

  /// No description provided for @vendorApplySentTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلبك'**
  String get vendorApplySentTitle;

  /// No description provided for @vendorApplySentMessage.
  ///
  /// In ar, this message translates to:
  /// **'سنراجع الطلب ونتواصل معك قريباً.'**
  String get vendorApplySentMessage;

  /// No description provided for @commonRequired.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحقل مطلوب'**
  String get commonRequired;

  /// No description provided for @supportCall.
  ///
  /// In ar, this message translates to:
  /// **'اتصل بالدعم'**
  String get supportCall;

  /// No description provided for @supportOrderIssue.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة في طلب'**
  String get supportOrderIssue;

  /// No description provided for @supportOrderIssueHint.
  ///
  /// In ar, this message translates to:
  /// **'افتح الطلب من طلباتي وتواصل مع السائق أو الدعم'**
  String get supportOrderIssueHint;

  /// No description provided for @driverLoginTitle.
  ///
  /// In ar, this message translates to:
  /// **'دخول السائقين'**
  String get driverLoginTitle;

  /// No description provided for @driverLoginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'استخدم رقم جوالك وكلمة المرور التي أعطتك إياها الإدارة.'**
  String get driverLoginSubtitle;

  /// No description provided for @driverPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get driverPassword;

  /// No description provided for @driverPasswordHint.
  ///
  /// In ar, this message translates to:
  /// **'أدخل كلمة المرور'**
  String get driverPasswordHint;

  /// No description provided for @driverLoginSubmit.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get driverLoginSubmit;

  /// No description provided for @driverIAmCustomer.
  ///
  /// In ar, this message translates to:
  /// **'لست سائقاً؟ دخول العملاء'**
  String get driverIAmCustomer;

  /// No description provided for @driverEntry.
  ///
  /// In ar, this message translates to:
  /// **'أنت سائق؟ سجّل دخولك من هنا'**
  String get driverEntry;

  /// No description provided for @driverCollect.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المطلوب تحصيله'**
  String get driverCollect;

  /// No description provided for @driverEarning.
  ///
  /// In ar, this message translates to:
  /// **'أرباحك'**
  String get driverEarning;

  /// No description provided for @driverLocationSending.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ إرسال موقعك...'**
  String get driverLocationSending;

  /// No description provided for @driverLocationOk.
  ///
  /// In ar, this message translates to:
  /// **'موقعك يُشارك بنجاح'**
  String get driverLocationOk;

  /// No description provided for @driverLocationPermission.
  ///
  /// In ar, this message translates to:
  /// **'نحتاج إذن الموقع للعمل'**
  String get driverLocationPermission;

  /// No description provided for @driverLocationPermissionHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط للسماح أو فتح الإعدادات'**
  String get driverLocationPermissionHint;

  /// No description provided for @driverLocationFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال الموقع، اضغط لإعادة المحاولة'**
  String get driverLocationFailed;

  /// No description provided for @driverLocationLast.
  ///
  /// In ar, this message translates to:
  /// **'آخر إرسال: {time}'**
  String driverLocationLast(String time);

  /// No description provided for @driverNavOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get driverNavOrders;

  /// No description provided for @driverNavWallet.
  ///
  /// In ar, this message translates to:
  /// **'الرصيد'**
  String get driverNavWallet;

  /// No description provided for @driverGreeting.
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير'**
  String get driverGreeting;

  /// No description provided for @driverOnline.
  ///
  /// In ar, this message translates to:
  /// **'متصل'**
  String get driverOnline;

  /// No description provided for @driverOffline.
  ///
  /// In ar, this message translates to:
  /// **'غير متصل'**
  String get driverOffline;

  /// No description provided for @driverOnlineHint.
  ///
  /// In ar, this message translates to:
  /// **'تستقبل الطلبات الآن'**
  String get driverOnlineHint;

  /// No description provided for @driverOfflineHint.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ يومك عند الاستعداد'**
  String get driverOfflineHint;

  /// No description provided for @driverGoOnline.
  ///
  /// In ar, this message translates to:
  /// **'بدء العمل'**
  String get driverGoOnline;

  /// No description provided for @driverGoOffline.
  ///
  /// In ar, this message translates to:
  /// **'إيقاف'**
  String get driverGoOffline;

  /// No description provided for @driverCurrentTask.
  ///
  /// In ar, this message translates to:
  /// **'المهمة الحالية'**
  String get driverCurrentTask;

  /// No description provided for @driverNoTask.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد مهمة حالية.'**
  String get driverNoTask;

  /// No description provided for @driverTodaySummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص اليوم'**
  String get driverTodaySummary;

  /// No description provided for @driverTodayOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات اليوم'**
  String get driverTodayOrders;

  /// No description provided for @driverTodayEarnings.
  ///
  /// In ar, this message translates to:
  /// **'أرباح اليوم'**
  String get driverTodayEarnings;

  /// No description provided for @driverAvailable.
  ///
  /// In ar, this message translates to:
  /// **'المتاحة'**
  String get driverAvailable;

  /// No description provided for @driverHistory.
  ///
  /// In ar, this message translates to:
  /// **'السجل'**
  String get driverHistory;

  /// No description provided for @driverNoAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات متاحة حالياً'**
  String get driverNoAvailable;

  /// No description provided for @driverNoHistory.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات سابقة'**
  String get driverNoHistory;

  /// No description provided for @driverOrderTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get driverOrderTitle;

  /// No description provided for @driverReject.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get driverReject;

  /// No description provided for @driverRejectConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد رفض هذا الطلب؟'**
  String get driverRejectConfirm;

  /// No description provided for @driverAlreadyTaken.
  ///
  /// In ar, this message translates to:
  /// **'الطلب أُسند لسائق آخر'**
  String get driverAlreadyTaken;

  /// No description provided for @driverCustomer.
  ///
  /// In ar, this message translates to:
  /// **'الزبون'**
  String get driverCustomer;

  /// No description provided for @driverDeliveredTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم بنجاح'**
  String get driverDeliveredTitle;

  /// No description provided for @driverDeliveredMessage.
  ///
  /// In ar, this message translates to:
  /// **'أُضيف {amount} إلى أرباحك.'**
  String driverDeliveredMessage(String amount);

  /// No description provided for @driverActionConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد: {action}؟'**
  String driverActionConfirm(String action);

  /// No description provided for @driverProofPhoto.
  ///
  /// In ar, this message translates to:
  /// **'صورة الإثبات'**
  String get driverProofPhoto;

  /// No description provided for @driverDeliveryCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز التسليم'**
  String get driverDeliveryCode;

  /// No description provided for @driverDeliveryCodeHint.
  ///
  /// In ar, this message translates to:
  /// **'اطلبه من الزبون'**
  String get driverDeliveryCodeHint;

  /// No description provided for @driverCashTitle.
  ///
  /// In ar, this message translates to:
  /// **'النقد بحوزتك'**
  String get driverCashTitle;

  /// No description provided for @driverCashLimit.
  ///
  /// In ar, this message translates to:
  /// **'الحد الأقصى'**
  String get driverCashLimit;

  /// No description provided for @driverCashRemaining.
  ///
  /// In ar, this message translates to:
  /// **'المتبقي قبل الحد'**
  String get driverCashRemaining;

  /// No description provided for @driverUnsettled.
  ///
  /// In ar, this message translates to:
  /// **'طلبات غير مسواة'**
  String get driverUnsettled;

  /// No description provided for @driverCashLimitReached.
  ///
  /// In ar, this message translates to:
  /// **'وصلت للحد الأقصى، سلّم النقد للإدارة لتستقبل طلبات جديدة.'**
  String get driverCashLimitReached;

  /// No description provided for @driverSettlements.
  ///
  /// In ar, this message translates to:
  /// **'التسويات'**
  String get driverSettlements;

  /// No description provided for @driverNoSettlements.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد تسويات بعد.'**
  String get driverNoSettlements;

  /// No description provided for @driverPeriodDay.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get driverPeriodDay;

  /// No description provided for @driverPeriodWeek.
  ///
  /// In ar, this message translates to:
  /// **'الأسبوع'**
  String get driverPeriodWeek;

  /// No description provided for @driverPeriodMonth.
  ///
  /// In ar, this message translates to:
  /// **'الشهر'**
  String get driverPeriodMonth;

  /// No description provided for @driverEarnings.
  ///
  /// In ar, this message translates to:
  /// **'الأرباح'**
  String get driverEarnings;

  /// No description provided for @driverEarningsHistory.
  ///
  /// In ar, this message translates to:
  /// **'سجل الأرباح'**
  String get driverEarningsHistory;

  /// No description provided for @driverProfileHint.
  ///
  /// In ar, this message translates to:
  /// **'اللغة، المركبة، والصورة'**
  String get driverProfileHint;

  /// No description provided for @driverVehicle.
  ///
  /// In ar, this message translates to:
  /// **'نوع المركبة'**
  String get driverVehicle;

  /// No description provided for @onboarding1Title.
  ///
  /// In ar, this message translates to:
  /// **'كل ما يحتاجه بيتك'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In ar, this message translates to:
  /// **'مواد بناء وكهرباء وأدوات من متاجر موثوقة، بأسعار واضحة وجودة مضمونة.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In ar, this message translates to:
  /// **'خدمات منزلية متميزة'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In ar, this message translates to:
  /// **'سباكة وكهرباء وتبريد وأكثر — احجز خدمتك بسهولة مع محترفين معتمدين.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In ar, this message translates to:
  /// **'توصيل سريع وموثوق'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In ar, this message translates to:
  /// **'تابع طلبك لحظة بلحظة واستلمه عند باب بيتك في الوقت المحدد.'**
  String get onboarding3Body;

  /// No description provided for @commonNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get commonNext;

  /// No description provided for @commonSkip.
  ///
  /// In ar, this message translates to:
  /// **'تخطّي'**
  String get commonSkip;

  /// No description provided for @commonSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريباً'**
  String get commonSoon;

  /// No description provided for @authSignupTitle.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك في عَمَار'**
  String get authSignupTitle;

  /// No description provided for @authSignupSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك خلال دقيقة وابدأ بتعمير بيتك.'**
  String get authSignupSubtitle;

  /// No description provided for @authLoginTitle.
  ///
  /// In ar, this message translates to:
  /// **'سعداء بعودتك'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك لمتابعة طلباتك.'**
  String get authLoginSubtitle;

  /// No description provided for @authTabSignup.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get authTabSignup;

  /// No description provided for @authTabLogin.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get authTabLogin;

  /// No description provided for @authNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get authNameLabel;

  /// No description provided for @authNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: سامي أحمد'**
  String get authNameHint;

  /// No description provided for @authSignupSubmit.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get authSignupSubmit;

  /// No description provided for @authLoginSubmit.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get authLoginSubmit;

  /// No description provided for @authDriverTitle.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت سائق؟'**
  String get authDriverTitle;

  /// No description provided for @authDriverSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك من هنا'**
  String get authDriverSubtitle;

  /// No description provided for @consentAgree.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على '**
  String get consentAgree;

  /// No description provided for @otpConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد رقم الجوال'**
  String get otpConfirmTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمزاً من 4 أرقام إلى '**
  String get otpSentTo;

  /// No description provided for @otpResendIn.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال بعد '**
  String get otpResendIn;

  /// No description provided for @otpResendAction.
  ///
  /// In ar, this message translates to:
  /// **'لم يصلك الرمز؟ أعد الإرسال'**
  String get otpResendAction;

  /// No description provided for @otpVerifyAction.
  ///
  /// In ar, this message translates to:
  /// **'تحقّق'**
  String get otpVerifyAction;

  /// No description provided for @profileCompleteTitle.
  ///
  /// In ar, this message translates to:
  /// **'أكمل ملفك الشخصي'**
  String get profileCompleteTitle;

  /// No description provided for @profileCompleteSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'خطوة أخيرة ليسهل على السائق والمتاجر التواصل معك.'**
  String get profileCompleteSubtitle;

  /// No description provided for @profileFullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'الاسم'**
  String get profileFullNameHint;

  /// No description provided for @locationTitle.
  ///
  /// In ar, this message translates to:
  /// **'أين نوصّل طلباتك؟'**
  String get locationTitle;

  /// No description provided for @locationSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك لنعرض لك المتاجر والخدمات القريبة منك.'**
  String get locationSubtitle;

  /// No description provided for @locationUseCurrent.
  ///
  /// In ar, this message translates to:
  /// **'استخدام موقعي الحالي'**
  String get locationUseCurrent;

  /// No description provided for @driverDesignTitle.
  ///
  /// In ar, this message translates to:
  /// **'دخول السائق'**
  String get driverDesignTitle;

  /// No description provided for @driverDesignSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك برقم جوالك وكلمة المرور التي زوّدتك بها عَمَار.'**
  String get driverDesignSubtitle;

  /// No description provided for @driverDesignPasswordHint.
  ///
  /// In ar, this message translates to:
  /// **'كلمة مرور السائق'**
  String get driverDesignPasswordHint;

  /// No description provided for @driverDesignCustomer.
  ///
  /// In ar, this message translates to:
  /// **'أنا زبون — العودة لتسجيل الدخول'**
  String get driverDesignCustomer;

  /// No description provided for @homeSetLocation.
  ///
  /// In ar, this message translates to:
  /// **'حدّد موقعك'**
  String get homeSetLocation;

  /// No description provided for @homeOrderHint.
  ///
  /// In ar, this message translates to:
  /// **'اضغط لمتابعة طلبك'**
  String get homeOrderHint;

  /// No description provided for @homeMostOrdered.
  ///
  /// In ar, this message translates to:
  /// **'الأكثر طلباً'**
  String get homeMostOrdered;

  /// No description provided for @homeStoresTitle.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر'**
  String get homeStoresTitle;

  /// No description provided for @homeCompaniesTitle.
  ///
  /// In ar, this message translates to:
  /// **'خدمات الشركات'**
  String get homeCompaniesTitle;

  /// No description provided for @homeProvidersEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد ما نعرضه هنا حالياً'**
  String get homeProvidersEmpty;

  /// No description provided for @promoTitle.
  ///
  /// In ar, this message translates to:
  /// **'خصم 15% على الصيانة'**
  String get promoTitle;

  /// No description provided for @promoSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'على أول حجز خدمة لك'**
  String get promoSubtitle;

  /// No description provided for @promoAction.
  ///
  /// In ar, this message translates to:
  /// **'احجز الآن'**
  String get promoAction;

  /// No description provided for @navCart.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get navCart;

  /// No description provided for @priceAfterInspection.
  ///
  /// In ar, this message translates to:
  /// **'بعد المعاينة'**
  String get priceAfterInspection;

  /// No description provided for @vendorTabServices.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get vendorTabServices;

  /// No description provided for @addressPickOnMap.
  ///
  /// In ar, this message translates to:
  /// **'تحديد على الخريطة'**
  String get addressPickOnMap;

  /// No description provided for @mapPickerTitle.
  ///
  /// In ar, this message translates to:
  /// **'حدّد الموقع على الخريطة'**
  String get mapPickerTitle;

  /// No description provided for @mapPickerConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الموقع'**
  String get mapPickerConfirm;

  /// No description provided for @serviceRequestAction.
  ///
  /// In ar, this message translates to:
  /// **'اطلب الخدمة'**
  String get serviceRequestAction;

  /// No description provided for @scheduleChoose.
  ///
  /// In ar, this message translates to:
  /// **'اختر الموعد'**
  String get scheduleChoose;

  /// No description provided for @paymentBankTransfer.
  ///
  /// In ar, this message translates to:
  /// **'تحويل بنكي'**
  String get paymentBankTransfer;

  /// No description provided for @serviceQuoteTitle.
  ///
  /// In ar, this message translates to:
  /// **'سعر الخدمة'**
  String get serviceQuoteTitle;

  /// No description provided for @serviceQuoteLabor.
  ///
  /// In ar, this message translates to:
  /// **'أجرة العمل'**
  String get serviceQuoteLabor;

  /// No description provided for @serviceQuoteTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get serviceQuoteTotal;

  /// No description provided for @serviceQuoteVisit.
  ///
  /// In ar, this message translates to:
  /// **'موعد الزيارة'**
  String get serviceQuoteVisit;

  /// No description provided for @serviceQuoteAccept.
  ///
  /// In ar, this message translates to:
  /// **'موافقة على السعر'**
  String get serviceQuoteAccept;

  /// No description provided for @serviceQuoteReject.
  ///
  /// In ar, this message translates to:
  /// **'رفض السعر'**
  String get serviceQuoteReject;

  /// No description provided for @serviceQuoteRejectConfirm.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد رفض هذا السعر؟'**
  String get serviceQuoteRejectConfirm;

  /// No description provided for @transferTitle.
  ///
  /// In ar, this message translates to:
  /// **'إرسال إشعار التحويل'**
  String get transferTitle;

  /// No description provided for @transferHint.
  ///
  /// In ar, this message translates to:
  /// **'حوّل المبلغ إلى الحساب التالي ثم ارفع صورة الإشعار.'**
  String get transferHint;

  /// No description provided for @transferBank.
  ///
  /// In ar, this message translates to:
  /// **'الجهة'**
  String get transferBank;

  /// No description provided for @transferHolder.
  ///
  /// In ar, this message translates to:
  /// **'صاحب الحساب'**
  String get transferHolder;

  /// No description provided for @transferAccount.
  ///
  /// In ar, this message translates to:
  /// **'رقم الحساب'**
  String get transferAccount;

  /// No description provided for @transferFixNeeded.
  ///
  /// In ar, this message translates to:
  /// **'يلزم تصحيح الإشعار'**
  String get transferFixNeeded;

  /// No description provided for @transferUpload.
  ///
  /// In ar, this message translates to:
  /// **'رفع صورة الإشعار'**
  String get transferUpload;

  /// No description provided for @failureAppSetup.
  ///
  /// In ar, this message translates to:
  /// **'التطبيق غير مهيأ بشكل صحيح. تواصل مع الدعم.'**
  String get failureAppSetup;

  /// No description provided for @failureDuplicateRequest.
  ///
  /// In ar, this message translates to:
  /// **'أُرسل هذا الطلب من قبل. حدّث الصفحة وتحقق منه.'**
  String get failureDuplicateRequest;

  /// No description provided for @failureQuoteChanged.
  ///
  /// In ar, this message translates to:
  /// **'أرسل المتجر سعراً جديداً. راجعه ثم وافق من جديد.'**
  String get failureQuoteChanged;

  /// No description provided for @failureNoQuoteYet.
  ///
  /// In ar, this message translates to:
  /// **'لم يحدد المتجر السعر بعد.'**
  String get failureNoQuoteYet;

  /// No description provided for @failureNotTransferOrder.
  ///
  /// In ar, this message translates to:
  /// **'هذا الطلب مدفوع نقداً ولا يحتاج إشعار تحويل.'**
  String get failureNotTransferOrder;

  /// No description provided for @failureServer.
  ///
  /// In ar, this message translates to:
  /// **'حدث خلل في الخادم. حاول مرة أخرى بعد قليل.'**
  String get failureServer;

  /// No description provided for @failureTemporary.
  ///
  /// In ar, this message translates to:
  /// **'عطل مؤقت. حاول مرة أخرى.'**
  String get failureTemporary;

  /// No description provided for @failureTimeout.
  ///
  /// In ar, this message translates to:
  /// **'استغرق الاتصال وقتاً طويلاً. تأكد من الإنترنت وحاول مرة أخرى.'**
  String get failureTimeout;

  /// No description provided for @failureSecureConnection.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إنشاء اتصال آمن بالخادم. تأكد من الشبكة وحاول مجدداً.'**
  String get failureSecureConnection;

  /// No description provided for @failureInvalidResponse.
  ///
  /// In ar, this message translates to:
  /// **'وصل رد غير متوقع من الخادم. حاول مرة أخرى لاحقاً.'**
  String get failureInvalidResponse;

  /// No description provided for @driverToggleOnline.
  ///
  /// In ar, this message translates to:
  /// **'تبديل الاتصال'**
  String get driverToggleOnline;

  /// No description provided for @driverLocationUpdating.
  ///
  /// In ar, this message translates to:
  /// **'جاري تحديث موقعك…'**
  String get driverLocationUpdating;

  /// No description provided for @driverLocationUpdated.
  ///
  /// In ar, this message translates to:
  /// **'موقعك محدّث'**
  String get driverLocationUpdated;

  /// No description provided for @driverHeroOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلبات'**
  String get driverHeroOrders;

  /// No description provided for @driverHeroHours.
  ///
  /// In ar, this message translates to:
  /// **'ساعات'**
  String get driverHeroHours;

  /// No description provided for @driverHeroRating.
  ///
  /// In ar, this message translates to:
  /// **'تقييم'**
  String get driverHeroRating;

  /// No description provided for @driverAvailableOrders.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات المتاحة'**
  String get driverAvailableOrders;

  /// No description provided for @driverNoAvailableTitle.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات متاحة'**
  String get driverNoAvailableTitle;

  /// No description provided for @driverNoAvailableHint.
  ///
  /// In ar, this message translates to:
  /// **'سيصلك إشعار عند وجود طلبات جديدة في منطقتك'**
  String get driverNoAvailableHint;

  /// No description provided for @driverNewBadge.
  ///
  /// In ar, this message translates to:
  /// **'جديد'**
  String get driverNewBadge;

  /// No description provided for @driverYourFee.
  ///
  /// In ar, this message translates to:
  /// **'أجرتك'**
  String get driverYourFee;

  /// No description provided for @driverAcceptOrder.
  ///
  /// In ar, this message translates to:
  /// **'قبول الطلب'**
  String get driverAcceptOrder;

  /// No description provided for @driverYourTask.
  ///
  /// In ar, this message translates to:
  /// **'مهمتك الحالية'**
  String get driverYourTask;

  /// No description provided for @driverInProgress.
  ///
  /// In ar, this message translates to:
  /// **'جارية'**
  String get driverInProgress;

  /// No description provided for @driverNextStep.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة التالية'**
  String get driverNextStep;

  /// No description provided for @driverContinueTask.
  ///
  /// In ar, this message translates to:
  /// **'متابعة المهمة'**
  String get driverContinueTask;

  /// No description provided for @driverOfflineTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل'**
  String get driverOfflineTitle;

  /// No description provided for @driverOfflineMessage.
  ///
  /// In ar, this message translates to:
  /// **'شغّل زر الاتصال بالأعلى لتستقبل الطلبات القريبة منك'**
  String get driverOfflineMessage;

  /// No description provided for @driverNowOnline.
  ///
  /// In ar, this message translates to:
  /// **'أنت متصل الآن'**
  String get driverNowOnline;

  /// No description provided for @driverNowOffline.
  ///
  /// In ar, this message translates to:
  /// **'تم إيقاف العمل'**
  String get driverNowOffline;

  /// No description provided for @driverCashAmount.
  ///
  /// In ar, this message translates to:
  /// **'نقداً {amount}'**
  String driverCashAmount(String amount);

  /// No description provided for @driverYesterday.
  ///
  /// In ar, this message translates to:
  /// **'أمس'**
  String get driverYesterday;

  /// No description provided for @driverCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة'**
  String get driverCompleted;

  /// No description provided for @driverCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغية'**
  String get driverCancelled;

  /// No description provided for @driverFilterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get driverFilterAll;

  /// No description provided for @driverFilterCompleted.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get driverFilterCompleted;

  /// No description provided for @driverFilterCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغي'**
  String get driverFilterCancelled;

  /// No description provided for @driverCashDue.
  ///
  /// In ar, this message translates to:
  /// **'يجب التسوية'**
  String get driverCashDue;

  /// No description provided for @driverNoCash.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد نقد'**
  String get driverNoCash;

  /// No description provided for @driverHandCash.
  ///
  /// In ar, this message translates to:
  /// **'سلّم النقد للإدارة قبل نهاية اليوم'**
  String get driverHandCash;

  /// No description provided for @driverTotalEarnings.
  ///
  /// In ar, this message translates to:
  /// **'إجمالي الأرباح'**
  String get driverTotalEarnings;

  /// No description provided for @driverTransactions.
  ///
  /// In ar, this message translates to:
  /// **'المعاملات'**
  String get driverTransactions;

  /// No description provided for @driverCashSettlement.
  ///
  /// In ar, this message translates to:
  /// **'تسوية نقدية'**
  String get driverCashSettlement;

  /// No description provided for @driverLicenseVehicle.
  ///
  /// In ar, this message translates to:
  /// **'الرخصة والمركبة'**
  String get driverLicenseVehicle;

  /// No description provided for @driverEditProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف'**
  String get driverEditProfile;

  /// No description provided for @driverLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get driverLanguage;

  /// No description provided for @driverVehicleMotorcycle.
  ///
  /// In ar, this message translates to:
  /// **'دراجة نارية'**
  String get driverVehicleMotorcycle;

  /// No description provided for @driverVehicleCar.
  ///
  /// In ar, this message translates to:
  /// **'سيارة'**
  String get driverVehicleCar;

  /// No description provided for @driverVehicleBicycle.
  ///
  /// In ar, this message translates to:
  /// **'دراجة هوائية'**
  String get driverVehicleBicycle;

  /// No description provided for @driverVehicleVan.
  ///
  /// In ar, this message translates to:
  /// **'فان'**
  String get driverVehicleVan;

  /// No description provided for @driverVehicleTukTuk.
  ///
  /// In ar, this message translates to:
  /// **'توك توك'**
  String get driverVehicleTukTuk;

  /// No description provided for @driverVehicleOnFoot.
  ///
  /// In ar, this message translates to:
  /// **'سيراً على الأقدام'**
  String get driverVehicleOnFoot;

  /// No description provided for @driverCashLimitValue.
  ///
  /// In ar, this message translates to:
  /// **'حد النقد {amount}'**
  String driverCashLimitValue(String amount);

  /// No description provided for @driverOrdersCount.
  ///
  /// In ar, this message translates to:
  /// **'الطلبات: {count}'**
  String driverOrdersCount(String count);

  /// No description provided for @driverAccountSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سائق عَمَار · {phone}'**
  String driverAccountSubtitle(String phone);

  /// No description provided for @driverHintAccepted.
  ///
  /// In ar, this message translates to:
  /// **'توجّه إلى المتجر لاستلام الطلب'**
  String get driverHintAccepted;

  /// No description provided for @driverHintPickedUp.
  ///
  /// In ar, this message translates to:
  /// **'توجّه إلى عنوان العميل'**
  String get driverHintPickedUp;

  /// No description provided for @driverHintOnTheWay.
  ///
  /// In ar, this message translates to:
  /// **'في طريقك للعميل'**
  String get driverHintOnTheWay;

  /// No description provided for @driverHintArrived.
  ///
  /// In ar, this message translates to:
  /// **'سلّم الطلب للعميل'**
  String get driverHintArrived;

  /// No description provided for @driverTakePhoto.
  ///
  /// In ar, this message translates to:
  /// **'التقط صورة للطلب'**
  String get driverTakePhoto;

  /// No description provided for @driverPhotoAttached.
  ///
  /// In ar, this message translates to:
  /// **'تم إرفاق الصورة'**
  String get driverPhotoAttached;

  /// No description provided for @driverAskCode.
  ///
  /// In ar, this message translates to:
  /// **'اطلب من العميل رمز التسليم'**
  String get driverAskCode;

  /// No description provided for @driverMessage.
  ///
  /// In ar, this message translates to:
  /// **'رسالة'**
  String get driverMessage;

  /// No description provided for @driverCall.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get driverCall;

  /// No description provided for @driverStore.
  ///
  /// In ar, this message translates to:
  /// **'المتجر'**
  String get driverStore;

  /// No description provided for @driverOrderDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get driverOrderDetails;

  /// No description provided for @driverContactSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'{role} · {order}'**
  String driverContactSubtitle(String role, String order);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
