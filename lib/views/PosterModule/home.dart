import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/helper/sub_modal_helper.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/models/poster_model.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/PosterProvider/poster_provider.dart';
import 'package:posternova/providers/auth/login_provider.dart';
import 'package:posternova/providers/festivals/date_time_provider.dart';
import 'package:posternova/providers/plans/get_all_plan_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/views/PosterModule/canvas_poster_listing_screen.dart';
import 'package:posternova/views/PosterModule/poster_listing_screen.dart';
import 'package:posternova/views/PosterModule/poster_making_screen.dart';
import 'package:posternova/views/stories/story_widget_screen.dart';
import 'package:posternova/views/subscription/payment_success_screen.dart';
import 'package:posternova/views/subscription/plan_detail_screen.dart';
import 'package:posternova/widgets/date_selctor_widget.dart';
import 'package:posternova/widgets/faancy_app_bar.dart';
import 'package:posternova/widgets/home_courosel_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<CategoryModel> items = [];
  final String imageUrl =
      "https://fntarizona.com/wp-content/uploads/2017/05/shutterstock_624472886.jpg";

  bool serchValue = false;

  int _currentIndex = 0;
  String? posterId;
  String? currentUserId;
  String? username;
  String? userImage;
  String? userId;
  String? _savedImageBase64;

  Map<String, dynamic> birthdayData = {};
  Map<String, dynamic> anniversaryData = {};

  Locale _locale = const Locale('en');

  bool _isLoading = false;

  static bool _hasShownReferAndEarnModal = false;

  late final MyPlanProvider myplanprovider;

  List<dynamic> festivaldata = [];
  List<dynamic> posterdata = [];
  List<dynamic> canvaposter = [];

  final TextEditingController _searchController = TextEditingController();
  bool _isListening = false;
  String _searchText = '';

  // late stt.SpeechToText _speech;
  List<dynamic> _filteredCategories = [];
  List<dynamic> _filteredNewposters = [];

  // late final CategoryProviderr categoryprovider;
  late final CanvaPosterProvider canvaPosterProvider;
  Map<String, List<Map<String, dynamic>>> _categorizedPosters = {};

  // Animation controllers
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchnewposters();
    _loadUserData();
    _loadUserId();
    _initializeUser();
    Future.microtask(() {
      final myPlanProvider = Provider.of<MyPlanProvider>(
        context,
        listen: false,
      );
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      storyProvider.fetchStories();

      if (!_hasShownReferAndEarnModal) {
        showReferAndEarnModal(context);
        _hasShownReferAndEarnModal = true;
      }

      final posterProvider = Provider.of<PosterProvider>(
        context,
        listen: false,
      );


          final authprovider = Provider.of<AuthProvider>(
        context,
        listen: false,
      );

    
      myPlanProvider
          .fetchMyPlan(userId.toString())
          .then((_) {
            print(
              'Fetch MyPlan completed - isPurchase: ${myPlanProvider.isPurchase}',
            );
            print(
              'Subscribed Plan: ${myPlanProvider.subscribedPlan?.name ?? 'None'}',
            );

            if (myPlanProvider.isPurchase) {
              print('User has an active subscription');
            } else {
              print('User does not have an active subscription');
              showSubscriptionModal(context);
            }
          })
          .catchError((error) {
            print('Error fetching MyPlan: $error');
            showSubscriptionModal(context);
          });

      posterProvider.fetchPosters().then((_) {
        print(
          'Fetch posters completed - poster count: ${posterProvider.posters.length}',
        );
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFestivalPosters(context.read<DateTimeProvider>().selectedDate);
      _startAnimations();
    });
  }

  Future<void> _loadUserId() async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData != null) {
        setState(() {
          username = userData.user.name;
          currentUserId = userData.user.id;
        });

        final response = await http.get(
          Uri.parse(
            'http://194.164.148.244:4061/api/users/wishes/$currentUserId',
          ),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          setState(() {
            birthdayData = Map<String, dynamic>.from(data);
            anniversaryData = Map<String, dynamic>.from(data);
          });
        } else {
          print(
            'Failed to load birthday data. Status code: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      print('Error loading user ID or birthday data: $e');
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _contentAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutQuart,
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerAnimationController,
            curve: Curves.easeOutBack,
          ),
        );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  void _startAnimations() {
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _contentAnimationController.forward();
    });
  }

  Future<void> _loadUserData() async {
    final userData = await AuthPreferences.getUserData();
    print(userData);
    if (userData != null && userData.user != null) {
      setState(() {
        userId = userData.user.id;
        username = userData.user.name;  // Add this
      userImage = userData.user.profileImage;  
      });
      print('User ID: $userId');
    } else {
      print("No User ID");
    }
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    _searchController.dispose();
    // _speech.stop();
    super.dispose();
  }

  Future<void> _fetchnewposters() async {
    try {
      final canvaPosterProvider = Provider.of<CanvaPosterProvider>(
        context,
        listen: false,
      );
      await canvaPosterProvider.fetchPosters();

      setState(() {
        canvaposter = canvaPosterProvider.posters;
      });

      print('Canva posters fetched: ${canvaposter.length}');
    } catch (e) {
      print('Error fetching canva posters: $e');
    }
  }

  Future<void> _fetchFestivalPosters(DateTime date) async {
    setState(() {
      _isLoading = true;
      festivaldata = [];
    });

    try {
      final response = await http.post(
        Uri.parse('http://194.164.148.244:4061/api/poster/festival'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'festivalDate': _formatDate(date)}),
      );

      if (response.statusCode == 200) {
        festivaldata = jsonDecode(response.body);
        setState(() {
          festivaldata = festivaldata;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final posterProvider = Provider.of<PosterProvider>(context);
    final posters = posterProvider.posters;

    return Scaffold(
      appBar:  FancyAppBar(username: username,profileImageUrl: userImage,),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _fetchFestivalPosters(
              context.read<DateTimeProvider>().selectedDate,
            );
            await _fetchnewposters();
          },
          color: const Color(0xFF6366F1),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _contentFadeAnimation,
                  child: Column(
                    children: [
                      _buildFeaturedCarousel(),
                      const SizedBox(height: 32),
                      _buildUpcomingFestivalsSection(),
                      const SizedBox(height: 32),
                      _buildFestivalPostersSection(),
                      const SizedBox(height: 32),
                      _buildPremiumTemplatesSection(),
                      const SizedBox(height: 100),
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

  Widget _buildWishesSection() {
    if (birthdayData['wishes'] == null || birthdayData['wishes'].isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE0F7FA),
            Color.fromARGB(255, 236, 178, 242),
          ], // light cyan gradient
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
                text: birthdayData['wishes'].join("  •  "),
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
        ],
      ),
    );
  }

  // Widget _buildWishesSection() {
  //   if (birthdayData['wishes'] == null || birthdayData['wishes'].isEmpty) {
  //     return const SizedBox();
  //   }

  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFFFEF7CD), Color(0xFFFDE68A)],
  //       ),
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFFFDE68A).withOpacity(0.3),
  //           blurRadius: 8,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: const Color(0xFFF59E0B),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: const Icon(Icons.celebration, color: Colors.white, size: 20),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: SizedBox(
  //             height: 24,
  //             child: Marquee(
  //               text: birthdayData['wishes'].join("  •  "),
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //                 color: Color(0xFFA16207),
  //               ),
  //               scrollAxis: Axis.horizontal,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               blankSpace: 50.0,
  //               velocity: 40.0,
  //               pauseAfterRound: const Duration(seconds: 2),
  //               startPadding: 10.0,
  //               accelerationDuration: const Duration(seconds: 1),
  //               accelerationCurve: Curves.linear,
  //               decelerationDuration: const Duration(milliseconds: 500),
  //               decelerationCurve: Curves.easeOut,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFeaturedCarousel() {
    return Column(
      children: [
        SizedBox(height: 20),

        _buildWishesSection(),
        // _buildSectionHeader(
        //   title: 'Featured Templates',
        //   subtitle: 'Trending designs for you',
        // ),
        const SizedBox(height: 16),
        const HomeCarousel(),
      ],
    );
  }

  Widget _buildHeaderActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildUpcomingFestivalsSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          StoriesWidget(),

          _buildSectionHeader(
            title: 'Seasonal Celebrations',
            subtitle: 'Never miss a celebration',
          ),
          const SizedBox(height: 16),
          Consumer<DateTimeProvider>(
            builder: (context, dateTimeProvider, _) {
              return DateSelectorRow(
                selectedDate: dateTimeProvider.selectedDate,
                onDateSelected: (date) {
                  dateTimeProvider.setStartDate(date);
                  _fetchFestivalPosters(date);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFestivalPostersSection() {
    return Column(
      children: [
        _buildSectionHeader(
          title: 'Celebration Templates',
          subtitle: 'Perfect for every occasion',
          showViewAll: true,
          onViewAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PosterListingScreen(
                  title: 'Celebration Templates',
                  type: 'festival',
                  festivalDate: context.read<DateTimeProvider>().selectedDate,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildFestivalPostersGrid(),
      ],
    );
  }

  Widget _buildFestivalPostersGrid() {
    if (_isLoading) {
      return Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: const Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
      );
    }

    // if (festivaldata.isEmpty) {
    //   return Container(
    //     height: 200,
    //     margin: const EdgeInsets.symmetric(horizontal: 20),
    //     padding: const EdgeInsets.all(32),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(16),
    //       border: Border.all(color: const Color(0xFFE5E7EB)),
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         // Container(
    //         //   padding: const EdgeInsets.all(16),
    //         //   decoration: BoxDecoration(
    //         //     color: const Color(0xFF6366F1).withOpacity(0.1),
    //         //     shape: BoxShape.circle,
    //         //   ),
    //         //   child: const Icon(
    //         //     Icons.event_busy,
    //         //     size: 32,
    //         //     color: Color(0xFF6366F1),
    //         //   ),
    //         // ),
    //         // const SizedBox(height: 16),
    //         const Text(
    //           'No festivals found',
    //           style: TextStyle(
    //             fontSize: 16,
    //             fontWeight: FontWeight.w600,
    //             color: Color(0xFF374151),
    //           ),
    //         ),
    //         const SizedBox(height: 4),
    //         Text(
    //           'Try selecting a different date',
    //           style: TextStyle(
    //             fontSize: 14,
    //             color: const Color(0xFF6B7280),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    if (festivaldata.isEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: Card(
                  elevation: 1,
                  shadowColor: Colors.black.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey.shade50, Colors.white],
                      ),
                    ),
                    child: Row(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          builder: (context, iconValue, child) {
                            return Transform.rotate(
                              angle: iconValue * 0.1,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(
                                    context,
                                  ).primaryColor.withOpacity(0.1),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Icon(
                                  Icons.calendar_view_month_outlined,
                                  size: 24,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No Celebration Found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try to select  different date ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
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
          },
        ),
      );
    }

    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: festivaldata.length,
        itemBuilder: (context, index) {
          final poster = festivaldata[index];
          return _buildFestivalPosterCard(poster, index);
        },
      ),
    );
  }

  Widget _buildFestivalPosterCard(dynamic poster, int index) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SamplePosterScreen(posterId: poster['_id'] ?? poster['id']),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      color: const Color(0xFFF3F4F6),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        poster['images'][0],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFFF3F4F6),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF3F4F6),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: Color(0xFF9CA3AF),
                                size: 32,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poster['categoryName'] ?? 'Festival',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // if (!myPlanProvider.isPurchase) ...[
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 6,
                          //     vertical: 2,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: const Color(0xFF6366F1),
                          //     borderRadius: BorderRadius.circular(4),
                          //   ),
                          //   child: const Text(
                          //     'PRO',
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 10,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          // const Spacer(),
                          // ],
                          // const Icon(
                          //   Icons.trending_up,
                          //   size: 14,
                          //   color: Color(0xFF10B981),
                          // ),
                        ],
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

  Widget _buildPremiumTemplatesSection() {
    return Column(
      children: [
        // _buildSectionHeader(
        //   title: 'Premium Templates',
        //   subtitle: 'Professional designs',
        //   showViewAll: false,
        //   onViewAll: () {
        //     // Navigate to all premium templates
        //   },
        // ),
        // const SizedBox(height: 16),
        Consumer<CanvaPosterProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Container(
                height: 220,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                ),
              );
            }

            if (provider.error != null) {
              return Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 40,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load templates',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => provider.fetchPosters(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.posters.isEmpty) {
              return Container(
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image_not_supported_outlined,
                      size: 40,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No templates available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Group posters by category for better organization
            Map<String, List<CanvasPosterModel>> categorizedPosters = {};
            for (var poster in provider.posters) {
              String category = poster.categoryName.isEmpty
                  ? 'Other'
                  : poster.categoryName;
              if (!categorizedPosters.containsKey(category)) {
                categorizedPosters[category] = [];
              }
              categorizedPosters[category]!.add(poster);
            }

            return Column(
              children: categorizedPosters.entries.take(3).map((entry) {
                return _buildCategorySection(entry.key, entry.value);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // Widget _buildCategorySection(
  //   String categoryName,
  //   List<CanvasPosterModel> posters,
  // ) {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               categoryName,
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color(0xFF111827),
  //               ),
  //             ),
  //             TextButton.icon(
  //               onPressed: () {
  //                 // Navigator.push(
  //                 //   context,
  //                 //   MaterialPageRoute(
  //                 //     builder: (context) => DetailsScreen(category: categoryName),
  //                 //   ),
  //                 // );
  //               },
  //               // icon: const Icon(
  //               //   Icons.arrow_forward_ios,
  //               //   size: 16,
  //               //   color: Color(0xFF6366F1),
  //               // ),
  //               label: const Text(
  //                 '',
  //                 style: TextStyle(
  //                   color: Color(0xFF6366F1),
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 12),
  //       Container(
  //         height: 190,
  //         child: ListView.builder(
  //           scrollDirection: Axis.horizontal,
  //           padding: const EdgeInsets.symmetric(horizontal: 20),
  //           itemCount: posters.length,
  //           itemBuilder: (context, index) {
  //             return _buildPremiumPosterCard(posters[index], index);
  //           },
  //         ),
  //       ),
  //       const SizedBox(height: 24),
  //     ],
  //   );
  // }

  Widget _buildCategorySection(
    String categoryName,
    List<CanvasPosterModel> posters,
  ) {
    return Consumer<MyPlanProvider>(
      builder: (context, myPlanprovider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      if (myPlanprovider.isPurchase == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CanvasPosterListingScreen(
                              categoryName: categoryName,
                            ),
                          ),
                        );
                      } else {
                        _showPremiumDialog();
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF6366F1),
                    ),
                    label: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: posters.length,
                itemBuilder: (context, index) {
                  return _buildPremiumPosterCard(posters[index], index);
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildPremiumPosterCard(CanvasPosterModel poster, int index) {
    return Consumer<MyPlanProvider>(
      builder: (context, myPlanProvider, child) {
        return Container(
          width: 170,
          margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (myPlanProvider.isPurchase == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SamplePosterScreen(posterId: poster.id),
                    ),
                  );
                } else {
                  _showPremiumDialog();
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          color: const Color(0xFFF3F4F6),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16), // 👈 add these
                                bottomRight: Radius.circular(
                                  16,
                                ), // 👈 add these
                              ),
                              child: Image.network(
                                poster.images.isNotEmpty
                                    ? poster.images[0]
                                    : '',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: const Color(0xFFF3F4F6),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Color(0xFF6366F1),
                                          ),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFF3F4F6),
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Color(0xFF9CA3AF),
                                        size: 32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Show PRO badge if not purchased
                            // Positioned(
                            //   top: 8,
                            //   right: 8,
                            //   child: Container(
                            //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            //     decoration: BoxDecoration(
                            //       color: const Color(0xFF6366F1),
                            //       borderRadius: BorderRadius.circular(4),
                            //     ),
                            //     child: const Text(
                            //       'PRO',
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 10,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    bool showViewAll = false,
    VoidCallback? onViewAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          if (showViewAll && onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'View All',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // void showSubscriptionModal(BuildContext context) async {
  //     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

  //     if (myPlanProvider.isPurchase == true) {
  //       return;
  //     }

  //     final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
  //     final shouldShowAgain = await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

  //     if (hasShownRecently && !shouldShowAgain) {
  //       print('Subscription modal shown recently, skipping');
  //       return;
  //     }

  //     final planProvider = Provider.of<GetAllPlanProvider>(context, listen: false);
  //     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
  //       planProvider.fetchAllPlans();
  //     }

  //     showGeneralDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       barrierLabel: 'Subscription Modal',
  //       barrierColor: Colors.black.withOpacity(0.6),
  //       transitionDuration: const Duration(milliseconds: 600),
  //       pageBuilder: (context, animation, secondaryAnimation) {
  //         return const SizedBox.shrink();
  //       },
  //       transitionBuilder: (context, animation, secondaryAnimation, child) {
  //         final curvedAnimation = CurvedAnimation(
  //           parent: animation,
  //           curve: Curves.easeOutBack,
  //         );

  //         return BackdropFilter(
  //           filter: ImageFilter.blur(
  //             sigmaX: 4 * animation.value,
  //             sigmaY: 4 * animation.value,
  //           ),
  //           child: SlideTransition(
  //             position: Tween<Offset>(
  //               begin: const Offset(0, 0.2),
  //               end: Offset.zero,
  //             ).animate(curvedAnimation),
  //             child: ScaleTransition(
  //               scale: Tween<double>(
  //                 begin: 0.8,
  //                 end: 1.0,
  //               ).animate(curvedAnimation),
  //               child: FadeTransition(
  //                 opacity: Tween<double>(
  //                   begin: 0.0,
  //                   end: 1.0,
  //                 ).animate(curvedAnimation),
  //                 child: Center(
  //                   child: Container(
  //                     margin: const EdgeInsets.symmetric(horizontal: 16),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(20),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.2),
  //                           blurRadius: 20,
  //                           offset: const Offset(0, 10),
  //                         ),
  //                       ],
  //                     ),
  //                     constraints: BoxConstraints(
  //                       maxHeight: MediaQuery.of(context).size.height * 0.85,
  //                       maxWidth: 500,
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(20),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           // Modern header with updated gradient
  //                           Container(
  //                             decoration: const BoxDecoration(
  //                               gradient: LinearGradient(
  //                                 begin: Alignment.topLeft,
  //                                 end: Alignment.bottomRight,
  //                                 colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  //                               ),
  //                             ),
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
  //                               child: Row(
  //                                 children: [
  //                                   Container(
  //                                     padding: const EdgeInsets.all(8),
  //                                     decoration: BoxDecoration(
  //                                       color: Colors.white.withOpacity(0.2),
  //                                       borderRadius: BorderRadius.circular(8),
  //                                     ),
  //                                     child: const Icon(
  //                                       Icons.workspace_premium,
  //                                       color: Colors.white,
  //                                       size: 24,
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 12),
  //                                   const Expanded(
  //                                     child: Text(
  //                                       'Choose Your Plan',
  //                                       style: TextStyle(
  //                                         fontSize: 20,
  //                                         fontWeight: FontWeight.bold,
  //                                         color: Colors.white,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   Material(
  //                                     color: Colors.transparent,
  //                                     child: InkWell(
  //                                       borderRadius: BorderRadius.circular(20),
  //                                       onTap: () => Navigator.pop(context),
  //                                       child: Container(
  //                                         padding: const EdgeInsets.all(6),
  //                                         decoration: BoxDecoration(
  //                                           color: Colors.white.withOpacity(0.2),
  //                                           shape: BoxShape.circle,
  //                                         ),
  //                                         child: const Icon(
  //                                           Icons.close,
  //                                           color: Colors.white,
  //                                           size: 18,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           Flexible(
  //                             child: Consumer<GetAllPlanProvider>(
  //                               builder: (context, provider, child) {
  //                                 if (provider.isLoading) {
  //                                   return const Center(
  //                                     child: Column(
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         SizedBox(
  //                                           width: 40,
  //                                           height: 40,
  //                                           child: CircularProgressIndicator(
  //                                             color: Color(0xFF6366F1),
  //                                             strokeWidth: 3,
  //                                           ),
  //                                         ),
  //                                         SizedBox(height: 16),
  //                                         Text(
  //                                           'Loading plans...',
  //                                           style: TextStyle(
  //                                             color: Color(0xFF6B7280),
  //                                             fontWeight: FontWeight.w500,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   );
  //                                 }

  //                                 if (provider.error != null) {
  //                                   return Center(
  //                                     child: Padding(
  //                                       padding: const EdgeInsets.all(20.0),
  //                                       child: Column(
  //                                         mainAxisAlignment: MainAxisAlignment.center,
  //                                         children: [
  //                                           const Icon(
  //                                             Icons.error_outline,
  //                                             color: Color(0xFFEF4444),
  //                                             size: 60,
  //                                           ),
  //                                           const SizedBox(height: 16),
  //                                           const Text(
  //                                             'Failed to load plans',
  //                                             style: TextStyle(
  //                                               fontSize: 18,
  //                                               fontWeight: FontWeight.bold,
  //                                               color: Color(0xFFEF4444),
  //                                             ),
  //                                           ),
  //                                           const SizedBox(height: 8),
  //                                           const Text(
  //                                             'Please try again later',
  //                                             style: TextStyle(color: Color(0xFF6B7280)),
  //                                           ),
  //                                           const SizedBox(height: 16),
  //                                           ElevatedButton.icon(
  //                                             onPressed: () => provider.fetchAllPlans(),
  //                                             style: ElevatedButton.styleFrom(
  //                                               backgroundColor: const Color(0xFF6366F1),
  //                                               foregroundColor: Colors.white,
  //                                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  //                                               shape: RoundedRectangleBorder(
  //                                                 borderRadius: BorderRadius.circular(12),
  //                                               ),
  //                                             ),
  //                                             icon: const Icon(Icons.refresh),
  //                                             label: const Text('Try Again'),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   );
  //                                 }

  //                                 if (provider.plans.isNotEmpty) {
  //                                   return AnimatedPlanList(
  //                                     plans: provider.plans,
  //                                     onPlanSelected: (plan) {
  //                                       Navigator.of(context).pop();
  //                                       Navigator.push(
  //                                         context,
  //                                         PageRouteBuilder(
  //                                           pageBuilder: (context, animation, secondaryAnimation) =>
  //                                               PlanDetailsAndPaymentScreen(plan: plan),
  //                                           transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //                                             const begin = Offset(1.0, 0.0);
  //                                             const end = Offset.zero;
  //                                             const curve = Curves.easeOutCubic;

  //                                             var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //                                             var offsetAnimation = animation.drive(tween);

  //                                             return SlideTransition(
  //                                               position: offsetAnimation,
  //                                               child: FadeTransition(
  //                                                 opacity: animation,
  //                                                 child: child,
  //                                               ),
  //                                             );
  //                                           },
  //                                           transitionDuration: const Duration(milliseconds: 500),
  //                                         ),
  //                                       );
  //                                     },
  //                                   );
  //                                 }

  //                                 return const Center(
  //                                   child: Column(
  //                                     mainAxisAlignment: MainAxisAlignment.center,
  //                                     children: [
  //                                       Icon(
  //                                         Icons.subscriptions,
  //                                         size: 60,
  //                                         color: Color(0xFF9CA3AF),
  //                                       ),
  //                                       SizedBox(height: 16),
  //                                       Text(
  //                                         'No subscription plans available',
  //                                         style: TextStyle(
  //                                           fontSize: 16,
  //                                           color: Color(0xFF6B7280),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     );
  //   }

  void showSubscriptionModal(BuildContext context) async {
    final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

    if (myPlanProvider.isPurchase == true) {
      return;
    }

    final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
    final shouldShowAgain =
        await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

    if (hasShownRecently && !shouldShowAgain) {
      print('Subscription modal shown recently, skipping');
      return;
    }

    final planProvider = Provider.of<GetAllPlanProvider>(
      context,
      listen: false,
    );
    if (planProvider.plans.isEmpty && !planProvider.isLoading) {
      planProvider.fetchAllPlans();
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  children: [
                    // Close Button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Premium Icon
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFA500).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    const Text(
                      'Unlock Premium',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 6),

                    // Subtitle
                    Text(
                      'Get unlimited access to all features',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Features List
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 20),
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFF8FAFC),
              //     borderRadius: BorderRadius.circular(14),
              //     border: Border.all(color: Colors.grey.shade200),
              //   ),
              //   child: Column(
              //     children: [
              //       // _buildCompactFeature('Unlimited Templates'),
              //       // const SizedBox(height: 12),
              //       // _buildCompactFeature('No Watermarks'),
              //       // const SizedBox(height: 12),
              //       // _buildCompactFeature('Priority Support'),
              //       // const SizedBox(height: 12),
              //       // _buildCompactFeature('Regular Updates'),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 20),

              // Plans Section
              Container(
                constraints: const BoxConstraints(maxHeight: 280),
                child: Consumer<GetAllPlanProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF6366F1),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Loading plans...',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (provider.error != null) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red.shade400,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Unable to Load Plans',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Please try again',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => provider.fetchAllPlans(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (provider.plans.isNotEmpty) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: AnimatedPlanList(
                          plans: provider.plans,
                          onPlanSelected: (plan) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlanDetailsAndPaymentScreen(plan: plan),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Plans Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Please check back later',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _showPremiumDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       title: Row(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(8),
  //             decoration: BoxDecoration(
  //               color: const Color(0xFF6366F1).withOpacity(0.1),
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(
  //               Icons.workspace_premium,
  //               color: Color(0xFF6366F1),
  //               size: 24,
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           const Text(
  //             'Premium Feature',
  //             style: TextStyle(
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: const Text(
  //         'This template requires a premium subscription. Upgrade now to unlock all premium features and templates!',
  //         style: TextStyle(fontSize: 14),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text(
  //             'Cancel',
  //             style: TextStyle(color: Color(0xFF6B7280)),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             showSubscriptionModal(context);
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: const Color(0xFF6366F1),
  //             foregroundColor: Colors.white,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //           child: const Text('Upgrade Now'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
              // Premium Icon with gradient
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

              // Title
              const Text(
                'Unlock Premium',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),

              // Description
              const Text(
                'Get access to exclusive templates and premium features to enhance your experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Feature List
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(
              //       color: const Color(0xFFE5E7EB),
              //       width: 1,
              //     ),
              //   ),
              //   child: Column(
              //     children: [
              //       _buildFeatureRow(Icons.check_circle, 'All premium templates'),
              //       const SizedBox(height: 12),
              //       _buildFeatureRow(Icons.check_circle, 'Priority support'),
              //       const SizedBox(height: 12),
              //       _buildFeatureRow(Icons.check_circle, 'Ad-free experience'),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 24),

              // Action Buttons
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
                      onPressed: () {
                        Navigator.pop(context);
                        showSubscriptionModal(context);
                      },
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

  void showReferAndEarnModal(BuildContext context) {
    String? userId;
    String? userReferralCode;
    bool isLoading = true;
    String? errorMessage;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Refer and Earn',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
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
                  builder: (context, setState) {
                    Future<void> loadUserDataAndFetchReferralCode() async {
                      try {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });

                        final userData = await AuthPreferences.getUserData();
                        if (userData != null && userData.user != null) {
                          userId = userData.user.id;

                          if (userId != null) {
                            final response = await http.get(
                              Uri.parse(
                                'http://194.164.148.244:4061/api/users/refferalcode/$userId',
                              ),
                              headers: {'Content-Type': 'application/json'},
                            );

                            if (response.statusCode == 200) {
                              final data = json.decode(response.body);
                              String? fetchedCode =
                                  data['referralCode'] ??
                                  data['refferalCode'] ??
                                  data['code'] ??
                                  data['referral_code'] ??
                                  data['refferal_code'];

                              setState(() {
                                isLoading = false;
                                userReferralCode = fetchedCode;
                                errorMessage = fetchedCode == null
                                    ? 'No referral code found'
                                    : null;
                              });
                            } else {
                              setState(() {
                                userReferralCode = null;
                                errorMessage = 'Failed to load referral code';
                                isLoading = false;
                              });
                            }
                          } else {
                            setState(() {
                              userReferralCode = null;
                              errorMessage = 'User ID is null';
                              isLoading = false;
                            });
                          }
                        } else {
                          setState(() {
                            userReferralCode = null;
                            errorMessage = 'User data not found';
                            isLoading = false;
                          });
                        }
                      } catch (e) {
                        setState(() {
                          userReferralCode = null;
                          errorMessage = 'Network error: ${e.toString()}';
                          isLoading = false;
                        });
                      }
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (isLoading &&
                          userReferralCode == null &&
                          errorMessage == null) {
                        loadUserDataAndFetchReferralCode();
                      }
                    });

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                        maxWidth: 500,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header
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
                                      color: const Color(
                                        0xFF4F46E5,
                                      ).withOpacity(0.1),
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
                                    child: Text(
                                      'Refer & Earn',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close, size: 24),
                                    color: Colors.grey[600],
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            Flexible(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Info Card
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0F9FF),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFBAE6FD),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0EA5E9),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.info_outline,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Text(
                                              'Share your referral code with friends and earn rewards when they upgrade.',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF0C4A6E),
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Referral Code Section
                                    const Text(
                                      'Your Referral Code',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: isLoading
                                          ? Container(
                                              key: const ValueKey('loading'),
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.grey[200]!,
                                                ),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Color(
                                                            0xFF4F46E5,
                                                          ),
                                                        ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    'Loading...',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF6B7280),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : (errorMessage != null)
                                          ? Container(
                                              key: const ValueKey('error'),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFEF2F2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFECACA,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.error_outline,
                                                        color: Color(
                                                          0xFFEF4444,
                                                        ),
                                                        size: 20,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          errorMessage!,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 14,
                                                                color: Color(
                                                                  0xFF991B1B,
                                                                ),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: OutlinedButton.icon(
                                                      onPressed:
                                                          loadUserDataAndFetchReferralCode,
                                                      style: OutlinedButton.styleFrom(
                                                        foregroundColor:
                                                            const Color(
                                                              0xFFEF4444,
                                                            ),
                                                        side: const BorderSide(
                                                          color: Color(
                                                            0xFFEF4444,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 12,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      icon: const Icon(
                                                        Icons.refresh,
                                                        size: 18,
                                                      ),
                                                      label: const Text(
                                                        'Retry',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              key: const ValueKey('code'),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.grey[300]!,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          userReferralCode ??
                                                              '--',
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                letterSpacing:
                                                                    2,
                                                                color: Color(
                                                                  0xFF4F46E5,
                                                                ),
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        const Text(
                                                          'Tap to copy',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                              0xFF6B7280,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      if (userReferralCode !=
                                                              null &&
                                                          userReferralCode!
                                                              .isNotEmpty) {
                                                        Clipboard.setData(
                                                          ClipboardData(
                                                            text:
                                                                userReferralCode!,
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                              'Referral code copied to clipboard',
                                                            ),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            backgroundColor:
                                                                const Color(
                                                                  0xFF10B981,
                                                                ),
                                                            duration:
                                                                const Duration(
                                                                  seconds: 2,
                                                                ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.copy,
                                                      size: 20,
                                                    ),
                                                    color: const Color(
                                                      0xFF4F46E5,
                                                    ),
                                                    style: IconButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                            0xFF4F46E5,
                                                          ).withOpacity(0.1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),

                                    const SizedBox(height: 24),

                                    // How It Works
                                    const Text(
                                      'How It Works',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    _buildSteps(
                                      number: '1',
                                      title: 'Share Your Code',
                                      description:
                                          'Send your referral code to friends via any platform',
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSteps(
                                      number: '2',
                                      title: 'Friend Signs Up',
                                      description:
                                          'They enter your code during registration',
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSteps(
                                      number: '3',
                                      title: 'Earn Rewards',
                                      description:
                                          'Get ₹200 when they upgrade their account',
                                    ),

                                    const SizedBox(height: 24),

                                    // Action Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (userReferralCode != null &&
                                              userReferralCode!.isNotEmpty) {
                                            Clipboard.setData(
                                              ClipboardData(
                                                text: userReferralCode!,
                                              ),
                                            );
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Referral code copied! Share it with your friends.',
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Color(
                                                  0xFF10B981,
                                                ),
                                              ),
                                            );
                                          } else {
                                            loadUserDataAndFetchReferralCode();
                                          }
                                        },
                                        icon: const Icon(Icons.copy, size: 20),
                                        label: const Text(
                                          'Copy Referral Code',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF4F46E5,
                                          ),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
        );
      },
    );
  }

  Widget _buildSteps({
    required String number,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF10B981), size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactFeature(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF10B981),
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF10B981),
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep(String number, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // helper widget used in the updated UI (kept in-file intentionally)

  Widget _buildHowItWorksStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF6366F1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCategoryWisePosters() {
    return Consumer<CanvaPosterProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6366F1)),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Color(0xFFEF4444),
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(color: Color(0xFFEF4444)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchPosters(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.posters.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Color(0xFF9CA3AF),
                ),
                SizedBox(height: 8),
                Text(
                  'No posters available',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          );
        }

        Map<String, List<CanvasPosterModel>> categorizedPosters = {};
        for (var poster in provider.posters) {
          String category = poster.categoryName.isEmpty
              ? 'Other'
              : poster.categoryName;
          if (!categorizedPosters.containsKey(category)) {
            categorizedPosters[category] = [];
          }
          categorizedPosters[category]!.add(poster);
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categorizedPosters.entries.map((entry) {
              String categoryName = entry.key;
              List<CanvasPosterModel> categoryPosters = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          '${categoryPosters.length} items',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categoryPosters.length,
                      itemBuilder: (context, index) {
                        final poster = categoryPosters[index];
                        return buildPosterCard(context, poster);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildPosterCard(BuildContext context, CanvasPosterModel poster) {
    return Consumer<MyPlanProvider>(
      builder: (context, myPlanProvider, child) {
        return Container(
          width: 140,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (myPlanProvider.isPurchase == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SamplePosterScreen(posterId: poster.id),
                          ),
                        );
                      } else {
                        _showPremiumDialog();
                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         SamplePosterScreen(posterId: poster.id),
                      //   ),
                      // );
                    },
                    child: Image.network(
                      poster.images.isNotEmpty ? poster.images[0] : '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Color(0xFF9CA3AF),
                            size: 30,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        poster.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            poster.price == 0 ? 'Free' : '₹${poster.price}',
                            style: TextStyle(
                              fontSize: 11,
                              color: poster.price == 0
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF6366F1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!poster.inStock)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Out',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFFEF4444),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
