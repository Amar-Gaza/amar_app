import 'package:dio/dio.dart';

import '../../constants/api_headers.dart';
import '../../constants/api_query.dart';
import '../../constants/app_env.dart';
import '../../storage/app_preferences.dart';
import '../api_failure.dart';

class HeadersInterceptor extends Interceptor {
  HeadersInterceptor(this._prefs);

  final AppPreferences _prefs;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!AppEnv.isConfigured) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: const ApiFailure(code: ApiErrorCodes.missingProjectKey),
        ),
      );
      return;
    }
    options.headers[ApiHeaders.projectKey] = AppEnv.projectKey;
    options.headers[ApiHeaders.accept] = ApiHeaders.json;
    options.headers[ApiHeaders.acceptLanguage] = _prefs.locale;
    options.headers[ApiHeaders.appVersion] = AppEnv.appVersion;
    final version = _prefs.configVersion;
    if (version != null) {
      options.headers[ApiHeaders.configVersion] = version;
    }
    if (AppEnv.sendsDevMember) {
      options.headers[ApiHeaders.devMember] = AppEnv.devMember;
    }
    handler.next(options);
  }
}
