// // import 'dart:convert';
// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:intl/intl.dart';
// // import 'package:posternova/helper/storage_helper.dart';
// // import 'package:posternova/helper/sub_modal_helper.dart';
// // import 'package:posternova/models/category_model.dart';
// // import 'package:posternova/models/poster_model.dart';
// // import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
// // import 'package:posternova/providers/PosterProvider/poster_provider.dart';
// // import 'package:posternova/providers/festivals/date_time_provider.dart';
// // import 'package:posternova/providers/plans/get_all_plan_provider.dart';
// // import 'package:posternova/providers/plans/my_plan_provider.dart';
// // import 'package:posternova/providers/story/story_provider.dart';
// // import 'package:posternova/views/PosterModule/canvas_poster_listing_screen.dart';
// // import 'package:posternova/views/PosterModule/poster_listing_screen.dart';
// // import 'package:posternova/views/PosterModule/poster_making_screen.dart';
// // import 'package:posternova/views/backgroundremover/background_remover.dart';
// // import 'package:posternova/views/category/category_screen.dart';
// // import 'package:posternova/views/chat/customer_list.dart';
// // import 'package:posternova/views/invoices/add_invoice_data.dart';
// // import 'package:posternova/views/onlinepunchang/online_punchang_screen.dart';
// // import 'package:posternova/views/stories/story_widget_screen.dart';
// // import 'package:posternova/views/subscription/payment_success_screen.dart';
// // import 'package:posternova/widgets/date_selctor_widget.dart';
// // import 'package:posternova/widgets/faancy_app_bar.dart';
// // import 'package:posternova/widgets/language_widget.dart';
// // import 'package:posternova/widgets/premium_widget.dart';
// // import 'package:posternova/widgets/voice_assistant_widget.dart';
// // import 'package:provider/provider.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:share_plus/share_plus.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
// //   List<CategoryModel> items = [];
// //   final String imageUrl =
// //       "https://fntarizona.com/wp-content/uploads/2017/05/shutterstock_624472886.jpg";

// //   bool serchValue = false;

// //   bool _showWishesSection = true;
// //   bool _showCustomerCelebrationsSection = true;

// //   int _currentIndex = 0;
// //   String? posterId;
// //   String? currentUserId;
// //   String? username;
// //   String? userImage;
// //   String? userId;
// //   String? _savedImageBase64;

// //   Map<String, dynamic> birthdayData = {};
// //   Map<String, dynamic> anniversaryData = {};

// //   Map<String, List<dynamic>> weeklyPosters = {};
// //   List<String> weekDays = [
// //     'Monday',
// //     'Tuesday',
// //     'Wednesday',
// //     'Thursday',
// //     'Friday',
// //     'Saturday',
// //     'Sunday',
// //   ];

// //   List<dynamic> customers = [];
// //   bool isLoadingCustomers = false;

// //   Locale _locale = const Locale('en');

// //   bool _isLoading = false;

// //   static bool _hasShownReferAndEarnModal = false;

// //   late final MyPlanProvider myplanprovider;

// //   List<dynamic> festivaldata = [];
// //   List<dynamic> posterdata = [];
// //   List<dynamic> canvaposter = [];

// //   final TextEditingController _searchController = TextEditingController();
// //   bool _isListening = false;
// //   String _searchText = '';

// //   bool _hasSpokenGreeting = false;

// //   // late stt.SpeechToText _speech;
// //   List<dynamic> _filteredCategories = [];
// //   List<dynamic> _filteredNewposters = [];

// //   static bool _hasClosedWishesSection = false;
// //   static bool _hasClosedCelebrationsSection = false;

// //   // late final CategoryProviderr categoryprovider;
// //   late final CanvaPosterProvider canvaPosterProvider;
// //   Map<String, List<Map<String, dynamic>>> _categorizedPosters = {};

// //   // Animation controllers
// //   late AnimationController _headerAnimationController;
// //   late AnimationController _contentAnimationController;
// //   late Animation<double> _headerFadeAnimation;
// //   late Animation<Offset> _headerSlideAnimation;
// //   late Animation<double> _contentFadeAnimation;

// //   void _setLocale(Locale locale) {
// //     setState(() {
// //       _locale = locale;
// //     });
// //   }

// //   Future<void> _saveWishesSectionPreference(bool show) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('show_wishes_section', show);
// //   }

// //   Future<void> _saveCustomerCelebrationsPreference(bool show) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setBool('show_customer_celebrations', show);
// //   }

// //   Future<void> _loadSectionPreferences() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       // Only load from preferences if not manually closed in this session
// //       if (!_hasClosedWishesSection) {
// //         _showWishesSection = prefs.getBool('show_wishes_section') ?? true;
// //       }
// //       if (!_hasClosedCelebrationsSection) {
// //         _showCustomerCelebrationsSection =
// //             prefs.getBool('show_customer_celebrations') ?? true;
// //       }
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeAnimations();
// //     _loadUserData();
// //     _loadUserId();
// //     _initializeUser();

// //     // Load all data in parallel without waiting for modals
// //     Future.microtask(() async {
// //       await _initializeAllData();
// //     });
// //   }

// //   Future<void> _initializeAllData() async {
// //     if (!mounted) return;

// //     // Load all data in parallel
// //     await Future.wait([
// //       _loadUserId().catchError((e) => print('Error loading userId: $e')),
// //       _fetchnewposters().catchError((e) => print('Error fetching posters: $e')),
// //       _initializeProviders().catchError(
// //         (e) => print('Error initializing providers: $e'),
// //       ),
// //       _fetchWeeklyPosters().catchError(
// //         (e) => print('Error fetching weekly posters: $e'),
// //       ),
// //     ]);

// //     if (!mounted) return;

// //     // Fetch festival posters after data is loaded
// //     _fetchFestivalPosters(context.read<DateTimeProvider>().selectedDate);

// //     // Start animations
// //     _startAnimations();
// //   }

// //   Future<void> _initializeProviders() async {
// //     if (!mounted) return;

// //     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
// //     final storyProvider = Provider.of<StoryProvider>(context, listen: false);
// //     final posterProvider = Provider.of<PosterProvider>(context, listen: false);

// //     storyProvider.fetchStories();

// //     // Load plan and posters in parallel
// //     await Future.wait([
// //       myPlanProvider.fetchMyPlan(userId.toString()).catchError((e) {
// //         print('Error fetching MyPlan: $e');
// //         return null;
// //       }),
// //       posterProvider.fetchPosters().catchError((e) {
// //         print('Error fetching posters: $e');
// //         return null;
// //       }),
// //     ]);

// //     if (!mounted) return;

// //     // Show modals after data is loaded
// //     _showInitialModals();
// //   }

// //   void _showInitialModals() {
// //     if (!mounted) return;

// //     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

// //     // Show subscription if needed
// //     if (!myPlanProvider.isPurchase) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         if (mounted) {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(builder: (context) => SubscriptionPlansPage()),
// //           );
// //         }
// //       });
// //     }

// //     // Show refer modal if needed
// //     if (!_hasShownReferAndEarnModal) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         if (mounted) {
// //           showReferAndEarnModal(context);
// //           _hasShownReferAndEarnModal = true;
// //         }
// //       });
// //     }
// //   }
// //   Future<void> _fetchWeeklyPosters() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse(
// //           'http://31.97.206.144:4061/api/poster/weeklyposters/$currentUserId',
// //         ),
// //       );

// //       print('response status code for weekly posters ${response.statusCode}');
// //       print('response bodyyyyyyyyyyyyyy for weekly posters ${response.body}');

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body) as Map<String, dynamic>;
// //         setState(() {
// //           weeklyPosters = data.map(
// //             (key, value) => MapEntry(key, List<dynamic>.from(value)),
// //           );
// //         });
// //       }
// //     } catch (e) {
// //       print('Error fetching weekly posters: $e');
// //     }
// //   }

// //   Future<void> _loadUserId() async {
// //     if (!mounted) return;
// //     try {
// //       final userData = await AuthPreferences.getUserData();
// //       if (!mounted) return;
// //       if (userData != null) {
// //         setState(() {
// //           username = userData.user.name;
// //           currentUserId = userData.user.id;
// //         });

// //         await _fetchWeeklyPosters();

// //         final response = await http.get(
// //           Uri.parse(
// //             'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
// //           ),
// //         );

// //         if (response.statusCode == 200) {
// //           final data = jsonDecode(response.body);

// //           setState(() {
// //             birthdayData = Map<String, dynamic>.from(data);
// //             anniversaryData = Map<String, dynamic>.from(data);
// //           });
// //         } else {
// //           print(
// //             'Failed to load birthday data. Status code: ${response.statusCode}',
// //           );
// //         }
// //       }
// //     } catch (e) {
// //       print('Error loading user ID or birthday data: $e');
// //     }
// //   }

// //   Future<void> fetchCustomers() async {
// //     // Wait for userId to be loaded first
// //     if (userId == null) {
// //       print('userId is null, waiting...');
// //       // Give it a moment for _loadUserId to complete
// //       await Future.delayed(Duration(milliseconds: 500));

// //       if (userId == null) {
// //         print('Cannot fetch customers: userId is still null');
// //         return;
// //       }
// //     }

// //     setState(() {
// //       isLoadingCustomers = true;
// //     });

// //     try {
// //       print('Fetching customers for userId: $userId');
// //       final response = await http.get(
// //         Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
// //       );

// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         setState(() {
// //           customers = data['customers'] ?? [];
// //           isLoadingCustomers = false;
// //         });
// //         print('✅ Customers fetched successfully: ${customers.length}');

// //         // Debug: Print customer data
// //         for (var customer in customers) {
// //           print(
// //             'Customer: ${customer['name']}, DOB: ${customer['dob']}, Anniversary: ${customer['anniversaryDate']}',
// //           );
// //         }
// //       } else {
// //         setState(() {
// //           isLoadingCustomers = false;
// //         });
// //         print('❌ Failed to load customers: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       setState(() {
// //         isLoadingCustomers = false;
// //       });
// //       print('❌ Error fetching customers: $e');
// //     }
// //   }

// //   String _formatDate(DateTime date) {
// //     return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
// //   }

// //   Future<void> _initializeUser() async {
// //     final userData = await AuthPreferences.getUserData();
// //     if (userData != null && userData.user.id != null) {
// //       final storyProvider = Provider.of<StoryProvider>(context, listen: false);

// //       storyProvider.setCurrentUser(
// //         userId: userData.user.id,
// //         userImage: userData.user.profileImage,
// //         username: userData.user.name ?? '',
// //       );

// //       storyProvider.fetchStories();
// //     }
// //   }

// //   List<String> _getOrderedDaysFromToday() {
// //     final today = DateFormat('EEEE').format(DateTime.now());
// //     final todayIndex = weekDays.indexOf(today);

// //     if (todayIndex == -1) return weekDays;

// //     return [
// //       ...weekDays.sublist(todayIndex),
// //       ...weekDays.sublist(0, todayIndex),
// //     ];
// //   }

// //   void _initializeAnimations() {
// //     _headerAnimationController = AnimationController(
// //       duration: const Duration(milliseconds: 1200),
// //       vsync: this,
// //     );

// //     _contentAnimationController = AnimationController(
// //       duration: const Duration(milliseconds: 1500),
// //       vsync: this,
// //     );

// //     _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(
// //         parent: _headerAnimationController,
// //         curve: Curves.easeOutQuart,
// //       ),
// //     );

// //     _headerSlideAnimation =
// //         Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
// //           CurvedAnimation(
// //             parent: _headerAnimationController,
// //             curve: Curves.easeOutBack,
// //           ),
// //         );

// //     _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(
// //         parent: _contentAnimationController,
// //         curve: Curves.easeOutCubic,
// //       ),
// //     );
// //   }

// //   void _startAnimations() {
// //     _headerAnimationController.forward();
// //     Future.delayed(const Duration(milliseconds: 300), () {
// //       _contentAnimationController.forward();
// //     });
// //   }

// //   // Future<void> _loadUserData() async {
// //   //   final userData = await AuthPreferences.getUserData();
// //   //   print(userData);
// //   //   if (userData != null && userData.user != null) {
// //   //     setState(() {
// //   //       userId = userData.user.id;
// //   //       username = userData.user.name; // Add this
// //   //       userImage = userData.user.profileImage;
// //   //     });
// //   //     fetchCustomers();
// //   //     print('User ID: $userId');
// //   //   } else {
// //   //     print("No User ID");
// //   //   }
// //   // }

// //   Future<void> _loadUserData() async {
// //     final userData = await AuthPreferences.getUserData();
// //     print(userData);
// //     if (userData != null && userData.user != null) {
// //       setState(() {
// //         userId = userData.user.id;
// //         username = userData.user.name;
// //         userImage = userData.user.profileImage;
// //       });

// //       // Speak welcome after username is loaded
// //       // if (!_hasSpokenGreeting && username != null) {
// //       //   Future.delayed(const Duration(milliseconds: 800), () {
// //       //     VoiceGreetingHelper.speakWelcome(username);
// //       //     _hasSpokenGreeting = true;
// //       //   });
// //       // }

// //       fetchCustomers();
// //       print('User ID: $userId');
// //     } else {
// //       print("No User ID");
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _headerAnimationController.dispose();
// //     _contentAnimationController.dispose();
// //     _searchController.dispose();
// //     VoiceGreetingHelper.stop();
// //     // _speech.stop();
// //     super.dispose();
// //   }

// //   Future<void> _fetchnewposters() async {
// //     try {
// //       final canvaPosterProvider = Provider.of<CanvaPosterProvider>(
// //         context,
// //         listen: false,
// //       );
// //       await canvaPosterProvider.fetchPosters();

// //       setState(() {
// //         canvaposter = canvaPosterProvider.posters;
// //       });

// //       print('Canva posters fetched: ${canvaposter.length}');
// //     } catch (e) {
// //       print('Error fetching canva posters: $e');
// //     }
// //   }

// //   Future<void> _fetchFestivalPosters(DateTime date) async {
// //     setState(() {
// //       _isLoading = true;
// //       festivaldata = [];
// //     });

// //     try {
// //       final response = await http.post(
// //         Uri.parse('http://31.97.206.144:4061/api/poster/festival'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({'festivalDate': _formatDate(date)}),
// //       );

// //       if (response.statusCode == 200) {
// //         festivaldata = jsonDecode(response.body);
// //         setState(() {
// //           festivaldata = festivaldata;
// //           _isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           _isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         _isLoading = false;
// //       });
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final posterProvider = Provider.of<PosterProvider>(context);
// //     final posters = posterProvider.posters;

// //     return Scaffold(
// //       appBar: FancyAppBar(userId: userId),
// //       body: SafeArea(
// //         child: RefreshIndicator(
// //           onRefresh: () async {
// //             await _fetchFestivalPosters(
// //               context.read<DateTimeProvider>().selectedDate,
// //             );
// //             await _fetchnewposters();
// //             await _fetchWeeklyPosters();
// //           },
// //           color: const Color(0xFF6366F1),
// //           child: CustomScrollView(
// //             slivers: [
// //               SliverToBoxAdapter(
// //                 child: FadeTransition(
// //                   opacity: _contentFadeAnimation,
// //                   child: Column(
// //                     children: [
// //                       _buildFeaturedCarousel(),
// //                       const SizedBox(height: 32),
// //                       _buildUpcomingFestivalsSection(),
// //                       const SizedBox(height: 32),
// //                       _buildFestivalPostersSection(),
// //                       const SizedBox(height: 32),
// //                       _buildSectionHeader(
// //                         titleKey: 'weekly_templates',
// //                         subtitleKey: 'fresh_designs_everyday',
// //                       ),
// //                       const SizedBox(height: 16),
// //                       _buildWeeklyPostersSection(),
// //                       // _buildPremiumTemplatesSection(),
// //                       const SizedBox(height: 100),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //   Widget _buildWeeklyPostersSection() {
// //     if (weeklyPosters.isEmpty) return const SizedBox();

// //     final orderedDays = _getOrderedDaysFromToday();
// //     final today = DateFormat('EEEE').format(DateTime.now());

// //     return Consumer<LanguageProvider>(
// //       builder: (context, languageProvider, child) {
// //         final langCode = languageProvider.locale.languageCode;

// //         return Column(
// //           children: orderedDays.map((day) {
// //             final posters = weeklyPosters[day] ?? [];

// //             // This is the extra added lines added to show only the added posters should show //

// //             if (posters.isEmpty) return const SizedBox.shrink();
// //             final isToday = day == today;

// //             final translatedDay = LocalizationService.translate(day, langCode);
// //             final todayPrefix = LocalizationService.translate(
// //               'today_prefix',
// //               langCode,
// //             );

// //             return Column(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(
// //                     horizontal: 20,
// //                     vertical: 16,
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       Container(
// //                         padding: const EdgeInsets.symmetric(
// //                           horizontal: 12,
// //                           vertical: 6,
// //                         ),
// //                         decoration: BoxDecoration(
// //                           gradient: isToday
// //                               ? const LinearGradient(
// //                                   colors: [
// //                                     Color(0xFF6366F1),
// //                                     Color(0xFF8B5CF6),
// //                                   ],
// //                                 )
// //                               : null,
// //                           color: isToday ? null : Colors.grey.shade100,
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         child: Row(
// //                           children: [
// //                             Icon(
// //                               isToday
// //                                   ? Icons.today
// //                                   : Icons.calendar_today_outlined,
// //                               size: 18,
// //                               color: isToday
// //                                   ? Colors.white
// //                                   : const Color(0xFF6B7280),
// //                             ),
// //                             const SizedBox(width: 8),
// //                             Text(
// //                               isToday
// //                                   ? '$todayPrefix - $translatedDay'
// //                                   : translatedDay,
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: isToday
// //                                     ? Colors.white
// //                                     : const Color(0xFF111827),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       const Spacer(),
// //                       // Text(
// //                       //   posters.isEmpty
// //                       //       ? LocalizationService.translate('no_templates', langCode)
// //                       //       : '${posters.length} ${LocalizationService.translate('templates', langCode)}',
// //                       //   style: TextStyle(
// //                       //     fontSize: 14,
// //                       //     color: posters.isEmpty
// //                       //         ? Colors.grey.shade400
// //                       //         : const Color(0xFF6B7280),
// //                       //   ),
// //                       // ),
// //                     ],
// //                   ),
// //                 ),
// //                 if (posters.isEmpty)
// //                   Container(
// //                     height: 120,
// //                     margin: const EdgeInsets.symmetric(horizontal: 20),
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.shade50,
// //                       borderRadius: BorderRadius.circular(12),
// //                       border: Border.all(color: Colors.grey.shade200),
// //                     ),
// //                     child: Center(
// //                       child: Text(
// //                         '${LocalizationService.translate('no_templates_available', langCode)} $translatedDay',
// //                         style: TextStyle(
// //                           fontSize: 14,
// //                           color: Colors.grey.shade500,
// //                         ),
// //                       ),
// //                     ),
// //                   )
// //                 else
// //                   SizedBox(
// //                     height: 220,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       padding: const EdgeInsets.symmetric(horizontal: 20),
// //                       itemCount: posters.length,
// //                       itemBuilder: (context, index) {
// //                         final poster = posters[index];
// //                         return _buildWeeklyPosterCard(poster, index);
// //                       },
// //                     ),
// //                   ),
// //                 const SizedBox(height: 24),
// //               ],
// //             );
// //           }).toList(),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildWeeklyPosterCard(dynamic poster, int index) {
// //     return Consumer<MyPlanProvider>(
// //       builder: (context, myplanprovider, child) {
// //         return Container(
// //           width: 160,
// //           margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
// //           child: Material(
// //             color: Colors.transparent,
// //             child: InkWell(
// //               onTap: () {
// //                 if (myplanprovider.isPurchase == true) {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) => SamplePosterScreen(
// //                         posterId: poster['_id'] ?? poster['id'],
// //                       ),
// //                     ),
// //                   );
// //                 } else {
// //                   _showPremiumDialog();
// //                 }

// //                 // if(myplanprovider.isPurchase==true){

// //                 // }else{
// //                 //     _showPremiumDialog();
// //                 // }
// //               },
// //               borderRadius: BorderRadius.circular(16),
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(16),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.1),
// //                       blurRadius: 8,
// //                       offset: const Offset(0, 4),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Expanded(
// //                       child: Container(
// //                         width: double.infinity,
// //                         decoration: const BoxDecoration(
// //                           borderRadius: BorderRadius.vertical(
// //                             top: Radius.circular(16),
// //                           ),
// //                           color: Color(0xFFF3F4F6),
// //                         ),
// //                         child: ClipRRect(
// //                           borderRadius: const BorderRadius.vertical(
// //                             top: Radius.circular(16),
// //                           ),
// //                           child: Image.network(
// //                             poster['images']?[0] ?? '',
// //                             fit: BoxFit.cover,
// //                             loadingBuilder: (context, child, loadingProgress) {
// //                               if (loadingProgress == null) return child;
// //                               return Container(
// //                                 color: const Color(0xFFF3F4F6),
// //                                 child: const Center(
// //                                   child: CircularProgressIndicator(
// //                                     strokeWidth: 2,
// //                                     color: Color(0xFF6366F1),
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                             errorBuilder: (context, error, stackTrace) {
// //                               return Container(
// //                                 color: const Color(0xFFF3F4F6),
// //                                 child: const Center(
// //                                   child: Icon(
// //                                     Icons.image_not_supported_outlined,
// //                                     color: Color(0xFF9CA3AF),
// //                                     size: 32,
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     Padding(
// //                       padding: const EdgeInsets.all(12),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             poster['categoryName'] ??
// //                                 poster['name'] ??
// //                                 'Poster',
// //                             style: const TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w600,
// //                               color: Color(0xFF374151),
// //                             ),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildFeaturedCarousel() {
// //     return Column(
// //       children: [
// //         SizedBox(height: 20),
// //         const SizedBox(height: 16),
// //         // const HomeCarousel(),
// //       ],
// //     );
// //   }

// //   Widget _buildCategoriesSection() {
// //     final categories = [
// //       {
// //         'nameKey': 'online_punchang',
// //         'icon': Icons.calendar_month,
// //         'color': Color(0xFFF59E0B),
// //         'screen': OnlinePunchangScreen(),
// //       },
// //       {
// //         'nameKey': 'chat',
// //         'icon': Icons.chat,
// //         'color': Color.fromRGBO(11, 245, 124, 1),
// //         'screen': CustomerList(),
// //       },
// //       {
// //         'nameKey': 'categories',
// //         'icon': Icons.category_outlined,
// //         'color': Color(0xFF10B981),
// //         'screen': CategoryScreen(),
// //       },
// //       {
// //         'nameKey': 'invoices',
// //         'icon': Icons.receipt_long_outlined,
// //         'color': Color(0xFFEF4444),
// //         'screen': AddInvoiceData(),
// //       },
// //       {
// //         'nameKey': 'background_remover',
// //         'icon': Icons.edit_outlined,
// //         'color': Color(0xFFF59E0B),
// //         'screen': BackgroundRemoverScreen(),
// //       },
// //     ];

// //     return Column(
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 20),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               // Use AppText for the section title too
// //               AppText(
// //                 'categories',
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Color(0xFF111827),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SizedBox(height: 16),
// //         Container(
// //           height: 100,
// //           child: Consumer<LanguageProvider>(
// //             builder: (context, languageProvider, child) {
// //               return ListView.builder(
// //                 scrollDirection: Axis.horizontal,
// //                 padding: const EdgeInsets.symmetric(horizontal: 20),
// //                 itemCount: categories.length,
// //                 itemBuilder: (context, index) {
// //                   final category = categories[index];
// //                   // Translate the category name using the key
// //                   final translatedName = LocalizationService.translate(
// //                     category['nameKey'] as String,
// //                     languageProvider.locale.languageCode,
// //                   );

// //                   return _buildCategoryCard(
// //                     name: translatedName,
// //                     icon: category['icon'] as IconData,
// //                     color: category['color'] as Color,
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => category['screen'] as Widget,
// //                         ),
// //                       );
// //                     },
// //                   );
// //                 },
// //               );
// //             },
// //           ),
// //         ),
// //         const SizedBox(height: 32),
// //       ],
// //     );
// //   }

// //   Widget _buildCategoryCard({
// //     required String name,
// //     required IconData icon,
// //     required Color color,
// //     required VoidCallback onTap,
// //   }) {
// //     return Container(
// //       width: 100,
// //       margin: const EdgeInsets.only(right: 12),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: onTap,
// //           borderRadius: BorderRadius.circular(16),
// //           child: Container(
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(16),
// //               border: Border.all(color: color.withOpacity(0.2), width: 1.5),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: color.withOpacity(0.1),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: color.withOpacity(0.1),
// //                     shape: BoxShape.circle,
// //                   ),
// //                   child: Icon(icon, color: color, size: 28),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 8),
// //                   child: Text(
// //                     name,
// //                     textAlign: TextAlign.center,
// //                     style: const TextStyle(
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.w600,
// //                       color: Color(0xFF374151),
// //                     ),
// //                     maxLines: 2,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildUpcomingFestivalsSection() {
// //     return Padding(
// //       padding: const EdgeInsets.all(10.0),
// //       child: Column(
// //         children: [
// //           StoriesWidget(),
// //           const SizedBox(height: 16), // Add spacing
// //           _buildCategoriesSection(),

// //           // const SizedBox(height: 16),
// //           // _buildWishesSection(), // Add this
// //           // _buildCustomerCelebrationsSection(), // Add this
// //           // const SizedBox(height: 16),
// //           _buildSectionHeader(
// //             titleKey: 'seasonal_celebrations',
// //             subtitleKey: 'never_miss_celebration',
// //           ),
// //           const SizedBox(height: 16),
// //           Consumer<DateTimeProvider>(
// //             builder: (context, dateTimeProvider, _) {
// //               return DateSelectorRow(
// //                 selectedDate: dateTimeProvider.selectedDate,
// //                 onDateSelected: (date) {
// //                   dateTimeProvider.setStartDate(date);
// //                   _fetchFestivalPosters(date);
// //                 },
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFestivalPostersSection() {
// //     return Column(
// //       children: [
// //         _buildSectionHeader(
// //           titleKey: 'celebration_templates',
// //           subtitleKey: 'perfect_every_occasion',
// //           showViewAll: true,
// //           onViewAll: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => PosterListingScreen(
// //                   title: 'Celebration Templates',
// //                   type: 'festival',
// //                   festivalDate: context.read<DateTimeProvider>().selectedDate,
// //                 ),
// //               ),
// //             );
// //           },
// //         ),
// //         const SizedBox(height: 16),
// //         _buildFestivalPostersGrid(),
// //       ],
// //     );
// //   }

// //   Widget _buildFestivalPostersGrid() {
// //     if (_isLoading) {
// //       return Container(
// //         height: 200,
// //         margin: const EdgeInsets.symmetric(horizontal: 20),
// //         child: const Center(
// //           child: CircularProgressIndicator(color: Color(0xFF6366F1)),
// //         ),
// //       );
// //     }

// //     if (festivaldata.isEmpty) {
// //       return AnimatedContainer(
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeInOut,
// //         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
// //         child: TweenAnimationBuilder<double>(
// //           tween: Tween<double>(begin: 0.0, end: 1.0),
// //           duration: const Duration(milliseconds: 500),
// //           builder: (context, value, child) {
// //             return Transform.scale(
// //               scale: 0.8 + (0.2 * value),
// //               child: Opacity(
// //                 opacity: value,
// //                 child: Card(
// //                   elevation: 1,
// //                   shadowColor: Colors.black.withOpacity(0.05),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(16),
// //                   ),
// //                   child: Container(
// //                     height: 120,
// //                     padding: const EdgeInsets.all(20),
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(16),
// //                       gradient: LinearGradient(
// //                         begin: Alignment.topLeft,
// //                         end: Alignment.bottomRight,
// //                         colors: [Colors.grey.shade50, Colors.white],
// //                       ),
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         TweenAnimationBuilder<double>(
// //                           tween: Tween<double>(begin: 0.0, end: 1.0),
// //                           duration: const Duration(milliseconds: 800),
// //                           builder: (context, iconValue, child) {
// //                             return Transform.rotate(
// //                               angle: iconValue * 0.1,
// //                               child: Container(
// //                                 height: 50,
// //                                 width: 50,
// //                                 decoration: BoxDecoration(
// //                                   shape: BoxShape.circle,
// //                                   color: Theme.of(
// //                                     context,
// //                                   ).primaryColor.withOpacity(0.1),
// //                                   border: Border.all(
// //                                     color: Theme.of(
// //                                       context,
// //                                     ).primaryColor.withOpacity(0.3),
// //                                   ),
// //                                 ),
// //                                 child: Icon(
// //                                   Icons.calendar_view_month_outlined,
// //                                   size: 24,
// //                                   color: Theme.of(context).primaryColor,
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                         const SizedBox(width: 16),
// //                         Expanded(
// //                           child: Column(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               AppText(
// //                                 'no_celebration_found',
// //                                 style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.w600,
// //                                   color: Colors.grey.shade800,
// //                                 ),
// //                               ),
// //                               const SizedBox(height: 4),
// //                               AppText(
// //                                 'try_select_different_date',
// //                                 style: TextStyle(
// //                                   fontSize: 13,
// //                                   color: Colors.grey.shade600,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         ),
// //       );
// //     }

// //     return Container(
// //       height: 220,
// //       child: ListView.builder(
// //         scrollDirection: Axis.horizontal,
// //         padding: const EdgeInsets.symmetric(horizontal: 20),
// //         itemCount: festivaldata.length,
// //         itemBuilder: (context, index) {
// //           final poster = festivaldata[index];
// //           return _buildFestivalPosterCard(poster, index);
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildFestivalPosterCard(dynamic poster, int index) {
// //     return Container(
// //       width: 160,
// //       margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
// //       child: Material(
// //         color: Colors.transparent,
// //         child: InkWell(
// //           onTap: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) =>
// //                     SamplePosterScreen(posterId: poster['_id'] ?? poster['id']),
// //               ),
// //             );
// //           },
// //           borderRadius: BorderRadius.circular(16),
// //           child: Container(
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(16),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(0.1),
// //                   blurRadius: 8,
// //                   offset: const Offset(0, 4),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Expanded(
// //                   child: Container(
// //                     width: double.infinity,
// //                     decoration: BoxDecoration(
// //                       borderRadius: const BorderRadius.vertical(
// //                         top: Radius.circular(16),
// //                       ),
// //                       color: const Color(0xFFF3F4F6),
// //                     ),
// //                     child: ClipRRect(
// //                       borderRadius: const BorderRadius.vertical(
// //                         top: Radius.circular(16),
// //                       ),
// //                       child: Image.network(
// //                         poster['images'][0],
// //                         fit: BoxFit.cover,
// //                         loadingBuilder: (context, child, loadingProgress) {
// //                           if (loadingProgress == null) return child;
// //                           return Container(
// //                             color: const Color(0xFFF3F4F6),
// //                             child: const Center(
// //                               child: CircularProgressIndicator(
// //                                 strokeWidth: 2,
// //                                 color: Color(0xFF6366F1),
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                         errorBuilder: (context, error, stackTrace) {
// //                           return Container(
// //                             color: const Color(0xFFF3F4F6),
// //                             child: const Center(
// //                               child: Icon(
// //                                 Icons.image_not_supported_outlined,
// //                                 color: Color(0xFF9CA3AF),
// //                                 size: 32,
// //                               ),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.all(12),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         poster['categoryName'] ?? 'Festival',
// //                         style: const TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w600,
// //                           color: Color(0xFF374151),
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Row(
// //                         children: [
// //                           // if (!myPlanProvider.isPurchase) ...[
// //                           // Container(
// //                           //   padding: const EdgeInsets.symmetric(
// //                           //     horizontal: 6,
// //                           //     vertical: 2,
// //                           //   ),
// //                           //   decoration: BoxDecoration(
// //                           //     color: const Color(0xFF6366F1),
// //                           //     borderRadius: BorderRadius.circular(4),
// //                           //   ),
// //                           //   child: const Text(
// //                           //     'PRO',
// //                           //     style: TextStyle(
// //                           //       color: Colors.white,
// //                           //       fontSize: 10,
// //                           //       fontWeight: FontWeight.bold,
// //                           //     ),
// //                           //   ),
// //                           // ),
// //                           // const Spacer(),
// //                           // ],
// //                           // const Icon(
// //                           //   Icons.trending_up,
// //                           //   size: 14,
// //                           //   color: Color(0xFF10B981),
// //                           // ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPremiumTemplatesSection() {
// //     return Column(
// //       children: [
// //         Consumer<CanvaPosterProvider>(
// //           builder: (context, provider, child) {
// //             if (provider.isLoading) {
// //               return Container(
// //                 height: 220,
// //                 margin: const EdgeInsets.symmetric(horizontal: 20),
// //                 child: const Center(
// //                   child: CircularProgressIndicator(color: Color(0xFF6366F1)),
// //                 ),
// //               );
// //             }

// //             if (provider.error != null) {
// //               return Container(
// //                 height: 200,
// //                 margin: const EdgeInsets.symmetric(horizontal: 20),
// //                 padding: const EdgeInsets.all(32),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(color: const Color(0xFFE5E7EB)),
// //                 ),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Icon(
// //                       Icons.error_outline,
// //                       size: 40,
// //                       color: Color(0xFFEF4444),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     Text(
// //                       'Failed to load templates',
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                         color: Color(0xFF374151),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     ElevatedButton(
// //                       onPressed: () => provider.fetchPosters(),
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: const Color(0xFF6366F1),
// //                         foregroundColor: Colors.white,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                       ),
// //                       child: const Text('Retry'),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             }

// //             if (provider.posters.isEmpty) {
// //               return Container(
// //                 height: 200,
// //                 margin: const EdgeInsets.symmetric(horizontal: 20),
// //                 padding: const EdgeInsets.all(32),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(16),
// //                   border: Border.all(color: const Color(0xFFE5E7EB)),
// //                 ),
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Icon(
// //                       Icons.image_not_supported_outlined,
// //                       size: 40,
// //                       color: Color(0xFF9CA3AF),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     const Text(
// //                       'No templates available',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.w600,
// //                         color: Color(0xFF374151),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             }

// //             // Group posters by category for better organization
// //             Map<String, List<CanvasPosterModel>> categorizedPosters = {};
// //             for (var poster in provider.posters) {
// //               String category = poster.categoryName.isEmpty
// //                   ? 'Other'
// //                   : poster.categoryName;
// //               if (!categorizedPosters.containsKey(category)) {
// //                 categorizedPosters[category] = [];
// //               }
// //               categorizedPosters[category]!.add(poster);
// //             }

// //             return Column(
// //               children: categorizedPosters.entries.take(3).map((entry) {
// //                 return _buildCategorySection(entry.key, entry.value);
// //               }).toList(),
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildCategorySection(
// //     String categoryName,
// //     List<CanvasPosterModel> posters,
// //   ) {
// //     return Consumer<MyPlanProvider>(
// //       builder: (context, myPlanprovider, child) {
// //         return Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     categoryName,
// //                     style: const TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF111827),
// //                     ),
// //                   ),
// //                   TextButton.icon(
// //                     onPressed: () {
// //                       if (myPlanprovider.isPurchase == true) {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => CanvasPosterListingScreen(
// //                               categoryName: categoryName,
// //                             ),
// //                           ),
// //                         );
// //                       } else {
// //                         _showPremiumDialog();
// //                       }
// //                     },
// //                     // icon: const Icon(
// //                     //   Icons.arrow_forward_ios,
// //                     //   size: 16,
// //                     //   color: Color(0xFF6366F1),
// //                     // ),
// //                     label: const Text(
// //                       '',
// //                       style: TextStyle(
// //                         color: Color(0xFF6366F1),
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             Container(
// //               height: 190,
// //               child: ListView.builder(
// //                 scrollDirection: Axis.horizontal,
// //                 padding: const EdgeInsets.symmetric(horizontal: 20),
// //                 itemCount: posters.length,
// //                 itemBuilder: (context, index) {
// //                   return _buildPremiumPosterCard(posters[index], index);
// //                 },
// //               ),
// //             ),
// //             const SizedBox(height: 24),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildPremiumPosterCard(CanvasPosterModel poster, int index) {
// //     return Consumer<MyPlanProvider>(
// //       builder: (context, myPlanProvider, child) {
// //         return Container(
// //           width: 170,
// //           margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
// //           child: Material(
// //             color: Colors.transparent,
// //             child: InkWell(
// //               onTap: () {
// //                 if (myPlanProvider.isPurchase == true) {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(
// //                       builder: (context) =>
// //                           SamplePosterScreen(posterId: poster.id),
// //                     ),
// //                   );
// //                 } else {
// //                   _showPremiumDialog();
// //                 }
// //               },
// //               borderRadius: BorderRadius.circular(16),
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.circular(16),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.black.withOpacity(0.08),
// //                       blurRadius: 8,
// //                       offset: const Offset(0, 4),
// //                     ),
// //                   ],
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Expanded(
// //                       flex: 3,
// //                       child: Container(
// //                         width: double.infinity,
// //                         decoration: BoxDecoration(
// //                           borderRadius: const BorderRadius.vertical(
// //                             top: Radius.circular(16),
// //                           ),
// //                           color: const Color(0xFFF3F4F6),
// //                         ),
// //                         child: Stack(
// //                           children: [
// //                             ClipRRect(
// //                               borderRadius: const BorderRadius.only(
// //                                 topLeft: Radius.circular(16),
// //                                 topRight: Radius.circular(16),
// //                                 bottomLeft: Radius.circular(16), // 👈 add these
// //                                 bottomRight: Radius.circular(
// //                                   16,
// //                                 ), // 👈 add these
// //                               ),
// //                               child: Image.network(
// //                                 poster.images.isNotEmpty
// //                                     ? poster.images[0]
// //                                     : '',
// //                                 width: double.infinity,
// //                                 fit: BoxFit.cover,
// //                                 loadingBuilder:
// //                                     (context, child, loadingProgress) {
// //                                       if (loadingProgress == null) return child;
// //                                       return Container(
// //                                         color: const Color(0xFFF3F4F6),
// //                                         child: const Center(
// //                                           child: CircularProgressIndicator(
// //                                             strokeWidth: 2,
// //                                             color: Color(0xFF6366F1),
// //                                           ),
// //                                         ),
// //                                       );
// //                                     },
// //                                 errorBuilder: (context, error, stackTrace) {
// //                                   return Container(
// //                                     color: const Color(0xFFF3F4F6),
// //                                     child: const Center(
// //                                       child: Icon(
// //                                         Icons.image_not_supported_outlined,
// //                                         color: Color(0xFF9CA3AF),
// //                                         size: 32,
// //                                       ),
// //                                     ),
// //                                   );
// //                                 },
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildSectionHeader({
// //     required String titleKey,
// //     required String subtitleKey,
// //     bool showViewAll = false,
// //     VoidCallback? onViewAll,
// //   }) {
// //     return Consumer<LanguageProvider>(
// //       builder: (context, languageProvider, child) {
// //         return Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 20),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       LocalizationService.translate(
// //                         titleKey,
// //                         languageProvider.locale.languageCode,
// //                       ),
// //                       style: const TextStyle(
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.bold,
// //                         color: Color(0xFF111827),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       LocalizationService.translate(
// //                         subtitleKey,
// //                         languageProvider.locale.languageCode,
// //                       ),
// //                       style: const TextStyle(
// //                         fontSize: 14,
// //                         color: Color(0xFF6B7280),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               if (showViewAll && onViewAll != null)
// //                 TextButton(
// //                   onPressed: onViewAll,
// //                   style: TextButton.styleFrom(
// //                     foregroundColor: const Color(0xFF6366F1),
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 12,
// //                       vertical: 8,
// //                     ),
// //                   ),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Text(
// //                         LocalizationService.translate(
// //                           'view_all',
// //                           languageProvider.locale.languageCode,
// //                         ),
// //                         style: const TextStyle(
// //                           fontSize: 14,
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 4),
// //                       const Icon(Icons.arrow_forward_ios, size: 14),
// //                     ],
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   void _showPremiumDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => Dialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
// //         child: Container(
// //           padding: const EdgeInsets.all(24),
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(24),
// //             gradient: const LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Color(0xFFFAF5FF), Color(0xFFEEF2FF)],
// //             ),
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // Premium Icon with gradient
// //               Container(
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   gradient: const LinearGradient(
// //                     colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
// //                   ),
// //                   shape: BoxShape.circle,
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: const Color(0xFF6366F1).withOpacity(0.3),
// //                       blurRadius: 16,
// //                       offset: const Offset(0, 4),
// //                     ),
// //                   ],
// //                 ),
// //                 child: const Icon(
// //                   Icons.workspace_premium,
// //                   color: Colors.white,
// //                   size: 32,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),

// //               // Title
// //               const Text(
// //                 'Unlock Premium',
// //                 style: TextStyle(
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.bold,
// //                   color: Color(0xFF1F2937),
// //                 ),
// //               ),
// //               const SizedBox(height: 12),

// //               // Description
// //               const Text(
// //                 'Get access to exclusive templates and premium features to enhance your experience.',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   fontSize: 14,
// //                   color: Color(0xFF6B7280),
// //                   height: 1.5,
// //                 ),
// //               ),
// //               const SizedBox(height: 24),
// //               const SizedBox(height: 24),

// //               // Action Buttons
// //               Row(
// //                 children: [
// //                   Expanded(
// //                     child: OutlinedButton(
// //                       onPressed: () => Navigator.pop(context),
// //                       style: OutlinedButton.styleFrom(
// //                         padding: const EdgeInsets.symmetric(vertical: 14),
// //                         side: const BorderSide(color: Color(0xFFE5E7EB)),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                       child: const Text(
// //                         'Maybe Later',
// //                         style: TextStyle(
// //                           color: Color(0xFF6B7280),
// //                           fontWeight: FontWeight.w600,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => SubscriptionPlansPage(),
// //                           ),
// //                         );
// //                         // Navigator.pop(context);
// //                         // showSubscriptionModal(context);
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         padding: const EdgeInsets.symmetric(vertical: 14),
// //                         backgroundColor: const Color(0xFF6366F1),
// //                         foregroundColor: Colors.white,
// //                         elevation: 0,
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                         ),
// //                       ),
// //                       child: const Text(
// //                         'Upgrade Now',
// //                         style: TextStyle(fontWeight: FontWeight.w600),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void showSubscriptionModal(BuildContext context) async {
// //     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

// //     if (myPlanProvider.isPurchase == true) {
// //       return;
// //     }

// //     final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
// //     final shouldShowAgain =
// //         await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

// //     if (hasShownRecently && !shouldShowAgain) {
// //       print('Subscription modal shown recently, skipping');
// //       return;
// //     }

// //     final planProvider = Provider.of<GetAllPlanProvider>(
// //       context,
// //       listen: false,
// //     );
// //     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
// //       planProvider.fetchAllPlans();
// //     }

// //     showDialog(
// //       context: context,
// //       barrierDismissible: true,
// //       builder: (context) => Dialog(
// //         backgroundColor: Colors.transparent,
// //         insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// //         child: Container(
// //           width: MediaQuery.of(context).size.width * 0.95,
// //           height: MediaQuery.of(context).size.height * 0.95,
// //           decoration: BoxDecoration(
// //             gradient: const LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
// //             ),
// //             borderRadius: BorderRadius.circular(32),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: const Color(0xFF6366F1).withOpacity(0.4),
// //                 blurRadius: 40,
// //                 offset: const Offset(0, 20),
// //               ),
// //             ],
// //           ),
// //           child: Stack(
// //             children: [
// //               // Decorative circles
// //               Positioned(
// //                 top: -50,
// //                 right: -50,
// //                 child: Container(
// //                   width: 150,
// //                   height: 150,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: Colors.white.withOpacity(0.1),
// //                   ),
// //                 ),
// //               ),
// //               Positioned(
// //                 bottom: -30,
// //                 left: -30,
// //                 child: Container(
// //                   width: 100,
// //                   height: 100,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: Colors.white.withOpacity(0.1),
// //                   ),
// //                 ),
// //               ),

// //               // Main content
// //               Column(
// //                 children: [
// //                   // Header with close button (optional header text removed)
// //                   Padding(
// //                     padding: const EdgeInsets.all(16),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.end,
// //                       children: [
// //                         GestureDetector(
// //                           onTap: () => Navigator.pop(context),
// //                           child: Container(
// //                             padding: const EdgeInsets.all(8),
// //                             decoration: BoxDecoration(
// //                               color: Colors.white.withOpacity(0.2),
// //                               shape: BoxShape.circle,
// //                             ),
// //                             child: const Icon(
// //                               Icons.close,
// //                               color: Colors.white,
// //                               size: 20,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   // Plans Container - Now using Expanded with fixed layout
// //                   Expanded(
// //                     flex: 2,
// //                     child: Container(
// //                       margin: const EdgeInsets.symmetric(horizontal: 16),
// //                       padding: const EdgeInsets.all(16),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(24),
// //                       ),
// //                       child: Consumer<GetAllPlanProvider>(
// //                         builder: (context, provider, child) {
// //                           if (provider.isLoading) {
// //                             return const Center(
// //                               child: Column(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   CircularProgressIndicator(
// //                                     color: Color(0xFF6366F1),
// //                                     strokeWidth: 3,
// //                                   ),
// //                                   SizedBox(height: 16),
// //                                   Text(
// //                                     'Loading premium plans...',
// //                                     style: TextStyle(
// //                                       color: Color(0xFF6B7280),
// //                                       fontSize: 14,
// //                                       fontWeight: FontWeight.w500,
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             );
// //                           }

// //                           if (provider.error != null) {
// //                             return Center(
// //                               child: Column(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   Container(
// //                                     padding: const EdgeInsets.all(16),
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.red.shade50,
// //                                       shape: BoxShape.circle,
// //                                     ),
// //                                     child: Icon(
// //                                       Icons.error_outline_rounded,
// //                                       color: Colors.red.shade400,
// //                                       size: 48,
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 16),
// //                                   const Text(
// //                                     'Oops! Something went wrong',
// //                                     style: TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.bold,
// //                                       color: Color(0xFF1F2937),
// //                                     ),
// //                                   ),
// //                                   const SizedBox(height: 8),
// //                                   Text(
// //                                     'Unable to load plans. Please try again.',
// //                                     style: TextStyle(
// //                                       color: Colors.grey.shade600,
// //                                       fontSize: 14,
// //                                     ),
// //                                     textAlign: TextAlign.center,
// //                                   ),
// //                                   const SizedBox(height: 24),
// //                                   ElevatedButton(
// //                                     onPressed: () => provider.fetchAllPlans(),
// //                                     style: ElevatedButton.styleFrom(
// //                                       backgroundColor: const Color(0xFF6366F1),
// //                                       foregroundColor: Colors.white,
// //                                       padding: const EdgeInsets.symmetric(
// //                                         horizontal: 32,
// //                                         vertical: 16,
// //                                       ),
// //                                       shape: RoundedRectangleBorder(
// //                                         borderRadius: BorderRadius.circular(12),
// //                                       ),
// //                                       elevation: 0,
// //                                     ),
// //                                     child: const Text(
// //                                       'Try Again',
// //                                       style: TextStyle(
// //                                         fontSize: 15,
// //                                         fontWeight: FontWeight.w600,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             );
// //                           }

// //                           if (provider.plans.isNotEmpty) {
// //                             // Non-scrollable plan list with flexible spacing
// //                             return LayoutBuilder(
// //                               builder: (context, constraints) {
// //                                 final totalPlans = provider.plans.length;
// //                                 final availableHeight = constraints.maxHeight;

// //                                 // Calculate height for each plan based on number of plans
// //                                 final planHeight = availableHeight / totalPlans;

// //                                 return Column(
// //                                   children: provider.plans.asMap().entries.map((
// //                                     entry,
// //                                   ) {
// //                                     final index = entry.key;
// //                                     final plan = entry.value;

// //                                     return Expanded(
// //                                       child: Container(
// //                                         margin: EdgeInsets.only(
// //                                           bottom:
// //                                               index < provider.plans.length - 1
// //                                               ? 12
// //                                               : 0,
// //                                         ),
// //                                         decoration: BoxDecoration(
// //                                           color: Colors.white,
// //                                           borderRadius: BorderRadius.circular(
// //                                             16,
// //                                           ),
// //                                           border: Border.all(
// //                                             color: index == 0
// //                                                 ? const Color(0xFF6366F1)
// //                                                 : Colors.grey.shade200,
// //                                             width: index == 0 ? 2 : 1,
// //                                           ),
// //                                           boxShadow: [
// //                                             BoxShadow(
// //                                               color: Colors.black.withOpacity(
// //                                                 0.05,
// //                                               ),
// //                                               blurRadius: 10,
// //                                               offset: const Offset(0, 5),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                         child: Material(
// //                                           color: Colors.transparent,
// //                                           child: InkWell(
// //                                             onTap: () {
// //                                               Navigator.of(context).pop();
// //                                               Navigator.push(
// //                                                 context,
// //                                                 MaterialPageRoute(
// //                                                   builder: (context) =>
// //                                                       PlanDetailsAndPaymentScreen(
// //                                                         plan: plan,
// //                                                       ),
// //                                                 ),
// //                                               );
// //                                             },
// //                                             borderRadius: BorderRadius.circular(
// //                                               16,
// //                                             ),
// //                                             child: Padding(
// //                                               padding: const EdgeInsets.all(16),
// //                                               child: Column(
// //                                                 crossAxisAlignment:
// //                                                     CrossAxisAlignment.start,
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment.center,
// //                                                 children: [
// //                                                   // Plan name and badge
// //                                                   Row(
// //                                                     children: [
// //                                                       Expanded(
// //                                                         child: Text(
// //                                                           plan.name ?? 'Plan',
// //                                                           style: TextStyle(
// //                                                             fontSize: 20,
// //                                                             fontWeight:
// //                                                                 FontWeight.bold,
// //                                                             color: index == 0
// //                                                                 ? const Color(
// //                                                                     0xFF6366F1,
// //                                                                   )
// //                                                                 : Colors
// //                                                                       .black87,
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                       // if (index == 0)
// //                                                       //   Container(
// //                                                       //     padding:
// //                                                       //         const EdgeInsets.symmetric(
// //                                                       //           horizontal: 8,
// //                                                       //           vertical: 4,
// //                                                       //         ),
// //                                                       //     decoration: BoxDecoration(
// //                                                       //       color: const Color(
// //                                                       //         0xFF6366F1,
// //                                                       //       ),
// //                                                       //       borderRadius:
// //                                                       //           BorderRadius.circular(
// //                                                       //             12,
// //                                                       //           ),
// //                                                       //     ),
// //                                                       //     child: const Text(
// //                                                       //       'POPULAR',
// //                                                       //       style: TextStyle(
// //                                                       //         color:
// //                                                       //             Colors.white,
// //                                                       //         fontSize: 9,
// //                                                       //         fontWeight:
// //                                                       //             FontWeight
// //                                                       //                 .w600,
// //                                                       //       ),
// //                                                       //     ),
// //                                                       //   ),
// //                                                     ],
// //                                                   ),
// //                                                   const SizedBox(height: 8),
// //                                                   // Price
// //                                                   Text(
// //                                                     '${plan.offerPrice?.toStringAsFixed(2) ?? '0.00'}/${(plan.duration ?? 'month') == 'month' ? 'mo' : 'yr'}',
// //                                                     style: TextStyle(
// //                                                       fontSize: 24,
// //                                                       fontWeight:
// //                                                           FontWeight.bold,
// //                                                       color: index == 0
// //                                                           ? const Color(
// //                                                               0xFF6366F1,
// //                                                             )
// //                                                           : Colors.black87,
// //                                                     ),
// //                                                   ),

// //                                                   const SizedBox(height: 8),
// //                                                   // Plan description
// //                                                   if (plan.features != null &&
// //                                                       plan.features!.isNotEmpty)
// //                                                     // Text(
// //                                                     //   plan.features.toString(),
// //                                                     //   style: TextStyle(
// //                                                     //     fontSize: 11,
// //                                                     //     color: Colors
// //                                                     //         .grey
// //                                                     //         .shade600,
// //                                                     //     height: 1.3,
// //                                                     //   ),
// //                                                     //   maxLines: 2,
// //                                                     //   overflow:
// //                                                     //       TextOverflow.ellipsis,
// //                                                     // ),
// //                                                     const SizedBox(height: 12),
// //                                                   // Features list
// //                                                   Flexible(
// //                                                     child: ListView(
// //                                                       shrinkWrap: true,
// //                                                       physics:
// //                                                           const NeverScrollableScrollPhysics(),
// //                                                       children:
// //                                                           plan.features
// //                                                               ?.take(4)
// //                                                               .map(
// //                                                                 (
// //                                                                   feature,
// //                                                                 ) => Padding(
// //                                                                   padding:
// //                                                                       const EdgeInsets.only(
// //                                                                         bottom:
// //                                                                             4,
// //                                                                       ),
// //                                                                   child: Row(
// //                                                                     children: [
// //                                                                       Icon(
// //                                                                         Icons
// //                                                                             .check_circle,
// //                                                                         size:
// //                                                                             14,
// //                                                                         color:
// //                                                                             index ==
// //                                                                                 0
// //                                                                             ? const Color(
// //                                                                                 0xFF6366F1,
// //                                                                               )
// //                                                                             : Colors.green,
// //                                                                       ),
// //                                                                       const SizedBox(
// //                                                                         width:
// //                                                                             6,
// //                                                                       ),
// //                                                                       Expanded(
// //                                                                         child: Text(
// //                                                                           feature,
// //                                                                           style: TextStyle(
// //                                                                             fontSize:
// //                                                                                 10,
// //                                                                             color:
// //                                                                                 Colors.grey.shade700,
// //                                                                           ),
// //                                                                           maxLines:
// //                                                                               1,
// //                                                                           overflow:
// //                                                                               TextOverflow.ellipsis,
// //                                                                         ),
// //                                                                       ),
// //                                                                     ],
// //                                                                   ),
// //                                                                 ),
// //                                                               )
// //                                                               .toList() ??
// //                                                           [],
// //                                                     ),
// //                                                   ),
// //                                                   if ((plan.features?.length ??
// //                                                           0) >
// //                                                       4)
// //                                                     Padding(
// //                                                       padding:
// //                                                           const EdgeInsets.only(
// //                                                             top: 4,
// //                                                           ),
// //                                                       child: Text(
// //                                                         '+ ${(plan.features?.length ?? 0) - 4} more features',
// //                                                         style: TextStyle(
// //                                                           fontSize: 9,
// //                                                           color: Colors
// //                                                               .grey
// //                                                               .shade600,
// //                                                         ),
// //                                                       ),
// //                                                     ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                     );
// //                                   }).toList(),
// //                                 );
// //                               },
// //                             );
// //                           }

// //                           return Center(
// //                             child: Column(
// //                               mainAxisSize: MainAxisSize.min,
// //                               children: [
// //                                 Container(
// //                                   padding: const EdgeInsets.all(16),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.grey.shade100,
// //                                     shape: BoxShape.circle,
// //                                   ),
// //                                   child: Icon(
// //                                     Icons.shopping_bag_outlined,
// //                                     size: 48,
// //                                     color: Colors.grey.shade400,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 16),
// //                                 Text(
// //                                   'No Plans Available',
// //                                   style: TextStyle(
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Colors.grey.shade700,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 8),
// //                                 Text(
// //                                   'Check back soon for premium options',
// //                                   style: TextStyle(
// //                                     color: Colors.grey.shade500,
// //                                     fontSize: 12,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ),

// //                   // Footer with subscription info
// //                   Container(
// //                     margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
// //                     padding: const EdgeInsets.all(16),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.15),
// //                       borderRadius: BorderRadius.circular(16),
// //                       border: Border.all(
// //                         color: Colors.white.withOpacity(0.3),
// //                         width: 1,
// //                       ),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         Row(
// //                           children: [
// //                             Icon(
// //                               Icons.autorenew_rounded,
// //                               size: 14,
// //                               color: Colors.white.withOpacity(0.9),
// //                             ),
// //                             const SizedBox(width: 6),
// //                             Expanded(
// //                               child: Text(
// //                                 'Auto-renews unless cancelled 24h before period ends',
// //                                 style: TextStyle(
// //                                   fontSize: 13,
// //                                   color: Colors.white.withOpacity(0.95),
// //                                   height: 1.3,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 10),
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             GestureDetector(
// //                               onTap: () => _launchURL(
// //                                 'https://editezy.onrender.com/privacy-and-policy',
// //                               ),
// //                               child: Text(
// //                                 'Privacy Policy',
// //                                 style: TextStyle(
// //                                   fontSize: 11,
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.w600,
// //                                   decoration: TextDecoration.underline,
// //                                   decorationColor: Colors.white,
// //                                 ),
// //                               ),
// //                             ),
// //                             Padding(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 8,
// //                               ),
// //                               child: Text(
// //                                 '•',
// //                                 style: TextStyle(
// //                                   color: Colors.white.withOpacity(0.7),
// //                                   fontSize: 11,
// //                                 ),
// //                               ),
// //                             ),
// //                             GestureDetector(
// //                               onTap: () => _launchURL(
// //                                 'https://editezy.onrender.com/terms-and-conditions',
// //                               ),
// //                               child: Text(
// //                                 'Terms of Use',
// //                                 style: TextStyle(
// //                                   fontSize: 11,
// //                                   color: Colors.white,
// //                                   fontWeight: FontWeight.w600,
// //                                   decoration: TextDecoration.underline,
// //                                   decorationColor: Colors.white,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // Helper method to launch URLs
// //   void _launchURL(String url) async {
// //     final Uri uri = Uri.parse(url);
// //     if (await canLaunchUrl(uri)) {
// //       await launchUrl(uri, mode: LaunchMode.externalApplication);
// //     }
// //   }

// //   void showReferAndEarnModal(BuildContext context) {
// //     String? userId;
// //     String? userReferralCode;
// //     bool isLoading = true;
// //     String? errorMessage;

// //     showGeneralDialog(
// //       context: context,
// //       barrierDismissible: true,
// //       barrierLabel: 'Refer and Earn',
// //       barrierColor: Colors.black.withOpacity(0.5),
// //       transitionDuration: const Duration(milliseconds: 300),
// //       pageBuilder: (context, animation, secondaryAnimation) {
// //         return const SizedBox.shrink();
// //       },
// //       transitionBuilder: (context, animation, secondaryAnimation, child) {
// //         return FadeTransition(
// //           opacity: animation,
// //           child: ScaleTransition(
// //             scale: Tween<double>(begin: 0.95, end: 1.0).animate(
// //               CurvedAnimation(parent: animation, curve: Curves.easeOut),
// //             ),
// //             child: Center(
// //               child: Material(
// //                 color: Colors.transparent,
// //                 child: StatefulBuilder(
// //                   builder: (context, setState) {
// //                     Future<void> loadUserDataAndFetchReferralCode() async {
// //                       try {
// //                         setState(() {
// //                           isLoading = true;
// //                           errorMessage = null;
// //                         });

// //                         final userData = await AuthPreferences.getUserData();
// //                         if (userData != null && userData.user != null) {
// //                           userId = userData.user.id;

// //                           if (userId != null) {
// //                             final response = await http.get(
// //                               Uri.parse(
// //                                 'http://31.97.206.144:4061/api/users/refferalcode/$userId',
// //                               ),
// //                               headers: {'Content-Type': 'application/json'},
// //                             );

// //                             if (response.statusCode == 200) {
// //                               final data = json.decode(response.body);
// //                               String? fetchedCode =
// //                                   data['referralCode'] ??
// //                                   data['refferalCode'] ??
// //                                   data['code'] ??
// //                                   data['referral_code'] ??
// //                                   data['refferal_code'];

// //                               setState(() {
// //                                 isLoading = false;
// //                                 userReferralCode = fetchedCode;
// //                                 errorMessage = fetchedCode == null
// //                                     ? 'No referral code found'
// //                                     : null;
// //                               });
// //                             } else {
// //                               setState(() {
// //                                 userReferralCode = null;
// //                                 errorMessage = 'Failed to load referral code';
// //                                 isLoading = false;
// //                               });
// //                             }
// //                           } else {
// //                             setState(() {
// //                               userReferralCode = null;
// //                               errorMessage = 'User ID is null';
// //                               isLoading = false;
// //                             });
// //                           }
// //                         } else {
// //                           setState(() {
// //                             userReferralCode = null;
// //                             errorMessage = 'User data not found';
// //                             isLoading = false;
// //                           });
// //                         }
// //                       } catch (e) {
// //                         setState(() {
// //                           userReferralCode = null;
// //                           errorMessage = 'Network error: ${e.toString()}';
// //                           isLoading = false;
// //                         });
// //                       }
// //                     }

// //                     void shareReferralCode() {
// //                       if (userReferralCode != null &&
// //                           userReferralCode!.isNotEmpty) {
// //                         final shareText =
// //                             '''
// // 🎉 Join me on EditEzy - Amazing Photo & Poster Editor!

// // Use my referral code: $userReferralCode

// // You'll get exclusive benefits, and I'll earn ₹200 when you upgrade your account!

// // Download EditEzy now:
// // https://play.google.com/store/apps/details?id=com.posternova.posternova

// // Don't miss out on this opportunity! 🚀
// // ''';
// //                         Share.share(
// //                           shareText,
// //                           subject: 'Join EditEzy using my referral code',
// //                         );
// //                       }
// //                     }

// //                     WidgetsBinding.instance.addPostFrameCallback((_) {
// //                       if (isLoading &&
// //                           userReferralCode == null &&
// //                           errorMessage == null) {
// //                         loadUserDataAndFetchReferralCode();
// //                       }
// //                     });

// //                     return Scaffold(
// //                       backgroundColor: Colors.transparent,
// //                       body: Center(
// //                         child: Container(
// //                           margin: const EdgeInsets.symmetric(horizontal: 24),
// //                           constraints: BoxConstraints(
// //                             maxHeight: MediaQuery.of(context).size.height * 0.8,
// //                             maxWidth: 500,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(16),
// //                             boxShadow: [
// //                               BoxShadow(
// //                                 color: Colors.black.withOpacity(0.1),
// //                                 blurRadius: 20,
// //                                 offset: const Offset(0, 4),
// //                               ),
// //                             ],
// //                           ),
// //                           child: ClipRRect(
// //                             borderRadius: BorderRadius.circular(16),
// //                             child: Column(
// //                               mainAxisSize: MainAxisSize.min,
// //                               children: [
// //                                 // Header
// //                                 Container(
// //                                   padding: const EdgeInsets.symmetric(
// //                                     horizontal: 20,
// //                                     vertical: 16,
// //                                   ),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.grey[50],
// //                                     border: Border(
// //                                       bottom: BorderSide(
// //                                         color: Colors.grey[200]!,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                   child: Row(
// //                                     children: [
// //                                       Container(
// //                                         padding: const EdgeInsets.all(8),
// //                                         decoration: BoxDecoration(
// //                                           color: const Color(
// //                                             0xFF4F46E5,
// //                                           ).withOpacity(0.1),
// //                                           borderRadius: BorderRadius.circular(
// //                                             8,
// //                                           ),
// //                                         ),
// //                                         child: const Icon(
// //                                           Icons.people_outline,
// //                                           color: Color(0xFF4F46E5),
// //                                           size: 24,
// //                                         ),
// //                                       ),
// //                                       const SizedBox(width: 12),
// //                                       const Expanded(
// //                                         child: AppText(
// //                                           'refer_earn',
// //                                           style: TextStyle(
// //                                             fontSize: 20,
// //                                             fontWeight: FontWeight.w600,
// //                                             color: Color(0xFF111827),
// //                                           ),
// //                                         ),
// //                                       ),
// //                                       IconButton(
// //                                         onPressed: () => Navigator.pop(context),
// //                                         icon: const Icon(Icons.close, size: 24),
// //                                         color: Colors.grey[600],
// //                                         padding: EdgeInsets.zero,
// //                                         constraints: const BoxConstraints(),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),

// //                                 // Content
// //                                 Flexible(
// //                                   child: SingleChildScrollView(
// //                                     padding: const EdgeInsets.all(24),
// //                                     child: Column(
// //                                       crossAxisAlignment:
// //                                           CrossAxisAlignment.start,
// //                                       children: [
// //                                         // Info Card
// //                                         Container(
// //                                           width: double.infinity,
// //                                           padding: const EdgeInsets.all(16),
// //                                           decoration: BoxDecoration(
// //                                             color: const Color(0xFFF0F9FF),
// //                                             borderRadius: BorderRadius.circular(
// //                                               12,
// //                                             ),
// //                                             border: Border.all(
// //                                               color: const Color(0xFFBAE6FD),
// //                                             ),
// //                                           ),
// //                                           child: Row(
// //                                             children: [
// //                                               Container(
// //                                                 padding: const EdgeInsets.all(
// //                                                   8,
// //                                                 ),
// //                                                 decoration: BoxDecoration(
// //                                                   color: const Color(
// //                                                     0xFF0EA5E9,
// //                                                   ),
// //                                                   borderRadius:
// //                                                       BorderRadius.circular(8),
// //                                                 ),
// //                                                 child: const Icon(
// //                                                   Icons.info_outline,
// //                                                   color: Colors.white,
// //                                                   size: 20,
// //                                                 ),
// //                                               ),
// //                                               const SizedBox(width: 12),
// //                                               const Expanded(
// //                                                 child: AppText(
// //                                                   'share_referral_earn',
// //                                                   style: TextStyle(
// //                                                     fontSize: 14,
// //                                                     color: Color(0xFF0C4A6E),
// //                                                     height: 1.4,
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),

// //                                         const SizedBox(height: 24),

// //                                         // Referral Code Section
// //                                         const AppText(
// //                                           'your_referral_code',
// //                                           style: TextStyle(
// //                                             fontSize: 14,
// //                                             fontWeight: FontWeight.w600,
// //                                             color: Color(0xFF374151),
// //                                           ),
// //                                         ),
// //                                         const SizedBox(height: 12),

// //                                         AnimatedSwitcher(
// //                                           duration: const Duration(
// //                                             milliseconds: 300,
// //                                           ),
// //                                           child: isLoading
// //                                               ? Container(
// //                                                   key: const ValueKey(
// //                                                     'loading',
// //                                                   ),
// //                                                   padding: const EdgeInsets.all(
// //                                                     20,
// //                                                   ),
// //                                                   decoration: BoxDecoration(
// //                                                     color: Colors.grey[50],
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                           12,
// //                                                         ),
// //                                                     border: Border.all(
// //                                                       color: Colors.grey[200]!,
// //                                                     ),
// //                                                   ),
// //                                                   child: const Row(
// //                                                     mainAxisAlignment:
// //                                                         MainAxisAlignment
// //                                                             .center,
// //                                                     children: [
// //                                                       SizedBox(
// //                                                         width: 20,
// //                                                         height: 20,
// //                                                         child:
// //                                                             CircularProgressIndicator(
// //                                                               strokeWidth: 2,
// //                                                               color: Color(
// //                                                                 0xFF4F46E5,
// //                                                               ),
// //                                                             ),
// //                                                       ),
// //                                                       SizedBox(width: 12),
// //                                                       Text(
// //                                                         'Loading...',
// //                                                         style: TextStyle(
// //                                                           fontSize: 14,
// //                                                           color: Color(
// //                                                             0xFF6B7280,
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 )
// //                                               : (errorMessage != null)
// //                                               ? Container(
// //                                                   key: const ValueKey('error'),
// //                                                   padding: const EdgeInsets.all(
// //                                                     16,
// //                                                   ),
// //                                                   decoration: BoxDecoration(
// //                                                     color: const Color(
// //                                                       0xFFFEF2F2,
// //                                                     ),
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                           12,
// //                                                         ),
// //                                                     border: Border.all(
// //                                                       color: const Color(
// //                                                         0xFFFECACA,
// //                                                       ),
// //                                                     ),
// //                                                   ),
// //                                                   child: Column(
// //                                                     children: [
// //                                                       Row(
// //                                                         children: [
// //                                                           const Icon(
// //                                                             Icons.error_outline,
// //                                                             color: Color(
// //                                                               0xFFEF4444,
// //                                                             ),
// //                                                             size: 20,
// //                                                           ),
// //                                                           const SizedBox(
// //                                                             width: 8,
// //                                                           ),
// //                                                           Expanded(
// //                                                             child: Text(
// //                                                               errorMessage!,
// //                                                               style:
// //                                                                   const TextStyle(
// //                                                                     fontSize:
// //                                                                         14,
// //                                                                     color: Color(
// //                                                                       0xFF991B1B,
// //                                                                     ),
// //                                                                   ),
// //                                                             ),
// //                                                           ),
// //                                                         ],
// //                                                       ),
// //                                                       const SizedBox(
// //                                                         height: 12,
// //                                                       ),
// //                                                       SizedBox(
// //                                                         width: double.infinity,
// //                                                         child: OutlinedButton.icon(
// //                                                           onPressed:
// //                                                               loadUserDataAndFetchReferralCode,
// //                                                           style: OutlinedButton.styleFrom(
// //                                                             foregroundColor:
// //                                                                 const Color(
// //                                                                   0xFFEF4444,
// //                                                                 ),
// //                                                             side:
// //                                                                 const BorderSide(
// //                                                                   color: Color(
// //                                                                     0xFFEF4444,
// //                                                                   ),
// //                                                                 ),
// //                                                             padding:
// //                                                                 const EdgeInsets.symmetric(
// //                                                                   vertical: 12,
// //                                                                 ),
// //                                                             shape: RoundedRectangleBorder(
// //                                                               borderRadius:
// //                                                                   BorderRadius.circular(
// //                                                                     8,
// //                                                                   ),
// //                                                             ),
// //                                                           ),
// //                                                           icon: const Icon(
// //                                                             Icons.refresh,
// //                                                             size: 18,
// //                                                           ),
// //                                                           label: const Text(
// //                                                             'Retry',
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 )
// //                                               : Container(
// //                                                   key: const ValueKey('code'),
// //                                                   padding: const EdgeInsets.all(
// //                                                     16,
// //                                                   ),
// //                                                   decoration: BoxDecoration(
// //                                                     color: Colors.grey[50],
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                           12,
// //                                                         ),
// //                                                     border: Border.all(
// //                                                       color: Colors.grey[300]!,
// //                                                     ),
// //                                                   ),
// //                                                   child: Row(
// //                                                     children: [
// //                                                       Expanded(
// //                                                         child: Column(
// //                                                           crossAxisAlignment:
// //                                                               CrossAxisAlignment
// //                                                                   .start,
// //                                                           children: [
// //                                                             Text(
// //                                                               userReferralCode ??
// //                                                                   '--',
// //                                                               style: const TextStyle(
// //                                                                 fontSize: 24,
// //                                                                 fontWeight:
// //                                                                     FontWeight
// //                                                                         .w700,
// //                                                                 letterSpacing:
// //                                                                     2,
// //                                                                 color: Color(
// //                                                                   0xFF4F46E5,
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                             const SizedBox(
// //                                                               height: 4,
// //                                                             ),
// //                                                             const Text(
// //                                                               'Tap to copy',
// //                                                               style: TextStyle(
// //                                                                 fontSize: 12,
// //                                                                 color: Color(
// //                                                                   0xFF6B7280,
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                           ],
// //                                                         ),
// //                                                       ),
// //                                                       IconButton(
// //                                                         onPressed: () {
// //                                                           if (userReferralCode !=
// //                                                                   null &&
// //                                                               userReferralCode!
// //                                                                   .isNotEmpty) {
// //                                                             Clipboard.setData(
// //                                                               ClipboardData(
// //                                                                 text:
// //                                                                     userReferralCode!,
// //                                                               ),
// //                                                             );
// //                                                             ScaffoldMessenger.of(
// //                                                               context,
// //                                                             ).showSnackBar(
// //                                                               const SnackBar(
// //                                                                 content: Text(
// //                                                                   'Referral code copied to clipboard',
// //                                                                 ),
// //                                                                 behavior:
// //                                                                     SnackBarBehavior
// //                                                                         .floating,
// //                                                                 backgroundColor:
// //                                                                     Color(
// //                                                                       0xFF10B981,
// //                                                                     ),
// //                                                                 duration:
// //                                                                     Duration(
// //                                                                       seconds:
// //                                                                           2,
// //                                                                     ),
// //                                                               ),
// //                                                             );
// //                                                           }
// //                                                         },
// //                                                         icon: const Icon(
// //                                                           Icons.copy,
// //                                                           size: 20,
// //                                                         ),
// //                                                         color: const Color(
// //                                                           0xFF4F46E5,
// //                                                         ),
// //                                                         style:
// //                                                             IconButton.styleFrom(
// //                                                               backgroundColor:
// //                                                                   const Color(
// //                                                                     0xFF4F46E5,
// //                                                                   ).withOpacity(
// //                                                                     0.1,
// //                                                                   ),
// //                                                             ),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 ),
// //                                         ),

// //                                         const SizedBox(height: 24),

// //                                         // How It Works
// //                                         const AppText(
// //                                           'how_it_works',
// //                                           style: TextStyle(
// //                                             fontSize: 14,
// //                                             fontWeight: FontWeight.w600,
// //                                             color: Color(0xFF374151),
// //                                           ),
// //                                         ),
// //                                         const SizedBox(height: 12),

// //                                         _buildSteps(
// //                                           number: '1',
// //                                           title: 'share_your_code',
// //                                           description:
// //                                               'send_referral_any_platform',
// //                                         ),
// //                                         const SizedBox(height: 12),
// //                                         _buildSteps(
// //                                           number: '2',
// //                                           title: 'friend_signs_up',
// //                                           description:
// //                                               'enter_code_during_signup',
// //                                         ),
// //                                         const SizedBox(height: 12),
// //                                         _buildSteps(
// //                                           number: '3',
// //                                           title: 'earn_rewards',
// //                                           description: 'get_200_on_upgrade',
// //                                         ),

// //                                         const SizedBox(height: 24),

// //                                         // Action Buttons
// //                                         Row(
// //                                           children: [
// //                                             Expanded(
// //                                               child: ElevatedButton.icon(
// //                                                 onPressed: () {
// //                                                   if (userReferralCode !=
// //                                                           null &&
// //                                                       userReferralCode!
// //                                                           .isNotEmpty) {
// //                                                     Clipboard.setData(
// //                                                       ClipboardData(
// //                                                         text: userReferralCode!,
// //                                                       ),
// //                                                     );
// //                                                     ScaffoldMessenger.of(
// //                                                       context,
// //                                                     ).showSnackBar(
// //                                                       const SnackBar(
// //                                                         content: Text(
// //                                                           'Referral code copied!',
// //                                                         ),
// //                                                         behavior:
// //                                                             SnackBarBehavior
// //                                                                 .floating,
// //                                                         backgroundColor: Color(
// //                                                           0xFF10B981,
// //                                                         ),
// //                                                         duration: Duration(
// //                                                           seconds: 2,
// //                                                         ),
// //                                                       ),
// //                                                     );
// //                                                   } else {
// //                                                     loadUserDataAndFetchReferralCode();
// //                                                   }
// //                                                 },
// //                                                 icon: const Icon(
// //                                                   Icons.copy,
// //                                                   size: 20,
// //                                                 ),
// //                                                 label: const Text('Copy Code'),
// //                                                 style: ElevatedButton.styleFrom(
// //                                                   backgroundColor: const Color(
// //                                                     0xFF4F46E5,
// //                                                   ),
// //                                                   foregroundColor: Colors.white,
// //                                                   padding:
// //                                                       const EdgeInsets.symmetric(
// //                                                         vertical: 14,
// //                                                       ),
// //                                                   shape: RoundedRectangleBorder(
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                           10,
// //                                                         ),
// //                                                   ),
// //                                                   elevation: 0,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                             const SizedBox(width: 12),
// //                                             Expanded(
// //                                               child: ElevatedButton.icon(
// //                                                 onPressed:
// //                                                     (userReferralCode != null &&
// //                                                         userReferralCode!
// //                                                             .isNotEmpty)
// //                                                     ? shareReferralCode
// //                                                     : null,
// //                                                 icon: const Icon(
// //                                                   Icons.share,
// //                                                   size: 20,
// //                                                 ),
// //                                                 label: const Text('Share'),
// //                                                 style: ElevatedButton.styleFrom(
// //                                                   backgroundColor: const Color(
// //                                                     0xFF10B981,
// //                                                   ),
// //                                                   foregroundColor: Colors.white,
// //                                                   disabledBackgroundColor:
// //                                                       Colors.grey[300],
// //                                                   disabledForegroundColor:
// //                                                       Colors.grey[500],
// //                                                   padding:
// //                                                       const EdgeInsets.symmetric(
// //                                                         vertical: 14,
// //                                                       ),
// //                                                   shape: RoundedRectangleBorder(
// //                                                     borderRadius:
// //                                                         BorderRadius.circular(
// //                                                           10,
// //                                                         ),
// //                                                   ),
// //                                                   elevation: 0,
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildSteps({
// //     required String number,
// //     required String title,
// //     required String description,
// //   }) {
// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Container(
// //           width: 32,
// //           height: 32,
// //           decoration: BoxDecoration(
// //             color: const Color(0xFF4F46E5).withOpacity(0.1),
// //             shape: BoxShape.circle,
// //           ),
// //           child: Center(
// //             child: Text(
// //               number,
// //               style: const TextStyle(
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.w600,
// //                 color: Color(0xFF4F46E5),
// //               ),
// //             ),
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               AppText(
// //                 title,
// //                 style: const TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFF111827),
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               AppText(
// //                 description,
// //                 style: const TextStyle(
// //                   fontSize: 13,
// //                   color: Color(0xFF6B7280),
// //                   height: 1.4,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildStepss({
// //     required String number,
// //     required String title,
// //     required String description,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: Colors.grey[200]!),
// //       ),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 36,
// //             height: 36,
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF4F46E5),
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Center(
// //               child: Text(
// //                 number,
// //                 style: const TextStyle(
// //                   fontSize: 16,
// //                   fontWeight: FontWeight.w700,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   title,
// //                   style: const TextStyle(
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w600,
// //                     color: Color(0xFF111827),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Text(
// //                   description,
// //                   style: const TextStyle(
// //                     fontSize: 12,
// //                     color: Color(0xFF6B7280),
// //                     height: 1.3,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFeatureRow(IconData icon, String text) {
// //     return Row(
// //       children: [
// //         Icon(icon, color: const Color(0xFF10B981), size: 20),
// //         const SizedBox(width: 12),
// //         Text(
// //           text,
// //           style: const TextStyle(
// //             fontSize: 14,
// //             color: Color(0xFF374151),
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildCompactFeature(String text) {
// //     return Row(
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(2),
// //           decoration: BoxDecoration(
// //             color: const Color(0xFF10B981).withOpacity(0.1),
// //             shape: BoxShape.circle,
// //           ),
// //           child: const Icon(
// //             Icons.check_circle_rounded,
// //             color: Color(0xFF10B981),
// //             size: 20,
// //           ),
// //         ),
// //         const SizedBox(width: 10),
// //         Text(
// //           text,
// //           style: const TextStyle(
// //             fontSize: 14,
// //             fontWeight: FontWeight.w500,
// //             color: Color(0xFF1F2937),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildFeatureItem({
// //     required IconData icon,
// //     required String title,
// //     required String description,
// //   }) {
// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Container(
// //           padding: const EdgeInsets.all(2),
// //           decoration: BoxDecoration(
// //             color: const Color(0xFF10B981).withOpacity(0.1),
// //             shape: BoxShape.circle,
// //           ),
// //           child: const Icon(
// //             Icons.check_circle_rounded,
// //             color: Color(0xFF10B981),
// //             size: 24,
// //           ),
// //         ),
// //         const SizedBox(width: 14),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   fontSize: 15,
// //                   fontWeight: FontWeight.w600,
// //                   color: Color(0xFF1F2937),
// //                   height: 1.3,
// //                 ),
// //               ),
// //               const SizedBox(height: 2),
// //               Text(
// //                 description,
// //                 style: TextStyle(
// //                   fontSize: 13,
// //                   color: Colors.grey.shade600,
// //                   height: 1.3,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildStep(String number, String description) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 8.0),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Container(
// //             width: 20,
// //             height: 20,
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF3B82F6),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Center(
// //               child: Text(
// //                 number,
// //                 style: const TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 12,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Text(
// //               description,
// //               style: const TextStyle(
// //                 fontSize: 14,
// //                 color: Color(0xFF475569),
// //                 height: 1.3,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // helper widget used in the updated UI (kept in-file intentionally)

// //   Widget _buildHowItWorksStep(String number, String title, String description) {
// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Container(
// //           width: 24,
// //           height: 24,
// //           decoration: const BoxDecoration(
// //             color: Color(0xFF6366F1),
// //             shape: BoxShape.circle,
// //           ),
// //           child: Center(
// //             child: Text(
// //               number,
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ),
// //         const SizedBox(width: 12),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   fontWeight: FontWeight.w600,
// //                   fontSize: 14,
// //                   color: Color(0xFF111827),
// //                 ),
// //               ),
// //               const SizedBox(height: 2),
// //               Text(
// //                 description,
// //                 style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget buildCategoryWisePosters() {
// //     return Consumer<CanvaPosterProvider>(
// //       builder: (context, provider, child) {
// //         if (provider.isLoading) {
// //           return const Center(
// //             child: CircularProgressIndicator(color: Color(0xFF6366F1)),
// //           );
// //         }

// //         if (provider.error != null) {
// //           return Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const Icon(
// //                   Icons.error_outline,
// //                   size: 40,
// //                   color: Color(0xFFEF4444),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Error: ${provider.error}',
// //                   style: const TextStyle(color: Color(0xFFEF4444)),
// //                   textAlign: TextAlign.center,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 ElevatedButton(
// //                   onPressed: () => provider.fetchPosters(),
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: const Color(0xFF6366F1),
// //                     foregroundColor: Colors.white,
// //                   ),
// //                   child: const Text('Retry'),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }

// //         if (provider.posters.isEmpty) {
// //           return const Center(
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   Icons.image_not_supported,
// //                   size: 40,
// //                   color: Color(0xFF9CA3AF),
// //                 ),
// //                 SizedBox(height: 8),
// //                 Text(
// //                   'No posters available',
// //                   style: TextStyle(color: Color(0xFF6B7280)),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }

// //         Map<String, List<CanvasPosterModel>> categorizedPosters = {};
// //         for (var poster in provider.posters) {
// //           String category = poster.categoryName.isEmpty
// //               ? 'Other'
// //               : poster.categoryName;
// //           if (!categorizedPosters.containsKey(category)) {
// //             categorizedPosters[category] = [];
// //           }
// //           categorizedPosters[category]!.add(poster);
// //         }

// //         return SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: categorizedPosters.entries.map((entry) {
// //               String categoryName = entry.key;
// //               List<CanvasPosterModel> categoryPosters = entry.value;

// //               return Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(16.0),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Text(
// //                           categoryName,
// //                           style: const TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 20,
// //                             color: Color(0xFF111827),
// //                           ),
// //                         ),
// //                         Text(
// //                           '${categoryPosters.length} items',
// //                           style: const TextStyle(
// //                             fontSize: 14,
// //                             color: Color(0xFF6B7280),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),

// //                   SizedBox(
// //                     height: 200,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       padding: const EdgeInsets.symmetric(horizontal: 16),
// //                       itemCount: categoryPosters.length,
// //                       itemBuilder: (context, index) {
// //                         final poster = categoryPosters[index];
// //                         return buildPosterCard(context, poster);
// //                       },
// //                     ),
// //                   ),

// //                   const SizedBox(height: 16),
// //                 ],
// //               );
// //             }).toList(),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget buildPosterCard(BuildContext context, CanvasPosterModel poster) {
// //     return Consumer<MyPlanProvider>(
// //       builder: (context, myPlanProvider, child) {
// //         return Container(
// //           width: 140,
// //           margin: const EdgeInsets.only(right: 12),
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(12),
// //             color: Colors.white,
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.08),
// //                 blurRadius: 4,
// //                 offset: const Offset(0, 2),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Expanded(
// //                 flex: 3,
// //                 child: ClipRRect(
// //                   borderRadius: const BorderRadius.vertical(
// //                     top: Radius.circular(12),
// //                   ),
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       if (myPlanProvider.isPurchase == true) {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) =>
// //                                 SamplePosterScreen(posterId: poster.id),
// //                           ),
// //                         );
// //                       } else {
// //                         _showPremiumDialog();
// //                       }
// //                       // Navigator.push(
// //                       //   context,
// //                       //   MaterialPageRoute(
// //                       //     builder: (context) =>
// //                       //         SamplePosterScreen(posterId: poster.id),
// //                       //   ),
// //                       // );
// //                     },
// //                     child: Image.network(
// //                       poster.images.isNotEmpty ? poster.images[0] : '',
// //                       width: double.infinity,
// //                       fit: BoxFit.cover,
// //                       errorBuilder: (context, error, stackTrace) {
// //                         return Container(
// //                           width: double.infinity,
// //                           color: const Color(0xFFF3F4F6),
// //                           child: const Icon(
// //                             Icons.image_not_supported,
// //                             color: Color(0xFF9CA3AF),
// //                             size: 30,
// //                           ),
// //                         );
// //                       },
// //                       loadingBuilder: (context, child, loadingProgress) {
// //                         if (loadingProgress == null) return child;
// //                         return Container(
// //                           width: double.infinity,
// //                           color: const Color(0xFFF3F4F6),
// //                           child: const Center(
// //                             child: CircularProgressIndicator(
// //                               strokeWidth: 2,
// //                               color: Color(0xFF6366F1),
// //                             ),
// //                           ),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ),

// //               Expanded(
// //                 flex: 1,
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text(
// //                         poster.name,
// //                         style: const TextStyle(
// //                           fontSize: 12,
// //                           fontWeight: FontWeight.w600,
// //                           color: Color(0xFF111827),
// //                         ),
// //                         maxLines: 1,
// //                         overflow: TextOverflow.ellipsis,
// //                       ),

// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           Text(
// //                             poster.price == 0 ? 'Free' : '₹${poster.price}',
// //                             style: TextStyle(
// //                               fontSize: 11,
// //                               color: poster.price == 0
// //                                   ? const Color(0xFF10B981)
// //                                   : const Color(0xFF6366F1),
// //                               fontWeight: FontWeight.w500,
// //                             ),
// //                           ),
// //                           if (!poster.inStock)
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 4,
// //                                 vertical: 1,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 color: const Color(0xFFFEF2F2),
// //                                 borderRadius: BorderRadius.circular(4),
// //                               ),
// //                               child: const Text(
// //                                 'Out',
// //                                 style: TextStyle(
// //                                   fontSize: 8,
// //                                   color: Color(0xFFEF4444),
// //                                   fontWeight: FontWeight.w500,
// //                                 ),
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }





import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/PosterProvider/poster_provider.dart';
import 'package:posternova/providers/festivals/date_time_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/providers/topics/hot_topic_provider.dart';
import 'package:posternova/views/PosterModule/poster_making_screen.dart'
    hide Overlay;
import 'package:posternova/views/ProfileScreen/profile_screen.dart';
import 'package:posternova/views/SecondPhase/poster_editor.dart';
import 'package:posternova/views/category/category_detail_screen.dart';
import 'package:posternova/views/category/search_category.dart';
import 'package:posternova/views/hot/hot_screen.dart';
import 'package:posternova/views/notifications/notification_screen.dart';
import 'package:posternova/views/stories/story_widget_screen.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:posternova/widgets/language_animation_widget.dart';
import 'package:posternova/services/language/restart_lan_service.dart';
import 'package:posternova/widgets/premium_widget.dart';
import 'package:posternova/widgets/voice_assistant_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // ─── User ──────────────────────────────────────────────────────────────────
  String? currentUserId;
  String? username;
  String? userImage;
  String? userId;

  // ─── Data ──────────────────────────────────────────────────────────────────
  Map<String, dynamic> birthdayData = {};
  Map<String, dynamic> anniversaryData = {};
  Map<String, List<dynamic>> weeklyPosters = {};
  List<dynamic> customers = [];
  bool isLoadingCustomers = false;
  bool _isLoading = false;
  bool _isBannerLoading = false;
  static bool _hasShownReferAndEarnModal = false;

  List<dynamic> festivaldata = [];
  List<dynamic> canvaposter = [];
  List<dynamic> bannerList = [];

  List<dynamic> birthdayAnniversaryPosters = [];
bool _isBirthdayLoading = false;

   // List<dynamic> birthdayPosters = [];
// List<dynamic> anniversaryPosters = [];
// bool _isBirthdayLoading = false;
  // ─── Controllers ───────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  late PageController _bannerPageController;
  int _currentBannerPage = 0;

  List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // ══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController();
    _loadUserData();
    _loadUserId();
    _initializeUser();
    Future.microtask(() async => await _initializeAllData());
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    _searchController.dispose();
    VoiceGreetingHelper.stop();
    super.dispose();
  }



  Future<void> _fetchBirthdayAnniversaryPosters() async {
  if (!mounted) return;
  setState(() => _isBirthdayLoading = true);
  try {
    final posterProvider = Provider.of<PosterProvider>(context, listen: false);
    // Filter from already-loaded posters for birthday/anniversary categories
    final allPosters = posterProvider.posters;
    final filtered = allPosters.where((poster) {
      final name = (poster.categoryName ?? '').toLowerCase();
      return name.contains('birthday') ||
          name.contains('anniversary') ||
          name.contains('wedding');
    }).toList();
 
    if (!mounted) return;
    setState(() {
      birthdayAnniversaryPosters = filtered;
      _isBirthdayLoading = false;
    });
  } catch (e) {
    if (!mounted) return;
    setState(() => _isBirthdayLoading = false);
    debugPrint('fetchBirthdayAnniversary: $e');
  }
}

  // ══════════════════════════════════════════════════════════════════════════
  // INIT HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> _initializeAllData() async {
    if (!mounted) return;
    await Future.wait([
      _loadUserId().catchError((e) => debugPrint('loadUserId: $e')),
      _fetchnewposters().catchError((e) => debugPrint('fetchPosters: $e')),
      _initializeProviders().catchError((e) => debugPrint('providers: $e')),
      _fetchWeeklyPosters().catchError((e) => debugPrint('weeklyPosters: $e')),
      _fetchBanners().catchError((e) => debugPrint('banners: $e')),
    ]);
    if (!mounted) return;
    _fetchFestivalPosters(context.read<DateTimeProvider>().selectedDate);
    _fetchReels();
    _fetchBirthdayAnniversaryPosters();
    _startBannerAutoScroll();
  }

  Future<void> _initializeProviders() async {
    if (!mounted) return;
    final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    final posterProvider = Provider.of<PosterProvider>(context, listen: false);
    storyProvider.fetchStories();
    await Future.wait([
      myPlanProvider.fetchMyPlan(userId.toString()).catchError((_) => null),
      posterProvider.fetchPosters().catchError((_) => null),
    ]);
    if (!mounted) return;
    _showInitialModals();
  }

  void _showInitialModals() {
    if (!mounted) return;
    final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
    if (!myPlanProvider.isPurchase) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SubscriptionPlansPage()),
          );
        }
      });
    }
    if (!_hasShownReferAndEarnModal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showReferAndEarnModal(context);
          _hasShownReferAndEarnModal = true;
        }
      });
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // DATA FETCHERS
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> _fetchBanners() async {
    setState(() => _isBannerLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/poster/getbanners'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          bannerList = data is List
              ? data
              : (data['banners'] ?? data['data'] ?? []);
          _isBannerLoading = false;
        });
      } else {
        setState(() => _isBannerLoading = false);
      }
    } catch (e) {
      setState(() => _isBannerLoading = false);
      debugPrint('fetchBanners: $e');
    }
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted || !_bannerPageController.hasClients || bannerList.isEmpty)
        return;
      final next = (_currentBannerPage + 1) % bannerList.length;
      _bannerPageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _startBannerAutoScroll();
    });
  }

  // Future<void> _fetchReels() async {
  //   if (userId == null) return;
  //   try {
  //     final reelProvider = Provider.of<ReelProvider>(context, listen: false);
  //     await reelProvider.fetchAllReels(userId!);
  //   } catch (e) {
  //     debugPrint('fetchReels: $e');
  //   }
  // }


  Future<void> _fetchReels() async {
  if (userId == null) return;
  try {
    final hotTopicProvider = Provider.of<HotTopicReelsProvider>(context, listen: false);
    await hotTopicProvider.loadHotTopicReels(userId!);
  } catch (e) {
    debugPrint('fetchReels: $e');
  }
}

  Future<void> _fetchWeeklyPosters() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://31.97.206.144:4061/api/poster/weeklyposters/$currentUserId',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          weeklyPosters = data.map(
            (k, v) => MapEntry(k, List<dynamic>.from(v)),
          );
        });
      }
    } catch (e) {
      debugPrint('fetchWeeklyPosters: $e');
    }
  }

  Future<void> _loadUserId() async {
    if (!mounted) return;
    try {
      final userData = await AuthPreferences.getUserData();
      if (!mounted) return;
      if (userData != null) {
        setState(() {
          username = userData.user.name;
          currentUserId = userData.user.id;
        });
        await _fetchWeeklyPosters();
        final response = await http.get(
          Uri.parse(
            'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
          ),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            birthdayData = Map<String, dynamic>.from(data);
            anniversaryData = Map<String, dynamic>.from(data);
          });
        }
      }
    } catch (e) {
      debugPrint('loadUserId: $e');
    }
  }

  Future<void> _loadUserData() async {
    final userData = await AuthPreferences.getUserData();
    if (userData != null && userData.user != null) {
      setState(() {
        userId = userData.user.id;
        username = userData.user.name;
        userImage = userData.user.profileImage;
      });
      // Fetch from API for latest profile image (same as FancyAppBar)
      _fetchUserProfile(userData.user.id);
      fetchCustomers();
    }
  }

  /// Fetches latest profile from API — mirrors FancyAppBar logic exactly
  Future<void> _fetchUserProfile(String? uid) async {
    if (uid == null) return;
    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/users/get-profile/$uid'),
      );
      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        setState(() {
          username = data['name'] ?? username ?? 'User';
          userImage = data['profileImage'] ?? userImage;
        });
        final lp = Provider.of<LanguageProvider>(context, listen: false);
        lp.setUserId(uid);
      }
    } catch (e) {
      debugPrint('fetchUserProfile: $e');
    }
  }

  Future<void> _initializeUser() async {
    final userData = await AuthPreferences.getUserData();
    if (userData != null && userData.user.id != null) {
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      storyProvider.setCurrentUser(
        userId: userData.user.id,
        userImage: userData.user.profileImage,
        username: userData.user.name ?? '',
      );
      storyProvider.fetchStories();
    }
  }

  Future<void> fetchCustomers() async {
    if (userId == null) return;
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

  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  Future<void> _fetchFestivalPosters(DateTime date) async {
    setState(() {
      _isLoading = true;
      festivaldata = [];
    });
    try {
      final response = await http.post(
        Uri.parse('http://31.97.206.144:4061/api/poster/festival'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'festivalDate': _formatDate(date)}),
      );
      if (response.statusCode == 200) {
        setState(() {
          festivaldata = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchnewposters() async {
    try {
      final cp = Provider.of<CanvaPosterProvider>(context, listen: false);
      await cp.fetchPosters();
      setState(() => canvaposter = cp.posters);
    } catch (e) {
      debugPrint('fetchnewposters: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  List<String> _getOrderedDaysFromToday() {
    final today = DateFormat('EEEE').format(DateTime.now());
    final todayIndex = weekDays.indexOf(today);
    if (todayIndex == -1) return weekDays;
    return [
      ...weekDays.sublist(todayIndex),
      ...weekDays.sublist(0, todayIndex),
    ];
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            _fetchFestivalPosters(
              context.read<DateTimeProvider>().selectedDate,
            ),
            _fetchnewposters(),
            _fetchWeeklyPosters(),
            _fetchBanners(),
            _fetchReels(),
          ]);
        },
        color: const Color(0xFFFFC107),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  _buildBannerSection(),
                  const SizedBox(height: 12),
                  _buildForYouSection(), // StoriesWidget
                  const SizedBox(height: 12),
                  _buildUpcomingFestivalsSection(),
                  _buildFestivalPostersSection(),
                  const SizedBox(height: 12),
                  _buildSectionHeader(
                    titleKey: 'weekly_templates',
                    subtitleKey: 'fresh_designs_everyday',
                  ),
                  _buildWeeklyPostersSection(),
                  const SizedBox(height: 12),

                  _buildHotTopicsSection(), // Reels from API
                  const SizedBox(height: 12),
                     _buildBirthdayAnniversarySection(),
                  const SizedBox(height: 12),
                  // _buildWeeklyPostersSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // APP BAR  — yellow, profile image from API, notification badge, language
  // ══════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF448AFF),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // ── Profile Avatar (fetched from API like FancyAppBar) ─────
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                    // final result = await Navigator.pushNamed(context, '/profile');
                    // if (result == true) _fetchUserProfile(userId);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          (userImage != null && userImage!.isNotEmpty)
                          ? NetworkImage(userImage!) as ImageProvider
                          : null,
                      child: (userImage == null || userImage!.isEmpty)
                          ? const Icon(
                              Icons.person,
                              color: Color(0xFFFFC107),
                              size: 22,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // ── Username + subtitle ────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppText(
                        'welcome_back',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                      Text(
                        username ?? 'User',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black87,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PosterEditorScreen (posterAsset: "assets/ugadi.png",),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 38,
                        minHeight: 38,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,  
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Notification badge ─────────────────────────────────────
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.black87,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(userId: userId.toString(),),
                          ),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 38,
                        minHeight: 38,
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,  
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Language (same dialog + transition as FancyAppBar) ─────
                GestureDetector(
                  onTap: () => _showLanguageSelector(context),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.language_rounded,
                      color: Colors.black87,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SEARCH BAR
  // ══════════════════════════════════════════════════════════════════════════

  // Widget _buildSearchBar() {
  //   return Container(
  //     color: Colors.white,
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //     child: Container(
  //       height: 44,
  //       decoration: BoxDecoration(
  //         color: const Color(0xFFF0F0F0),
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: const Color(0xFFE0E0E0)),
  //       ),
  //       child: Row(
  //         children: [
  //           const SizedBox(width: 10),
  //           const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
  //           const SizedBox(width: 8),
  //           Expanded(
  //             child: TextField(
  //               controller: _searchController,
  //               decoration: const InputDecoration(
  //                 hintText: 'Search Posts by Topics',
  //                 hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
  //                 border: InputBorder.none,
  //                 isDense: true,
  //                 contentPadding: EdgeInsets.symmetric(vertical: 10),
  //               ),
  //               style: const TextStyle(fontSize: 14),
  //             ),
  //           ),
  //           IconButton(
  //             icon: const Icon(Icons.mic_rounded, color: Colors.grey, size: 20),
  //             onPressed: () {},
  //             padding: EdgeInsets.zero,
  //             constraints: const BoxConstraints(),
  //           ),
  //           const SizedBox(width: 10),
  //         ],
  //       ),
  //     ),
  //   );
  // }




  Widget _buildSearchBar() {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SearchScreen(),
        ),
      );
    },
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
            const SizedBox(width: 8),

            Expanded(
              child: AbsorbPointer(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search Posts by Topics',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),

            const Icon(Icons.mic_rounded, color: Colors.grey, size: 20),
            const SizedBox(width: 10),
          ],
        ),
      ),
    ),
  );
}

  // ══════════════════════════════════════════════════════════════════════════
  // BANNER  — from /api/poster/getbanners
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildBannerSection() {
    if (_isBannerLoading) {
      return Container(
        height: 150,
        color: const Color(0xFFD32F2F),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      );
    }

    final items = bannerList.isNotEmpty ? bannerList : null;

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: items != null
              ? PageView.builder(
                  controller: _bannerPageController,
                  onPageChanged: (i) => setState(() => _currentBannerPage = i),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _buildBannerItem(items[i]),
                )
              : _buildFallbackBanner(),
        ),
        if (items != null && items.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(items.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentBannerPage == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: _currentBannerPage == i
                        ? const Color(0xFFFFC107)
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  // Widget _buildBannerItem(dynamic banner) {
  //   final imageUrl =
  //       (banner['images'] != null && (banner['images'] as List).isNotEmpty)
  //       ? banner['images'][0]
  //       : (banner['imageUrl'] ??
  //             banner['image'] ??
  //             banner['bannerImage'] ??
  //             '');

  //   return GestureDetector(
  //     onTap: () {
  //       if (banner['posterId'] != null) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (_) => SamplePosterScreen(posterId: banner['posterId']),
  //           ),
  //         );
  //       }
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Stack(
  //         fit: StackFit.expand,
  //         children: [
  //           imageUrl.isNotEmpty
  //               ? Image.network(
  //                   imageUrl,
  //                   fit: BoxFit.cover,
  //                   errorBuilder: (_, __, ___) => _buildBannerGradient(),
  //                   loadingBuilder: (_, child, progress) =>
  //                       progress == null ? child : _buildBannerGradient(),
  //                 )
  //               : _buildBannerGradient(),
        
  //           // Dim left side for text legibility
  //           Container(
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [
  //                   Colors.black.withOpacity(0.55),
  //                   Colors.transparent,
  //                   Colors.transparent,
  //                 ],
  //                 begin: Alignment.centerLeft,
  //                 end: Alignment.centerRight,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }



  Widget _buildBannerItem(dynamic banner) {
  final imageUrl =
      (banner['images'] != null && (banner['images'] as List).isNotEmpty)
      ? banner['images'][0]
      : (banner['imageUrl'] ??
          banner['image'] ??
          banner['bannerImage'] ??
          '');

  return GestureDetector(
    onTap: () {
      if (banner['posterId'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SamplePosterScreen(posterId: banner['posterId']),
          ),
        );
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Curve amount
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildBannerGradient(),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _buildBannerGradient(),
                  )
                : _buildBannerGradient(),

            // Dim left side for text legibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildBannerGradient() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color.fromARGB(255, 126, 211, 47), Color(0xFFB71C1C)],
      ),
    ),
  );

  Widget _buildFallbackBanner() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFFB71C1C)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wedding Count Down\nTemplates are ready!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EXPLORE NOW',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.black,
                          size: 13,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: Colors.white54,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FOR YOU  — StoriesWidget only
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildForYouSection() {
    return Container(
      color: const Color(0xFFFFFDE7),
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 1),
            child: Text(
              'Explore',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const StoriesWidget(),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // UPCOMING FESTIVALS  — date selector
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildUpcomingFestivalsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              'Upcoming Festivals',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Consumer<DateTimeProvider>(
            builder: (_, dtp, __) => _buildDateSelector(dtp),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDateSelector(DateTimeProvider dtp) {
    final today = DateTime.now();
    final dates = List.generate(7, (i) => today.add(Duration(days: i)));

    return SizedBox(
      height: 68,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected =
              date.day == dtp.selectedDate.day &&
              date.month == dtp.selectedDate.month;
          final day = date.day.toString();
          final suffix = _getDaySuffix(date.day);
          final month = DateFormat('MMM').format(date);

          return GestureDetector(
            onTap: () {
              dtp.setStartDate(date);
              _fetchFestivalPosters(date);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 58,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF448AFF) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF448AFF)
                      : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFFFFC107).withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: day,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.black : Colors.black87,
                          ),
                        ),
                        TextSpan(
                          text: suffix,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.black : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // FESTIVAL POSTERS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildFestivalPostersSection() {
    if (_isLoading) {
      return const SizedBox(
        height: 155,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFC107)),
        ),
      );
    }
    if (festivaldata.isEmpty) {
      return Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text(
            'No festivals for selected date',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      );
    }
    return SizedBox(
      height: 155,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        itemCount: festivaldata.length,
        itemBuilder: (_, i) => _buildSmallPosterCard(festivaldata[i], i),
      ),
    );
  }

  Widget _buildSmallPosterCard(dynamic poster, int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              SamplePosterScreen(posterId: poster['_id'] ?? poster['id']),
        ),
      ),
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.network(
                  poster['images'][0],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFF3F4F6)),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFF3F4F6),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFFFC107),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                poster['categoryName'] ?? 'Festival',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HOT TOPICS / REELS  — auto-playing video, tap → ReelsScreen
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildHotTopicsSection() {
    return Consumer<HotTopicReelsProvider>(
      builder: (context, hotTopicProvider, _) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hot Topics',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _goToReelsScreen(0),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Color(0xFFFFC107),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: hotTopicProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFFC107),
                        ),
                      )
                    : hotTopicProvider.reels.isEmpty
                    ? _buildReelPlaceholders()
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: hotTopicProvider.reels.length,
                        itemBuilder: (_, i) =>
                            _buildReelCard(hotTopicProvider.reels[i], i),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }





  Widget _buildBirthdayAnniversarySection() {
  // Use posters from PosterProvider filtered by category name
  return Consumer<PosterProvider>(
    builder: (context, posterProvider, _) {
      final allPosters = posterProvider.posters;
 
      // Separate birthday and anniversary lists
      final birthdayPosters = allPosters
          .where((p) =>
              (p.categoryName ?? '').toLowerCase().contains('birthday'))
          .toList();
 
      final anniversaryPosters = allPosters
          .where((p) =>
              (p.categoryName ?? '').toLowerCase().contains('anniversary') ||
              (p.categoryName ?? '').toLowerCase().contains('wedding'))
          .toList();
 
      // Don't render section if both lists are empty
      if (birthdayPosters.isEmpty && anniversaryPosters.isEmpty) {
        return const SizedBox.shrink();
      }
 
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Birthday sub-section ──────────────────────────────────
            if (birthdayPosters.isNotEmpty) ...[
              _buildCelebrationHeader(
                title: 'Birthday Posters',
                icon: Icons.cake_rounded,
                iconColor: const Color(0xFFE91E63),
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsScreen(category: 'birthday'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildCelebrationPosterList(birthdayPosters),
              const SizedBox(height: 14),
            ],
 
            // ── Anniversary sub-section ───────────────────────────────
            if (anniversaryPosters.isNotEmpty) ...[
              _buildCelebrationHeader(
                title: 'Anniversary Posters',
                icon: Icons.favorite_rounded,
                iconColor: const Color(0xFFE53935),
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsScreen(category: 'anniversary'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildCelebrationPosterList(anniversaryPosters),
            ],
          ],
        ),
      );
    },
  );
}
 
/// Shared header row for Birthday / Anniversary sections
Widget _buildCelebrationHeader({
  required String title,
  required IconData icon,
  required Color iconColor,
  required VoidCallback onViewAll,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        // GestureDetector(
        //   onTap: onViewAll,
        //   child: const Text(
        //     'View All',
        //     style: TextStyle(
        //       color: Color(0xFFFFC107),  
        //       fontSize: 13,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}
 
/// Horizontal poster list — same card size as weekly posters (110×140)
Widget _buildCelebrationPosterList(List<dynamic> posters) {
  return SizedBox(
    height: 140, // same as _buildWeeklyPosterCard
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: posters.length,
      itemBuilder: (context, index) {
        final poster = posters[index];
        return Consumer<MyPlanProvider>(
          builder: (context, myPlanProvider, _) {
            return GestureDetector(
              onTap: () {
                if (myPlanProvider.isPurchase) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SamplePosterScreen(
                        posterId: poster.id,
                      ),
                    ),
                  );
                } else {
                  _showPremiumDialog();
                }
              },
              child: Container(
                width: 110, // same as weekly poster card
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: poster.images != null &&
                                poster.images.isNotEmpty
                            ? Image.network(
                                poster.images[0],
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFFF3F4F6),
                                ),
                                loadingBuilder: (_, child, progress) {
                                  if (progress == null) return child;
                                  return Container(
                                    color: const Color(0xFFF3F4F6),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFFFC107),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(color: const Color(0xFFF3F4F6)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        poster.categoryName ?? 'Poster',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

  void _goToReelsScreen(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HotScreen(
          // initialIndex: initialIndex,
          // userId: userId ?? '',
        ),
      ),
    );
  }

  Widget _buildReelCard(dynamic reel, int index) {
    final isLiked = reel.isLiked ?? false;
    final likeCount = reel.likeCount ?? 0;
    final videoUrl = reel.videoUrl ?? '';

    return GestureDetector(
      onTap: () => _goToReelsScreen(index),
      child: Container(
        width: 105,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Auto-playing muted video
              _AutoPlayReelVideo(videoUrl: videoUrl),

              // Bottom gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.75),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Icon(
                          //   isLiked ? Icons.favorite : Icons.favorite_border,
                          //   color: isLiked ? Colors.red : Colors.white70,
                          //   size: 13,
                          // ),
                          const SizedBox(width: 3),
                          // Text(
                          //   '$likeCount',
                          //   style: const TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 10,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                        ],
                      ),
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              // Liked badge top-right
              // if (isLiked)
              //   Positioned(
              //     top: 6,
              //     right: 6,
              //     child: Container(
              //       padding: const EdgeInsets.all(3),
              //       decoration: const BoxDecoration(
              //         color: Colors.red,
              //         shape: BoxShape.circle,
              //       ),
              //       child: const Icon(
              //         Icons.favorite,
              //         color: Colors.white,
              //         size: 9,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReelPlaceholders() {
    const gradients = [
      [Color(0xFFFF7043), Color(0xFFFF5722)],
      [Color(0xFF42A5F5), Color(0xFF1976D2)],
      [Color(0xFF66BB6A), Color(0xFF388E3C)],
      [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
      [Color(0xFFFFCA28), Color(0xFFF57F17)],
      [Color(0xFF26C6DA), Color(0xFF00838F)],
    ];
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: 6,
      itemBuilder: (_, i) => Container(
        width: 105,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: gradients[i % gradients.length],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.play_circle_fill_rounded,
            color: Colors.white54,
            size: 34,
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // WEEKLY TEMPLATES
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildWeeklyPostersSection() {
    if (weeklyPosters.isEmpty) return const SizedBox();
    final orderedDays = _getOrderedDaysFromToday();
    final today = DateFormat('EEEE').format(DateTime.now());

    return Consumer<LanguageProvider>(
      builder: (context, lp, _) {
        final langCode = lp.locale.languageCode;
        return Column(
          children: orderedDays.map((day) {
            final posters = weeklyPosters[day] ?? [];
            if (posters.isEmpty) return const SizedBox.shrink();
            final isToday = day == today;
            final translatedDay = LocalizationService.translate(day, langCode);
            final todayPrefix = LocalizationService.translate(
              'today_prefix',
              langCode,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? const LinearGradient(
                              colors: [Color(0xFFFFC107), Color(0xFFFF8F00)],
                            )
                          : null,
                      color: isToday ? null : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isToday
                              ? Icons.today_rounded
                              : Icons.calendar_today_outlined,
                          size: 16,
                          color: isToday ? Colors.black : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isToday
                              ? '$todayPrefix - $translatedDay'
                              : translatedDay,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.black : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: posters.length,
                    itemBuilder: (_, i) =>
                        _buildWeeklyPosterCard(posters[i], i),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildWeeklyPosterCard(dynamic poster, int index) {
    return Consumer<MyPlanProvider>(
      builder: (context, myplanprovider, _) {
        return GestureDetector(
          onTap: () {
            if (myplanprovider.isPurchase) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SamplePosterScreen(
                    posterId: poster['_id'] ?? poster['id'],
                  ),
                ),
              );
            } else {
              _showPremiumDialog();
            }
          },
          child: Container(
            width: 110,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.network(
                      poster['images']?[0] ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFF3F4F6)),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFFC107),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    poster['categoryName'] ?? poster['name'] ?? 'Poster',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION HEADER
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildSectionHeader({
    required String titleKey,
    required String subtitleKey,
    bool showViewAll = false,
    VoidCallback? onViewAll,
  }) {
    return Consumer<LanguageProvider>(
      builder: (context, lp, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocalizationService.translate(
                      titleKey,
                      lp.locale.languageCode,
                    ),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    LocalizationService.translate(
                      subtitleKey,
                      lp.locale.languageCode,
                    ),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              if (showViewAll && onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFFFFC107),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // LANGUAGE SELECTOR  — exact same dialog + LanguageTransitionScreen as FancyAppBar
  // ══════════════════════════════════════════════════════════════════════════

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              _buildLangOption(
                context,
                dialogContext,
                'English',
                'en',
                Icons.language,
              ),
              const SizedBox(height: 12),
              _buildLangOption(
                context,
                dialogContext,
                'हिंदी',
                'hi',
                Icons.translate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangOption(
    BuildContext context,
    BuildContext dialogContext,
    String name,
    String code,
    IconData icon,
  ) {
    final lp = Provider.of<LanguageProvider>(context, listen: true);
    final isSelected = lp.locale.languageCode == code;

    return InkWell(
      // Mirrors FancyAppBar: overlay → setLocale → restartApp
      onTap: () async {
        Navigator.pop(dialogContext);

        late OverlayEntry overlayEntry;
        overlayEntry = OverlayEntry(
          builder: (overlayContext) => LanguageTransitionScreen(
            languageName: name,
            languageCode: code,
            onComplete: () async {
              final lp2 = Provider.of<LanguageProvider>(context, listen: false);
              await lp2.setLocale(Locale(code));
              overlayEntry.remove();
              AppRestartService.restartApp(context);
            },
          ),
        );
        Overlay.of(context).insert(overlayEntry);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PREMIUM DIALOG
  // ══════════════════════════════════════════════════════════════════════════

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFAF5FF), Color(0xFFEEF2FF)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Unlock Premium',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Get access to exclusive templates and premium features.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Maybe Later',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubscriptionPlansPage(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Upgrade Now',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REFER & EARN MODAL  — identical to original
  // ══════════════════════════════════════════════════════════════════════════

  void showReferAndEarnModal(BuildContext context) {
    String? uid;
    String? userReferralCode;
    bool isLoading = true;
    String? errorMessage;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Refer and Earn',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, __, ___) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setModalState) {
                    Future<void> loadReferralCode() async {
                      try {
                        setModalState(() {
                          isLoading = true;
                          errorMessage = null;
                        });
                        final userData = await AuthPreferences.getUserData();
                        if (userData != null) {
                          uid = userData.user.id;
                          final response = await http.get(
                            Uri.parse(
                              'http://31.97.206.144:4061/api/users/refferalcode/$uid',
                            ),
                          );
                          if (response.statusCode == 200) {
                            final data = json.decode(response.body);
                            final code =
                                data['referralCode'] ??
                                data['refferalCode'] ??
                                data['code'];
                            setModalState(() {
                              isLoading = false;
                              userReferralCode = code;
                              errorMessage = code == null
                                  ? 'No referral code found'
                                  : null;
                            });
                          } else {
                            setModalState(() {
                              isLoading = false;
                              errorMessage = 'Failed to load referral code';
                            });
                          }
                        }
                      } catch (e) {
                        setModalState(() {
                          isLoading = false;
                          errorMessage = 'Error: $e';
                        });
                      }
                    }

                    void shareCode() {
                      if (userReferralCode != null) {
                        Share.share(
                          '🎉 Join me on EditEzy!\n\nUse my referral code: $userReferralCode\n\nGet exclusive benefits when you upgrade!\n\nhttps://play.google.com/store/apps/details?id=com.posternova.posternova',
                          subject: 'Join EditEzy',
                        );
                      }
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (isLoading &&
                          userReferralCode == null &&
                          errorMessage == null) {
                        loadReferralCode();
                      }
                    });

                    return _FlippableReferModal(
                      isLoading: isLoading,
                      errorMessage: errorMessage,
                      userReferralCode: userReferralCode,
                      onLoadReferralCode: loadReferralCode,
                      onShare: shareCode,
                      onClose: () => Navigator.pop(context),
                      onCopy: () {
                        if (userReferralCode != null) {
                          Clipboard.setData(
                            ClipboardData(text: userReferralCode!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Referral code copied!'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        } else {
                          loadReferralCode();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //   void showReferAndEarnModal(BuildContext context) {
  //   String? uid;
  //   String? userReferralCode;
  //   bool isLoading = true;
  //   String? errorMessage;
  //   bool isFlipped = false;

  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: 'Refer and Earn',
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (_, __, ___) => const SizedBox.shrink(),
  //     transitionBuilder: (context, animation, __, ___) {
  //       return FadeTransition(
  //         opacity: animation,
  //         child: ScaleTransition(
  //           scale: Tween<double>(begin: 0.95, end: 1.0).animate(
  //             CurvedAnimation(parent: animation, curve: Curves.easeOut),
  //           ),
  //           child: Center(
  //             child: Material(
  //               color: Colors.transparent,
  //               child: StatefulBuilder(
  //                 builder: (context, setModalState) {
  //                   Future<void> loadReferralCode() async {
  //                     try {
  //                       setModalState(() {
  //                         isLoading = true;
  //                         errorMessage = null;
  //                       });
  //                       final userData = await AuthPreferences.getUserData();
  //                       if (userData != null) {
  //                         uid = userData.user.id;
  //                         final response = await http.get(
  //                           Uri.parse(
  //                             'http://31.97.206.144:4061/api/users/refferalcode/$uid',
  //                           ),
  //                         );
  //                         if (response.statusCode == 200) {
  //                           final data = json.decode(response.body);
  //                           final code =
  //                               data['referralCode'] ??
  //                               data['refferalCode'] ??
  //                               data['code'];
  //                           setModalState(() {
  //                             isLoading = false;
  //                             userReferralCode = code;
  //                             errorMessage =
  //                                 code == null ? 'No referral code found' : null;
  //                           });
  //                         } else {
  //                           setModalState(() {
  //                             isLoading = false;
  //                             errorMessage = 'Failed to load referral code';
  //                           });
  //                         }
  //                       }
  //                     } catch (e) {
  //                       setModalState(() {
  //                         isLoading = false;
  //                         errorMessage = 'Error: $e';
  //                       });
  //                     }
  //                   }

  //                   void shareCode() {
  //                     if (userReferralCode != null) {
  //                       Share.share(
  //                         '🎉 Join me on EditEzy!\n\nUse my referral code: $userReferralCode\n\nGet exclusive benefits when you upgrade!\n\nhttps://play.google.com/store/apps/details?id=com.posternova.posternova',
  //                         subject: 'Join EditEzy',
  //                       );
  //                     }
  //                   }

  //                   WidgetsBinding.instance.addPostFrameCallback((_) {
  //                     if (isLoading &&
  //                         userReferralCode == null &&
  //                         errorMessage == null) {
  //                       loadReferralCode();
  //                     }
  //                   });

  //                   return Scaffold(
  //                     backgroundColor: Colors.transparent,
  //                     body: Center(
  //                       child: Container(
  //                         margin: const EdgeInsets.symmetric(horizontal: 24),
  //                         constraints: BoxConstraints(
  //                           maxWidth: 500,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(16),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.black.withOpacity(0.1),
  //                               blurRadius: 20,
  //                             ),
  //                           ],
  //                         ),
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(16),
  //                           child: Column(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               // ── Header ───────────────────────────────────
  //                               Container(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 20,
  //                                   vertical: 16,
  //                                 ),
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.grey[50],
  //                                   border: Border(
  //                                     bottom:
  //                                         BorderSide(color: Colors.grey[200]!),
  //                                   ),
  //                                 ),
  //                                 child: Row(
  //                                   children: [
  //                                     Container(
  //                                       padding: const EdgeInsets.all(8),
  //                                       decoration: BoxDecoration(
  //                                         color: const Color(
  //                                           0xFF4F46E5,
  //                                         ).withOpacity(0.1),
  //                                         borderRadius: BorderRadius.circular(8),
  //                                       ),
  //                                       child: const Icon(
  //                                         Icons.people_outline,
  //                                         color: Color(0xFF4F46E5),
  //                                         size: 24,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 12),
  //                                     const Expanded(
  //                                       child: AppText(
  //                                         'refer_earn',
  //                                         style: TextStyle(
  //                                           fontSize: 20,
  //                                           fontWeight: FontWeight.w600,
  //                                           color: Color(0xFF111827),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     IconButton(
  //                                       onPressed: () => Navigator.pop(context),
  //                                       icon:
  //                                           const Icon(Icons.close, size: 24),
  //                                       color: Colors.grey[600],
  //                                       padding: EdgeInsets.zero,
  //                                       constraints: const BoxConstraints(),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),

  //                               // ── Flip indicator tabs ───────────────────────
  //                               Padding(
  //                                 padding: const EdgeInsets.fromLTRB(
  //                                     20, 16, 20, 0),
  //                                 child: Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: GestureDetector(
  //                                         onTap: () => setModalState(
  //                                             () => isFlipped = false),
  //                                         child: AnimatedContainer(
  //                                           duration: const Duration(
  //                                               milliseconds: 250),
  //                                           padding: const EdgeInsets.symmetric(
  //                                               vertical: 8),
  //                                           decoration: BoxDecoration(
  //                                             color: !isFlipped
  //                                                 ? const Color(0xFF4F46E5)
  //                                                 : Colors.grey[100],
  //                                             borderRadius:
  //                                                 BorderRadius.circular(8),
  //                                           ),
  //                                           child: Text(
  //                                             'My Code',
  //                                             textAlign: TextAlign.center,
  //                                             style: TextStyle(
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.w600,
  //                                               color: !isFlipped
  //                                                   ? Colors.white
  //                                                   : Colors.grey[500],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 8),
  //                                     Expanded(
  //                                       child: GestureDetector(
  //                                         onTap: () => setModalState(
  //                                             () => isFlipped = true),
  //                                         child: AnimatedContainer(
  //                                           duration: const Duration(
  //                                               milliseconds: 250),
  //                                           padding: const EdgeInsets.symmetric(
  //                                               vertical: 8),
  //                                           decoration: BoxDecoration(
  //                                             color: isFlipped
  //                                                 ? const Color(0xFF4F46E5)
  //                                                 : Colors.grey[100],
  //                                             borderRadius:
  //                                                 BorderRadius.circular(8),
  //                                           ),
  //                                           child: Text(
  //                                             'How It Works',
  //                                             textAlign: TextAlign.center,
  //                                             style: TextStyle(
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.w600,
  //                                               color: isFlipped
  //                                                   ? Colors.white
  //                                                   : Colors.grey[500],
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),

  //                               // ── Flipping content ──────────────────────────
  //                               Padding(
  //                                 padding: const EdgeInsets.all(20),
  //                                 child: AnimatedSwitcher(
  //                                   duration:
  //                                       const Duration(milliseconds: 350),
  //                                   transitionBuilder: (child, anim) {
  //                                     final offset = isFlipped
  //                                         ? const Offset(1, 0)
  //                                         : const Offset(-1, 0);
  //                                     return SlideTransition(
  //                                       position: Tween<Offset>(
  //                                         begin: offset,
  //                                         end: Offset.zero,
  //                                       ).animate(CurvedAnimation(
  //                                         parent: anim,
  //                                         curve: Curves.easeOut,
  //                                       )),
  //                                       child: FadeTransition(
  //                                           opacity: anim, child: child),
  //                                     );
  //                                   },
  //                                   child: isFlipped
  //                                       ? _buildHowItWorksPanel()
  //                                       : _buildMyCodePanel(
  //                                           isLoading,
  //                                           errorMessage,
  //                                           userReferralCode,
  //                                           loadReferralCode,
  //                                         ),
  //                                 ),
  //                               ),

  //                               // ── Common action buttons ─────────────────────
  //                               Padding(
  //                                 padding: const EdgeInsets.fromLTRB(
  //                                     20, 0, 20, 20),
  //                                 child: Row(
  //                                   children: [
  //                                     Expanded(
  //                                       child: ElevatedButton.icon(
  //                                         onPressed: () {
  //                                           if (userReferralCode != null) {
  //                                             Clipboard.setData(ClipboardData(
  //                                                 text: userReferralCode!));
  //                                             ScaffoldMessenger.of(context)
  //                                                 .showSnackBar(
  //                                               const SnackBar(
  //                                                 content:
  //                                                     Text('Referral code copied!'),
  //                                                 behavior:
  //                                                     SnackBarBehavior.floating,
  //                                                 backgroundColor:
  //                                                     Color(0xFF10B981),
  //                                               ),
  //                                             );
  //                                           } else {
  //                                             loadReferralCode();
  //                                           }
  //                                         },
  //                                         icon: const Icon(Icons.copy, size: 20),
  //                                         label: const Text('Copy Code'),
  //                                         style: ElevatedButton.styleFrom(
  //                                           backgroundColor:
  //                                               const Color(0xFF4F46E5),
  //                                           foregroundColor: Colors.white,
  //                                           padding: const EdgeInsets.symmetric(
  //                                               vertical: 14),
  //                                           shape: RoundedRectangleBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                           ),
  //                                           elevation: 0,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 12),
  //                                     Expanded(
  //                                       child: ElevatedButton.icon(
  //                                         onPressed: userReferralCode != null
  //                                             ? shareCode
  //                                             : null,
  //                                         icon:
  //                                             const Icon(Icons.share, size: 20),
  //                                         label: const Text('Share'),
  //                                         style: ElevatedButton.styleFrom(
  //                                           backgroundColor:
  //                                               const Color(0xFF10B981),
  //                                           foregroundColor: Colors.white,
  //                                           disabledBackgroundColor:
  //                                               Colors.grey[300],
  //                                           padding: const EdgeInsets.symmetric(
  //                                               vertical: 14),
  //                                           shape: RoundedRectangleBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(10),
  //                                           ),
  //                                           elevation: 0,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // // ── Front face: My Code ────────────────────────────────────────────────────
  // Widget _buildMyCodePanel(
  //   bool isLoading,
  //   String? errorMessage,
  //   String? userReferralCode,
  //   VoidCallback loadReferralCode,
  // ) {
  //   return Column(
  //     key: const ValueKey('front'),
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFFF0F9FF),
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: const Color(0xFFBAE6FD)),
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF0EA5E9),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Icon(Icons.info_outline,
  //                   color: Colors.white, size: 20),
  //             ),
  //             const SizedBox(width: 12),
  //             const Expanded(
  //               child: AppText(
  //                 'share_referral_earn',
  //                 style: TextStyle(
  //                     fontSize: 14,
  //                     color: Color(0xFF0C4A6E),
  //                     height: 1.4),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //       const AppText(
  //         'your_referral_code',
  //         style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF374151)),
  //       ),
  //       const SizedBox(height: 12),
  //       AnimatedSwitcher(
  //         duration: const Duration(milliseconds: 300),
  //         child: isLoading
  //             ? Container(
  //                 key: const ValueKey('loading'),
  //                 padding: const EdgeInsets.all(20),
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[50],
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: Colors.grey[200]!),
  //                 ),
  //                 child: const Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     SizedBox(
  //                       width: 20,
  //                       height: 20,
  //                       child: CircularProgressIndicator(
  //                           strokeWidth: 2,
  //                           color: Color(0xFF4F46E5)),
  //                     ),
  //                     SizedBox(width: 12),
  //                     Text('Loading...',
  //                         style: TextStyle(
  //                             fontSize: 14, color: Color(0xFF6B7280))),
  //                   ],
  //                 ),
  //               )
  //             : errorMessage != null
  //                 ? Container(
  //                     key: const ValueKey('error'),
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFFFEF2F2),
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(color: const Color(0xFFFECACA)),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         const Icon(Icons.error_outline,
  //                             color: Color(0xFFEF4444), size: 20),
  //                         const SizedBox(width: 8),
  //                         Expanded(
  //                           child: Text(errorMessage,
  //                               style: const TextStyle(
  //                                   fontSize: 14,
  //                                   color: Color(0xFF991B1B))),
  //                         ),
  //                         TextButton(
  //                           onPressed: loadReferralCode,
  //                           child: const Text('Retry'),
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 : Container(
  //                     key: const ValueKey('code'),
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey[50],
  //                       borderRadius: BorderRadius.circular(12),
  //                       border: Border.all(color: Colors.grey[300]!),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 userReferralCode ?? '--',
  //                                 style: const TextStyle(
  //                                   fontSize: 28,
  //                                   fontWeight: FontWeight.w700,
  //                                   letterSpacing: 3,
  //                                   color: Color(0xFF4F46E5),
  //                                 ),
  //                               ),
  //                               const Text('Tap Copy to share',
  //                                   style: TextStyle(
  //                                       fontSize: 12,
  //                                       color: Color(0xFF6B7280))),
  //                             ],
  //                           ),
  //                         ),
  //                         const Icon(Icons.card_giftcard_rounded,
  //                             color: Color(0xFF4F46E5), size: 36),
  //                       ],
  //                     ),
  //                   ),
  //       ),
  //     ],
  //   );
  // }

  // // ── Back face: How It Works ────────────────────────────────────────────────
  // Widget _buildHowItWorksPanel() {
  //   return Column(
  //     key: const ValueKey('back'),
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const AppText(
  //         'how_it_works',
  //         style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF374151)),
  //       ),
  //       const SizedBox(height: 16),
  //       _referStep('1', 'share_your_code', 'send_referral_any_platform'),
  //       const SizedBox(height: 14),
  //       _referStep('2', 'friend_signs_up', 'enter_code_during_signup'),
  //       const SizedBox(height: 14),
  //       _referStep('3', 'earn_rewards', 'get_200_on_upgrade'),
  //       const SizedBox(height: 8),
  //     ],
  //   );
  // }

  // void showReferAndEarnModal(BuildContext context) {
  //   String? uid;
  //   String? userReferralCode;
  //   bool isLoading = true;
  //   String? errorMessage;

  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: 'Refer and Earn',
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     transitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (_, __, ___) => const SizedBox.shrink(),
  //     transitionBuilder: (context, animation, __, ___) {
  //       return FadeTransition(
  //         opacity: animation,
  //         child: ScaleTransition(
  //           scale: Tween<double>(begin: 0.95, end: 1.0).animate(
  //             CurvedAnimation(parent: animation, curve: Curves.easeOut),
  //           ),
  //           child: Center(
  //             child: Material(
  //               color: Colors.transparent,
  //               child: StatefulBuilder(
  //                 builder: (context, setModalState) {
  //                   Future<void> loadReferralCode() async {
  //                     try {
  //                       setModalState(() {
  //                         isLoading = true;
  //                         errorMessage = null;
  //                       });
  //                       final userData = await AuthPreferences.getUserData();
  //                       if (userData != null) {
  //                         uid = userData.user.id;
  //                         final response = await http.get(
  //                           Uri.parse(
  //                             'http://31.97.206.144:4061/api/users/refferalcode/$uid',
  //                           ),
  //                         );
  //                         if (response.statusCode == 200) {
  //                           final data = json.decode(response.body);
  //                           final code =
  //                               data['referralCode'] ??
  //                               data['refferalCode'] ??
  //                               data['code'];
  //                           setModalState(() {
  //                             isLoading = false;
  //                             userReferralCode = code;
  //                             errorMessage = code == null
  //                                 ? 'No referral code found'
  //                                 : null;
  //                           });
  //                         } else {
  //                           setModalState(() {
  //                             isLoading = false;
  //                             errorMessage = 'Failed to load referral code';
  //                           });
  //                         }
  //                       }
  //                     } catch (e) {
  //                       setModalState(() {
  //                         isLoading = false;
  //                         errorMessage = 'Error: $e';
  //                       });
  //                     }
  //                   }

  //                   void shareCode() {
  //                     if (userReferralCode != null) {
  //                       Share.share(
  //                         '🎉 Join me on EditEzy!\n\nUse my referral code: $userReferralCode\n\nGet exclusive benefits when you upgrade!\n\nhttps://play.google.com/store/apps/details?id=com.posternova.posternova',
  //                         subject: 'Join EditEzy',
  //                       );
  //                     }
  //                   }

  //                   WidgetsBinding.instance.addPostFrameCallback((_) {
  //                     if (isLoading &&
  //                         userReferralCode == null &&
  //                         errorMessage == null) {
  //                       loadReferralCode();
  //                     }
  //                   });

  //                   return Scaffold(
  //                     backgroundColor: Colors.transparent,
  //                     body: Center(
  //                       child: Container(
  //                         margin: const EdgeInsets.symmetric(horizontal: 24),
  //                         constraints: BoxConstraints(
  //                           maxHeight: MediaQuery.of(context).size.height * 0.8,
  //                           maxWidth: 500,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(16),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.black.withOpacity(0.1),
  //                               blurRadius: 20,
  //                             ),
  //                           ],
  //                         ),
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(16),
  //                           child: Column(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               // Header
  //                               Container(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 20,
  //                                   vertical: 16,
  //                                 ),
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.grey[50],
  //                                   border: Border(
  //                                     bottom: BorderSide(
  //                                       color: Colors.grey[200]!,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 child: Row(
  //                                   children: [
  //                                     Container(
  //                                       padding: const EdgeInsets.all(8),
  //                                       decoration: BoxDecoration(
  //                                         color: const Color(
  //                                           0xFF4F46E5,
  //                                         ).withOpacity(0.1),
  //                                         borderRadius: BorderRadius.circular(
  //                                           8,
  //                                         ),
  //                                       ),
  //                                       child: const Icon(
  //                                         Icons.people_outline,
  //                                         color: Color(0xFF4F46E5),
  //                                         size: 24,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 12),
  //                                     const Expanded(
  //                                       child: AppText(
  //                                         'refer_earn',
  //                                         style: TextStyle(
  //                                           fontSize: 20,
  //                                           fontWeight: FontWeight.w600,
  //                                           color: Color(0xFF111827),
  //                                         ),
  //                                       ),
  //                                     ),
  //                                     IconButton(
  //                                       onPressed: () => Navigator.pop(context),
  //                                       icon: const Icon(Icons.close, size: 24),
  //                                       color: Colors.grey[600],
  //                                       padding: EdgeInsets.zero,
  //                                       constraints: const BoxConstraints(),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               // Content
  //                               Flexible(
  //                                 child: SingleChildScrollView(
  //                                   padding: const EdgeInsets.all(24),
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       Container(
  //                                         width: double.infinity,
  //                                         padding: const EdgeInsets.all(16),
  //                                         decoration: BoxDecoration(
  //                                           color: const Color(0xFFF0F9FF),
  //                                           borderRadius: BorderRadius.circular(
  //                                             12,
  //                                           ),
  //                                           border: Border.all(
  //                                             color: const Color(0xFFBAE6FD),
  //                                           ),
  //                                         ),
  //                                         child: Row(
  //                                           children: [
  //                                             Container(
  //                                               padding: const EdgeInsets.all(
  //                                                 8,
  //                                               ),
  //                                               decoration: BoxDecoration(
  //                                                 color: const Color(
  //                                                   0xFF0EA5E9,
  //                                                 ),
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(8),
  //                                               ),
  //                                               child: const Icon(
  //                                                 Icons.info_outline,
  //                                                 color: Colors.white,
  //                                                 size: 20,
  //                                               ),
  //                                             ),
  //                                             const SizedBox(width: 12),
  //                                             const Expanded(
  //                                               child: AppText(
  //                                                 'share_referral_earn',
  //                                                 style: TextStyle(
  //                                                   fontSize: 14,
  //                                                   color: Color(0xFF0C4A6E),
  //                                                   height: 1.4,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                       const SizedBox(height: 24),
  //                                       const AppText(
  //                                         'your_referral_code',
  //                                         style: TextStyle(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w600,
  //                                           color: Color(0xFF374151),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(height: 12),
  //                                       AnimatedSwitcher(
  //                                         duration: const Duration(
  //                                           milliseconds: 300,
  //                                         ),
  //                                         child: isLoading
  //                                             ? Container(
  //                                                 key: const ValueKey(
  //                                                   'loading',
  //                                                 ),
  //                                                 padding: const EdgeInsets.all(
  //                                                   20,
  //                                                 ),
  //                                                 decoration: BoxDecoration(
  //                                                   color: Colors.grey[50],
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                         12,
  //                                                       ),
  //                                                   border: Border.all(
  //                                                     color: Colors.grey[200]!,
  //                                                   ),
  //                                                 ),
  //                                                 child: const Row(
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment
  //                                                           .center,
  //                                                   children: [
  //                                                     SizedBox(
  //                                                       width: 20,
  //                                                       height: 20,
  //                                                       child:
  //                                                           CircularProgressIndicator(
  //                                                             strokeWidth: 2,
  //                                                             color: Color(
  //                                                               0xFF4F46E5,
  //                                                             ),
  //                                                           ),
  //                                                     ),
  //                                                     SizedBox(width: 12),
  //                                                     Text(
  //                                                       'Loading...',
  //                                                       style: TextStyle(
  //                                                         fontSize: 14,
  //                                                         color: Color(
  //                                                           0xFF6B7280,
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               )
  //                                             : errorMessage != null
  //                                             ? Container(
  //                                                 key: const ValueKey('error'),
  //                                                 padding: const EdgeInsets.all(
  //                                                   16,
  //                                                 ),
  //                                                 decoration: BoxDecoration(
  //                                                   color: const Color(
  //                                                     0xFFFEF2F2,
  //                                                   ),
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                         12,
  //                                                       ),
  //                                                   border: Border.all(
  //                                                     color: const Color(
  //                                                       0xFFFECACA,
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                                 child: Column(
  //                                                   children: [
  //                                                     Row(
  //                                                       children: [
  //                                                         const Icon(
  //                                                           Icons.error_outline,
  //                                                           color: Color(
  //                                                             0xFFEF4444,
  //                                                           ),
  //                                                           size: 20,
  //                                                         ),
  //                                                         const SizedBox(
  //                                                           width: 8,
  //                                                         ),
  //                                                         Expanded(
  //                                                           child: Text(
  //                                                             errorMessage!,
  //                                                             style:
  //                                                                 const TextStyle(
  //                                                                   fontSize:
  //                                                                       14,
  //                                                                   color: Color(
  //                                                                     0xFF991B1B,
  //                                                                   ),
  //                                                                 ),
  //                                                           ),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                     const SizedBox(
  //                                                       height: 12,
  //                                                     ),
  //                                                     SizedBox(
  //                                                       width: double.infinity,
  //                                                       child: OutlinedButton.icon(
  //                                                         onPressed:
  //                                                             loadReferralCode,
  //                                                         style: OutlinedButton.styleFrom(
  //                                                           foregroundColor:
  //                                                               const Color(
  //                                                                 0xFFEF4444,
  //                                                               ),
  //                                                           side:
  //                                                               const BorderSide(
  //                                                                 color: Color(
  //                                                                   0xFFEF4444,
  //                                                                 ),
  //                                                               ),
  //                                                           shape: RoundedRectangleBorder(
  //                                                             borderRadius:
  //                                                                 BorderRadius.circular(
  //                                                                   8,
  //                                                                 ),
  //                                                           ),
  //                                                         ),
  //                                                         icon: const Icon(
  //                                                           Icons.refresh,
  //                                                           size: 18,
  //                                                         ),
  //                                                         label: const Text(
  //                                                           'Retry',
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               )
  //                                             : Container(
  //                                                 key: const ValueKey('code'),
  //                                                 padding: const EdgeInsets.all(
  //                                                   16,
  //                                                 ),
  //                                                 decoration: BoxDecoration(
  //                                                   color: Colors.grey[50],
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                         12,
  //                                                       ),
  //                                                   border: Border.all(
  //                                                     color: Colors.grey[300]!,
  //                                                   ),
  //                                                 ),
  //                                                 child: Row(
  //                                                   children: [
  //                                                     Expanded(
  //                                                       child: Column(
  //                                                         crossAxisAlignment:
  //                                                             CrossAxisAlignment
  //                                                                 .start,
  //                                                         children: [
  //                                                           Text(
  //                                                             userReferralCode ??
  //                                                                 '--',
  //                                                             style: const TextStyle(
  //                                                               fontSize: 24,
  //                                                               fontWeight:
  //                                                                   FontWeight
  //                                                                       .w700,
  //                                                               letterSpacing:
  //                                                                   2,
  //                                                               color: Color(
  //                                                                 0xFF4F46E5,
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                           const Text(
  //                                                             'Tap to copy',
  //                                                             style: TextStyle(
  //                                                               fontSize: 12,
  //                                                               color: Color(
  //                                                                 0xFF6B7280,
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                         ],
  //                                                       ),
  //                                                     ),
  //                                                     IconButton(
  //                                                       onPressed: () {
  //                                                         if (userReferralCode !=
  //                                                             null) {
  //                                                           Clipboard.setData(
  //                                                             ClipboardData(
  //                                                               text:
  //                                                                   userReferralCode!,
  //                                                             ),
  //                                                           );
  //                                                           ScaffoldMessenger.of(
  //                                                             context,
  //                                                           ).showSnackBar(
  //                                                             const SnackBar(
  //                                                               content: Text(
  //                                                                 'Referral code copied!',
  //                                                               ),
  //                                                               behavior:
  //                                                                   SnackBarBehavior
  //                                                                       .floating,
  //                                                               backgroundColor:
  //                                                                   Color(
  //                                                                     0xFF10B981,
  //                                                                   ),
  //                                                             ),
  //                                                           );
  //                                                         }
  //                                                       },
  //                                                       icon: const Icon(
  //                                                         Icons.copy,
  //                                                         size: 20,
  //                                                       ),
  //                                                       color: const Color(
  //                                                         0xFF4F46E5,
  //                                                       ),
  //                                                       style:
  //                                                           IconButton.styleFrom(
  //                                                             backgroundColor:
  //                                                                 const Color(
  //                                                                   0xFF4F46E5,
  //                                                                 ).withOpacity(
  //                                                                   0.1,
  //                                                                 ),
  //                                                           ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                       ),
  //                                       const SizedBox(height: 24),
  //                                       const AppText(
  //                                         'how_it_works',
  //                                         style: TextStyle(
  //                                           fontSize: 14,
  //                                           fontWeight: FontWeight.w600,
  //                                           color: Color(0xFF374151),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(height: 12),
  //                                       _referStep(
  //                                         '1',
  //                                         'share_your_code',
  //                                         'send_referral_any_platform',
  //                                       ),
  //                                       const SizedBox(height: 12),
  //                                       _referStep(
  //                                         '2',
  //                                         'friend_signs_up',
  //                                         'enter_code_during_signup',
  //                                       ),
  //                                       const SizedBox(height: 12),
  //                                       _referStep(
  //                                         '3',
  //                                         'earn_rewards',
  //                                         'get_200_on_upgrade',
  //                                       ),
  //                                       const SizedBox(height: 24),
  //                                       Row(
  //                                         children: [
  //                                           Expanded(
  //                                             child: ElevatedButton.icon(
  //                                               onPressed: () {
  //                                                 if (userReferralCode !=
  //                                                     null) {
  //                                                   Clipboard.setData(
  //                                                     ClipboardData(
  //                                                       text: userReferralCode!,
  //                                                     ),
  //                                                   );
  //                                                   ScaffoldMessenger.of(
  //                                                     context,
  //                                                   ).showSnackBar(
  //                                                     const SnackBar(
  //                                                       content: Text(
  //                                                         'Copied!',
  //                                                       ),
  //                                                       backgroundColor: Color(
  //                                                         0xFF10B981,
  //                                                       ),
  //                                                     ),
  //                                                   );
  //                                                 } else {
  //                                                   loadReferralCode();
  //                                                 }
  //                                               },
  //                                               icon: const Icon(
  //                                                 Icons.copy,
  //                                                 size: 20,
  //                                               ),
  //                                               label: const Text('Copy Code'),
  //                                               style: ElevatedButton.styleFrom(
  //                                                 backgroundColor: const Color(
  //                                                   0xFF4F46E5,
  //                                                 ),
  //                                                 foregroundColor: Colors.white,
  //                                                 padding:
  //                                                     const EdgeInsets.symmetric(
  //                                                       vertical: 14,
  //                                                     ),
  //                                                 shape: RoundedRectangleBorder(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                         10,
  //                                                       ),
  //                                                 ),
  //                                                 elevation: 0,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           const SizedBox(width: 12),
  //                                           Expanded(
  //                                             child: ElevatedButton.icon(
  //                                               onPressed:
  //                                                   userReferralCode != null
  //                                                   ? shareCode
  //                                                   : null,
  //                                               icon: const Icon(
  //                                                 Icons.share,
  //                                                 size: 20,
  //                                               ),
  //                                               label: const Text('Share'),
  //                                               style: ElevatedButton.styleFrom(
  //                                                 backgroundColor: const Color(
  //                                                   0xFF10B981,
  //                                                 ),
  //                                                 foregroundColor: Colors.white,
  //                                                 disabledBackgroundColor:
  //                                                     Colors.grey[300],
  //                                                 padding:
  //                                                     const EdgeInsets.symmetric(
  //                                                       vertical: 14,
  //                                                     ),
  //                                                 shape: RoundedRectangleBorder(
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                         10,
  //                                                       ),
  //                                                 ),
  //                                                 elevation: 0,
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _referStep(String number, String titleKey, String descKey) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F46E5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                titleKey,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              AppText(
                descKey,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _AutoPlayReelVideo extends StatefulWidget {
  final String videoUrl;
  const _AutoPlayReelVideo({required this.videoUrl});

  @override
  State<_AutoPlayReelVideo> createState() => _AutoPlayReelVideoState();
}

class _AutoPlayReelVideoState extends State<_AutoPlayReelVideo> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (widget.videoUrl.isEmpty) {
      setState(() => _hasError = true);
      return;
    }
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _controller!.initialize();
      if (!mounted) return;
      _controller!
        ..setLooping(true)
        ..setVolume(0) // muted — user hears sound only on full ReelsScreen
        ..play();
      setState(() => _initialized = true);
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || !_initialized || _controller == null) {
      // Fallback gradient while loading / on error
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.play_circle_outline_rounded,
            color: Colors.white38,
            size: 36,
          ),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );
  }
}

class _FlippableReferModal extends StatefulWidget {
  final bool isLoading;
  final String? errorMessage;
  final String? userReferralCode;
  final VoidCallback onLoadReferralCode;
  final VoidCallback onShare;
  final VoidCallback onClose;
  final VoidCallback onCopy;

  const _FlippableReferModal({
    required this.isLoading,
    required this.errorMessage,
    required this.userReferralCode,
    required this.onLoadReferralCode,
    required this.onShare,
    required this.onClose,
    required this.onCopy,
  });

  @override
  State<_FlippableReferModal> createState() => _FlippableReferModalState();
}

class _FlippableReferModalState extends State<_FlippableReferModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlipped = false;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _flipAnimation.addListener(() {
      // Switch content halfway through flip
      if (_flipAnimation.value >= 0.5 && !_showBack) {
        setState(() => _showBack = true);
      } else if (_flipAnimation.value < 0.5 && _showBack) {
        setState(() => _showBack = false);
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    _isFlipped = !_isFlipped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ──────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4F46E5).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.people_outline,
                          color: Color(0xFF4F46E5),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: AppText(
                          'refer_earn',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      // Flip hint button
                      GestureDetector(
                        onTap: _flip,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4F46E5).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _flipAnimation,
                                builder: (_, __) => Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(
                                    _flipAnimation.value * 3.14159,
                                  ),
                                  child: const Icon(
                                    Icons.flip_camera_android_rounded,
                                    color: Color(0xFF4F46E5),
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _showBack ? 'My Code' : 'How it works',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: widget.onClose,
                        icon: const Icon(Icons.close, size: 24),
                        color: Colors.grey[600],
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),

                // ── Flipping Card ────────────────────────────────────────
                GestureDetector(
                  onTap: _flip,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, _) {
                      final angle = _flipAnimation.value * 3.14159;
                      // Flip Y axis — first half shows front, second half shows back (mirrored)
                      final isSecondHalf = _flipAnimation.value >= 0.5;
                      final displayAngle = isSecondHalf
                          ? angle - 3.14159
                          : angle;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // perspective
                          ..rotateY(angle),
                        child: Transform(
                          alignment: Alignment.center,
                          // Mirror the back face so text isn't reversed
                          transform: isSecondHalf
                              ? (Matrix4.identity()..rotateY(3.14159))
                              : Matrix4.identity(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                            child: _showBack
                                ? _buildHowItWorksContent()
                                : _buildMyCodeContent(),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Flip hint text ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        size: 13,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tap card to flip',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),

                // ── Common Buttons (always visible) ──────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onCopy,
                          icon: const Icon(Icons.copy, size: 20),
                          label: const Text('Copy Code'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.userReferralCode != null
                              ? widget.onShare
                              : null,
                          icon: const Icon(Icons.share, size: 20),
                          label: const Text('Share'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
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
    );
  }

  Widget _buildMyCodeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBAE6FD)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: AppText(
                  'share_referral_earn',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0C4A6E),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const AppText(
          'your_referral_code',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 10),
        if (widget.isLoading)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF4F46E5),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Loading...',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          )
        else if (widget.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFEF4444),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.errorMessage!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onLoadReferralCode,
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC7D2FE)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userReferralCode ?? '--',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                      const Text(
                        'Your unique referral code',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard_rounded,
                    color: Color(0xFF4F46E5),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHowItWorksContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'how_it_works',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        _howItWorksStep(
          '1',
          Icons.share_rounded,
          'share_your_code',
          'send_referral_any_platform',
          const Color(0xFF6366F1),
        ),
        const SizedBox(height: 12),
        _howItWorksStep(
          '2',
          Icons.person_add_rounded,
          'friend_signs_up',
          'enter_code_during_signup',
          const Color(0xFF0EA5E9),
        ),
        const SizedBox(height: 12),
        _howItWorksStep(
          '3',
          Icons.emoji_events_rounded,
          'earn_rewards',
          'get_200_on_upgrade',
          const Color(0xFF10B981),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _howItWorksStep(
    String number,
    IconData icon,
    String titleKey,
    String descKey,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(child: Icon(icon, color: color, size: 20)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                titleKey,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 3),
              AppText(
                descKey,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
