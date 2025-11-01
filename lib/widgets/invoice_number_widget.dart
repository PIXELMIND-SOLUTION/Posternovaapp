import 'package:shared_preferences/shared_preferences.dart';

Future<String> generateInvoiceNumber() async {
  final now = DateTime.now();
  final datePart = "${now.year}${_twoDigits(now.month)}${_twoDigits(now.day)}";

  final prefs = await SharedPreferences.getInstance();
  final key = "invoice_count_$datePart";
  int count = prefs.getInt(key) ?? 0;
  count++;

  await prefs.setInt(key, count);

  final countPart = count.toString().padLeft(4, '0'); // e.g., 0001
  return "INV-$datePart-$countPart";
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');
