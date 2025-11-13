// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class HoroscopeScreen extends StatefulWidget {
//   const HoroscopeScreen({super.key});

//   @override
//   State<HoroscopeScreen> createState() => _HoroscopeScreenState();
// }

// class _HoroscopeScreenState extends State<HoroscopeScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late AnimationController _scaleController;
//   late AnimationController _shimmerController;
  
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _shimmerAnimation;

//   String selectedSign = 'leo';
//   int selectedIndex = 4; // Default to Leo
//   Map<String, dynamic>? horoscopeData;
//   bool isLoading = false;

//   final List<Map<String, dynamic>> zodiacSigns = [
//     {
//       'name': 'Aries',
//       'apiName': 'aries',
//       'symbol': '♈',
//       'dates': 'Mar 21 - Apr 19',
//       'element': 'Fire',
//       'color': const Color(0xFFE74C3C),
//       'gradient': [const Color(0xFFE74C3C), const Color(0xFFF39C12)],
//       'description': 'Bold and ambitious, Aries dives headfirst into even the most challenging situations.',
//     },
//     {
//       'name': 'Taurus',
//       'apiName': 'taurus',
//       'symbol': '♉',
//       'dates': 'Apr 20 - May 20',
//       'element': 'Earth',
//       'color': const Color(0xFF27AE60),
//       'gradient': [const Color(0xFF27AE60), const Color(0xFF2ECC71)],
//       'description': 'Smart, ambitious, and trustworthy, Taurus is the anchor of the Zodiac.',
//     },
//     {
//       'name': 'Gemini',
//       'apiName': 'gemini',
//       'symbol': '♊',
//       'dates': 'May 21 - Jun 20',
//       'element': 'Air',
//       'color': const Color(0xFFF1C40F),
//       'gradient': [const Color(0xFFF1C40F), const Color(0xFFE67E22)],
//       'description': 'Playful and intellectually curious, Gemini is constantly juggling a variety of passions.',
//     },
//     {
//       'name': 'Cancer',
//       'apiName': 'cancer',
//       'symbol': '♋',
//       'dates': 'Jun 21 - Jul 22',
//       'element': 'Water',
//       'color': const Color(0xFF3498DB),
//       'gradient': [const Color(0xFF3498DB), const Color(0xFF2980B9)],
//       'description': 'Deeply intuitive and sentimental, Cancer can be one of the most challenging signs to get to know.',
//     },
//     {
//       'name': 'Leo',
//       'apiName': 'leo',
//       'symbol': '♌',
//       'dates': 'Jul 23 - Aug 22',
//       'element': 'Fire',
//       'color': const Color(0xFFE67E22),
//       'gradient': [const Color(0xFFE67E22), const Color(0xFFF39C12)],
//       'description': 'Bold, intelligent, warm, and courageous, Leo is a natural leader.',
//     },
//     {
//       'name': 'Virgo',
//       'apiName': 'virgo',
//       'symbol': '♍',
//       'dates': 'Aug 23 - Sep 22',
//       'element': 'Earth',
//       'color': const Color(0xFF8E44AD),
//       'gradient': [const Color(0xFF8E44AD), const Color(0xFF9B59B6)],
//       'description': 'Logical, practical, and systematic, Virgo is the perfectionist of the zodiac.',
//     },
//     {
//       'name': 'Libra',
//       'apiName': 'libra',
//       'symbol': '♎',
//       'dates': 'Sep 23 - Oct 22',
//       'element': 'Air',
//       'color': const Color(0xFFE91E63),
//       'gradient': [const Color(0xFFE91E63), const Color(0xFF9C27B0)],
//       'description': 'Diplomatic and fair-minded, Libra is obsessed with symmetry and balance.',
//     },
//     {
//       'name': 'Scorpio',
//       'apiName': 'scorpio',
//       'symbol': '♏',
//       'dates': 'Oct 23 - Nov 21',
//       'element': 'Water',
//       'color': const Color(0xFF8E24AA),
//       'gradient': [const Color(0xFF8E24AA), const Color(0xFF673AB7)],
//       'description': 'Passionate, stubborn, and resourceful, Scorpio is one of the most dynamic signs.',
//     },
//     {
//       'name': 'Sagittarius',
//       'apiName': 'sagittarius',
//       'symbol': '♐',
//       'dates': 'Nov 22 - Dec 21',
//       'element': 'Fire',
//       'color': const Color(0xFF00BCD4),
//       'gradient': [const Color(0xFF00BCD4), const Color(0xFF009688)],
//       'description': 'Curious and energetic, Sagittarius is one of the biggest travelers among all zodiac signs.',
//     },
//     {
//       'name': 'Capricorn',
//       'apiName': 'capricorn',
//       'symbol': '♑',
//       'dates': 'Dec 22 - Jan 19',
//       'element': 'Earth',
//       'color': const Color(0xFF3F51B5),
//       'gradient': [const Color(0xFF3F51B5), const Color(0xFF2196F3)],
//       'description': 'Responsible and disciplined, Capricorn is a sign that represents time and responsibility.',
//     },
//     {
//       'name': 'Aquarius',
//       'apiName': 'aquarius',
//       'symbol': '♒',
//       'dates': 'Jan 20 - Feb 18',
//       'element': 'Air',
//       'color': const Color(0xFF00BCD4),
//       'gradient': [const Color(0xFF00BCD4), const Color(0xFF03A9F4)],
//       'description': 'Progressive, original, and independent, Aquarius is a humanitarian at heart.',
//     },
//     {
//       'name': 'Pisces',
//       'apiName': 'pisces',
//       'symbol': '♓',
//       'dates': 'Feb 19 - Mar 20',
//       'element': 'Water',
//       'color': const Color(0xFF9C27B0),
//       'gradient': [const Color(0xFF9C27B0), const Color(0xFFE91E63)],
//       'description': 'Compassionate, artistic, and intuitive, Pisces are known for their wisdom.',
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
    
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
    
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
    
//     _shimmerController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
//     );
    
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
//     _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
//     );
    
//     _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
//       CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
//     );

//     // Start animations
//     _fadeController.forward();
//     Future.delayed(const Duration(milliseconds: 200), () {
//       _slideController.forward();
//     });
//     Future.delayed(const Duration(milliseconds: 400), () {
//       _scaleController.forward();
//     });

//     // Fetch initial horoscope data
//     _fetchHoroscope(zodiacSigns[selectedIndex]['apiName']);
//   }

//   Future<void> _fetchHoroscope(String sign) async {
//     setState(() {
//       isLoading = true;
//     });
    
//     _shimmerController.repeat();

//     try {
//       final response = await http.get(
//         Uri.parse('http://194.164.148.244:4061/api/users/horoscope?sign=$sign'),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           horoscopeData = json.decode(response.body);
//           isLoading = false;
//         });
//         _shimmerController.stop();
//       } else {
//         setState(() {
//           isLoading = false;
//           horoscopeData = {
//             'horoscope': 'Unable to load your horoscope at the moment. Please try again later.'
//           };
//         });
//         _shimmerController.stop();
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         horoscopeData = {
//           'horoscope': 'Connection error. Please check your internet and try again.'
//         };
//       });
//       _shimmerController.stop();
//     }
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _scaleController.dispose();
//     _shimmerController.dispose();
//     super.dispose();
//   }

//   void _selectSign(int index) {
//     setState(() {
//       selectedIndex = index;
//       selectedSign = zodiacSigns[index]['apiName'];
//     });
    
//     // Restart animations for new selection
//     _scaleController.reset();
//     _scaleController.forward();
    
//     // Fetch new horoscope data
//     _fetchHoroscope(zodiacSigns[index]['apiName']);
//   }

//   Widget _buildShimmerLoading() {
//     return AnimatedBuilder(
//       animation: _shimmerAnimation,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               stops: [
//                 _shimmerAnimation.value - 0.3,
//                 _shimmerAnimation.value,
//                 _shimmerAnimation.value + 0.3,
//               ],
//               colors: [
//                 Colors.transparent,
//                 Colors.white.withOpacity(0.1),
//                 Colors.transparent,
//               ],
//             ),
//           ),
//           height: 100,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedSignData = zodiacSigns[selectedIndex];
    
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F0F23),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color(0xFF0F0F23),
//               const Color(0xFF1A1A2E),
//               selectedSignData['color'].withOpacity(0.05),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: CustomScrollView(
//             slivers: [
//               // Header
//               SliverToBoxAdapter(
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: selectedSignData['gradient'],
//                                 ),
//                                 borderRadius: BorderRadius.circular(16),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: selectedSignData['color'].withOpacity(0.3),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: const Icon(
//                                 Icons.auto_awesome,
//                                 color: Colors.white,
//                                 size: 24,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   'Daily Horoscope',
//                                   style: TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.white,
//                                     letterSpacing: -0.5,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Discover what the stars have in store',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white.withOpacity(0.6),
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 32),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
              
//               // Zodiac Signs Selector
//               SliverToBoxAdapter(
//                 child: SlideTransition(
//                   position: _slideAnimation,
//                   child: Container(
//                     height: 90,
//                     margin: const EdgeInsets.only(bottom: 24),
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       itemCount: zodiacSigns.length,
//                       itemBuilder: (context, index) {
//                         final sign = zodiacSigns[index];
//                         final isSelected = index == selectedIndex;
                        
//                         return GestureDetector(
//                           onTap: () => _selectSign(index),
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 250),
//                             margin: const EdgeInsets.only(right: 12),
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                             decoration: BoxDecoration(
//                               gradient: isSelected 
//                                   ? LinearGradient(colors: sign['gradient'])
//                                   : null,
//                               color: isSelected 
//                                   ? null
//                                   : const Color(0xFF1E1E3A),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: isSelected 
//                                     ? Colors.transparent
//                                     : const Color(0xFF2A2A4A),
//                                 width: 1,
//                               ),
//                               boxShadow: isSelected ? [
//                                 BoxShadow(
//                                   color: sign['color'].withOpacity(0.3),
//                                   blurRadius: 12,
//                                   spreadRadius: 0,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ] : [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   sign['symbol'],
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   sign['name'],
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     color: isSelected 
//                                         ? Colors.white 
//                                         : Colors.white.withOpacity(0.7),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
              
//               // Main Content
//               SliverToBoxAdapter(
//                 child: ScaleTransition(
//                   scale: _scaleAnimation,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 24),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1A1A2E),
//                       borderRadius: BorderRadius.circular(24),
//                       border: Border.all(
//                         color: const Color(0xFF2A2A4A),
//                         width: 1,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 20,
//                           spreadRadius: 0,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Sign Header
//                           Row(
//                             children: [
//                               Container(
//                                 width: 70,
//                                 height: 70,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: selectedSignData['gradient'],
//                                   ),
//                                   borderRadius: BorderRadius.circular(20),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: selectedSignData['color'].withOpacity(0.3),
//                                       blurRadius: 16,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     selectedSignData['symbol'],
//                                     style: const TextStyle(
//                                       fontSize: 32,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 20),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       selectedSignData['name'],
//                                       style: const TextStyle(
//                                         fontSize: 26,
//                                         fontWeight: FontWeight.w700,
//                                         color: Colors.white,
//                                         letterSpacing: -0.5,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       selectedSignData['dates'],
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.white.withOpacity(0.6),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Container(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 6,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: [
//                                             selectedSignData['color'].withOpacity(0.2),
//                                             selectedSignData['color'].withOpacity(0.1),
//                                           ],
//                                         ),
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(
//                                           color: selectedSignData['color'].withOpacity(0.3),
//                                           width: 1,
//                                         ),
//                                       ),
//                                       child: Text(
//                                         '${selectedSignData['element']} Element',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: selectedSignData['color'],
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
                          
//                           const SizedBox(height: 32),
                          
//                           // Description Section
//                           Container(
//                             padding: const EdgeInsets.all(20),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF0F0F23),
//                               borderRadius: BorderRadius.circular(16),
//                               border: Border.all(
//                                 color: const Color(0xFF2A2A4A),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.info_outline,
//                                       color: selectedSignData['color'],
//                                       size: 20,
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       'About ${selectedSignData['name']}',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Text(
//                                   selectedSignData['description'],
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.white.withOpacity(0.8),
//                                     height: 1.6,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
                          
//                           const SizedBox(height: 24),
                          
//                           // Today's Prediction
//                           Container(
//                             padding: const EdgeInsets.all(24),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors: [
//                                   selectedSignData['color'].withOpacity(0.1),
//                                   selectedSignData['color'].withOpacity(0.05),
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: selectedSignData['color'].withOpacity(0.2),
//                                 width: 1,
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(8),
//                                       decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                           colors: selectedSignData['gradient'],
//                                         ),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: const Icon(
//                                         Icons.auto_awesome,
//                                         color: Colors.white,
//                                         size: 18,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           const Text(
//                                             'Today\'s Horoscope',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           if (horoscopeData != null && horoscopeData!['date'] != null)
//                                             Text(
//                                               horoscopeData!['date'],
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: Colors.white.withOpacity(0.6),
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20),
//                                 if (isLoading)
//                                   Column(
//                                     children: [
//                                       _buildShimmerLoading(),
//                                       const SizedBox(height: 12),
//                                       const Center(
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 else
//                                   Text(
//                                     horoscopeData != null
//                                         ? horoscopeData!['horoscope'] ?? 'No horoscope available at the moment.'
//                                         : 'Loading your cosmic insights...',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.white.withOpacity(0.9),
//                                       height: 1.6,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
                          
//                           const SizedBox(height: 24),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
              
//               // Bottom spacing
//               const SliverToBoxAdapter(
//                 child: SizedBox(height: 32),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  String selectedSign = 'leo';
  int selectedIndex = 4;
  Map<String, dynamic>? horoscopeData;
  bool isLoading = false;

  final List<Map<String, dynamic>> zodiacSigns = [
    {
      'name': 'Aries',
      'apiName': 'aries',
      'symbol': '♈',
      'dates': 'Mar 21 - Apr 19',
      'element': 'Fire',
      'color': const Color(0xFFFF6B6B),
      'gradient': [const Color(0xFFFF6B6B), const Color(0xFFFFB347)],
      'description': 'Bold and ambitious, Aries dives headfirst into even the most challenging situations.',
    },
    {
      'name': 'Taurus',
      'apiName': 'taurus',
      'symbol': '♉',
      'dates': 'Apr 20 - May 20',
      'element': 'Earth',
      'color': const Color(0xFF4ECDC4),
      'gradient': [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      'description': 'Smart, ambitious, and trustworthy, Taurus is the anchor of the Zodiac.',
    },
    {
      'name': 'Gemini',
      'apiName': 'gemini',
      'symbol': '♊',
      'dates': 'May 21 - Jun 20',
      'element': 'Air',
      'color': const Color(0xFFFECA57),
      'gradient': [const Color(0xFFFECA57), const Color(0xFFEE5A6F)],
      'description': 'Playful and intellectually curious, Gemini is constantly juggling a variety of passions.',
    },
    {
      'name': 'Cancer',
      'apiName': 'cancer',
      'symbol': '♋',
      'dates': 'Jun 21 - Jul 22',
      'element': 'Water',
      'color': const Color(0xFF5F9DF7),
      'gradient': [const Color(0xFF5F9DF7), const Color(0xFF736EFE)],
      'description': 'Deeply intuitive and sentimental, Cancer can be one of the most challenging signs to get to know.',
    },
    {
      'name': 'Leo',
      'apiName': 'leo',
      'symbol': '♌',
      'dates': 'Jul 23 - Aug 22',
      'element': 'Fire',
      'color': const Color(0xFFFFA502),
      'gradient': [const Color(0xFFFFA502), const Color(0xFFFF6348)],
      'description': 'Bold, intelligent, warm, and courageous, Leo is a natural leader.',
    },
    {
      'name': 'Virgo',
      'apiName': 'virgo',
      'symbol': '♍',
      'dates': 'Aug 23 - Sep 22',
      'element': 'Earth',
      'color': const Color(0xFFB68CFF),
      'gradient': [const Color(0xFFB68CFF), const Color(0xFF9D6CFF)],
      'description': 'Logical, practical, and systematic, Virgo is the perfectionist of the zodiac.',
    },
    {
      'name': 'Libra',
      'apiName': 'libra',
      'symbol': '♎',
      'dates': 'Sep 23 - Oct 22',
      'element': 'Air',
      'color': const Color(0xFFFF85C0),
      'gradient': [const Color(0xFFFF85C0), const Color(0xFFCE7BB0)],
      'description': 'Diplomatic and fair-minded, Libra is obsessed with symmetry and balance.',
    },
    {
      'name': 'Scorpio',
      'apiName': 'scorpio',
      'symbol': '♏',
      'dates': 'Oct 23 - Nov 21',
      'element': 'Water',
      'color': const Color(0xFF9B59B6),
      'gradient': [const Color(0xFF9B59B6), const Color(0xFF8E44AD)],
      'description': 'Passionate, stubborn, and resourceful, Scorpio is one of the most dynamic signs.',
    },
    {
      'name': 'Sagittarius',
      'apiName': 'sagittarius',
      'symbol': '♐',
      'dates': 'Nov 22 - Dec 21',
      'element': 'Fire',
      'color': const Color(0xFF48C9B0),
      'gradient': [const Color(0xFF48C9B0), const Color(0xFF1ABC9C)],
      'description': 'Curious and energetic, Sagittarius is one of the biggest travelers among all zodiac signs.',
    },
    {
      'name': 'Capricorn',
      'apiName': 'capricorn',
      'symbol': '♑',
      'dates': 'Dec 22 - Jan 19',
      'element': 'Earth',
      'color': const Color(0xFF546DE5),
      'gradient': [const Color(0xFF546DE5), const Color(0xFF3742FA)],
      'description': 'Responsible and disciplined, Capricorn is a sign that represents time and responsibility.',
    },
    {
      'name': 'Aquarius',
      'apiName': 'aquarius',
      'symbol': '♒',
      'dates': 'Jan 20 - Feb 18',
      'element': 'Air',
      'color': const Color(0xFF45AAF2),
      'gradient': [const Color(0xFF45AAF2), const Color(0xFF26A0DA)],
      'description': 'Progressive, original, and independent, Aquarius is a humanitarian at heart.',
    },
    {
      'name': 'Pisces',
      'apiName': 'pisces',
      'symbol': '♓',
      'dates': 'Feb 19 - Mar 20',
      'element': 'Water',
      'color': const Color(0xFFD980FA),
      'gradient': [const Color(0xFFD980FA), const Color(0xFF9C88FF)],
      'description': 'Compassionate, artistic, and intuitive, Pisces are known for their wisdom.',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
    
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_rotateController);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      _scaleController.forward();
    });

    _fetchHoroscope(zodiacSigns[selectedIndex]['apiName']);
  }

  Future<void> _fetchHoroscope(String sign) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://194.164.148.244:4061/api/users/horoscope?sign=$sign'),
      );

      if (response.statusCode == 200) {
        setState(() {
          horoscopeData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          horoscopeData = {
            'horoscope': 'Unable to load your horoscope at the moment. Please try again later.'
          };
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        horoscopeData = {
          'horoscope': 'Connection error. Please check your internet and try again.'
        };
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _selectSign(int index) {
    setState(() {
      selectedIndex = index;
      selectedSign = zodiacSigns[index]['apiName'];
    });
    
    _scaleController.reset();
    _scaleController.forward();
    
    _fetchHoroscope(zodiacSigns[index]['apiName']);
  }

  @override
  Widget build(BuildContext context) {
    final selectedSignData = zodiacSigns[selectedIndex];
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E27),
              const Color(0xFF1A1A3E),
              selectedSignData['color'].withOpacity(0.1),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated Background Particles
            ...List.generate(20, (index) => _buildParticle(index)),
            
            // Main Content
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Custom App Bar
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Cosmic',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white.withOpacity(0.9),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        colors: selectedSignData['gradient'],
                                      ).createShader(bounds),
                                      child: const Text(
                                        'Journey',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: selectedSignData['gradient'],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: selectedSignData['color'].withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.stars_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Discover what the universe reveals today',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Zodiac Grid
                  SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: zodiacSigns.length,
                          itemBuilder: (context, index) {
                            final sign = zodiacSigns[index];
                            final isSelected = index == selectedIndex;
                            
                            return GestureDetector(
                              onTap: () => _selectSign(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                decoration: BoxDecoration(
                                  gradient: isSelected 
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: sign['gradient'],
                                        )
                                      : null,
                                  color: isSelected 
                                      ? null
                                      : const Color(0xFF1E1E3F).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected 
                                        ? sign['color'].withOpacity(0.5)
                                        : Colors.white.withOpacity(0.1),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected ? [
                                    BoxShadow(
                                      color: sign['color'].withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ] : [],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      sign['symbol'],
                                      style: TextStyle(
                                        fontSize: isSelected ? 32 : 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      sign['name'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(isSelected ? 1 : 0.7),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  // Main Card
                  SliverToBoxAdapter(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF1E1E3F).withOpacity(0.9),
                                const Color(0xFF2A2A5A).withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: selectedSignData['color'].withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: Stack(
                              children: [
                                // Rotating background decoration
                                Positioned(
                                  top: -50,
                                  right: -50,
                                  child: AnimatedBuilder(
                                    animation: _rotateAnimation,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _rotateAnimation.value,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            gradient: RadialGradient(
                                              colors: [
                                                selectedSignData['color'].withOpacity(0.1),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                
                                Padding(
                                  padding: const EdgeInsets.all(28),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Sign Header
                                      Row(
                                        children: [
                                          ScaleTransition(
                                            scale: _pulseAnimation,
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: selectedSignData['gradient'],
                                                ),
                                                borderRadius: BorderRadius.circular(24),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: selectedSignData['color'].withOpacity(0.5),
                                                    blurRadius: 20,
                                                    spreadRadius: 2,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  selectedSignData['symbol'],
                                                  style: const TextStyle(
                                                    fontSize: 40,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedSignData['name'],
                                                  style: const TextStyle(
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    letterSpacing: -0.5,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  selectedSignData['dates'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white.withOpacity(0.6),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 7,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        selectedSignData['color'].withOpacity(0.3),
                                                        selectedSignData['color'].withOpacity(0.1),
                                                      ],
                                                    ),
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(
                                                      color: selectedSignData['color'].withOpacity(0.5),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        _getElementIcon(selectedSignData['element']),
                                                        color: selectedSignData['color'],
                                                        size: 14,
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        selectedSignData['element'],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: selectedSignData['color'],
                                                          fontWeight: FontWeight.w700,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 28),
                                      
                                      // Description
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.1),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.auto_awesome_rounded,
                                              color: selectedSignData['color'],
                                              size: 22,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                selectedSignData['description'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white.withOpacity(0.85),
                                                  height: 1.6,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 24),
                                      
                                      // Today's Horoscope
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              selectedSignData['color'].withOpacity(0.15),
                                              selectedSignData['color'].withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(
                                            color: selectedSignData['color'].withOpacity(0.3),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: selectedSignData['gradient'],
                                                    ),
                                                    borderRadius: BorderRadius.circular(14),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: selectedSignData['color'].withOpacity(0.4),
                                                        blurRadius: 12,
                                                      ),
                                                    ],
                                                  ),
                                                  child: const Icon(
                                                    Icons.wb_sunny_rounded,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        'Today\'s Reading',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white,
                                                          letterSpacing: -0.3,
                                                        ),
                                                      ),
                                                      if (horoscopeData != null && horoscopeData!['date'] != null)
                                                        Text(
                                                          horoscopeData!['date'],
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white.withOpacity(0.5),
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            if (isLoading)
                                              Center(
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 40,
                                                      height: 40,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        valueColor: AlwaysStoppedAnimation<Color>(
                                                          selectedSignData['color'],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'Reading the stars...',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white.withOpacity(0.6),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            else
                                              Text(
                                                horoscopeData != null
                                                    ? horoscopeData!['horoscope'] ?? 'No horoscope available at the moment.'
                                                    : 'Loading your cosmic insights...',
                                                style: TextStyle(
                                                  fontSize: 15.5,
                                                  color: Colors.white.withOpacity(0.95),
                                                  height: 1.7,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 4 + 2;
    final duration = random.nextInt(3000) + 2000;
    final delay = random.nextInt(2000);
    
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        final progress = (_particleController.value + (delay / duration)) % 1.0;
        return Positioned(
          left: random.nextDouble() * MediaQuery.of(context).size.width,
          top: MediaQuery.of(context).size.height * progress,
          child: Opacity(
            opacity: (math.sin(progress * math.pi) * 0.5).clamp(0.0, 1.0),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getElementIcon(String element) {
    switch (element.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'water':
        return Icons.water_drop_rounded;
      case 'earth':
        return Icons.terrain_rounded;
      case 'air':
        return Icons.air_rounded;
      default:
        return Icons.star_rounded;
    }
  }
    }