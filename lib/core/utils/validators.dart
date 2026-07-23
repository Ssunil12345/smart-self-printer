import '../constants/app_constants.dart';

class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? fileSize(int bytes) {
    if (bytes > AppConstants.fileSizeLimitBytes) {
      return 'File size exceeds ${AppConstants.fileSizeLimitMB} MB limit';
    }
    return null;
  }

  static String? pageRange(String? value, int totalPages) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter page range';
    }
    final trimmed = value.trim();
    if (trimmed == 'All' || trimmed == 'all') {
      return null;
    }
    final parts = trimmed.split(',');
    for (final part in parts) {
      final trimmedPart = part.trim();
      if (trimmedPart.contains('-')) {
        final range = trimmedPart.split('-');
        if (range.length != 2) {
          return 'Invalid range format';
        }
        final start = int.tryParse(range[0].trim());
        final end = int.tryParse(range[1].trim());
        if (start == null || end == null || start < 1 || end > totalPages || start > end) {
          return 'Invalid page range';
        }
      } else {
        final page = int.tryParse(trimmedPart);
        if (page == null || page < 1 || page > totalPages) {
          return 'Invalid page number';
        }
      }
    }
    return null;
  }

  static String? copies(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter number of copies';
    }
    final copies = int.tryParse(value);
    if (copies == null || copies < 1 || copies > 100) {
      return 'Copies must be between 1 and 100';
    }
    return null;
  }

  static bool isValidExtension(String extension) {
    return AppConstants.supportedExtensions.contains(extension.toLowerCase());
  }
}
