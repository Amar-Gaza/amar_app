import '../../l10n/app_localizations.dart';
import '../constants/api_query.dart';
import '../network/api_failure.dart';

/// The one place that turns an [ApiFailure] into text for the user.
abstract final class ErrorMessageResolver {
  /// Codes whose server message is meant for developers, not users.
  static const Set<String> _technical = {
    ApiErrorCodes.missingProjectKey,
    ApiErrorCodes.invalidProjectKey,
    ApiErrorCodes.methodNotAllowed,
    ApiErrorCodes.idempotencyMismatch,
    ApiErrorCodes.chaosInjected,
    ApiErrorCodes.invalidResponse,
    ApiErrorCodes.emptyResponse,
  };

  /// Order: the server's reason for the first invalid field, then the
  /// server's own (localized) message, then a local text by error code.
  static String resolve(ApiFailure failure, AppLocalizations l10n) {
    if (failure.isValidation) {
      final field = failure.firstFieldError;
      if (field != null && field.isNotEmpty) return field;
    }
    if (failure.message.isNotEmpty && !_technical.contains(failure.code)) {
      return failure.message;
    }
    return byCode(failure.code, l10n);
  }

  static String byCode(String code, AppLocalizations l10n) => switch (code) {
        ApiErrorCodes.missingProjectKey ||
        ApiErrorCodes.invalidProjectKey ||
        ApiErrorCodes.methodNotAllowed =>
          l10n.failureAppSetup,
        ApiErrorCodes.unauthenticated => l10n.errorUnauthenticated,
        ApiErrorCodes.otpInvalid => l10n.errorOtpInvalid,
        ApiErrorCodes.otpExpired => l10n.errorOtpExpired,
        ApiErrorCodes.forbidden => l10n.errorForbidden,
        ApiErrorCodes.moduleDisabled => l10n.errorModuleDisabled,
        ApiErrorCodes.projectFrozen => l10n.errorProjectFrozen,
        ApiErrorCodes.projectInactive => l10n.errorProjectInactive,
        ApiErrorCodes.userBlocked => l10n.errorUserBlocked,
        ApiErrorCodes.notFound => l10n.errorNotFound,
        ApiErrorCodes.alreadyTaken => l10n.errorAlreadyTaken,
        ApiErrorCodes.conflict => l10n.errorConflict,
        ApiErrorCodes.bidClosed => l10n.errorBidClosed,
        ApiErrorCodes.idempotencyMismatch => l10n.failureDuplicateRequest,
        ApiErrorCodes.quoteExpired => l10n.errorQuoteExpired,
        ApiErrorCodes.quoteUsed => l10n.errorQuoteUsed,
        ApiErrorCodes.quoteChanged => l10n.failureQuoteChanged,
        ApiErrorCodes.noQuoteYet => l10n.failureNoQuoteYet,
        ApiErrorCodes.notATransferOrder => l10n.failureNotTransferOrder,
        ApiErrorCodes.validationFailed => l10n.errorValidationFailed,
        ApiErrorCodes.invalidTransition => l10n.errorInvalidTransition,
        ApiErrorCodes.outOfZone => l10n.errorOutOfZone,
        ApiErrorCodes.outOfStock => l10n.errorOutOfStock,
        ApiErrorCodes.slotFull => l10n.errorSlotFull,
        ApiErrorCodes.cashLimitReached => l10n.errorCashLimitReached,
        ApiErrorCodes.vendorClosed => l10n.errorVendorClosed,
        ApiErrorCodes.appUpdateRequired => l10n.errorAppUpdateRequired,
        ApiErrorCodes.tooManyRequests => l10n.errorTooManyRequests,
        ApiErrorCodes.serverError => l10n.failureServer,
        ApiErrorCodes.maintenance => l10n.errorMaintenance,
        ApiErrorCodes.chaosInjected => l10n.failureTemporary,
        ApiErrorCodes.networkError => l10n.commonOfflineHint,
        ApiErrorCodes.timeout => l10n.failureTimeout,
        ApiErrorCodes.secureConnection => l10n.failureSecureConnection,
        ApiErrorCodes.invalidResponse ||
        ApiErrorCodes.emptyResponse =>
          l10n.failureInvalidResponse,
        _ => l10n.commonGenericError,
      };
}
