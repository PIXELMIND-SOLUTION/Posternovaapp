import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CelebrationOverlay extends StatefulWidget {
  final Map<String, dynamic> birthdayData;
  final List<dynamic> customers;

  const CelebrationOverlay({
    Key? key,
    required this.birthdayData,
    required this.customers,
  }) : super(key: key);

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> {
  bool _showWishesSection = true;
  bool _showCustomerCelebrationsSection = true;

  @override
  void initState() {
    super.initState();
    _loadSectionPreferences();
  }

  Future<void> _loadSectionPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showWishesSection = prefs.getBool('show_wishes_section') ?? true;
      _showCustomerCelebrationsSection =
          prefs.getBool('show_customer_celebrations') ?? true;
    });
  }

  Future<void> _saveWishesSectionPreference(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_wishes_section', show);
  }

  Future<void> _saveCustomerCelebrationsPreference(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_customer_celebrations', show);
  }

  @override
  Widget build(BuildContext context) {
    // Check if we have any celebrations to show
    bool hasWishes = _showWishesSection &&
        widget.birthdayData['wishes'] != null &&
        widget.birthdayData['wishes'].isNotEmpty;

    List<String> celebrations = _getCustomerCelebrations();
    bool hasCelebrations =
        _showCustomerCelebrationsSection && celebrations.isNotEmpty;

    if (!hasWishes && !hasCelebrations) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (hasWishes) _buildWishesSection(),
        if (hasCelebrations) _buildCustomerCelebrationsSection(celebrations),
      ],
    );
  }

  List<String> _getCustomerCelebrations() {
    List<String> celebrations = [];

    if (widget.customers.isNotEmpty) {
      final today = DateTime.now();

      for (var customer in widget.customers) {
        // Birthday check
        if (customer['dob'] != null && customer['dob'].isNotEmpty) {
          try {
            final dob = DateTime.parse(customer['dob']);
            if (dob.month == today.month && dob.day == today.day) {
              final age = today.year - dob.year;
              String suffix = _getOrdinalSuffix(age);
              final celebration = age > 0
                  ? "🎂 Happy ${age}${suffix} Birthday ${customer['name']}!"
                  : "🎂 Happy Birthday ${customer['name']}!";
              celebrations.add(celebration);
            }
          } catch (e) {
            print('Error parsing DOB: $e');
          }
        }

        // Anniversary check
        if (customer['anniversaryDate'] != null &&
            customer['anniversaryDate'].isNotEmpty) {
          try {
            final anniversary = DateTime.parse(customer['anniversaryDate']);
            if (anniversary.month == today.month &&
                anniversary.day == today.day) {
              final years = today.year - anniversary.year;
              String suffix = _getOrdinalSuffix(years);
              final celebration = years > 0
                  ? "💐 Happy ${years}${suffix} Anniversary ${customer['name']}!"
                  : "💐 Happy Anniversary ${customer['name']}!";
              celebrations.add(celebration);
            }
          } catch (e) {
            print('Error parsing anniversary: $e');
          }
        }
      }
    }

    return celebrations;
  }

  String _getOrdinalSuffix(int number) {
    if (number % 10 == 1 && number != 11) {
      return 'st';
    } else if (number % 10 == 2 && number != 12) {
      return 'nd';
    } else if (number % 10 == 3 && number != 13) {
      return 'rd';
    } else {
      return 'th';
    }
  }

  Widget _buildWishesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F7FA), Color.fromARGB(255, 236, 178, 242)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(103, 58, 183, 1).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFF80DEEA), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF00838F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.celebration, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 26,
              child: Marquee(
                text: widget.birthdayData['wishes'].join("  •  "),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004D40),
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 40.0,
                velocity: 35.0,
                pauseAfterRound: Duration(seconds: 2),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                accelerationCurve: Curves.easeInOut,
                decelerationDuration: Duration(milliseconds: 600),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _showWishesSection = false;
              });
              _saveWishesSectionPreference(false);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xFF00838F),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCelebrationsSection(List<String> celebrations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6F00).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFFFB74D), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE65100),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.cake, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 26,
              child: Marquee(
                text: celebrations.join("  •  "),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFBF360C),
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 40.0,
                velocity: 35.0,
                pauseAfterRound: const Duration(seconds: 2),
                startPadding: 10.0,
                accelerationDuration: const Duration(seconds: 1),
                accelerationCurve: Curves.easeInOut,
                decelerationDuration: const Duration(milliseconds: 600),
                decelerationCurve: Curves.easeOut,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _showCustomerCelebrationsSection = false;
              });
              _saveCustomerCelebrationsPreference(false);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Color(0xFFE65100),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}