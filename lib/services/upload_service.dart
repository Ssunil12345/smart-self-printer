import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/print_options_model.dart';

class UploadService {
  final ApiClient _apiClient;

  UploadService(this._apiClient);

  Future<ApiResponse<Map<String, dynamic>>> uploadFile({
    required PrintOptionsModel options,
    void Function(int, int)? onProgress,
  }) async {
    return _apiClient.uploadFile(
      filePath: options.filePath,
      fileName: options.fileName,
      fields: options.toApiFields(),
      onProgress: onProgress,
    );
  }
}
