import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../core/network/api_response.dart';
import '../services/payment_service.dart';
import '../services/storage_service.dart';
import '../models/order_model.dart';
import '../models/payment_model.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _paymentService;
  final StorageService _storageService;
  final Logger _logger = Logger();

  PaymentProvider(this._paymentService, this._storageService);

  String? _selectedMethod;
  bool _isProcessing = false;
  bool _isConfirming = false;
  PaymentModel? _paymentResult;
  ApiResponse<Map<String, dynamic>>? _confirmResponse;
  String? _error;

  String? get selectedMethod => _selectedMethod;
  bool get isProcessing => _isProcessing;
  bool get isConfirming => _isConfirming;
  PaymentModel? get paymentResult => _paymentResult;
  ApiResponse<Map<String, dynamic>>? get confirmResponse => _confirmResponse;
  String? get error => _error;

  void selectMethod(String method) {
    _selectedMethod = method;
    notifyListeners();
  }

  Future<bool> processPayment({
    required String orderNumber,
    required double amount,
    required String fileName,
    required int copies,
    required bool isColor,
  }) async {
    if (_selectedMethod == null) {
      _error = 'Please select a payment method';
      notifyListeners();
      return false;
    }

    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _paymentService.processPayment(
        orderNumber: orderNumber,
        method: _selectedMethod!,
        amount: amount,
      );

      if (response.success) {
        _paymentResult = PaymentModel(
          method: _selectedMethod!,
          amount: amount,
          orderNumber: orderNumber,
          isSuccess: true,
          date: DateTime.now(),
        );

        await _storageService.saveOrder(OrderModel(
          orderNumber: orderNumber,
          fileName: fileName,
          copies: copies,
          isColor: isColor,
          amount: amount,
          status: 'Paid',
          date: DateTime.now(),
          orderId: orderNumber,
        ));

        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _logger.e('Payment processing error: $e');
      _error = 'Payment processing failed';
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<bool> confirmPayment(String value) async {
    _isConfirming = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _paymentService.confirmPayment(value: value);
      _confirmResponse = response;
      if (response.success) {
        return true;
      } else {
        _error = response.message;
        return false;
      }
    } catch (e) {
      _logger.e('Payment confirmation error: $e');
      _error = 'Payment confirmation failed';
      return false;
    } finally {
      _isConfirming = false;
      notifyListeners();
    }
  }

  void reset() {
    _selectedMethod = null;
    _isProcessing = false;
    _isConfirming = false;
    _paymentResult = null;
    _confirmResponse = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
