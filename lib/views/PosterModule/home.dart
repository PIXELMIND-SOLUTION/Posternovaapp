import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/helper/sub_modal_helper.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/models/invoice_model.dart';
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
import 'package:posternova/views/backgroundremover/background_remover.dart';
import 'package:posternova/views/category/category_screen.dart';
import 'package:posternova/views/invoices/add_invoice_data.dart';
import 'package:posternova/views/onlinepunchang/online_punchang_screen.dart';
import 'package:posternova/views/stories/story_widget_screen.dart';
import 'package:posternova/views/subscription/payment_success_screen.dart';
import 'package:posternova/views/subscription/plan_detail_screen.dart';
import 'package:posternova/views/textremovalmodule/image_editor_screen.dart';
import 'package:posternova/widgets/date_selctor_widget.dart';
import 'package:posternova/widgets/faancy_app_bar.dart';
import 'package:posternova/widgets/home_courosel_widget.dart';
import 'package:posternova/widgets/premium_widget.dart';
import 'package:posternova/widgets/voice_assistant_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:posternova/widgets/premium_widget.dart'; // Add this line

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


  Map<String, List<dynamic>> weeklyPosters = {};
List<String> weekDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  List<dynamic> customers = [];
  bool isLoadingCustomers = false;

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

  bool _hasSpokenGreeting = false;

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
      _fetchWeeklyPosters();
    _initializeAnimations();
    _fetchnewposters();
    _loadUserData();
    _loadUserId();
    _initializeUser();
    Future.microtask(() async {
      await _loadUserId(); // Ensure userId is loaded first
      fetchCustomers();

      // if (!_hasSpokenGreeting && username != null) {
      //   await Future.delayed(
      //     const Duration(milliseconds: 800),
      //   ); // Small delay for better UX
      //   await VoiceGreetingHelper.speakWelcome(username);
      //   _hasSpokenGreeting = true;
      // }
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

      final authprovider = Provider.of<AuthProvider>(context, listen: false);

      // myPlanProvider
      //     .fetchMyPlan(userId.toString())
      //     .then((_) {
      //       print(
      //         'Fetch MyPlan completed - isPurchase: ${myPlanProvider.isPurchase}',
      //       );
      //       print(
      //         'Subscribed Plan: ${myPlanProvider.subscribedPlan?.name ?? 'None'}',
      //       );

      //       if (myPlanProvider.isPurchase) {
      //         print('User has an active subscription');
      //       } else {
      //         print('User does not have an active subscription');
      //         showSubscriptionModal(context);
      //       }
      //     })
      //     .catchError((error) {
      //       print('Error fetching MyPlan: $error');
      //       showSubscriptionModal(context);
      //     });

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
              // Navigate to subscription page instead of showing modal
              if (mounted) {
                // Check if widget is still mounted
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionPlansPage(),
                  ),
                );
              }
            }
          })
          .catchError((error) {
            print('Error fetching MyPlan: $error');
            // Navigate to subscription page instead of showing modal
            if (mounted) {
              // Check if widget is still mounted
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionPlansPage(),
                ),
              );
            }
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



  Future<void> _fetchWeeklyPosters() async {
  try {
    final response = await http.get(
      Uri.parse('http://31.97.206.144:4061/api/poster/weeklyposters'),
    );
   
  print('response status code for weekly posters ${response.statusCode}');
    print('response bodyyyyyyyyyyyyyy for weekly posters ${response.body}');


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        weeklyPosters = data.map((key, value) => MapEntry(key, List<dynamic>.from(value)));
      });
    }
  } catch (e) {
    print('Error fetching weekly posters: $e');
  }
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
            'http://31.97.206.144:4061/api/users/wishes/$currentUserId',
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

  Future<void> fetchCustomers() async {
    // Wait for userId to be loaded first
    if (userId == null) {
      print('userId is null, waiting...');
      // Give it a moment for _loadUserId to complete
      await Future.delayed(Duration(milliseconds: 500));

      if (userId == null) {
        print('Cannot fetch customers: userId is still null');
        return;
      }
    }

    setState(() {
      isLoadingCustomers = true;
    });

    try {
      print('Fetching customers for userId: $userId');
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/users/allcustomers/$userId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          customers = data['customers'] ?? [];
          isLoadingCustomers = false;
        });
        print('✅ Customers fetched successfully: ${customers.length}');

        // Debug: Print customer data
        for (var customer in customers) {
          print(
            'Customer: ${customer['name']}, DOB: ${customer['dob']}, Anniversary: ${customer['anniversaryDate']}',
          );
        }
      } else {
        setState(() {
          isLoadingCustomers = false;
        });
        print('❌ Failed to load customers: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoadingCustomers = false;
      });
      print('❌ Error fetching customers: $e');
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


  List<String> _getOrderedDaysFromToday() {
  final today = DateFormat('EEEE').format(DateTime.now());
  final todayIndex = weekDays.indexOf(today);
  
  if (todayIndex == -1) return weekDays;
  
  return [
    ...weekDays.sublist(todayIndex),
    ...weekDays.sublist(0, todayIndex),
  ];
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

  // Future<void> _loadUserData() async {
  //   final userData = await AuthPreferences.getUserData();
  //   print(userData);
  //   if (userData != null && userData.user != null) {
  //     setState(() {
  //       userId = userData.user.id;
  //       username = userData.user.name; // Add this
  //       userImage = userData.user.profileImage;
  //     });
  //     fetchCustomers();
  //     print('User ID: $userId');
  //   } else {
  //     print("No User ID");
  //   }
  // }

  Future<void> _loadUserData() async {
    final userData = await AuthPreferences.getUserData();
    print(userData);
    if (userData != null && userData.user != null) {
      setState(() {
        userId = userData.user.id;
        username = userData.user.name;
        userImage = userData.user.profileImage;
      });

      // Speak welcome after username is loaded
      // if (!_hasSpokenGreeting && username != null) {
      //   Future.delayed(const Duration(milliseconds: 800), () {
      //     VoiceGreetingHelper.speakWelcome(username);
      //     _hasSpokenGreeting = true;
      //   });
      // }

      fetchCustomers();
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
    VoiceGreetingHelper.stop();
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
        Uri.parse('http://31.97.206.144:4061/api/poster/festival'),
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
      appBar: FancyAppBar(username: username, profileImageUrl: userImage),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _fetchFestivalPosters(
              context.read<DateTimeProvider>().selectedDate,
            );
            await _fetchnewposters();
             await _fetchWeeklyPosters(); 
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
                        _buildSectionHeader(
                      title: 'Weekly Templates',
                      subtitle: 'Fresh designs for every day',
                    ),
                    const SizedBox(height: 16),
                    _buildWeeklyPostersSection(),
                      // _buildPremiumTemplatesSection(),
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





//   Widget _buildWeeklyPostersSection() {
//   if (weeklyPosters.isEmpty) return const SizedBox();
  
//   final orderedDays = _getOrderedDaysFromToday();
//   final today = DateFormat('EEEE').format(DateTime.now());
  
//   return Column(
//     children: orderedDays.map((day) {
//       final posters = weeklyPosters[day] ?? [];
//       if (posters.isEmpty) return const SizedBox();
      
//       final isToday = day == today;
      
//       return Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     gradient: isToday
//                         ? const LinearGradient(
//                             colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                           )
//                         : null,
//                     color: isToday ? null : Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         isToday ? Icons.today : Icons.calendar_today_outlined,
//                         size: 18,
//                         color: isToday ? Colors.white : const Color(0xFF6B7280),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         isToday ? 'Today - $day' : day,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: isToday ? Colors.white : const Color(0xFF111827),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   '${posters.length} templates',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Color(0xFF6B7280),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 220,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               itemCount: posters.length,
//               itemBuilder: (context, index) {
//                 final poster = posters[index];
//                 return _buildWeeklyPosterCard(poster, index);
//               },
//             ),
//           ),
//           const SizedBox(height: 24),
//         ],
//       );
//     }).toList(),
//   );
// }


Widget _buildWeeklyPostersSection() {
  if (weeklyPosters.isEmpty) return const SizedBox();
  
  final orderedDays = _getOrderedDaysFromToday();
  final today = DateFormat('EEEE').format(DateTime.now());
  
  return Column(
    children: orderedDays.map((day) {
      final posters = weeklyPosters[day] ?? [];
      // Remove this condition - show all days even if empty
      // if (posters.isEmpty) return const SizedBox();
      
      final isToday = day == today;
      
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: isToday
                        ? const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          )
                        : null,
                    color: isToday ? null : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isToday ? Icons.today : Icons.calendar_today_outlined,
                        size: 18,
                        color: isToday ? Colors.white : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isToday ? 'Today - $day' : day,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.white : const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  posters.isEmpty ? 'No templates' : '${posters.length} templates',
                  style: TextStyle(
                    fontSize: 14,
                    color: posters.isEmpty ? Colors.grey.shade400 : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          // Show message if no posters, otherwise show the list
          if (posters.isEmpty)
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Text(
                  'No templates available for $day',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            )
          else
            Container(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: posters.length,
                itemBuilder: (context, index) {
                  final poster = posters[index];
                  return _buildWeeklyPosterCard(poster, index);
                },
              ),
            ),
          const SizedBox(height: 24),
        ],
      );
    }).toList(),
  );
}



Widget _buildWeeklyPosterCard(dynamic poster, int index) {

      return Consumer<MyPlanProvider>(
        builder: (context, myplanprovider, child) {
           return  Container(
        width: 160,
        margin: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {

              if(myplanprovider.isPurchase==true){
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SamplePosterScreen(
                    posterId: poster['_id'] ?? poster['id'],
                  ),
                ),
              );
              }else{
                _showPremiumDialog();
              }
        
              
              // if(myplanprovider.isPurchase==true){
                 
              // }else{
              //     _showPremiumDialog();
              // }
             
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
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        color: Color(0xFFF3F4F6),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          poster['images']?[0] ?? '',
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
                          poster['categoryName'] ?? poster['name'] ?? 'Poster',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
  Widget _buildCustomerCelebrationsSection() {
    List<String> celebrations = [];

    print('=== Customer Celebrations Debug ===');
    print('Total customers: ${customers.length}');
    print('Is loading: $isLoadingCustomers');

    if (customers.isNotEmpty) {
      final today = DateTime.now();
      print('Today: ${today.year}-${today.month}-${today.day}');

      for (var customer in customers) {
        print('\nChecking customer: ${customer['name']}');

        // Check for birthday
        if (customer['dob'] != null && customer['dob'].isNotEmpty) {
          try {
            final dob = DateTime.parse(customer['dob']);
            print('  DOB: ${dob.year}-${dob.month}-${dob.day}');
            print(
              '  Match: month=${dob.month == today.month}, day=${dob.day == today.day}',
            );

            if (dob.month == today.month && dob.day == today.day) {
              final age = today.year - dob.year;

              // Determine suffix (st, nd, rd, th)
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

              final celebration = age > 0
                  ? "🎂 Happy ${age}${suffix} Birthday ${customer['name']}!"
                  : "🎂 Happy Birthday ${customer['name']}!";

              celebrations.add(celebration);
              print('  ✅ Birthday celebration added: $celebration');
            }
          } catch (e) {
            print('  ❌ Error parsing DOB for ${customer['name']}: $e');
          }
        } else {
          print('  No DOB data');
        }

        // Check for anniversary
        if (customer['anniversaryDate'] != null &&
            customer['anniversaryDate'].isNotEmpty) {
          try {
            final anniversary = DateTime.parse(customer['anniversaryDate']);
            print(
              '  Anniversary: ${anniversary.year}-${anniversary.month}-${anniversary.day}',
            );
            print(
              '  Match: month=${anniversary.month == today.month}, day=${anniversary.day == today.day}',
            );

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

              final celebration = years > 0
                  ? "💐 Happy ${years}${suffix} Anniversary ${customer['name']}!"
                  : "💐 Happy Anniversary ${customer['name']}!";

              celebrations.add(celebration);
              print('  ✅ Anniversary celebration added: $celebration');
            }
          } catch (e) {
            print('  ❌ Error parsing anniversary for ${customer['name']}: $e');
          }
        } else {
          print('  No anniversary data');
        }
      }
    } else {
      print('No customers available');
    }

    print('\nTotal celebrations found: ${celebrations.length}');
    if (celebrations.isNotEmpty) {
      print('Celebrations: $celebrations');
    }
    print('=== End Debug ===\n');

    // If no celebrations to display, return empty widget
    if (celebrations.isEmpty) {
      return const SizedBox();
    }

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
        ],
      ),
    );
  }

 

  Widget _buildFeaturedCarousel() {
    return Column(
      children: [
        SizedBox(height: 20),

        _buildWishesSection(),
        _buildCustomerCelebrationsSection(),

        // _buildSectionHeader(
        //   title: 'Featured Templates',
        //   subtitle: 'Trending designs for you',
        // ),
        const SizedBox(height: 16),
        const HomeCarousel(),
      ],
    );
  }




  
// Add this method to your _HomeScreenState class

Widget _buildCategoriesSection() {
  final categories = [
    {
      'name': 'Edit Poster',
      'icon': Icons.text_fields_outlined,
      'color': Color(0xFF8B5CF6),
      'screen': ImageEditorScreen(),
    },
    {
      'name': 'Categories',
      'icon': Icons.category_outlined,
      'color': Color(0xFF10B981),
      'screen': CategoryScreen(),
    },
    {
      'name': 'Invoices',
      'icon': Icons.receipt_long_outlined,
      'color': Color(0xFFEF4444),
      'screen': AddInvoiceData(),
    },
    {
      'name': 'Background Remover',
      'icon': Icons.edit_outlined,
      'color': Color(0xFFF59E0B),
      'screen': BackgroundRemoverScreen(),
    },
     {
      'name': 'Online Punchang',
      'icon': Icons.calendar_month,
      'color': Color(0xFFF59E0B),
      'screen': OnlinePunchangScreen(),
    },
  ];

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const CategoryScreen(),
            //       ),
            //     );
            //   },
            //   child: const Text(
            //     'View All',
            //     style: TextStyle(
            //       color: Color(0xFF6366F1),
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Container(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              name: category['name'] as String,
              icon: category['icon'] as IconData,
              color: category['color'] as Color,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => category['screen'] as Widget,
                  ),
                );
              },
            );
          },
        ),
      ),
      const SizedBox(height: 32),
    ],
  );
}

Widget _buildCategoryCard({
  required String name,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return Container(
    width: 100,
    margin: const EdgeInsets.only(right: 12),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
          const SizedBox(height: 16), // Add spacing
        _buildCategoriesSection(), 

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
                    // icon: const Icon(
                    //   Icons.arrow_forward_ios,
                    //   size: 16,
                    //   color: Color(0xFF6366F1),
                    // ),
                    label: const Text(
                      '',
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
                  // Text(
                  //   'View All',
                  //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  // ),
                  // SizedBox(width: 4),
                  // Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
        ],
      ),
    );
  }
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionPlansPage(),
                          ),
                        );
                        // Navigator.pop(context);
                        // showSubscriptionModal(context);
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.95,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.4),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // Main content
              Column(
                children: [
                  // Header with close button (optional header text removed)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Plans Container - Now using Expanded with fixed layout
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Consumer<GetAllPlanProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: Color(0xFF6366F1),
                                    strokeWidth: 3,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Loading premium plans...',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (provider.error != null) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.red.shade400,
                                      size: 48,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Oops! Something went wrong',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Unable to load plans. Please try again.',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () => provider.fetchAllPlans(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6366F1),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Try Again',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (provider.plans.isNotEmpty) {
                            // Non-scrollable plan list with flexible spacing
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                final totalPlans = provider.plans.length;
                                final availableHeight = constraints.maxHeight;

                                // Calculate height for each plan based on number of plans
                                final planHeight = availableHeight / totalPlans;

                                return Column(
                                  children: provider.plans.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final plan = entry.value;

                                    return Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom:
                                              index < provider.plans.length - 1
                                              ? 12
                                              : 0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: index == 0
                                                ? const Color(0xFF6366F1)
                                                : Colors.grey.shade200,
                                            width: index == 0 ? 2 : 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlanDetailsAndPaymentScreen(
                                                        plan: plan,
                                                      ),
                                                ),
                                              );
                                            },
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Plan name and badge
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          plan.name ?? 'Plan',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index == 0
                                                                ? const Color(
                                                                    0xFF6366F1,
                                                                  )
                                                                : Colors
                                                                      .black87,
                                                          ),
                                                        ),
                                                      ),
                                                      // if (index == 0)
                                                      //   Container(
                                                      //     padding:
                                                      //         const EdgeInsets.symmetric(
                                                      //           horizontal: 8,
                                                      //           vertical: 4,
                                                      //         ),
                                                      //     decoration: BoxDecoration(
                                                      //       color: const Color(
                                                      //         0xFF6366F1,
                                                      //       ),
                                                      //       borderRadius:
                                                      //           BorderRadius.circular(
                                                      //             12,
                                                      //           ),
                                                      //     ),
                                                      //     child: const Text(
                                                      //       'POPULAR',
                                                      //       style: TextStyle(
                                                      //         color:
                                                      //             Colors.white,
                                                      //         fontSize: 9,
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .w600,
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  // Price
                                                  Text(
                                                    '${plan.offerPrice?.toStringAsFixed(2) ?? '0.00'}/${(plan.duration ?? 'month') == 'month' ? 'mo' : 'yr'}',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: index == 0
                                                          ? const Color(
                                                              0xFF6366F1,
                                                            )
                                                          : Colors.black87,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 8),
                                                  // Plan description
                                                  if (plan.features != null &&
                                                      plan.features!.isNotEmpty)
                                                    // Text(
                                                    //   plan.features.toString(),
                                                    //   style: TextStyle(
                                                    //     fontSize: 11,
                                                    //     color: Colors
                                                    //         .grey
                                                    //         .shade600,
                                                    //     height: 1.3,
                                                    //   ),
                                                    //   maxLines: 2,
                                                    //   overflow:
                                                    //       TextOverflow.ellipsis,
                                                    // ),
                                                    const SizedBox(height: 12),
                                                  // Features list
                                                  Flexible(
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      children:
                                                          plan.features
                                                              ?.take(4)
                                                              .map(
                                                                (
                                                                  feature,
                                                                ) => Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        bottom:
                                                                            4,
                                                                      ),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        size:
                                                                            14,
                                                                        color:
                                                                            index ==
                                                                                0
                                                                            ? const Color(
                                                                                0xFF6366F1,
                                                                              )
                                                                            : Colors.green,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            6,
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          feature,
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color:
                                                                                Colors.grey.shade700,
                                                                          ),
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                              .toList() ??
                                                          [],
                                                    ),
                                                  ),
                                                  if ((plan.features?.length ??
                                                          0) >
                                                      4)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 4,
                                                          ),
                                                      child: Text(
                                                        '+ ${(plan.features?.length ?? 0) - 4} more features',
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          color: Colors
                                                              .grey
                                                              .shade600,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            );
                          }

                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Plans Available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Check back soon for premium options',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Footer with subscription info
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.autorenew_rounded,
                              size: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Auto-renews unless cancelled 24h before period ends',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.95),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _launchURL(
                                'https://editezy.onrender.com/privacy-and-policy',
                              ),
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '•',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(
                                'https://editezy.onrender.com/terms-and-conditions',
                              ),
                              child: Text(
                                'Terms of Use',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  // Helper method to launch URLs
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
                                'http://31.97.206.144:4061/api/users/refferalcode/$userId',
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

                    void shareReferralCode() {
                      if (userReferralCode != null &&
                          userReferralCode!.isNotEmpty) {
                        final shareText =
                            '''
🎉 Join me on EditEzy - Amazing Photo & Poster Editor!

Use my referral code: $userReferralCode

You'll get exclusive benefits, and I'll earn ₹200 when you upgrade your account!

Download EditEzy now:
https://play.google.com/store/apps/details?id=com.posternova.posternova

Don't miss out on this opportunity! 🚀
''';
                        Share.share(
                          shareText,
                          subject: 'Join EditEzy using my referral code',
                        );
                      }
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (isLoading &&
                          userReferralCode == null &&
                          errorMessage == null) {
                        loadUserDataAndFetchReferralCode();
                      }
                    });

                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Center(
                        child: Container(
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
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                      ),
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Info Card
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF0F9FF),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFBAE6FD),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF0EA5E9,
                                                  ),
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
                                                  key: const ValueKey(
                                                    'loading',
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                    20,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.grey[200]!,
                                                    ),
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                          color: Color(
                                                            0xFF6B7280,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : (errorMessage != null)
                                              ? Container(
                                                  key: const ValueKey('error'),
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFFEF2F2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
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
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              errorMessage!,
                                                              style:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Color(
                                                                      0xFF991B1B,
                                                                    ),
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 12,
                                                      ),
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
                                                            side:
                                                                const BorderSide(
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
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
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
                                                              style: const TextStyle(
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
                                                              const SnackBar(
                                                                content: Text(
                                                                  'Referral code copied to clipboard',
                                                                ),
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                backgroundColor:
                                                                    Color(
                                                                      0xFF10B981,
                                                                    ),
                                                                duration:
                                                                    Duration(
                                                                      seconds:
                                                                          2,
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
                                                        style:
                                                            IconButton.styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFF4F46E5,
                                                                  ).withOpacity(
                                                                    0.1,
                                                                  ),
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

                                        // Action Buttons
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  if (userReferralCode !=
                                                          null &&
                                                      userReferralCode!
                                                          .isNotEmpty) {
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
                                                          'Referral code copied!',
                                                        ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor: Color(
                                                          0xFF10B981,
                                                        ),
                                                        duration: Duration(
                                                          seconds: 2,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    loadUserDataAndFetchReferralCode();
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.copy,
                                                  size: 20,
                                                ),
                                                label: const Text('Copy Code'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF4F46E5,
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  elevation: 0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed:
                                                    (userReferralCode != null &&
                                                        userReferralCode!
                                                            .isNotEmpty)
                                                    ? shareReferralCode
                                                    : null,
                                                icon: const Icon(
                                                  Icons.share,
                                                  size: 20,
                                                ),
                                                label: const Text('Share'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFF10B981,
                                                  ),
                                                  foregroundColor: Colors.white,
                                                  disabledBackgroundColor:
                                                      Colors.grey[300],
                                                  disabledForegroundColor:
                                                      Colors.grey[500],
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  elevation: 0,
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
                          ),
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
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

  Widget _buildStepss({
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
 