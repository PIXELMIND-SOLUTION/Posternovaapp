// // // // import 'package:flutter/material.dart';
// // // // import 'package:posternova/views/PosterModule/home.dart';
// // // // import 'package:posternova/views/category/category_screen.dart';
// // // // import 'package:posternova/views/createposter/poster_screen.dart';
// // // // import 'package:posternova/views/customer/customer_screen.dart';
// // // // import 'package:posternova/views/horrorscope/horror_scope.dart';

// // // // class MainNavigationScreen extends StatefulWidget {
// // // //   const MainNavigationScreen({Key? key}) : super(key: key);

// // // //   @override
// // // //   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// // // // }

// // // // class _MainNavigationScreenState extends State<MainNavigationScreen> {
// // // //   int _currentIndex = 0;

// // // //   final List<Widget> _screens = [
// // // //     const HomeScreen(),
// // // //     const CategoryScreen(),
// // // //     const PosterScreen(),
// // // //     const HoroscopeScreen(),
// // // //     // const ProfileScreen(),
// // // //     const CustomerScreen(),
// // // //   ];

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       body: _screens[_currentIndex],
// // // //       bottomNavigationBar: Container(
// // // //         decoration: BoxDecoration(
// // // //           gradient: const LinearGradient(
// // // //             colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
// // // //           ),
// // // //           boxShadow: [
// // // //             BoxShadow(
// // // //               color: Colors.purple.withOpacity(0.3),
// // // //               blurRadius: 20,
// // // //               offset: const Offset(0, -5),
// // // //             ),
// // // //           ],
// // // //         ),
// // // //         child: BottomNavigationBar(
// // // //           currentIndex: _currentIndex,
// // // //           onTap: (index) {
// // // //             setState(() {
// // // //               _currentIndex = index;
// // // //             });
// // // //           },
// // // //           backgroundColor: Colors.transparent,
// // // //           elevation: 0,
// // // //           type: BottomNavigationBarType.fixed,
// // // //           selectedItemColor: Colors.purple.shade300,
// // // //           unselectedItemColor: Colors.grey.shade600,
// // // //           selectedLabelStyle: const TextStyle(
// // // //             fontWeight: FontWeight.w600,
// // // //             fontSize: 12,
// // // //           ),
// // // //           unselectedLabelStyle: const TextStyle(fontSize: 12),
// // // //           items: const [
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.home_outlined, size: 28),
// // // //               activeIcon: Icon(Icons.home, size: 28),
// // // //               label: 'Home',
// // // //             ),

// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.grid_view_rounded, size: 28),
// // // //               activeIcon: Icon(Icons.grid_view, size: 28),
// // // //               label: 'Category',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.edit_outlined, size: 28),
// // // //               activeIcon: Icon(Icons.edit, size: 28),
// // // //               label: 'Poster',
// // // //             ),
// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.auto_awesome, size: 28),
// // // //               activeIcon: Icon(Icons.auto_awesome, size: 28),
// // // //               label: 'HorrorScope',
// // // //             ),

// // // //             BottomNavigationBarItem(
// // // //               icon: Icon(Icons.group_outlined, size: 28),
// // // //               activeIcon: Icon(Icons.group, size: 28),
// // // //               label: 'Customer',
// // // //             ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }



// // // import 'package:flutter/material.dart';
// // // import 'package:posternova/views/PosterModule/home.dart';
// // // import 'package:posternova/views/category/category_screen.dart';
// // // import 'package:posternova/views/createposter/poster_screen.dart';
// // // import 'package:posternova/views/customer/customer_screen.dart';
// // // import 'package:posternova/views/reels/reels_screen.dart';
// // // import 'package:posternova/widgets/language_widget.dart';
// // // import 'package:upgrader/upgrader.dart';

// // // class MainNavigationScreen extends StatefulWidget {
// // //   const MainNavigationScreen({Key? key}) : super(key: key);

// // //   @override
// // //   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// // // }

// // // class _MainNavigationScreenState extends State<MainNavigationScreen> {
// // //   int _currentIndex = 0;

// // //   final List<Widget> _screens = [
// // //     const HomeScreen(),
// // //     const CategoryScreen(),
// // //     const PosterScreen(),
// // //     const ReelsScreen(),
// // //     // const OnlinePunchangScreen(),

// // //     // const HoroscopeScreen(),
// // //     // const ProfileScreen(),
// // //     const CustomerScreen(),
// // //   ];

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return UpgradeAlert(
// // //       // Customize the upgrade alert dialog
// // //       upgrader: Upgrader(durationUntilAlertAgain: const Duration(days: 1)),
// // //       dialogStyle:
// // //           UpgradeDialogStyle.material, // or UpgradeDialogStyle.cupertino
// // //       showLater: true, // Show "Later" button
// // //       showIgnore: false, // Hide "Ignore" button
// // //       child: Scaffold(
// // //         body: _screens[_currentIndex],
// // //         bottomNavigationBar: Container(
// // //           decoration: BoxDecoration(
// // //             gradient: const LinearGradient(
// // //               colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
// // //             ),
// // //             boxShadow: [
// // //               BoxShadow(
// // //                 color: Colors.purple.withOpacity(0.3),
// // //                 blurRadius: 20,
// // //                 offset: const Offset(0, -5),
// // //               ),
// // //             ],
// // //           ),
// // //           child: BottomNavigationBar(
// // //             currentIndex: _currentIndex,
// // //             onTap: (index) {
// // //               setState(() {
// // //                 _currentIndex = index;
// // //               });
// // //             },
// // //             backgroundColor: Colors.transparent,
// // //             elevation: 0,
// // //             type: BottomNavigationBarType.fixed,
// // //             selectedItemColor: Colors.purple.shade300,
// // //             unselectedItemColor: Colors.grey.shade600,
// // //             selectedLabelStyle: const TextStyle(
// // //               fontWeight: FontWeight.w600,
// // //               fontSize: 12,
// // //             ),
// // //             unselectedLabelStyle: const TextStyle(fontSize: 12),

// // //             // items: const [
// // //             //   BottomNavigationBarItem(
// // //             //     icon: Icon(Icons.home_outlined, size: 28),
// // //             //     activeIcon: Icon(Icons.home, size: 28),
// // //             //     label: 'Home',
// // //             //   ),
// // //             //   BottomNavigationBarItem(
// // //             //     icon: Icon(Icons.grid_view_rounded, size: 28),
// // //             //     activeIcon: Icon(Icons.grid_view, size: 28),
// // //             //     label: 'Category',
// // //             //   ),
// // //             //   BottomNavigationBarItem(
// // //             //     icon: Icon(Icons.edit_outlined, size: 28),
// // //             //     activeIcon: Icon(Icons.edit, size: 28),
// // //             //     label: 'Poster',
// // //             //   ),
// // //             //   // BottomNavigationBarItem(
// // //             //   //   icon: Icon(Icons.calendar_month, size: 28),
// // //             //   //   activeIcon: Icon(Icons.calendar_month, size: 28),
// // //             //   //   label: 'Punchang',
// // //             //   // ),
// // //             //   BottomNavigationBarItem(
// // //             //     icon: Icon(Icons.video_library, size: 28),
// // //             //     activeIcon: Icon(Icons.video_library, size: 28),
// // //             //     label: 'Reels',
// // //             //   ),
// // //             //   //     BottomNavigationBarItem(
// // //             //   //   icon: Icon(Icons.calendar_month, size: 28),
// // //             //   //   activeIcon: Icon(Icons.calendar_month, size: 28),
// // //             //   //   label: 'Punchang',
// // //             //   // ),
// // //             //   BottomNavigationBarItem(
// // //             //     icon: Icon(Icons.group_outlined, size: 28),
// // //             //     activeIcon: Icon(Icons.group, size: 28),
// // //             //     label: 'Customer',
// // //             //   ),
// // //             // ],
// // //             items: [
// // //               BottomNavigationBarItem(
// // //                 icon: Icon(Icons.home_outlined, size: 28),
// // //                 activeIcon: Icon(Icons.home, size: 28),
// // //                 label: AppText.translate(context, 'home'),
// // //               ),
// // //               BottomNavigationBarItem(
// // //                 icon: Icon(Icons.grid_view_rounded, size: 28),
// // //                 activeIcon: Icon(Icons.grid_view, size: 28),
// // //                 label: AppText.translate(context, 'category'),
// // //               ),
// // //               BottomNavigationBarItem(
// // //                 icon: Icon(Icons.edit_outlined, size: 28),
// // //                 activeIcon: Icon(Icons.edit, size: 28),
// // //                 label: AppText.translate(context, 'poster'),
// // //               ),
// // //               BottomNavigationBarItem(
// // //                 icon: Icon(Icons.video_library, size: 28),
// // //                 activeIcon: Icon(Icons.video_library, size: 28),
// // //                 label: AppText.translate(context, 'reels'),
// // //               ),
// // //               BottomNavigationBarItem(
// // //                 icon: Icon(Icons.group_outlined, size: 28),
// // //                 activeIcon: Icon(Icons.group, size: 28),
// // //                 label: AppText.translate(context, 'customer'),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

































// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:marquee/marquee.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/views/PosterModule/home.dart';
// import 'package:posternova/views/category/category_screen.dart';
// import 'package:posternova/views/createposter/poster_screen.dart';
// import 'package:posternova/views/customer/customer_screen.dart';
// import 'package:posternova/views/reels/reels_screen.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:upgrader/upgrader.dart';

// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({Key? key}) : super(key: key);

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;
  
//   // Wishes and celebrations data
//   String? currentUserId;
//   String? userId;
//   Map<String, dynamic> birthdayData = {};
//   List<dynamic> customers = [];
//   bool isLoadingCustomers = false;
//   bool isLoadingWishes = false;
  
//   bool _showWishesSection = true;
//   bool _showCustomerCelebrationsSection = true;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const CategoryScreen(),
//     const PosterScreen(),
//     const ReelsScreen(),
//     const CustomerScreen(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     print('🚀 MainNavigationScreen initState called');
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     print('📊 Starting data initialization...');
    
//     // OPTION 1: Reset preferences to show sections (RECOMMENDED FOR TESTING)
//     await _resetSectionPreferences();
    
//     // OPTION 2: Load saved preferences (use this in production)
//     // await _loadSectionPreferences();
    
//     await _loadUserId();
    
//     // Add a small delay to ensure userId is set
//     await Future.delayed(Duration(milliseconds: 300));
    
//     if (userId != null) {
//       print('✅ UserId loaded: $userId');
//       await fetchCustomers();
//     } else {
//       print('❌ UserId is null after loading');
//     }
//   }

//   // OPTION 1: Reset preferences - shows sections every time (for testing)
//   Future<void> _resetSectionPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('show_wishes_section', true);
//     await prefs.setBool('show_customer_celebrations', true);
//     setState(() {
//       _showWishesSection = true;
//       _showCustomerCelebrationsSection = true;
//     });
//     print('🔄 Section preferences RESET - Both sections will show');
//   }

//   // OPTION 2: Load saved preferences (use in production)
//   Future<void> _loadSectionPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _showWishesSection = prefs.getBool('show_wishes_section') ?? true;
//       _showCustomerCelebrationsSection = prefs.getBool('show_customer_celebrations') ?? true;
//     });
//     print('📱 Section preferences loaded - Wishes: $_showWishesSection, Celebrations: $_showCustomerCelebrationsSection');
//   }

//   Future<void> _loadUserId() async {
//     print('🔍 Loading user ID and wishes...');
//     setState(() {
//       isLoadingWishes = true;
//     });
    
//     try {
//       final userData = await AuthPreferences.getUserData();
//       print('👤 User data: ${userData?.user.id}');
      
//       if (userData != null) {
//         setState(() {
//           currentUserId = userData.user.id;
//           userId = userData.user.id;
//         });

//         print('🌐 Fetching wishes for user: $currentUserId');
//         final response = await http.get(
//           Uri.parse(
//             'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
//           ),
//         );

//         print('📡 Wishes API Response: ${response.statusCode}');
//         print('📄 Wishes Response Body: ${response.body}');

//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           print('🎉 Wishes data received: $data');
          
//           setState(() {
//             birthdayData = Map<String, dynamic>.from(data);
//             isLoadingWishes = false;
//           });
          
//           print('✅ Birthday data updated. Wishes count: ${birthdayData['wishes']?.length ?? 0}');
//         } else {
//           print('❌ Failed to load wishes. Status: ${response.statusCode}');
//           setState(() {
//             isLoadingWishes = false;
//           });
//         }
//       } else {
//         print('❌ User data is null');
//         setState(() {
//           isLoadingWishes = false;
//         });
//       }
//     } catch (e) {
//       print('❌ Error loading user ID or birthday data: $e');
//       setState(() {
//         isLoadingWishes = false;
//       });
//     }
//   }

//   Future<void> fetchCustomers() async {
//     print('👥 Fetching customers...');
    
//     if (userId == null) {
//       print('⏳ UserId is null, waiting...');
//       await Future.delayed(Duration(milliseconds: 500));
//       if (userId == null) {
//         print('❌ UserId still null after delay');
//         return;
//       }
//     }

//     setState(() {
//       isLoadingCustomers = true;
//     });

//     try {
//       print('🌐 Calling customers API for userId: $userId');
//       final response = await http.get(
//         Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
//       );

//       print('📡 Customers API Response: ${response.statusCode}');
//       print('📄 Customers Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           customers = data['customers'] ?? [];
//           isLoadingCustomers = false;
//         });
//         print('✅ Customers loaded: ${customers.length}');
        
//         // Debug customer data
//         for (var customer in customers) {
//           print('Customer: ${customer['name']}, DOB: ${customer['dob']}, Anniversary: ${customer['anniversaryDate']}');
//         }
//       } else {
//         print('❌ Failed to load customers. Status: ${response.statusCode}');
//         setState(() {
//           isLoadingCustomers = false;
//         });
//       }
//     } catch (e) {
//       print('❌ Error fetching customers: $e');
//       setState(() {
//         isLoadingCustomers = false;
//       });
//     }
//   }

//   Future<void> _saveWishesSectionPreference(bool show) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('show_wishes_section', show);
//     print('💾 Saved wishes preference: $show');
//   }

//   Future<void> _saveCustomerCelebrationsPreference(bool show) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('show_customer_celebrations', show);
//     print('💾 Saved celebrations preference: $show');
//   }

//   Widget _buildWishesSection() {
//     print('🎂 Building wishes section...');
//     print('Show: $_showWishesSection, Has wishes: ${birthdayData['wishes'] != null}, Wishes: ${birthdayData['wishes']}');
    
//     // Show loading indicator if still loading
//     if (isLoadingWishes) {
//       return Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             ),
//             SizedBox(width: 12),
//             Text('Loading wishes...', style: TextStyle(fontSize: 12)),
//           ],
//         ),
//       );
//     }
    
//     if (!_showWishesSection ||
//         birthdayData['wishes'] == null ||
//         (birthdayData['wishes'] is List && birthdayData['wishes'].isEmpty)) {
//       print('❌ Not showing wishes section');
//       return const SizedBox.shrink();
//     }

//     print('✅ Showing wishes section');
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFE0F7FA), Color.fromARGB(255, 236, 178, 242)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromRGBO(103, 58, 183, 1).withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: const Color(0xFF80DEEA), width: 1),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF00838F),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.celebration, color: Colors.white, size: 18),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: SizedBox(
//               height: 22,
//               child: Marquee(
//                 text: (birthdayData['wishes'] is List) 
//                     ? birthdayData['wishes'].join("  •  ")
//                     : birthdayData['wishes'].toString(),
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF004D40),
//                 ),
//                 scrollAxis: Axis.horizontal,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 blankSpace: 40.0,
//                 velocity: 35.0,
//                 pauseAfterRound: Duration(seconds: 2),
//                 startPadding: 10.0,
//                 accelerationDuration: Duration(seconds: 1),
//                 accelerationCurve: Curves.easeInOut,
//                 decelerationDuration: Duration(milliseconds: 600),
//                 decelerationCurve: Curves.easeOut,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 _showWishesSection = false;
//               });
//               _saveWishesSectionPreference(false);
//             },
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.3),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.close,
//                 color: Color(0xFF00838F),
//                 size: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCustomerCelebrationsSection() {
//     print('🎉 Building celebrations section...');
    
//     // Show loading indicator if still loading
//     if (isLoadingCustomers) {
//       return Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             ),
//             SizedBox(width: 12),
//             Text('Loading celebrations...', style: TextStyle(fontSize: 12)),
//           ],
//         ),
//       );
//     }
    
//     List<String> celebrations = [];

//     if (customers.isNotEmpty) {
//       final today = DateTime.now();
//       print('📅 Today: ${today.year}-${today.month}-${today.day}');

//       for (var customer in customers) {
//         // Birthday check
//         if (customer['dob'] != null && customer['dob'].isNotEmpty) {
//           try {
//             final dob = DateTime.parse(customer['dob']);
//             print('🎂 Checking ${customer['name']}: DOB ${dob.month}-${dob.day} vs Today ${today.month}-${today.day}');
            
//             if (dob.month == today.month && dob.day == today.day) {
//               final age = today.year - dob.year;
//               String suffix;
//               if (age % 10 == 1 && age != 11) {
//                 suffix = 'st';
//               } else if (age % 10 == 2 && age != 12) {
//                 suffix = 'nd';
//               } else if (age % 10 == 3 && age != 13) {
//                 suffix = 'rd';
//               } else {
//                 suffix = 'th';
//               }
//               final celebration = age > 0
//                   ? "🎂 Happy ${age}${suffix} Birthday ${customer['name']}!"
//                   : "🎂 Happy Birthday ${customer['name']}!";
//               celebrations.add(celebration);
//               print('✅ Added birthday: $celebration');
//             }
//           } catch (e) {
//             print('❌ Error parsing DOB for ${customer['name']}: $e');
//           }
//         }

//         // Anniversary check
//         if (customer['anniversaryDate'] != null &&
//             customer['anniversaryDate'].isNotEmpty) {
//           try {
//             final anniversary = DateTime.parse(customer['anniversaryDate']);
//             print('💐 Checking ${customer['name']}: Anniversary ${anniversary.month}-${anniversary.day} vs Today ${today.month}-${today.day}');
            
//             if (anniversary.month == today.month &&
//                 anniversary.day == today.day) {
//               final years = today.year - anniversary.year;
//               String suffix;
//               if (years % 10 == 1 && years != 11) {
//                 suffix = 'st';
//               } else if (years % 10 == 2 && years != 12) {
//                 suffix = 'nd';
//               } else if (years % 10 == 3 && years != 13) {
//                 suffix = 'rd';
//               } else {
//                 suffix = 'th';
//               }
//               final celebration = years > 0
//                   ? "💐 Happy ${years}${suffix} Anniversary ${customer['name']}!"
//                   : "💐 Happy Anniversary ${customer['name']}!";
//               celebrations.add(celebration);
//               print('✅ Added anniversary: $celebration');
//             }
//           } catch (e) {
//             print('❌ Error parsing anniversary for ${customer['name']}: $e');
//           }
//         }
//       }
//     }

//     print('🎊 Total celebrations: ${celebrations.length}');
//     print('Show section: $_showCustomerCelebrationsSection');

//     if (!_showCustomerCelebrationsSection || celebrations.isEmpty) {
//       print('❌ Not showing celebrations section');
//       return const SizedBox.shrink();
//     }

//     print('✅ Showing celebrations section');
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFFFF6F00).withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         border: Border.all(color: const Color(0xFFFFB74D), width: 1),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: const Color(0xFFE65100),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.cake, color: Colors.white, size: 18),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: SizedBox(
//               height: 22,
//               child: Marquee(
//                 text: celebrations.join("  •  "),
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFFBF360C),
//                 ),
//                 scrollAxis: Axis.horizontal,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 blankSpace: 40.0,
//                 velocity: 35.0,
//                 pauseAfterRound: const Duration(seconds: 2),
//                 startPadding: 10.0,
//                 accelerationDuration: const Duration(seconds: 1),
//                 accelerationCurve: Curves.easeInOut,
//                 decelerationDuration: const Duration(milliseconds: 600),
//                 decelerationCurve: Curves.easeOut,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 _showCustomerCelebrationsSection = false;
//               });
//               _saveCustomerCelebrationsPreference(false);
//             },
//             child: Container(
//               padding: const EdgeInsets.all(4),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.3),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.close,
//                 color: Color(0xFFE65100),
//                 size: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return UpgradeAlert(
//       upgrader: Upgrader(durationUntilAlertAgain: const Duration(days: 1)),
//       dialogStyle: UpgradeDialogStyle.material,
//       showLater: true,
//       showIgnore: false,
//       child: Scaffold(
//         body: _screens[_currentIndex],
//         bottomNavigationBar: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Wishes and Celebrations sections
//             _buildWishesSection(),
//             _buildCustomerCelebrationsSection(),
            
//             // Bottom Navigation Bar
//             Container(
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.purple.withOpacity(0.3),
//                     blurRadius: 20,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: BottomNavigationBar(
//                 currentIndex: _currentIndex,
//                 onTap: (index) {
//                   setState(() {
//                     _currentIndex = index;
//                   });
//                 },
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 type: BottomNavigationBarType.fixed,
//                 selectedItemColor: Colors.purple.shade300,
//                 unselectedItemColor: Colors.grey.shade600,
//                 selectedLabelStyle: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 12,
//                 ),
//                 unselectedLabelStyle: const TextStyle(fontSize: 12),
//                 items: [
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.home_outlined, size: 28),
//                     activeIcon: Icon(Icons.home, size: 28),
//                     label: AppText.translate(context, 'home'),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.grid_view_rounded, size: 28),
//                     activeIcon: Icon(Icons.grid_view, size: 28),
//                     label: AppText.translate(context, 'category'),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.edit_outlined, size: 28),
//                     activeIcon: Icon(Icons.edit, size: 28),
//                     label: AppText.translate(context, 'poster'),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.video_library, size: 28),
//                     activeIcon: Icon(Icons.video_library, size: 28),
//                     label: AppText.translate(context, 'reels'),
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(Icons.group_outlined, size: 28),
//                     activeIcon: Icon(Icons.group, size: 28),
//                     label: AppText.translate(context, 'customer'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

















import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/views/PosterModule/home.dart';
import 'package:posternova/views/category/category_screen.dart';
import 'package:posternova/views/createposter/poster_screen.dart';
import 'package:posternova/views/customer/customer_screen.dart';
import 'package:posternova/views/reels/reels_screen.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  String? currentUserId;
  String? userId;
  Map<String, dynamic> birthdayData = {};
  List<dynamic> customers = [];
  bool isLoadingCustomers = false;
  bool isLoadingWishes = false;

  bool _showWishesSection = true;
  bool _showCustomerCelebrationsSection = true;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const PosterScreen(),
    const ReelsScreen(),
    const CustomerScreen(),
  ];

  @override
  void initState() {
    super.initState();
    print('🚀 MainNavigationScreen initState called');
    _initializeData();
  }

  Future<void> _initializeData() async {
    print('📊 Starting data initialization...');
    await _resetSectionPreferences();
    await _loadUserId();
    await Future.delayed(Duration(milliseconds: 300));
    if (userId != null) {
      print('✅ UserId loaded: $userId');
      await fetchCustomers();
    } else {
      print('❌ UserId is null after loading');
    }
  }

  Future<void> _resetSectionPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_wishes_section', true);
    await prefs.setBool('show_customer_celebrations', true);
    setState(() {
      _showWishesSection = true;
      _showCustomerCelebrationsSection = true;
    });
    print('🔄 Section preferences RESET - Both sections will show');
  }

  Future<void> _loadSectionPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showWishesSection = prefs.getBool('show_wishes_section') ?? true;
      _showCustomerCelebrationsSection =
          prefs.getBool('show_customer_celebrations') ?? true;
    });
  }

  Future<void> _loadUserId() async {
    print('🔍 Loading user ID and wishes...');
    setState(() {
      isLoadingWishes = true;
    });

    try {
      final userData = await AuthPreferences.getUserData();
      print('👤 User data: ${userData?.user.id}');

      if (userData != null) {
        setState(() {
          currentUserId = userData.user.id;
          userId = userData.user.id;
        });

        print('🌐 Fetching wishes for user: $currentUserId');
        final response = await http.get(
          Uri.parse(
            'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
          ),
        );

        print('📡 Wishes API Response: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('🎉 Wishes data received: $data');

          setState(() {
            birthdayData = Map<String, dynamic>.from(data);
            isLoadingWishes = false;
          });

          print(
            '✅ Birthday data updated. Wishes count: ${birthdayData['wishes']?.length ?? 0}',
          );
        } else {
          print('❌ Failed to load wishes. Status: ${response.statusCode}');
          setState(() {
            isLoadingWishes = false;
          });
        }
      } else {
        print('❌ User data is null');
        setState(() {
          isLoadingWishes = false;
        });
      }
    } catch (e) {
      print('❌ Error loading user ID or birthday data: $e');
      setState(() {
        isLoadingWishes = false;
      });
    }
  }

  Future<void> fetchCustomers() async {
    print('👥 Fetching customers...');

    if (userId == null) {
      print('⏳ UserId is null, waiting...');
      await Future.delayed(Duration(milliseconds: 500));
      if (userId == null) {
        print('❌ UserId still null after delay');
        return;
      }
    }

    setState(() {
      isLoadingCustomers = true;
    });

    try {
      print('🌐 Calling customers API for userId: $userId');
      final response = await http.get(
        Uri.parse(
          'http://31.97.206.144:4061/api/users/allcustomers/$userId',
        ),
      );

      print('📡 Customers API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          customers = data['customers'] ?? [];
          isLoadingCustomers = false;
        });
        print('✅ Customers loaded: ${customers.length}');
      } else {
        print('❌ Failed to load customers. Status: ${response.statusCode}');
        setState(() {
          isLoadingCustomers = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching customers: $e');
      setState(() {
        isLoadingCustomers = false;
      });
    }
  }

  Future<void> _saveWishesSectionPreference(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_wishes_section', show);
    print('💾 Saved wishes preference: $show');
  }

  Future<void> _saveCustomerCelebrationsPreference(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_customer_celebrations', show);
    print('💾 Saved celebrations preference: $show');
  }

  Widget _buildWishesSection(String langCode) {
    if (isLoadingWishes) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text(
              LocalizationService.translate('loading_wishes', langCode),
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    if (!_showWishesSection ||
        birthdayData['wishes'] == null ||
        (birthdayData['wishes'] is List && birthdayData['wishes'].isEmpty)) {
      print('❌ Not showing wishes section');
      return const SizedBox.shrink();
    }

    print('✅ Showing wishes section');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F7FA), Color.fromARGB(255, 236, 178, 242)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(103, 58, 183, 1).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFF80DEEA), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00838F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.celebration,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 22,
              child: Marquee(
                text: (birthdayData['wishes'] is List)
                    ? birthdayData['wishes'].join("  •  ")
                    : birthdayData['wishes'].toString(),
                style: const TextStyle(
                  fontSize: 13,
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
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCelebrationsSection(String langCode) {
    if (isLoadingCustomers) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text(
              LocalizationService.translate('loading_celebrations', langCode),
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }

    List<String> celebrations = [];

    if (customers.isNotEmpty) {
      final today = DateTime.now();
      final happyBirthday =
          LocalizationService.translate('happy_birthday', langCode);
      final happyAnniversary =
          LocalizationService.translate('happy_anniversary', langCode);

      for (var customer in customers) {
        if (customer['dob'] != null && customer['dob'].isNotEmpty) {
          try {
            final dob = DateTime.parse(customer['dob']);
            if (dob.month == today.month && dob.day == today.day) {
              final age = today.year - dob.year;
              String suffix;
              if (age % 10 == 1 && age != 11) {
                suffix = 'st';
              } else if (age % 10 == 2 && age != 12) {
                suffix = 'nd';
              } else if (age % 10 == 3 && age != 13) {
                suffix = 'rd';
              } else {
                suffix = 'th';
              }
              celebrations.add(
                age > 0
                    ? "🎂 $happyBirthday ${customer['name']}! ($age$suffix)"
                    : "🎂 $happyBirthday ${customer['name']}!",
              );
            }
          } catch (e) {
            print('❌ Error parsing DOB: $e');
          }
        }

        if (customer['anniversaryDate'] != null &&
            customer['anniversaryDate'].isNotEmpty) {
          try {
            final anniversary = DateTime.parse(customer['anniversaryDate']);
            if (anniversary.month == today.month &&
                anniversary.day == today.day) {
              final years = today.year - anniversary.year;
              String suffix;
              if (years % 10 == 1 && years != 11) {
                suffix = 'st';
              } else if (years % 10 == 2 && years != 12) {
                suffix = 'nd';
              } else if (years % 10 == 3 && years != 13) {
                suffix = 'rd';
              } else {
                suffix = 'th';
              }
              celebrations.add(
                years > 0
                    ? "💐 $happyAnniversary ${customer['name']}! ($years$suffix)"
                    : "💐 $happyAnniversary ${customer['name']}!",
              );
            }
          } catch (e) {
            print('❌ Error parsing anniversary: $e');
          }
        }
      }
    }

    if (!_showCustomerCelebrationsSection || celebrations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6F00).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFFFB74D), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE65100),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.cake, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 22,
              child: Marquee(
                text: celebrations.join("  •  "),
                style: const TextStyle(
                  fontSize: 13,
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
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(durationUntilAlertAgain: const Duration(days: 1)),
      dialogStyle: UpgradeDialogStyle.material,
      showLater: true,
      showIgnore: false,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            final langCode = languageProvider.locale.languageCode;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWishesSection(langCode),
                _buildCustomerCelebrationsSection(langCode),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: Colors.purple.shade300,
                    unselectedItemColor: Colors.grey.shade600,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: const TextStyle(fontSize: 12),
                    items: [
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.home_outlined, size: 28),
                        activeIcon: const Icon(Icons.home, size: 28),
                        label: LocalizationService.translate('home', langCode),
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.grid_view_rounded, size: 28),
                        activeIcon: const Icon(Icons.grid_view, size: 28),
                        label: LocalizationService.translate(
                          'category',
                          langCode,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.edit_outlined, size: 28),
                        activeIcon: const Icon(Icons.edit, size: 28),
                        label: LocalizationService.translate(
                          'poster',
                          langCode,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.video_library, size: 28),
                        activeIcon: const Icon(Icons.video_library, size: 28),
                        label: LocalizationService.translate(
                          'reels',
                          langCode,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.group_outlined, size: 28),
                        activeIcon: const Icon(Icons.group, size: 28),
                        label: LocalizationService.translate(
                          'customer',
                          langCode,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}