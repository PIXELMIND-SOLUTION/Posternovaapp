import 'package:flutter/material.dart';
import 'package:posternova/services/customer/customer_services.dart';

class CreateCustomerProvider with ChangeNotifier {
  final CustomerApiServices _apiService = CustomerApiServices();
  
  List<Map<String, dynamic>> _customers = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get customers => _customers;
  bool get isLoading => _isLoading;

  /// Add Customer - API Integration
  Future<bool> addCustomer({
    required String userId,
    required String name,
    required String email,
    required String mobile,
    required String dob,
    required String address,
    required String gender,
    required String anniversaryDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _apiService.addCustomer(
        userId: userId,
        name: name,
        email: email,
        mobile: mobile,
        dob: dob,
        address: address,
        gender: gender,
        anniversaryDate: anniversaryDate,
      );

      if (success) {
        // Refresh the customer list after successful addition
        await fetchUser(userId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Error in addCustomer: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch User and Customers - API Integration
  Future<void> fetchUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("myyyyyyyyyyyyyyyyyyyyyyyy$userId");
      final response = await _apiService.fetchUser(userId);

      if (response != null && response['customers'] != null) {
        _customers = List<Map<String, dynamic>>.from(response['customers']);
      } else {
        _customers = [];
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error in fetchUser: $e');
      _customers = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update Customer - API Integration
  Future<bool> updateCustomer({
    required String userId,
    required String customerId,
    required String name,
    required String email,
    required String mobile,
    required String address,
    required String gender,
    required String dob,
    required String anniversaryDate,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _apiService.updateCustomer(
        userId: userId,
        customerId: customerId,
        name: name,
        email: email,
        mobile: mobile,
        dob: dob,
        address: address,
        gender: gender,
        anniversaryDate: anniversaryDate,
      );

      if (success) {
        // Refresh the customer list after successful update
        await fetchUser(userId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Error in updateCustomer: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete Customer - API Integration
  Future<bool> deleteCustomer({
    required String userId,
    required String customerId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _apiService.deleteCustomer(
        userId: userId,
        customerId: customerId,
      );

      if (success) {
        // Refresh the customer list after successful deletion
        await fetchUser(userId);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Error in deleteCustomer: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}