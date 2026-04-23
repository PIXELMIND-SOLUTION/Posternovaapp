import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/admin_amount_model.dart';

class AdminAmountProvider extends ChangeNotifier {
  List<AdminAmount> _amounts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AdminAmount> get amounts => _amounts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalAmount => _amounts.fold(0, (sum, item) => sum + item.amount);

  // Fetch all admin amounts
  Future<void> fetchAdminAmounts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://82.29.162.67:4061/api/admin/allamount'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final adminAmountResponse = AdminAmountResponse.fromJson(jsonData);
        _amounts = adminAmountResponse.data;
        _errorMessage = null;
      } else {
        _errorMessage =
            'Failed to load amounts. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      debugPrint('Error fetching admin amounts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get amount by name
  AdminAmount? getAmountByName(String name) {
    try {
      return _amounts.firstWhere(
        (amount) => amount.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get amount by ID
  AdminAmount? getAmountById(String id) {
    try {
      return _amounts.firstWhere((amount) => amount.id == id);
    } catch (e) {
      return null;
    }
  }
}
