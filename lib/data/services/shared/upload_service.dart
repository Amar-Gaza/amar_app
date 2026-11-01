import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/api_query.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_token_storage.dart';
import '../../models/masar/masar_models.dart';

/// POST /uploads. The returned upload id is referenced by fields,
/// attachments, transitions and avatars.
class UploadService {
  UploadService(this._client);

  final ApiClient _client;

  /// [purpose] matches `^[a-z0-9_]+$`; [role] picks whose token is sent.
  Future<Upload> upload({
    required String filePath,
    required String purpose,
    SessionRole role = SessionRole.customer,
    ProgressCallback? onProgress,
  }) async =>
      _client.data<Upload>(
        HttpMethod.post,
        ApiEndpoints.uploads,
        role: role,
        onSendProgress: onProgress,
        body: FormData.fromMap({
          ApiBody.file: await MultipartFile.fromFile(filePath),
          ApiBody.purpose: purpose,
        }),
        parse: (data) => ApiClient.parseObject(data, Upload.fromJson),
      );
}
