import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../core/network/api_response.dart';
import '../core/utils/helpers.dart';
import '../models/print_options_model.dart';
import '../services/upload_service.dart';

class PrintProvider extends ChangeNotifier {
  final UploadService _uploadService;
  final Logger _logger = Logger();

  PrintProvider(this._uploadService);

  bool _isColor = false;
  String _pageOption = 'All';
  String? _pageRange;
  int _copies = 1;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadStatus = '';
  ApiResponse<Map<String, dynamic>>? _uploadResponse;
  String? _error;
  PrintOptionsModel? _currentOptions;

  bool get isColor => _isColor;
  String get pageOption => _pageOption;
  String? get pageRange => _pageRange;
  int get copies => _copies;
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;
  String get uploadStatus => _uploadStatus;
  ApiResponse<Map<String, dynamic>>? get uploadResponse => _uploadResponse;
  String? get error => _error;
  PrintOptionsModel? get currentOptions => _currentOptions;

  double get calculatedPrice {
    final totalPages = Helpers.parseTotalPages(_pageOption, _pageRange);
    return Helpers.calculatePrice(
      isColor: _isColor,
      copies: _copies,
      totalPages: totalPages,
    );
  }

  int get calculatedTotalPages {
    return Helpers.parseTotalPages(_pageOption, _pageRange);
  }

  void toggleColor() {
    _isColor = !_isColor;
    notifyListeners();
  }

  void setPageOption(String option) {
    _pageOption = option;
    if (option == 'All') {
      _pageRange = null;
    }
    notifyListeners();
  }

  void setPageRange(String? range) {
    _pageRange = range;
    notifyListeners();
  }

  void setCopies(int copies) {
    _copies = copies.clamp(1, 100);
    notifyListeners();
  }

  void setPrintOptions(PrintOptionsModel options) {
    _currentOptions = options;
    _isColor = options.isColor;
    _pageOption = options.pageOption;
    _pageRange = options.pageRange;
    _copies = options.copies;
    notifyListeners();
  }

  Future<bool> uploadFile({
    required String filePath,
    required String fileName,
    required String fileExtension,
    required int fileSize,
  }) async {
    _isUploading = true;
    _uploadProgress = 0.0;
    _error = null;
    _uploadStatus = 'Uploading...';
    notifyListeners();

    try {
      final options = PrintOptionsModel(
        isColor: _isColor,
        pageOption: _pageOption,
        pageRange: _pageRange,
        copies: _copies,
        totalPages: calculatedTotalPages,
        totalPrice: calculatedPrice,
        fileName: fileName,
        filePath: filePath,
        fileExtension: fileExtension,
        fileSize: fileSize,
      );
      _currentOptions = options;

      _uploadStatus = 'Checking File...';
      notifyListeners();

      final response = await _uploadService.uploadFile(
        options: options,
        onProgress: (sent, total) {
          _uploadProgress = sent / total;
          notifyListeners();
        },
      );

      _uploadStatus = 'Almost Done...';
      notifyListeners();

      _uploadResponse = response;
      if (response.success) {
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _logger.e('Upload failed: $e');
      _error = 'Upload failed. Please try again.';
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isColor = false;
    _pageOption = 'All';
    _pageRange = null;
    _copies = 1;
    _isUploading = false;
    _uploadProgress = 0.0;
    _uploadStatus = '';
    _uploadResponse = null;
    _error = null;
    _currentOptions = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
