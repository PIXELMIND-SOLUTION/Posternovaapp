
import 'package:flutter/material.dart';
import 'package:posternova/models/redeem_model.dart';
import 'package:posternova/services/redeem/redeem_service.dart';


class RedeemProvider extends ChangeNotifier {
  final RedeemService _redeemService = RedeemService();
  
  // Loading states
  bool _isSubmittingRedemption = false;
  bool _isLoadingHistory = false;
  
  // Data
  RedeemResponse? _lastRedeemResponse;
  List<RedemptionHistory> _redemptionHistory = [];
  String? _errorMessage;
  
  // Getters
  bool get isSubmittingRedemption => _isSubmittingRedemption;
  bool get isLoadingHistory => _isLoadingHistory;
  RedeemResponse? get lastRedeemResponse => _lastRedeemResponse;
  List<RedemptionHistory> get redemptionHistory => _redemptionHistory;
  String? get errorMessage => _errorMessage;
  
  // Submit redemption request
  Future<bool> submitRedemption({
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String bankName,
    required String upiId,
  }) async {
    _isSubmittingRedemption = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _redeemService.submitRedemption(
        accountHolderName: accountHolderName,
        accountNumber: accountNumber,
        ifscCode: ifscCode,
        bankName: bankName,
        upiId: upiId,
      );
      
      if (response != null) {
        _lastRedeemResponse = response;
        _isSubmittingRedemption = false;
        notifyListeners();
        
        // Refresh history after successful submission
        await getRedemptionHistory();
        
        return true;
      } else {
        _errorMessage = 'Failed to submit redemption request';
        _isSubmittingRedemption = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isSubmittingRedemption = false;
      notifyListeners();
      return false;
    }
  }
  
  // Get redemption history
  Future<void> getRedemptionHistory() async {
    _isLoadingHistory = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final history = await _redeemService.getRedemptionHistory();
      if (history != null) {
        _redemptionHistory = history;
      } else {
        _redemptionHistory = [];
        _errorMessage = 'Failed to load redemption history';
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _redemptionHistory = [];
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }
  
  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  // Clear all data (for logout or reset)
  void clearData() {
    _lastRedeemResponse = null;
    _redemptionHistory.clear();
    _errorMessage = null;
    _isSubmittingRedemption = false;
    _isLoadingHistory = false;
    notifyListeners();
  }
  
  // Get pending redemptions count
  int get pendingRedemptionsCount {
    return _redemptionHistory
        .where((redemption) => redemption.status.toLowerCase() == 'pending')
        .length;
  }
  
  // Get total redeemed amount
  double get totalRedeemedAmount {
    return _redemptionHistory
        .where((redemption) => redemption.status.toLowerCase() == 'completed')
        .fold(0.0, (sum, redemption) => sum + redemption.amount);
  }
  
  // Get latest redemption
  RedemptionHistory? get latestRedemption {
    if (_redemptionHistory.isEmpty) return null;
    
    return _redemptionHistory.reduce((current, next) {
      return current.createdAt.isAfter(next.createdAt) ? current : next;
    });
  }
  
  // Filter redemptions by status
  List<RedemptionHistory> getRedemptionsByStatus(String status) {
    return _redemptionHistory
        .where((redemption) => redemption.status.toLowerCase() == status.toLowerCase())
        .toList();
  }
  
  // Check if account details already exist in any redemption
  bool hasExistingAccountDetails({
    required String accountNumber,
    required String ifscCode,
  }) {
    return _redemptionHistory.any((redemption) =>
        redemption.accountNumber == accountNumber &&
        redemption.ifscCode == ifscCode);
  }
}