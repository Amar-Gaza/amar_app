import '../../l10n/app_localizations.dart';
import '../utils/validators.dart';

abstract final class FieldIssueResolver {
  static String message(FieldIssue issue, AppLocalizations l10n) {
    switch (issue) {
      case FieldIssue.phoneInvalid:
        return l10n.validationPhoneInvalid;
      case FieldIssue.nameInvalid:
        return l10n.validationNameInvalid;
      case FieldIssue.otpIncomplete:
        return l10n.validationOtpIncomplete;
    }
  }
}
