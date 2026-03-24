// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:posternova/views/PosterModule/home.dart';
// // // // // import 'package:posternova/views/category/category_screen.dart';
// // // // // import 'package:posternova/views/createposter/poster_screen.dart';
// // // // // import 'package:posternova/views/customer/customer_screen.dart';
// // // // // import 'package:posternova/views/horrorscope/horror_scope.dart';

// // // // // class MainNavigationScreen extends StatefulWidget {
// // // // //   const MainNavigationScreen({Key? key}) : super(key: key);

// // // // //   @override
// // // // //   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// // // // // }

// // // // // class _MainNavigationScreenState extends State<MainNavigationScreen> {
// // // // //   int _currentIndex = 0;

// // // // //   final List<Widget> _screens = [
// // // // //     const HomeScreen(),
// // // // //     const CategoryScreen(),
// // // // //     const PosterScreen(),
// // // // //     const HoroscopeScreen(),
// // // // //     // const ProfileScreen(),
// // // // //     const CustomerScreen(),
// // // // //   ];

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       body: _screens[_currentIndex],
// // // // //       bottomNavigationBar: Container(
// // // // //         decoration: BoxDecoration(
// // // // //           gradient: const LinearGradient(
// // // // //             colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
// // // // //           ),
// // // // //           boxShadow: [
// // // // //             BoxShadow(
// // // // //               color: Colors.purple.withOpacity(0.3),
// // // // //               blurRadius: 20,
// // // // //               offset: const Offset(0, -5),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //         child: BottomNavigationBar(
// // // // //           currentIndex: _currentIndex,
// // // // //           onTap: (index) {
// // // // //             setState(() {
// // // // //               _currentIndex = index;
// // // // //             });
// // // // //           },
// // // // //           backgroundColor: Colors.transparent,
// // // // //           elevation: 0,
// // // // //           type: BottomNavigationBarType.fixed,
// // // // //           selectedItemColor: Colors.purple.shade300,
// // // // //           unselectedItemColor: Colors.grey.shade600,
// // // // //           selectedLabelStyle: const TextStyle(
// // // // //             fontWeight: FontWeight.w600,
// // // // //             fontSize: 12,
// // // // //           ),
// // // // //           unselectedLabelStyle: const TextStyle(fontSize: 12),
// // // // //           items: const [
// // // // //             BottomNavigationBarItem(
// // // // //               icon: Icon(Icons.home_outlined, size: 28),
// // // // //               activeIcon: Icon(Icons.home, size: 28),
// // // // //               label: 'Home',
// // // // //             ),

// // // // //             BottomNavigationBarItem(
// // // // //               icon: Icon(Icons.grid_view_rounded, size: 28),
// // // // //               activeIcon: Icon(Icons.grid_view, size: 28),
// // // // //               label: 'Category',
// // // // //             ),
// // // // //             BottomNavigationBarItem(
// // // // //               icon: Icon(Icons.edit_outlined, size: 28),
// // // // //               activeIcon: Icon(Icons.edit, size: 28),
// // // // //               label: 'Poster',
// // // // //             ),
// // // // //             BottomNavigationBarItem(
// // // // //               icon: Icon(Icons.auto_awesome, size: 28),
// // // // //               activeIcon: Icon(Icons.auto_awesome, size: 28),
// // // // //               label: 'HorrorScope',
// // // // //             ),

// // // // //             BottomNavigationBarItem(
// // // // //               icon: Icon(Icons.group_outlined, size: 28),
// // // // //               activeIcon: Icon(Icons.group, size: 28),
// // // // //               label: 'Customer',
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:posternova/views/PosterModule/home.dart';
// // // // import 'package:posternova/views/category/category_screen.dart';
// // // // import 'package:posternova/views/createposter/poster_screen.dart';
// // // // import 'package:posternova/views/customer/customer_screen.dart';
// // // // import 'package:posternova/views/reels/reels_screen.dart';
// // // // import 'package:posternova/widgets/language_widget.dart';
// // // // import 'package:upgrader/upgrader.dart';

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
// // // //     const ReelsScreen(),
// // // //     // const OnlinePunchangScreen(),

// // // //     // const HoroscopeScreen(),
// // // //     // const ProfileScreen(),
// // // //     const CustomerScreen(),
// // // //   ];

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return UpgradeAlert(
// // // //       // Customize the upgrade alert dialog
// // // //       upgrader: Upgrader(durationUntilAlertAgain: const Duration(days: 1)),
// // // //       dialogStyle:
// // // //           UpgradeDialogStyle.material, // or UpgradeDialogStyle.cupertino
// // // //       showLater: true, // Show "Later" button
// // // //       showIgnore: false, // Hide "Ignore" button
// // // //       child: Scaffold(
// // // //         body: _screens[_currentIndex],
// // // //         bottomNavigationBar: Container(
// // // //           decoration: BoxDecoration(
// // // //             gradient: const LinearGradient(
// // // //               colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
// // // //             ),
// // // //             boxShadow: [
// // // //               BoxShadow(
// // // //                 color: Colors.purple.withOpacity(0.3),
// // // //                 blurRadius: 20,
// // // //                 offset: const Offset(0, -5),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           child: BottomNavigationBar(
// // // //             currentIndex: _currentIndex,
// // // //             onTap: (index) {
// // // //               setState(() {
// // // //                 _currentIndex = index;
// // // //               });
// // // //             },
// // // //             backgroundColor: Colors.transparent,
// // // //             elevation: 0,
// // // //             type: BottomNavigationBarType.fixed,
// // // //             selectedItemColor: Colors.purple.shade300,
// // // //             unselectedItemColor: Colors.grey.shade600,
// // // //             selectedLabelStyle: const TextStyle(
// // // //               fontWeight: FontWeight.w600,
// // // //               fontSize: 12,
// // // //             ),
// // // //             unselectedLabelStyle: const TextStyle(fontSize: 12),

// // // //             // items: const [
// // // //             //   BottomNavigationBarItem(
// // // //             //     icon: Icon(Icons.home_outlined, size: 28),
// // // //             //     activeIcon: Icon(Icons.home, size: 28),
// // // //             //     label: 'Home',
// // // //             //   ),
// // // //             //   BottomNavigationBarItem(
// // // //             //     icon: Icon(Icons.grid_view_rounded, size: 28),
// // // //             //     activeIcon: Icon(Icons.grid_view, size: 28),
// // // //             //     label: 'Category',
// // // //             //   ),
// // // //             //   BottomNavigationBarItem(
// // // //             //     icon: Icon(Icons.edit_outlined, size: 28),
// // // //             //     activeIcon: Icon(Icons.edit, size: 28),
// // // //             //     label: 'Poster',
// // // //             //   ),
// // // //             //   // BottomNavigationBarItem(
// // // //             //   //   icon: Icon(Icons.calendar_month, size: 28),
// // // //             //   //   activeIcon: Icon(Icons.calendar_month, size: 28),
// // // //             //   //   label: 'Punchang',
// // // //             //   // ),
// // // //             //   BottomNavigationBarItem(
// // // //             //     icon: Icon(Icons.video_library, size: 28),
// // // //             //     activeIcon: Icon(Icons.video_library, size: 28),
// // // //             //     label: 'Reels',
// // // //             //   ),
// // // //             //   //     BottomNavigationBarItem(
// // // //             //   //   icon: Icon(Icons.calendar_month, size: 28),
// // // //             //   //   activeIcon: Icon(Icons.calendar_month, size: 28),
// // // //             //   //   label: 'Punchang',
// // // //             //   // ),
// // // //             //   BottomNavigationBarItem(
// // // //             //     icon: Icon(Icons.group_outlined, size: 28),
// // // //             //     activeIcon: Icon(Icons.group, size: 28),
// // // //             //     label: 'Customer',
// // // //             //   ),
// // // //             // ],
// // // //             items: [
// // // //               BottomNavigationBarItem(
// // // //                 icon: Icon(Icons.home_outlined, size: 28),
// // // //                 activeIcon: Icon(Icons.home, size: 28),
// // // //                 label: AppText.translate(context, 'home'),
// // // //               ),
// // // //               BottomNavigationBarItem(
// // // //                 icon: Icon(Icons.grid_view_rounded, size: 28),
// // // //                 activeIcon: Icon(Icons.grid_view, size: 28),
// // // //                 label: AppText.translate(context, 'category'),
// // // //               ),
// // // //               BottomNavigationBarItem(
// // // //                 icon: Icon(Icons.edit_outlined, size: 28),
// // // //                 activeIcon: Icon(Icons.edit, size: 28),
// // // //                 label: AppText.translate(context, 'poster'),
// // // //               ),
// // // //               BottomNavigationBarItem(
// // // //                 icon: Icon(Icons.video_library, size: 28),
// // // //                 activeIcon: Icon(Icons.video_library, size: 28),
// // // //                 label: AppText.translate(context, 'reels'),
// // // //               ),
// // // //               BottomNavigationBarItem(
// // // //                 icon: Icon(Icons.group_outlined, size: 28),
// // // //                 activeIcon: Icon(Icons.group, size: 28),
// // // //                 label: AppText.translate(context, 'customer'),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:marquee/marquee.dart';
// // import 'package:posternova/helper/storage_helper.dart';
// // import 'package:posternova/views/PosterModule/home.dart';
// // import 'package:posternova/views/category/category_screen.dart';
// // import 'package:posternova/views/createposter/poster_screen.dart';
// // import 'package:posternova/views/customer/customer_screen.dart';
// // import 'package:posternova/views/reels/reels_screen.dart';
// // import 'package:posternova/widgets/language_widget.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:upgrader/upgrader.dart';

// // class MainNavigationScreen extends StatefulWidget {
// //   const MainNavigationScreen({Key? key}) : super(key: key);

// //   @override
// //   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// // }

// // class _MainNavigationScreenState extends State<MainNavigationScreen> {
// //   int _currentIndex = 0;

// //   // Wishes and celebrations data
// //   String? currentUserId;
// //   String? userId;
// //   Map<String, dynamic> birthdayData = {};
// //   List<dynamic> customers = [];
// //   bool isLoadingCustomers = false;
// //   bool isLoadingWishes = false;

// //   bool _showWishesSection = true;
// //   bool _showCustomerCelebrationsSection = true;

// //   final List<Widget> _screens = [
// //     const HomeScreen(),
// //     const CategoryScreen(),
// //     const PosterScreen(),
// //     const ReelsScreen(),
// //     const CustomerScreen(),
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     print('🚀 MainNavigationScreen initState called');
// //     _initializeData();
// //   }

// //   Future<void> _initializeData() async {
// //     print('📊 Starting data initialization...');

// //     // OPTION 1: Reset preferences to show sections (RECOMMENDED FOR TESTING)
// //     await _resetSectionPreferences();

// //     // OPTION 2: Load saved preferences (use this in production)
// //     // await _loadSectionPreferences();

// //     await _loadUserId();

// //     // Add a small delay to ensure userId is set
// //     await Future.delayed(Duration(milliseconds: 300));

// //     if (userId != null) {
// //       print('✅ UserId loaded: $userId');
// //       await fetchCustomers();
// //     } else {
// //       print('❌ UserId is null after loading');
// //     }
// //   }

// //   // OPTION 1: Reset preferences - shows sections every time (for testing)
// //   Future<void> _resetSectionPreferences() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('show_wishes_section', true);
// //     await prefs.setBool('show_customer_celebrations', true);
// //     setState(() {
// //       _showWishesSection = true;
// //       _showCustomerCelebrationsSection = true;
// //     });
// //     print('🔄 Section preferences RESET - Both sections will show');
// //   }

// //   // OPTION 2: Load saved preferences (use in production)
// //   Future<void> _loadSectionPreferences() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _showWishesSection = prefs.getBool('show_wishes_section') ?? true;
// //       _showCustomerCelebrationsSection = prefs.getBool('show_customer_celebrations') ?? true;
// //     });
// //     print('📱 Section preferences loaded - Wishes: $_showWishesSection, Celebrations: $_showCustomerCelebrationsSection');
// //   }

// //   Future<void> _loadUserId() async {
// //     print('🔍 Loading user ID and wishes...');
// //     setState(() {
// //       isLoadingWishes = true;
// //     });

// //     try {
// //       final userData = await AuthPreferences.getUserData();
// //       print('👤 User data: ${userData?.user.id}');

// //       if (userData != null) {
// //         setState(() {
// //           currentUserId = userData.user.id;
// //           userId = userData.user.id;
// //         });

// //         print('🌐 Fetching wishes for user: $currentUserId');
// //         final response = await http.get(
// //           Uri.parse(
// //             'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
// //           ),
// //         );

// //         print('📡 Wishes API Response: ${response.statusCode}');
// //         print('📄 Wishes Response Body: ${response.body}');

// //         if (response.statusCode == 200) {
// //           final data = jsonDecode(response.body);
// //           print('🎉 Wishes data received: $data');

// //           setState(() {
// //             birthdayData = Map<String, dynamic>.from(data);
// //             isLoadingWishes = false;
// //           });

// //           print('✅ Birthday data updated. Wishes count: ${birthdayData['wishes']?.length ?? 0}');
// //         } else {
// //           print('❌ Failed to load wishes. Status: ${response.statusCode}');
// //           setState(() {
// //             isLoadingWishes = false;
// //           });
// //         }
// //       } else {
// //         print('❌ User data is null');
// //         setState(() {
// //           isLoadingWishes = false;
// //         });
// //       }
// //     } catch (e) {
// //       print('❌ Error loading user ID or birthday data: $e');
// //       setState(() {
// //         isLoadingWishes = false;
// //       });
// //     }
// //   }

// //   Future<void> fetchCustomers() async {
// //     print('👥 Fetching customers...');

// //     if (userId == null) {
// //       print('⏳ UserId is null, waiting...');
// //       await Future.delayed(Duration(milliseconds: 500));
// //       if (userId == null) {
// //         print('❌ UserId still null after delay');
// //         return;
// //       }
// //     }

// //     setState(() {
// //       isLoadingCustomers = true;
// //     });

// //     try {
// //       print('🌐 Calling customers API for userId: $userId');
// //       final response = await http.get(
// //         Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
// //       );

// //       print('📡 Customers API Response: ${response.statusCode}');
// //       print('📄 Customers Response Body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         setState(() {
// //           customers = data['customers'] ?? [];
// //           isLoadingCustomers = false;
// //         });
// //         print('✅ Customers loaded: ${customers.length}');

// //         // Debug customer data
// //         for (var customer in customers) {
// //           print('Customer: ${customer['name']}, DOB: ${customer['dob']}, Anniversary: ${customer['anniversaryDate']}');
// //         }
// //       } else {
// //         print('❌ Failed to load customers. Status: ${response.statusCode}');
// //         setState(() {
// //           isLoadingCustomers = false;
// //         });
// //       }
// //     } catch (e) {
// //       print('❌ Error fetching customers: $e');
// //       setState(() {
// //         isLoadingCustomers = false;
// //       });
// //     }
// //   }

// //   Future<void> _saveWishesSectionPreference(bool show) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('show_wishes_section', show);
// //     print('💾 Saved wishes preference: $show');
// //   }

// //   Future<void> _saveCustomerCelebrationsPreference(bool show) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('show_customer_celebrations', show);
// //     print('💾 Saved celebrations preference: $show');
// //   }

// //   Widget _buildWishesSection() {
// //     print('🎂 Building wishes section...');
// //     print('Show: $_showWishesSection, Has wishes: ${birthdayData['wishes'] != null}, Wishes: ${birthdayData['wishes']}');

// //     // Show loading indicator if still loading
// //     if (isLoadingWishes) {
// //       return Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: Colors.grey[200],
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             SizedBox(
// //               width: 16,
// //               height: 16,
// //               child: CircularProgressIndicator(strokeWidth: 2),
// //             ),
// //             SizedBox(width: 12),
// //             Text('Loading wishes...', style: TextStyle(fontSize: 12)),
// //           ],
// //         ),
// //       );
// //     }

// //     if (!_showWishesSection ||
// //         birthdayData['wishes'] == null ||
// //         (birthdayData['wishes'] is List && birthdayData['wishes'].isEmpty)) {
// //       print('❌ Not showing wishes section');
// //       return const SizedBox.shrink();
// //     }

// //     print('✅ Showing wishes section');
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFFE0F7FA), Color.fromARGB(255, 236, 178, 242)],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: const Color.fromRGBO(103, 58, 183, 1).withOpacity(0.3),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //         border: Border.all(color: const Color(0xFF80DEEA), width: 1),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF00838F),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: const Icon(Icons.celebration, color: Colors.white, size: 18),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: SizedBox(
// //               height: 22,
// //               child: Marquee(
// //                 text: (birthdayData['wishes'] is List)
// //                     ? birthdayData['wishes'].join("  •  ")
// //                     : birthdayData['wishes'].toString(),
// //                 style: const TextStyle(
// //                   fontSize: 13,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFF004D40),
// //                 ),
// //                 scrollAxis: Axis.horizontal,
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 blankSpace: 40.0,
// //                 velocity: 35.0,
// //                 pauseAfterRound: Duration(seconds: 2),
// //                 startPadding: 10.0,
// //                 accelerationDuration: Duration(seconds: 1),
// //                 accelerationCurve: Curves.easeInOut,
// //                 decelerationDuration: Duration(milliseconds: 600),
// //                 decelerationCurve: Curves.easeOut,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           GestureDetector(
// //             onTap: () {
// //               setState(() {
// //                 _showWishesSection = false;
// //               });
// //               _saveWishesSectionPreference(false);
// //             },
// //             child: Container(
// //               padding: const EdgeInsets.all(4),
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.3),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(
// //                 Icons.close,
// //                 color: Color(0xFF00838F),
// //                 size: 16,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildCustomerCelebrationsSection() {
// //     print('🎉 Building celebrations section...');

// //     // Show loading indicator if still loading
// //     if (isLoadingCustomers) {
// //       return Container(
// //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //         padding: const EdgeInsets.all(12),
// //         decoration: BoxDecoration(
// //           color: Colors.grey[200],
// //           borderRadius: BorderRadius.circular(16),
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             SizedBox(
// //               width: 16,
// //               height: 16,
// //               child: CircularProgressIndicator(strokeWidth: 2),
// //             ),
// //             SizedBox(width: 12),
// //             Text('Loading celebrations...', style: TextStyle(fontSize: 12)),
// //           ],
// //         ),
// //       );
// //     }

// //     List<String> celebrations = [];

// //     if (customers.isNotEmpty) {
// //       final today = DateTime.now();
// //       print('📅 Today: ${today.year}-${today.month}-${today.day}');

// //       for (var customer in customers) {
// //         // Birthday check
// //         if (customer['dob'] != null && customer['dob'].isNotEmpty) {
// //           try {
// //             final dob = DateTime.parse(customer['dob']);
// //             print('🎂 Checking ${customer['name']}: DOB ${dob.month}-${dob.day} vs Today ${today.month}-${today.day}');

// //             if (dob.month == today.month && dob.day == today.day) {
// //               final age = today.year - dob.year;
// //               String suffix;
// //               if (age % 10 == 1 && age != 11) {
// //                 suffix = 'st';
// //               } else if (age % 10 == 2 && age != 12) {
// //                 suffix = 'nd';
// //               } else if (age % 10 == 3 && age != 13) {
// //                 suffix = 'rd';
// //               } else {
// //                 suffix = 'th';
// //               }
// //               final celebration = age > 0
// //                   ? "🎂 Happy ${age}${suffix} Birthday ${customer['name']}!"
// //                   : "🎂 Happy Birthday ${customer['name']}!";
// //               celebrations.add(celebration);
// //               print('✅ Added birthday: $celebration');
// //             }
// //           } catch (e) {
// //             print('❌ Error parsing DOB for ${customer['name']}: $e');
// //           }
// //         }

// //         // Anniversary check
// //         if (customer['anniversaryDate'] != null &&
// //             customer['anniversaryDate'].isNotEmpty) {
// //           try {
// //             final anniversary = DateTime.parse(customer['anniversaryDate']);
// //             print('💐 Checking ${customer['name']}: Anniversary ${anniversary.month}-${anniversary.day} vs Today ${today.month}-${today.day}');

// //             if (anniversary.month == today.month &&
// //                 anniversary.day == today.day) {
// //               final years = today.year - anniversary.year;
// //               String suffix;
// //               if (years % 10 == 1 && years != 11) {
// //                 suffix = 'st';
// //               } else if (years % 10 == 2 && years != 12) {
// //                 suffix = 'nd';
// //               } else if (years % 10 == 3 && years != 13) {
// //                 suffix = 'rd';
// //               } else {
// //                 suffix = 'th';
// //               }
// //               final celebration = years > 0
// //                   ? "💐 Happy ${years}${suffix} Anniversary ${customer['name']}!"
// //                   : "💐 Happy Anniversary ${customer['name']}!";
// //               celebrations.add(celebration);
// //               print('✅ Added anniversary: $celebration');
// //             }
// //           } catch (e) {
// //             print('❌ Error parsing anniversary for ${customer['name']}: $e');
// //           }
// //         }
// //       }
// //     }

// //     print('🎊 Total celebrations: ${celebrations.length}');
// //     print('Show section: $_showCustomerCelebrationsSection');

// //     if (!_showCustomerCelebrationsSection || celebrations.isEmpty) {
// //       print('❌ Not showing celebrations section');
// //       return const SizedBox.shrink();
// //     }

// //     print('✅ Showing celebrations section');
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: const Color(0xFFFF6F00).withOpacity(0.3),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //         border: Border.all(color: const Color(0xFFFFB74D), width: 1),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFFE65100),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: const Icon(Icons.cake, color: Colors.white, size: 18),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: SizedBox(
// //               height: 22,
// //               child: Marquee(
// //                 text: celebrations.join("  •  "),
// //                 style: const TextStyle(
// //                   fontSize: 13,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFFBF360C),
// //                 ),
// //                 scrollAxis: Axis.horizontal,
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 blankSpace: 40.0,
// //                 velocity: 35.0,
// //                 pauseAfterRound: const Duration(seconds: 2),
// //                 startPadding: 10.0,
// //                 accelerationDuration: const Duration(seconds: 1),
// //                 accelerationCurve: Curves.easeInOut,
// //                 decelerationDuration: const Duration(milliseconds: 600),
// //                 decelerationCurve: Curves.easeOut,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           GestureDetector(
// //             onTap: () {
// //               setState(() {
// //                 _showCustomerCelebrationsSection = false;
// //               });
// //               _saveCustomerCelebrationsPreference(false);
// //             },
// //             child: Container(
// //               padding: const EdgeInsets.all(4),
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.3),
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(
// //                 Icons.close,
// //                 color: Color(0xFFE65100),
// //                 size: 16,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return UpgradeAlert(
// //       upgrader: Upgrader(durationUntilAlertAgain: const Duration(days: 1)),
// //       dialogStyle: UpgradeDialogStyle.material,
// //       showLater: true,
// //       showIgnore: false,
// //       child: Scaffold(
// //         body: _screens[_currentIndex],
// //         bottomNavigationBar: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             // Wishes and Celebrations sections
// //             _buildWishesSection(),
// //             _buildCustomerCelebrationsSection(),

// //             // Bottom Navigation Bar
// //             Container(
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(
// //                   colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
// //                 ),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.purple.withOpacity(0.3),
// //                     blurRadius: 20,
// //                     offset: const Offset(0, -5),
// //                   ),
// //                 ],
// //               ),
// //               child: BottomNavigationBar(
// //                 currentIndex: _currentIndex,
// //                 onTap: (index) {
// //                   setState(() {
// //                     _currentIndex = index;
// //                   });
// //                 },
// //                 backgroundColor: Colors.transparent,
// //                 elevation: 0,
// //                 type: BottomNavigationBarType.fixed,
// //                 selectedItemColor: Colors.purple.shade300,
// //                 unselectedItemColor: Colors.grey.shade600,
// //                 selectedLabelStyle: const TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 12,
// //                 ),
// //                 unselectedLabelStyle: const TextStyle(fontSize: 12),
// //                 items: [
// //                   BottomNavigationBarItem(
// //                     icon: Icon(Icons.home_outlined, size: 28),
// //                     activeIcon: Icon(Icons.home, size: 28),
// //                     label: AppText.translate(context, 'home'),
// //                   ),
// //                   BottomNavigationBarItem(
// //                     icon: Icon(Icons.grid_view_rounded, size: 28),
// //                     activeIcon: Icon(Icons.grid_view, size: 28),
// //                     label: AppText.translate(context, 'category'),
// //                   ),
// //                   BottomNavigationBarItem(
// //                     icon: Icon(Icons.edit_outlined, size: 28),
// //                     activeIcon: Icon(Icons.edit, size: 28),
// //                     label: AppText.translate(context, 'poster'),
// //                   ),
// //                   BottomNavigationBarItem(
// //                     icon: Icon(Icons.video_library, size: 28),
// //                     activeIcon: Icon(Icons.video_library, size: 28),
// //                     label: AppText.translate(context, 'reels'),
// //                   ),
// //                   BottomNavigationBarItem(
// //                     icon: Icon(Icons.group_outlined, size: 28),
// //                     activeIcon: Icon(Icons.group, size: 28),
// //                     label: AppText.translate(context, 'customer'),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

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
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:upgrader/upgrader.dart';

// class MainNavigationScreen extends StatefulWidget {
//   const MainNavigationScreen({Key? key}) : super(key: key);

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;

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
//     await _resetSectionPreferences();
//     await _loadUserId();
//     await Future.delayed(Duration(milliseconds: 300));
//     if (userId != null) {
//       print('✅ UserId loaded: $userId');
//       await fetchCustomers();
//     } else {
//       print('❌ UserId is null after loading');
//     }
//   }

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

//   Future<void> _loadSectionPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _showWishesSection = prefs.getBool('show_wishes_section') ?? true;
//       _showCustomerCelebrationsSection =
//           prefs.getBool('show_customer_celebrations') ?? true;
//     });
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

//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           print('🎉 Wishes data received: $data');

//           setState(() {
//             birthdayData = Map<String, dynamic>.from(data);
//             isLoadingWishes = false;
//           });

//           print(
//             '✅ Birthday data updated. Wishes count: ${birthdayData['wishes']?.length ?? 0}',
//           );
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
//         Uri.parse(
//           'http://31.97.206.144:4061/api/users/allcustomers/$userId',
//         ),
//       );

//       print('📡 Customers API Response: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           customers = data['customers'] ?? [];
//           isLoadingCustomers = false;
//         });
//         print('✅ Customers loaded: ${customers.length}');
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

//   Widget _buildWishesSection(String langCode) {
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
//             Text(
//               LocalizationService.translate('loading_wishes', langCode),
//               style: TextStyle(fontSize: 12),
//             ),
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
//             child: const Icon(
//               Icons.celebration,
//               color: Colors.white,
//               size: 18,
//             ),
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

//   Widget _buildCustomerCelebrationsSection(String langCode) {
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
//             Text(
//               LocalizationService.translate('loading_celebrations', langCode),
//               style: TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//       );
//     }

//     List<String> celebrations = [];

//     if (customers.isNotEmpty) {
//       final today = DateTime.now();
//       final happyBirthday =
//           LocalizationService.translate('happy_birthday', langCode);
//       final happyAnniversary =
//           LocalizationService.translate('happy_anniversary', langCode);

//       for (var customer in customers) {
//         if (customer['dob'] != null && customer['dob'].isNotEmpty) {
//           try {
//             final dob = DateTime.parse(customer['dob']);
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
//               celebrations.add(
//                 age > 0
//                     ? "🎂 $happyBirthday ${customer['name']}! ($age$suffix)"
//                     : "🎂 $happyBirthday ${customer['name']}!",
//               );
//             }
//           } catch (e) {
//             print('❌ Error parsing DOB: $e');
//           }
//         }

//         if (customer['anniversaryDate'] != null &&
//             customer['anniversaryDate'].isNotEmpty) {
//           try {
//             final anniversary = DateTime.parse(customer['anniversaryDate']);
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
//               celebrations.add(
//                 years > 0
//                     ? "💐 $happyAnniversary ${customer['name']}! ($years$suffix)"
//                     : "💐 $happyAnniversary ${customer['name']}!",
//               );
//             }
//           } catch (e) {
//             print('❌ Error parsing anniversary: $e');
//           }
//         }
//       }
//     }

//     if (!_showCustomerCelebrationsSection || celebrations.isEmpty) {
//       return const SizedBox.shrink();
//     }

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
//         bottomNavigationBar: Consumer<LanguageProvider>(
//           builder: (context, languageProvider, child) {
//             final langCode = languageProvider.locale.languageCode;
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildWishesSection(langCode),
//                 _buildCustomerCelebrationsSection(langCode),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.purple.withOpacity(0.3),
//                         blurRadius: 20,
//                         offset: const Offset(0, -5),
//                       ),
//                     ],
//                   ),
//                   child: BottomNavigationBar(
//                     currentIndex: _currentIndex,
//                     onTap: (index) {
//                       setState(() {
//                         _currentIndex = index;
//                       });
//                     },
//                     backgroundColor: Colors.transparent,
//                     elevation: 0,
//                     type: BottomNavigationBarType.fixed,
//                     selectedItemColor: Colors.purple.shade300,
//                     unselectedItemColor: Colors.grey.shade600,
//                     selectedLabelStyle: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 12,
//                     ),
//                     unselectedLabelStyle: const TextStyle(fontSize: 12),
//                     items: [
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.home_outlined, size: 28),
//                         activeIcon: const Icon(Icons.home, size: 28),
//                         label: LocalizationService.translate('home', langCode),
//                       ),
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.grid_view_rounded, size: 28),
//                         activeIcon: const Icon(Icons.grid_view, size: 28),
//                         label: LocalizationService.translate(
//                           'category',
//                           langCode,
//                         ),
//                       ),
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.edit_outlined, size: 28),
//                         activeIcon: const Icon(Icons.edit, size: 28),
//                         label: LocalizationService.translate(
//                           'poster',
//                           langCode,
//                         ),
//                       ),
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.video_library, size: 28),
//                         activeIcon: const Icon(Icons.video_library, size: 28),
//                         label: LocalizationService.translate(
//                           'reels',
//                           langCode,
//                         ),
//                       ),
//                       BottomNavigationBarItem(
//                         icon: const Icon(Icons.group_outlined, size: 28),
//                         activeIcon: const Icon(Icons.group, size: 28),
//                         label: LocalizationService.translate(
//                           'customer',
//                           langCode,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/showplans/show_pan_screen.dart';
import 'package:posternova/views/PosterModule/home.dart';
import 'package:posternova/views/category/category_screen.dart';
import 'package:posternova/views/category/special_category.dart';
import 'package:posternova/views/chat/customer_list.dart';
import 'package:posternova/views/createposter/poster_screen.dart';
import 'package:posternova/views/customer/customer_screen.dart';
import 'package:posternova/views/reels/reels_screen.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

// ─────────────────────────────────────────────
//  Notch Painter
// ─────────────────────────────────────────────
class _NotchNavPainter extends CustomPainter {
  final Color color;
  final double notchRadius;
  final double borderRadius;

  _NotchNavPainter({
    required this.color,
    this.notchRadius = 34.0,
    this.borderRadius = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double notchCurveDepth = notchRadius + 10;

    final path = Path();

    // Start from top-left with rounded corner
    path.moveTo(borderRadius, 0);

    // Top-left to just before the notch
    path.lineTo(centerX - notchRadius - 18, 0);

    // Left curve into the notch
    path.quadraticBezierTo(
      centerX - notchRadius - 4,
      0,
      centerX - notchRadius + 2,
      notchCurveDepth * 0.35,
    );

    // Arc across the notch (semicircle cutout)
    path.arcToPoint(
      Offset(centerX + notchRadius - 2, notchCurveDepth * 0.35),
      radius: Radius.circular(notchRadius + 6),
      clockwise: false,
    );

    // Right curve out of the notch
    path.quadraticBezierTo(
      centerX + notchRadius + 4,
      0,
      centerX + notchRadius + 18,
      0,
    );

    // Top-right corner
    path.lineTo(size.width - borderRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    // Right side down
    path.lineTo(size.width, size.height);

    // Bottom
    path.lineTo(0, size.height);

    // Left side up
    path.lineTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    path.close();

    // Shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.5), 8, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_NotchNavPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ─────────────────────────────────────────────
//  Nav Item Model
// ─────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final bool isCenter;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    this.isCenter = false,
  });
}

// ─────────────────────────────────────────────
//  Main Navigation Screen
// ─────────────────────────────────────────────
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  String? currentUserId;
  String? userId;
  Map<String, dynamic> birthdayData = {};
  List<dynamic> customers = [];
  bool isLoadingCustomers = false;
  bool isLoadingWishes = false;

  bool _showWishesSection = true;
  bool _showCustomerCelebrationsSection = true;

  late AnimationController _proJiggleController;
  late Animation<double> _proJiggleAnimation;

  final List<Widget> _screens = [
    const HomeScreen(),
    // const CategoryScreen(),
    const SpecialCategory(),
    const CustomerList(),
    // const PosterScreen(),
    const ReelsScreen(),
    const CustomerScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupProAnimation();
  }

  void _setupProAnimation() {
    _proJiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _proJiggleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.18), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -0.18, end: 0.18), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 0.18, end: -0.12), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.12), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 0.12, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(
            parent: _proJiggleController,
            curve: Curves.easeInOut,
          ),
        );

    Future.delayed(const Duration(seconds: 2), _startJiggleLoop);
  }

  void _startJiggleLoop() {
    if (!mounted) return;
    _proJiggleController.forward(from: 0).then((_) {
      Future.delayed(const Duration(seconds: 3), _startJiggleLoop);
    });
  }

  @override
  void dispose() {
    _proJiggleController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _resetSectionPreferences();
    await _loadUserId();
    await Future.delayed(const Duration(milliseconds: 300));
    if (userId != null) await fetchCustomers();
  }

  Future<void> _resetSectionPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_wishes_section', true);
    await prefs.setBool('show_customer_celebrations', true);
    setState(() {
      _showWishesSection = true;
      _showCustomerCelebrationsSection = true;
    });
  }

  Future<void> _loadUserId() async {
    setState(() => isLoadingWishes = true);
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData != null) {
        setState(() {
          currentUserId = userData.user.id;
          userId = userData.user.id;
        });
        final response = await http.get(
          Uri.parse(
            'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
          ),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            birthdayData = Map<String, dynamic>.from(data);
            isLoadingWishes = false;
          });
        } else {
          setState(() => isLoadingWishes = false);
        }
      } else {
        setState(() => isLoadingWishes = false);
      }
    } catch (e) {
      setState(() => isLoadingWishes = false);
    }
  }

  Future<void> fetchCustomers() async {
    if (userId == null) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (userId == null) return;
    }
    setState(() => isLoadingCustomers = true);
    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          customers = data['customers'] ?? [];
          isLoadingCustomers = false;
        });
      } else {
        setState(() => isLoadingCustomers = false);
      }
    } catch (e) {
      setState(() => isLoadingCustomers = false);
    }
  }

  Future<void> _saveWishesSectionPreference(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_wishes_section', show);
  }

  Future<void> _saveCustomerCelebrationsPreference(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_customer_celebrations', show);
  }

  // ── Wishes Banner ──────────────────────────────────────────────────────────
  Widget _buildWishesSection(String langCode) {
    if (isLoadingWishes) {
      return _loadingBanner(
        LocalizationService.translate('loading_wishes', langCode),
      );
    }
    if (!_showWishesSection ||
        birthdayData['wishes'] == null ||
        (birthdayData['wishes'] is List && birthdayData['wishes'].isEmpty)) {
      return const SizedBox.shrink();
    }
    return _marqueeBanner(
      gradient: const LinearGradient(
        colors: [Color(0xFFE0F7FA), Color.fromARGB(255, 236, 178, 242)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadowColor: const Color.fromRGBO(103, 58, 183, 1),
      borderColor: const Color(0xFF80DEEA),
      iconBg: const Color(0xFF00838F),
      iconData: Icons.celebration,
      closeIconColor: const Color(0xFF00838F),
      textColor: const Color(0xFF004D40),
      text: (birthdayData['wishes'] is List)
          ? birthdayData['wishes'].join("  •  ")
          : birthdayData['wishes'].toString(),
      onClose: () {
        setState(() => _showWishesSection = false);
        _saveWishesSectionPreference(false);
      },
    );
  }

  // ── Customer Celebrations Banner ───────────────────────────────────────────
  Widget _buildCustomerCelebrationsSection(String langCode) {
    if (isLoadingCustomers) {
      return _loadingBanner(
        LocalizationService.translate('loading_celebrations', langCode),
      );
    }

    List<String> celebrations = [];
    if (customers.isNotEmpty) {
      final today = DateTime.now();
      final happyBirthday = LocalizationService.translate(
        'happy_birthday',
        langCode,
      );
      final happyAnniversary = LocalizationService.translate(
        'happy_anniversary',
        langCode,
      );

      for (var customer in customers) {
        if (customer['dob'] != null && customer['dob'].isNotEmpty) {
          try {
            final dob = DateTime.parse(customer['dob']);
            if (dob.month == today.month && dob.day == today.day) {
              final age = today.year - dob.year;
              celebrations.add(
                age > 0
                    ? "🎂 $happyBirthday ${customer['name']}! ($age${_suffix(age)})"
                    : "🎂 $happyBirthday ${customer['name']}!",
              );
            }
          } catch (_) {}
        }
        if (customer['anniversaryDate'] != null &&
            customer['anniversaryDate'].isNotEmpty) {
          try {
            final ann = DateTime.parse(customer['anniversaryDate']);
            if (ann.month == today.month && ann.day == today.day) {
              final years = today.year - ann.year;
              celebrations.add(
                years > 0
                    ? "💐 $happyAnniversary ${customer['name']}! ($years${_suffix(years)})"
                    : "💐 $happyAnniversary ${customer['name']}!",
              );
            }
          } catch (_) {}
        }
      }
    }

    if (!_showCustomerCelebrationsSection || celebrations.isEmpty) {
      return const SizedBox.shrink();
    }

    return _marqueeBanner(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadowColor: const Color(0xFFFF6F00),
      borderColor: const Color(0xFFFFB74D),
      iconBg: const Color(0xFFE65100),
      iconData: Icons.cake,
      closeIconColor: const Color(0xFFE65100),
      textColor: const Color(0xFFBF360C),
      text: celebrations.join("  •  "),
      onClose: () {
        setState(() => _showCustomerCelebrationsSection = false);
        _saveCustomerCelebrationsPreference(false);
      },
    );
  }

  String _suffix(int n) {
    if (n % 10 == 1 && n != 11) return 'st';
    if (n % 10 == 2 && n != 12) return 'nd';
    if (n % 10 == 3 && n != 13) return 'rd';
    return 'th';
  }

  Widget _loadingBanner(String text) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );

  Widget _marqueeBanner({
    required LinearGradient gradient,
    required Color shadowColor,
    required Color borderColor,
    required Color iconBg,
    required IconData iconData,
    required Color closeIconColor,
    required Color textColor,
    required String text,
    required VoidCallback onClose,
  }) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(color: borderColor, width: 1),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 22,
            child: Marquee(
              text: text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textColor,
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
          onTap: onClose,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, color: closeIconColor, size: 16),
          ),
        ),
      ],
    ),
  );

  // ── PRO Badge ──────────────────────────────────────────────────────────────
  // Widget _buildProBadge() {
  //   return Positioned(
  //     right: 4,
  //     bottom: 164,
  //     child: GestureDetector(
  //       onTap: () {

  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowPlanScreen()));
  //         // Navigate to Pro screen
  //       },
  //       child: AnimatedBuilder(
  //         animation: _proJiggleAnimation,
  //         builder: (context, child) => Transform.rotate(
  //           angle: _proJiggleAnimation.value,
  //           child: child,
  //         ),
  //         child: Container(
  //           width: 58,
  //           height: 58,
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             gradient: const RadialGradient(
  //               colors: [
  //                 Color(0xFFFFE566),
  //                 Color(0xFFFFA000),
  //                 Color(0xFFE65100),
  //               ],
  //               center: Alignment.topLeft,
  //               radius: 1.5,
  //             ),
  //             border: Border.all(color: const Color(0xFF6A0DAD), width: 3),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: const Color(0xFFFF6F00).withOpacity(0.55),
  //                 blurRadius: 10,
  //                 spreadRadius: 1,
  //               ),
  //             ],
  //           ),
  //           child: const Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(Icons.workspace_premium, color: Colors.white, size: 20),
  //               SizedBox(height: 1),
  //               Text(
  //                 'PRO',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.w900,
  //                   letterSpacing: 1.2,
  //                   height: 1.0,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProBadge() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ShowPlanScreen()),
        );
      },
      child: AnimatedBuilder(
        animation: _proJiggleAnimation,
        builder: (context, child) =>
            Transform.rotate(angle: _proJiggleAnimation.value, child: child),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFFFE566), Color(0xFFFFA000), Color(0xFFE65100)],
              center: Alignment.topLeft,
              radius: 1.5,
            ),
            border: Border.all(color: const Color(0xFF6A0DAD), width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6F00).withOpacity(0.55),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.workspace_premium, color: Colors.white, size: 20),
              SizedBox(height: 1),
              Text(
                'PRO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Curved Notch Bottom Nav ────────────────────────────────────────────────
  Widget _buildCurvedNotchNavBar(String langCode) {
    const navBgColor = Color(0xFF1C1C2E);
    const double navHeight = 62.0;
    const double fabSize = 56.0;
    const double notchRadius = 36.0;

    final items = [
      _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: LocalizationService.translate('home', langCode),
        index: 0,
      ),
      _NavItem(
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view,
        label: LocalizationService.translate('category', langCode),
        index: 1,
      ),
      _NavItem(
        icon: Icons.edit_outlined,
        activeIcon: Icons.edit,
        label: 'Create',
        index: 2,
        isCenter: true,
      ),
      _NavItem(
        icon: Icons.contact_page_outlined,
        activeIcon: Icons.contact_page,
        label: 'reels',
        index: 3,
      ),
      _NavItem(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        label: 'customers',
        index: 4,
      ),
    ];

    return SizedBox(
      height: navHeight + 24 + MediaQuery.of(context).padding.bottom,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ── Painted notch background ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: _NotchNavPainter(
                color: navBgColor,
                notchRadius: notchRadius,
                borderRadius: 20,
              ),
              child: SizedBox(
                height: navHeight + MediaQuery.of(context).padding.bottom,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: Row(
                    children: items.map((item) {
                      if (item.isCenter) {
                        // Empty space for the FAB
                        return const Expanded(child: SizedBox());
                      }
                      final isActive = _currentIndex == item.index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _currentIndex = item.index),
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isActive ? item.activeIcon : item.icon,
                                color: isActive
                                    ? const Color(0xFF448AFF)
                                    : Colors.grey.shade500,
                                size: 26,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isActive
                                      ? const Color(0xFF448AFF)
                                      : Colors.grey.shade500,
                                  fontWeight: isActive
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),

          // ── Floating Create FAB ──
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => setState(() => _currentIndex = 2),
              child: Container(
                width: fabSize,
                height: fabSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: navBgColor,
                  border: Border.all(color: const Color(0xFF2E2E48), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _currentIndex == 2 ? Icons.edit : Icons.edit_outlined,
                  color: _currentIndex == 2
                      ? const Color(0xFFFFA000)
                      : Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),

          // ── "Create" label below FAB ──
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 8,
            child: AppText(
              'chat',
              style: TextStyle(
                fontSize: 11,
                color: _currentIndex == 2
                    ? const Color(0xFFFFA000)
                    : Colors.grey.shade500,
                fontWeight: _currentIndex == 2
                    ? FontWeight.w700
                    : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(durationUntilAlertAgain: const Duration(days: 1)),
      dialogStyle: UpgradeDialogStyle.material,
      showLater: true,
      showIgnore: false,
      child: Scaffold(
        // backgroundColor: Colors.black,
        body: _screens[_currentIndex],
        bottomNavigationBar: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            final langCode = languageProvider.locale.languageCode;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWishesSection(langCode),
                _buildCustomerCelebrationsSection(langCode),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topRight,
                  children: [
                    _buildCurvedNotchNavBar(langCode),
                    Positioned(
                      right: 4,
                      top:
                          -20, // adjust this value to position it above the navbar
                      child: _buildProBadge(),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
