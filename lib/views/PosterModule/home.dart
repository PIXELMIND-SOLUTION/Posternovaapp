// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
// import 'package:posternova/providers/PosterProvider/poster_provider.dart';
// import 'package:posternova/providers/festivals/date_time_provider.dart';
// import 'package:posternova/providers/plans/my_plan_provider.dart';
// import 'package:posternova/providers/story/story_provider.dart';
// import 'package:posternova/providers/topics/hot_topic_provider.dart';
// import 'package:posternova/views/PosterModule/poster_making_screen.dart'
//     hide Overlay;
// import 'package:posternova/views/ProfileScreen/profile_screen.dart';
// import 'package:posternova/views/SecondPhase/poster_editor.dart';
// import 'package:posternova/views/category/category_detail_screen.dart';
// import 'package:posternova/views/category/search_category.dart';
// import 'package:posternova/views/hot/hot_screen.dart';
// import 'package:posternova/views/notifications/notification_screen.dart';
// import 'package:posternova/views/stories/story_widget_screen.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:posternova/widgets/language_animation_widget.dart';
// import 'package:posternova/services/language/restart_lan_service.dart';
// import 'package:posternova/widgets/premium_widget.dart';
// import 'package:posternova/widgets/voice_assistant_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';
// import 'package:video_player/video_player.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   // ─── User ──────────────────────────────────────────────────────────────────
//   String? currentUserId;
//   String? username;
//   String? userImage;
//   String? userId;

//   // ─── Data ──────────────────────────────────────────────────────────────────
//   Map<String, dynamic> birthdayData = {};
//   Map<String, dynamic> anniversaryData = {};
//   Map<String, List<dynamic>> weeklyPosters = {};
//   List<dynamic> customers = [];
//   bool isLoadingCustomers = false;
//   bool _isLoading = false;
//   bool _isBannerLoading = false;
//   static bool _hasShownReferAndEarnModal = false;

//   List<dynamic> festivaldata = [];
//   List<dynamic> canvaposter = [];
//   List<dynamic> bannerList = [];

//   List<dynamic> birthdayAnniversaryPosters = [];
//   bool _isBirthdayLoading = false;

//   // List<dynamic> birthdayPosters = [];
//   // List<dynamic> anniversaryPosters = [];
//   // bool _isBirthdayLoading = false;
//   // ─── Controllers ───────────────────────────────────────────────────────────
//   final TextEditingController _searchController = TextEditingController();
//   late PageController _bannerPageController;
//   int _currentBannerPage = 0;

//   List<String> weekDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday',
//   ];

//   late VideoPlayerController _controller;

//   // ══════════════════════════════════════════════════════════════════════════
//   // LIFECYCLE
//   // ══════════════════════════════════════════════════════════════════════════

//   @override
//   void initState() {
//     super.initState();
//     _bannerPageController = PageController();
//     _loadUserData();
//     _loadUserId();
//     _initializeUser();
//     Future.microtask(() async => await _initializeAllData());
//     _controller = VideoPlayerController.asset("assets/videos/bg.webm")
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.setLooping(true);
//         _controller.play();
//       });
//   }

//   @override
//   void dispose() {
//     _bannerPageController.dispose();
//     _searchController.dispose();
//     VoiceGreetingHelper.stop();
//     super.dispose();
//   }

//   Future<void> _fetchBirthdayAnniversaryPosters() async {
//     if (!mounted) return;
//     setState(() => _isBirthdayLoading = true);
//     try {
//       final posterProvider = Provider.of<PosterProvider>(
//         context,
//         listen: false,
//       );
//       // Filter from already-loaded posters for birthday/anniversary categories
//       final allPosters = posterProvider.posters;
//       final filtered = allPosters.where((poster) {
//         final name = (poster.categoryName ?? '').toLowerCase();
//         return name.contains('birthday') ||
//             name.contains('anniversary') ||
//             name.contains('wedding');
//       }).toList();

//       if (!mounted) return;
//       setState(() {
//         birthdayAnniversaryPosters = filtered;
//         _isBirthdayLoading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _isBirthdayLoading = false);
//       debugPrint('fetchBirthdayAnniversary: $e');
//     }
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // INIT HELPERS
//   // ══════════════════════════════════════════════════════════════════════════

//   Future<void> _initializeAllData() async {
//     if (!mounted) return;
//     await Future.wait([
//       _loadUserId().catchError((e) => debugPrint('loadUserId: $e')),
//       _fetchnewposters().catchError((e) => debugPrint('fetchPosters: $e')),
//       _initializeProviders().catchError((e) => debugPrint('providers: $e')),
//       _fetchWeeklyPosters().catchError((e) => debugPrint('weeklyPosters: $e')),
//       _fetchBanners().catchError((e) => debugPrint('banners: $e')),
//     ]);
//     if (!mounted) return;
//     _fetchFestivalPosters(context.read<DateTimeProvider>().selectedDate);
//     _fetchReels();
//     _fetchBirthdayAnniversaryPosters();
//     _startBannerAutoScroll();
//   }

//   Future<void> _initializeProviders() async {
//     if (!mounted) return;
//     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
//     final storyProvider = Provider.of<StoryProvider>(context, listen: false);
//     final posterProvider = Provider.of<PosterProvider>(context, listen: false);
//     storyProvider.fetchStories();
//     await Future.wait([
//       myPlanProvider.fetchMyPlan(userId.toString()).catchError((_) => null),
//       posterProvider.fetchPosters().catchError((_) => null),
//     ]);
//     if (!mounted) return;
//     _showInitialModals();
//   }

//   void _showInitialModals() {
//     if (!mounted) return;
//     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
//     if (!myPlanProvider.isPurchase) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => SubscriptionPlansPage()),
//           );
//         }
//       });
//     }
//     if (!_hasShownReferAndEarnModal) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           showReferAndEarnModal(context);
//           _hasShownReferAndEarnModal = true;
//         }
//       });
//     }
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // DATA FETCHERS
//   // ══════════════════════════════════════════════════════════════════════════

//   Future<void> _fetchBanners() async {
//     setState(() => _isBannerLoading = true);
//     try {
//       final response = await http.get(
//         Uri.parse('http://31.97.206.144:4061/api/poster/getbanners'),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           bannerList = data is List
//               ? data
//               : (data['banners'] ?? data['data'] ?? []);
//           _isBannerLoading = false;
//         });
//       } else {
//         setState(() => _isBannerLoading = false);
//       }
//     } catch (e) {
//       setState(() => _isBannerLoading = false);
//       debugPrint('fetchBanners: $e');
//     }
//   }

//   void _startBannerAutoScroll() {
//     Future.delayed(const Duration(seconds: 3), () {
//       if (!mounted || !_bannerPageController.hasClients || bannerList.isEmpty)
//         return;
//       final next = (_currentBannerPage + 1) % bannerList.length;
//       _bannerPageController.animateToPage(
//         next,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//       _startBannerAutoScroll();
//     });
//   }

//   // Future<void> _fetchReels() async {
//   //   if (userId == null) return;
//   //   try {
//   //     final reelProvider = Provider.of<ReelProvider>(context, listen: false);
//   //     await reelProvider.fetchAllReels(userId!);
//   //   } catch (e) {
//   //     debugPrint('fetchReels: $e');
//   //   }
//   // }

//   Future<void> _fetchReels() async {
//     if (userId == null) return;
//     try {
//       final hotTopicProvider = Provider.of<HotTopicReelsProvider>(
//         context,
//         listen: false,
//       );
//       await hotTopicProvider.loadHotTopicReels(userId!);
//     } catch (e) {
//       debugPrint('fetchReels: $e');
//     }
//   }

//   Future<void> _fetchWeeklyPosters() async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           'http://31.97.206.144:4061/api/poster/weeklyposters/$currentUserId',
//         ),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as Map<String, dynamic>;
//         setState(() {
//           weeklyPosters = data.map(
//             (k, v) => MapEntry(k, List<dynamic>.from(v)),
//           );
//         });
//       }
//     } catch (e) {
//       debugPrint('fetchWeeklyPosters: $e');
//     }
//   }

//   Future<void> _loadUserId() async {
//     if (!mounted) return;
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (!mounted) return;
//       if (userData != null) {
//         setState(() {
//           username = userData.user.name;
//           currentUserId = userData.user.id;
//         });
//         await _fetchWeeklyPosters();
//         final response = await http.get(
//           Uri.parse(
//             'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
//           ),
//         );
//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           setState(() {
//             birthdayData = Map<String, dynamic>.from(data);
//             anniversaryData = Map<String, dynamic>.from(data);
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('loadUserId: $e');
//     }
//   }

//   Future<void> _loadUserData() async {
//     final userData = await AuthPreferences.getUserData();
//     if (userData != null && userData.user != null) {
//       setState(() {
//         userId = userData.user.id;
//         username = userData.user.name;
//         userImage = userData.user.profileImage;
//       });
//       // Fetch from API for latest profile image (same as FancyAppBar)
//       _fetchUserProfile(userData.user.id);
//       fetchCustomers();
//     }
//   }

//   /// Fetches latest profile from API — mirrors FancyAppBar logic exactly
//   Future<void> _fetchUserProfile(String? uid) async {
//     if (uid == null) return;
//     try {
//       final response = await http.get(
//         Uri.parse('http://31.97.206.144:4061/api/users/get-profile/$uid'),
//       );
//       if (response.statusCode == 200 && mounted) {
//         final data = json.decode(response.body);
//         setState(() {
//           username = data['name'] ?? username ?? 'User';
//           userImage = data['profileImage'] ?? userImage;
//         });
//         final lp = Provider.of<LanguageProvider>(context, listen: false);
//         lp.setUserId(uid);
//       }
//     } catch (e) {
//       debugPrint('fetchUserProfile: $e');
//     }
//   }

//   Future<void> _initializeUser() async {
//     final userData = await AuthPreferences.getUserData();
//     if (userData != null && userData.user.id != null) {
//       final storyProvider = Provider.of<StoryProvider>(context, listen: false);
//       storyProvider.setCurrentUser(
//         userId: userData.user.id,
//         userImage: userData.user.profileImage,
//         username: userData.user.name ?? '',
//       );
//       storyProvider.fetchStories();
//     }
//   }

//   Future<void> fetchCustomers() async {
//     if (userId == null) return;
//     setState(() => isLoadingCustomers = true);
//     try {
//       final response = await http.get(
//         Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           customers = data['customers'] ?? [];
//           isLoadingCustomers = false;
//         });
//       } else {
//         setState(() => isLoadingCustomers = false);
//       }
//     } catch (e) {
//       setState(() => isLoadingCustomers = false);
//     }
//   }

//   String _formatDate(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

//   Future<void> _fetchFestivalPosters(DateTime date) async {
//     setState(() {
//       _isLoading = true;
//       festivaldata = [];
//     });
//     try {
//       final response = await http.post(
//         Uri.parse('http://31.97.206.144:4061/api/poster/festival'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'festivalDate': _formatDate(date)}),
//       );
//       if (response.statusCode == 200) {
//         setState(() {
//           festivaldata = jsonDecode(response.body);
//           _isLoading = false;
//         });
//       } else {
//         setState(() => _isLoading = false);
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _fetchnewposters() async {
//     try {
//       final cp = Provider.of<CanvaPosterProvider>(context, listen: false);
//       await cp.fetchPosters();
//       setState(() => canvaposter = cp.posters);
//     } catch (e) {
//       debugPrint('fetchnewposters: $e');
//     }
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // HELPERS
//   // ══════════════════════════════════════════════════════════════════════════

//   List<String> _getOrderedDaysFromToday() {
//     final today = DateFormat('EEEE').format(DateTime.now());
//     final todayIndex = weekDays.indexOf(today);
//     if (todayIndex == -1) return weekDays;
//     return [
//       ...weekDays.sublist(todayIndex),
//       ...weekDays.sublist(0, todayIndex),
//     ];
//   }

//   String _getDaySuffix(int day) {
//     if (day >= 11 && day <= 13) return 'th';
//     switch (day % 10) {
//       case 1:
//         return 'st';
//       case 2:
//         return 'nd';
//       case 3:
//         return 'rd';
//       default:
//         return 'th';
//     }
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // BUILD
//   // ══════════════════════════════════════════════════════════════════════════

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     backgroundColor: const Color(0xFFF5F5F5),
//   //     appBar: _buildAppBar(),
//   //     body: RefreshIndicator(
//   //       onRefresh: () async {
//   //         await Future.wait([
//   //           _fetchFestivalPosters(
//   //             context.read<DateTimeProvider>().selectedDate,
//   //           ),
//   //           _fetchnewposters(),
//   //           _fetchWeeklyPosters(),
//   //           _fetchBanners(),
//   //           _fetchReels(),
//   //         ]);
//   //       },
//   //       color: const Color(0xFFFFC107),
//   //       child: CustomScrollView(
//   //         slivers: [
//   //           SliverToBoxAdapter(
//   //             child: Column(
//   //               crossAxisAlignment: CrossAxisAlignment.start,
//   //               children: [
//   //                 _buildSearchBar(),
//   //                 _buildBannerSection(),
//   //                 const SizedBox(height: 12),
//   //                 _buildForYouSection(), // StoriesWidget
//   //                 const SizedBox(height: 12),
//   //                 _buildUpcomingFestivalsSection(),
//   //                 _buildFestivalPostersSection(),
//   //                 const SizedBox(height: 12),
//   //                 _buildSectionHeader(
//   //                   titleKey: 'weekly_templates',
//   //                   subtitleKey: 'fresh_designs_everyday',
//   //                 ),
//   //                 _buildWeeklyPostersSection(),
//   //                 const SizedBox(height: 12),

//   //                 _buildHotTopicsSection(), // Reels from API
//   //                 const SizedBox(height: 12),
//   //                 _buildBirthdayAnniversarySection(),
//   //                 const SizedBox(height: 12),
//   //                 // _buildWeeklyPostersSection(),
//   //                 const SizedBox(height: 100),
//   //               ],
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: Stack(
//         children: [
//           /// 🔥 VIDEO BACKGROUND
//           // _controller.value.isInitialized
//           //     ? SizedBox.expand(
//           //         child: FittedBox(
//           //           fit: BoxFit.cover,
//           //           child: SizedBox(
//           //             width: _controller.value.size.width,
//           //             height: _controller.value.size.height,
//           //             child: VideoPlayer(_controller),
//           //           ),
//           //         ),
//           //       )
//           //     : Container(color: Colors.black),

//           /// 🔥 OPTIONAL DARK OVERLAY (for readability)
//           // Container(color: Colors.black.withOpacity(0.3)),

//           /// 🔥 YOUR ACTUAL UI
//           RefreshIndicator(
//             onRefresh: () async {
//               await Future.wait([
//                 _fetchFestivalPosters(
//                   context.read<DateTimeProvider>().selectedDate,
//                 ),
//                 _fetchnewposters(),
//                 _fetchWeeklyPosters(),
//                 _fetchBanners(),
//                 _fetchReels(),
//               ]);
//             },
//             color: const Color(0xFFFFC107),
//             child: CustomScrollView(
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSearchBar(),
//                       _buildBannerSection(),
//                       const SizedBox(height: 12),
//                       _buildForYouSection(),
//                       const SizedBox(height: 12),
//                       _buildUpcomingFestivalsSection(),
//                       _buildFestivalPostersSection(),
//                       const SizedBox(height: 12),
//                       _buildSectionHeader(
//                         titleKey: 'weekly_templates',
//                         subtitleKey: 'fresh_designs_everyday',
//                       ),
//                       _buildWeeklyPostersSection(),
//                       const SizedBox(height: 12),
//                       _buildHotTopicsSection(),
//                       const SizedBox(height: 12),
//                       _buildBirthdayAnniversarySection(),
//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // APP BAR  — yellow, profile image from API, notification badge, language
//   // ══════════════════════════════════════════════════════════════════════════

//   PreferredSizeWidget _buildAppBar() {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(64),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF448AFF),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           bottom: false,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               children: [
//                 // ── Profile Avatar (fetched from API like FancyAppBar) ─────
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProfileScreen()),
//                     );
//                     // final result = await Navigator.pushNamed(context, '/profile');
//                     // if (result == true) _fetchUserProfile(userId);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           blurRadius: 6,
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.white,
//                       backgroundImage:
//                           (userImage != null && userImage!.isNotEmpty)
//                           ? NetworkImage(userImage!) as ImageProvider
//                           : null,
//                       child: (userImage == null || userImage!.isEmpty)
//                           ? const Icon(
//                               Icons.person,
//                               color: Color(0xFFFFC107),
//                               size: 22,
//                             )
//                           : null,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),

//                 // ── Username + subtitle ────────────────────────────────────
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const AppText(
//                         'welcome_back',
//                         style: TextStyle(fontSize: 11, color: Colors.black54),
//                       ),
//                       Text(
//                         username ?? 'User',
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                           letterSpacing: 0.2,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),

//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.notifications_none_rounded,
//                         color: Colors.black87,
//                         size: 26,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PosterEditorScreen(
//                               posterAsset: "assets/ugadi.png",
//                             ),
//                           ),
//                         );
//                       },
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(
//                         minWidth: 38,
//                         minHeight: 38,
//                       ),
//                     ),
//                     Positioned(
//                       right: 4,
//                       top: 4,
//                       child: Container(
//                         width: 16,
//                         height: 16,
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Center(
//                           child: Text(
//                             '3',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // ── Notification badge ─────────────────────────────────────
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.notifications_none_rounded,
//                         color: Colors.black87,
//                         size: 26,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 NotificationScreen(userId: userId.toString()),
//                           ),
//                         );
//                       },
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(
//                         minWidth: 38,
//                         minHeight: 38,
//                       ),
//                     ),
//                     Positioned(
//                       right: 4,
//                       top: 4,
//                       child: Container(
//                         width: 16,
//                         height: 16,
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Center(
//                           child: Text(
//                             '3',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // ── Language (same dialog + transition as FancyAppBar) ─────
//                 GestureDetector(
//                   onTap: () => _showLanguageSelector(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(7),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.language_rounded,
//                       color: Colors.black87,
//                       size: 22,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // SEARCH BAR
//   // ══════════════════════════════════════════════════════════════════════════

//   // Widget _buildSearchBar() {
//   //   return Container(
//   //     color: Colors.white,
//   //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//   //     child: Container(
//   //       height: 44,
//   //       decoration: BoxDecoration(
//   //         color: const Color(0xFFF0F0F0),
//   //         borderRadius: BorderRadius.circular(10),
//   //         border: Border.all(color: const Color(0xFFE0E0E0)),
//   //       ),
//   //       child: Row(
//   //         children: [
//   //           const SizedBox(width: 10),
//   //           const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
//   //           const SizedBox(width: 8),
//   //           Expanded(
//   //             child: TextField(
//   //               controller: _searchController,
//   //               decoration: const InputDecoration(
//   //                 hintText: 'Search Posts by Topics',
//   //                 hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
//   //                 border: InputBorder.none,
//   //                 isDense: true,
//   //                 contentPadding: EdgeInsets.symmetric(vertical: 10),
//   //               ),
//   //               style: const TextStyle(fontSize: 14),
//   //             ),
//   //           ),
//   //           IconButton(
//   //             icon: const Icon(Icons.mic_rounded, color: Colors.grey, size: 20),
//   //             onPressed: () {},
//   //             padding: EdgeInsets.zero,
//   //             constraints: const BoxConstraints(),
//   //           ),
//   //           const SizedBox(width: 10),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildSearchBar() {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const SearchScreen()),
//         );
//       },
//       child: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         child: Container(
//           height: 44,
//           decoration: BoxDecoration(
//             color: const Color(0xFFF0F0F0),
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: const Color(0xFFE0E0E0)),
//           ),
//           child: Row(
//             children: [
//               const SizedBox(width: 10),
//               const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
//               const SizedBox(width: 8),

//               Expanded(
//                 child: AbsorbPointer(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       hintText: 'Search Posts by Topics',
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                       border: InputBorder.none,
//                       isDense: true,
//                       contentPadding: EdgeInsets.symmetric(vertical: 10),
//                     ),
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ),
//               ),

//               const Icon(Icons.mic_rounded, color: Colors.grey, size: 20),
//               const SizedBox(width: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // BANNER  — from /api/poster/getbanners
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildBannerSection() {
//     if (_isBannerLoading) {
//       return Container(
//         height: 150,
//         color: const Color(0xFFD32F2F),
//         child: const Center(
//           child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//         ),
//       );
//     }

//     final items = bannerList.isNotEmpty ? bannerList : null;

//     return Column(
//       children: [
//         SizedBox(
//           height: 120,
//           child: items != null
//               ? PageView.builder(
//                   controller: _bannerPageController,
//                   onPageChanged: (i) => setState(() => _currentBannerPage = i),
//                   itemCount: items.length,
//                   itemBuilder: (_, i) => _buildBannerItem(items[i]),
//                 )
//               : _buildFallbackBanner(),
//         ),
//         if (items != null && items.length > 1)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(items.length, (i) {
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 250),
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   width: _currentBannerPage == i ? 18 : 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(3),
//                     color: _currentBannerPage == i
//                         ? const Color(0xFFFFC107)
//                         : Colors.grey.shade300,
//                   ),
//                 );
//               }),
//             ),
//           ),
//       ],
//     );
//   }

//   // Widget _buildBannerItem(dynamic banner) {
//   //   final imageUrl =
//   //       (banner['images'] != null && (banner['images'] as List).isNotEmpty)
//   //       ? banner['images'][0]
//   //       : (banner['imageUrl'] ??
//   //             banner['image'] ??
//   //             banner['bannerImage'] ??
//   //             '');

//   //   return GestureDetector(
//   //     onTap: () {
//   //       if (banner['posterId'] != null) {
//   //         Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //             builder: (_) => SamplePosterScreen(posterId: banner['posterId']),
//   //           ),
//   //         );
//   //       }
//   //     },
//   //     child: Padding(
//   //       padding: const EdgeInsets.all(8.0),
//   //       child: Stack(
//   //         fit: StackFit.expand,
//   //         children: [
//   //           imageUrl.isNotEmpty
//   //               ? Image.network(
//   //                   imageUrl,
//   //                   fit: BoxFit.cover,
//   //                   errorBuilder: (_, __, ___) => _buildBannerGradient(),
//   //                   loadingBuilder: (_, child, progress) =>
//   //                       progress == null ? child : _buildBannerGradient(),
//   //                 )
//   //               : _buildBannerGradient(),

//   //           // Dim left side for text legibility
//   //           Container(
//   //             decoration: BoxDecoration(
//   //               gradient: LinearGradient(
//   //                 colors: [
//   //                   Colors.black.withOpacity(0.55),
//   //                   Colors.transparent,
//   //                   Colors.transparent,
//   //                 ],
//   //                 begin: Alignment.centerLeft,
//   //                 end: Alignment.centerRight,
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildBannerItem(dynamic banner) {
//     final imageUrl =
//         (banner['images'] != null && (banner['images'] as List).isNotEmpty)
//         ? banner['images'][0]
//         : (banner['imageUrl'] ??
//               banner['image'] ??
//               banner['bannerImage'] ??
//               '');

//     return GestureDetector(
//       onTap: () {
//         if (banner['posterId'] != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => SamplePosterScreen(posterId: banner['posterId']),
//             ),
//           );
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16), // Curve amount
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               imageUrl.isNotEmpty
//                   ? Image.network(
//                       imageUrl,
//                       fit: BoxFit.fill,
//                       errorBuilder: (_, __, ___) => _buildBannerGradient(),
//                       loadingBuilder: (_, child, progress) =>
//                           progress == null ? child : _buildBannerGradient(),
//                     )
//                   : _buildBannerGradient(),

//               // Dim left side for text legibility
//               Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.black.withOpacity(0.55),
//                       Colors.transparent,
//                       Colors.transparent,
//                     ],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBannerGradient() => Container(
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color.fromARGB(255, 126, 211, 47), Color(0xFFB71C1C)],
//       ),
//     ),
//   );

//   Widget _buildFallbackBanner() {
//     return Container(
//       height: 100,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFFB71C1C)],
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Wedding Count Down\nTemplates are ready!',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       height: 1.3,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFFC107),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'EXPLORE NOW',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 11,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         Icon(
//                           Icons.arrow_back_rounded,
//                           color: Colors.black,
//                           size: 13,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 5,
//             child: Row(
//               children: List.generate(
//                 3,
//                 (i) => Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.15),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Center(
//                       child: Icon(
//                         Icons.image_outlined,
//                         color: Colors.white54,
//                         size: 28,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // FOR YOU  — StoriesWidget only
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildForYouSection() {
//     return Container(
//       // color: const Color(0xFFFFFDE7),
//       padding: const EdgeInsets.symmetric(vertical: 1),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(left: 12, bottom: 1),
//             child: Text(
//               'Explore',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(221, 255, 255, 255),
//               ),
//             ),
//           ),
//           StoriesWidget(profile: userImage),
//         ],
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // UPCOMING FESTIVALS  — date selector
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildUpcomingFestivalsSection() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.only(top: 14, bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(left: 16, bottom: 10),
//             child: Text(
//               'Upcoming Festivals',
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Consumer<DateTimeProvider>(
//             builder: (_, dtp, __) => _buildDateSelector(dtp),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateSelector(DateTimeProvider dtp) {
//     final today = DateTime.now();
//     final dates = List.generate(7, (i) => today.add(Duration(days: i)));

//     return SizedBox(
//       height: 68,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: dates.length,
//         itemBuilder: (context, index) {
//           final date = dates[index];
//           final isSelected =
//               date.day == dtp.selectedDate.day &&
//               date.month == dtp.selectedDate.month;
//           final day = date.day.toString();
//           final suffix = _getDaySuffix(date.day);
//           final month = DateFormat('MMM').format(date);

//           return GestureDetector(
//             onTap: () {
//               dtp.setStartDate(date);
//               _fetchFestivalPosters(date);
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: 58,
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               decoration: BoxDecoration(
//                 color: isSelected ? Color(0xFF448AFF) : Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: isSelected
//                       ? const Color(0xFF448AFF)
//                       : Colors.grey.shade300,
//                 ),
//                 boxShadow: isSelected
//                     ? [
//                         BoxShadow(
//                           color: const Color(0xFFFFC107).withOpacity(0.35),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3),
//                         ),
//                       ]
//                     : [],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: day,
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.bold,
//                             color: isSelected ? Colors.black : Colors.black87,
//                           ),
//                         ),
//                         TextSpan(
//                           text: suffix,
//                           style: TextStyle(
//                             fontSize: 9,
//                             fontWeight: FontWeight.bold,
//                             color: isSelected ? Colors.black : Colors.black54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     month,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: isSelected ? Colors.black : Colors.black54,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // FESTIVAL POSTERS
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildFestivalPostersSection() {
//     if (_isLoading) {
//       return const SizedBox(
//         height: 155,
//         child: Center(
//           child: CircularProgressIndicator(color: Color(0xFFFFC107)),
//         ),
//       );
//     }
//     if (festivaldata.isEmpty) {
//       return Container(
//         height: 80,
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: const Center(
//           child: Text(
//             'No festivals for selected date',
//             style: TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//         ),
//       );
//     }
//     return SizedBox(
//       height: 155,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//         itemCount: festivaldata.length,
//         itemBuilder: (_, i) => _buildSmallPosterCard(festivaldata[i], i),
//       ),
//     );
//   }

//   Widget _buildSmallPosterCard(dynamic poster, int index) {
//     return GestureDetector(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) =>
//               SamplePosterScreen(posterId: poster['_id'] ?? poster['id']),
//         ),
//       ),
//       child: Container(
//         width: 110,
//         margin: const EdgeInsets.only(right: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(10),
//                 ),
//                 child: Image.network(
//                   poster['images'][0],
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) =>
//                       Container(color: const Color(0xFFF3F4F6)),
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;
//                     return Container(
//                       color: const Color(0xFFF3F4F6),
//                       child: const Center(
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Color(0xFFFFC107),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(7),
//               child: Text(
//                 poster['categoryName'] ?? 'Festival',
//                 style: const TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // HOT TOPICS / REELS  — auto-playing video, tap → ReelsScreen
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildHotTopicsSection() {
//     return Consumer<HotTopicReelsProvider>(
//       builder: (context, hotTopicProvider, _) {
//         return Container(
//           color: Colors.white,
//           padding: const EdgeInsets.only(top: 12, bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 2,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Hot Topics',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => _goToReelsScreen(0),
//                       child: const Text(
//                         'View All',
//                         style: TextStyle(
//                           color: Color(0xFFFFC107),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 180,
//                 child: hotTopicProvider.isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(
//                           color: Color(0xFFFFC107),
//                         ),
//                       )
//                     : hotTopicProvider.reels.isEmpty
//                     ? _buildReelPlaceholders()
//                     : ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         itemCount: hotTopicProvider.reels.length,
//                         itemBuilder: (_, i) =>
//                             _buildReelCard(hotTopicProvider.reels[i], i),
//                       ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBirthdayAnniversarySection() {
//     // Use posters from PosterProvider filtered by category name
//     return Consumer<PosterProvider>(
//       builder: (context, posterProvider, _) {
//         final allPosters = posterProvider.posters;

//         // Separate birthday and anniversary lists
//         final birthdayPosters = allPosters
//             .where(
//               (p) => (p.categoryName ?? '').toLowerCase().contains('birthday'),
//             )
//             .toList();

//         final anniversaryPosters = allPosters
//             .where(
//               (p) =>
//                   (p.categoryName ?? '').toLowerCase().contains(
//                     'anniversary',
//                   ) ||
//                   (p.categoryName ?? '').toLowerCase().contains('wedding'),
//             )
//             .toList();

//         // Don't render section if both lists are empty
//         if (birthdayPosters.isEmpty && anniversaryPosters.isEmpty) {
//           return const SizedBox.shrink();
//         }

//         return Container(
//           color: Colors.white,
//           padding: const EdgeInsets.only(top: 12, bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Birthday sub-section ──────────────────────────────────
//               if (birthdayPosters.isNotEmpty) ...[
//                 _buildCelebrationHeader(
//                   title: 'Birthday Posters',
//                   icon: Icons.cake_rounded,
//                   iconColor: const Color(0xFFE91E63),
//                   onViewAll: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => DetailsScreen(category: 'birthday'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 _buildCelebrationPosterList(birthdayPosters),
//                 const SizedBox(height: 14),
//               ],

//               // ── Anniversary sub-section ───────────────────────────────
//               if (anniversaryPosters.isNotEmpty) ...[
//                 _buildCelebrationHeader(
//                   title: 'Anniversary Posters',
//                   icon: Icons.favorite_rounded,
//                   iconColor: const Color(0xFFE53935),
//                   onViewAll: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => DetailsScreen(category: 'anniversary'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 _buildCelebrationPosterList(anniversaryPosters),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   /// Shared header row for Birthday / Anniversary sections
//   Widget _buildCelebrationHeader({
//     required String title,
//     required IconData icon,
//     required Color iconColor,
//     required VoidCallback onViewAll,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: iconColor, size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           // GestureDetector(
//           //   onTap: onViewAll,
//           //   child: const Text(
//           //     'View All',
//           //     style: TextStyle(
//           //       color: Color(0xFFFFC107),
//           //       fontSize: 13,
//           //       fontWeight: FontWeight.w600,
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   /// Horizontal poster list — same card size as weekly posters (110×140)
//   Widget _buildCelebrationPosterList(List<dynamic> posters) {
//     return SizedBox(
//       height: 140, // same as _buildWeeklyPosterCard
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: posters.length,
//         itemBuilder: (context, index) {
//           final poster = posters[index];
//           return Consumer<MyPlanProvider>(
//             builder: (context, myPlanProvider, _) {
//               return GestureDetector(
//                 onTap: () {
//                   if (myPlanProvider.isPurchase) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => SamplePosterScreen(posterId: poster.id),
//                       ),
//                     );
//                   } else {
//                     _showPremiumDialog();
//                   }
//                 },
//                 child: Container(
//                   width: 110, // same as weekly poster card
//                   margin: const EdgeInsets.only(right: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(10),
//                           ),
//                           child:
//                               poster.images != null && poster.images.isNotEmpty
//                               ? Image.network(
//                                   poster.images[0],
//                                   width: double.infinity,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) =>
//                                       Container(color: const Color(0xFFF3F4F6)),
//                                   loadingBuilder: (_, child, progress) {
//                                     if (progress == null) return child;
//                                     return Container(
//                                       color: const Color(0xFFF3F4F6),
//                                       child: const Center(
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           color: Color(0xFFFFC107),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 )
//                               : Container(color: const Color(0xFFF3F4F6)),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(6),
//                         child: Text(
//                           poster.categoryName ?? 'Poster',
//                           style: const TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   void _goToReelsScreen(int initialIndex) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => HotScreen(
//           // initialIndex: initialIndex,
//           // userId: userId ?? '',
//         ),
//       ),
//     );
//   }

//   Widget _buildReelCard(dynamic reel, int index) {
//     final isLiked = reel.isLiked ?? false;
//     final likeCount = reel.likeCount ?? 0;
//     final videoUrl = reel.videoUrl ?? '';

//     return GestureDetector(
//       onTap: () => _goToReelsScreen(index),
//       child: Container(
//         width: 105,
//         margin: const EdgeInsets.only(right: 10),
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Auto-playing muted video
//               _AutoPlayReelVideo(videoUrl: videoUrl),

//               // Bottom gradient overlay
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 52,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.75),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: const BorderRadius.vertical(
//                       bottom: Radius.circular(12),
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 7,
//                     vertical: 6,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Row(
//                         children: [
//                           // Icon(
//                           //   isLiked ? Icons.favorite : Icons.favorite_border,
//                           //   color: isLiked ? Colors.red : Colors.white70,
//                           //   size: 13,
//                           // ),
//                           const SizedBox(width: 3),
//                           // Text(
//                           //   '$likeCount',
//                           //   style: const TextStyle(
//                           //     color: Colors.white,
//                           //     fontSize: 10,
//                           //     fontWeight: FontWeight.bold,
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       const Icon(
//                         Icons.play_circle_fill_rounded,
//                         color: Colors.white70,
//                         size: 18,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Liked badge top-right
//               // if (isLiked)
//               //   Positioned(
//               //     top: 6,
//               //     right: 6,
//               //     child: Container(
//               //       padding: const EdgeInsets.all(3),
//               //       decoration: const BoxDecoration(
//               //         color: Colors.red,
//               //         shape: BoxShape.circle,
//               //       ),
//               //       child: const Icon(
//               //         Icons.favorite,
//               //         color: Colors.white,
//               //         size: 9,
//               //       ),
//               //     ),
//               //   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildReelPlaceholders() {
//     const gradients = [
//       [Color(0xFFFF7043), Color(0xFFFF5722)],
//       [Color(0xFF42A5F5), Color(0xFF1976D2)],
//       [Color(0xFF66BB6A), Color(0xFF388E3C)],
//       [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
//       [Color(0xFFFFCA28), Color(0xFFF57F17)],
//       [Color(0xFF26C6DA), Color(0xFF00838F)],
//     ];
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       itemCount: 6,
//       itemBuilder: (_, i) => Container(
//         width: 105,
//         margin: const EdgeInsets.only(right: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//             colors: gradients[i % gradients.length],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: const Center(
//           child: Icon(
//             Icons.play_circle_fill_rounded,
//             color: Colors.white54,
//             size: 34,
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // WEEKLY TEMPLATES
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildWeeklyPostersSection() {
//     if (weeklyPosters.isEmpty) return const SizedBox();
//     final orderedDays = _getOrderedDaysFromToday();
//     final today = DateFormat('EEEE').format(DateTime.now());

//     return Consumer<LanguageProvider>(
//       builder: (context, lp, _) {
//         final langCode = lp.locale.languageCode;
//         return Column(
//           children: orderedDays.map((day) {
//             final posters = weeklyPosters[day] ?? [];
//             if (posters.isEmpty) return const SizedBox.shrink();
//             final isToday = day == today;
//             final translatedDay = LocalizationService.translate(day, langCode);
//             final todayPrefix = LocalizationService.translate(
//               'today_prefix',
//               langCode,
//             );

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: isToday
//                           ? const LinearGradient(
//                               colors: [Color(0xFFFFC107), Color(0xFFFF8F00)],
//                             )
//                           : null,
//                       color: isToday ? null : Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           isToday
//                               ? Icons.today_rounded
//                               : Icons.calendar_today_outlined,
//                           size: 16,
//                           color: isToday ? Colors.black : Colors.grey,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           isToday
//                               ? '$todayPrefix - $translatedDay'
//                               : translatedDay,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: isToday ? Colors.black : Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 140,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     itemCount: posters.length,
//                     itemBuilder: (_, i) =>
//                         _buildWeeklyPosterCard(posters[i], i),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   Widget _buildWeeklyPosterCard(dynamic poster, int index) {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myplanprovider, _) {
//         return GestureDetector(
//           onTap: () {
//             if (myplanprovider.isPurchase) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => SamplePosterScreen(
//                     posterId: poster['_id'] ?? poster['id'],
//                   ),
//                 ),
//               );
//             } else {
//               _showPremiumDialog();
//             }
//           },
//           child: Container(
//             width: 110,
//             margin: const EdgeInsets.only(right: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(10),
//                     ),
//                     child: Image.network(
//                       poster['images']?[0] ?? '',
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) =>
//                           Container(color: const Color(0xFFF3F4F6)),
//                       loadingBuilder: (context, child, progress) {
//                         if (progress == null) return child;
//                         return Container(
//                           color: const Color(0xFFF3F4F6),
//                           child: const Center(
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Color(0xFFFFC107),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(6),
//                   child: Text(
//                     poster['categoryName'] ?? poster['name'] ?? 'Poster',
//                     style: const TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // SECTION HEADER
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildSectionHeader({
//     required String titleKey,
//     required String subtitleKey,
//     bool showViewAll = false,
//     VoidCallback? onViewAll,
//   }) {
//     return Consumer<LanguageProvider>(
//       builder: (context, lp, _) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     LocalizationService.translate(
//                       titleKey,
//                       lp.locale.languageCode,
//                     ),
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     LocalizationService.translate(
//                       subtitleKey,
//                       lp.locale.languageCode,
//                     ),
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               if (showViewAll && onViewAll != null)
//                 GestureDetector(
//                   onTap: onViewAll,
//                   child: const Text(
//                     'View All',
//                     style: TextStyle(
//                       color: Color(0xFFFFC107),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // LANGUAGE SELECTOR  — exact same dialog + LanguageTransitionScreen as FancyAppBar
//   // ══════════════════════════════════════════════════════════════════════════

//   void _showLanguageSelector(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Select Language',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildLangOption(
//                 context,
//                 dialogContext,
//                 'English',
//                 'en',
//                 Icons.language,
//               ),
//               const SizedBox(height: 12),
//               _buildLangOption(
//                 context,
//                 dialogContext,
//                 'हिंदी',
//                 'hi',
//                 Icons.translate,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLangOption(
//     BuildContext context,
//     BuildContext dialogContext,
//     String name,
//     String code,
//     IconData icon,
//   ) {
//     final lp = Provider.of<LanguageProvider>(context, listen: true);
//     final isSelected = lp.locale.languageCode == code;

//     return InkWell(
//       // Mirrors FancyAppBar: overlay → setLocale → restartApp
//       onTap: () async {
//         Navigator.pop(dialogContext);

//         late OverlayEntry overlayEntry;
//         overlayEntry = OverlayEntry(
//           builder: (overlayContext) => LanguageTransitionScreen(
//             languageName: name,
//             languageCode: code,
//             onComplete: () async {
//               final lp2 = Provider.of<LanguageProvider>(context, listen: false);
//               await lp2.setLocale(Locale(code));
//               overlayEntry.remove();
//               AppRestartService.restartApp(context);
//             },
//           ),
//         );
//         Overlay.of(context).insert(overlayEntry);
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Colors.white.withOpacity(0.3)
//               : Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 24),
//             const SizedBox(width: 12),
//             Text(
//               name,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//             const Spacer(),
//             if (isSelected)
//               const Icon(Icons.check_circle, color: Colors.white, size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // PREMIUM DIALOG
//   // ══════════════════════════════════════════════════════════════════════════

//   void _showPremiumDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFFFAF5FF), Color(0xFFEEF2FF)],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
//                   ),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF6366F1).withOpacity(0.3),
//                       blurRadius: 16,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.workspace_premium,
//                   color: Colors.white,
//                   size: 32,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Unlock Premium',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Get access to exclusive templates and premium features.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF6B7280),
//                   height: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: const BorderSide(color: Color(0xFFE5E7EB)),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Maybe Later',
//                         style: TextStyle(
//                           color: Color(0xFF6B7280),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => SubscriptionPlansPage(),
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: const Color(0xFF6366F1),
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Upgrade Now',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // REFER & EARN MODAL  — identical to original
//   // ══════════════════════════════════════════════════════════════════════════

//   void showReferAndEarnModal(BuildContext context) {
//     String? uid;
//     String? userReferralCode;
//     bool isLoading = true;
//     String? errorMessage;

//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: 'Refer and Earn',
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (_, __, ___) => const SizedBox.shrink(),
//       transitionBuilder: (context, animation, __, ___) {
//         return FadeTransition(
//           opacity: animation,
//           child: ScaleTransition(
//             scale: Tween<double>(begin: 0.95, end: 1.0).animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeOut),
//             ),
//             child: Center(
//               child: Material(
//                 color: Colors.transparent,
//                 child: StatefulBuilder(
//                   builder: (context, setModalState) {
//                     Future<void> loadReferralCode() async {
//                       try {
//                         setModalState(() {
//                           isLoading = true;
//                           errorMessage = null;
//                         });
//                         final userData = await AuthPreferences.getUserData();
//                         if (userData != null) {
//                           uid = userData.user.id;
//                           final response = await http.get(
//                             Uri.parse(
//                               'http://31.97.206.144:4061/api/users/refferalcode/$uid',
//                             ),
//                           );
//                           if (response.statusCode == 200) {
//                             final data = json.decode(response.body);
//                             final code =
//                                 data['referralCode'] ??
//                                 data['refferalCode'] ??
//                                 data['code'];
//                             setModalState(() {
//                               isLoading = false;
//                               userReferralCode = code;
//                               errorMessage = code == null
//                                   ? 'No referral code found'
//                                   : null;
//                             });
//                           } else {
//                             setModalState(() {
//                               isLoading = false;
//                               errorMessage = 'Failed to load referral code';
//                             });
//                           }
//                         }
//                       } catch (e) {
//                         setModalState(() {
//                           isLoading = false;
//                           errorMessage = 'Error: $e';
//                         });
//                       }
//                     }

//                     void shareCode() {
//                       if (userReferralCode != null) {
//                         Share.share(
//                           '🎉 Join me on EditEzy!\n\nUse my referral code: $userReferralCode\n\nGet exclusive benefits when you upgrade!\n\nhttps://play.google.com/store/apps/details?id=com.posternova.posternova',
//                           subject: 'Join EditEzy',
//                         );
//                       }
//                     }

//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       if (isLoading &&
//                           userReferralCode == null &&
//                           errorMessage == null) {
//                         loadReferralCode();
//                       }
//                     });

//                     return _FlippableReferModal(
//                       isLoading: isLoading,
//                       errorMessage: errorMessage,
//                       userReferralCode: userReferralCode,
//                       onLoadReferralCode: loadReferralCode,
//                       onShare: shareCode,
//                       onClose: () => Navigator.pop(context),
//                       onCopy: () {
//                         if (userReferralCode != null) {
//                           Clipboard.setData(
//                             ClipboardData(text: userReferralCode!),
//                           );
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Referral code copied!'),
//                               behavior: SnackBarBehavior.floating,
//                               backgroundColor: Color(0xFF10B981),
//                             ),
//                           );
//                         } else {
//                           loadReferralCode();
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   //   void showReferAndEarnModal(BuildContext context) {
//   //   String? uid;
//   //   String? userReferralCode;
//   //   bool isLoading = true;
//   //   String? errorMessage;
//   //   bool isFlipped = false;

//   //   showGeneralDialog(
//   //     context: context,
//   //     barrierDismissible: true,
//   //     barrierLabel: 'Refer and Earn',
//   //     barrierColor: Colors.black.withOpacity(0.5),
//   //     transitionDuration: const Duration(milliseconds: 300),
//   //     pageBuilder: (_, __, ___) => const SizedBox.shrink(),
//   //     transitionBuilder: (context, animation, __, ___) {
//   //       return FadeTransition(
//   //         opacity: animation,
//   //         child: ScaleTransition(
//   //           scale: Tween<double>(begin: 0.95, end: 1.0).animate(
//   //             CurvedAnimation(parent: animation, curve: Curves.easeOut),
//   //           ),
//   //           child: Center(
//   //             child: Material(
//   //               color: Colors.transparent,
//   //               child: StatefulBuilder(
//   //                 builder: (context, setModalState) {
//   //                   Future<void> loadReferralCode() async {
//   //                     try {
//   //                       setModalState(() {
//   //                         isLoading = true;
//   //                         errorMessage = null;
//   //                       });
//   //                       final userData = await AuthPreferences.getUserData();
//   //                       if (userData != null) {
//   //                         uid = userData.user.id;
//   //                         final response = await http.get(
//   //                           Uri.parse(
//   //                             'http://31.97.206.144:4061/api/users/refferalcode/$uid',
//   //                           ),
//   //                         );
//   //                         if (response.statusCode == 200) {
//   //                           final data = json.decode(response.body);
//   //                           final code =
//   //                               data['referralCode'] ??
//   //                               data['refferalCode'] ??
//   //                               data['code'];
//   //                           setModalState(() {
//   //                             isLoading = false;
//   //                             userReferralCode = code;
//   //                             errorMessage =
//   //                                 code == null ? 'No referral code found' : null;
//   //                           });
//   //                         } else {
//   //                           setModalState(() {
//   //                             isLoading = false;
//   //                             errorMessage = 'Failed to load referral code';
//   //                           });
//   //                         }
//   //                       }
//   //                     } catch (e) {
//   //                       setModalState(() {
//   //                         isLoading = false;
//   //                         errorMessage = 'Error: $e';
//   //                       });
//   //                     }
//   //                   }

//   //                   void shareCode() {
//   //                     if (userReferralCode != null) {
//   //                       Share.share(
//   //                         '🎉 Join me on EditEzy!\n\nUse my referral code: $userReferralCode\n\nGet exclusive benefits when you upgrade!\n\nhttps://play.google.com/store/apps/details?id=com.posternova.posternova',
//   //                         subject: 'Join EditEzy',
//   //                       );
//   //                     }
//   //                   }

//   //                   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //                     if (isLoading &&
//   //                         userReferralCode == null &&
//   //                         errorMessage == null) {
//   //                       loadReferralCode();
//   //                     }
//   //                   });

//   //                   return Scaffold(
//   //                     backgroundColor: Colors.transparent,
//   //                     body: Center(
//   //                       child: Container(
//   //                         margin: const EdgeInsets.symmetric(horizontal: 24),
//   //                         constraints: BoxConstraints(
//   //                           maxWidth: 500,
//   //                         ),
//   //                         decoration: BoxDecoration(
//   //                           color: Colors.white,
//   //                           borderRadius: BorderRadius.circular(16),
//   //                           boxShadow: [
//   //                             BoxShadow(
//   //                               color: Colors.black.withOpacity(0.1),
//   //                               blurRadius: 20,
//   //                             ),
//   //                           ],
//   //                         ),
//   //                         child: ClipRRect(
//   //                           borderRadius: BorderRadius.circular(16),
//   //                           child: Column(
//   //                             mainAxisSize: MainAxisSize.min,
//   //                             children: [
//   //                               // ── Header ───────────────────────────────────
//   //                               Container(
//   //                                 padding: const EdgeInsets.symmetric(
//   //                                   horizontal: 20,
//   //                                   vertical: 16,
//   //                                 ),
//   //                                 decoration: BoxDecoration(
//   //                                   color: Colors.grey[50],
//   //                                   border: Border(
//   //                                     bottom:
//   //                                         BorderSide(color: Colors.grey[200]!),
//   //                                   ),
//   //                                 ),
//   //                                 child: Row(
//   //                                   children: [
//   //                                     Container(
//   //                                       padding: const EdgeInsets.all(8),
//   //                                       decoration: BoxDecoration(
//   //                                         color: const Color(
//   //                                           0xFF4F46E5,
//   //                                         ).withOpacity(0.1),
//   //                                         borderRadius: BorderRadius.circular(8),
//   //                                       ),
//   //                                       child: const Icon(
//   //                                         Icons.people_outline,
//   //                                         color: Color(0xFF4F46E5),
//   //                                         size: 24,
//   //                                       ),
//   //                                     ),
//   //                                     const SizedBox(width: 12),
//   //                                     const Expanded(
//   //                                       child: AppText(
//   //                                         'refer_earn',
//   //                                         style: TextStyle(
//   //                                           fontSize: 20,
//   //                                           fontWeight: FontWeight.w600,
//   //                                           color: Color(0xFF111827),
//   //                                         ),
//   //                                       ),
//   //                                     ),
//   //                                     IconButton(
//   //                                       onPressed: () => Navigator.pop(context),
//   //                                       icon:
//   //                                           const Icon(Icons.close, size: 24),
//   //                                       color: Colors.grey[600],
//   //                                       padding: EdgeInsets.zero,
//   //                                       constraints: const BoxConstraints(),
//   //                                     ),
//   //                                   ],
//   //                                 ),
//   //                               ),

//   //                               // ── Flip indicator tabs ───────────────────────
//   //                               Padding(
//   //                                 padding: const EdgeInsets.fromLTRB(
//   //                                     20, 16, 20, 0),
//   //                                 child: Row(
//   //                                   children: [
//   //                                     Expanded(
//   //                                       child: GestureDetector(
//   //                                         onTap: () => setModalState(
//   //                                             () => isFlipped = false),
//   //                                         child: AnimatedContainer(
//   //                                           duration: const Duration(
//   //                                               milliseconds: 250),
//   //                                           padding: const EdgeInsets.symmetric(
//   //                                               vertical: 8),
//   //                                           decoration: BoxDecoration(
//   //                                             color: !isFlipped
//   //                                                 ? const Color(0xFF4F46E5)
//   //                                                 : Colors.grey[100],
//   //                                             borderRadius:
//   //                                                 BorderRadius.circular(8),
//   //                                           ),
//   //                                           child: Text(
//   //                                             'My Code',
//   //                                             textAlign: TextAlign.center,
//   //                                             style: TextStyle(
//   //                                               fontSize: 13,
//   //                                               fontWeight: FontWeight.w600,
//   //                                               color: !isFlipped
//   //                                                   ? Colors.white
//   //                                                   : Colors.grey[500],
//   //                                             ),
//   //                                           ),
//   //                                         ),
//   //                                       ),
//   //                                     ),
//   //                                     const SizedBox(width: 8),
//   //                                     Expanded(
//   //                                       child: GestureDetector(
//   //                                         onTap: () => setModalState(
//   //                                             () => isFlipped = true),
//   //                                         child: AnimatedContainer(
//   //                                           duration: const Duration(
//   //                                               milliseconds: 250),
//   //                                           padding: const EdgeInsets.symmetric(
//   //                                               vertical: 8),
//   //                                           decoration: BoxDecoration(
//   //                                             color: isFlipped
//   //                                                 ? const Color(0xFF4F46E5)
//   //                                                 : Colors.grey[100],
//   //                                             borderRadius:
//   //                                                 BorderRadius.circular(8),
//   //                                           ),
//   //                                           child: Text(
//   //                                             'How It Works',
//   //                                             textAlign: TextAlign.center,
//   //                                             style: TextStyle(
//   //                                               fontSize: 13,
//   //                                               fontWeight: FontWeight.w600,
//   //                                               color: isFlipped
//   //                                                   ? Colors.white
//   //                                                   : Colors.grey[500],
//   //                                             ),
//   //                                           ),
//   //                                         ),
//   //                                       ),
//   //                                     ),
//   //                                   ],
//   //                                 ),
//   //                               ),

//   //                               // ── Flipping content ──────────────────────────
//   //                               Padding(
//   //                                 padding: const EdgeInsets.all(20),
//   //                                 child: AnimatedSwitcher(
//   //                                   duration:
//   //                                       const Duration(milliseconds: 350),
//   //                                   transitionBuilder: (child, anim) {
//   //                                     final offset = isFlipped
//   //                                         ? const Offset(1, 0)
//   //                                         : const Offset(-1, 0);
//   //                                     return SlideTransition(
//   //                                       position: Tween<Offset>(
//   //                                         begin: offset,
//   //                                         end: Offset.zero,
//   //                                       ).animate(CurvedAnimation(
//   //                                         parent: anim,
//   //                                         curve: Curves.easeOut,
//   //                                       )),
//   //                                       child: FadeTransition(
//   //                                           opacity: anim, child: child),
//   //                                     );
//   //                                   },
//   //                                   child: isFlipped
//   //                                       ? _buildHowItWorksPanel()
//   //                                       : _buildMyCodePanel(
//   //                                           isLoading,
//   //                                           errorMessage,
//   //                                           userReferralCode,
//   //                                           loadReferralCode,
//   //                                         ),
//   //                                 ),
//   //                               ),

//   //                               // ── Common action buttons ─────────────────────
//   //                               Padding(
//   //                                 padding: const EdgeInsets.fromLTRB(
//   //                                     20, 0, 20, 20),
//   //                                 child: Row(
//   //                                   children: [
//   //                                     Expanded(
//   //                                       child: ElevatedButton.icon(
//   //                                         onPressed: () {
//   //                                           if (userReferralCode != null) {
//   //                                             Clipboard.setData(ClipboardData(
//   //                                                 text: userReferralCode!));
//   //                                             ScaffoldMessenger.of(context)
//   //                                                 .showSnackBar(
//   //                                               const SnackBar(
//   //                                                 content:
//   //                                                     Text('Referral code copied!'),
//   //                                                 behavior:
//   //                                                     SnackBarBehavior.floating,
//   //                                                 backgroundColor:
//   //                                                     Color(0xFF10B981),
//   //                                               ),
//   //                                             );
//   //                                           } else {
//   //                                             loadReferralCode();
//   //                                           }
//   //                                         },
//   //                                         icon: const Icon(Icons.copy, size: 20),
//   //                                         label: const Text('Copy Code'),
//   //                                         style: ElevatedButton.styleFrom(
//   //                                           backgroundColor:
//   //                                               const Color(0xFF4F46E5),
//   //                                           foregroundColor: Colors.white,
//   //                                           padding: const EdgeInsets.symmetric(
//   //                                               vertical: 14),
//   //                                           shape: RoundedRectangleBorder(
//   //                                             borderRadius:
//   //                                                 BorderRadius.circular(10),
//   //                                           ),
//   //                                           elevation: 0,
//   //                                         ),
//   //                                       ),
//   //                                     ),
//   //                                     const SizedBox(width: 12),
//   //                                     Expanded(
//   //                                       child: ElevatedButton.icon(
//   //                                         onPressed: userReferralCode != null
//   //                                             ? shareCode
//   //                                             : null,
//   //                                         icon:
//   //                                             const Icon(Icons.share, size: 20),
//   //                                         label: const Text('Share'),
//   //                                         style: ElevatedButton.styleFrom(
//   //                                           backgroundColor:
//   //                                               const Color(0xFF10B981),
//   //                                           foregroundColor: Colors.white,
//   //                                           disabledBackgroundColor:
//   //                                               Colors.grey[300],
//   //                                           padding: const EdgeInsets.symmetric(
//   //                                               vertical: 14),
//   //                                           shape: RoundedRectangleBorder(
//   //                                             borderRadius:
//   //                                                 BorderRadius.circular(10),
//   //                                           ),
//   //                                           elevation: 0,
//   //                                         ),
//   //                                       ),
//   //                                     ),
//   //                                   ],
//   //                                 ),
//   //                               ),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   );
//   //                 },
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   // // ── Front face: My Code ────────────────────────────────────────────────────
//   // Widget _buildMyCodePanel(
//   //   bool isLoading,
//   //   String? errorMessage,
//   //   String? userReferralCode,
//   //   VoidCallback loadReferralCode,
//   // ) {
//   //   return Column(
//   //     key: const ValueKey('front'),
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Container(
//   //         width: double.infinity,
//   //         padding: const EdgeInsets.all(16),
//   //         decoration: BoxDecoration(
//   //           color: const Color(0xFFF0F9FF),
//   //           borderRadius: BorderRadius.circular(12),
//   //           border: Border.all(color: const Color(0xFFBAE6FD)),
//   //         ),
//   //         child: Row(
//   //           children: [
//   //             Container(
//   //               padding: const EdgeInsets.all(8),
//   //               decoration: BoxDecoration(
//   //                 color: const Color(0xFF0EA5E9),
//   //                 borderRadius: BorderRadius.circular(8),
//   //               ),
//   //               child: const Icon(Icons.info_outline,
//   //                   color: Colors.white, size: 20),
//   //             ),
//   //             const SizedBox(width: 12),
//   //             const Expanded(
//   //               child: AppText(
//   //                 'share_referral_earn',
//   //                 style: TextStyle(
//   //                     fontSize: 14,
//   //                     color: Color(0xFF0C4A6E),
//   //                     height: 1.4),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       const SizedBox(height: 20),
//   //       const AppText(
//   //         'your_referral_code',
//   //         style: TextStyle(
//   //             fontSize: 14,
//   //             fontWeight: FontWeight.w600,
//   //             color: Color(0xFF374151)),
//   //       ),
//   //       const SizedBox(height: 12),
//   //       AnimatedSwitcher(
//   //         duration: const Duration(milliseconds: 300),
//   //         child: isLoading
//   //             ? Container(
//   //                 key: const ValueKey('loading'),
//   //                 padding: const EdgeInsets.all(20),
//   //                 decoration: BoxDecoration(
//   //                   color: Colors.grey[50],
//   //                   borderRadius: BorderRadius.circular(12),
//   //                   border: Border.all(color: Colors.grey[200]!),
//   //                 ),
//   //                 child: const Row(
//   //                   mainAxisAlignment: MainAxisAlignment.center,
//   //                   children: [
//   //                     SizedBox(
//   //                       width: 20,
//   //                       height: 20,
//   //                       child: CircularProgressIndicator(
//   //                           strokeWidth: 2,
//   //                           color: Color(0xFF4F46E5)),
//   //                     ),
//   //                     SizedBox(width: 12),
//   //                     Text('Loading...',
//   //                         style: TextStyle(
//   //                             fontSize: 14, color: Color(0xFF6B7280))),
//   //                   ],
//   //                 ),
//   //               )
//   //             : errorMessage != null
//   //                 ? Container(
//   //                     key: const ValueKey('error'),
//   //                     padding: const EdgeInsets.all(16),
//   //                     decoration: BoxDecoration(
//   //                       color: const Color(0xFFFEF2F2),
//   //                       borderRadius: BorderRadius.circular(12),
//   //                       border: Border.all(color: const Color(0xFFFECACA)),
//   //                     ),
//   //                     child: Row(
//   //                       children: [
//   //                         const Icon(Icons.error_outline,
//   //                             color: Color(0xFFEF4444), size: 20),
//   //                         const SizedBox(width: 8),
//   //                         Expanded(
//   //                           child: Text(errorMessage,
//   //                               style: const TextStyle(
//   //                                   fontSize: 14,
//   //                                   color: Color(0xFF991B1B))),
//   //                         ),
//   //                         TextButton(
//   //                           onPressed: loadReferralCode,
//   //                           child: const Text('Retry'),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                   )
//   //                 : Container(
//   //                     key: const ValueKey('code'),
//   //                     padding: const EdgeInsets.all(16),
//   //                     decoration: BoxDecoration(
//   //                       color: Colors.grey[50],
//   //                       borderRadius: BorderRadius.circular(12),
//   //                       border: Border.all(color: Colors.grey[300]!),
//   //                     ),
//   //                     child: Row(
//   //                       children: [
//   //                         Expanded(
//   //                           child: Column(
//   //                             crossAxisAlignment: CrossAxisAlignment.start,
//   //                             children: [
//   //                               Text(
//   //                                 userReferralCode ?? '--',
//   //                                 style: const TextStyle(
//   //                                   fontSize: 28,
//   //                                   fontWeight: FontWeight.w700,
//   //                                   letterSpacing: 3,
//   //                                   color: Color(0xFF4F46E5),
//   //                                 ),
//   //                               ),
//   //                               const Text('Tap Copy to share',
//   //                                   style: TextStyle(
//   //                                       fontSize: 12,
//   //                                       color: Color(0xFF6B7280))),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         const Icon(Icons.card_giftcard_rounded,
//   //                             color: Color(0xFF4F46E5), size: 36),
//   //                       ],
//   //                     ),
//   //                   ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // // ── Back face: How It Works ────────────────────────────────────────────────
//   // Widget _buildHowItWorksPanel() {
//   //   return Column(
//   //     key: const ValueKey('back'),
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       const AppText(
//   //         'how_it_works',
//   //         style: TextStyle(
//   //             fontSize: 16,
//   //             fontWeight: FontWeight.w600,
//   //             color: Color(0xFF374151)),
//   //       ),
//   //       const SizedBox(height: 16),
//   //       _referStep('1', 'share_your_code', 'send_referral_any_platform'),
//   //       const SizedBox(height: 14),
//   //       _referStep('2', 'friend_signs_up', 'enter_code_during_signup'),
//   //       const SizedBox(height: 14),
//   //       _referStep('3', 'earn_rewards', 'get_200_on_upgrade'),
//   //       const SizedBox(height: 8),
//   //     ],
//   //   );
//   // }

//   // void showReferAndEarnModal(BuildContext context) {
//   //   String? uid;
//   //   String? userReferralCode;
//   //   bool isLoading = true;
//   //   String? errorMessage;

//   //   showGeneralDialog(
//   //     context: context,
//   //     barrierDismissible: true,
//   //     barrierLabel: 'Refer and Earn',
//   //     barrierColor: Colors.black.withOpacity(0.5),
//   //     transitionDuration: const Duration(milliseconds: 300),
//   //     pageBuilder: (_, __, ___) => const SizedBox.shrink(),
//   //     transitionBuilder: (context, animation, __, ___) {
//   //       return FadeTransition(
//   //         opacity: animation,
//   //         child: ScaleTransition(
//   //           scale: Tween<double>(begin: 0.95, end: 1.0).animate(
//   //             CurvedAnimation(parent: animation, curve: Curves.easeOut),
//   //           ),
//   //           child: Center(
//   //             child: Material(
//   //               color: Colors.transparent,
//   //               child: StatefulBuilder(
//   //                 builder: (context, setModalState) {
//   //                   Future<void> loadReferralCode() async {
//   //                     try {
//   //                       setModalState(() {
//   //                         isLoading = true;
//   //                         errorMessage = null;
//   //                       });
//   //                       final userData = await AuthPreferences.getUserData();
//   //                       if (userData != null) {
//   //                         uid = userData.user.id;
//   //                         final response = await http.get(
//   //                           Uri.parse(
//   //                             'http://31.97.206.144:4061/api/users/refferalcode/$uid',
//   //                           ),
//   //                         );
//   //                         if (response.statusCode == 200) {
//   //                           final data = json.decode(response.body);
//   //                           final code =
//   //                               data['referralCode'] ??
//   //                               data['refferalCode'] ??
//   //                               data['code'];
//   //                           setModalState(() {
//   //                             isLoading = false;
//   //                             userReferralCode = code;
//   //                             errorMessage = code == null
//   //                                 ? 'No referral code found'
//   //                                 : null;
//   //                           });
//   //                         } else {
//   //                           setModalState(() {
//   //                             isLoading = false;
//   //                             errorMessage = 'Failed to load referral code';
//   //                           });
//   //                         }
//   //                       }
//   //                     } catch (e) {
//   //                       setModalState(() {
//   //                         isLoading = false;
//   //                         errorMessage = 'Error: $e';
//   //                       });
//   //                     }
//   //                   }

//   //                   void shareCode() {
//   //                     if (userReferralCode != null) {
//   //                       Share.share(
//   //                         '🎉 Join me on EditEzy!\n\nUse my referral code: $userReferralCode\n\nGet exclusive benefits when you upgrade!\n\nhttps://play.google.com/store/apps/details?id=com.posternova.posternova',
//   //                         subject: 'Join EditEzy',
//   //                       );
//   //                     }
//   //                   }

//   //                   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //                     if (isLoading &&
//   //                         userReferralCode == null &&
//   //                         errorMessage == null) {
//   //                       loadReferralCode();
//   //                     }
//   //                   });

//   //                   return Scaffold(
//   //                     backgroundColor: Colors.transparent,
//   //                     body: Center(
//   //                       child: Container(
//   //                         margin: const EdgeInsets.symmetric(horizontal: 24),
//   //                         constraints: BoxConstraints(
//   //                           maxHeight: MediaQuery.of(context).size.height * 0.8,
//   //                           maxWidth: 500,
//   //                         ),
//   //                         decoration: BoxDecoration(
//   //                           color: Colors.white,
//   //                           borderRadius: BorderRadius.circular(16),
//   //                           boxShadow: [
//   //                             BoxShadow(
//   //                               color: Colors.black.withOpacity(0.1),
//   //                               blurRadius: 20,
//   //                             ),
//   //                           ],
//   //                         ),
//   //                         child: ClipRRect(
//   //                           borderRadius: BorderRadius.circular(16),
//   //                           child: Column(
//   //                             mainAxisSize: MainAxisSize.min,
//   //                             children: [
//   //                               // Header
//   //                               Container(
//   //                                 padding: const EdgeInsets.symmetric(
//   //                                   horizontal: 20,
//   //                                   vertical: 16,
//   //                                 ),
//   //                                 decoration: BoxDecoration(
//   //                                   color: Colors.grey[50],
//   //                                   border: Border(
//   //                                     bottom: BorderSide(
//   //                                       color: Colors.grey[200]!,
//   //                                     ),
//   //                                   ),
//   //                                 ),
//   //                                 child: Row(
//   //                                   children: [
//   //                                     Container(
//   //                                       padding: const EdgeInsets.all(8),
//   //                                       decoration: BoxDecoration(
//   //                                         color: const Color(
//   //                                           0xFF4F46E5,
//   //                                         ).withOpacity(0.1),
//   //                                         borderRadius: BorderRadius.circular(
//   //                                           8,
//   //                                         ),
//   //                                       ),
//   //                                       child: const Icon(
//   //                                         Icons.people_outline,
//   //                                         color: Color(0xFF4F46E5),
//   //                                         size: 24,
//   //                                       ),
//   //                                     ),
//   //                                     const SizedBox(width: 12),
//   //                                     const Expanded(
//   //                                       child: AppText(
//   //                                         'refer_earn',
//   //                                         style: TextStyle(
//   //                                           fontSize: 20,
//   //                                           fontWeight: FontWeight.w600,
//   //                                           color: Color(0xFF111827),
//   //                                         ),
//   //                                       ),
//   //                                     ),
//   //                                     IconButton(
//   //                                       onPressed: () => Navigator.pop(context),
//   //                                       icon: const Icon(Icons.close, size: 24),
//   //                                       color: Colors.grey[600],
//   //                                       padding: EdgeInsets.zero,
//   //                                       constraints: const BoxConstraints(),
//   //                                     ),
//   //                                   ],
//   //                                 ),
//   //                               ),
//   //                               // Content
//   //                               Flexible(
//   //                                 child: SingleChildScrollView(
//   //                                   padding: const EdgeInsets.all(24),
//   //                                   child: Column(
//   //                                     crossAxisAlignment:
//   //                                         CrossAxisAlignment.start,
//   //                                     children: [
//   //                                       Container(
//   //                                         width: double.infinity,
//   //                                         padding: const EdgeInsets.all(16),
//   //                                         decoration: BoxDecoration(
//   //                                           color: const Color(0xFFF0F9FF),
//   //                                           borderRadius: BorderRadius.circular(
//   //                                             12,
//   //                                           ),
//   //                                           border: Border.all(
//   //                                             color: const Color(0xFFBAE6FD),
//   //                                           ),
//   //                                         ),
//   //                                         child: Row(
//   //                                           children: [
//   //                                             Container(
//   //                                               padding: const EdgeInsets.all(
//   //                                                 8,
//   //                                               ),
//   //                                               decoration: BoxDecoration(
//   //                                                 color: const Color(
//   //                                                   0xFF0EA5E9,
//   //                                                 ),
//   //                                                 borderRadius:
//   //                                                     BorderRadius.circular(8),
//   //                                               ),
//   //                                               child: const Icon(
//   //                                                 Icons.info_outline,
//   //                                                 color: Colors.white,
//   //                                                 size: 20,
//   //                                               ),
//   //                                             ),
//   //                                             const SizedBox(width: 12),
//   //                                             const Expanded(
//   //                                               child: AppText(
//   //                                                 'share_referral_earn',
//   //                                                 style: TextStyle(
//   //                                                   fontSize: 14,
//   //                                                   color: Color(0xFF0C4A6E),
//   //                                                   height: 1.4,
//   //                                                 ),
//   //                                               ),
//   //                                             ),
//   //                                           ],
//   //                                         ),
//   //                                       ),
//   //                                       const SizedBox(height: 24),
//   //                                       const AppText(
//   //                                         'your_referral_code',
//   //                                         style: TextStyle(
//   //                                           fontSize: 14,
//   //                                           fontWeight: FontWeight.w600,
//   //                                           color: Color(0xFF374151),
//   //                                         ),
//   //                                       ),
//   //                                       const SizedBox(height: 12),
//   //                                       AnimatedSwitcher(
//   //                                         duration: const Duration(
//   //                                           milliseconds: 300,
//   //                                         ),
//   //                                         child: isLoading
//   //                                             ? Container(
//   //                                                 key: const ValueKey(
//   //                                                   'loading',
//   //                                                 ),
//   //                                                 padding: const EdgeInsets.all(
//   //                                                   20,
//   //                                                 ),
//   //                                                 decoration: BoxDecoration(
//   //                                                   color: Colors.grey[50],
//   //                                                   borderRadius:
//   //                                                       BorderRadius.circular(
//   //                                                         12,
//   //                                                       ),
//   //                                                   border: Border.all(
//   //                                                     color: Colors.grey[200]!,
//   //                                                   ),
//   //                                                 ),
//   //                                                 child: const Row(
//   //                                                   mainAxisAlignment:
//   //                                                       MainAxisAlignment
//   //                                                           .center,
//   //                                                   children: [
//   //                                                     SizedBox(
//   //                                                       width: 20,
//   //                                                       height: 20,
//   //                                                       child:
//   //                                                           CircularProgressIndicator(
//   //                                                             strokeWidth: 2,
//   //                                                             color: Color(
//   //                                                               0xFF4F46E5,
//   //                                                             ),
//   //                                                           ),
//   //                                                     ),
//   //                                                     SizedBox(width: 12),
//   //                                                     Text(
//   //                                                       'Loading...',
//   //                                                       style: TextStyle(
//   //                                                         fontSize: 14,
//   //                                                         color: Color(
//   //                                                           0xFF6B7280,
//   //                                                         ),
//   //                                                       ),
//   //                                                     ),
//   //                                                   ],
//   //                                                 ),
//   //                                               )
//   //                                             : errorMessage != null
//   //                                             ? Container(
//   //                                                 key: const ValueKey('error'),
//   //                                                 padding: const EdgeInsets.all(
//   //                                                   16,
//   //                                                 ),
//   //                                                 decoration: BoxDecoration(
//   //                                                   color: const Color(
//   //                                                     0xFFFEF2F2,
//   //                                                   ),
//   //                                                   borderRadius:
//   //                                                       BorderRadius.circular(
//   //                                                         12,
//   //                                                       ),
//   //                                                   border: Border.all(
//   //                                                     color: const Color(
//   //                                                       0xFFFECACA,
//   //                                                     ),
//   //                                                   ),
//   //                                                 ),
//   //                                                 child: Column(
//   //                                                   children: [
//   //                                                     Row(
//   //                                                       children: [
//   //                                                         const Icon(
//   //                                                           Icons.error_outline,
//   //                                                           color: Color(
//   //                                                             0xFFEF4444,
//   //                                                           ),
//   //                                                           size: 20,
//   //                                                         ),
//   //                                                         const SizedBox(
//   //                                                           width: 8,
//   //                                                         ),
//   //                                                         Expanded(
//   //                                                           child: Text(
//   //                                                             errorMessage!,
//   //                                                             style:
//   //                                                                 const TextStyle(
//   //                                                                   fontSize:
//   //                                                                       14,
//   //                                                                   color: Color(
//   //                                                                     0xFF991B1B,
//   //                                                                   ),
//   //                                                                 ),
//   //                                                           ),
//   //                                                         ),
//   //                                                       ],
//   //                                                     ),
//   //                                                     const SizedBox(
//   //                                                       height: 12,
//   //                                                     ),
//   //                                                     SizedBox(
//   //                                                       width: double.infinity,
//   //                                                       child: OutlinedButton.icon(
//   //                                                         onPressed:
//   //                                                             loadReferralCode,
//   //                                                         style: OutlinedButton.styleFrom(
//   //                                                           foregroundColor:
//   //                                                               const Color(
//   //                                                                 0xFFEF4444,
//   //                                                               ),
//   //                                                           side:
//   //                                                               const BorderSide(
//   //                                                                 color: Color(
//   //                                                                   0xFFEF4444,
//   //                                                                 ),
//   //                                                               ),
//   //                                                           shape: RoundedRectangleBorder(
//   //                                                             borderRadius:
//   //                                                                 BorderRadius.circular(
//   //                                                                   8,
//   //                                                                 ),
//   //                                                           ),
//   //                                                         ),
//   //                                                         icon: const Icon(
//   //                                                           Icons.refresh,
//   //                                                           size: 18,
//   //                                                         ),
//   //                                                         label: const Text(
//   //                                                           'Retry',
//   //                                                         ),
//   //                                                       ),
//   //                                                     ),
//   //                                                   ],
//   //                                                 ),
//   //                                               )
//   //                                             : Container(
//   //                                                 key: const ValueKey('code'),
//   //                                                 padding: const EdgeInsets.all(
//   //                                                   16,
//   //                                                 ),
//   //                                                 decoration: BoxDecoration(
//   //                                                   color: Colors.grey[50],
//   //                                                   borderRadius:
//   //                                                       BorderRadius.circular(
//   //                                                         12,
//   //                                                       ),
//   //                                                   border: Border.all(
//   //                                                     color: Colors.grey[300]!,
//   //                                                   ),
//   //                                                 ),
//   //                                                 child: Row(
//   //                                                   children: [
//   //                                                     Expanded(
//   //                                                       child: Column(
//   //                                                         crossAxisAlignment:
//   //                                                             CrossAxisAlignment
//   //                                                                 .start,
//   //                                                         children: [
//   //                                                           Text(
//   //                                                             userReferralCode ??
//   //                                                                 '--',
//   //                                                             style: const TextStyle(
//   //                                                               fontSize: 24,
//   //                                                               fontWeight:
//   //                                                                   FontWeight
//   //                                                                       .w700,
//   //                                                               letterSpacing:
//   //                                                                   2,
//   //                                                               color: Color(
//   //                                                                 0xFF4F46E5,
//   //                                                               ),
//   //                                                             ),
//   //                                                           ),
//   //                                                           const Text(
//   //                                                             'Tap to copy',
//   //                                                             style: TextStyle(
//   //                                                               fontSize: 12,
//   //                                                               color: Color(
//   //                                                                 0xFF6B7280,
//   //                                                               ),
//   //                                                             ),
//   //                                                           ),
//   //                                                         ],
//   //                                                       ),
//   //                                                     ),
//   //                                                     IconButton(
//   //                                                       onPressed: () {
//   //                                                         if (userReferralCode !=
//   //                                                             null) {
//   //                                                           Clipboard.setData(
//   //                                                             ClipboardData(
//   //                                                               text:
//   //                                                                   userReferralCode!,
//   //                                                             ),
//   //                                                           );
//   //                                                           ScaffoldMessenger.of(
//   //                                                             context,
//   //                                                           ).showSnackBar(
//   //                                                             const SnackBar(
//   //                                                               content: Text(
//   //                                                                 'Referral code copied!',
//   //                                                               ),
//   //                                                               behavior:
//   //                                                                   SnackBarBehavior
//   //                                                                       .floating,
//   //                                                               backgroundColor:
//   //                                                                   Color(
//   //                                                                     0xFF10B981,
//   //                                                                   ),
//   //                                                             ),
//   //                                                           );
//   //                                                         }
//   //                                                       },
//   //                                                       icon: const Icon(
//   //                                                         Icons.copy,
//   //                                                         size: 20,
//   //                                                       ),
//   //                                                       color: const Color(
//   //                                                         0xFF4F46E5,
//   //                                                       ),
//   //                                                       style:
//   //                                                           IconButton.styleFrom(
//   //                                                             backgroundColor:
//   //                                                                 const Color(
//   //                                                                   0xFF4F46E5,
//   //                                                                 ).withOpacity(
//   //                                                                   0.1,
//   //                                                                 ),
//   //                                                           ),
//   //                                                     ),
//   //                                                   ],
//   //                                                 ),
//   //                                               ),
//   //                                       ),
//   //                                       const SizedBox(height: 24),
//   //                                       const AppText(
//   //                                         'how_it_works',
//   //                                         style: TextStyle(
//   //                                           fontSize: 14,
//   //                                           fontWeight: FontWeight.w600,
//   //                                           color: Color(0xFF374151),
//   //                                         ),
//   //                                       ),
//   //                                       const SizedBox(height: 12),
//   //                                       _referStep(
//   //                                         '1',
//   //                                         'share_your_code',
//   //                                         'send_referral_any_platform',
//   //                                       ),
//   //                                       const SizedBox(height: 12),
//   //                                       _referStep(
//   //                                         '2',
//   //                                         'friend_signs_up',
//   //                                         'enter_code_during_signup',
//   //                                       ),
//   //                                       const SizedBox(height: 12),
//   //                                       _referStep(
//   //                                         '3',
//   //                                         'earn_rewards',
//   //                                         'get_200_on_upgrade',
//   //                                       ),
//   //                                       const SizedBox(height: 24),
//   //                                       Row(
//   //                                         children: [
//   //                                           Expanded(
//   //                                             child: ElevatedButton.icon(
//   //                                               onPressed: () {
//   //                                                 if (userReferralCode !=
//   //                                                     null) {
//   //                                                   Clipboard.setData(
//   //                                                     ClipboardData(
//   //                                                       text: userReferralCode!,
//   //                                                     ),
//   //                                                   );
//   //                                                   ScaffoldMessenger.of(
//   //                                                     context,
//   //                                                   ).showSnackBar(
//   //                                                     const SnackBar(
//   //                                                       content: Text(
//   //                                                         'Copied!',
//   //                                                       ),
//   //                                                       backgroundColor: Color(
//   //                                                         0xFF10B981,
//   //                                                       ),
//   //                                                     ),
//   //                                                   );
//   //                                                 } else {
//   //                                                   loadReferralCode();
//   //                                                 }
//   //                                               },
//   //                                               icon: const Icon(
//   //                                                 Icons.copy,
//   //                                                 size: 20,
//   //                                               ),
//   //                                               label: const Text('Copy Code'),
//   //                                               style: ElevatedButton.styleFrom(
//   //                                                 backgroundColor: const Color(
//   //                                                   0xFF4F46E5,
//   //                                                 ),
//   //                                                 foregroundColor: Colors.white,
//   //                                                 padding:
//   //                                                     const EdgeInsets.symmetric(
//   //                                                       vertical: 14,
//   //                                                     ),
//   //                                                 shape: RoundedRectangleBorder(
//   //                                                   borderRadius:
//   //                                                       BorderRadius.circular(
//   //                                                         10,
//   //                                                       ),
//   //                                                 ),
//   //                                                 elevation: 0,
//   //                                               ),
//   //                                             ),
//   //                                           ),
//   //                                           const SizedBox(width: 12),
//   //                                           Expanded(
//   //                                             child: ElevatedButton.icon(
//   //                                               onPressed:
//   //                                                   userReferralCode != null
//   //                                                   ? shareCode
//   //                                                   : null,
//   //                                               icon: const Icon(
//   //                                                 Icons.share,
//   //                                                 size: 20,
//   //                                               ),
//   //                                               label: const Text('Share'),
//   //                                               style: ElevatedButton.styleFrom(
//   //                                                 backgroundColor: const Color(
//   //                                                   0xFF10B981,
//   //                                                 ),
//   //                                                 foregroundColor: Colors.white,
//   //                                                 disabledBackgroundColor:
//   //                                                     Colors.grey[300],
//   //                                                 padding:
//   //                                                     const EdgeInsets.symmetric(
//   //                                                       vertical: 14,
//   //                                                     ),
//   //                                                 shape: RoundedRectangleBorder(
//   //                                                   borderRadius:
//   //                                                       BorderRadius.circular(
//   //                                                         10,
//   //                                                       ),
//   //                                                 ),
//   //                                                 elevation: 0,
//   //                                               ),
//   //                                             ),
//   //                                           ),
//   //                                         ],
//   //                                       ),
//   //                                     ],
//   //                                   ),
//   //                                 ),
//   //                               ),
//   //                             ],
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   );
//   //                 },
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   Widget _referStep(String number, String titleKey, String descKey) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 32,
//           height: 32,
//           decoration: BoxDecoration(
//             color: const Color(0xFF4F46E5).withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Text(
//               number,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF4F46E5),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 titleKey,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               AppText(
//                 descKey,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Color(0xFF6B7280),
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
// }

// class _AutoPlayReelVideo extends StatefulWidget {
//   final String videoUrl;
//   const _AutoPlayReelVideo({required this.videoUrl});

//   @override
//   State<_AutoPlayReelVideo> createState() => _AutoPlayReelVideoState();
// }

// class _AutoPlayReelVideoState extends State<_AutoPlayReelVideo> {
//   VideoPlayerController? _controller;
//   bool _initialized = false;
//   bool _hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     _initVideo();
//   }

//   Future<void> _initVideo() async {
//     if (widget.videoUrl.isEmpty) {
//       setState(() => _hasError = true);
//       return;
//     }
//     try {
//       _controller = VideoPlayerController.networkUrl(
//         Uri.parse(widget.videoUrl),
//       );
//       await _controller!.initialize();
//       if (!mounted) return;
//       _controller!
//         ..setLooping(true)
//         ..setVolume(0) // muted — user hears sound only on full ReelsScreen
//         ..play();
//       setState(() => _initialized = true);
//     } catch (_) {
//       if (mounted) setState(() => _hasError = true);
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_hasError || !_initialized || _controller == null) {
//       // Fallback gradient while loading / on error
//       return Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: const Center(
//           child: Icon(
//             Icons.play_circle_outline_rounded,
//             color: Colors.white38,
//             size: 36,
//           ),
//         ),
//       );
//     }

//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(
//         width: _controller!.value.size.width,
//         height: _controller!.value.size.height,
//         child: VideoPlayer(_controller!),
//       ),
//     );
//   }
// }

// class _FlippableReferModal extends StatefulWidget {
//   final bool isLoading;
//   final String? errorMessage;
//   final String? userReferralCode;
//   final VoidCallback onLoadReferralCode;
//   final VoidCallback onShare;
//   final VoidCallback onClose;
//   final VoidCallback onCopy;

//   const _FlippableReferModal({
//     required this.isLoading,
//     required this.errorMessage,
//     required this.userReferralCode,
//     required this.onLoadReferralCode,
//     required this.onShare,
//     required this.onClose,
//     required this.onCopy,
//   });

//   @override
//   State<_FlippableReferModal> createState() => _FlippableReferModalState();
// }

// class _FlippableReferModalState extends State<_FlippableReferModal>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _flipController;
//   late Animation<double> _flipAnimation;
//   bool _isFlipped = false;
//   bool _showBack = false;

//   @override
//   void initState() {
//     super.initState();
//     _flipController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
//     );
//     _flipAnimation.addListener(() {
//       // Switch content halfway through flip
//       if (_flipAnimation.value >= 0.5 && !_showBack) {
//         setState(() => _showBack = true);
//       } else if (_flipAnimation.value < 0.5 && _showBack) {
//         setState(() => _showBack = false);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _flipController.dispose();
//     super.dispose();
//   }

//   void _flip() {
//     if (_isFlipped) {
//       _flipController.reverse();
//     } else {
//       _flipController.forward();
//     }
//     _isFlipped = !_isFlipped;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 24),
//           constraints: const BoxConstraints(maxWidth: 500),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // ── Header ──────────────────────────────────────────────
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 16,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[50],
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey[200]!),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF4F46E5).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(
//                           Icons.people_outline,
//                           color: Color(0xFF4F46E5),
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Expanded(
//                         child: AppText(
//                           'refer_earn',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF111827),
//                           ),
//                         ),
//                       ),
//                       // Flip hint button
//                       GestureDetector(
//                         onTap: _flip,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF4F46E5).withOpacity(0.08),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               AnimatedBuilder(
//                                 animation: _flipAnimation,
//                                 builder: (_, __) => Transform(
//                                   alignment: Alignment.center,
//                                   transform: Matrix4.rotationY(
//                                     _flipAnimation.value * 3.14159,
//                                   ),
//                                   child: const Icon(
//                                     Icons.flip_camera_android_rounded,
//                                     color: Color(0xFF4F46E5),
//                                     size: 16,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               Text(
//                                 _showBack ? 'My Code' : 'How it works',
//                                 style: const TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF4F46E5),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       IconButton(
//                         onPressed: widget.onClose,
//                         icon: const Icon(Icons.close, size: 24),
//                         color: Colors.grey[600],
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ── Flipping Card ────────────────────────────────────────
//                 GestureDetector(
//                   onTap: _flip,
//                   child: AnimatedBuilder(
//                     animation: _flipAnimation,
//                     builder: (context, _) {
//                       final angle = _flipAnimation.value * 3.14159;
//                       // Flip Y axis — first half shows front, second half shows back (mirrored)
//                       final isSecondHalf = _flipAnimation.value >= 0.5;
//                       final displayAngle = isSecondHalf
//                           ? angle - 3.14159
//                           : angle;

//                       return Transform(
//                         alignment: Alignment.center,
//                         transform: Matrix4.identity()
//                           ..setEntry(3, 2, 0.001) // perspective
//                           ..rotateY(angle),
//                         child: Transform(
//                           alignment: Alignment.center,
//                           // Mirror the back face so text isn't reversed
//                           transform: isSecondHalf
//                               ? (Matrix4.identity()..rotateY(3.14159))
//                               : Matrix4.identity(),
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//                             child: _showBack
//                                 ? _buildHowItWorksContent()
//                                 : _buildMyCodeContent(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 // ── Flip hint text ───────────────────────────────────────
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.touch_app_rounded,
//                         size: 13,
//                         color: Colors.grey[400],
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Tap card to flip',
//                         style: TextStyle(fontSize: 11, color: Colors.grey[400]),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // ── Common Buttons (always visible) ──────────────────────
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: widget.onCopy,
//                           icon: const Icon(Icons.copy, size: 20),
//                           label: const Text('Copy Code'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4F46E5),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 0,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: widget.userReferralCode != null
//                               ? widget.onShare
//                               : null,
//                           icon: const Icon(Icons.share, size: 20),
//                           label: const Text('Share'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF10B981),
//                             foregroundColor: Colors.white,
//                             disabledBackgroundColor: Colors.grey[300],
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMyCodeContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF0F9FF),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: const Color(0xFFBAE6FD)),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(7),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0EA5E9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.info_outline,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Expanded(
//                 child: AppText(
//                   'share_referral_earn',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF0C4A6E),
//                     height: 1.4,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         const AppText(
//           'your_referral_code',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 10),
//         if (widget.isLoading)
//           Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey[200]!),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 18,
//                   height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Color(0xFF4F46E5),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'Loading...',
//                   style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//                 ),
//               ],
//             ),
//           )
//         else if (widget.errorMessage != null)
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFEF2F2),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFFECACA)),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.error_outline,
//                   color: Color(0xFFEF4444),
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     widget.errorMessage!,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Color(0xFF991B1B),
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: widget.onLoadReferralCode,
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           )
//         else
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFC7D2FE)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.userReferralCode ?? '--',
//                         style: const TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 4,
//                           color: Color(0xFF4F46E5),
//                         ),
//                       ),
//                       const Text(
//                         'Your unique referral code',
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF4F46E5).withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.card_giftcard_rounded,
//                     color: Color(0xFF4F46E5),
//                     size: 28,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget _buildHowItWorksContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const AppText(
//           'how_it_works',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF111827),
//           ),
//         ),
//         const SizedBox(height: 16),
//         _howItWorksStep(
//           '1',
//           Icons.share_rounded,
//           'share_your_code',
//           'send_referral_any_platform',
//           const Color(0xFF6366F1),
//         ),
//         const SizedBox(height: 12),
//         _howItWorksStep(
//           '2',
//           Icons.person_add_rounded,
//           'friend_signs_up',
//           'enter_code_during_signup',
//           const Color(0xFF0EA5E9),
//         ),
//         const SizedBox(height: 12),
//         _howItWorksStep(
//           '3',
//           Icons.emoji_events_rounded,
//           'earn_rewards',
//           'get_200_on_upgrade',
//           const Color(0xFF10B981),
//         ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget _howItWorksStep(
//     String number,
//     IconData icon,
//     String titleKey,
//     String descKey,
//     Color color,
//   ) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             shape: BoxShape.circle,
//           ),
//           child: Center(child: Icon(icon, color: color, size: 20)),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 titleKey,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 3),
//               AppText(
//                 descKey,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF6B7280),
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/models/category_model.dart';
// import 'package:posternova/models/celebration_model.dart';
// import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
// import 'package:posternova/providers/PosterProvider/poster_provider.dart';
// import 'package:posternova/providers/festivals/date_time_provider.dart';
// import 'package:posternova/providers/plans/my_plan_provider.dart';
// import 'package:posternova/providers/story/story_provider.dart';
// import 'package:posternova/providers/topics/hot_topic_provider.dart';
// import 'package:posternova/views/PosterModule/poster_making_screen.dart'
//     hide Overlay;
// import 'package:posternova/views/ProfileScreen/profile_screen.dart';
// import 'package:posternova/views/SecondPhase/poster_editor.dart';
// import 'package:posternova/views/category/category_detail_screen.dart';
// import 'package:posternova/views/category/search_category.dart';
// import 'package:posternova/views/hot/hot_screen.dart';
// import 'package:posternova/views/notifications/notification_screen.dart';
// import 'package:posternova/views/stories/story_widget_screen.dart';
// import 'package:posternova/widgets/common_modal.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:posternova/widgets/language_animation_widget.dart';
// import 'package:posternova/services/language/restart_lan_service.dart';
// import 'package:posternova/widgets/premium_widget.dart';
// import 'package:posternova/widgets/voice_assistant_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';
// import 'package:video_player/video_player.dart';
// import 'package:url_launcher/url_launcher.dart';

// // ─────────────────────────────────────────────────────────────────────────────
// // SKELETON SHIMMER HELPERS
// // ─────────────────────────────────────────────────────────────────────────────

// class _SkeletonBox extends StatefulWidget {
//   final double width;
//   final double height;
//   final double borderRadius;
//   const _SkeletonBox({
//     required this.width,
//     required this.height,
//     this.borderRadius = 8,
//   });

//   @override
//   State<_SkeletonBox> createState() => _SkeletonBoxState();
// }

// class _SkeletonBoxState extends State<_SkeletonBox>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animController;
//   late Animation<double> _anim;

//   @override
//   void initState() {
//     super.initState();
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     )..repeat(reverse: true);
//     _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
//       CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) => Container(
//         width: widget.width,
//         height: widget.height,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(widget.borderRadius),
//           gradient: LinearGradient(
//             colors: [
//               Colors.grey.withOpacity(_anim.value * 0.6),
//               Colors.white.withOpacity(_anim.value),
//               Colors.grey.withOpacity(_anim.value * 0.6),
//             ],
//           ),
//         ),
//         // EditEzy logo overlay (B&W, very subtle)
//         child: Opacity(
//           opacity: 0.06,
//           child: Center(
//             child: Image.asset(
//               'assets/images/logo.png', // EditEzy logo asset
//               width: widget.width * 0.4,
//               height: widget.height * 0.4,
//               fit: BoxFit.contain,
//               color: Colors.black,
//               errorBuilder: (_, __, ___) => Icon(
//                 Icons.edit,
//                 color: Colors.black,
//                 size: widget.width * 0.3,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Banner Skeleton
// class _BannerSkeleton extends StatelessWidget {
//   const _BannerSkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: const _SkeletonBox(
//           width: double.infinity,
//           height: 104,
//           borderRadius: 16,
//         ),
//       ),
//     );
//   }
// }

// // Story/Explore Skeleton
// class _StorySkeleton extends StatelessWidget {
//   const _StorySkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 90,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: 6,
//         itemBuilder: (_, __) => Padding(
//           padding: const EdgeInsets.only(right: 12),
//           child: Column(
//             children: [
//               const _SkeletonBox(width: 56, height: 56, borderRadius: 28),
//               const SizedBox(height: 6),
//               _SkeletonBox(width: 48, height: 10, borderRadius: 4),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Poster Card Skeleton
// class _PosterCardSkeleton extends StatelessWidget {
//   const _PosterCardSkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 110,
//       margin: const EdgeInsets.only(right: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//             child: const _SkeletonBox(width: 110, height: 100, borderRadius: 0),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(6),
//             child: _SkeletonBox(width: 70, height: 10, borderRadius: 4),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Reel Card Skeleton
// class _ReelCardSkeleton extends StatelessWidget {
//   const _ReelCardSkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 105,
//       margin: const EdgeInsets.only(right: 10),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//       child: const _SkeletonBox(width: 105, height: 180, borderRadius: 12),
//     );
//   }
// }

// // Date Selector Skeleton
// class _DateSelectorSkeleton extends StatelessWidget {
//   const _DateSelectorSkeleton();
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 68,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: 7,
//         itemBuilder: (_, __) => Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 4),
//           child: const _SkeletonBox(width: 58, height: 68, borderRadius: 10),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // NO NETWORK BOTTOM SHEET
// // ─────────────────────────────────────────────────────────────────────────────

// class _NoNetworkSheet extends StatelessWidget {
//   final VoidCallback onRetry;
//   const _NoNetworkSheet({required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFF3E0),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.wifi_off_rounded,
//               color: Color(0xFFFF6D00),
//               size: 40,
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'No Internet Connection',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1F2937),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Please check your Wi-Fi or mobile data and try again. All features are unavailable while offline.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF6B7280),
//               height: 1.5,
//             ),
//           ),
//           const SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh_rounded, size: 20),
//               label: const Text(
//                 'Try Again',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF448AFF),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // HOME SCREEN
// // ─────────────────────────────────────────────────────────────────────────────

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//   // ─── Keep alive so tab switches don't rebuild ──────────────────────────────
//   @override
//   bool get wantKeepAlive => true;

//   // ─── User ──────────────────────────────────────────────────────────────────
//   String? currentUserId;
//   String? username;
//   String? userImage;
//   String? userId;

//   // ─── Data ──────────────────────────────────────────────────────────────────
//   Map<String, dynamic> birthdayData = {};
//   Map<String, dynamic> anniversaryData = {};
//   Map<String, List<dynamic>> weeklyPosters = {};
//   List<dynamic> customers = [];
//   bool isLoadingCustomers = false;

//   // ─── Loading states ────────────────────────────────────────────────────────
//   bool _isBannerLoading = true;
//   bool _isWeeklyLoading = true;
//   bool _isFestivalLoading = true;
//   bool _isReelsLoading = true;
//   bool _isStoriesLoading = true;
//   bool _isInitialLoad = true; // true until first full load completes

//   static bool _hasShownReferAndEarnModal = false;
//   static bool _hasLoadedOnce = false; // prevent refetch on tab switch

//   List<dynamic> festivaldata = [];
//   List<dynamic> canvaposter = [];
//   List<dynamic> bannerList = [];

//   CelebrationConfig? _celebrationConfig;
//   VideoPlayerController? _celebrationController;
//   bool _showCelebration = false;

//   // ─── Network ───────────────────────────────────────────────────────────────
//   bool _hasNetwork = true;
//   StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
//   bool _noNetworkSheetShown = false;

//   // ─── Controllers ───────────────────────────────────────────────────────────
//   final TextEditingController _searchController = TextEditingController();
//   late PageController _bannerPageController;
//   int _currentBannerPage = 0;

//   List<String> weekDays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday',
//   ];

//   late VideoPlayerController _videoController;

//   // ══════════════════════════════════════════════════════════════════════════
//   // LIFECYCLE
//   // ══════════════════════════════════════════════════════════════════════════

//   @override
//   void initState() {
//     super.initState();
//     _bannerPageController = PageController();
//     _listenConnectivity();
//     _checkNetwork().then((_) {
//       _loadUserData();
//       _loadUserId();
//       _initializeUser();
//       // Only fetch on first load; subsequent tab switches reuse cached state
//       if (!_hasLoadedOnce) {
//         Future.microtask(() async => await _initializeAllData());
//         _hasLoadedOnce = true;
//       } else {
//         // Data already loaded — just update loading states to false
//         setState(() {
//           _isBannerLoading = false;
//           _isWeeklyLoading = false;
//           _isFestivalLoading = false;
//           _isReelsLoading = false;
//           _isStoriesLoading = false;
//           _isInitialLoad = false;
//         });
//       }
//     });
//     _videoController = VideoPlayerController.asset("assets/videos/bg.webm")
//       ..initialize().then((_) {
//         if (mounted) setState(() {});
//         _videoController.setLooping(true);
//         _videoController.play();
//       });
//   }

//   Future<void> _fetchCelebrationConfig() async {
//     // TODO: Uncomment API call when backend is ready
//     // try {
//     //   final response = await http.get(
//     //     Uri.parse('http://31.97.206.144:4061/api/celebration/active'),
//     //   );
//     //   if (response.statusCode == 200) {
//     //     final data = jsonDecode(response.body);
//     //     final config = CelebrationConfig.fromJson(data);
//     //     if (config.enabled && config.videoUrl.isNotEmpty) {
//     //       setState(() => _celebrationConfig = config);
//     //       _initCelebrationVideo(config);
//     //     }
//     //   }
//     // } catch (e) {
//     //   debugPrint('fetchCelebration: $e');
//     // }

//     // ─── Default hardcoded config for testing ─────────────────────────
//     final config = CelebrationConfig(
//       enabled: true,
//       videoUrl: '', // leave empty to trigger local fallback
//       durationSeconds: 10,
//       loop: false,
//     );

//     if (config.enabled) {
//       setState(() => _celebrationConfig = config);
//       _initCelebrationVideo(config);
//     }
//   }

//   // Future<void> _initCelebrationVideo(CelebrationConfig config) async {
//   //   try {
//   //     _celebrationController = VideoPlayerController.networkUrl(
//   //       Uri.parse(config.videoUrl),
//   //     );
//   //     await _celebrationController!.initialize();
//   //     if (!mounted) return;

//   //     _celebrationController!
//   //       ..setLooping(config.loop)
//   //       ..setVolume(0)
//   //       ..play();

//   //     setState(() => _showCelebration = true);

//   //     // Auto-dismiss after duration
//   //     if (!config.loop) {
//   //       Future.delayed(Duration(seconds: config.durationSeconds), () {
//   //         if (mounted) setState(() => _showCelebration = false);
//   //         _celebrationController?.dispose();
//   //         _celebrationController = null;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     debugPrint('initCelebrationVideo: $e');
//   //   }
//   // }

//   Future<void> _initCelebrationVideo(CelebrationConfig config) async {
//     try {
//       _celebrationController = VideoPlayerController.networkUrl(
//         Uri.parse(config.videoUrl),
//       );
//       await _celebrationController!.initialize();
//     } catch (e) {
//       debugPrint('Network video failed, using fallback: $e');

//       // ─── FALLBACK to local asset ───────────────────────────────────
//       try {
//         _celebrationController?.dispose();
//         _celebrationController = VideoPlayerController.asset(
//           'assets/videos/celebration.mp4', // your fallback local video
//         );
//         await _celebrationController!.initialize();
//       } catch (e2) {
//         debugPrint('Fallback also failed: $e2');
//         _celebrationController = null;
//         return; // nothing to show
//       }
//     }

//     if (!mounted) return;

//     _celebrationController!
//       ..setLooping(config.loop)
//       ..setVolume(0)
//       ..play();

//     setState(() => _showCelebration = true);

//     if (!config.loop) {
//       Future.delayed(Duration(seconds: config.durationSeconds), () {
//         if (mounted) setState(() => _showCelebration = false);
//         _celebrationController?.dispose();
//         _celebrationController = null;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _bannerPageController.dispose();
//     _searchController.dispose();
//     _connectivitySubscription?.cancel();
//     _celebrationController?.dispose();
//     VoiceGreetingHelper.stop();
//     super.dispose();
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // NETWORK
//   // ══════════════════════════════════════════════════════════════════════════

//   Future<void> _checkNetwork() async {
//     try {
//       final result = await Connectivity().checkConnectivity();
//       final hasNet =
//           result.isNotEmpty && !result.contains(ConnectivityResult.none);
//       if (mounted) setState(() => _hasNetwork = hasNet);
//       if (!hasNet) _showNoNetworkSheet();
//     } catch (_) {}
//   }

//   void _listenConnectivity() {
//     _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
//       results,
//     ) {
//       final hasNet =
//           results.isNotEmpty && !results.contains(ConnectivityResult.none);
//       if (!mounted) return;
//       final wasOffline = !_hasNetwork;
//       setState(() {
//         _hasNetwork = hasNet;
//         if (hasNet) _noNetworkSheetShown = false;
//       });
//       if (!hasNet) {
//         _showNoNetworkSheet();
//       } else if (wasOffline && hasNet) {
//         // Reconnected — silently reload data
//         _initializeAllData();
//       }
//     });
//   }

//   void _showNoNetworkSheet() {
//     if (_noNetworkSheetShown || !mounted) return;
//     _noNetworkSheetShown = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       showModalBottomSheet(
//         context: context,
//         isDismissible: false,
//         enableDrag: false,
//         backgroundColor: Colors.transparent,
//         builder: (_) => _NoNetworkSheet(
//           onRetry: () async {
//             Navigator.pop(context);
//             _noNetworkSheetShown = false;
//             await _checkNetwork();
//             if (_hasNetwork) await _initializeAllData();
//           },
//         ),
//       );
//     });
//   }

//   /// Guard: block any action if offline, show sheet and return false
//   bool _requireNetwork() {
//     if (!_hasNetwork) {
//       _noNetworkSheetShown = false;
//       _showNoNetworkSheet();
//       return false;
//     }
//     return true;
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // INIT HELPERS
//   // ══════════════════════════════════════════════════════════════════════════

//   Future<void> _initializeAllData() async {
//     if (!mounted || !_hasNetwork) return;
//     await Future.wait([
//       _loadUserId().catchError((e) => debugPrint('loadUserId: $e')),
//       _fetchnewposters().catchError((e) => debugPrint('fetchPosters: $e')),
//       _initializeProviders().catchError((e) => debugPrint('providers: $e')),
//       _fetchWeeklyPosters().catchError((e) => debugPrint('weeklyPosters: $e')),
//       _fetchBanners().catchError((e) => debugPrint('banners: $e')),
//       _fetchCelebrationConfig().catchError(
//         (e) => debugPrint('celebration: $e'),
//       ),
//     ]);
//     if (!mounted) return;
//     _fetchFestivalPosters(context.read<DateTimeProvider>().selectedDate);
//     _fetchReels();
//     _startBannerAutoScroll();
//     if (mounted) setState(() => _isInitialLoad = false);
//   }

//   Future<void> _initializeProviders() async {
//     if (!mounted) return;
//     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
//     final storyProvider = Provider.of<StoryProvider>(context, listen: false);
//     final posterProvider = Provider.of<PosterProvider>(context, listen: false);
//     if (mounted) setState(() => _isStoriesLoading = true);
//     storyProvider.fetchStories();
//     await Future.wait([
//       myPlanProvider.fetchMyPlan(userId.toString()).catchError((_) => null),
//       posterProvider.fetchPosters().catchError((_) => null),
//     ]);
//     if (mounted) setState(() => _isStoriesLoading = false);
//     if (!mounted) return;
//     _showInitialModals();
//   }

//   void _showInitialModals() {
//     if (!mounted) return;
//     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
//     if (!myPlanProvider.isPurchase) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => SubscriptionPlansPage()),
//           );
//         }
//       });
//     }
//     if (!_hasShownReferAndEarnModal) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           showReferAndEarnModal(context);
//           _hasShownReferAndEarnModal = true;
//         }
//       });
//     }
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // DATA FETCHERS
//   // ══════════════════════════════════════════════════════════════════════════

//   Future<void> _fetchBanners() async {
//     if (mounted) setState(() => _isBannerLoading = true);

//     try {
//       final response = await http.get(
//         Uri.parse('http://31.97.206.144:4061/api/poster/getbanners'),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         List banners = data is List
//             ? data
//             : (data['banners'] ?? data['data'] ?? []);

//         // ✅ Extract only image URLs
//         List<String> images = [];

//         for (var item in banners) {
//           if (item['images'] != null && item['images'].isNotEmpty) {
//             images.add(item['images'][0]);
//           }
//         }

//         if (mounted) {
//           setState(() {
//             bannerList = images;
//             _isBannerLoading = false;
//           });
//         }
//       } else {
//         if (mounted) setState(() => _isBannerLoading = false);
//       }
//     } catch (e) {
//       if (mounted) setState(() => _isBannerLoading = false);
//       debugPrint('fetchBanners: $e');
//     }
//   }

//   void _startBannerAutoScroll() {
//     Future.delayed(const Duration(seconds: 3), () {
//       if (!mounted || !_bannerPageController.hasClients || bannerList.isEmpty)
//         return;
//       final next = (_currentBannerPage + 1) % bannerList.length;
//       _bannerPageController.animateToPage(
//         next,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//       _startBannerAutoScroll();
//     });
//   }

//   Future<void> _fetchReels() async {
//     if (userId == null) return;
//     if (mounted) setState(() => _isReelsLoading = true);
//     try {
//       final hotTopicProvider = Provider.of<HotTopicReelsProvider>(
//         context,
//         listen: false,
//       );
//       await hotTopicProvider.loadHotTopicReels(userId!);
//     } catch (e) {
//       debugPrint('fetchReels: $e');
//     } finally {
//       if (mounted) setState(() => _isReelsLoading = false);
//     }
//   }

//   Future<void> _fetchWeeklyPosters() async {
//     if (mounted) setState(() => _isWeeklyLoading = true);
//     try {
//       final response = await http.get(
//         Uri.parse(
//           'http://31.97.206.144:4061/api/poster/weeklyposters/$currentUserId',
//         ),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as Map<String, dynamic>;
//         if (mounted)
//           setState(() {
//             weeklyPosters = data.map(
//               (k, v) => MapEntry(k, List<dynamic>.from(v)),
//             );
//             _isWeeklyLoading = false;
//           });
//       } else {
//         if (mounted) setState(() => _isWeeklyLoading = false);
//       }
//     } catch (e) {
//       if (mounted) setState(() => _isWeeklyLoading = false);
//       debugPrint('fetchWeeklyPosters: $e');
//     }
//   }

//   Future<void> _loadUserId() async {
//     if (!mounted) return;
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (!mounted) return;
//       if (userData != null) {
//         setState(() {
//           username = userData.user.name;
//           currentUserId = userData.user.id;
//         });
//         await _fetchWeeklyPosters();
//         final response = await http.get(
//           Uri.parse(
//             'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
//           ),
//         );
//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           if (mounted)
//             setState(() {
//               birthdayData = Map<String, dynamic>.from(data);
//               anniversaryData = Map<String, dynamic>.from(data);
//             });
//         }
//       }
//     } catch (e) {
//       debugPrint('loadUserId: $e');
//     }
//   }

//   Future<void> _loadUserData() async {
//     final userData = await AuthPreferences.getUserData();
//     if (userData != null && userData.user != null) {
//       if (mounted)
//         setState(() {
//           userId = userData.user.id;
//           username = userData.user.name;
//           userImage = userData.user.profileImage;
//         });
//       _fetchUserProfile(userData.user.id);
//       fetchCustomers();
//     }
//   }

//   Future<void> _fetchUserProfile(String? uid) async {
//     if (uid == null) return;
//     try {
//       final response = await http.get(
//         Uri.parse('http://31.97.206.144:4061/api/users/get-profile/$uid'),
//       );
//       if (response.statusCode == 200 && mounted) {
//         final data = json.decode(response.body);
//         setState(() {
//           username = data['name'] ?? username ?? 'User';
//           userImage = data['profileImage'] ?? userImage;
//         });
//         final lp = Provider.of<LanguageProvider>(context, listen: false);
//         lp.setUserId(uid);
//       }
//     } catch (e) {
//       debugPrint('fetchUserProfile: $e');
//     }
//   }

//   Future<void> _initializeUser() async {
//     final userData = await AuthPreferences.getUserData();
//     if (userData != null && userData.user.id != null) {
//       final storyProvider = Provider.of<StoryProvider>(context, listen: false);
//       storyProvider.setCurrentUser(
//         userId: userData.user.id,
//         userImage: userData.user.profileImage,
//         username: userData.user.name ?? '',
//       );
//       storyProvider.fetchStories();
//     }
//   }

//   Future<void> fetchCustomers() async {
//     if (userId == null) return;
//     setState(() => isLoadingCustomers = true);
//     try {
//       final response = await http.get(
//         Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (mounted)
//           setState(() {
//             customers = data['customers'] ?? [];
//             isLoadingCustomers = false;
//           });
//       } else {
//         if (mounted) setState(() => isLoadingCustomers = false);
//       }
//     } catch (e) {
//       if (mounted) setState(() => isLoadingCustomers = false);
//     }
//   }

//   String _formatDate(DateTime d) =>
//       "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

//   Future<void> _fetchFestivalPosters(DateTime date) async {
//     if (mounted)
//       setState(() {
//         _isFestivalLoading = true;
//         festivaldata = [];
//       });
//     try {
//       final response = await http.post(
//         Uri.parse('http://31.97.206.144:4061/api/poster/festival'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'festivalDate': _formatDate(date)}),
//       );
//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         if (mounted)
//           setState(() {
//             festivaldata = decoded is List ? decoded : [];
//             _isFestivalLoading = false;
//           });
//       } else {
//         if (mounted) setState(() => _isFestivalLoading = false);
//       }
//     } catch (e) {
//       if (mounted) setState(() => _isFestivalLoading = false);
//     }
//   }

//   Future<void> _fetchnewposters() async {
//     try {
//       final cp = Provider.of<CanvaPosterProvider>(context, listen: false);
//       await cp.fetchPosters();
//       if (mounted) setState(() => canvaposter = cp.posters);
//     } catch (e) {
//       debugPrint('fetchnewposters: $e');
//     }
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // HELPERS
//   // ══════════════════════════════════════════════════════════════════════════

//   List<String> _getOrderedDaysFromToday() {
//     final today = DateFormat('EEEE').format(DateTime.now());
//     final todayIndex = weekDays.indexOf(today);
//     if (todayIndex == -1) return weekDays;
//     return [
//       ...weekDays.sublist(todayIndex),
//       ...weekDays.sublist(0, todayIndex),
//     ];
//   }

//   String _getDaySuffix(int day) {
//     if (day >= 11 && day <= 13) return 'th';
//     switch (day % 10) {
//       case 1:
//         return 'st';
//       case 2:
//         return 'nd';
//       case 3:
//         return 'rd';
//       default:
//         return 'th';
//     }
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // BUILD
//   // ══════════════════════════════════════════════════════════════════════════

//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // required for AutomaticKeepAliveClientMixin
//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: Stack(
//         children: [
//           RefreshIndicator(
//             onRefresh: () async {
//               if (!_requireNetwork()) return;
//               await Future.wait([
//                 _fetchFestivalPosters(
//                   context.read<DateTimeProvider>().selectedDate,
//                 ),
//                 _fetchnewposters(),
//                 _fetchWeeklyPosters(),
//                 _fetchBanners(),
//                 _fetchReels(),
//               ]);
//             },
//             color: const Color(0xFFFFC107),
//             child: CustomScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildSearchBar(),
//                       _buildBannerSection(),
//                       const SizedBox(height: 12),
//                       _buildForYouSection(),
//                       const SizedBox(height: 12),
//                       _buildUpcomingFestivalsSection(),
//                       _buildFestivalPostersSection(),
//                       const SizedBox(height: 12),
//                       _buildWeeklySectionWithHeader(),
//                       _buildHotTopicsSection(),
//                       const SizedBox(height: 12),
//                       _buildAllCategoriesSection(),
//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ─── Celebration video overlay ──────────────────────────────
//           if (_showCelebration &&
//               _celebrationController != null &&
//               _celebrationController!.value.isInitialized)
//             Positioned.fill(
//               child: IgnorePointer(
//                 // taps pass through to UI below
//                 child: VideoPlayer(_celebrationController!),
//               ),
//             ),
//           // Network overlay — dim + block touches when offline
//           if (!_hasNetwork)
//             Positioned.fill(
//               child: IgnorePointer(
//                 ignoring: false,
//                 child: Container(color: Colors.black.withOpacity(0.01)),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // APP BAR
//   // ══════════════════════════════════════════════════════════════════════════

//   PreferredSizeWidget _buildAppBar() {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(64),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF448AFF),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: SafeArea(
//           bottom: false,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     if (!_requireNetwork()) return;
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProfileScreen()),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           blurRadius: 6,
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.white,
//                       backgroundImage:
//                           (userImage != null && userImage!.isNotEmpty)
//                           ? NetworkImage(userImage!) as ImageProvider
//                           : null,
//                       child: (userImage == null || userImage!.isEmpty)
//                           ? const Icon(
//                               Icons.person,
//                               color: Color(0xFFFFC107),
//                               size: 22,
//                             )
//                           : null,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const AppText(
//                         'welcome_back',
//                         style: TextStyle(fontSize: 11, color: Colors.black54),
//                       ),
//                       Text(
//                         username ?? 'User',
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                           letterSpacing: 0.2,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Network indicator badge
//                 if (!_hasNetwork)
//                   Container(
//                     margin: const EdgeInsets.only(right: 8),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.red.shade600,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.wifi_off_rounded,
//                           color: Colors.white,
//                           size: 12,
//                         ),
//                         SizedBox(width: 4),
//                         Text(
//                           'Offline',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.notifications_none_rounded,
//                         color: Colors.black87,
//                         size: 26,
//                       ),
//                       onPressed: () {
//                         if (!_requireNetwork()) return;
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 NotificationScreen(userId: userId.toString()),
//                           ),
//                         );
//                       },
//                       padding: EdgeInsets.zero,
//                       constraints: const BoxConstraints(
//                         minWidth: 38,
//                         minHeight: 38,
//                       ),
//                     ),
//                     Positioned(
//                       right: 4,
//                       top: 4,
//                       child: Container(
//                         width: 16,
//                         height: 16,
//                         decoration: const BoxDecoration(
//                           color: Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Center(
//                           child: Text(
//                             '3',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     if (!_requireNetwork()) return;
//                     _showLanguageSelector(context);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(7),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.language_rounded,
//                       color: Colors.black87,
//                       size: 22,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // SEARCH BAR
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildSearchBar() {
//     return GestureDetector(
//       onTap: () {
//         if (!_requireNetwork()) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const SearchScreen()),
//         );
//       },
//       child: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         child: Container(
//           height: 44,
//           decoration: BoxDecoration(
//             color: const Color(0xFFF0F0F0),
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: const Color(0xFFE0E0E0)),
//           ),
//           child: Row(
//             children: [
//               const SizedBox(width: 10),
//               const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: AbsorbPointer(
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       hintText: 'Search Posts by Topics',
//                       hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                       border: InputBorder.none,
//                       isDense: true,
//                       contentPadding: EdgeInsets.symmetric(vertical: 10),
//                     ),
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ),
//               ),
//               const Icon(Icons.mic_rounded, color: Colors.grey, size: 20),
//               const SizedBox(width: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // BANNER
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildBannerSection() {
//     if (_isBannerLoading) {
//       return const SizedBox(
//         height: 136,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//           child: _BannerSkeleton(),
//         ),
//       );
//     }

//     if (bannerList.isEmpty) return const SizedBox.shrink();

//     return Column(
//       children: [
//         SizedBox(
//           height: 120,
//           child: PageView.builder(
//             controller: _bannerPageController,
//             onPageChanged: (i) => setState(() => _currentBannerPage = i),
//             itemCount: bannerList.length,
//             itemBuilder: (_, i) => _buildBannerItem(bannerList[i]),
//           ),
//         ),
//         if (bannerList.length > 1)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(bannerList.length, (i) {
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 250),
//                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                   width: _currentBannerPage == i ? 18 : 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(3),
//                     color: _currentBannerPage == i
//                         ? const Color(0xFFFFC107)
//                         : Colors.grey.shade300,
//                   ),
//                 );
//               }),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildBannerItem(String imageUrl) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             imageUrl.isNotEmpty
//                 ? Image.network(
//                     imageUrl,
//                     fit: BoxFit.fill,
//                     errorBuilder: (_, __, ___) => _buildBannerGradient(),
//                     loadingBuilder: (_, child, progress) =>
//                         progress == null ? child : _buildBannerGradient(),
//                   )
//                 : _buildBannerGradient(),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.black.withOpacity(0.55),
//                     Colors.transparent,
//                     Colors.transparent,
//                   ],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBannerGradient() => Container(
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color.fromARGB(255, 126, 211, 47), Color(0xFFB71C1C)],
//       ),
//     ),
//   );

//   // ══════════════════════════════════════════════════════════════════════════
//   // FOR YOU / EXPLORE (Stories)
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildForYouSection() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 1),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(left: 12, bottom: 1),
//             child: Text(
//               'Explore',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromARGB(221, 0, 0, 0),
//               ),
//             ),
//           ),
//           _isStoriesLoading
//               ? const _StorySkeleton()
//               : StoriesWidget(profile: userImage),
//         ],
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // UPCOMING FESTIVALS — date selector
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildUpcomingFestivalsSection() {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.only(top: 14, bottom: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.only(left: 16, bottom: 10),
//             child: Text(
//               'Upcoming Festivals',
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Consumer<DateTimeProvider>(
//             builder: (_, dtp, __) => _buildDateSelector(dtp),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateSelector(DateTimeProvider dtp) {
//     final today = DateTime.now();
//     final dates = List.generate(7, (i) => today.add(Duration(days: i)));

//     return SizedBox(
//       height: 68,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         itemCount: dates.length,
//         itemBuilder: (context, index) {
//           final date = dates[index];
//           final isSelected =
//               date.day == dtp.selectedDate.day &&
//               date.month == dtp.selectedDate.month;
//           final day = date.day.toString();
//           final suffix = _getDaySuffix(date.day);
//           final month = DateFormat('MMM').format(date);

//           return GestureDetector(
//             onTap: () {
//               if (!_requireNetwork()) return;
//               dtp.setStartDate(date);
//               _fetchFestivalPosters(date);
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: 58,
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xFF448AFF) : Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: isSelected
//                       ? const Color(0xFF448AFF)
//                       : Colors.grey.shade300,
//                 ),
//                 boxShadow: isSelected
//                     ? [
//                         BoxShadow(
//                           color: const Color(0xFFFFC107).withOpacity(0.35),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3),
//                         ),
//                       ]
//                     : [],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: day,
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.bold,
//                             color: isSelected ? Colors.black : Colors.black87,
//                           ),
//                         ),
//                         TextSpan(
//                           text: suffix,
//                           style: TextStyle(
//                             fontSize: 9,
//                             fontWeight: FontWeight.bold,
//                             color: isSelected ? Colors.black : Colors.black54,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Text(
//                     month,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: isSelected ? Colors.black : Colors.black54,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // FESTIVAL POSTERS  — hidden when empty
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildFestivalPostersSection() {
//     if (_isFestivalLoading) {
//       return SizedBox(
//         height: 155,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//           itemCount: 5,
//           itemBuilder: (_, __) => const _PosterCardSkeleton(),
//         ),
//       );
//     }
//     // Empty → show nothing
//     if (festivaldata.isEmpty) return const SizedBox.shrink();

//     return SizedBox(
//       height: 155,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
//         itemCount: festivaldata.length,
//         itemBuilder: (_, i) => _buildSmallPosterCard(festivaldata[i], i),
//       ),
//     );
//   }

//   Widget _buildSmallPosterCard(dynamic poster, int index) {
//     return GestureDetector(
//       onTap: () {
//         if (!_requireNetwork()) return;
//         final bgImageUrl = poster['designData']?['bgImage']?['url'] ?? '';
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => PosterEditorScreen(
//               posterAsset: bgImageUrl, // pass this
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: 110,
//         margin: const EdgeInsets.only(right: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(10),
//                 ),
//                 child: Image.network(
//                   poster['images'][0],
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) =>
//                       Container(color: const Color(0xFFF3F4F6)),
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;
//                     return const _SkeletonBox(
//                       width: 110,
//                       height: 100,
//                       borderRadius: 0,
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(7),
//               child: Text(
//                 poster['categoryName'] ?? 'Festival',
//                 style: const TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // WEEKLY TEMPLATES  — header + list, both hidden when empty
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildWeeklySectionWithHeader() {
//     if (_isWeeklyLoading) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             titleKey: 'weekly_templates',
//             subtitleKey: 'fresh_designs_everyday',
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             height: 140,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: 5,
//               itemBuilder: (_, __) => const _PosterCardSkeleton(),
//             ),
//           ),
//           const SizedBox(height: 12),
//         ],
//       );
//     }

//     // Check if there's actually any data
//     final orderedDays = _getOrderedDaysFromToday();
//     final hasAnyPosters = orderedDays.any(
//       (d) => (weeklyPosters[d] ?? []).isNotEmpty,
//     );
//     if (!hasAnyPosters) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionHeader(
//           titleKey: 'weekly_templates',
//           subtitleKey: 'fresh_designs_everyday',
//         ),
//         _buildWeeklyPostersSection(),
//         const SizedBox(height: 12),
//       ],
//     );
//   }

//   Widget _buildWeeklyPostersSection() {
//     final orderedDays = _getOrderedDaysFromToday();
//     final today = DateFormat('EEEE').format(DateTime.now());

//     return Consumer<LanguageProvider>(
//       builder: (context, lp, _) {
//         final langCode = lp.locale.languageCode;
//         return Column(
//           children: orderedDays.map((day) {
//             final posters = weeklyPosters[day] ?? [];
//             if (posters.isEmpty) return const SizedBox.shrink();
//             final isToday = day == today;
//             final translatedDay = LocalizationService.translate(day, langCode);
//             final todayPrefix = LocalizationService.translate(
//               'today_prefix',
//               langCode,
//             );

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: isToday
//                           ? const LinearGradient(
//                               colors: [Color(0xFFFFC107), Color(0xFFFF8F00)],
//                             )
//                           : null,
//                       color: isToday ? null : Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           isToday
//                               ? Icons.today_rounded
//                               : Icons.calendar_today_outlined,
//                           size: 16,
//                           color: isToday ? Colors.black : Colors.grey,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           isToday
//                               ? '$todayPrefix - $translatedDay'
//                               : translatedDay,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: isToday ? Colors.black : Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 140,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     itemCount: posters.length,
//                     itemBuilder: (_, i) =>
//                         _buildWeeklyPosterCard(posters[i], i),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//               ],
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   Widget _buildWeeklyPosterCard(dynamic poster, int index) {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myplanprovider, _) {
//         return GestureDetector(
//           onTap: () {
//             if (!_requireNetwork()) return;
//             if (myplanprovider.isPurchase) {
//               final bgImageUrl = poster['designData']?['bgImage']?['url'] ?? '';
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => PosterEditorScreen(
//                     posterAsset: bgImageUrl, // pass this
//                   ),
//                 ),
//               );
//             } else {
//               _showPremiumDialog();
//             }
//           },
//           child: Container(
//             width: 110,
//             margin: const EdgeInsets.only(right: 10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(10),
//                     ),
//                     child: Image.network(
//                       poster['images']?[0] ?? '',
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) =>
//                           Container(color: const Color(0xFFF3F4F6)),
//                       loadingBuilder: (context, child, progress) {
//                         if (progress == null) return child;
//                         return const _SkeletonBox(
//                           width: 110,
//                           height: 100,
//                           borderRadius: 0,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(6),
//                   child: Text(
//                     poster['categoryName'] ?? poster['name'] ?? 'Poster',
//                     style: const TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black87,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // HOT TOPICS / REELS
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildHotTopicsSection() {
//     return Consumer<HotTopicReelsProvider>(
//       builder: (context, hotTopicProvider, _) {
//         return Container(
//           color: Colors.white,
//           padding: const EdgeInsets.only(top: 12, bottom: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 2,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Hot Topics',
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         if (!_requireNetwork()) return;
//                         _goToReelsScreen(0);
//                       },
//                       child: const Text(
//                         'View All',
//                         style: TextStyle(
//                           color: Color(0xFFFFC107),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 180,
//                 child: (_isReelsLoading || hotTopicProvider.isLoading)
//                     ? ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         itemCount: 5,
//                         itemBuilder: (_, __) => const _ReelCardSkeleton(),
//                       )
//                     : hotTopicProvider.reels.isEmpty
//                     ? const SizedBox.shrink()
//                     : ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         itemCount: hotTopicProvider.reels.length,
//                         itemBuilder: (_, i) =>
//                             _buildReelCard(hotTopicProvider.reels[i], i),
//                       ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _goToReelsScreen(int initialIndex) {
//     Navigator.push(context, MaterialPageRoute(builder: (_) => HotScreen()));
//   }

//   Widget _buildReelCard(dynamic reel, int index) {
//     final videoUrl = reel.videoUrl ?? '';

//     return GestureDetector(
//       onTap: () {
//         if (!_requireNetwork()) return;
//         _goToReelsScreen(index);
//       },
//       child: Container(
//         width: 105,
//         margin: const EdgeInsets.only(right: 10),
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               _AutoPlayReelVideo(videoUrl: videoUrl),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 52,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.75),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                     borderRadius: const BorderRadius.vertical(
//                       bottom: Radius.circular(12),
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 7,
//                     vertical: 6,
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Icon(
//                         Icons.play_circle_fill_rounded,
//                         color: Colors.white70,
//                         size: 18,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // ALL CATEGORIES  — same layout as CategoryScreen, embedded in home
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildAllCategoriesSection() {
//     return Consumer<PosterProvider>(
//       builder: (context, posterProvider, _) {
//         // ── Loading skeleton ───────────────────────────────────────────────
//         if (posterProvider.isLoading) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: List.generate(
//               3,
//               (catIdx) => Padding(
//                 padding: const EdgeInsets.only(bottom: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 4,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _SkeletonBox(width: 140, height: 18, borderRadius: 4),
//                           _SkeletonBox(width: 60, height: 14, borderRadius: 4),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       height: 150,
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         itemCount: 4,
//                         itemBuilder: (_, __) => Padding(
//                           padding: const EdgeInsets.only(right: 12),
//                           child: const _SkeletonBox(
//                             width: 110,
//                             height: 130,
//                             borderRadius: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }

//         // ── Extract unique categories ──────────────────────────────────────
//         final allPosters = posterProvider.posters;
//         final Set<String> seen = {};
//         final List<String> categories = [];
//         for (final p in allPosters) {
//           if (p is CategoryModel &&
//               p.categoryName.isNotEmpty &&
//               seen.add(p.categoryName)) {
//             categories.add(p.categoryName);
//           }
//         }

//         if (categories.isEmpty) return const SizedBox.shrink();

//         // ── One block per category ─────────────────────────────────────────
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: categories.map((category) {
//             final categoryPosters = allPosters
//                 .whereType<CategoryModel>()
//                 .where(
//                   (p) => p.categoryName.toLowerCase() == category.toLowerCase(),
//                 )
//                 .toList();

//             if (categoryPosters.isEmpty) return const SizedBox.shrink();

//             return Container(
//               color: Colors.white,
//               margin: const EdgeInsets.only(bottom: 4),
//               padding: const EdgeInsets.only(top: 14, bottom: 14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── Header row ───────────────────────────────────────────
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             _capitalizeFirst(category),
//                             style: const TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF1A1A1A),
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Consumer<MyPlanProvider>(
//                           builder: (context, myPlanProvider, _) {
//                             return GestureDetector(
//                               onTap: () {
//                                 if (!_requireNetwork()) return;
//                                 if (myPlanProvider.isPurchase) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) =>
//                                           DetailsScreen(category: category),
//                                     ),
//                                   );
//                                 } else {
//                                   _showPremiumDialog();
//                                 }
//                               },
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: const [
//                                   Text(
//                                     'View All',
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w600,
//                                       color: Color(0xFF1A1A1A),
//                                     ),
//                                   ),
//                                   SizedBox(width: 3),
//                                   Icon(
//                                     Icons.arrow_forward_ios_rounded,
//                                     size: 12,
//                                     color: Color(0xFF1A1A1A),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   // ── Horizontal poster list ───────────────────────────────
//                   SizedBox(
//                     height: 150,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       physics: const BouncingScrollPhysics(),
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: categoryPosters.length,
//                       itemBuilder: (context, index) {
//                         final poster = categoryPosters[index];
//                         return Padding(
//                           padding: EdgeInsets.only(
//                             right: index == categoryPosters.length - 1 ? 0 : 12,
//                           ),
//                           child: _buildCategoryPosterCard(poster),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   Widget _buildCategoryPosterCard(CategoryModel poster) {
//     const double w = 110;
//     const double h = 130;
//     return Consumer<MyPlanProvider>(
//       builder: (context, myPlanProvider, _) {
//         return GestureDetector(
//           onTap: () {
//             if (!_requireNetwork()) return;
//             if (myPlanProvider.isPurchase) {
//               final bgImageUrl = poster.images[0] ?? '';
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => PosterEditorScreen(
//                     posterAsset: bgImageUrl, // pass this
//                   ),
//                 ),
//               );
//             } else {
//               _showPremiumDialog();
//             }
//           },
//           child: Container(
//             width: w,
//             height: h,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: poster.images.isNotEmpty
//                   ? Image.network(
//                       poster.images[0],
//                       fit: BoxFit.cover,
//                       width: w,
//                       height: h,
//                       loadingBuilder: (_, child, progress) {
//                         if (progress == null) return child;
//                         return const _SkeletonBox(
//                           width: w,
//                           height: h,
//                           borderRadius: 0,
//                         );
//                       },
//                       errorBuilder: (_, __, ___) => Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               const Color(0xFF4F46E5).withOpacity(0.1),
//                               const Color(0xFF7C3AED).withOpacity(0.1),
//                             ],
//                           ),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.image_outlined,
//                             size: 36,
//                             color: Color(0xFF9CA3AF),
//                           ),
//                         ),
//                       ),
//                     )
//                   : Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             const Color(0xFF4F46E5).withOpacity(0.1),
//                             const Color(0xFF7C3AED).withOpacity(0.1),
//                           ],
//                         ),
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.image_outlined,
//                           size: 36,
//                           color: Color(0xFF9CA3AF),
//                         ),
//                       ),
//                     ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _capitalizeFirst(String text) {
//     if (text.isEmpty) return '';
//     return text[0].toUpperCase() + text.substring(1);
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // SECTION HEADER
//   // ══════════════════════════════════════════════════════════════════════════

//   Widget _buildSectionHeader({
//     required String titleKey,
//     required String subtitleKey,
//     bool showViewAll = false,
//     VoidCallback? onViewAll,
//   }) {
//     return Consumer<LanguageProvider>(
//       builder: (context, lp, _) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     LocalizationService.translate(
//                       titleKey,
//                       lp.locale.languageCode,
//                     ),
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     LocalizationService.translate(
//                       subtitleKey,
//                       lp.locale.languageCode,
//                     ),
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//               if (showViewAll && onViewAll != null)
//                 GestureDetector(
//                   onTap: onViewAll,
//                   child: const Text(
//                     'View All',
//                     style: TextStyle(
//                       color: Color(0xFFFFC107),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // LANGUAGE SELECTOR
//   // ══════════════════════════════════════════════════════════════════════════

//   void _showLanguageSelector(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Select Language',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               _buildLangOption(
//                 context,
//                 dialogContext,
//                 'English',
//                 'en',
//                 Icons.language,
//               ),
//               const SizedBox(height: 12),
//               _buildLangOption(
//                 context,
//                 dialogContext,
//                 'हिंदी',
//                 'hi',
//                 Icons.translate,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLangOption(
//     BuildContext context,
//     BuildContext dialogContext,
//     String name,
//     String code,
//     IconData icon,
//   ) {
//     final lp = Provider.of<LanguageProvider>(context, listen: true);
//     final isSelected = lp.locale.languageCode == code;

//     return InkWell(
//       onTap: () async {
//         Navigator.pop(dialogContext);
//         late OverlayEntry overlayEntry;
//         overlayEntry = OverlayEntry(
//           builder: (overlayContext) => LanguageTransitionScreen(
//             languageName: name,
//             languageCode: code,
//             onComplete: () async {
//               final lp2 = Provider.of<LanguageProvider>(context, listen: false);
//               await lp2.setLocale(Locale(code));
//               overlayEntry.remove();
//               AppRestartService.restartApp(context);
//             },
//           ),
//         );
//         Overlay.of(context).insert(overlayEntry);
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? Colors.white.withOpacity(0.3)
//               : Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 24),
//             const SizedBox(width: 12),
//             Text(
//               name,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//             const Spacer(),
//             if (isSelected)
//               const Icon(Icons.check_circle, color: Colors.white, size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // PREMIUM DIALOG
//   // ══════════════════════════════════════════════════════════════════════════

//   void _showPremiumDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24),
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFFFAF5FF), Color(0xFFEEF2FF)],
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
//                   ),
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: const Color(0xFF6366F1).withOpacity(0.3),
//                       blurRadius: 16,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.workspace_premium,
//                   color: Colors.white,
//                   size: 32,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Unlock Premium',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Get access to exclusive templates and premium features.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Color(0xFF6B7280),
//                   height: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: const BorderSide(color: Color(0xFFE5E7EB)),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Maybe Later',
//                         style: TextStyle(
//                           color: Color(0xFF6B7280),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => SubscriptionPlansPage(),
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: const Color(0xFF6366F1),
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Upgrade Now',
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // REFER & EARN MODAL
//   // ══════════════════════════════════════════════════════════════════════════

//   void showReferAndEarnModal(BuildContext context) {
//     String? uid;
//     String? userReferralCode;
//     bool isLoading = true;
//     String? errorMessage;

//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: 'Refer and Earn',
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: const Duration(milliseconds: 300),
//       pageBuilder: (_, __, ___) => const SizedBox.shrink(),
//       transitionBuilder: (context, animation, __, ___) {
//         return FadeTransition(
//           opacity: animation,
//           child: ScaleTransition(
//             scale: Tween<double>(begin: 0.95, end: 1.0).animate(
//               CurvedAnimation(parent: animation, curve: Curves.easeOut),
//             ),
//             child: Center(
//               child: Material(
//                 color: Colors.transparent,
//                 child: StatefulBuilder(
//                   builder: (context, setModalState) {
//                     Future<void> loadReferralCode() async {
//                       try {
//                         setModalState(() {
//                           isLoading = true;
//                           errorMessage = null;
//                         });
//                         final userData = await AuthPreferences.getUserData();
//                         if (userData != null) {
//                           uid = userData.user.id;
//                           final response = await http.get(
//                             Uri.parse(
//                               'http://31.97.206.144:4061/api/users/refferalcode/$uid',
//                             ),
//                           );
//                           if (response.statusCode == 200) {
//                             final data = json.decode(response.body);
//                             final code =
//                                 data['referralCode'] ??
//                                 data['refferalCode'] ??
//                                 data['code'];
//                             setModalState(() {
//                               isLoading = false;
//                               userReferralCode = code;
//                               errorMessage = code == null
//                                   ? 'No referral code found'
//                                   : null;
//                             });
//                           } else {
//                             setModalState(() {
//                               isLoading = false;
//                               errorMessage = 'Failed to load referral code';
//                             });
//                           }
//                         }
//                       } catch (e) {
//                         setModalState(() {
//                           isLoading = false;
//                           errorMessage = 'Error: $e';
//                         });
//                       }
//                     }

//                     void shareCode() {
//                       if (userReferralCode != null) {
//                         Share.share(
//                           '🎉 Join me on EditEzy!\n\nUse my referral code: $userReferralCode\n\nGet exclusive benefits when you upgrade!\n\nhttps://play.google.com/store/apps/details?id=com.posternova.posternova',
//                           subject: 'Join EditEzy',
//                         );
//                       }
//                     }

//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       if (isLoading &&
//                           userReferralCode == null &&
//                           errorMessage == null) {
//                         loadReferralCode();
//                       }
//                     });

//                     return _FlippableReferModal(
//                       isLoading: isLoading,
//                       errorMessage: errorMessage,
//                       userReferralCode: userReferralCode,
//                       onLoadReferralCode: loadReferralCode,
//                       onShare: shareCode,
//                       onClose: () => Navigator.pop(context),
//                       onCopy: () {
//                         if (userReferralCode != null) {
//                           Clipboard.setData(
//                             ClipboardData(text: userReferralCode!),
//                           );
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Referral code copied!'),
//                               behavior: SnackBarBehavior.floating,
//                               backgroundColor: Color(0xFF10B981),
//                             ),
//                           );
//                         } else {
//                           loadReferralCode();
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _referStep(String number, String titleKey, String descKey) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 32,
//           height: 32,
//           decoration: BoxDecoration(
//             color: const Color(0xFF4F46E5).withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Text(
//               number,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF4F46E5),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 titleKey,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               AppText(
//                 descKey,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   color: Color(0xFF6B7280),
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // AUTO PLAY REEL VIDEO
// // ─────────────────────────────────────────────────────────────────────────────

// class _AutoPlayReelVideo extends StatefulWidget {
//   final String videoUrl;
//   const _AutoPlayReelVideo({required this.videoUrl});

//   @override
//   State<_AutoPlayReelVideo> createState() => _AutoPlayReelVideoState();
// }

// class _AutoPlayReelVideoState extends State<_AutoPlayReelVideo> {
//   VideoPlayerController? _controller;
//   bool _initialized = false;
//   bool _hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     _initVideo();
//   }

//   Future<void> _initVideo() async {
//     if (widget.videoUrl.isEmpty) {
//       setState(() => _hasError = true);
//       return;
//     }
//     try {
//       _controller = VideoPlayerController.networkUrl(
//         Uri.parse(widget.videoUrl),
//       );
//       await _controller!.initialize();
//       if (!mounted) return;
//       _controller!
//         ..setLooping(true)
//         ..setVolume(0)
//         ..play();
//       setState(() => _initialized = true);
//     } catch (_) {
//       if (mounted) setState(() => _hasError = true);
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_hasError || !_initialized || _controller == null) {
//       return Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: const Center(
//           child: Icon(
//             Icons.play_circle_outline_rounded,
//             color: Colors.white38,
//             size: 36,
//           ),
//         ),
//       );
//     }
//     return FittedBox(
//       fit: BoxFit.cover,
//       child: SizedBox(
//         width: _controller!.value.size.width,
//         height: _controller!.value.size.height,
//         child: VideoPlayer(_controller!),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // FLIPPABLE REFER MODAL
// // ─────────────────────────────────────────────────────────────────────────────

// class _FlippableReferModal extends StatefulWidget {
//   final bool isLoading;
//   final String? errorMessage;
//   final String? userReferralCode;
//   final VoidCallback onLoadReferralCode;
//   final VoidCallback onShare;
//   final VoidCallback onClose;
//   final VoidCallback onCopy;

//   const _FlippableReferModal({
//     required this.isLoading,
//     required this.errorMessage,
//     required this.userReferralCode,
//     required this.onLoadReferralCode,
//     required this.onShare,
//     required this.onClose,
//     required this.onCopy,
//   });

//   @override
//   State<_FlippableReferModal> createState() => _FlippableReferModalState();
// }

// class _FlippableReferModalState extends State<_FlippableReferModal>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _flipController;
//   late Animation<double> _flipAnimation;
//   bool _isFlipped = false;
//   bool _showBack = false;

//   @override
//   void initState() {
//     super.initState();
//     _flipController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
//     );
//     _flipAnimation.addListener(() {
//       if (_flipAnimation.value >= 0.5 && !_showBack)
//         setState(() => _showBack = true);
//       else if (_flipAnimation.value < 0.5 && _showBack)
//         setState(() => _showBack = false);
//     });
//   }

//   @override
//   void dispose() {
//     _flipController.dispose();
//     super.dispose();
//   }

//   void _flip() {
//     if (_isFlipped)
//       _flipController.reverse();
//     else
//       _flipController.forward();
//     _isFlipped = !_isFlipped;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 24),
//           constraints: const BoxConstraints(maxWidth: 500),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 16,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[50],
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey[200]!),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF4F46E5).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(
//                           Icons.people_outline,
//                           color: Color(0xFF4F46E5),
//                           size: 24,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Expanded(
//                         child: AppText(
//                           'refer_earn',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF111827),
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: _flip,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 10,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF4F46E5).withOpacity(0.08),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               AnimatedBuilder(
//                                 animation: _flipAnimation,
//                                 builder: (_, __) => Transform(
//                                   alignment: Alignment.center,
//                                   transform: Matrix4.rotationY(
//                                     _flipAnimation.value * 3.14159,
//                                   ),
//                                   child: const Icon(
//                                     Icons.flip_camera_android_rounded,
//                                     color: Color(0xFF4F46E5),
//                                     size: 16,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               Text(
//                                 _showBack ? 'My Code' : 'How it works',
//                                 style: const TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF4F46E5),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       IconButton(
//                         onPressed: widget.onClose,
//                         icon: const Icon(Icons.close, size: 24),
//                         color: Colors.grey[600],
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: _flip,
//                   child: AnimatedBuilder(
//                     animation: _flipAnimation,
//                     builder: (context, _) {
//                       final angle = _flipAnimation.value * 3.14159;
//                       final isSecondHalf = _flipAnimation.value >= 0.5;
//                       return Transform(
//                         alignment: Alignment.center,
//                         transform: Matrix4.identity()
//                           ..setEntry(3, 2, 0.001)
//                           ..rotateY(angle),
//                         child: Transform(
//                           alignment: Alignment.center,
//                           transform: isSecondHalf
//                               ? (Matrix4.identity()..rotateY(3.14159))
//                               : Matrix4.identity(),
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//                             child: _showBack
//                                 ? _buildHowItWorksContent()
//                                 : _buildMyCodeContent(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.touch_app_rounded,
//                         size: 13,
//                         color: Colors.grey[400],
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Tap card to flip',
//                         style: TextStyle(fontSize: 11, color: Colors.grey[400]),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: widget.onCopy,
//                           icon: const Icon(Icons.copy, size: 20),
//                           label: const Text('Copy Code'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4F46E5),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 0,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: widget.userReferralCode != null
//                               ? widget.onShare
//                               : null,
//                           icon: const Icon(Icons.share, size: 20),
//                           label: const Text('Share'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF10B981),
//                             foregroundColor: Colors.white,
//                             disabledBackgroundColor: Colors.grey[300],
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             elevation: 0,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMyCodeContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF0F9FF),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: const Color(0xFFBAE6FD)),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(7),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0EA5E9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(
//                   Icons.info_outline,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               const Expanded(
//                 child: AppText(
//                   'share_referral_earn',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF0C4A6E),
//                     height: 1.4,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 16),
//         const AppText(
//           'your_referral_code',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF374151),
//           ),
//         ),
//         const SizedBox(height: 10),
//         if (widget.isLoading)
//           Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey[200]!),
//             ),
//             child: const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 18,
//                   height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Color(0xFF4F46E5),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Text(
//                   'Loading...',
//                   style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//                 ),
//               ],
//             ),
//           )
//         else if (widget.errorMessage != null)
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFEF2F2),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFFECACA)),
//             ),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.error_outline,
//                   color: Color(0xFFEF4444),
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     widget.errorMessage!,
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: Color(0xFF991B1B),
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: widget.onLoadReferralCode,
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           )
//         else
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: const Color(0xFFC7D2FE)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.userReferralCode ?? '--',
//                         style: const TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 4,
//                           color: Color(0xFF4F46E5),
//                         ),
//                       ),
//                       const Text(
//                         'Your unique referral code',
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF4F46E5).withOpacity(0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.card_giftcard_rounded,
//                     color: Color(0xFF4F46E5),
//                     size: 28,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget _buildHowItWorksContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const AppText(
//           'how_it_works',
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF111827),
//           ),
//         ),
//         const SizedBox(height: 16),
//         _howItWorksStep(
//           '1',
//           Icons.share_rounded,
//           'share_your_code',
//           'send_referral_any_platform',
//           const Color(0xFF6366F1),
//         ),
//         const SizedBox(height: 12),
//         _howItWorksStep(
//           '2',
//           Icons.person_add_rounded,
//           'friend_signs_up',
//           'enter_code_during_signup',
//           const Color(0xFF0EA5E9),
//         ),
//         const SizedBox(height: 12),
//         _howItWorksStep(
//           '3',
//           Icons.emoji_events_rounded,
//           'earn_rewards',
//           'get_200_on_upgrade',
//           const Color(0xFF10B981),
//         ),
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget _howItWorksStep(
//     String number,
//     IconData icon,
//     String titleKey,
//     String descKey,
//     Color color,
//   ) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             shape: BoxShape.circle,
//           ),
//           child: Center(child: Icon(icon, color: color, size: 20)),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppText(
//                 titleKey,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 3),
//               AppText(
//                 descKey,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF6B7280),
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/banner_model.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/models/festival_poster_model.dart';
import 'package:posternova/models/hot_top.dart';
import 'package:posternova/models/weekly_template_model.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/PosterProvider/poster_provider.dart';
import 'package:posternova/providers/banner/banner_provider.dart';
import 'package:posternova/providers/festival/festival_posters_provider.dart';
import 'package:posternova/providers/festivals/date_time_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/providers/topics/hot_topic_provider.dart';
import 'package:posternova/providers/weekly/weekly_templates_provider.dart';
import 'package:posternova/views/ProfileScreen/profile_screen.dart';
import 'package:posternova/views/SecondPhase/poster_editor.dart';
import 'package:posternova/views/category/category_detail_screen.dart';
import 'package:posternova/views/category/search_category.dart';
import 'package:posternova/views/hot/hot_screen.dart';
import 'package:posternova/views/notifications/notification_screen.dart';
import 'package:posternova/views/stories/story_widget_screen.dart';
import 'package:posternova/widgets/home/celebration.dart';
import 'package:posternova/widgets/home/auto_video_player.dart';
import 'package:posternova/widgets/home/flipper_modal.dart';
import 'package:posternova/widgets/home/network.dart';
import 'package:posternova/widgets/home/skeleton.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ── User ───────────────────────────────────────────────────────────────────
  String? currentUserId;
  String? username;
  String? userImage;
  String? userId;

  // ── Data ───────────────────────────────────────────────────────────────────
  Map<String, dynamic> birthdayData = {};
  Map<String, dynamic> anniversaryData = {};
  Map<String, List<dynamic>> weeklyPosters = {};
  List<dynamic> customers = [];
  bool isLoadingCustomers = false;

  // ── Loading states ─────────────────────────────────────────────────────────
  bool _isBannerLoading = true;
  bool _isWeeklyLoading = true;
  bool _isFestivalLoading = true;
  bool _isReelsLoading = true;
  bool _isStoriesLoading = true;
  bool _isInitialLoad = true;

  static bool _hasShownReferAndEarnModal = false;
  static bool _hasLoadedOnce = false;

  List<dynamic> festivaldata = [];
  List<dynamic> canvaposter = [];
  List<dynamic> bannerList = [];

  // ── Celebration ────────────────────────────────────────────────────────────
  CelebrationConfig? _celebrationConfig;
  VideoPlayerController? _celebrationController;
  bool _celebrationVideoReady = false;

  // ── App defaults (used when no celebration theme) ──────────────────────────
  static const Color _defaultPrimaryText = Color(0xFF1A1A1A);
  static const Color _defaultSecondaryText = Colors.grey;
  static const Color _defaultSectionBg = Colors.white;
  static const Color _defaultAccent = Color(0xFFFFC107);

  // ── Resolved theme getters ─────────────────────────────────────────────────
  Color get _primaryText =>
      _celebrationConfig?.primaryTextColor ?? _defaultPrimaryText;
  Color get _secondaryText =>
      _celebrationConfig?.secondaryTextColor ?? _defaultSecondaryText;
  Color get _sectionBg =>
      _celebrationConfig?.sectionBgColor ?? _defaultSectionBg;
  Color get _accent => _celebrationConfig?.accentColor ?? _defaultAccent;
  bool get _hasTheme => _celebrationConfig?.hasTheme ?? false;

  // ── Network ────────────────────────────────────────────────────────────────
  bool _hasNetwork = true;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _noNetworkSheetShown = false;

  // ── Controllers ────────────────────────────────────────────────────────────
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

  late VideoPlayerController _videoController;

  // ══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController();
    _listenConnectivity();
    _checkNetwork().then((_) {
      _loadUserData();
      _loadUserId();
      if (!_hasLoadedOnce) {
        Future.microtask(() async => await _initializeAllData());
        _hasLoadedOnce = true;
      } else {
        setState(() {
          _isBannerLoading = false;
          _isWeeklyLoading = false;
          _isFestivalLoading = false;
          _isReelsLoading = false;
          _isStoriesLoading = false;
          _isInitialLoad = false;
        });
      }
    });
    _videoController = VideoPlayerController.asset("assets/videos/bg.webm")
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  // ── Celebration config fetch ───────────────────────────────────────────────

  Future<void> _fetchCelebrationConfig() async {
    // TODO: Uncomment API call when backend is ready
    // try {
    //   final response = await http.get(
    //     Uri.parse('http://31.97.206.144:4061/api/celebration/active'),
    //   );
    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     final config = CelebrationConfig.fromJson(data);
    //     if (config.enabled) {
    //       setState(() => _celebrationConfig = config);
    //       await _initCelebrationVideo(config);
    //     }
    //   }
    // } catch (e) {
    //   debugPrint('fetchCelebration: $e');
    // }

    // ── Hardcoded test config ──────────────────────────────────────────────
    // Simulate what backend would return:
    // {
    //   "enabled": true,
    //   "video_url": "",
    //   "duration_seconds": 0,
    //   "loop": true,
    //   "gradient_colors": ["#FF6B6B", "#4ECDC4"],
    //   "section_bg_color": "#FFF5F5",
    //   "primary_text_color": "#1A1A1A",
    //   "secondary_text_color": "#888888",
    //   "accent_color": "#FF6B6B"
    // }
    final config = CelebrationConfig.fromJson({
      'enabled': true,
      'video_url':
          'assets/videos/celebration.mp4', // empty → triggers local fallback
      'duration_seconds': 0, // 0 = play forever (loop: true)
      'loop': true,
      // Exact teal/mint green gradient from the Eid home screen
      'gradient_colors': ['#A8D5CC', '#C8E8E0'],
      'section_bg_color': '#C8E8E0', // same mint — sections blend into bg
      'primary_text_color': '#1A1A1A', // dark text readable on light mint
      'secondary_text_color': '#4A7A72', // muted teal for subtitles
      'accent_color': '#2E8B7A', // deeper teal for highlights
    });

    if (config.enabled) {
      setState(() => _celebrationConfig = config);
      await _initCelebrationVideo(config);
    }
  }

  Future<void> _initCelebrationVideo(CelebrationConfig config) async {
    // Try network URL first
    if (config.videoUrl.isNotEmpty) {
      try {
        _celebrationController = VideoPlayerController.networkUrl(
          Uri.parse(config.videoUrl),
        );
        await _celebrationController!.initialize();
        _setupAndPlayCelebration(config);
        return;
      } catch (e) {
        debugPrint('Network celebration video failed: $e');
        _celebrationController?.dispose();
        _celebrationController = null;
      }
    }

    // Fallback → local asset
    try {
      _celebrationController = VideoPlayerController.asset(
        'assets/videos/celebration.mp4',
      );
      await _celebrationController!.initialize();
      _setupAndPlayCelebration(config);
    } catch (e2) {
      debugPrint('Local celebration video also failed: $e2');
      _celebrationController?.dispose();
      _celebrationController = null;
      // Theme still applies even if video fails
      if (mounted) setState(() {});
    }
  }

  void _setupAndPlayCelebration(CelebrationConfig config) {
    if (!mounted || _celebrationController == null) return;
    _celebrationController!
      ..setLooping(config.loop)
      ..setVolume(0)
      ..play();

    setState(() => _celebrationVideoReady = true);

    // Auto-stop only if loop=false and duration > 0
    if (!config.loop && config.durationSeconds > 0) {
      Future.delayed(Duration(seconds: config.durationSeconds), () {
        if (mounted) {
          _celebrationController?.pause();
          setState(() => _celebrationVideoReady = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    _searchController.dispose();
    _connectivitySubscription?.cancel();
    _celebrationController?.dispose();
    _videoController.dispose();
    VoiceGreetingHelper.stop();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // NETWORK
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> _checkNetwork() async {
    try {
      final result = await Connectivity().checkConnectivity();
      final hasNet =
          result.isNotEmpty && !result.contains(ConnectivityResult.none);
      if (mounted) setState(() => _hasNetwork = hasNet);
      if (!hasNet) _showNoNetworkSheet();
    } catch (_) {}
  }

  void _listenConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final hasNet =
          results.isNotEmpty && !results.contains(ConnectivityResult.none);
      if (!mounted) return;
      final wasOffline = !_hasNetwork;
      setState(() {
        _hasNetwork = hasNet;
        if (hasNet) _noNetworkSheetShown = false;
      });
      if (!hasNet) {
        _showNoNetworkSheet();
      } else if (wasOffline && hasNet) {
        _initializeAllData();
      }
    });
  }

  void _showNoNetworkSheet() {
    if (_noNetworkSheetShown || !mounted) return;
    _noNetworkSheetShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (_) => NoNetworkSheet(
          onRetry: () async {
            Navigator.pop(context);
            _noNetworkSheetShown = false;
            await _checkNetwork();
            if (_hasNetwork) await _initializeAllData();
          },
        ),
      );
    });
  }

  bool _requireNetwork() {
    if (!_hasNetwork) {
      _noNetworkSheetShown = false;
      _showNoNetworkSheet();
      return false;
    }
    return true;
  }

  // ══════════════════════════════════════════════════════════════════════════
  // INIT HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> _initializeAllData() async {
    if (!mounted || !_hasNetwork) return;
    final selectedDate = context.read<DateTimeProvider>().selectedDate;

    // Set all loading states to true
    setState(() {
      _isStoriesLoading = true;
      _isFestivalLoading = true;
      _isWeeklyLoading = true;
      _isReelsLoading = true;
    });

    await Future.wait([
      _loadUserId().catchError((e) => debugPrint('loadUserId: $e')),
      _fetchnewposters().catchError((e) => debugPrint('fetchPosters: $e')),
      _initializeProviders().catchError((e) => debugPrint('providers: $e')),
      _fetchWeeklyPosters().catchError((e) => debugPrint('weeklyPosters: $e')),
      _fetchBanners().catchError((e) => debugPrint('banners: $e')),
      _initializeUser().catchError((e) => debugPrint('initializeUser: $e')),
      _fetchFestivalPosters(
        selectedDate,
      ).catchError((e) => debugPrint('festivalPosters: $e')),
      _fetchReels().catchError((e) => debugPrint('reels: $e')),
    ]);

    if (!mounted) return;

    // Set all loading states to false AFTER all data is loaded
    setState(() {
      _isStoriesLoading = false;
      _isFestivalLoading = false;
      _isWeeklyLoading = false;
      _isReelsLoading = false;
      _isInitialLoad = false;
    });

    _startBannerAutoScroll();
    _showInitialModals();
  }

  Future<void> _initializeProviders() async {
    if (!mounted) return;
    final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
    final posterProvider = Provider.of<PosterProvider>(context, listen: false);

    // Don't set _isStoriesLoading here anymore
    await Future.wait([
      myPlanProvider.fetchMyPlan(userId.toString()).catchError((_) => null),
      posterProvider.fetchPosters().catchError((_) => null),
    ]);

    if (!mounted) return;
    _showInitialModals();
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

      // Wait for stories to actually load
      await storyProvider.fetchStories();

      // Stories are now loaded, we can update loading state
      if (mounted) {
        setState(() => _isStoriesLoading = false);
      }
    }
  }

  void _showInitialModals() {
    if (!mounted) return;
    final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
    if (!myPlanProvider.isPurchase) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SubscriptionPlansPage()),
          );
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

  Future<void> _fetchBanners({bool forceRefresh = false}) async {
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);

    // Only fetch if no data or force refresh
    if (!bannerProvider.hasData || forceRefresh) {
      await bannerProvider.fetchBanners(forceRefresh: forceRefresh);
    }
  }

  void _startBannerAutoScroll() {
    final bannerProvider = Provider.of<BannerProvider>(context, listen: false);

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted ||
          !_bannerPageController.hasClients ||
          bannerProvider.bannerCount == 0)
        return;
      final next = (_currentBannerPage + 1) % bannerProvider.bannerCount;
      _bannerPageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _startBannerAutoScroll();
    });
  }

  Future<void> _fetchReels({bool forceRefresh = false}) async {
    if (userId == null) return;

    final hotTopicsProvider = Provider.of<HotTopicsProvider>(
      context,
      listen: false,
    );

    // Only fetch if no data or force refresh
    if (!hotTopicsProvider.hasData || forceRefresh) {
      await hotTopicsProvider.fetchHotTopicReels(
        userId: userId,
        forceRefresh: forceRefresh,
      );
    }
  }

  Future<void> _fetchWeeklyPosters({bool forceRefresh = false}) async {
    if (userId == null) return;

    final weeklyProvider = Provider.of<WeeklyTemplatesProvider>(
      context,
      listen: false,
    );

    // Only fetch if no data or force refresh
    if (!weeklyProvider.hasData || forceRefresh) {
      await weeklyProvider.fetchWeeklyPosters(
        userId!,
        forceRefresh: forceRefresh,
      );
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
        final response = await http.get(
          Uri.parse(
            'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
          ),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (mounted)
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
      if (mounted)
        setState(() {
          userId = userData.user.id;
          username = userData.user.name;
          userImage = userData.user.profileImage;
        });
      _fetchUserProfile(userData.user.id);
      fetchCustomers();
    }
  }

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

  Future<void> fetchCustomers() async {
    if (userId == null) return;
    setState(() => isLoadingCustomers = true);
    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted)
          setState(() {
            customers = data['customers'] ?? [];
            isLoadingCustomers = false;
          });
      } else {
        if (mounted) setState(() => isLoadingCustomers = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingCustomers = false);
    }
  }

  String _formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  Future<void> _fetchFestivalPosters(
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    final festivalProvider = Provider.of<FestivalPostersProvider>(
      context,
      listen: false,
    );

    print('🎯 _fetchFestivalPosters called for date: ${_formatDate(date)}');

    // Check if we have cached data for this date
    if (!forceRefresh && festivalProvider.hasCachedDataForDate(date)) {
      print('Using cached festival posters for date: ${_formatDate(date)}');
      // Even with cache, make sure we update the UI
      if (mounted) {
        setState(() {
          _isFestivalLoading = false;
        });
      }
      return;
    }

    print(
      '🌐 Fetching festival posters from API for date: ${_formatDate(date)}',
    );
    await festivalProvider.fetchFestivalPosters(
      date,
      forceRefresh: forceRefresh,
    );
    print(
      '✅ Festival posters fetched, count: ${festivalProvider.festivalPosters.length}',
    );
  }

  Future<void> _fetchnewposters() async {
    try {
      final cp = Provider.of<CanvaPosterProvider>(context, listen: false);
      await cp.fetchPosters();
      if (mounted) setState(() => canvaposter = cp.posters);
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
    super.build(context);

    // ── Body background: gradient if celebration theme active, else white ──
    Widget body = _hasTheme
        ? Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _celebrationConfig!.gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: _buildScrollContent(),
          )
        : _buildScrollContent();

    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          body,
          if (!_hasNetwork)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: Container(color: Colors.black.withOpacity(0.01)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScrollContent() {
    return RefreshIndicator(
      onRefresh: () async {
        if (!_requireNetwork()) return;
        await Future.wait([
          Provider.of<FestivalPostersProvider>(
            context,
            listen: false,
          ).refresh(),
          _fetchnewposters(),
          Provider.of<WeeklyTemplatesProvider>(
            context,
            listen: false,
          ).refresh(userId!),
          Provider.of<BannerProvider>(context, listen: false).refresh(),
          Provider.of<HotTopicsProvider>(
            context,
            listen: false,
          ).refreshWithUserId(userId!),
        ]);
      },
      color: _accent,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildBannerSection(),
                const SizedBox(height: 12),
                // ── Explore (stories) + celebration video below it ──────────
                _buildForYouSection(),
                // ── Inline celebration video — plays right after stories ────
                if (_celebrationVideoReady &&
                    _celebrationController != null &&
                    _celebrationController!.value.isInitialized)
                  CelebrationVideoWidget(controller: _celebrationController!),
                const SizedBox(height: 12),
                _buildUpcomingFestivalsSection(),
                _buildFestivalPostersSection(),
                const SizedBox(height: 12),
                _buildWeeklySectionWithHeader(),
                _buildHotTopicsSection(),
                const SizedBox(height: 12),
                _buildAllCategoriesSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // APP BAR
  // ══════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: BoxDecoration(
          // Use celebration gradient on AppBar when theme active, else brand blue
          gradient: _hasTheme && _celebrationConfig?.gradientColors != null
              ? LinearGradient(
                  colors: _celebrationConfig!.gradientColors!,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: _hasTheme ? null : const Color(0xFF448AFF),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (!_requireNetwork()) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
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
                if (!_hasNetwork)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Offline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
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
                        if (!_requireNetwork()) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NotificationScreen(userId: userId.toString()),
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
                GestureDetector(
                  onTap: () {
                    if (!_requireNetwork()) return;
                    _showLanguageSelector(context);
                  },
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

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        if (!_requireNetwork()) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        color: _sectionBg,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(5),
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
  // BANNER
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildBannerSection() {
    return Consumer<BannerProvider>(
      builder: (context, bannerProvider, _) {
        // Show loading only on first load when no data
        if (bannerProvider.isLoading && !bannerProvider.hasData) {
          return const SizedBox(
            height: 136,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: BannerSkeleton(),
            ),
          );
        }

        if (bannerProvider.banners.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _bannerPageController,
                onPageChanged: (i) => setState(() => _currentBannerPage = i),
                itemCount: bannerProvider.bannerCount,
                itemBuilder: (_, i) =>
                    _buildBannerItem(bannerProvider.getBannerByIndex(i)!),
              ),
            ),
            if (bannerProvider.bannerCount > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(bannerProvider.bannerCount, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentBannerPage == i ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: _currentBannerPage == i
                            ? _accent
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
              ),
          ],
        );
      },
    );
  }

  // Update _buildBannerItem to accept BannerModel:
  Widget _buildBannerItem(BannerModel banner) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            banner.imageUrl.isNotEmpty
                ? Image.network(
                    banner.imageUrl,
                    fit: BoxFit.fill,
                    errorBuilder: (_, __, ___) => _buildBannerGradient(),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _buildBannerGradient(),
                  )
                : _buildBannerGradient(),
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
    );
  }

  Widget _buildBannerGradient() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors:
            _celebrationConfig?.gradientColors ??
            [const Color.fromARGB(255, 126, 211, 47), const Color(0xFFB71C1C)],
      ),
    ),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // FOR YOU / EXPLORE (Stories)
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildForYouSection() {
    return Container(
      color: _sectionBg,
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 1),
            child: Text(
              'Explore',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _primaryText,
              ),
            ),
          ),
          _isStoriesLoading
              ? const StorySkeleton()
              : StoriesWidget(profile: userImage),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // UPCOMING FESTIVALS — date selector
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildUpcomingFestivalsSection() {
    return Container(
      color: _sectionBg,
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Text(
              'Upcoming Festivals',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: _primaryText,
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

  // Update _buildDateSelector to work with FestivalPostersProvider:
  Widget _buildDateSelector(DateTimeProvider dtp) {
    final today = DateTime.now();
    final dates = List.generate(7, (i) => today.add(Duration(days: i)));

    return Consumer<FestivalPostersProvider>(
      builder: (context, festivalProvider, _) {
        return SizedBox(
          height: 68,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              // IMPORTANT: Use festivalProvider.selectedDate, not dtp.selectedDate
              final isSelected =
                  date.year == festivalProvider.selectedDate.year &&
                  date.month == festivalProvider.selectedDate.month &&
                  date.day == festivalProvider.selectedDate.day;

              final day = date.day.toString();
              final suffix = _getDaySuffix(date.day);
              final month = DateFormat('MMM').format(date);
              final hasCache = festivalProvider.hasCachedDataForDate(date);

              return GestureDetector(
                onTap: () async {
                  if (!_requireNetwork()) return;

                  print('\n=== 🎯 Date Tapped ===');
                  print('Date: ${_formatDateForDebug(date)}');
                  print(
                    'Provider current date: ${_formatDateForDebug(festivalProvider.selectedDate)}',
                  );
                  print('Is selected: $isSelected');

                  if (isSelected) {
                    print('Same date, skipping');
                    return;
                  }

                  setState(() {
                    _isFestivalLoading = true;
                  });

                  // Update DateTimeProvider if needed
                  dtp.setStartDate(date);

                  // Call changeDate on the provider
                  final success = await festivalProvider.changeDate(date);
                  print('Change date success: $success');
                  print(
                    'New posters count: ${festivalProvider.festivalPosters.length}',
                  );
                  print(
                    'New date in provider: ${_formatDateForDebug(festivalProvider.selectedDate)}',
                  );

                  setState(() {
                    _isFestivalLoading = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 58,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? _accent : _sectionBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? _accent : Colors.grey.shade300,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: _accent.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    // ← Add this Center widget
                    child: Stack(
                      alignment: Alignment.center, // ← Center the stack content
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // ← Center horizontally
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: day,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : _primaryText,
                                    ),
                                  ),
                                  TextSpan(
                                    text: suffix,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white70
                                          : _secondaryText,
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
                                color: isSelected
                                    ? Colors.white
                                    : _secondaryText,
                              ),
                            ),
                          ],
                        ),
                        if (hasCache && !isSelected)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        if (isSelected && _isFestivalLoading)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isSelected ? Colors.white : _accent,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Add helper method to compare dates
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Update _buildFestivalPostersSection to properly react to changes
  Widget _buildFestivalPostersSection() {
    return Consumer<FestivalPostersProvider>(
      builder: (context, festivalProvider, _) {
        // Add debug print to see when this rebuilds
        print(
          '🔥 _buildFestivalPostersSection REBUILDING - Date: ${_formatDateForDebug(festivalProvider.selectedDate)}, Posters: ${festivalProvider.festivalPosters.length}',
        );

        // Show loading state
        if (_isFestivalLoading || festivalProvider.isLoading) {
          print('⏳ Showing loading skeleton');
          return SizedBox(
            height: 155,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              itemCount: 5,
              itemBuilder: (_, __) => const PosterCardSkeleton(),
            ),
          );
        }

        // Check if we have data
        if (festivalProvider.festivalPosters.isEmpty) {
          print(
            '📭 No posters available for selected date: ${_formatDateForDebug(festivalProvider.selectedDate)}',
          );
          return SizedBox();
        }

        // Show posters
        print(
          '🎨 Showing ${festivalProvider.festivalPosters.length} posters for date: ${_formatDateForDebug(festivalProvider.selectedDate)}',
        );
        return SizedBox(
          height: 155,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            itemCount: festivalProvider.festivalPosters.length,
            itemBuilder: (_, i) {
              final poster = festivalProvider.festivalPosters[i];
              print('   Poster $i: ${poster.categoryName}');
              return _buildSmallPosterCard(poster, i);
            },
          ),
        );
      },
    );
  }

  // Add this helper method
  String _formatDateForDebug(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  // Update _buildSmallPosterCard to accept FestivalPoster:
  Widget _buildSmallPosterCard(FestivalPoster poster, int index) {
    return GestureDetector(
      onTap: () {
        if (!_requireNetwork()) return;
        final bgImageUrl =
            poster.designData?['bgImage']?['url'] ?? poster.imageUrl;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PosterEditorScreen(posterAsset: bgImageUrl),
          ),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: _sectionBg,
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
                  poster.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFFF3F4F6)),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SkeletonBox(
                      width: 110,
                      height: 100,
                      borderRadius: 0,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                poster.categoryName,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _primaryText,
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
  // WEEKLY TEMPLATES
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildWeeklySectionWithHeader() {
    return Consumer<WeeklyTemplatesProvider>(
      builder: (context, weeklyProvider, _) {
        // Show loading only on first load when no data
        if (weeklyProvider.isLoading && !weeklyProvider.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                titleKey: 'weekly_templates',
                subtitleKey: 'fresh_designs_everyday',
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 5,
                  itemBuilder: (_, __) => const PosterCardSkeleton(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }

        final orderedDays = _getOrderedDaysFromToday();
        final hasAnyPosters = orderedDays.any(
          (d) => weeklyProvider.getPostersForDay(d).isNotEmpty,
        );

        if (!hasAnyPosters) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              titleKey: 'weekly_templates',
              subtitleKey: 'fresh_designs_everyday',
            ),
            _buildWeeklyPostersSection(weeklyProvider),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  // Update _buildWeeklyPostersSection:
  Widget _buildWeeklyPostersSection(WeeklyTemplatesProvider weeklyProvider) {
    final orderedDays = _getOrderedDaysFromToday();
    final today = DateFormat('EEEE').format(DateTime.now());

    return Consumer<LanguageProvider>(
      builder: (context, lp, _) {
        final langCode = lp.locale.languageCode;
        return Column(
          children: orderedDays.map((day) {
            final posters = weeklyProvider.getPostersForDay(day);
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
                          ? LinearGradient(
                              colors:
                                  _celebrationConfig?.gradientColors ??
                                  [
                                    const Color(0xFFFFC107),
                                    const Color(0xFFFF8F00),
                                  ],
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
                          color: isToday ? Colors.white : _secondaryText,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isToday
                              ? '$todayPrefix - $translatedDay'
                              : translatedDay,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.white : _primaryText,
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

  // Update _buildWeeklyPosterCard to accept WeeklyTemplate:
  Widget _buildWeeklyPosterCard(WeeklyTemplate poster, int index) {
    return Consumer<MyPlanProvider>(
      builder: (context, myplanprovider, _) {
        return GestureDetector(
          onTap: () {
            if (!_requireNetwork()) return;
            // if (myplanprovider.isPurchase) {
            //   final bgImageUrl =
            //       poster.designData?['bgImage']?['url'] ?? poster.imageUrl;
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (_) => PosterEditorScreen(posterAsset: bgImageUrl),
            //     ),
            //   );
            // } else {
            //   _showPremiumDialog();
            // }

            // if (myplanprovider.isPurchase) {
            final bgImageUrl =
                poster.designData?['bgImage']?['url'] ?? poster.imageUrl;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PosterEditorScreen(posterAsset: bgImageUrl),
              ),
            );
            // } else {
            //   _showPremiumDialog();
            // }
          },
          child: Container(
            width: 110,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: _sectionBg,
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
                      poster.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFF3F4F6)),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SkeletonBox(
                          width: 110,
                          height: 100,
                          borderRadius: 0,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    poster.categoryName.isNotEmpty
                        ? poster.categoryName
                        : (poster.name ?? 'Poster'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _primaryText,
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
  // HOT TOPICS / REELS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildHotTopicsSection() {
    return Consumer<HotTopicsProvider>(
      builder: (context, hotTopicsProvider, _) {
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
                child: _buildReelsContent(hotTopicsProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReelsContent(HotTopicsProvider provider) {
    // Show loading only on first load when no data
    if (provider.isLoading && !provider.hasData) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFC107)),
      );
    }

    // Show placeholders if no data
    if (provider.reels.isEmpty) {
      return _buildReelPlaceholders();
    }

    // Show reels list
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: provider.reelCount,
      itemBuilder: (_, i) => _buildReelCard(provider.getReelByIndex(i)!, i),
    );
  }

  // Update _buildReelCard to accept ReelModel:
  Widget _buildReelCard(ReelModel reel, int index) {
    final videoUrl = reel.videoUrl.isNotEmpty
        ? reel.videoUrl
        : 'assets/videos/celebration.mp4';
    print("Playing reel video: $videoUrl");

    return GestureDetector(
      onTap: () {
        if (!_requireNetwork()) return;
        _goToReelsScreen(index);
      },
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
              AutoPlayReelVideo(videoUrl: videoUrl),
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
                      // Optional: Add title if available
                      if (reel.title != null)
                        Expanded(
                          child: Text(
                            reel.title!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
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

  void _goToReelsScreen(int initialIndex) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => HotScreen()));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ALL CATEGORIES
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildAllCategoriesSection() {
    return Consumer<PosterProvider>(
      builder: (context, posterProvider, _) {
        if (posterProvider.isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              3,
              (catIdx) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonBox(width: 130, height: 18, borderRadius: 4),
                          SkeletonBox(width: 60, height: 14, borderRadius: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 4,
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: const SkeletonBox(
                            width: 110,
                            height: 130,
                            borderRadius: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final allPosters = posterProvider.posters;
        final Set<String> seen = {};
        final List<String> categories = [];
        for (final p in allPosters) {
          if (p is CategoryModel &&
              p.categoryName.isNotEmpty &&
              seen.add(p.categoryName))
            categories.add(p.categoryName);
        }
        if (categories.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categories.map((category) {
            final categoryPosters = allPosters
                .whereType<CategoryModel>()
                .where(
                  (p) => p.categoryName.toLowerCase() == category.toLowerCase(),
                )
                .toList();
            if (categoryPosters.isEmpty) return const SizedBox.shrink();
            return Container(
              color: _sectionBg,
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.only(top: 14, bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _capitalizeFirst(category),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: _primaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Consumer<MyPlanProvider>(
                          builder: (context, myPlanProvider, _) {
                            return GestureDetector(
                              onTap: () {
                                if (!_requireNetwork()) return;
                                if (myPlanProvider.isPurchase)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DetailsScreen(category: category),
                                    ),
                                  );
                                else
                                  _showPremiumDialog();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _primaryText,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                    color: _primaryText,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categoryPosters.length,
                      itemBuilder: (context, index) {
                        final poster = categoryPosters[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == categoryPosters.length - 1 ? 0 : 12,
                          ),
                          child: _buildCategoryPosterCard(poster),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCategoryPosterCard(CategoryModel poster) {
    const double w = 110;
    const double h = 130;
    return Consumer<MyPlanProvider>(
      builder: (context, myPlanProvider, _) {
        return GestureDetector(
          onTap: () {
            if (!_requireNetwork()) return;
            if (myPlanProvider.isPurchase) {
              final bgImageUrl = poster.images[0] ?? '';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PosterEditorScreen(posterAsset: bgImageUrl),
                ),
              );
            } else {
              _showPremiumDialog();
            }
          },
          child: Container(
            width: w,
            height: h,
            decoration: BoxDecoration(
              color: _sectionBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: poster.images.isNotEmpty
                  ? Image.network(
                      poster.images[0],
                      fit: BoxFit.cover,
                      width: w,
                      height: h,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const SkeletonBox(
                          width: w,
                          height: h,
                          borderRadius: 0,
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF4F46E5).withOpacity(0.1),
                              const Color(0xFF7C3AED).withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 36,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF4F46E5).withOpacity(0.1),
                            const Color(0xFF7C3AED).withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 36,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
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
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _primaryText,
                    ),
                  ),
                  Text(
                    LocalizationService.translate(
                      subtitleKey,
                      lp.locale.languageCode,
                    ),
                    style: TextStyle(fontSize: 12, color: _secondaryText),
                  ),
                ],
              ),
              if (showViewAll && onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: _accent,
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
  // LANGUAGE SELECTOR
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
  // REFER & EARN MODAL
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
                          errorMessage == null)
                        loadReferralCode();
                    });

                    return FlippableReferModal(
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
}
