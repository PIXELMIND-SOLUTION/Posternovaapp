
import 'package:flutter/material.dart';
import 'package:posternova/models/get_all_plan_model.dart';
import 'package:posternova/services/plan/get_all_plan_service.dart';

class GetAllPlanProvider extends ChangeNotifier {
  final GetAllPlanServices _planService = GetAllPlanServices();

  List<GetAllPlanModel> _plans = [];
  bool _isLoading = false;
  String? _error;

  List<GetAllPlanModel> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllPlans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
            print('sfjsjfjsjjsdfjskhffdfdfdkfjdlfjlsdfjdslfjdslfjsdfjdsfj');

      _plans = await _planService.fetchAllPlans();
                  print('sfjsjfjsjjsdfjskhffdfdfdkfjdlfjlsdfjdslfjdslfjsdfjdsfj${_plans.length}');
                      print('📋 ALL PLAN DATA:');
    for (int i = 0; i < _plans.length; i++) {
      print('Plan $i:');
      print('  - ID: ${_plans[i].id}');
      print('  - Name: ${_plans[i].name}');
      print('  - Price: ${_plans[i].originalPrice}');
      print('  - Offer Price: ${_plans[i].offerPrice}');
      print('  - Duration: ${_plans[i].duration}');
      print('  - Features: ${_plans[i].features}');
      print('  ---');
    }
                        _isLoading = false;
      notifyListeners();

    } catch (e) {
      print('sfjsjfjsjjsdfjs$e');
      print('planssssssssss$_plans');
      _error = e.toString();
            notifyListeners();
    } 
  }
}
