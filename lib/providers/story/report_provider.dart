
import 'package:flutter/material.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/services/story/report_story_service.dart';

class ReportStoryProvider extends ChangeNotifier {
  final ReportStoryService _reportService = ReportStoryService();
  
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setSuccessMessage(String? message) {
    _successMessage = message;
    notifyListeners();
  }

  void clearMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> reportUser({
    required String reportedUserId,
    required BuildContext context,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      _setSuccessMessage(null);

      // Get current user data
      final userData = await AuthPreferences.getUserData();
      if (userData == null || userData.user.id == null) {
        _setError('User not authenticated');
        return false;
      }

      final currentUserId = userData.user.id.toString();

      // Make API call
      final result = await _reportService.reportUser(
        userId: currentUserId,
        reportedUserId: reportedUserId,
      );

      if (result['success']) {
        _setSuccessMessage(result['message']);
        return true;
      } else {
        _setError(result['message']);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      print('Error in reportUser: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> blockUser({
    required String blockedUserId,
    required BuildContext context,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      _setSuccessMessage(null);

      // Get current user data
      final userData = await AuthPreferences.getUserData();
      if (userData == null || userData.user.id == null) {
        _setError('User not authenticated');
        return false;
      }

      final currentUserId = userData.user.id.toString();

      // Make API call
      final result = await _reportService.blockUser(
        userId: currentUserId,
        blockedUserId: blockedUserId,
      );

      if (result['success']) {
        _setSuccessMessage(result['message']);
        return true;
      } else {
        _setError(result['message']);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      print('Error in blockUser: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> reportAndBlockUser({
    required String reportedUserId,
    required BuildContext context,
    required bool shouldBlock,
  }) async {
    try {
      _setLoading(true);
      _setError(null);
      _setSuccessMessage(null);

      // First, report the user
      final reportSuccess = await reportUser(
        reportedUserId: reportedUserId,
        context: context,
      );

      if (!reportSuccess) {
        return false;
      }

      // If shouldBlock is true, also block the user
      if (shouldBlock) {
        final blockSuccess = await blockUser(
          blockedUserId: reportedUserId,
          context: context,
        );

        if (!blockSuccess) {
          // Report succeeded but block failed
          _setSuccessMessage('User reported successfully, but blocking failed');
          return false;
        }

        _setSuccessMessage('User reported and blocked successfully');
      } else {
        _setSuccessMessage('User reported successfully');
      }

      return true;
    } catch (e) {
      _setError('An unexpected error occurred');
      print('Error in reportAndBlockUser: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}