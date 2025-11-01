import 'package:flutter/material.dart';

class DateTimeProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setStartDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
