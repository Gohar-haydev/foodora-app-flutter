import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../errors/failure.dart';
import '../utils/result.dart';
import 'api_constants.dart';

import '../utils/token_storage.dart';
import 'network_info.dart';

class ApiService {
  final http.Client client;
  final NetworkInfo networkInfo;

  ApiService({http.Client? client, NetworkInfo? networkInfo}) 
      : client = client ?? http.Client(),
        networkInfo = networkInfo ?? NetworkInfoImpl(Connectivity());

  // Helper to get headers with optional auth
  Future<Map<String, String>> _getHeaders(Map<String, String>? extraHeaders, bool requireAuth) async {
    final Map<String, String> headers = {...ApiConstants.headers, ...?extraHeaders};
    
    if (requireAuth) {
      final authHeader = await TokenStorage.getAuthorizationHeader();
      if (authHeader != null) {
        headers['Authorization'] = authHeader;
      }
    }
    
    return headers;
  }

  Future<Result<T>> get<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool requireAuth = false,
  }) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('No Internet Connection'));
    }
    try {
      final requestHeaders = await _getHeaders(headers, requireAuth);
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: requestHeaders,
      );

      return _handleResponse(response, fromJson);
    } on SocketException catch (e) {
      debugPrint('ApiService SocketException [GET $endpoint]: ${e.message}');
      return Result.failure(NetworkFailure('Network Error: ${e.message}'));
    } catch (e) {
      debugPrint('ApiService Exception [GET $endpoint]: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool requireAuth = false,
  }) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('No Internet Connection'));
    }
    try {
      final requestHeaders = await _getHeaders(headers, requireAuth);
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: requestHeaders,
        body: jsonEncode(body),
      );

      return _handleResponse(response, fromJson);
    } on SocketException catch (e) {
      debugPrint('ApiService SocketException [POST $endpoint]: ${e.message}');
      return Result.failure(NetworkFailure('Network Error: ${e.message}'));
    } catch (e) {
      debugPrint('ApiService Exception [POST $endpoint]: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<T>> put<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool requireAuth = false,
  }) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('No Internet Connection'));
    }
    try {
      final requestHeaders = await _getHeaders(headers, requireAuth);
      final response = await client.put(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: requestHeaders,
        body: jsonEncode(body),
      );

      return _handleResponse(response, fromJson);
    } on SocketException catch (e) {
      debugPrint('ApiService SocketException [PUT $endpoint]: ${e.message}');
      return Result.failure(NetworkFailure('Network Error: ${e.message}'));
    } catch (e) {
      debugPrint('ApiService Exception [PUT $endpoint]: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<Result<T>> delete<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    bool requireAuth = false,
  }) async {
    if (!await networkInfo.isConnected) {
      return Result.failure(const NetworkFailure('No Internet Connection'));
    }
    try {
      final requestHeaders = await _getHeaders(headers, requireAuth);
      final response = await client.delete(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: requestHeaders,
      );

      return _handleResponse(response, fromJson);
    } on SocketException catch (e) {
      debugPrint('ApiService SocketException [DELETE $endpoint]: ${e.message}');
      return Result.failure(NetworkFailure('Network Error: ${e.message}'));
    } catch (e) {
      debugPrint('ApiService Exception [DELETE $endpoint]: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Result<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        // Handle nested response structure with 'data' field
        if (decoded is Map<String, dynamic>) {
          // If response has 'data' field, extract it
          if (decoded.containsKey('data')) {
            return Result.success(fromJson(decoded));
          }
          // Otherwise, use the decoded response directly
          return Result.success(fromJson(decoded));
        }
        return Result.failure(const ValidationFailure('Invalid response format'));
      } catch (e) {
        return Result.failure(ValidationFailure('Data Parsing Error: ${e.toString()}'));
      }
    } else {
      // Try to parse error message from server
      try {
        final errorBody = jsonDecode(response.body);
        return Result.failure(
          ServerFailure(errorBody['message'] ?? 'Unknown server error'),
        );
      } catch (_) {
        return Result.failure(
          ServerFailure('Server Error: ${response.statusCode}'),
        );
      }
    }
  }
}
