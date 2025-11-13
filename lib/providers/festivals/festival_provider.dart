
import 'package:flutter/material.dart';
import 'package:posternova/models/festival_model.dart';
import 'package:posternova/services/PosterServices/festival_service.dart';


class FestivalProvider extends ChangeNotifier {
  List<FestivalModel> _templates = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FestivalModel> get templates => _templates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFestivalTemplates(DateTime festivalDate) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _templates = await FestivalServices.fetchFestivalTemplates(festivalDate);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
