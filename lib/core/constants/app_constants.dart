class AppConstants {
  AppConstants._();

  static const int splashDelay = 3;
  static const int fileSizeLimitMB = 100;
  static const int fileSizeLimitBytes = 100 * 1024 * 1024;
  static const int maxCopies = 100;
  static const int minCopies = 1;
  static const int defaultCopies = 1;
  static const double pricePerPageBlack = 3.0;
  static const double pricePerPageColor = 10.0;
  static const double colorMultiplier = 2.0;
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 60;
  static const int sendTimeout = 60;
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  static const List<String> supportedExtensions = [
    'pdf', 'doc', 'docx', 'ppt', 'pptx',
    'xls', 'xlsx', 'jpg', 'jpeg', 'png',
    'bmp', 'txt', 'webp', 'heic',
  ];

  static const List<String> imageExtensions = [
    'jpg', 'jpeg', 'png', 'bmp', 'webp', 'heic',
  ];

  static const List<String> paymentMethodsList = ['UPI', 'Card', 'Wallet', 'Cash'];
}
