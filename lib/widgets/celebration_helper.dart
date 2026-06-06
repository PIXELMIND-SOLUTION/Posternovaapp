import 'package:flutter/material.dart';
import 'package:posternova/widgets/anniversary_special_animation.dart';
import 'package:posternova/widgets/birthday_special_animation.dart';


class CelebrationOverlayHelper {
  static bool _isCelebrationCategory(String? categoryName) {
    if (categoryName == null) return false;
    final lower = categoryName.toLowerCase().trim();
    return lower == 'birthday' || lower == 'anniversary';
  }

  static bool isBirthday(String? categoryName) =>
      categoryName?.toLowerCase().trim() == 'birthday';

  static bool isAnniversary(String? categoryName) =>
      categoryName?.toLowerCase().trim() == 'anniversary';

  /// Returns the overlay widget or null if category doesn't need one.
  static Widget? buildOverlay({
    required String? categoryName,
    required VoidCallback onDismiss,
  }) {
    if (isBirthday(categoryName)) {
      return BirthdayCelebrationOverlay(onDismiss: onDismiss);
    }
    if (isAnniversary(categoryName)) {
      return AnniversaryCelebrationOverlay(onDismiss: onDismiss);
    }
    return null;
  }
}