// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DateTimeProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setStartDate(DateTime date) {
    print('📅 DateTimeProvider: Setting date to ${_formatDate(date)}');
    print('   Old date: ${_formatDate(_selectedDate)}');

    // Create a new DateTime object to avoid reference issues
    _selectedDate = DateTime(date.year, date.month, date.day);
    print('   New date set to: ${_formatDate(_selectedDate)}');

    notifyListeners();
    print('✅ DateTimeProvider: Notified listeners');
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }
}
