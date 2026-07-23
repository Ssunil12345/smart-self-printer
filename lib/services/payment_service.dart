import '../core/network/api_client.dart';
import '../core/network/api_response.dart';

class PaymentService {
  final ApiClient _apiClient;

  PaymentService(this._apiClient);

  Future<ApiResponse<Map<String, dynamic>>> processPayment({
    required String orderNumber,
    required String method,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return ApiResponse.success(
      data: {
        'orderNumber': orderNumber,
        'method': method,
        'amount': amount,
        'status': 'success',
      },
      message: 'Payment successful',
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> confirmPayment({
    required String value,
  }) async {
    return _apiClient.confirmPayment(value: value);
  }
}
