import 'dart:async';

import 'package:crypto_app/data/repository/result.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:io'; // for SocketException
import 'dart:developer'; // Add this for better logging

mixin SafeCall {
  final _successCodes = [200, 201];

  Future<Result<T>> safeApiCall<T>(
    Future<HttpResponse<T>> Function() apiCall,
  ) async {
    try {
      log('SafeCall: Starting API call');
      final response = await apiCall();
      final statusCode = response.response.statusCode ?? 0;

      log('SafeCall: Received response with status code: $statusCode');

      if (_successCodes.contains(statusCode) && response.data != null) {
        log('SafeCall: Success with data');
        return Success(data: response.data!);
      } else {
        log('SafeCall: Unexpected status code or null data');
        return Failure(
          message:
              'Server returned status $statusCode: ${response.response.statusMessage ?? 'Unknown error'}',
          statusCode: statusCode,
        );
      }
    } on DioException catch (dioError, stackTrace) {
      log('SafeCall: DioException caught - Type: ${dioError.type}');
      log(
        'SafeCall: DioException response status: ${dioError.response?.statusCode}',
      );
      log('SafeCall: DioException stack trace: $stackTrace');

      final statusCode = dioError.response?.statusCode;
      final message = _parseDioError(dioError);

      // Don't include stack trace in user-facing message
      return Failure(message: message, statusCode: statusCode);
    } on SocketException catch (socketError, stackTrace) {
      log('SafeCall: SocketException caught: $socketError');
      log('SafeCall: SocketException stack trace: $stackTrace');
      return Failure(
        message: 'No internet connection. Please check your network settings.',
      );
    } on TimeoutException catch (timeoutError, stackTrace) {
      log('SafeCall: TimeoutException caught: $timeoutError');
      log('SafeCall: TimeoutException stack trace: $stackTrace');
      return Failure(message: 'Request timed out. Please try again.');
    } catch (e, stackTrace) {
      log('SafeCall: Unknown exception caught: $e');
      log('SafeCall: Unknown exception type: ${e.runtimeType}');
      log('SafeCall: Unknown exception stack trace: $stackTrace');

      // Check if it's actually a network-related error disguised as something else
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('socket') ||
          errorString.contains('network') ||
          errorString.contains('connection') ||
          errorString.contains('timeout')) {
        return Failure(
          message:
              'Network connection error. Please check your internet connection.',
        );
      }

      return Failure(message: 'Something went wrong. Please try again later.');
    }
  }

  String _parseDioError(DioException error) {
    log('SafeCall: Parsing DioException type: ${error.type}');

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timed out while sending data.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final data = error.response?.data;

        log('SafeCall: Bad response - Status: $statusCode, Data: $data');

        // Handle authentication errors specifically
        if (statusCode == 401) {
          // Check if this is a refresh token error
          if (data is Map &&
              data['error'] == 'Unauthorized' &&
              data['message']?.toString().contains('refresh token') == true) {
            return 'Your session has expired. Please log in again.';
          }
          return 'Authentication failed. Please log in again.';
        }

        // Try to extract meaningful error message from response
        if (data is Map && data['message'] != null) {
          if (data['message'] is List) {
            return (data['message'] as List).join('\n');
          }
          return data['message'].toString();
        }

        // Provide user-friendly messages for common status codes
        switch (statusCode) {
          case 400:
            return 'Invalid request. Please check your input.';
          case 403:
            return 'Access denied. You don\'t have permission to access this resource.';
          case 404:
            return 'Resource not found. Please try again later.';
          case 500:
            return 'Server error. Please try again later.';
          case 503:
            return 'Service temporarily unavailable. Please try again later.';
          default:
            return 'Server returned an error (Status: $statusCode).';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please check your connection.';
      case DioExceptionType.connectionError:
        log('SafeCall: Connection error - Underlying error: ${error.error}');

        // Check if the underlying error is a SocketException
        if (error.error is SocketException) {
          return 'No internet connection. Please check your network settings.';
        }
        return 'Failed to connect to the server. Please check your internet connection.';
      case DioExceptionType.unknown:
        log(
          'SafeCall: Unknown DioException - Underlying error: ${error.error}',
        );

        // Handle possible socket error or other network issues
        if (error.error is SocketException) {
          return 'No internet connection. Please check your network settings.';
        }

        // Check error message for common network issues
        final errorMessage = error.message?.toLowerCase() ?? '';
        if (errorMessage.contains('socket') ||
            errorMessage.contains('network') ||
            errorMessage.contains('host lookup failed') ||
            errorMessage.contains('connection refused')) {
          return 'Network connection error. Please check your internet connection.';
        }

        return 'An unexpected error occurred. Please try again.';
    }
  }
}
