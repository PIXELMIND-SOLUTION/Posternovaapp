// lib/providers/invoice_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/invoice_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


class ProductInvoiceProvider extends ChangeNotifier {
  static const String _invoicesKey = 'user_invoices';
  List<Invoice> _invoices = [];

  // Getter that returns a copy of the list to prevent direct modification
  List<Invoice> get invoices => List.unmodifiable(_invoices);

  // Initialize provider by loading saved invoices
  Future<void> loadInvoices() async {
    final userData = await AuthPreferences.getUserData();
    if (userData == null) return;

    final prefs = await SharedPreferences.getInstance();
    final invoicesJson = prefs.getString(_invoicesKey);
    
    if (invoicesJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(invoicesJson);
        final List<Invoice> loadedInvoices = decoded
            .map((item) => Invoice.fromJson(item))
            .where((invoice) => invoice.userId == userData.user.id)
            .toList();
        
        _invoices = loadedInvoices;
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading invoices: $e');
      }
    }
  }

  // Save all invoices to SharedPreferences
  Future<void> _saveInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_invoices.map((e) => e.toJson()).toList());
    await prefs.setString(_invoicesKey, encodedData);
  }

  // Add a new invoice
  Future<bool> addInvoice(List<ProductItem> products) async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData == null) return false;

      final newInvoice = Invoice(
        id: const Uuid().v4(),
        products: products,
        createdAt: DateTime.now(),
        userId: userData.user.id,
      );

      _invoices.add(newInvoice);
      await _saveInvoices();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding invoice: $e');
      return false;
    }
  }

  // Delete an invoice by ID
  Future<bool> deleteInvoice(String invoiceId) async {
    try {
      _invoices.removeWhere((invoice) => invoice.id == invoiceId);
      await _saveInvoices();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
      return false;
    }
  }

  // Get all invoices for the current user
  Future<List<Invoice>> getUserInvoices() async {
    final userData = await AuthPreferences.getUserData();
    if (userData == null) return [];

    return _invoices
        .where((invoice) => invoice.userId == userData.user.id)
        .toList();
  }
}