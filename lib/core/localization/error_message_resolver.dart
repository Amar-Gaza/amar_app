import '../../l10n/app_localizations.dart';
import '../constants/api_query.dart';
import '../network/api_failure.dart';

abstract final class ErrorMessageResolver {
  /// Server message first (already localized); ARB fallback by error code.
  static String resolve(ApiFailure failure, AppLocalizations l10n) {
    if (failure.message.isNotEmpty) return failure.message;
    switch (failure.code) {
      case 'missing_project_key':
        return l10n.errorMissingProjectKey;
      case 'invalid_project_key':
        return l10n.errorInvalidProjectKey;
      case 'unauthenticated':
        return l10n.errorUnauthenticated;
      case 'otp_invalid':
        return l10n.errorOtpInvalid;
      case 'otp_expired':
        return l10n.errorOtpExpired;
      case 'forbidden':
        return l10n.errorForbidden;
      case 'module_disabled':
        return l10n.errorModuleDisabled;
      case 'project_frozen':
        return l10n.errorProjectFrozen;
      case 'project_inactive':
        return l10n.errorProjectInactive;
      case 'user_blocked':
        return l10n.errorUserBlocked;
      case 'not_found':
        return l10n.errorNotFound;
      case 'method_not_allowed':
        return l10n.errorMethodNotAllowed;
      case 'already_taken':
        return l10n.errorAlreadyTaken;
      case 'conflict':
        return l10n.errorConflict;
      case 'bid_closed':
        return l10n.errorBidClosed;
      case 'idempotency_mismatch':
        return l10n.errorIdempotencyMismatch;
      case 'quote_expired':
        return l10n.errorQuoteExpired;
      case 'quote_used':
        return l10n.errorQuoteUsed;
      case 'validation_failed':
        return l10n.errorValidationFailed;
      case 'invalid_transition':
        return l10n.errorInvalidTransition;
      case 'out_of_zone':
        return l10n.errorOutOfZone;
      case 'out_of_stock':
        return l10n.errorOutOfStock;
      case 'slot_full':
        return l10n.errorSlotFull;
      case 'cash_limit_reached':
        return l10n.errorCashLimitReached;
      case 'vendor_closed':
        return l10n.errorVendorClosed;
      case 'app_update_required':
        return l10n.errorAppUpdateRequired;
      case 'too_many_requests':
        return l10n.errorTooManyRequests;
      case 'server_error':
        return l10n.errorServerError;
      case 'maintenance':
        return l10n.errorMaintenance;
      case 'chaos_injected':
        return l10n.errorChaosInjected;
      case ApiErrorCodes.networkError:
      case ApiErrorCodes.timeout:
        return l10n.commonOfflineHint;
      default:
        return l10n.commonGenericError;
    }
  }
}
