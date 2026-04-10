// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:posternova/views/SecondPhase/poster_editor.dart';
// import 'package:posternova/views/category/amoders_loading.dart';
// import 'package:posternova/widgets/recent_search_helper.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:posternova/helper/sub_modal_helper.dart';
// import 'package:posternova/models/category_model.dart';
// import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
// import 'package:posternova/providers/plans/get_all_plan_provider.dart';
// import 'package:posternova/providers/plans/my_plan_provider.dart';
// import 'package:posternova/views/PosterModule/poster_making_screen.dart';
// import 'package:posternova/views/category/category_detail_screen.dart';
// import 'package:posternova/views/category/search_category.dart';
// import 'package:posternova/views/subscription/payment_success_screen.dart';
// import 'package:posternova/views/subscription/plan_detail_screen.dart';
// import 'package:posternova/widgets/common_modal.dart';
// import 'package:posternova/widgets/premium_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';

// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({super.key});

//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }

// class _CategoryScreenState extends State<CategoryScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   final ScrollController _scrollController = ScrollController();
//   bool _showElevation = false;
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _lastWords = '';
//   bool _isMicButtonVisible = true;
//   List<String> _recentSearches = [];
//   bool _isLoadingRecent = true;
//   Timer? _speechTimer;
//   String? _selectedCategory;

//   String? _selectedLanguage;
//   List<String> _availableLanguages = [];
//   bool _showLanguageFilter = false;

//   final List<Map<String, dynamic>> _languages = [
//     {'name': 'English', 'code': 'english', 'icon': '🇺🇸'},
//     {'name': 'Telugu', 'code': 'telugu', 'icon': '🇮🇳'},
//     {'name': 'Hindi', 'code': 'hindi', 'icon': '🇮🇳'},
//     {'name': 'Tamil', 'code': 'tamil', 'icon': '🇮🇳'},
//     {'name': 'Malayalam', 'code': 'malayalam', 'icon': '🇮🇳'},
//     {'name': 'Kannada', 'code': 'kannada', 'icon': '🇮🇳'},
//     {'name': 'Bengali', 'code': 'bengali', 'icon': '🇮🇳'},
//     {'name': 'All', 'code': null, 'icon': '🌐'},
//   ];

//   final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
//       GlobalKey<ScaffoldMessengerState>();

//   @override
//   void initState() {
//     super.initState();

//     _speech = stt.SpeechToText();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     _scrollController.addListener(() {
//       if (!mounted) return;
//       if (_scrollController.offset > 10 && !_showElevation) {
//         setState(() => _showElevation = true);
//       } else if (_scrollController.offset <= 10 && _showElevation) {
//         setState(() => _showElevation = false);
//       }
//     });

//     Future.microtask(() {
//       if (!mounted) return;
//       final posterProvider = Provider.of<PosterProvider>(
//         context,
//         listen: false,
//       );

//       Provider.of<PosterProvider>(context, listen: false).fetchPosters();
//       _animationController.forward();
//       _loadRecentSearches();
//       _extractAvailableLanguages(posterProvider.posters);
//     });
//   }

//   void _extractAvailableLanguages(List<CategoryModel> posters) {
//     final Set<String> languages = {};
//     for (var poster in posters) {
//       if (poster.posterlang.isNotEmpty) {
//         languages.add(poster.posterlang.toLowerCase());
//       }
//     }
//     setState(() {
//       _availableLanguages = languages.toList();
//     });
//   }

//   List<CategoryModel> _filterByLanguage(List<CategoryModel> posters) {
//     if (_selectedLanguage == null || _selectedLanguage == 'all') {
//       return posters;
//     }
//     return posters
//         .where(
//           (poster) =>
//               poster.posterlang.toLowerCase() ==
//               _selectedLanguage!.toLowerCase(),
//         )
//         .toList();
//   }

//   // Filter categories based on selected language
//   List<String> _getFilteredCategories(List<CategoryModel> filteredPosters) {
//     final categories = <String>{};
//     for (var poster in filteredPosters) {
//       if (poster.categoryName.isNotEmpty) {
//         categories.add(poster.categoryName);
//       }
//     }
//     return categories.toList();
//   }

//   Future<void> _loadRecentSearches() async {
//     if (!mounted) return;
//     setState(() => _isLoadingRecent = true);
//     final searches = await RecentSearchHelper.getRecentSearches();
//     if (!mounted) return;
//     setState(() {
//       _recentSearches = searches;
//       _isLoadingRecent = false;
//     });
//   }

//   void _startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done') {
//           _stopListening();
//         }
//       },
//       onError: (error) {
//         _showSpeechError(error.errorMsg);
//       },
//     );

//     if (available) {
//       if (!mounted) return;
//       setState(() {
//         _isListening = true;
//         _isMicButtonVisible = false;
//       });

//       _speech.listen(
//         onResult: (result) {
//           if (!mounted) return;
//           setState(() {
//             _lastWords = result.recognizedWords;
//           });

//           _speechTimer?.cancel();
//           _speechTimer = Timer(const Duration(seconds: 3), () {
//             if (_isListening && mounted) {
//               _stopListening();
//             }
//           });
//         },
//         listenFor: const Duration(seconds: 30),
//         pauseFor: const Duration(seconds: 5),
//         partialResults: true,
//         localeId: 'en_US',
//         cancelOnError: true,
//         listenMode: stt.ListenMode.confirmation,
//       );
//     } else {
//       _showSpeechError('Speech recognition not available');
//     }
//   }

//   void _stopListening() {
//     _speechTimer?.cancel();
//     _speech.stop();
//     if (!mounted) return;
//     setState(() {
//       _isListening = false;
//       _isMicButtonVisible = true;
//     });

//     if (_lastWords.trim().isNotEmpty) {
//       _performVoiceSearch(_lastWords);
//     }
//   }

//   void _performVoiceSearch(String query) async {
//     await RecentSearchHelper.addRecentSearch(query);
//     await _loadRecentSearches();

//     if (mounted) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchScreen(initialQuery: query),
//         ),
//       );
//     }

//     if (!mounted) return;
//     setState(() => _lastWords = '');
//   }

//   void _showSpeechError(String error) {
//     if (!mounted) return;
//     setState(() {
//       _isListening = false;
//       _isMicButtonVisible = true;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Speech error: $error'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }

//   Future<bool> _onWillPop() async {
//     if (_isListening) {
//       _stopListening();
//       return false;
//     }

//     if (Navigator.canPop(context)) {
//       return true;
//     }
//     return await _showExitConfirmation();
//   }

//   Future<bool> _showExitConfirmation() async {
//     return await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (context) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: const Text(
//               'Exit App',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             content: const Text('Are you sure you want to exit?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () => SystemNavigator.pop(),
//                 style: TextButton.styleFrom(foregroundColor: Colors.red),
//                 child: const Text('Exit'),
//               ),
//             ],
//           ),
//         ) ??
//         false;
//   }

//   @override
//   void dispose() {
//     _speechTimer?.cancel();
//     if (_isListening) {
//       _speech.stop();
//     }
//     _animationController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   // Build language filter button
//   Widget _buildLanguageFilterButton() {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _showLanguageFilter = !_showLanguageFilter;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFFE5E7EB)),
//           borderRadius: BorderRadius.circular(10),
//           color: _selectedLanguage != null
//               ? const Color(0xFF4F46E5).withOpacity(0.1)
//               : Colors.white,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.translate, size: 18, color: Color(0xFF4F46E5)),
//             const SizedBox(width: 8),
//             Text(
//               _selectedLanguage != null && _selectedLanguage != 'all'
//                   ? _getLanguageDisplayName(_selectedLanguage!)
//                   : 'Language',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: _selectedLanguage != null
//                     ? const Color(0xFF4F46E5)
//                     : const Color(0xFF374151),
//               ),
//             ),
//             const SizedBox(width: 4),
//             Icon(
//               _showLanguageFilter ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//               size: 20,
//               color: const Color(0xFF6B7280),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _getLanguageDisplayName(String code) {
//     final language = _languages.firstWhere(
//       (lang) => lang['code'] == code,
//       orElse: () => {'name': code, 'icon': ''},
//     );
//     return '${language['icon']} ${language['name']}';
//   }

//   // Language filter dropdown overlay
//   Widget _buildLanguageDropdown() {
//     if (!_showLanguageFilter) return const SizedBox.shrink();

//     return Positioned(
//       top: 70,
//       right: 16,
//       child: Material(
//         elevation: 8,
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//         child: Container(
//           width: 200,
//           constraints: const BoxConstraints(maxHeight: 400),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 decoration: const BoxDecoration(
//                   border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Filter by Language',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1F2937),
//                       ),
//                     ),
//                     if (_selectedLanguage != null)
//                       TextButton(
//                         onPressed: () {
//                           setState(() {
//                             _selectedLanguage = null;
//                             _showLanguageFilter = false;
//                           });
//                         },
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                           minimumSize: Size.zero,
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: const Text(
//                           'Clear',
//                           style: TextStyle(fontSize: 12, color: Colors.red),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               // Language list
//               Flexible(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   itemCount: _languages.length,
//                   itemBuilder: (context, index) {
//                     final language = _languages[index];
//                     final isSelected = _selectedLanguage == language['code'];
//                     final isAvailable =
//                         language['code'] == null ||
//                         _availableLanguages.contains(language['code']);

//                     if (!isAvailable && language['code'] != null) {
//                       return const SizedBox.shrink(); // Hide unavailable languages
//                     }

//                     return InkWell(
//                       onTap: () {
//                         setState(() {
//                           _selectedLanguage = language['code'];
//                           _showLanguageFilter = false;
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 12,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? const Color(0xFF4F46E5).withOpacity(0.1)
//                               : Colors.transparent,
//                           border: const Border(
//                             bottom: BorderSide(color: Color(0xFFF3F4F6)),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               language['icon'],
//                               style: const TextStyle(fontSize: 20),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 language['name'],
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: isSelected
//                                       ? FontWeight.w600
//                                       : FontWeight.normal,
//                                   color: isSelected
//                                       ? const Color(0xFF4F46E5)
//                                       : const Color(0xFF374151),
//                                 ),
//                               ),
//                             ),
//                             if (isSelected)
//                               const Icon(
//                                 Icons.check,
//                                 size: 18,
//                                 color: Color(0xFF4F46E5),
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final padding = isTablet ? 24.0 : 16.0;

//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF8F9FA),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   children: [
//                     _buildAppBar(padding, isTablet),
//                     _buildFilterRow(padding),
//                     Expanded(
//                       child: Consumer<PosterProvider>(
//                         builder: (context, posterProvider, child) {
//                           if (posterProvider.isLoading) {
//                             return _buildLoadingState(padding, isTablet);
//                           }

//                           if (posterProvider.error != null) {
//                             return _buildErrorState(posterProvider);
//                           }

//                           // 🔥 CRITICAL FIX: Filter posters by selected language
//                           final filteredByLanguage = _filterByLanguage(
//                             posterProvider.posters,
//                           );

//                           // If no posters after language filter, show empty state
//                           if (filteredByLanguage.isEmpty) {
//                             return _buildEmptyLanguageState();
//                           }

//                           // Extract languages after data loads
//                           if (_availableLanguages.isEmpty &&
//                               posterProvider.posters.isNotEmpty) {
//                             WidgetsBinding.instance.addPostFrameCallback((_) {
//                               _extractAvailableLanguages(
//                                 posterProvider.posters,
//                               );
//                             });
//                           }

//                           // 🔥 USE FILTERED posters for categories
//                           final categories = _extractUniqueCategories(
//                             filteredByLanguage,
//                           );

//                           if (categories.isEmpty) {
//                             return _buildEmptyState();
//                           }

//                           // Filter posters by selected category chip
//                           final filteredCategories = _selectedCategory == null
//                               ? categories
//                               : categories
//                                     .where(
//                                       (c) =>
//                                           c.toLowerCase() ==
//                                           _selectedCategory!.toLowerCase(),
//                                     )
//                                     .toList();

//                           return Column(
//                             children: [
//                               // Category Filter Chips
//                               _buildCategoryChips(categories, padding),
//                               Expanded(
//                                 child: _buildCategoryList(
//                                   filteredCategories,
//                                   filteredByLanguage, // 🔥 Pass filtered posters
//                                   padding,
//                                   isTablet,
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               _buildLanguageDropdown(),
//               // Voice search overlay
//               if (_isListening) _buildVoiceSearchOverlay(),

//               // Mic button
//               if (_isMicButtonVisible) _buildFloatingMicButton(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterRow(double padding) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.fromLTRB(padding, 12, padding, 12),
//       child: Row(
//         children: [
//           Expanded(child: _buildLanguageFilterButton()),
//           // You can add more filters here if needed
//           // const SizedBox(width: 12),
//           // _buildAnotherFilterButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyLanguageState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFEF3C7),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.translate_outlined,
//                 color: Color(0xFFF59E0B),
//                 size: 48,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               _selectedLanguage != null
//                   ? 'No ${_getLanguageDisplayName(_selectedLanguage!)} templates available'
//                   : 'No templates available',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Try selecting a different language',
//               style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             if (_selectedLanguage != null)
//               ElevatedButton.icon(
//                 onPressed: () {
//                   setState(() {
//                     _selectedLanguage = null;
//                   });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF4F46E5),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 12,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 icon: const Icon(Icons.clear, size: 18),
//                 label: const Text('Clear Language Filter'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Horizontal scrollable category filter chips (like the image)
//   Widget _buildCategoryChips(List<String> categories, double padding) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: padding),
//         child: Row(
//           children: categories.map((category) {
//             final isSelected = _selectedCategory == category;
//             return Padding(
//               padding: const EdgeInsets.only(right: 10),
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     _selectedCategory = isSelected ? null : category;
//                   });
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 18,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isSelected ? const Color(0xFFFFC107) : Colors.white,
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(
//                       color: isSelected
//                           ? const Color(0xFFFFC107)
//                           : const Color(0xFFD1D5DB),
//                       width: 1.5,
//                     ),
//                     boxShadow: isSelected
//                         ? [
//                             BoxShadow(
//                               color: const Color(0xFFFFC107).withOpacity(0.3),
//                               blurRadius: 8,
//                               offset: const Offset(0, 2),
//                             ),
//                           ]
//                         : [],
//                   ),
//                   child: Text(
//                     _capitalizeFirstLetter(category),
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: isSelected
//                           ? Colors.black87
//                           : const Color(0xFF374151),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildVoiceSearchOverlay() {
//     return Positioned.fill(
//       child: GestureDetector(
//         onTap: _stopListening,
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
//           child: Container(
//             color: Colors.black.withOpacity(0.3),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.3),
//                         blurRadius: 20,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       ...List.generate(3, (index) {
//                         return AnimatedContainer(
//                           duration: const Duration(milliseconds: 1500),
//                           width: 80 + (index * 30),
//                           height: 80 + (index * 30),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.blue.withOpacity(
//                                 0.3 - (index * 0.1),
//                               ),
//                               width: 2,
//                             ),
//                           ),
//                         );
//                       }),
//                       Container(
//                         width: 60,
//                         height: 60,
//                         decoration: const BoxDecoration(
//                           color: Colors.blue,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.mic,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 const Text(
//                   'Listening...',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 12,
//                   ),
//                   margin: const EdgeInsets.symmetric(horizontal: 40),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     _lastWords.isNotEmpty ? _lastWords : 'Speak now...',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: _lastWords.isNotEmpty ? Colors.blue : Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Tap anywhere to stop',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white.withOpacity(0.8),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFloatingMicButton(BuildContext context) {
//     return Positioned(
//       bottom: 20,
//       right: 20,
//       child: Consumer<MyPlanProvider>(
//         builder: (context, myPlanProvider, child) {
//           return FloatingActionButton(
//             onPressed: () {
//               if (myPlanProvider.isPurchase == true) {
//                 _startListening();
//               } else {
//                 CommonModal.showWarning(
//                   context: context,
//                   title: "Premium Feature",
//                   message:
//                       "Voice search is a premium feature. Upgrade to unlock voice commands and advanced search capabilities.",
//                   primaryButtonText: "Upgrade Now",
//                   secondaryButtonText: "Cancel",
//                   onPrimaryPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SubscriptionPlansPage(),
//                       ),
//                     );
//                   },
//                   onSecondaryPressed: () => Navigator.of(context).pop(),
//                 );
//               }
//             },
//             backgroundColor: const Color(0xFF4F46E5),
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 8,
//             child: const Icon(Icons.mic, size: 28),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildAppBar(double padding, bool isTablet) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: _showElevation
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ]
//             : [],
//       ),
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(padding, padding, padding, padding / 2),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Categories',
//                 style: TextStyle(
//                   fontSize: isTablet ? 26 : 22,
//                   fontWeight: FontWeight.w700,
//                   color: const Color(0xFF1A1A1A),
//                 ),
//               ),
//             ),
//             // Language filter indicator
//             if (_selectedLanguage != null)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 margin: const EdgeInsets.only(right: 12),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF4F46E5).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(
//                       Icons.translate,
//                       size: 14,
//                       color: Color(0xFF4F46E5),
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       _getLanguageDisplayName(_selectedLanguage!),
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF4F46E5),
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _selectedLanguage = null;
//                         });
//                       },
//                       child: const Icon(
//                         Icons.close,
//                         size: 14,
//                         color: Color(0xFF4F46E5),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             // Search button
//             _buildSearchIconButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchIconButton() {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myPlanProvider, child) {
//         return Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () async {
//               if (myPlanProvider.isPurchase == true) {
//                 await _showSearchModal();
//               } else {
//                 CommonModal.showWarning(
//                   context: context,
//                   title: "Premium Category",
//                   message:
//                       "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
//                   primaryButtonText: "Upgrade Now",
//                   secondaryButtonText: "Cancel",
//                   onPrimaryPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SubscriptionPlansPage(),
//                       ),
//                     );
//                   },
//                   onSecondaryPressed: () => Navigator.of(context).pop(),
//                 );
//               }
//             },
//             borderRadius: BorderRadius.circular(10),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0xFFE5E7EB)),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(
//                 Icons.search_rounded,
//                 size: 22,
//                 color: Color(0xFF374151),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _showSearchModal() async {
//     await _loadRecentSearches();

//     if (!mounted) return;

//     String? searchQuery = await showModalBottomSheet<String?>(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (context) {
//         final searchController = TextEditingController();
//         String currentQuery = '';

//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Container(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: searchController,
//                             autofocus: true,
//                             decoration: InputDecoration(
//                               hintText: 'Search templates...',
//                               prefixIcon: const Icon(
//                                 Icons.search,
//                                 color: Color(0xFF6B7280),
//                               ),
//                               suffixIcon: currentQuery.isNotEmpty
//                                   ? IconButton(
//                                       icon: const Icon(Icons.close),
//                                       onPressed: () {
//                                         searchController.clear();
//                                         setModalState(() => currentQuery = '');
//                                       },
//                                     )
//                                   : null,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                               filled: true,
//                               fillColor: const Color(0xFFF3F4F6),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                             ),
//                             onChanged: (value) {
//                               setModalState(() => currentQuery = value);
//                             },
//                             onSubmitted: (value) {
//                               if (value.trim().isNotEmpty) {
//                                 Navigator.pop(context, value.trim());
//                               }
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Consumer<MyPlanProvider>(
//                           builder: (context, myPlanProvider, child) {
//                             return Material(
//                               color: const Color(0xFF4F46E5),
//                               borderRadius: BorderRadius.circular(12),
//                               child: InkWell(
//                                 onTap: () {
//                                   if (myPlanProvider.isPurchase == true) {
//                                     Navigator.pop(context);
//                                     _startListening();
//                                   } else {
//                                     CommonModal.showWarning(
//                                       context: context,
//                                       title: "Premium Feature",
//                                       message:
//                                           "Voice search is a premium feature. Upgrade to unlock voice commands.",
//                                       primaryButtonText: "Upgrade Now",
//                                       secondaryButtonText: "Cancel",
//                                       onPrimaryPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 SubscriptionPlansPage(),
//                                           ),
//                                         );
//                                       },
//                                       onSecondaryPressed: () =>
//                                           Navigator.of(context).pop(),
//                                     );
//                                   }
//                                 },
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(12),
//                                   child: const Icon(
//                                     Icons.mic,
//                                     color: Colors.white,
//                                     size: 22,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (_recentSearches.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Recent Searches',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1F2937),
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () async {
//                                   await RecentSearchHelper.clearRecentSearches();
//                                   await _loadRecentSearches();
//                                   setModalState(() {});
//                                 },
//                                 style: TextButton.styleFrom(
//                                   foregroundColor: Colors.red,
//                                   padding: EdgeInsets.zero,
//                                   minimumSize: Size.zero,
//                                   tapTargetSize:
//                                       MaterialTapTargetSize.shrinkWrap,
//                                 ),
//                                 child: const Text(
//                                   'Clear All',
//                                   style: TextStyle(fontSize: 13),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: _recentSearches.length,
//                           itemBuilder: (context, index) {
//                             final search = _recentSearches[index];
//                             return ListTile(
//                               leading: const Icon(
//                                 Icons.history_rounded,
//                                 color: Color(0xFF6B7280),
//                                 size: 20,
//                               ),
//                               title: Text(
//                                 search,
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Color(0xFF1F2937),
//                                 ),
//                               ),
//                               trailing: IconButton(
//                                 icon: const Icon(
//                                   Icons.close,
//                                   size: 16,
//                                   color: Color(0xFF9CA3AF),
//                                 ),
//                                 onPressed: () async {
//                                   await RecentSearchHelper.removeRecentSearch(
//                                     search,
//                                   );
//                                   await _loadRecentSearches();
//                                   setModalState(() {});
//                                 },
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                               ),
//                               onTap: () {
//                                 Navigator.pop(context, search);
//                               },
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                               ),
//                               minLeadingWidth: 0,
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   if (_recentSearches.isEmpty && !_isLoadingRecent)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 40),
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.search_off_rounded,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                           const SizedBox(height: 12),
//                           const Text(
//                             'No recent searches',
//                             style: TextStyle(
//                               color: Color(0xFF6B7280),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );

//     if (searchQuery != null && searchQuery.isNotEmpty && mounted) {
//       await RecentSearchHelper.addRecentSearch(searchQuery);
//       if (!mounted) return;
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SearchScreen(initialQuery: searchQuery),
//         ),
//       );
//     }
//   }

//   Widget _buildCategoryList(
//     List<String> categories,
//     List<dynamic> posters,
//     double padding,
//     bool isTablet,
//   ) {
//     final itemWidth = isTablet ? 140.0 : 110.0;
//     final itemHeight = isTablet ? 160.0 : 130.0;

//     return ListView.builder(
//       controller: _scrollController,
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.symmetric(vertical: padding),
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         final categoryPosters = _getPostersByCategory(category, posters);

//         return Padding(
//           padding: EdgeInsets.only(bottom: padding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildCategoryHeader(category, padding, isTablet),
//               const SizedBox(height: 12),
//               SizedBox(
//                 height: itemHeight + 20,
//                 child: _buildHorizontalPosterList(
//                   categoryPosters,
//                   itemWidth,
//                   itemHeight,
//                   padding,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCategoryHeader(String category, double padding, bool isTablet) {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myplanprovider, child) {
//         return Padding(
//           padding: EdgeInsets.symmetric(horizontal: padding),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   _capitalizeFirstLetter(category),
//                   style: TextStyle(
//                     fontSize: isTablet ? 20 : 17,
//                     fontWeight: FontWeight.w700,
//                     color: const Color(0xFF1A1A1A),
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (myplanprovider.isPurchase == true) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DetailsScreen(category: category),
//                       ),
//                     );
//                   } else {
//                     CommonModal.showWarning(
//                       context: context,
//                       title: "Premium Category",
//                       message:
//                           "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
//                       primaryButtonText: "Upgrade Now",
//                       secondaryButtonText: "Cancel",
//                       onPrimaryPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SubscriptionPlansPage(),
//                           ),
//                         );
//                       },
//                       onSecondaryPressed: () => Navigator.of(context).pop(),
//                     );
//                   }
//                 },
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'View All',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF1A1A1A),
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     const Icon(
//                       Icons.arrow_forward_ios_rounded,
//                       size: 13,
//                       color: Color(0xFF1A1A1A),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void showSubscriptionModal(BuildContext context) async {
//     final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

//     if (myPlanProvider.isPurchase == true) {
//       return;
//     }

//     final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
//     final shouldShowAgain =
//         await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

//     if (hasShownRecently && !shouldShowAgain) {
//       return;
//     }

//     if (!mounted) return;

//     final planProvider = Provider.of<GetAllPlanProvider>(
//       context,
//       listen: false,
//     );
//     if (planProvider.plans.isEmpty && !planProvider.isLoading) {
//       planProvider.fetchAllPlans();
//     }

//     if (!mounted) return;

//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           constraints: const BoxConstraints(maxWidth: 400),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 30,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
//                 child: Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.close,
//                             size: 18,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       width: 70,
//                       height: 70,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                         ),
//                         borderRadius: BorderRadius.circular(18),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFFFFA500).withOpacity(0.3),
//                             blurRadius: 15,
//                             offset: const Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.workspace_premium_rounded,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Unlock Premium',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1F2937),
//                         letterSpacing: -0.5,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       'Get unlimited access to all features',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                         height: 1.3,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 constraints: const BoxConstraints(maxHeight: 280),
//                 child: Consumer<GetAllPlanProvider>(
//                   builder: (context, provider, child) {
//                     if (provider.isLoading) {
//                       return const Padding(
//                         padding: EdgeInsets.all(40.0),
//                         child: Center(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               CircularProgressIndicator(
//                                 color: Color(0xFF6366F1),
//                                 strokeWidth: 3,
//                               ),
//                               SizedBox(height: 12),
//                               Text(
//                                 'Loading plans...',
//                                 style: TextStyle(
//                                   color: Color(0xFF6B7280),
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }

//                     if (provider.error != null) {
//                       return Padding(
//                         padding: const EdgeInsets.all(24.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.error_outline_rounded,
//                               color: Colors.red.shade400,
//                               size: 48,
//                             ),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Unable to Load Plans',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF1F2937),
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               'Please try again',
//                               style: TextStyle(
//                                 color: Colors.grey.shade600,
//                                 fontSize: 13,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             ElevatedButton.icon(
//                               onPressed: () => provider.fetchAllPlans(),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF6366F1),
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 12,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               icon: const Icon(Icons.refresh_rounded, size: 18),
//                               label: const Text(
//                                 'Try Again',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }

//                     if (provider.plans.isNotEmpty) {
//                       return SingleChildScrollView(
//                         padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                         child: AnimatedPlanList(
//                           plans: provider.plans,
//                           onPlanSelected: (plan) {
//                             Navigator.of(context).pop();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     PlanDetailsAndPaymentScreen(plan: plan),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     }

//                     return Padding(
//                       padding: const EdgeInsets.all(24.0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.shopping_bag_outlined,
//                             size: 48,
//                             color: Colors.grey.shade400,
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'No Plans Available',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Please check back later',
//                             style: TextStyle(
//                               color: Colors.grey.shade500,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHorizontalPosterList(
//     List<CategoryModel> posters,
//     double itemWidth,
//     double itemHeight,
//     double padding,
//   ) {
//     if (posters.isEmpty) {
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: padding),
//         child: Center(
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: const Color(0xFFE5E7EB)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.image_not_supported_outlined,
//                   color: Colors.grey.shade400,
//                   size: 32,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   "No items available",
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       physics: const BouncingScrollPhysics(),
//       padding: EdgeInsets.symmetric(horizontal: padding),
//       itemCount: posters.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.only(right: index == posters.length - 1 ? 0 : 12),
//           child: _buildPosterCard(posters[index], itemWidth, itemHeight),
//         );
//       },
//     );
//   }

//   Widget _buildPosterCard(CategoryModel poster, double width, double height) {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myplanProvider, child) {
//         return Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {
//               if (myplanProvider.isPurchase == true) {
//                 final bgImageUrl = poster.images[0] ?? '';
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => PosterEditorScreen(
//                       posterAsset: bgImageUrl,
//                       itemid: poster.id,
//                     ),
//                   ),
//                 );
//               } else {
//                 CommonModal.showWarning(
//                   context: context,
//                   title: "Premium Category",
//                   message:
//                       "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
//                   primaryButtonText: "Upgrade Now",
//                   secondaryButtonText: "Cancel",
//                   onPrimaryPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SubscriptionPlansPage(),
//                       ),
//                     );
//                   },
//                   onSecondaryPressed: () => Navigator.of(context).pop(),
//                 );
//               }
//             },
//             borderRadius: BorderRadius.circular(16),
//             child: Container(
//               width: width,
//               height: height,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: poster.images.isNotEmpty
//                     ? Image.network(
//                         poster.images[0],
//                         fit: BoxFit.cover,
//                         width: width,
//                         height: height,
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return Container(
//                             color: const Color(0xFFF3F4F6),
//                             child: Center(
//                               child: SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: const Color(0xFF4F46E5),
//                                   value:
//                                       loadingProgress.expectedTotalBytes != null
//                                       ? loadingProgress.cumulativeBytesLoaded /
//                                             loadingProgress.expectedTotalBytes!
//                                       : null,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         errorBuilder: (context, error, stackTrace) =>
//                             _buildPlaceholder(),
//                       )
//                     : _buildPlaceholder(),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPlaceholder() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             const Color(0xFF4F46E5).withOpacity(0.1),
//             const Color(0xFF7C3AED).withOpacity(0.1),
//           ],
//         ),
//       ),
//       child: const Center(
//         child: Icon(Icons.image_outlined, size: 48, color: Color(0xFF9CA3AF)),
//       ),
//     );
//   }

//   Widget _buildLoadingState(double padding, bool isTablet) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Your asset image
//           Image.asset(
//             'assets/appstore.png', // Replace with your actual asset path
//             width: isTablet ? 200 : 150,
//             height: isTablet ? 200 : 150,
//           ),
//           const SizedBox(height: 32),
//           AmodersLoading(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSimpleWaveLoader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(5, (index) {
//         return _buildBouncingDot(index);
//       }),
//     );
//   }

//   Widget _buildBouncingDot(int index) {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.easeInOut,
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (context, value, child) {
//         // Create a bouncing effect using a triangle wave pattern
//         double offset = 0;
//         double scale = 1;

//         if (value < 0.5) {
//           offset = value * 2 * 12;
//           scale = 0.6 + value * 2 * 0.4;
//         } else {
//           offset = (1 - value) * 2 * 12;
//           scale = 0.6 + (1 - value) * 2 * 0.4;
//         }

//         // Add delay based on index
//         final delayedValue = (value + index * 0.15) % 1;

//         double delayedOffset = 0;
//         double delayedScale = 1;

//         if (delayedValue < 0.5) {
//           delayedOffset = delayedValue * 2 * 12;
//           delayedScale = 0.6 + delayedValue * 2 * 0.4;
//         } else {
//           delayedOffset = (1 - delayedValue) * 2 * 12;
//           delayedScale = 0.6 + (1 - delayedValue) * 2 * 0.4;
//         }

//         return Transform.translate(
//           offset: Offset(0, -delayedOffset),
//           child: Transform.scale(
//             scale: delayedScale,
//             child: Container(
//               margin: const EdgeInsets.symmetric(horizontal: 6),
//               width: 12,
//               height: 12,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: const LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFFFFC107).withOpacity(0.4),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildErrorState(PosterProvider posterProvider) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFEE2E2),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.error_outline_rounded,
//                 color: Color(0xFFDC2626),
//                 size: 48,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Something went wrong',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Unable to load categories at this time',
//               style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () => posterProvider.fetchPosters(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF4F46E5),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                   vertical: 16,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//               icon: const Icon(Icons.refresh_rounded),
//               label: const Text(
//                 'Try Again',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF3F4F6),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.category_outlined,
//                 color: Color(0xFF9CA3AF),
//                 size: 48,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'No Categories Available',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF1A1A1A),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Check back later for new content',
//               style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<String> _extractUniqueCategories(List<dynamic> posters) {
//     final Set<String> categories = {};
//     for (var poster in posters) {
//       if (poster is CategoryModel && poster.categoryName.isNotEmpty) {
//         categories.add(poster.categoryName);
//       }
//     }
//     return categories.toList();
//   }

//   List<CategoryModel> _getPostersByCategory(
//     String category,
//     List<dynamic> allPosters,
//   ) {
//     return allPosters
//         .where(
//           (poster) =>
//               poster is CategoryModel &&
//               poster.categoryName.toLowerCase() == category.toLowerCase(),
//         )
//         .cast<CategoryModel>()
//         .toList();
//   }

//   String _capitalizeFirstLetter(String text) {
//     if (text.isEmpty) return '';
//     return text[0].toUpperCase() + text.substring(1);
//   }
// }

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/views/SecondPhase/poster_editor.dart';
import 'package:posternova/views/category/amoders_loading.dart';
import 'package:posternova/widgets/recent_search_helper.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:posternova/helper/sub_modal_helper.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/plans/get_all_plan_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/views/PosterModule/poster_making_screen.dart';
import 'package:posternova/views/category/category_detail_screen.dart';
import 'package:posternova/views/category/search_category.dart';
import 'package:posternova/views/subscription/payment_success_screen.dart';
import 'package:posternova/views/subscription/plan_detail_screen.dart';
import 'package:posternova/widgets/common_modal.dart';
import 'package:posternova/widgets/premium_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showElevation = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';
  bool _isMicButtonVisible = true;
  List<String> _recentSearches = [];
  bool _isLoadingRecent = true;
  Timer? _speechTimer;
  String? _selectedCategory;

  String? _selectedLanguage;
  List<String> _availableLanguages = [];
  bool _showLanguageFilter = false;

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  final List<Map<String, dynamic>> _languages = [
    {'name': 'English', 'code': 'english', 'icon': '🇺🇸'},
    {'name': 'Telugu', 'code': 'telugu', 'icon': '🇮🇳'},
    {'name': 'Hindi', 'code': 'hindi', 'icon': '🇮🇳'},
    {'name': 'Tamil', 'code': 'tamil', 'icon': '🇮🇳'},
    {'name': 'Malayalam', 'code': 'malayalam', 'icon': '🇮🇳'},
    {'name': 'Kannada', 'code': 'kannada', 'icon': '🇮🇳'},
    {'name': 'Bengali', 'code': 'bengali', 'icon': '🇮🇳'},
    {'name': 'All', 'code': null, 'icon': '🌐'},
  ];

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scrollController.addListener(() {
      if (!mounted) return;
      if (_scrollController.offset > 10 && !_showElevation) {
        setState(() => _showElevation = true);
      } else if (_scrollController.offset <= 10 && _showElevation) {
        setState(() => _showElevation = false);
      }
    });

    Future.microtask(() {
      if (!mounted) return;
      final posterProvider = Provider.of<PosterProvider>(
        context,
        listen: false,
      );

      Provider.of<PosterProvider>(context, listen: false).fetchPosters();
      _animationController.forward();
      _loadRecentSearches();
      _extractAvailableLanguages(posterProvider.posters);
    });
  }

  void _extractAvailableLanguages(List<CategoryModel> posters) {
    final Set<String> languages = {};
    for (var poster in posters) {
      if (poster.posterlang.isNotEmpty) {
        languages.add(poster.posterlang.toLowerCase());
      }
    }
    setState(() {
      _availableLanguages = languages.toList();
    });
  }

  List<CategoryModel> _filterByLanguage(List<CategoryModel> posters) {
    if (_selectedLanguage == null || _selectedLanguage == 'all') {
      return posters;
    }
    return posters
        .where(
          (poster) =>
              poster.posterlang.toLowerCase() ==
              _selectedLanguage!.toLowerCase(),
        )
        .toList();
  }

  // Filter categories based on selected language
  List<String> _getFilteredCategories(List<CategoryModel> filteredPosters) {
    final categories = <String>{};
    for (var poster in filteredPosters) {
      if (poster.categoryName.isNotEmpty) {
        categories.add(poster.categoryName);
      }
    }
    return categories.toList();
  }

  Future<void> _loadRecentSearches() async {
    if (!mounted) return;
    setState(() => _isLoadingRecent = true);
    final searches = await RecentSearchHelper.getRecentSearches();
    if (!mounted) return;
    setState(() {
      _recentSearches = searches;
      _isLoadingRecent = false;
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done') {
          _stopListening();
        }
      },
      onError: (error) {
        _showSpeechError(error.errorMsg);
      },
    );

    if (available) {
      if (!mounted) return;
      setState(() {
        _isListening = true;
        _isMicButtonVisible = false;
      });

      _speech.listen(
        onResult: (result) {
          if (!mounted) return;
          setState(() {
            _lastWords = result.recognizedWords;
          });

          _speechTimer?.cancel();
          _speechTimer = Timer(const Duration(seconds: 3), () {
            if (_isListening && mounted) {
              _stopListening();
            }
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: 'en_US',
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    } else {
      _showSpeechError('Speech recognition not available');
    }
  }

  void _stopListening() {
    _speechTimer?.cancel();
    _speech.stop();
    if (!mounted) return;
    setState(() {
      _isListening = false;
      _isMicButtonVisible = true;
    });

    if (_lastWords.trim().isNotEmpty) {
      _performVoiceSearch(_lastWords);
    }
  }

  void _performVoiceSearch(String query) async {
    await RecentSearchHelper.addRecentSearch(query);
    await _loadRecentSearches();

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(initialQuery: query),
        ),
      );
    }

    if (!mounted) return;
    setState(() => _lastWords = '');
  }

  void _showSpeechError(String error) {
    if (!mounted) return;
    setState(() {
      _isListening = false;
      _isMicButtonVisible = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Speech error: $error'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_isListening) {
      _stopListening();
      return false;
    }

    if (Navigator.canPop(context)) {
      return true;
    }
    return await _showExitConfirmation();
  }

  Future<bool> _showExitConfirmation() async {
    final isDarkMode = _isDarkMode;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: isDarkMode
                ? const Color(0xFF1E293B)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Exit App',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            content: Text(
              'Are you sure you want to exit?',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    _speechTimer?.cancel();
    if (_isListening) {
      _speech.stop();
    }
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Build language filter button
  Widget _buildLanguageFilterButton() {
    final isDarkMode = _isDarkMode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showLanguageFilter = !_showLanguageFilter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode
                ? const Color(0xFF334155)
                : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(10),
          color: _selectedLanguage != null
              ? const Color(0xFFF5C518).withOpacity(0.1)
              : (isDarkMode ? const Color(0xFF1E293B) : Colors.white),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate, size: 18, color: const Color(0xFFF5C518)),
            const SizedBox(width: 8),
            Text(
              _selectedLanguage != null && _selectedLanguage != 'all'
                  ? _getLanguageDisplayName(_selectedLanguage!)
                  : 'Language',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _selectedLanguage != null
                    ? const Color(0xFFF5C518)
                    : (isDarkMode ? Colors.white70 : const Color(0xFF374151)),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              _showLanguageFilter ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: 20,
              color: isDarkMode ? Colors.grey[400] : const Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageDisplayName(String code) {
    final language = _languages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => {'name': code, 'icon': ''},
    );
    return '${language['icon']} ${language['name']}';
  }

  // Language filter dropdown overlay
  Widget _buildLanguageDropdown() {
    final isDarkMode = _isDarkMode;

    if (!_showLanguageFilter) return const SizedBox.shrink();

    return Positioned(
      top: 70,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        child: Container(
          width: 200,
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDarkMode
                          ? const Color(0xFF334155)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter by Language',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF1F2937),
                      ),
                    ),
                    if (_selectedLanguage != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedLanguage = null;
                            _showLanguageFilter = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
              // Language list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = _selectedLanguage == language['code'];
                    final isAvailable =
                        language['code'] == null ||
                        _availableLanguages.contains(language['code']);

                    if (!isAvailable && language['code'] != null) {
                      return const SizedBox.shrink();
                    }

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = language['code'];
                          _showLanguageFilter = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF5C518).withOpacity(0.1)
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: isDarkMode
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFF3F4F6),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              language['icon'],
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                language['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFFF5C518)
                                      : (isDarkMode
                                            ? Colors.white70
                                            : const Color(0xFF374151)),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                size: 18,
                                color: Color(0xFFF5C518),
                              ),
                          ],
                        ),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final padding = isTablet ? 24.0 : 16.0;
    final isDarkMode = _isDarkMode;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: isDarkMode
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Stack(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    _buildAppBar(padding, isTablet),
                    _buildFilterRow(padding),
                    Expanded(
                      child: Consumer<PosterProvider>(
                        builder: (context, posterProvider, child) {
                          if (posterProvider.isLoading) {
                            return _buildLoadingState(padding, isTablet);
                          }

                          if (posterProvider.error != null) {
                            return _buildErrorState(posterProvider);
                          }

                          // 🔥 CRITICAL FIX: Filter posters by selected language
                          final filteredByLanguage = _filterByLanguage(
                            posterProvider.posters,
                          );

                          // If no posters after language filter, show empty state
                          if (filteredByLanguage.isEmpty) {
                            return _buildEmptyLanguageState();
                          }

                          // Extract languages after data loads
                          if (_availableLanguages.isEmpty &&
                              posterProvider.posters.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _extractAvailableLanguages(
                                posterProvider.posters,
                              );
                            });
                          }

                          // 🔥 USE FILTERED posters for categories
                          final categories = _extractUniqueCategories(
                            filteredByLanguage,
                          );

                          if (categories.isEmpty) {
                            return _buildEmptyState();
                          }

                          // Filter posters by selected category chip
                          final filteredCategories = _selectedCategory == null
                              ? categories
                              : categories
                                    .where(
                                      (c) =>
                                          c.toLowerCase() ==
                                          _selectedCategory!.toLowerCase(),
                                    )
                                    .toList();

                          return Column(
                            children: [
                              // Category Filter Chips
                              _buildCategoryChips(categories, padding),
                              Expanded(
                                child: _buildCategoryList(
                                  filteredCategories,
                                  filteredByLanguage, // 🔥 Pass filtered posters
                                  padding,
                                  isTablet,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              _buildLanguageDropdown(),
              // Voice search overlay
              if (_isListening) _buildVoiceSearchOverlay(),

              // Mic button
              if (_isMicButtonVisible) _buildFloatingMicButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(double padding) {
    final isDarkMode = _isDarkMode;

    return Container(
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      padding: EdgeInsets.fromLTRB(padding, 12, padding, 12),
      child: Row(children: [Expanded(child: _buildLanguageFilterButton())]),
    );
  }

  Widget _buildEmptyLanguageState() {
    final isDarkMode = _isDarkMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.translate_outlined,
                color: const Color(0xFFF5C518),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _selectedLanguage != null
                  ? 'No ${_getLanguageDisplayName(_selectedLanguage!)} templates available'
                  : 'No templates available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different language',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_selectedLanguage != null)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedLanguage = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5C518),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Clear Language Filter'),
              ),
          ],
        ),
      ),
    );
  }

  /// Horizontal scrollable category filter chips (like the image)
  Widget _buildCategoryChips(List<String> categories, double padding) {
    final isDarkMode = _isDarkMode;

    return Container(
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Row(
          children: categories.map((category) {
            final isSelected = _selectedCategory == category;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = isSelected ? null : category;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFF5C518)
                        : (isDarkMode ? const Color(0xFF0F172A) : Colors.white),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFF5C518)
                          : (isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFD1D5DB)),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFFF5C518).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    _capitalizeFirstLetter(category),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.black87
                          : (isDarkMode
                                ? Colors.white70
                                : const Color(0xFF374151)),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildVoiceSearchOverlay() {
    final isDarkMode = _isDarkMode;

    return Positioned.fill(
      child: GestureDetector(
        onTap: _stopListening,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF5C518).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ...List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 1500),
                          width: 80 + (index * 30),
                          height: 80 + (index * 30),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(
                                0xFFF5C518,
                              ).withOpacity(0.3 - (index * 0.1)),
                              width: 2,
                            ),
                          ),
                        );
                      }),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5C518),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mic,
                          color: Colors.black87,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Listening...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF1E293B)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _lastWords.isNotEmpty ? _lastWords : 'Speak now...',
                    style: TextStyle(
                      fontSize: 18,
                      color: _lastWords.isNotEmpty
                          ? const Color(0xFFF5C518)
                          : (isDarkMode ? Colors.grey[400] : Colors.grey),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tap anywhere to stop',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingMicButton(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Positioned(
      bottom: 20,
      right: 20,
      child: Consumer<MyPlanProvider>(
        builder: (context, myPlanProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              if (myPlanProvider.isPurchase == true) {
                _startListening();
              } else {
                CommonModal.showWarning(
                  context: context,
                  title: "Premium Feature",
                  message:
                      "Voice search is a premium feature. Upgrade to unlock voice commands and advanced search capabilities.",
                  primaryButtonText: "Upgrade Now",
                  secondaryButtonText: "Cancel",
                  onPrimaryPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPlansPage(),
                      ),
                    );
                  },
                  onSecondaryPressed: () => Navigator.of(context).pop(),
                );
              }
            },
            backgroundColor: const Color(0xFFF5C518),
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: const Icon(Icons.mic, size: 28),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(double padding, bool isTablet) {
    final isDarkMode = _isDarkMode;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: _showElevation
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, padding, padding, padding / 2),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
            Expanded(
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: isTablet ? 26 : 22,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ),
            // Language filter indicator
            if (_selectedLanguage != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5C518).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.translate,
                      size: 14,
                      color: Color(0xFFF5C518),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getLanguageDisplayName(_selectedLanguage!),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF5C518),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = null;
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Color(0xFFF5C518),
                      ),
                    ),
                  ],
                ),
              ),
            // Search button
            _buildSearchIconButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchIconButton() {
    final isDarkMode = _isDarkMode;

    return Consumer<MyPlanProvider>(
      builder: (context, myPlanProvider, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (myPlanProvider.isPurchase == true) {
                await _showSearchModal();
              } else {
                CommonModal.showWarning(
                  context: context,
                  title: "Premium Category",
                  message:
                      "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
                  primaryButtonText: "Upgrade Now",
                  secondaryButtonText: "Cancel",
                  onPrimaryPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPlansPage(),
                      ),
                    );
                  },
                  onSecondaryPressed: () => Navigator.of(context).pop(),
                );
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xFF334155)
                      : const Color(0xFFE5E7EB),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.search_rounded,
                size: 22,
                color: isDarkMode ? Colors.white70 : const Color(0xFF374151),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSearchModal() async {
    final isDarkMode = _isDarkMode;

    await _loadRecentSearches();

    if (!mounted) return;

    String? searchQuery = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      builder: (context) {
        final searchController = TextEditingController();
        String currentQuery = '';

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            autofocus: true,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search templates...',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[500]
                                    : const Color(0xFF6B7280),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : const Color(0xFF6B7280),
                              ),
                              suffixIcon: currentQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        searchController.clear();
                                        setModalState(() => currentQuery = '');
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF3F4F6),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) {
                              setModalState(() => currentQuery = value);
                            },
                            onSubmitted: (value) {
                              if (value.trim().isNotEmpty) {
                                Navigator.pop(context, value.trim());
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Consumer<MyPlanProvider>(
                          builder: (context, myPlanProvider, child) {
                            return Material(
                              color: const Color(0xFFF5C518),
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () {
                                  if (myPlanProvider.isPurchase == true) {
                                    Navigator.pop(context);
                                    _startListening();
                                  } else {
                                    CommonModal.showWarning(
                                      context: context,
                                      title: "Premium Feature",
                                      message:
                                          "Voice search is a premium feature. Upgrade to unlock voice commands.",
                                      primaryButtonText: "Upgrade Now",
                                      secondaryButtonText: "Cancel",
                                      onPrimaryPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SubscriptionPlansPage(),
                                          ),
                                        );
                                      },
                                      onSecondaryPressed: () =>
                                          Navigator.of(context).pop(),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: const Icon(
                                    Icons.mic,
                                    color: Colors.black87,
                                    size: 22,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_recentSearches.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Searches',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF1F2937),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await RecentSearchHelper.clearRecentSearches();
                                  await _loadRecentSearches();
                                  setModalState(() {});
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Clear All',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recentSearches.length,
                          itemBuilder: (context, index) {
                            final search = _recentSearches[index];
                            return ListTile(
                              leading: Icon(
                                Icons.history_rounded,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : const Color(0xFF6B7280),
                                size: 20,
                              ),
                              title: Text(
                                search,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF1F2937),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: isDarkMode
                                      ? Colors.grey[500]
                                      : const Color(0xFF9CA3AF),
                                ),
                                onPressed: () async {
                                  await RecentSearchHelper.removeRecentSearch(
                                    search,
                                  );
                                  await _loadRecentSearches();
                                  setModalState(() {});
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              onTap: () {
                                Navigator.pop(context, search);
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              minLeadingWidth: 0,
                            );
                          },
                        ),
                      ],
                    ),
                  if (_recentSearches.isEmpty && !_isLoadingRecent)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: isDarkMode
                                ? Colors.grey[600]
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No recent searches',
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : const Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );

    if (searchQuery != null && searchQuery.isNotEmpty && mounted) {
      await RecentSearchHelper.addRecentSearch(searchQuery);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(initialQuery: searchQuery),
        ),
      );
    }
  }

  Widget _buildCategoryList(
    List<String> categories,
    List<dynamic> posters,
    double padding,
    bool isTablet,
  ) {
    final itemWidth = isTablet ? 140.0 : 110.0;
    final itemHeight = isTablet ? 160.0 : 130.0;

    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: padding),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryPosters = _getPostersByCategory(category, posters);

        return Padding(
          padding: EdgeInsets.only(bottom: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryHeader(category, padding, isTablet),
              const SizedBox(height: 12),
              SizedBox(
                height: itemHeight + 20,
                child: _buildHorizontalPosterList(
                  categoryPosters,
                  itemWidth,
                  itemHeight,
                  padding,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(String category, double padding, bool isTablet) {
    final isDarkMode = _isDarkMode;

    return Consumer<MyPlanProvider>(
      builder: (context, myplanprovider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _capitalizeFirstLetter(category),
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 17,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (myplanprovider.isPurchase == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(category: category),
                      ),
                    );
                  } else {
                    CommonModal.showWarning(
                      context: context,
                      title: "Premium Category",
                      message:
                          "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
                      primaryButtonText: "Upgrade Now",
                      secondaryButtonText: "Cancel",
                      onPrimaryPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionPlansPage(),
                          ),
                        );
                      },
                      onSecondaryPressed: () => Navigator.of(context).pop(),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.white70
                            : const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: isDarkMode
                          ? Colors.white70
                          : const Color(0xFF1A1A1A),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showSubscriptionModal(BuildContext context) async {
    final isDarkMode = _isDarkMode;
    final myPlanProvider = Provider.of<MyPlanProvider>(context, listen: false);

    if (myPlanProvider.isPurchase == true) {
      return;
    }

    final hasShownRecently = await ModalPreferences.hasShownSubscriptionModal();
    final shouldShowAgain =
        await ModalPreferences.shouldShowSubscriptionModalAgain(daysBetween: 7);

    if (hasShownRecently && !shouldShowAgain) {
      return;
    }

    if (!mounted) return;

    final planProvider = Provider.of<GetAllPlanProvider>(
      context,
      listen: false,
    );
    if (planProvider.plans.isEmpty && !planProvider.isLoading) {
      planProvider.fetchAllPlans();
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xFF0F172A)
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFF5C518), Color(0xFFFFA500)],
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
                        color: Colors.black87,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unlock Premium',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white
                            : const Color(0xFF1F2937),
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Get unlimited access to all features',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey.shade600,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                                color: Color(0xFFF5C518),
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
                                backgroundColor: const Color(0xFFF5C518),
                                foregroundColor: Colors.black87,
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

  Widget _buildHorizontalPosterList(
    List<CategoryModel> posters,
    double itemWidth,
    double itemHeight,
    double padding,
  ) {
    final isDarkMode = _isDarkMode;

    if (posters.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? const Color(0xFF334155)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  color: isDarkMode ? Colors.grey[600] : Colors.grey.shade400,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  "No items available",
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding),
      itemCount: posters.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index == posters.length - 1 ? 0 : 12),
          child: _buildPosterCard(posters[index], itemWidth, itemHeight),
        );
      },
    );
  }

  Widget _buildPosterCard(CategoryModel poster, double width, double height) {
    final isDarkMode = _isDarkMode;

    return Consumer<MyPlanProvider>(
      builder: (context, myplanProvider, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (myplanProvider.isPurchase == true) {
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
              } else {
                CommonModal.showWarning(
                  context: context,
                  title: "Premium Category",
                  message:
                      "This section offers premium content. Unlock exclusive templates and advanced features by upgrading to a premium plan.",
                  primaryButtonText: "Upgrade Now",
                  secondaryButtonText: "Cancel",
                  onPrimaryPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPlansPage(),
                      ),
                    );
                  },
                  onSecondaryPressed: () => Navigator.of(context).pop(),
                );
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.06),
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
                        width: width,
                        height: height,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: isDarkMode
                                ? const Color(0xFF0F172A)
                                : const Color(0xFFF3F4F6),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: const Color(0xFFF5C518),
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    final isDarkMode = _isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF5C518).withOpacity(0.1),
            const Color(0xFFF5C518).withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: isDarkMode ? Colors.grey[600] : const Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  Widget _buildLoadingState(double padding, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/appstore.png',
            width: isTablet ? 200 : 150,
            height: isTablet ? 200 : 150,
          ),
          const SizedBox(height: 32),
          AmodersLoading(),
        ],
      ),
    );
  }

  Widget _buildErrorState(PosterProvider posterProvider) {
    final isDarkMode = _isDarkMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFDC2626),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load categories at this time',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => posterProvider.fetchPosters(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5C518),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Try Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = _isDarkMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.category_outlined,
                color: isDarkMode ? Colors.grey[600] : const Color(0xFF9CA3AF),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Categories Available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<String> _extractUniqueCategories(List<dynamic> posters) {
    final Set<String> categories = {};
    for (var poster in posters) {
      if (poster is CategoryModel && poster.categoryName.isNotEmpty) {
        categories.add(poster.categoryName);
      }
    }
    return categories.toList();
  }

  List<CategoryModel> _getPostersByCategory(
    String category,
    List<dynamic> allPosters,
  ) {
    return allPosters
        .where(
          (poster) =>
              poster is CategoryModel &&
              poster.categoryName.toLowerCase() == category.toLowerCase(),
        )
        .cast<CategoryModel>()
        .toList();
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }
}
