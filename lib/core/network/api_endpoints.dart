class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = '';
  static const String upload = '${baseUrl}30-update.php';
  static const String paymentSuccess = '${baseUrl}31-update.php';

  static String paymentSuccessWithValue(String value) {
    return '$paymentSuccess?value=$value';
  }
}
