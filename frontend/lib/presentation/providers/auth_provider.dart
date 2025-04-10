import 'package:flutter/foundation.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/models/auth_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';
import '../../utils/logger.dart';

enum AuthStatus { loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthLocalDataSource _authLocalDataSource;
  final ApiService _apiService = ApiService();
  
  AuthStatus _status = AuthStatus.loading;
  User? _user;
  String? _error;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  // Constructor
  AuthProvider(this._authLocalDataSource) {
    _initializeAuth();
  }

  // Initialize authentication state from local storage
  Future<void> _initializeAuth() async {
    try {
      final isAuthenticated = await _authLocalDataSource.isAuthenticated();
      
      if (isAuthenticated) {
        final user = await _authLocalDataSource.getUser();
        if (user != null) {
          _user = user;
          _status = AuthStatus.authenticated;
          notifyListeners();
          return;
        }
      }
      
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      AppLogger.e('Error initializing authentication: $e');
      _status = AuthStatus.error;
      _error = 'Failed to initialize authentication';
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _error = null;
      notifyListeners();

      final response = await _apiService.post<AuthResponse>(
        endpoint: '/auth/login',
        data: LoginRequest(
          email: email,
          password: password,
        ).toJson(),
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        await _authLocalDataSource.saveAuth(response.data!);
        _user = response.data!.user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _error = response.message ?? 'Login failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      AppLogger.e('Login error: $e');
      _status = AuthStatus.unauthenticated;
      _error = 'An unexpected error occurred during login';
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(String username, String email, String password, {String? role}) async {
    try {
      _status = AuthStatus.loading;
      _error = null;
      notifyListeners();

      final response = await _apiService.post<AuthResponse>(
        endpoint: '/auth/register',
        data: RegisterRequest(
          username: username,
          email: email,
          password: password,
          role: role,
        ).toJson(),
        fromJson: (json) => AuthResponse.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        await _authLocalDataSource.saveAuth(response.data!);
        _user = response.data!.user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _error = response.message ?? 'Registration failed';
        notifyListeners();
        return false;
      }
    } catch (e) {
      AppLogger.e('Registration error: $e');
      _status = AuthStatus.unauthenticated;
      _error = 'An unexpected error occurred during registration';
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authLocalDataSource.clearAuth();
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      AppLogger.e('Logout error: $e');
      _error = 'Failed to log out';
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile({String? displayName, String? bio}) async {
    try {
      if (_user == null) return false;

      final response = await _apiService.put<User>(
        endpoint: '/users/profile',
        data: {
          if (displayName != null) 'displayName': displayName,
          if (bio != null) 'bio': bio,
        },
        fromJson: (json) => User.fromJson(json),
      );

      if (response.isSuccess && response.data != null) {
        _user = response.data;
        await _authLocalDataSource.updateUser(_user!);
        notifyListeners();
        return true;
      } else {
        _error = response.message ?? 'Failed to update profile';
        notifyListeners();
        return false;
      }
    } catch (e) {
      AppLogger.e('Update profile error: $e');
      _error = 'An unexpected error occurred while updating profile';
      notifyListeners();
      return false;
    }
  }

  // Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      final response = await _apiService.put(
        endpoint: '/auth/change-password',
        data: ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ).toJson(),
      );

      if (response.isSuccess) {
        return true;
      } else {
        _error = response.message ?? 'Failed to change password';
        notifyListeners();
        return false;
      }
    } catch (e) {
      AppLogger.e('Change password error: $e');
      _error = 'An unexpected error occurred while changing password';
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
