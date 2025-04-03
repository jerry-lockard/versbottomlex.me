import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/auth_model.dart';
import '../../utils/logger.dart';

class AuthLocalDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'auth_refresh_token';
  static const String _userKey = 'auth_user';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Save authentication data
  Future<void> saveAuth(AuthResponse auth) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: auth.token);
      await _secureStorage.write(key: _refreshTokenKey, value: auth.refreshToken);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(auth.user.toJson()));
      
      AppLogger.d('Auth data saved successfully');
    } catch (e) {
      AppLogger.e('Error saving auth data: $e');
      rethrow;
    }
  }

  // Get user data
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      
      if (userString != null) {
        return User.fromJson(jsonDecode(userString));
      }
      
      return null;
    } catch (e) {
      AppLogger.e('Error getting user data: $e');
      return null;
    }
  }

  // Update user data
  Future<void> updateUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      
      AppLogger.d('User data updated successfully');
    } catch (e) {
      AppLogger.e('Error updating user data: $e');
      rethrow;
    }
  }

  // Get auth token
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      AppLogger.e('Error getting auth token: $e');
      return null;
    }
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      AppLogger.e('Error getting refresh token: $e');
      return null;
    }
  }

  // Save new token
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      AppLogger.e('Error saving auth token: $e');
      rethrow;
    }
  }

  // Save new refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    } catch (e) {
      AppLogger.e('Error saving refresh token: $e');
      rethrow;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      return token != null;
    } catch (e) {
      AppLogger.e('Error checking authentication: $e');
      return false;
    }
  }

  // Clear authentication data
  Future<void> clearAuth() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      
      AppLogger.d('Auth data cleared successfully');
    } catch (e) {
      AppLogger.e('Error clearing auth data: $e');
      rethrow;
    }
  }
}