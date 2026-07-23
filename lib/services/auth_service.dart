import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage;
  static const String _emailKey = 'user_email';
  static const String _nameKey = 'user_name';
  static const String _loggedInKey = 'is_logged_in';

  AuthService()
      : _secureStorage = const FlutterSecureStorage();

  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await _secureStorage.write(key: _emailKey, value: email);
    return UserModel(email: email, isLoggedIn: true);
  }

  Future<UserModel> register(String email, String name, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await _secureStorage.write(key: _emailKey, value: email);
    await _secureStorage.write(key: _nameKey, value: name);
    return UserModel(email: email, name: name, isLoggedIn: true);
  }

  Future<UserModel> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_loggedInKey) ?? false;
    if (!isLoggedIn) {
      return const UserModel(email: '', isLoggedIn: false);
    }
    final email = await _secureStorage.read(key: _emailKey) ?? '';
    final name = await _secureStorage.read(key: _nameKey) ?? '';
    return UserModel(email: email, name: name, isLoggedIn: true);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
    await _secureStorage.delete(key: _emailKey);
    await _secureStorage.delete(key: _nameKey);
  }
}
