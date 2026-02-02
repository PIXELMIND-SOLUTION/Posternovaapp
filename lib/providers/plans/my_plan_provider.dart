import 'package:flutter/material.dart';
import 'package:posternova/models/subscribe_plan_model.dart';
import 'package:posternova/services/plan/my_plan_service.dart';

class MyPlanProvider extends ChangeNotifier {
  final MyPlanServices _planService = MyPlanServices();

  SubscribePlanModel? _subscribedPlan;
  bool _isLoading = false;
  bool _isPurchase = false;
  bool _isActive = false;
  String? _error;

  SubscribePlanModel? get subscribedPlan => _subscribedPlan;
  bool get isLoading => _isLoading;
  bool get isPurchase => _isPurchase;
  bool get isActive => _isActive;
  String? get error => _error;

  Future<void> fetchMyPlan(String userId) async {
    print("🚀 Starting fetchMyPlan for userId: $userId");

    // Validate userId
    if (userId.isEmpty) {
      print("❌ UserId is empty");
      _error = "User ID cannot be empty";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // print('gggggggggggggggggggggggggggggggggggggggg${fetchMyPlan(userId)}');
      // print('🔄 Calling API service...');

      // _subscribedPlan = await _planService.fetchUserPlan(userId);

      // print('📦 Service returned: ${_subscribedPlan != null ? 'Plan found' : 'No plan'}');

      // if (_subscribedPlan != null) {
      //   _isPurchase = _subscribedPlan!.isSubscribedPlan;
      //   _isActive=_subscribedPlan!.isSubscribedPlan;
      //   print('✅ Plan found - isPurchase: $_isPurchase');
      //    print('✅ Plan foundfffffffffffffffffffffffffffff: $_isActive');
      //   print('📋 Plan details: ${_subscribedPlan.toString()}');
      // } else {
      //   _isPurchase = false;
      //   print('❌ No plan found, setting _isPurchase to false');
      // }

      print('🔄 Calling API service...');

      _subscribedPlan = await _planService.fetchUserPlan(userId);

      // print('📦 Service returned: ${_subscribedPlan != null ? 'Plan found' : 'No plan'}');
      //  print('📦 Service returned: ${_subscribedPlan != null ? 'Plan found' : 'No plan'}');
      // print('✅ isSubscribedPlan: ${_subscribedPlan!.isSubscribedPlan}');
      // print('🎁 free7DayTrial: ${_subscribedPlan!.free7DayTrial}');

      if (_subscribedPlan != null) {
        final bool isSubscribed = _subscribedPlan!.isSubscribedPlan == true;
        final bool isFreeTrial = _subscribedPlan!.free7DayTrial == true;

        // User has access if subscribed OR free trial
        _isPurchase = isSubscribed || isFreeTrial;
        _isActive = _isPurchase;

        print('✅ isSubscribedPlan: $isSubscribed');
        print('🎁 free7DayTrial: $isFreeTrial');
        print('🔓 Final access (_isPurchase): $_isPurchase');
        print('📋 Plan details: ${_subscribedPlan.toString()}');
      } else {
        _isPurchase = false;
        _isActive = false;
        print('❌ No plan found, access denied');
      }
    } catch (e) {
      print('❌ Error in fetchMyPlan: $e');
      _error = e.toString();
      _isPurchase = false;
    } finally {
      _isLoading = false;
      print('🏁 fetchMyPlan completed - Loading: $_isLoading, Error: $_error');
      notifyListeners();
    }
  }

  // Toggle the selection state of the subscribed plan
  void togglePlanSelection() {
    if (_subscribedPlan != null) {
      _subscribedPlan = _subscribedPlan!.copyWith(
        isSelected: !_subscribedPlan!.isSelected,
      );
      _isPurchase = _subscribedPlan!.isSelected;
      notifyListeners();
    }
  }

  // Set the selection state of the subscribed plan
  void setPlanSelection(bool isSelected) {
    if (_subscribedPlan != null) {
      _subscribedPlan = _subscribedPlan!.copyWith(isSelected: isSelected);
      _isPurchase = isSelected;
      notifyListeners();
    }
  }

  // Clear the subscribed plan
  void clearPlan() {
    _subscribedPlan = null;
    _error = null;
    _isPurchase = false;
    notifyListeners();
  }

  // Update purchase status
  void setPurchaseStatus(bool status) {
    _isPurchase = status;
    notifyListeners();
  }
}
