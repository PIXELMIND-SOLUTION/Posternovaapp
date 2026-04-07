import 'dart:convert';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/banner_model.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/models/festival_poster_model.dart';
import 'package:posternova/models/hot_top.dart';
import 'package:posternova/models/weekly_template_model.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/PosterProvider/poster_provider.dart';
import 'package:posternova/providers/adminamount/admin_amount_provider.dart';
import 'package:posternova/providers/banner/banner_provider.dart';
import 'package:posternova/providers/celebration/celebration_provider.dart';
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
import 'package:posternova/views/reels/exo_video_player.dart';
import 'package:posternova/views/stories/story_widget_screen.dart';
import 'package:posternova/widgets/home/active_time_widget.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
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

  static const String _KEY_REFER_MODAL_SHOWN = 'refer_modal_last_shown';
  static const int MODAL_COOLDOWN_HOURS = 24;

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

  List<String> _wishesList = [];
  bool _isLoadingWishes = false;

  static bool _hasShownReferAndEarnModal = false;
  // static bool _hasLoadedOnce = false;

  List<dynamic> festivaldata = [];
  List<dynamic> canvaposter = [];
  List<dynamic> bannerList = [];

  // ── Celebration ────────────────────────────────────────────────────────────
  bool _celebrationVideoReady = false;

  // ── App defaults (used when no celebration theme) ──────────────────────────
  static const Color _defaultPrimaryText = Color(0xFF1A1A1A);
  static const Color _defaultSecondaryText = Colors.grey;
  static const Color _defaultSectionBg = Colors.white;
  static const Color _defaultAccent = Color(0xFFFFC107);

  // ── Resolved theme getters ─────────────────────────────────────────────────
  // Update the getters to use provider:
  Color get _primaryText =>
      Provider.of<CelebrationProvider>(context, listen: false).primaryTextColor;
  Color get _secondaryText => Provider.of<CelebrationProvider>(
    context,
    listen: false,
  ).secondaryTextColor;
  Color get _sectionBg =>
      Provider.of<CelebrationProvider>(context, listen: false).sectionBgColor;
  Color get _accent =>
      Provider.of<CelebrationProvider>(context, listen: false).accentColor;
  bool get _hasTheme =>
      Provider.of<CelebrationProvider>(context, listen: false).hasTheme;
  bool get _hasCelebrationMedia =>
      Provider.of<CelebrationProvider>(context, listen: false).hasMedia;
  CelebrationConfig? get _celebrationConfig => Provider.of<CelebrationProvider>(
    context,
    listen: false,
  ).celebrationConfig;
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

  bool _showWishesSection = true;
  bool _showCustomerCelebrationsSection = true;
  List<String> _customerCelebrationsList = [];
  bool _isLoadingCelebrations = false;

  // ══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ══════════════════════════════════════════════════════════════════════════

  // Add these methods
  Future<bool> _shouldShowReferModal() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShownTimestamp = prefs.getInt(_KEY_REFER_MODAL_SHOWN);

    if (lastShownTimestamp == null) {
      return true; // Never shown before
    }

    final lastShownDate = DateTime.fromMillisecondsSinceEpoch(
      lastShownTimestamp,
    );
    final currentDate = DateTime.now();
    final difference = currentDate.difference(lastShownDate);

    // Return true if 24 hours have passed
    return difference.inHours >= MODAL_COOLDOWN_HOURS;
  }

  Future<void> _saveReferModalShownTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _KEY_REFER_MODAL_SHOWN,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> _resetReferModalCooldown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_KEY_REFER_MODAL_SHOWN);
  }

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController();
    _listenConnectivity();
    _checkNetwork().then((_) {
      _loadUserData();
      _loadUserId();
      // if (!_hasLoadedOnce) {
      Future.microtask(() async => await _initializeAllData());
      // _hasLoadedOnce = true;
      // } else {
      //   setState(() {
      //     _isBannerLoading = false;
      //     _isWeeklyLoading = false;
      //     _isFestivalLoading = false;
      //     _isReelsLoading = false;
      //     _isStoriesLoading = false;
      //     _isInitialLoad = false;
      //   });
      // }
    });
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    _searchController.dispose();
    _connectivitySubscription?.cancel();
    VoiceGreetingHelper.stop();
    super.dispose();
  }

  Future<void> _fetchWishes() async {
    if (userId == null) return;

    setState(() => _isLoadingWishes = true);

    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/users/wishes/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _wishesList = data['wishes'] != null
              ? List<String>.from(data['wishes'])
              : [];
          _isLoadingWishes = false;
        });
      } else {
        setState(() => _isLoadingWishes = false);
      }
    } catch (e) {
      print('Error fetching wishes: $e');
      setState(() => _isLoadingWishes = false);
    }
  }

  Future<void> _fetchCustomerCelebrations() async {
    if (userId == null) return;

    setState(() => _isLoadingCelebrations = true);

    try {
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final customers = data['customers'] ?? [];
        final today = DateTime.now();
        final List<String> celebrations = [];

        for (var customer in customers) {
          // Check birthdays
          if (customer['dob'] != null && customer['dob'].isNotEmpty) {
            try {
              final dob = DateTime.parse(customer['dob']);
              if (dob.month == today.month && dob.day == today.day) {
                final age = today.year - dob.year;
                final suffix = _getAgeSuffix(age);
                celebrations.add(
                  "🎂 Happy ${age}${suffix} Birthday ${customer['name']}!",
                );
              }
            } catch (_) {}
          }

          // Check anniversaries
          if (customer['anniversaryDate'] != null &&
              customer['anniversaryDate'].isNotEmpty) {
            try {
              final anniversary = DateTime.parse(customer['anniversaryDate']);
              if (anniversary.month == today.month &&
                  anniversary.day == today.day) {
                final years = today.year - anniversary.year;
                final suffix = _getAgeSuffix(years);
                celebrations.add(
                  "💐 Happy ${years}${suffix} Anniversary ${customer['name']}!",
                );
              }
            } catch (_) {}
          }
        }

        setState(() {
          _customerCelebrationsList = celebrations;
          _isLoadingCelebrations = false;
        });
      } else {
        setState(() => _isLoadingCelebrations = false);
      }
    } catch (e) {
      print('Error fetching celebrations: $e');
      setState(() => _isLoadingCelebrations = false);
    }
  }

  String _getAgeSuffix(int age) {
    if (age % 10 == 1 && age != 11) return 'st';
    if (age % 10 == 2 && age != 12) return 'nd';
    if (age % 10 == 3 && age != 13) return 'rd';
    return 'th';
  }

  void _saveWishesPreference(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_wishes_section', show);
  }

  void _saveCelebrationsPreference(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_customer_celebrations', show);
  }

  Future<void> _loadSectionPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showWishesSection = prefs.getBool('show_wishes_section') ?? true;
      _showCustomerCelebrationsSection =
          prefs.getBool('show_customer_celebrations') ?? true;
    });
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

    // Fetch celebration config through provider
    final celebrationProvider = Provider.of<CelebrationProvider>(
      context,
      listen: false,
    );
    await celebrationProvider.fetchCelebrationConfig();

    final adminAmountProvider = Provider.of<AdminAmountProvider>(
      context,
      listen: false,
    );
    adminAmountProvider.fetchAdminAmounts();

    await Future.wait([
      _loadUserId().catchError((e) => debugPrint('loadUserId: $e')),
      _loadSectionPreferences(), // Add this
      _fetchWishes(), // Add this
      _fetchFestivalPosters(
        selectedDate,
      ).catchError((e) => debugPrint('festivalPosters: $e')),
      _fetchnewposters().catchError((e) => debugPrint('fetchPosters: $e')),
      _initializeProviders().catchError((e) => debugPrint('providers: $e')),
      _fetchWeeklyPosters().catchError((e) => debugPrint('weeklyPosters: $e')),
      _fetchBanners().catchError((e) => debugPrint('banners: $e')),
      _initializeUser().catchError((e) => debugPrint('initializeUser: $e')),

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
  }

  Future<void> _initializeProviders() async {
    if (!mounted) return;
    // final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
    final posterProvider = Provider.of<PosterProvider>(context, listen: false);

    // Don't set _isStoriesLoading here anymore
    await Future.wait([
      // myPlanProvider.fetchMyPlan(userId.toString()).catchError((_) => null),
      posterProvider.fetchPosters().catchError((_) => null),
    ]);

    if (!mounted) return;
  }

  Future<void> _initializeUser() async {
    final userData = await AuthPreferences.getUserData();
    if (userData != null && userData.user.id != null) {
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      final myPlanProvider = Provider.of<MyPlanProvider>(
        context,
        listen: false,
      );

      await myPlanProvider
          .fetchMyPlan(userId.toString())
          .catchError((_) => null);
      _showInitialModals();

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

  // void _showInitialModals() {
  //   if (!mounted) return;
  //   final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);
  //   if (!myPlanProvider.isPurchase) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (mounted)
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (_) => SubscriptionPlansPage()),
  //         );
  //     });
  //   }
  //   if (!_hasShownReferAndEarnModal) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (mounted) {
  //         showReferAndEarnModal(context);
  //         _hasShownReferAndEarnModal = true;
  //       }
  //     });
  //   }
  // }

  void _showInitialModals() async {
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

    // Check if we should show the Refer & Earn modal
    final shouldShow = await _shouldShowReferModal();

    if (shouldShow && !_hasShownReferAndEarnModal) {
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
    return Consumer<CelebrationProvider>(
      builder: (context, celebrationProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            if (!_requireNetwork()) return;
            await Future.wait([
              _fetchWishes(),
              _fetchCustomerCelebrations(),
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
              // Refresh celebration data
              celebrationProvider.fetchCelebrationConfig(forceRefresh: true),
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
                    // const SizedBox(height: 12),
                    // ── Explore (stories) ──────────
                    _buildForYouSection(),
                    // const SizedBox(height: 12),
                    // ── Celebration Media (Video/GIF) ──
                    if (celebrationProvider.hasMedia)
                      _buildCelebrationMedia(
                        celebrationProvider.celebrationConfig!,
                      ),
                    // const SizedBox(height: 12),
                    _buildUpcomingFestivalsSection(),
                    _buildFestivalPostersSection(),
                    // const SizedBox(height: 12),
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
      },
    );
  }

  // Widget _buildCelebrationMedia(CelebrationConfig config) {
  //   final isGif = config.mediaType == MediaType.gif;

  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(0),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(0),
  //       child: isGif
  //           ? _buildGifWidget(config.mediaUrl)
  //           : _buildVideoWidget(config.mediaUrl),
  //     ),
  //   );
  // }

  // Widget _buildVideoWidget(String url) {
  //   return AspectRatio(
  //     aspectRatio: 16 / 9,
  //     child: ExoVideoPlayer(url: url, autoPlay: true),
  //   );
  // }

  // Widget _buildGifWidget(String url) {
  //   return AspectRatio(
  //     aspectRatio: 16 / 9,
  //     child: Image.network(
  //       url,
  //       fit: BoxFit.cover,
  //       loadingBuilder: (context, child, loadingProgress) {
  //         if (loadingProgress == null) return child;
  //         return Center(
  //           child: CircularProgressIndicator(
  //             value: loadingProgress.expectedTotalBytes != null
  //                 ? loadingProgress.cumulativeBytesLoaded /
  //                       loadingProgress.expectedTotalBytes!
  //                 : null,
  //             color: _accent,
  //           ),
  //         );
  //       },
  //       errorBuilder: (context, error, stackTrace) {
  //         return Container(
  //           color: Colors.grey[200],
  //           child: const Center(
  //             child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _buildCelebrationMedia(CelebrationConfig config) {
    final isGif = config.mediaType == MediaType.gif;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: SizedBox(
          height: 120, // Reduced height (was ~200-220 with 16:9)
          width: double.infinity,
          child: isGif
              ? _buildGifWidget(config.mediaUrl)
              : _buildVideoWidget(config.mediaUrl),
        ),
      ),
    );
  }

  Widget _buildVideoWidget(String url) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: ExoVideoPlayer(url: url, autoPlay: true),
    );
  }

  Widget _buildGifWidget(String url) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: Image.network(
        url,
        fit: BoxFit.fill,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              color: _accent,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // APP BAR
  // ══════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar() {
    // Determine if we should show the message ticker
    final bool showMessageTicker = !_isLoadingWishes && _wishesList.isNotEmpty;

    // Calculate dynamic height: 64 for profile row + (8 spacing + 32 for ticker if visible)
    final double appBarHeight = 64 + (showMessageTicker ? 8 + 32 : 0);

    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: Container(
        decoration: BoxDecoration(
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
            child: Column(
              children: [
                // First row - Profile and actions (always visible)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!_requireNetwork()) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
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
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
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
                    const SizedBox(width: 6),
                    const ActiveTimeWidget(),
                    const SizedBox(width: 6),
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
                                builder: (context) => NotificationScreen(
                                  userId: userId.toString(),
                                ),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 38,
                            minHeight: 38,
                          ),
                        ),
                        // Positioned(
                        //   right: 4,
                        //   top: 4,
                        //   child: Container(
                        //     width: 16,
                        //     height: 16,
                        //     decoration: const BoxDecoration(
                        //       color: Colors.red,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: const Center(
                        //       child: Text(
                        //         '3',
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 9,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     if (!_requireNetwork()) return;
                    //     _showLanguageSelector(context);
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.all(7),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black.withOpacity(0.1),
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //     child: const Icon(
                    //       Icons.language_rounded,
                    //       color: Colors.black87,
                    //       size: 22,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),

                // Second row - Birthday and Anniversary messages ticker (only if there are wishes)
                if (showMessageTicker) ...[
                  const SizedBox(height: 8),
                  _buildMessageTicker(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTicker() {
    if (_isLoadingWishes) {
      return Container(
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Loading wishes...',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (_wishesList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration,
              color: Color.fromARGB(255, 255, 49, 8),
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 30,
              child: Marquee(
                text: _wishesList.join("  •  "),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                blankSpace: 40.0,
                velocity: 30.0,
                pauseAfterRound: const Duration(seconds: 2),
                accelerationDuration: const Duration(seconds: 1),
                decelerationDuration: const Duration(milliseconds: 600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SEARCH BAR
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildSearchBar() {
    final celebrationProvider = Provider.of<CelebrationProvider>(
      context,
      listen: false,
    );

    return GestureDetector(
      onTap: () {
        if (!_requireNetwork()) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        // color: celebrationProvider.sectionBgColor,
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
            // if (bannerProvider.bannerCount > 1)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 8),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: List.generate(bannerProvider.bannerCount, (i) {
            //         return AnimatedContainer(
            //           duration: const Duration(milliseconds: 250),
            //           margin: const EdgeInsets.symmetric(horizontal: 3),
            //           width: _currentBannerPage == i ? 18 : 6,
            //           height: 6,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(3),
            //             color: _currentBannerPage == i
            //                 ? _accent
            //                 : Colors.grey.shade300,
            //           ),
            //         );
            //       }),
            //     ),
            //   ),
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
    final celebrationProvider = Provider.of<CelebrationProvider>(
      context,
      listen: false,
    );

    final hasGradient =
        celebrationProvider.gradientColors != null &&
        celebrationProvider.gradientColors!.length >= 2;

    return Container(
      // decoration: BoxDecoration(
      //   gradient: hasGradient
      //       ? LinearGradient(
      //           colors: celebrationProvider.gradientColors!,
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //         )
      //       : null,
      //   color: hasGradient ? null : celebrationProvider.sectionBgColor,
      // ),
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
                color: celebrationProvider.primaryTextColor,
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
      // color: _sectionBg,
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
            builder: (_) =>
                PosterEditorScreen(posterAsset: bgImageUrl, itemid: poster.id),
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
                builder: (_) => PosterEditorScreen(
                  posterAsset: bgImageUrl,
                  itemid: poster.id,
                ),
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
          // color: Colors.white,
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
        print("Reel tapped at index: $index"); // Debug log
        if (!_requireNetwork()) return;
        _goToReelsScreen(index);
      },
      behavior: HitTestBehavior.opaque, // Add this to ensure taps are detected
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
              // Wrap AutoPlayReelVideo with IgnorePointer to let taps pass through
              IgnorePointer(
                ignoring: true,
                child: AutoPlayReelVideo(thumbnailUrl: reel.thumbnailUrl ?? ''),
              ),
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
                      if (reel.title != null && reel.title!.isNotEmpty)
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

  void _goToReelsScreen(int selectedIndex) {
    print("Going to reels screen with index: $selectedIndex");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HotScreen(initialIndex: selectedIndex)),
    );
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
              // color: _sectionBg,
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
                                // if (myPlanProvider.isPurchase)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailsScreen(category: category),
                                  ),
                                );
                                // else
                                //   _showPremiumDialog();
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
            // if (myPlanProvider.isPurchase) {
            final bgImageUrl = poster.images[0] ?? '';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PosterEditorScreen(
                  posterAsset: bgImageUrl,
                  itemid: poster.id,
                ),
              ),
            );
            // } else {
            //   _showPremiumDialog();
            // }
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
  //                         errorMessage == null)
  //                       loadReferralCode();
  //                   });

  //                   return FlippableReferModal(
  //                     isLoading: isLoading,
  //                     errorMessage: errorMessage,
  //                     userReferralCode: userReferralCode,
  //                     onLoadReferralCode: loadReferralCode,
  //                     onShare: shareCode,
  //                     onClose: () => Navigator.pop(context),
  //                     onCopy: () {
  //                       if (userReferralCode != null) {
  //                         Clipboard.setData(
  //                           ClipboardData(text: userReferralCode!),
  //                         );
  //                         ScaffoldMessenger.of(context).showSnackBar(
  //                           const SnackBar(
  //                             content: Text('Referral code copied!'),
  //                             behavior: SnackBarBehavior.floating,
  //                             backgroundColor: Color(0xFF10B981),
  //                           ),
  //                         );
  //                       } else {
  //                         loadReferralCode();
  //                       }
  //                     },
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
                      onClose: () async {
                        // Save the current time when modal is closed
                        await _saveReferModalShownTime();
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
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

  Widget _buildWishesBanner() {
    if (_isLoadingWishes) {
      return _buildLoadingBanner('Loading wishes...');
    }

    if (!_showWishesSection || _wishesList.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildMarqueeBanner(
      gradient: const LinearGradient(
        colors: [Color(0xFFE0F7FA), Color(0xFFF3E5F5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadowColor: Color(0xFF673AB7),
      borderColor: Color(0xFF80DEEA),
      iconBg: Color(0xFF00838F),
      iconData: Icons.celebration,
      closeIconColor: Color(0xFF00838F),
      textColor: Color(0xFF004D40),
      text: _wishesList.join("  •  "),
      onClose: () {
        setState(() => _showWishesSection = false);
        _saveWishesPreference(false);
      },
    );
  }

  Widget _buildCelebrationsBanner() {
    if (_isLoadingCelebrations) {
      return _buildLoadingBanner('Loading celebrations...');
    }

    if (!_showCustomerCelebrationsSection ||
        _customerCelebrationsList.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildMarqueeBanner(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadowColor: Color(0xFFFF6F00),
      borderColor: Color(0xFFFFB74D),
      iconBg: Color(0xFFE65100),
      iconData: Icons.cake,
      closeIconColor: Color(0xFFE65100),
      textColor: Color(0xFFBF360C),
      text: _customerCelebrationsList.join("  •  "),
      onClose: () {
        setState(() => _showCustomerCelebrationsSection = false);
        _saveCelebrationsPreference(false);
      },
    );
  }

  Widget _buildLoadingBanner(String text) {
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
  }

  Widget _buildMarqueeBanner({
    required LinearGradient gradient,
    required Color shadowColor,
    required Color borderColor,
    required Color iconBg,
    required IconData iconData,
    required Color closeIconColor,
    required Color textColor,
    required String text,
    required VoidCallback onClose,
  }) {
    return Container(
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
  }
}
