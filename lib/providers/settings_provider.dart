import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;

  SettingsProvider(this._storageService);

  SettingsModel _settings = const SettingsModel();

  SettingsModel get settings => _settings;
  bool get isDarkMode => _settings.isDarkMode;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  String get themeMode => _settings.themeMode;

  Future<void> loadSettings() async {
    _settings = await _storageService.getSettings();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _settings = _settings.copyWith(isDarkMode: !_settings.isDarkMode);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _settings = _settings.copyWith(
      notificationsEnabled: !_settings.notificationsEnabled,
    );
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> updateSettings(SettingsModel settings) async {
    _settings = settings;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }
}
