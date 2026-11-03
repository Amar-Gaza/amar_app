// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get statusAwaitingPayment => 'Awaiting payment';

  @override
  String get statusAwaitingPricing => 'Waiting for a price';

  @override
  String get statusPaymentReview => 'Payment review';

  @override
  String get statusPriced => 'Priced';

  @override
  String get statusAwaitingVendor => 'Waiting for the store';

  @override
  String get statusPreparing => 'Being prepared';

  @override
  String get statusPending => 'Waiting for a driver';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusPickedUp => 'Picked up';

  @override
  String get statusOnTheWay => 'On the way';

  @override
  String get statusArrived => 'Driver arrived';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusServiceRequested => 'Service requested';

  @override
  String get statusServiceInspection => 'Waiting for the store\'s price';

  @override
  String get statusServiceQuoted => 'Price sent';

  @override
  String get statusServiceScheduled => 'Visit scheduled';

  @override
  String get statusTechnicianOnWay => 'Technician on the way';

  @override
  String get statusServiceInProgress => 'Work in progress';

  @override
  String get statusServiceCompleted => 'Service completed';

  @override
  String get actionAwaitingVendorToPreparingVendor => 'Accept order';

  @override
  String get actionAwaitingPricingToPricedAdmin => 'Send offer';

  @override
  String get actionPreparingToPendingVendor => 'Ready for pickup';

  @override
  String get actionPendingToAcceptedDriver => 'Accept order';

  @override
  String get actionServiceRequestedToServiceScheduledVendor =>
      'Accept the request';

  @override
  String get actionServiceInspectionToServiceQuotedVendor => 'Send the price';

  @override
  String get actionServiceQuotedToServiceScheduledUser => 'Accept the price';

  @override
  String get actionServiceScheduledToTechnicianOnWayVendor =>
      'Technician on the way';

  @override
  String get actionTechnicianOnWayToServiceInProgressVendor => 'Start the work';

  @override
  String get actionServiceInProgressToServiceCompletedVendor =>
      'Complete the service';

  @override
  String get actionPaymentReviewToPendingAdmin => 'Approve payment';

  @override
  String get actionAwaitingPaymentToPaymentReviewUser =>
      'Send transfer receipt';

  @override
  String get actionPaymentReviewToPendingVendor => 'Approve payment';

  @override
  String get actionPricedToAwaitingPaymentUser => 'Approve the price and pay';

  @override
  String get actionServiceQuotedToAwaitingPaymentUser => 'Accept the price';

  @override
  String get actionPaymentReviewToServiceRequestedAdmin => 'Approve payment';

  @override
  String get actionPaymentReviewToServiceRequestedVendor => 'Approve payment';

  @override
  String get actionPaymentReviewToServiceScheduledAdmin => 'Approve payment';

  @override
  String get actionPaymentReviewToServiceScheduledVendor => 'Approve payment';

  @override
  String get actionAcceptedToPickedUpDriver => 'Picked up';

  @override
  String get confirmAcceptedToPickedUpDriver => 'Did you pick up the order?';

  @override
  String get actionPaymentReviewToAwaitingPaymentAdmin =>
      'Ask for a new receipt';

  @override
  String get actionPaymentReviewToAwaitingPaymentVendor =>
      'Ask for a new receipt';

  @override
  String get actionPickedUpToOnTheWayDriver => 'Head to customer';

  @override
  String get actionOnTheWayToArrivedDriver => 'I\'ve arrived';

  @override
  String get actionArrivedToDeliveredDriver => 'Complete delivery';

  @override
  String get confirmArrivedToDeliveredDriver =>
      'Confirm the customer received the order';

  @override
  String get actionPendingToCancelledUser => 'Cancel order';

  @override
  String get actionAwaitingVendorToCancelledUser => 'Cancel order';

  @override
  String get actionPreparingToCancelledUser => 'Cancel order';

  @override
  String get actionAwaitingPricingToCancelledUser => 'Cancel order';

  @override
  String get actionServiceQuotedToCancelledUser => 'Reject the price';

  @override
  String get actionServiceRequestedToCancelledVendor => 'Decline the request';

  @override
  String get actionServiceInspectionToCancelledVendor => 'Decline the request';

  @override
  String get actionServiceScheduledToCancelledVendor => 'Cancel the visit';

  @override
  String get actionAcceptedToCancelledUser => 'Cancel order';

  @override
  String get actionAwaitingVendorToCancelledVendor => 'Reject order';

  @override
  String get actionAwaitingPricingToCancelledVendor => 'Reject order';

  @override
  String get actionPricedToCancelledVendor => 'Reject order';

  @override
  String get actionPricedToCancelledUser => 'Reject offer';

  @override
  String get cancelReasonUserChangedMind => 'I changed my mind';

  @override
  String get cancelReasonUserWrongAddress => 'Wrong address';

  @override
  String get cancelReasonUserTooSlow => 'Taking too long';

  @override
  String get cancelReasonUserOther => 'Other reason';

  @override
  String get cancelReasonAdminCustomerRequest => 'Customer request';

  @override
  String get cancelReasonAdminNoDriver => 'No driver available';

  @override
  String get cancelReasonAdminOther => 'Other reason';

  @override
  String get errorMissingProjectKey => 'The X-Project-Key header is required';

  @override
  String get errorInvalidProjectKey =>
      'The project key is invalid or has been revoked';

  @override
  String get errorUnauthenticated => 'Please sign in to continue';

  @override
  String get errorOtpInvalid => 'The verification code is incorrect';

  @override
  String get errorOtpExpired => 'The verification code has expired';

  @override
  String get errorForbidden => 'You are not allowed to do this';

  @override
  String get errorModuleDisabled =>
      'This feature is not enabled for this project';

  @override
  String get errorProjectFrozen => 'This project is frozen';

  @override
  String get errorProjectInactive => 'This project is not active yet';

  @override
  String get errorUserBlocked => 'This account has been blocked';

  @override
  String get errorNotFound => 'The requested item was not found';

  @override
  String get errorMethodNotAllowed => 'This HTTP method is not allowed here';

  @override
  String get errorAlreadyTaken => 'Someone else took this first';

  @override
  String get errorConflict => 'The request conflicts with the current state';

  @override
  String get errorBidClosed => 'Bidding on this request is closed';

  @override
  String get errorIdempotencyMismatch =>
      'This Idempotency-Key was already used with a different request';

  @override
  String get errorQuoteExpired =>
      'The price quote has expired, please request a new one';

  @override
  String get errorQuoteUsed => 'This price quote was already used';

  @override
  String get errorValidationFailed => 'Some fields are invalid';

  @override
  String get errorInvalidTransition => 'This status change is not allowed now';

  @override
  String get errorOutOfZone => 'This location is outside the service area';

  @override
  String get errorOutOfStock => 'Not enough stock';

  @override
  String get errorSlotFull => 'This delivery window is full';

  @override
  String get errorCashLimitReached =>
      'Cash on hand limit reached; settle first';

  @override
  String get errorVendorClosed => 'The store is closed right now';

  @override
  String get errorAppUpdateRequired => 'Please update the app to continue';

  @override
  String get errorTooManyRequests => 'Too many requests, please slow down';

  @override
  String get errorServerError => 'Something went wrong on our side';

  @override
  String get errorMaintenance => 'The service is under maintenance';

  @override
  String get errorChaosInjected =>
      'Temporary failure (chaos mode), please retry';

  @override
  String get splashTagline => 'Built with our own hands';

  @override
  String get onboardingTitle => 'Trusted home services, made easy';

  @override
  String get onboardingSubtitle =>
      'From cleaning and maintenance to plumbing, electrical and more.';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get phoneTitle => 'Welcome to Amar';

  @override
  String get phoneSubtitle =>
      'Enter your mobile number and we will send you a code to verify it.';

  @override
  String get phoneHint => '59 123 4567';

  @override
  String get phoneSend => 'Send verification code';

  @override
  String get otpTitle => 'Enter the verification code';

  @override
  String get otpResend => 'Resend code';

  @override
  String get otpChangePhone => 'Change number';

  @override
  String get otpVerify => 'Verify and continue';

  @override
  String get otpExpiredTitle => 'The code has expired';

  @override
  String get otpExpiredHint =>
      'Request a new code to continue and sign in securely.';

  @override
  String get profileTitle => 'What should we call you?';

  @override
  String get profileSubtitle => 'Help us personalize your Amar experience.';

  @override
  String get profileNameLabel => 'Name';

  @override
  String get profileNameHint => 'Type your name';

  @override
  String get profileContinue => 'Save and get started';

  @override
  String get homeGreetingGuest => 'Welcome';

  @override
  String get homeCategoriesTitle => 'What do you need today?';

  @override
  String get homeCategoriesSubtitle => 'Trusted home services';

  @override
  String get homeLogout => 'Sign out';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonLoading => 'Please wait a moment';

  @override
  String get commonOfflineTitle => 'Cannot reach the service';

  @override
  String get commonOfflineHint =>
      'Check your internet connection and try again';

  @override
  String get commonGenericError => 'An unexpected error occurred';

  @override
  String get logoutDialogMessage => 'Do you want to sign out of your account?';

  @override
  String get validationPhoneInvalid => 'The phone number is invalid';

  @override
  String get validationNameInvalid => 'The name must be at least 2 characters';

  @override
  String get validationOtpIncomplete => 'Enter the full code';

  @override
  String get brandName => 'Amar';

  @override
  String get splashFooter => 'Amar · Everything your home needs';

  @override
  String get configLoadingTitle => 'Preparing your experience';

  @override
  String get configLoadingMessage =>
      'Loading app settings and available services...';

  @override
  String get configStepVersion => 'Checking the app version';

  @override
  String get configStepSettings => 'Loading Amar settings';

  @override
  String get configStepModules => 'Preparing modules and services';

  @override
  String get languageToggle => 'ع';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get phoneLabel => 'Mobile number';

  @override
  String get phoneHelper => 'Enter your number without the country code';

  @override
  String get consentPrefix => 'By continuing, you agree to the ';

  @override
  String get consentTerms => 'Terms & Conditions';

  @override
  String get consentAnd => ' and ';

  @override
  String get consentPrivacy => 'Privacy Policy';

  @override
  String get otpScreenTitle => 'Verify your number';

  @override
  String get otpResendWithin => 'Resend in';

  @override
  String get otpTryAgain => 'Try again';

  @override
  String get otpSendNew => 'Send a new code';

  @override
  String get otpUseDifferentNumber => 'Use a different number';

  @override
  String get otpInvalidTitle => 'Incorrect code';

  @override
  String get otpInvalidMessage =>
      'Check the code and try again. You have a limited number of attempts.';

  @override
  String get otpInvalidBannerTitle => 'Verification failed';

  @override
  String get authLoadingTitle => 'Signing you in';

  @override
  String get authLoadingMessage =>
      'Checking the code and preparing your account...';

  @override
  String get authLoadingStep => 'Verifying identity';

  @override
  String get authLoadingKeepOpen => 'Please keep the app open';

  @override
  String get profileScreenTitle => 'Complete your profile';

  @override
  String get profileStepLabel => 'Last step';

  @override
  String get profileLanguageLabel => 'App language';

  @override
  String get navHome => 'Home';

  @override
  String get navOrders => 'My orders';

  @override
  String get navNotifications => 'Notifications';

  @override
  String get navAccount => 'Account';

  @override
  String get homeSearchHint => 'Search for a service, product or store';

  @override
  String get homeVendorsTitle => 'Suggested providers';

  @override
  String get homeVendorsSubtitle => 'Picked for you';

  @override
  String get homeProductsTitle => 'Popular products';

  @override
  String get homeProductsSubtitle => 'Most ordered';

  @override
  String get homeEmptyTitle => 'No services available yet';

  @override
  String get homeEmptyMessage =>
      'Services will appear here as soon as they are available.';

  @override
  String get vendorOpenNow => 'Open now';

  @override
  String get vendorClosedNow => 'Closed';

  @override
  String get ordersEmptyTitle => 'No orders yet';

  @override
  String get ordersEmptyMessage =>
      'Start exploring Amar services and your orders will show up here.';

  @override
  String get ordersExplore => 'Explore services';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptyMessage =>
      'Order updates and new offers will appear here.';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonErrorTitle => 'Something went wrong';

  @override
  String get commonContactSupport => 'Contact support';

  @override
  String get stateOfflineTitle => 'You are offline';

  @override
  String get stateOfflineMessage =>
      'Check your internet connection and try again.';

  @override
  String get stateOfflineFootnote =>
      'We will reload the latest content once you are back online.';

  @override
  String get stateOfflineBanner => 'No internet connection';

  @override
  String get stateUnavailableTitle => 'Service unavailable';

  @override
  String get stateUnavailableMessage =>
      'We could not complete your request. Please try again shortly.';

  @override
  String get stateErrorTitle => 'One moment';

  @override
  String get stateSupportReference => 'Support reference';

  @override
  String get stateLoadingContent => 'Loading content';

  @override
  String orderCode(String code) {
    return 'Order #$code';
  }

  @override
  String orderItemsCount(int count) {
    return '$count items';
  }

  @override
  String get ordersScopeActive => 'Active';

  @override
  String get ordersScopeCompleted => 'Completed';

  @override
  String get ordersScopeCancelled => 'Cancelled';

  @override
  String get notificationsReadAll => 'Mark all as read';

  @override
  String get homeActiveOrderTitle => 'Your current order';

  @override
  String get commonViewAll => 'View all';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartAdd => 'Add to cart';

  @override
  String cartAddCount(int count) {
    return 'Add $count to cart';
  }

  @override
  String get cartAdded => 'Added to cart';

  @override
  String get cartOtherVendorMessage =>
      'Your cart has items from another store. Clear it and start with this product?';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search for a product or service';

  @override
  String get searchIdleTitle => 'What are you looking for?';

  @override
  String get searchIdleMessage =>
      'Type a product or service name, then search.';

  @override
  String get searchResultsTitle => 'Search results';

  @override
  String resultsCount(int count) {
    return '$count results';
  }

  @override
  String get searchEmptyTitle => 'No results found';

  @override
  String get searchEmptyMessage =>
      'Try a shorter word or browse the categories.';

  @override
  String get searchBrowseCategories => 'Browse categories';

  @override
  String get searchClear => 'Clear search';

  @override
  String get categoriesTitle => 'All categories';

  @override
  String get categoriesSearchHint => 'Search categories';

  @override
  String get categoriesEmpty => 'No matching categories';

  @override
  String categoryProductsCount(int count) {
    return '$count products';
  }

  @override
  String get vendorsTitle => 'Stores';

  @override
  String get vendorsEmpty => 'No stores available yet';

  @override
  String vendorRating(String average, int count) {
    return '$average ($count)';
  }

  @override
  String vendorRatingsCount(int count) {
    return '$count ratings';
  }

  @override
  String vendorDistance(String km) {
    return '$km km';
  }

  @override
  String get vendorDistanceLabel => 'from you';

  @override
  String vendorPrepMinutes(int minutes) {
    return 'Ready in $minutes min';
  }

  @override
  String vendorMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get vendorPrepLabel => 'Prep time';

  @override
  String get vendorAddress => 'Address';

  @override
  String get vendorAddressUnknown => 'The store has not added an address yet';

  @override
  String get vendorTabProducts => 'Products';

  @override
  String get vendorTabHours => 'Hours';

  @override
  String get vendorTabAbout => 'About';

  @override
  String get vendorNoDescription => 'This store has no description yet.';

  @override
  String get vendorHoursTitle => 'Opening hours';

  @override
  String get vendorHoursUnknown => 'The store has not set its hours.';

  @override
  String get vendorDayClosed => 'Closed';

  @override
  String get vendorToday => 'Today';

  @override
  String get vendorOpenTitle => 'The store is open';

  @override
  String get vendorClosedTitle => 'The store is closed';

  @override
  String get vendorClosedHint => 'Check the opening hours below.';

  @override
  String get productsSearchHint => 'Search products';

  @override
  String productsCount(int count) {
    return '$count products';
  }

  @override
  String get productsEmpty => 'No products here yet';

  @override
  String get productAvailable => 'In stock';

  @override
  String get productUnavailable => 'Unavailable';

  @override
  String get productUnavailableNow => 'Currently unavailable';

  @override
  String get productVendor => 'Store';

  @override
  String get productCategory => 'Category';

  @override
  String get productIndicativePrice =>
      'Indicative price, confirmed by the server';

  @override
  String get productPriceAfterInspection => 'Final price after inspection';

  @override
  String get productOptionsTitle => 'Product options';

  @override
  String get productOptionsHint => 'Choose the required specifications';

  @override
  String get productOutOfStockTitle => 'Out of stock';

  @override
  String get productOutOfStockMessage =>
      'It can be added once it is back in stock.';

  @override
  String get productAlternatives => 'Explore alternatives';

  @override
  String get productOptionsScreenTitle => 'Choose options';

  @override
  String productBasePrice(String price) {
    return 'Base price: $price';
  }

  @override
  String get optionSingle => 'Choose one';

  @override
  String get optionMulti => 'Choose any';

  @override
  String get optionRequired => 'Required';

  @override
  String get optionOptional => 'Optional';

  @override
  String optionExtraPrice(String price) {
    return '+$price';
  }

  @override
  String get optionsContinue => 'Continue to quantity';

  @override
  String get quantityTitle => 'Quantity';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get quantityServerPriced => 'Repriced by the server';

  @override
  String quantityStock(int count) {
    return 'In stock: $count';
  }

  @override
  String get quantityStockHint => 'You cannot exceed the available stock.';

  @override
  String get quantityPriceNote =>
      'Prices are indicative; the server calculates the final price at quote time.';

  @override
  String get commonContinue => 'Continue';

  @override
  String get checkoutStepCart => 'Cart';

  @override
  String get checkoutStepDelivery => 'Delivery';

  @override
  String get checkoutStepQuote => 'Quote';

  @override
  String get checkoutStepConfirm => 'Confirm';

  @override
  String get checkoutPayment => 'Payment method';

  @override
  String get paymentCashOnDelivery => 'Cash on delivery';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyMessage =>
      'Add products from the stores and they will appear here.';

  @override
  String get cartVendorFallback => 'Store';

  @override
  String cartLinesCount(int count) {
    return '$count items in the cart';
  }

  @override
  String get cartClear => 'Clear cart';

  @override
  String get cartRemove => 'Remove';

  @override
  String get cartNoOptions => 'No options';

  @override
  String get cartPriceByServer => 'Price confirmed by the quote';

  @override
  String cartQty(int qty) {
    return 'Qty: $qty';
  }

  @override
  String get cartTotalNote =>
      'No confirmed total before the quote. The server prices every line and option.';

  @override
  String get cartTotalLabel => 'Total';

  @override
  String get cartTotalLater => 'Calculated next';

  @override
  String get deliveryTitle => 'Pickup and delivery';

  @override
  String get deliveryPickup => 'Pickup';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get deliveryChooseAddress => 'Choose address';

  @override
  String get deliveryTime => 'Delivery time';

  @override
  String get deliveryRequestQuote => 'Get a quote';

  @override
  String get scheduleNow => 'Now';

  @override
  String get schedulePick => 'Pick a time';

  @override
  String get detailsTitle => 'Additional details';

  @override
  String get detailsHint => 'Optional note and attachments';

  @override
  String detailsAttachedCount(int count) {
    return '$count attachments';
  }

  @override
  String get detailsNote => 'General note';

  @override
  String get detailsNoteHint => 'Optional, up to 1000 characters';

  @override
  String get attachTitle => 'Attachments';

  @override
  String get attachPick => 'Choose a photo to upload';

  @override
  String attachLimits(int max) {
    return 'Up to $max files, 10MB each';
  }

  @override
  String get attachCamera => 'Take a photo';

  @override
  String get attachGallery => 'From gallery';

  @override
  String get attachUploading => 'Uploading files...';

  @override
  String get uploadDone => 'Uploaded';

  @override
  String get addressPickerTitle => 'Choose delivery address';

  @override
  String get addressAddNew => 'Add a new address';

  @override
  String get addressInsideZone => 'Inside the service area';

  @override
  String get addressUse => 'Use this address';

  @override
  String get addressNewTitle => 'Add address';

  @override
  String get addressLocating => 'Finding your location...';

  @override
  String get addressLocated => 'Location found';

  @override
  String get addressUseMyLocation => 'Use my current location';

  @override
  String get addressLabel => 'Address name';

  @override
  String get addressLabelHint => 'e.g. Home';

  @override
  String get addressLabelRequired => 'Enter a name for the address';

  @override
  String get addressDetails => 'More details';

  @override
  String get addressDetailsHint => 'Street, building, floor...';

  @override
  String get addressMakeDefault => 'Set as default';

  @override
  String get addressZoneNote =>
      'Addresses outside the service area are rejected by the server.';

  @override
  String get addressSave => 'Save address';

  @override
  String get locationServiceOff =>
      'Location services are off. Turn them on and try again.';

  @override
  String get locationDenied =>
      'We need location permission to set the address.';

  @override
  String get locationDeniedForever =>
      'Location permission is blocked. Enable it in settings.';

  @override
  String get locationOpenSettings => 'Open settings';

  @override
  String get couponTitle => 'Discount coupon';

  @override
  String get couponHint => 'Add a coupon if you have one';

  @override
  String get couponHero => 'Your discount starts here';

  @override
  String get couponCodeLabel => 'Coupon code';

  @override
  String get couponCodeHint => 'AMAR30';

  @override
  String get couponCheck => 'Check';

  @override
  String get couponCheckNote =>
      'Checking only confirms the code; the final discount shows in the quote.';

  @override
  String get couponInvalidTitle => 'Invalid coupon';

  @override
  String get couponValidTitle => 'Coupon is valid';

  @override
  String get couponValidMessage =>
      'The code is sent with the quote so the server applies the final discount.';

  @override
  String get couponValue => 'Value';

  @override
  String get couponMaxDiscount => 'Max discount';

  @override
  String get couponMinTotal => 'Minimum order';

  @override
  String get couponUsesLeft => 'Uses left';

  @override
  String get couponExpires => 'Expires';

  @override
  String get couponApply => 'Apply coupon';

  @override
  String couponRemove(String code) {
    return 'Remove coupon $code';
  }

  @override
  String get quoteTitle => 'Quote';

  @override
  String quoteValidFor(String time) {
    return 'Quote valid for $time';
  }

  @override
  String get quoteValidHint => 'After it expires you need a new quote.';

  @override
  String get quoteDetailsTitle => 'Price details';

  @override
  String get quoteItemsTotal => 'Items total';

  @override
  String get quoteDeliveryFee => 'Delivery fee';

  @override
  String get quoteDiscount => 'Discount';

  @override
  String get quoteTotal => 'Total';

  @override
  String get quoteDistance => 'Distance';

  @override
  String get quoteReview => 'Review order';

  @override
  String get quoteExpiredTitle => 'The quote has expired';

  @override
  String get quoteUsedTitle => 'The quote was already used';

  @override
  String get quoteExpiredMessage =>
      'Prices change; request a new quote to continue.';

  @override
  String get quoteRefresh => 'Get a new quote';

  @override
  String get quoteBackToCart => 'Go back';

  @override
  String get reviewTitle => 'Review order';

  @override
  String get reviewProducts => 'Products';

  @override
  String get reviewDeliveryPayment => 'Delivery and payment';

  @override
  String reviewConfirm(String total) {
    return 'Confirm order · $total';
  }

  @override
  String get placeFailedTitle => 'Could not create the order';

  @override
  String get placingTitle => 'Creating your order';

  @override
  String get placingMessage =>
      'Keep the app open. Retrying will not create a duplicate.';

  @override
  String get successCaption => 'Order created';

  @override
  String get successTitle => 'Your order is in good hands';

  @override
  String get successMessage => 'Follow its status from My orders.';

  @override
  String get successOrderNumber => 'Order number';

  @override
  String get successStatus => 'Status';

  @override
  String get successDeliverTo => 'Deliver to';

  @override
  String get successTrack => 'Track order';

  @override
  String get successBackHome => 'Back to home';

  @override
  String orderStepOf(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get orderRoute => 'Route';

  @override
  String get orderPickup => 'Pickup';

  @override
  String get orderDropoff => 'Drop-off';

  @override
  String get orderPlaceUnknown => 'Not set';

  @override
  String get orderDirections => 'Directions';

  @override
  String get orderDetailsTitle => 'Order details';

  @override
  String get orderTimelineTitle => 'Order history';

  @override
  String get orderDeliveryCode => 'Delivery code';

  @override
  String get orderCancelledTitle => 'Order cancelled';

  @override
  String get offerPendingTitle => 'A price offer is waiting for you';

  @override
  String get offerPendingMessage => 'Review the items, then approve or reject.';

  @override
  String get offerView => 'View offer';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get receiptTitle => 'Receipt';

  @override
  String get shareTitle => 'Share tracking link';

  @override
  String get rateTitle => 'Rate order';

  @override
  String trackingDriverRating(String rating) {
    return '★ $rating';
  }

  @override
  String get cancelHint => 'Choose a reason. This cannot be undone.';

  @override
  String get cancelNote => 'Note';

  @override
  String get cancelSubmit => 'Confirm cancellation';

  @override
  String get cancelConfirm => 'Are you sure you want to cancel this order?';

  @override
  String get offerClosed => 'This offer is no longer open.';

  @override
  String get offerItemUnavailable => 'Unavailable';

  @override
  String get offerApprove => 'Approve';

  @override
  String get offerReject => 'Reject offer';

  @override
  String get offerApproveConfirm =>
      'Approve this offer? Your order will proceed.';

  @override
  String get offerRejectConfirm => 'Reject offer';

  @override
  String get offerRejectReason => 'Reason (optional)';

  @override
  String offerSubstitute(String name, String price) {
    return 'Substitute: $name · $price';
  }

  @override
  String offerExpires(String time) {
    return 'Offer ends $time';
  }

  @override
  String get trackingEmptyTitle => 'No tracking yet';

  @override
  String get trackingEmptyMessage =>
      'Tracking starts once a driver picks up your order.';

  @override
  String get trackingNoLocation => 'The driver has not shared a location yet';

  @override
  String get trackingOpenMap => 'Open in maps';

  @override
  String get trackingNoDriver => 'No driver assigned yet.';

  @override
  String get trackingNextUpdate => 'Next update';

  @override
  String trackingEta(int minutes) {
    return 'Arriving in about $minutes min';
  }

  @override
  String trackingSeconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get receiptDate => 'Date';

  @override
  String get receiptDriver => 'Driver';

  @override
  String get rateDriver => 'How was the delivery?';

  @override
  String get rateStore => 'Rate the store (optional)';

  @override
  String get rateComment => 'Comment';

  @override
  String get rateCommentHint => 'Share your thoughts (optional)';

  @override
  String get rateSubmit => 'Submit rating';

  @override
  String get shareIntroTitle => 'Share your order tracking';

  @override
  String get shareIntroMessage =>
      'Create a temporary link anyone can open to follow the order.';

  @override
  String get shareCreate => 'Create link';

  @override
  String get shareCopy => 'Copy link';

  @override
  String get shareCopied => 'Link copied';

  @override
  String get shareRevoke => 'Revoke link';

  @override
  String shareExpires(String time) {
    return 'Link expires $time';
  }

  @override
  String get publicTrackingTitle => 'Track an order';

  @override
  String get publicTrackingLabel => 'Tracking link or code';

  @override
  String get publicTrackingHint => 'https://…/track/…';

  @override
  String get publicTrackingOpen => 'Track';

  @override
  String get publicTrackingEta => 'ETA';

  @override
  String get publicTrackingUpdated => 'Last update';

  @override
  String get addressEditTitle => 'Edit address';

  @override
  String get accountEditProfile => 'Profile';

  @override
  String get accountEditProfileHint => 'Name, photo and language';

  @override
  String get accountAddresses => 'Saved addresses';

  @override
  String get accountTerms => 'Terms & privacy';

  @override
  String get accountDelete => 'Delete account';

  @override
  String get accountDeleteConfirm =>
      'Your account and data will be deleted permanently. Are you sure?';

  @override
  String get vendorApplyTitle => 'Join as a store';

  @override
  String get vendorApplyHint => 'Apply to list your store';

  @override
  String get supportTitle => 'Help & support';

  @override
  String get commonSave => 'Save';

  @override
  String get addressesEmpty => 'No saved addresses';

  @override
  String get addressDefault => 'Default';

  @override
  String get addressDeleteConfirm => 'Delete this address?';

  @override
  String get vendorApplyIntro =>
      'Tell us about your store and the Amar team will contact you.';

  @override
  String get vendorApplyBusiness => 'Store name';

  @override
  String get vendorApplyBusinessHint => 'e.g. Hope Store';

  @override
  String get vendorApplyContact => 'Contact name';

  @override
  String get vendorApplyLocation => 'Attach my current location';

  @override
  String get vendorApplySubmit => 'Submit application';

  @override
  String get vendorApplySentTitle => 'Application sent';

  @override
  String get vendorApplySentMessage =>
      'We will review it and get back to you soon.';

  @override
  String get commonRequired => 'This field is required';

  @override
  String get supportCall => 'Call support';

  @override
  String get supportOrderIssue => 'Problem with an order';

  @override
  String get supportOrderIssueHint =>
      'Open the order from My orders and contact the driver or support';

  @override
  String get driverLoginTitle => 'Driver sign in';

  @override
  String get driverLoginSubtitle =>
      'Use your phone and the password from your manager.';

  @override
  String get driverPassword => 'Password';

  @override
  String get driverPasswordHint => 'Enter your password';

  @override
  String get driverLoginSubmit => 'Sign in';

  @override
  String get driverIAmCustomer => 'Not a driver? Customer sign in';

  @override
  String get driverEntry => 'Are you a driver? Sign in here';

  @override
  String get driverCollect => 'To collect';

  @override
  String get driverEarning => 'Your earning';

  @override
  String get driverLocationSending => 'Sending your location...';

  @override
  String get driverLocationOk => 'Your location is being shared';

  @override
  String get driverLocationPermission => 'Location permission is required';

  @override
  String get driverLocationPermissionHint => 'Tap to allow or open settings';

  @override
  String get driverLocationFailed => 'Could not send location, tap to retry';

  @override
  String driverLocationLast(String time) {
    return 'Last sent: $time';
  }

  @override
  String get driverNavOrders => 'Jobs';

  @override
  String get driverNavWallet => 'Earnings';

  @override
  String get driverGreeting => 'Hello';

  @override
  String get driverOnline => 'Online';

  @override
  String get driverOffline => 'Offline';

  @override
  String get driverOnlineHint => 'You are receiving jobs';

  @override
  String get driverOfflineHint => 'Start your day when ready';

  @override
  String get driverGoOnline => 'Go online';

  @override
  String get driverGoOffline => 'Go offline';

  @override
  String get driverCurrentTask => 'Current job';

  @override
  String get driverNoTask => 'No current job.';

  @override
  String get driverTodaySummary => 'Summary for today';

  @override
  String get driverTodayOrders => 'Jobs today';

  @override
  String get driverTodayEarnings => 'Earned today';

  @override
  String get driverAvailable => 'Available';

  @override
  String get driverHistory => 'History';

  @override
  String get driverNoAvailable => 'No jobs available right now';

  @override
  String get driverNoHistory => 'No past jobs';

  @override
  String get driverOrderTitle => 'Job details';

  @override
  String get driverReject => 'Reject';

  @override
  String get driverRejectConfirm => 'Reject this job?';

  @override
  String get driverAlreadyTaken => 'Another driver took this job';

  @override
  String get driverCustomer => 'Customer';

  @override
  String get driverDeliveredTitle => 'Delivered';

  @override
  String driverDeliveredMessage(String amount) {
    return '$amount was added to your earnings.';
  }

  @override
  String driverActionConfirm(String action) {
    return 'Confirm: $action?';
  }

  @override
  String get driverProofPhoto => 'Proof photo';

  @override
  String get driverDeliveryCode => 'Delivery code';

  @override
  String get driverDeliveryCodeHint => 'Ask the customer for it';

  @override
  String get driverCashTitle => 'Cash on hand';

  @override
  String get driverCashLimit => 'Limit';

  @override
  String get driverCashRemaining => 'Remaining';

  @override
  String get driverUnsettled => 'Unsettled jobs';

  @override
  String get driverCashLimitReached =>
      'Limit reached. Hand over the cash to receive new jobs.';

  @override
  String get driverSettlements => 'Settlements';

  @override
  String get driverNoSettlements => 'No settlements yet.';

  @override
  String get driverPeriodDay => 'Today';

  @override
  String get driverPeriodWeek => 'Week';

  @override
  String get driverPeriodMonth => 'Month';

  @override
  String get driverEarnings => 'Earnings';

  @override
  String get driverEarningsHistory => 'Earnings history';

  @override
  String get driverProfileHint => 'Language, vehicle and photo';

  @override
  String get driverVehicle => 'Vehicle type';

  @override
  String get onboarding1Title => 'Everything your home needs';

  @override
  String get onboarding1Body =>
      'Building, electrical and tool supplies from trusted stores, with clear prices and guaranteed quality.';

  @override
  String get onboarding2Title => 'Outstanding home services';

  @override
  String get onboarding2Body =>
      'Plumbing, electrical, cooling and more. Book easily with certified professionals.';

  @override
  String get onboarding3Title => 'Fast, reliable delivery';

  @override
  String get onboarding3Body =>
      'Follow your order moment by moment and receive it at your door on time.';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonSoon => 'Coming soon';

  @override
  String get authSignupTitle => 'Welcome to Amar';

  @override
  String get authSignupSubtitle =>
      'Create your account in a minute and start building your home.';

  @override
  String get authLoginTitle => 'Glad to see you again';

  @override
  String get authLoginSubtitle => 'Sign in to follow your orders.';

  @override
  String get authTabSignup => 'Create account';

  @override
  String get authTabLogin => 'Sign in';

  @override
  String get authNameLabel => 'Full name';

  @override
  String get authNameHint => 'Example: Sami Ahmad';

  @override
  String get authSignupSubmit => 'Create account';

  @override
  String get authLoginSubmit => 'Sign in';

  @override
  String get authDriverTitle => 'Are you a driver?';

  @override
  String get authDriverSubtitle => 'Sign in here';

  @override
  String get consentAgree => 'I agree to the ';

  @override
  String get otpConfirmTitle => 'Confirm your phone';

  @override
  String get otpSentTo => 'We sent a 4-digit code to ';

  @override
  String get otpResendIn => 'Resend in ';

  @override
  String get otpResendAction => 'Did not get the code? Resend';

  @override
  String get otpVerifyAction => 'Verify';

  @override
  String get profileCompleteTitle => 'Complete your profile';

  @override
  String get profileCompleteSubtitle =>
      'One last step so drivers and stores can reach you easily.';

  @override
  String get profileFullNameHint => 'Name';

  @override
  String get locationTitle => 'Where do we deliver?';

  @override
  String get locationSubtitle =>
      'Set your location to see nearby stores and services.';

  @override
  String get locationUseCurrent => 'Use my current location';

  @override
  String get driverDesignTitle => 'Driver sign-in';

  @override
  String get driverDesignSubtitle =>
      'Sign in with your phone and the password Amar gave you.';

  @override
  String get driverDesignPasswordHint => 'Driver password';

  @override
  String get driverDesignCustomer => 'I am a customer — back to sign-in';

  @override
  String get homeSetLocation => 'Set your location';

  @override
  String get homeOrderHint => 'Tap to follow your order';

  @override
  String get homeMostOrdered => 'Most ordered';

  @override
  String get homeStoresTitle => 'Stores';

  @override
  String get homeCompaniesTitle => 'Company services';

  @override
  String get homeProvidersEmpty => 'Nothing to show here yet';

  @override
  String get promoTitle => '15% off maintenance';

  @override
  String get promoSubtitle => 'On your first service booking';

  @override
  String get promoAction => 'Book now';

  @override
  String get navCart => 'Cart';

  @override
  String get priceAfterInspection => 'After inspection';

  @override
  String get vendorTabServices => 'Services';

  @override
  String get addressPickOnMap => 'Pick on the map';

  @override
  String get mapPickerTitle => 'Pick the location on the map';

  @override
  String get mapPickerConfirm => 'Confirm location';

  @override
  String get serviceRequestAction => 'Request service';

  @override
  String get scheduleChoose => 'Choose a time';

  @override
  String get paymentBankTransfer => 'Bank transfer';

  @override
  String get serviceQuoteTitle => 'Service price';

  @override
  String get serviceQuoteLabor => 'Labor';

  @override
  String get serviceQuoteTotal => 'Total';

  @override
  String get serviceQuoteVisit => 'Visit time';

  @override
  String get serviceQuoteAccept => 'Accept price';

  @override
  String get serviceQuoteReject => 'Reject price';

  @override
  String get serviceQuoteRejectConfirm => 'Reject this price?';

  @override
  String get transferTitle => 'Send transfer receipt';

  @override
  String get transferHint =>
      'Transfer the amount to this account, then upload the receipt image.';

  @override
  String get transferBank => 'Provider';

  @override
  String get transferHolder => 'Account holder';

  @override
  String get transferAccount => 'Account number';

  @override
  String get transferFixNeeded => 'The receipt needs correcting';

  @override
  String get transferUpload => 'Upload receipt image';

  @override
  String get failureAppSetup =>
      'The app is not set up correctly. Please contact support.';

  @override
  String get failureDuplicateRequest =>
      'This request was already sent. Refresh and check it.';

  @override
  String get failureQuoteChanged =>
      'The store sent a new price. Review it and accept again.';

  @override
  String get failureNoQuoteYet => 'The store has not set the price yet.';

  @override
  String get failureNotTransferOrder =>
      'This order is paid in cash and needs no transfer receipt.';

  @override
  String get failureServer =>
      'The server ran into a problem. Please try again shortly.';

  @override
  String get failureTemporary => 'Temporary problem. Please try again.';

  @override
  String get failureTimeout =>
      'The connection took too long. Check your internet and try again.';

  @override
  String get failureSecureConnection =>
      'Could not open a secure connection. Check your network and try again.';

  @override
  String get failureInvalidResponse =>
      'The server sent an unexpected reply. Please try again later.';
}
