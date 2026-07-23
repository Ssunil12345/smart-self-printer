import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../models/settings_model.dart';

class StorageService {
  static const String _ordersKey = 'order_history';
  static const String _settingsKey = 'app_settings';

  Future<List<OrderModel>> getOrderHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_ordersKey);
    if (ordersJson == null) return [];
    final List<dynamic> decoded = json.decode(ordersJson) as List<dynamic>;
    return decoded
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveOrder(OrderModel order) async {
    final orders = await getOrderHistory();
    orders.insert(0, order);
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(orders.map((e) => e.toJson()).toList());
    await prefs.setString(_ordersKey, encoded);
  }

  Future<void> clearOrderHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ordersKey);
  }

  Future<SettingsModel> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson == null) return const SettingsModel();
    return SettingsModel.fromJson(
      json.decode(settingsJson) as Map<String, dynamic>,
    );
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, json.encode(settings.toJson()));
  }
}
