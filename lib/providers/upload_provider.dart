import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/validators.dart';

class UploadProvider extends ChangeNotifier {
  PlatformFile? _selectedFile;
  String? _error;
  static const String _fileTooLarge = 'File size exceeds 100 MB limit';

  PlatformFile? get selectedFile => _selectedFile;
  bool get hasFile => _selectedFile != null;
  String? get error => _error;

  Future<void> pickFile() async {
    _error = null;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.supportedExtensions,
        allowMultiple: false,
        withData: false,
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.size > AppConstants.fileSizeLimitBytes) {
          _error = _fileTooLarge;
          notifyListeners();
          return;
        }
        final extension = file.extension?.toLowerCase() ?? '';
        if (!Validators.isValidExtension(extension)) {
          _error = 'Invalid file format';
          notifyListeners();
          return;
        }
        _selectedFile = file;
      }
    } catch (e) {
      _error = 'Failed to pick file: $e';
    }
    notifyListeners();
  }

  void removeFile() {
    _selectedFile = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
