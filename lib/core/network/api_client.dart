import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import 'api_endpoints.dart';
import 'api_response.dart';

class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: AppConstants.connectionTimeout),
        receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
        sendTimeout: const Duration(seconds: AppConstants.sendTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.i('API Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.i('API Response: ${response.statusCode} ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.e('API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> uploadFile({
    required String filePath,
    required String fileName,
    required Map<String, dynamic> fields,
    void Function(int, int)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(filePath, filename: fileName),
        ...fields,
      });

      final response = await _dio.post(
        ApiEndpoints.upload,
        data: formData,
        onSendProgress: (sent, total) {
          onProgress?.call(sent, total);
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          data: response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : {'message': response.data.toString()},
          statusCode: response.statusCode,
          message: 'File uploaded successfully',
        );
      }
      return ApiResponse.error(
        message: 'Upload failed with status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      _logger.e('Upload error: $e');
      return ApiResponse.error(message: 'Upload failed: $e');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> confirmPayment({
    required String value,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.paymentSuccessWithValue(value),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(
          data: response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : {'message': response.data.toString()},
          statusCode: response.statusCode,
          message: 'Payment confirmed successfully',
        );
      }
      return ApiResponse.error(
        message: 'Payment confirmation failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      _logger.e('Payment confirmation error: $e');
      return ApiResponse.error(message: 'Payment failed: $e');
    }
  }

  ApiResponse<Map<String, dynamic>> _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiResponse.error(message: 'Connection timed out');
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error(message: 'Server responded too slowly');
      case DioExceptionType.sendTimeout:
        return ApiResponse.error(message: 'Upload timed out');
      case DioExceptionType.connectionError:
        return ApiResponse.error(message: 'No internet connection');
      case DioExceptionType.badResponse:
        return ApiResponse.error(
          message: 'Server error: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      default:
        return ApiResponse.error(message: 'Network error occurred');
    }
  }
}
