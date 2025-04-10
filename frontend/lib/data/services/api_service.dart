import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../utils/logger.dart';
import '../models/api_response.dart';
import '../datasources/auth_local_data_source.dart';
import 'connectivity_service.dart';

enum HttpMethod { get, post, put, delete }

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  final AuthLocalDataSource _authLocalDataSource = AuthLocalDataSource();
  final ConnectivityService _connectivityService = ConnectivityService();

  ApiService._internal() {
    _initDio();
  }

  // Stream providing real-time connectivity status changes
  Stream<bool> get connectivityStream => _connectivityService.connectionStream;

  void _initDio() {
    final options = BaseOptions(
      baseUrl: AppConfig().apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add interceptors for logging and token handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authentication token if available
          final token = await _authLocalDataSource.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          AppLogger.d('API Request: ${options.method} ${options.path}');
          if (options.data != null) {
            AppLogger.d('Request Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.d(
            'API Response [${response.statusCode}]: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          AppLogger.e(
            'API Error [${error.response?.statusCode}]: ${error.requestOptions.path}',
          );
          AppLogger.e('Error Response: ${error.response?.data}');

          // Handle 401 Unauthorized errors (token expired)
          if (error.response?.statusCode == 401) {
            // Try to refresh the token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request with the new token
              final token = await _authLocalDataSource.getToken();
              if (token != null) {
                error.requestOptions.headers['Authorization'] = 'Bearer $token';
                final retryResponse = await _dio.fetch(error.requestOptions);
                return handler.resolve(retryResponse);
              }
            } else {
              // If token refresh fails, log out the user
              await _authLocalDataSource.clearAuth();
              // Handle logout logic here if needed
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _authLocalDataSource.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['data'] != null) {
          await _authLocalDataSource.saveToken(data['data']['token']);
          await _authLocalDataSource.saveRefreshToken(
            data['data']['refreshToken'],
          );
          return true;
        }
      }

      return false;
    } catch (e) {
      AppLogger.e('Token refresh error: $e');
      return false;
    }
  }

  /// Make API request with automatic connectivity check and retry
  Future<ApiResponse<T>> request<T>({
    required String endpoint,
    required HttpMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
    int retryCount = 2,
  }) async {
    // Check for connectivity before making request
    if (!await _connectivityService.checkConnectivity()) {
      return ApiResponse<T>(
        status: 'error',
        message: 'No internet connection. Please check your network settings.',
      );
    }

    try {
      Response response;
      // Properly construct URL - if endpoint starts with http, use as is,
      // if it starts with /, append to base URL, otherwise prepend / and append to base URL
      final String url =
          endpoint.startsWith('http')
              ? endpoint
              : endpoint.startsWith('/')
              ? '${AppConfig().apiBaseUrl}$endpoint'
              : '${AppConfig().apiBaseUrl}/$endpoint';

      AppLogger.d('Making ${method.toString()} request to: $url');

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(url, queryParameters: queryParameters);
          break;
        case HttpMethod.post:
          response = await _dio.post(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.put:
          response = await _dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.delete:
          response = await _dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ApiResponse<T>.fromJson(response.data, fromJson);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      // Handle network errors and retry if possible
      if (e.error is SocketException ||
          e.type == DioExceptionType.connectionTimeout) {
        if (retryCount > 0) {
          AppLogger.w(
            'Connection error, retrying... ($retryCount attempts left)',
          );
          await Future.delayed(const Duration(seconds: 1));
          return request<T>(
            endpoint: endpoint,
            method: method,
            data: data,
            queryParameters: queryParameters,
            fromJson: fromJson,
            retryCount: retryCount - 1,
          );
        }

        return ApiResponse<T>(
          status: 'error',
          message: 'Network error. Please check your internet connection.',
        );
      }

      // Try to parse error response from server
      if (e.response != null) {
        try {
          return ApiResponse<T>.fromJson(e.response!.data, fromJson);
        } catch (_) {
          return ApiResponse<T>(
            status: 'error',
            message: 'Server error: ${e.response!.statusCode}',
          );
        }
      }

      return ApiResponse<T>(
        status: 'error',
        message: 'An unexpected error occurred. Please try again later.',
      );
    } catch (e) {
      AppLogger.e('API request error: $e');
      return ApiResponse<T>(
        status: 'error',
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }

  // Helper methods for common HTTP methods
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.get,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.post,
      data: data,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.put,
      data: data,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return request<T>(
      endpoint: endpoint,
      method: HttpMethod.delete,
      data: data,
      queryParameters: queryParameters,
      fromJson: fromJson,
    );
  }
}
