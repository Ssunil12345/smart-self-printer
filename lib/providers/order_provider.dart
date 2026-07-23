import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/storage_service.dart';

class OrderProvider extends ChangeNotifier {
  final StorageService _storageService;

  OrderProvider(this._storageService);

  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  List<OrderModel> get recentOrders =>
      _orders.take(5).toList();

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    try {
      _orders = await _storageService.getOrderHistory();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addOrder(OrderModel order) async {
    await _storageService.saveOrder(order);
    _orders.insert(0, order);
    notifyListeners();
  }

  Future<void> clearOrders() async {
    await _storageService.clearOrderHistory();
    _orders.clear();
    notifyListeners();
  }
}
