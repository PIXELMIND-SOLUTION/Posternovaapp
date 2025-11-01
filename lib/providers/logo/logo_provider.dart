

import 'package:flutter/material.dart';
import 'package:posternova/models/logo_model.dart';
import 'package:posternova/services/logo/logo_service.dart';
// Adjust the path accordingly

class LogoProvider extends ChangeNotifier {
  final LogoService _logoService = LogoService();

  List<LogoItem> _logos = [];
  List<LogoItem> get logos => _logos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchLogos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _logos = await _logoService.fetchLogos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
