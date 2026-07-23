class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = '';
  static const String upload = '$baseUrl/.php';
  static const String paymentSuccess = '$baseUrl/.php';

  static String paymentSuccessWithValue(String value) {
    return '$paymentSuccess?value=$value';
  }
}
