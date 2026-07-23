import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Helpers {
  Helpers._();

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String formatCurrency(double amount) {
    final format = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
    return format.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  static String generateOrderNumber() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().microsecondsSinceEpoch;
    final code = List.generate(8, (i) => chars[(random >> (i * 3)) % chars.length]).join();
    return 'SSP-$code';
  }

  static String getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'pdf';
      case 'doc':
      case 'docx':
        return 'word';
      case 'xls':
      case 'xlsx':
        return 'excel';
      case 'ppt':
      case 'pptx':
        return 'powerpoint';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'bmp':
      case 'gif':
      case 'webp':
      case 'heic':
        return 'image';
      default:
        return 'generic';
    }
  }

  static double calculatePrice({
    required bool isColor,
    required int copies,
    required int totalPages,
  }) {
    final pricePerPage = isColor
        ? AppConstants.pricePerPageColor
        : AppConstants.pricePerPageBlack;
    return pricePerPage * totalPages * copies;
  }

  static int parseTotalPages(String pageOption, String? pageRange) {
    if (pageOption == 'All') return 1;
    if (pageRange == null || pageRange.isEmpty) return 1;
    final pages = <int>{};
    final parts = pageRange.split(',');
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.contains('-')) {
        final range = trimmed.split('-');
        final start = int.tryParse(range[0].trim()) ?? 1;
        final end = int.tryParse(range[1].trim()) ?? 1;
        for (int i = start; i <= end; i++) {
          pages.add(i);
        }
      } else {
        final page = int.tryParse(trimmed);
        if (page != null) pages.add(page);
      }
    }
    return pages.length;
  }
}
