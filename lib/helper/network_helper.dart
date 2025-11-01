import 'dart:io';

class NetworkHelper {
  /// Check if the exception is due to no internet connection
  static bool isNoInternetError(dynamic error) {
    if (error is SocketException) {
      return true;
    }
    
    // Also check for common network error patterns in error messages
    final errorString = error.toString().toLowerCase();
    return errorString.contains('failed host lookup') ||
           errorString.contains('network is unreachable') ||
           errorString.contains('connection refused') ||
           errorString.contains('no internet connection') ||
           errorString.contains('check your network connection');
  }

  /// Get a user-friendly error message
  static String getErrorMessage(dynamic error) {
    if (isNoInternetError(error)) {
      return 'Please turn on your internet connection';
    }
    return error.toString();
  }

  /// Check if error is a timeout
  static bool isTimeoutError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('timeout') ||
           errorString.contains('deadline exceeded');
  }
}
