// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:posternova/models/category_model.dart';
// import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
// import 'package:posternova/views/PosterModule/poster_making_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:permission_handler/permission_handler.dart';

// class SearchScreen extends StatefulWidget {
//   final String?initialQuery;

//   const SearchScreen({super.key,this.initialQuery});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen>
//     with TickerProviderStateMixin {
//   final searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();

//   List<CategoryModel> filteredPosters = [];
//   bool searchValue = false;
//   bool _isListening = false;
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   String _selectedSort = 'recent';

//   @override
//   void initState() {

//     super.initState();

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );
//     _scaleAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     );

//     Future.microtask(
//       () => Provider.of<PosterProvider>(context, listen: false).fetchPosters(),
//     );
//     _initSpeech();
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     _searchFocusNode.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _initSpeech() async {
//     await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'notListening') {
//           setState(() => _isListening = false);
//         }
//       },
//       onError: (error) {
//         setState(() => _isListening = false);
//         _showSnackBar(
//           'Voice recognition error',
//           Icons.error_outline,
//           Colors.red,
//         );
//       },
//     );
//   }

//   void _showSnackBar(String message, IconData icon, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   Future<bool> _requestMicPermission() async {
//     PermissionStatus status = await Permission.microphone.request();
//     return status.isGranted;
//   }

//   Future<void> _startListening() async {
//     bool hasPermission = await _requestMicPermission();

//     if (!hasPermission) {
//       _showSnackBar(
//         'Microphone permission required',
//         Icons.mic_off,
//         Colors.orange,
//       );
//       return;
//     }

//     if (!_isListening) {
//       bool available = await _speech.initialize();
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (result) {
//             if (result.finalResult) {
//               setState(() {
//                 searchController.text = result.recognizedWords;
//                 _isListening = false;
//               });
//               handleSearch(result.recognizedWords);
//             }
//           },
//           listenFor: const Duration(seconds: 30),
//           pauseFor: const Duration(seconds: 5),
//           partialResults: false,
//           cancelOnError: true,
//           listenMode: stt.ListenMode.confirmation,
//         );
//       } else {
//         _showSnackBar(
//           'Speech recognition unavailable',
//           Icons.error_outline,
//           Colors.red,
//         );
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }

//   void handleSearch(String query) {
//     final trimmedQuery = query.trim().toLowerCase();

//     if (trimmedQuery.isEmpty) {
//       setState(() {
//         searchValue = false;
//         filteredPosters = [];
//       });
//     } else {
//       final posterProvider = Provider.of<PosterProvider>(
//         context,
//         listen: false,
//       );
//       final searchResults = posterProvider.posters
//           .where((poster) {
//             if (poster is CategoryModel) {
//               return poster.categoryName.toLowerCase().contains(trimmedQuery);
//             }
//             return false;
//           })
//           .cast<CategoryModel>()
//           .toList();

//       setState(() {
//         searchValue = true;
//         filteredPosters = searchResults;
//       });
//     }
//   }

//   void _clearSearch() {
//     searchController.clear();
//     setState(() {
//       searchValue = false;
//       filteredPosters = [];
//     });
//     _searchFocusNode.unfocus();
//   }

//   // Widget _buildSearchBar() {
//   //   return Container(
//   //     margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//   //     child: Row(
//   //       children: [
//   //         Expanded(
//   //           child: Container(
//   //             height: 52,
//   //             decoration: BoxDecoration(
//   //               color: Colors.white,
//   //               borderRadius: BorderRadius.circular(16),
//   //               border: Border.all(color: Colors.grey.shade200),
//   //               boxShadow: [
//   //                 BoxShadow(
//   //                   color: Colors.black.withOpacity(0.04),
//   //                   blurRadius: 8,
//   //                   offset: const Offset(0, 2),
//   //                 ),
//   //               ],
//   //             ),
//   //             child: TextField(
//   //               controller: searchController,
//   //               focusNode: _searchFocusNode,
//   //               onChanged: handleSearch,
//   //               style: const TextStyle(
//   //                 fontSize: 15,
//   //                 fontWeight: FontWeight.w500,
//   //               ),
//   //               decoration: InputDecoration(
//   //                 hintText: 'Search templates...',
//   //                 hintStyle: TextStyle(
//   //                   color: Colors.grey.shade400,
//   //                   fontSize: 15,
//   //                   fontWeight: FontWeight.w400,
//   //                 ),
//   //                 prefixIcon: Icon(
//   //                   Icons.search,
//   //                   color: Colors.grey.shade600,
//   //                   size: 22,
//   //                 ),
//   //                 suffixIcon: searchController.text.isNotEmpty
//   //                     ? IconButton(
//   //                         icon: Icon(
//   //                           Icons.clear,
//   //                           color: Colors.grey.shade600,
//   //                           size: 20,
//   //                         ),
//   //                         onPressed: _clearSearch,
//   //                       )
//   //                     : null,
//   //                 border: InputBorder.none,
//   //                 contentPadding: const EdgeInsets.symmetric(
//   //                   horizontal: 16,
//   //                   vertical: 16,
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //         const SizedBox(width: 8),
//   //         // Material(
//   //         //   color: _isListening ? const Color(0xFF6366F1) : Colors.white,
//   //         //   borderRadius: BorderRadius.circular(16),
//   //         //   child: InkWell(
//   //         //     onTap: _startListening,
//   //         //     borderRadius: BorderRadius.circular(16),
//   //         //     child: Container(
//   //         //       height: 52,
//   //         //       width: 52,
//   //         //       decoration: BoxDecoration(
//   //         //         border: Border.all(
//   //         //           color: _isListening ? Colors.transparent : Colors.grey.shade200,
//   //         //         ),
//   //         //         borderRadius: BorderRadius.circular(16),
//   //         //         boxShadow: _isListening
//   //         //             ? [
//   //         //                 BoxShadow(
//   //         //                   color: const Color(0xFF6366F1).withOpacity(0.3),
//   //         //                   blurRadius: 12,
//   //         //                   offset: const Offset(0, 4),
//   //         //                 ),
//   //         //               ]
//   //         //             : [
//   //         //                 BoxShadow(
//   //         //                   color: Colors.black.withOpacity(0.04),
//   //         //                   blurRadius: 8,
//   //         //                   offset: const Offset(0, 2),
//   //         //                 ),
//   //         //               ],
//   //         //       ),
//   //         //       child: Icon(
//   //         //         _isListening ? Icons.mic : Icons.mic_none,
//   //         //         color: _isListening ? Colors.white : Colors.grey.shade700,
//   //         //         size: 22,
//   //         //       ),
//   //         //     ),
//   //         //   ),
//   //         // ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildSearchBar() {
//   final theme = Theme.of(context);
//   final isDarkMode = theme.brightness == Brightness.dark;
//   final textColor = isDarkMode ? Colors.white : Colors.black87;
//   final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey.shade400;
//   final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
//   final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey.shade200;
//   final iconColor = isDarkMode ? Colors.grey[400] : Colors.grey.shade600;

//   return Container(
//     margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//     child: Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 52,
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: borderColor!),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.04),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: searchController,
//               focusNode: _searchFocusNode,
//               onChanged: handleSearch,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//                 color: textColor,
//               ),
//               decoration: InputDecoration(
//                 hintText: 'Search templates...',
//                 hintStyle: TextStyle(
//                   color: hintColor,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: iconColor,
//                   size: 22,
//                 ),
//                 suffixIcon: searchController.text.isNotEmpty
//                     ? IconButton(
//                         icon: Icon(
//                           Icons.clear,
//                           color: iconColor,
//                           size: 20,
//                         ),
//                         onPressed: _clearSearch,
//                       )
//                     : null,
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 16,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//       ],
//     ),
//   );
// }

//   // Widget _buildFilterChips() {
//   //   return Container(
//   //     height: 44,
//   //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   //     child: ListView(
//   //       scrollDirection: Axis.horizontal,
//   //       children: [
//   //         // _buildChip('Recent', 'recent'),
//   //         // _buildChip('Popular', 'popular'),
//   //         // _buildChip('A-Z', 'az'),
//   //         // _buildChip('Category', 'category'),
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _buildChip(String label, String value) {
//     final isSelected = _selectedSort == value;
//     return Padding(
//       padding: const EdgeInsets.only(right: 8),
//       child: FilterChip(
//         label: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.grey.shade700,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//             fontSize: 13,
//           ),
//         ),
//         selected: isSelected,
//         onSelected: (selected) {
//           setState(() => _selectedSort = value);
//         },
//         backgroundColor: Colors.white,
//         selectedColor: const Color(0xFF6366F1),
//         side: BorderSide(
//           color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
//           width: 1,
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         showCheckmark: false,
//       ),
//     );
//   }

//   Widget _buildListeningBanner() {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       height: _isListening ? 56 : 0,
//       child: _isListening
//           ? Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     const Color(0xFF6366F1).withOpacity(0.1),
//                     const Color(0xFF8B5CF6).withOpacity(0.1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(
//                   color: const Color(0xFF6366F1).withOpacity(0.3),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF6366F1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(Icons.mic, color: Colors.white, size: 16),
//                   ),
//                   const SizedBox(width: 12),
//                   const Text(
//                     'Listening...',
//                     style: TextStyle(
//                       color: Color(0xFF6366F1),
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                   const Spacer(),
//                   SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2.5,
//                       valueColor: const AlwaysStoppedAnimation<Color>(
//                         Color(0xFF6366F1),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : const SizedBox.shrink(),
//     );
//   }

//   Widget _buildResultCard(CategoryModel poster, int index) {
//     return ScaleTransition(
//       scale: _scaleAnimation,
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SamplePosterScreen(posterId: poster.id),
//               ),
//             );
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.grey.shade200),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.04),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(16),
//                     ),
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         poster.images != null && poster.images.isNotEmpty
//                             ? Image.network(
//                                 poster.images[0],
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return _buildPlaceholder(
//                                     Icons.broken_image_outlined,
//                                   );
//                                 },
//                                 loadingBuilder:
//                                     (context, child, loadingProgress) {
//                                       if (loadingProgress == null) return child;
//                                       return Container(
//                                         color: Colors.grey.shade50,
//                                         child: Center(
//                                           child: CircularProgressIndicator(
//                                             value:
//                                                 loadingProgress
//                                                         .expectedTotalBytes !=
//                                                     null
//                                                 ? loadingProgress
//                                                           .cumulativeBytesLoaded /
//                                                       loadingProgress
//                                                           .expectedTotalBytes!
//                                                 : null,
//                                             strokeWidth: 2,
//                                             color: const Color(0xFF6366F1),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                               )
//                             : _buildPlaceholder(Icons.image_outlined),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.95),
//                               borderRadius: BorderRadius.circular(8),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 4,
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 // const Icon(Icons.category, size: 12, color: Color(0xFF6366F1)),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   '${poster.images?.length ?? 0}',
//                                   style: const TextStyle(
//                                     fontSize: 11,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF6366F1),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         poster.categoryName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                           color: Colors.black87,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'Tap to explore',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
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

//   Widget _buildPlaceholder(IconData icon) {
//     return Container(
//       color: Colors.grey.shade50,
//       child: Center(child: Icon(icon, size: 48, color: Colors.grey.shade300)),
//     );
//   }

//   Widget _buildEmptyState({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Center(
//       child: FadeTransition(
//         opacity: _scaleAnimation,
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF6366F1).withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, size: 64, color: const Color(0xFF6366F1)),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 15,
//                   color: Colors.grey.shade600,
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () => Navigator.of(context).pop(),
//           icon: const Icon(Icons.arrow_back_ios_new, size: 20),
//         ),
//         title: const Text(
//           'Search',
//           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         surfaceTintColor: Colors.transparent,
//         systemOverlayStyle: const SystemUiOverlayStyle(
//           statusBarColor: Colors.transparent,
//           statusBarIconBrightness: Brightness.dark,
//         ),
//       ),
//       body: Consumer<PosterProvider>(
//         builder: (context, posterProvider, child) {
//           if (posterProvider.isLoading && !searchValue) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     strokeWidth: 3,
//                     color: const Color(0xFF6366F1),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Loading templates...',
//                     style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (posterProvider.error != null && !searchValue) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(32),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade50,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.cloud_off,
//                         size: 64,
//                         color: Colors.red.shade400,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Connection Error',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       posterProvider.error!,
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 14,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 24),
//                     ElevatedButton.icon(
//                       onPressed: () => posterProvider.fetchPosters(),
//                       icon: const Icon(Icons.refresh, size: 20),
//                       label: const Text('Retry'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF6366F1),
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 32,
//                           vertical: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return Column(
//             children: [
//               _buildSearchBar(),
//               _buildListeningBanner(),
//               // if (searchValue) _buildFilterChips(),
//               Expanded(
//                 child: searchValue
//                     ? filteredPosters.isNotEmpty
//                           ? GridView.builder(
//                               padding: const EdgeInsets.all(16),
//                               gridDelegate:
//                                   const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     childAspectRatio: 0.75,
//                                     crossAxisSpacing: 12,
//                                     mainAxisSpacing: 12,
//                                   ),
//                               itemCount: filteredPosters.length,
//                               itemBuilder: (context, index) => _buildResultCard(
//                                 filteredPosters[index],
//                                 index,
//                               ),
//                             )
//                           : _buildEmptyState(
//                               icon: Icons.search_off,
//                               title: "No Results Found",
//                               subtitle:
//                                   "Try different keywords or check your spelling",
//                             )
//                     : _buildEmptyState(
//                         icon: Icons.travel_explore,
//                         title: "Start Searching",
//                         subtitle: "Find the perfect template for your needs",
//                       ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/views/PosterModule/poster_making_screen.dart';
import 'package:posternova/widgets/recent_search_helper.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final FocusNode _searchFocusNode = FocusNode();
  late TextEditingController _searchController;
  List<CategoryModel> filteredPosters = [];
  bool searchValue = false;
  bool _isListening = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _selectedSort = 'recent';
  List<String> _recentSearches = [];
  bool _isLoadingRecent = true;
  Timer? _speechTimer;
  bool _showRecentSearches = true;
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    Future.microtask(() {
      Provider.of<PosterProvider>(context, listen: false).fetchPosters();
      _loadRecentSearches();
    });

    _initSpeech();
    _animationController.forward();

    // If initial query is provided, perform search
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _search(widget.initialQuery!);
      });
    }
  }

  Future<void> _loadRecentSearches() async {
    setState(() => _isLoadingRecent = true);
    final searches = await RecentSearchHelper.getRecentSearches();
    setState(() {
      _recentSearches = searches;
      _searchHistory = searches; // Initialize search history
      _isLoadingRecent = false;
    });
  }

  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          _stopListening();
        }
      },
      onError: (error) {
        _stopListening();
        _showSnackBar(
          'Voice recognition error',
          Icons.error_outline,
          Colors.red,
        );
      },
    );
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _requestMicPermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (await Permission.microphone.isPermanentlyDenied) {
        _showSnackBar(
          'Microphone permission permanently denied. Please enable in settings.',
          Icons.mic_off,
          Colors.orange,
        );
      }
    }
    return status.isGranted;
  }

  Future<void> _startListening() async {
    bool hasPermission = await _requestMicPermission();

    if (!hasPermission) {
      return;
    }

    if (!_isListening) {
      setState(() {
        _isListening = true;
        _showRecentSearches = false;
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _searchController.text = result.recognizedWords;
          });

          // Start timer to stop listening after 2 seconds of silence
          _speechTimer?.cancel();
          _speechTimer = Timer(const Duration(seconds: 2), () {
            if (_isListening) {
              _stopListening();
            }
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );
    }
  }

  void _stopListening() {
    _speechTimer?.cancel();
    if (_isListening) {
      _speech.stop();
    }

    // Save search query if not empty
    final query = _searchController.text.trim();
    if (query.isNotEmpty && _isListening) {
      _saveRecentSearch(query);
      _search(query);
    }

    setState(() => _isListening = false);
  }

  void _saveRecentSearch(String query) async {
    await RecentSearchHelper.addRecentSearch(query);
    await _loadRecentSearches();
  }

  void _search(String query) {
    final trimmedQuery = query.trim().toLowerCase();

    if (trimmedQuery.isEmpty) {
      setState(() {
        searchValue = false;
        filteredPosters = [];
        _showRecentSearches = true;
      });
    } else {
      final posterProvider = Provider.of<PosterProvider>(
        context,
        listen: false,
      );
      final searchResults = posterProvider.posters
          .where((poster) {
            if (poster is CategoryModel) {
              return poster.categoryName.toLowerCase().contains(trimmedQuery) ||
                  (poster.tags != null &&
                      poster.tags!.any(
                        (tag) => tag.toLowerCase().contains(trimmedQuery),
                      ));
            }
            return false;
          })
          .cast<CategoryModel>()
          .toList();

      // Sort results
      _applySorting(searchResults);

      setState(() {
        searchValue = true;
        filteredPosters = searchResults;
        _showRecentSearches = false;
      });
    }
  }

  void _applySorting(List<CategoryModel> results) {
    switch (_selectedSort) {
      case 'recent':
        // Keep as is (already sorted by provider)
        break;
      case 'popular':
        // Sort by image count (assuming more images = more popular)
        results.sort(
          (a, b) => (b.images?.length ?? 0).compareTo(a.images?.length ?? 0),
        );
        break;
      case 'az':
        results.sort(
          (a, b) => a.categoryName.toLowerCase().compareTo(
            b.categoryName.toLowerCase(),
          ),
        );
        break;
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchValue = false;
      filteredPosters = [];
      _showRecentSearches = true;
    });
    _searchFocusNode.unfocus();
  }

  void _removeRecentSearch(String query) async {
    await RecentSearchHelper.removeRecentSearch(query);
    await _loadRecentSearches();
  }

  void _clearAllRecentSearches() async {
    await RecentSearchHelper.clearRecentSearches();
    await _loadRecentSearches();
  }

  void _selectRecentSearch(String query) {
    _searchController.text = query;
    _searchFocusNode.requestFocus();
    _saveRecentSearch(query);
    _search(query);
  }

  @override
  void dispose() {
    _speechTimer?.cancel();
    if (_isListening) {
      _speech.stop();
    }
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final hintColor = isDarkMode ? Colors.grey[400] : Colors.grey.shade400;
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey.shade200;
    final iconColor = isDarkMode ? Colors.grey[400] : Colors.grey.shade600;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    _search(value);
                    setState(() {
                      _showRecentSearches = false;
                    });
                  } else {
                    setState(() {
                      searchValue = false;
                      _showRecentSearches = true;
                    });
                  }
                },
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _saveRecentSearch(value.trim());
                  }
                },
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Search templates...',
                  hintStyle: TextStyle(
                    color: hintColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(Icons.search, color: iconColor, size: 22),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.clear, color: iconColor, size: 20),
                          onPressed: _clearSearch,
                        ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening
                              ? const Color(0xFF6366F1)
                              : iconColor,
                          size: 22,
                        ),
                        onPressed: () {
                          if (_isListening) {
                            _stopListening();
                          } else {
                            _startListening();
                          }
                        },
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: searchValue ? 44 : 0,
      child: searchValue
          ? Container(
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // _buildChip('Recent', 'recent'),
                  // _buildChip('Popular', 'popular'),
                  // _buildChip('A-Z', 'az'),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildChip(String label, String value) {
    final isSelected = _selectedSort == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSort = value;
            _applySorting(filteredPosters);
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF6366F1),
        side: BorderSide(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
          width: 1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildListeningBanner() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isListening ? 56 : 0,
      child: _isListening
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6366F1).withOpacity(0.1),
                    const Color(0xFF8B5CF6).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.mic, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _searchController.text.isNotEmpty
                          ? _searchController.text
                          : 'Listening...',
                      style: TextStyle(
                        color: const Color(0xFF6366F1),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildRecentSearches() {
    if (_isLoadingRecent) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF6366F1),
        ),
      );
    }

    if (_recentSearches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history_rounded,
        title: "No Recent Searches",
        subtitle: "Your search history will appear here",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: _clearAllRecentSearches,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Clear All', style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentSearches.length,
          itemBuilder: (context, index) {
            final search = _recentSearches[index];
            return ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ),
              title: Text(
                search,
                style: const TextStyle(fontSize: 15, color: Color(0xFF1F2937)),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close, size: 16, color: Colors.grey.shade500),
                onPressed: () => _removeRecentSearch(search),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              onTap: () => _selectRecentSearch(search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              minLeadingWidth: 0,
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget _buildPopularSearches() {
  //   final List<String> popularSearches = [
  //     'Business',
  //     'Education',
  //     'Marketing',
  //     'Social Media',
  //     'Events',
  //     'Promotion',
  //   ];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //         child: Text(
  //           'Popular Searches',
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF1F2937),
  //           ),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 20),
  //         child: Wrap(
  //           spacing: 8,
  //           runSpacing: 8,
  //           children: popularSearches.map((search) {
  //             return FilterChip(
  //               label: Text(search),
  //               onSelected: (_) => _selectRecentSearch(search),
  //               backgroundColor: Colors.white,
  //               selectedColor: const Color(0xFF6366F1),
  //               side: BorderSide(color: Colors.grey.shade300),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               labelStyle: const TextStyle(
  //                 fontSize: 13,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //     ],
  //   );
  // }

  Widget _buildResultCard(CategoryModel poster, int index) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SamplePosterScreen(posterId: poster.id),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        poster.images != null && poster.images.isNotEmpty
                            ? Image.network(
                                poster.images[0],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholder(
                                    Icons.broken_image_outlined,
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey.shade50,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                            strokeWidth: 2,
                                            color: const Color(0xFF6366F1),
                                          ),
                                        ),
                                      );
                                    },
                              )
                            : _buildPlaceholder(Icons.image_outlined),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.image,
                                  size: 12,
                                  color: Color(0xFF6366F1),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${poster.images?.length ?? 0}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poster.categoryName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (poster.tags != null && poster.tags!.isNotEmpty)
                        Text(
                          poster.tags!.take(3).join(', '),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to explore',
                        style: TextStyle(
                          fontSize: 12,
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
  }

  Widget _buildPlaceholder(IconData icon) {
    return Container(
      color: Colors.grey.shade50,
      child: Center(child: Icon(icon, size: 48, color: Colors.grey.shade300)),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: FadeTransition(
        opacity: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64, color: const Color(0xFF6366F1)),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Consumer<PosterProvider>(
        builder: (context, posterProvider, child) {
          if (posterProvider.isLoading && !searchValue) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    color: const Color(0xFF6366F1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading templates...',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          if (posterProvider.error != null && !searchValue) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_off,
                        size: 64,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Connection Error',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      posterProvider.error!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => posterProvider.fetchPosters(),
                      icon: const Icon(Icons.refresh, size: 20),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              _buildSearchBar(),
              _buildListeningBanner(),
              _buildFilterChips(),
              Expanded(
                child: searchValue
                    ? filteredPosters.isNotEmpty
                          ? GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: filteredPosters.length,
                              itemBuilder: (context, index) => _buildResultCard(
                                filteredPosters[index],
                                index,
                              ),
                            )
                          : _buildEmptyState(
                              icon: Icons.search_off,
                              title: "No Results Found",
                              subtitle:
                                  "Try different keywords or check your spelling",
                            )
                    : _showRecentSearches
                    ? SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRecentSearches(),
                            // _buildPopularSearches(),
                          ],
                        ),
                      )
                    : _buildEmptyState(
                        icon: Icons.travel_explore,
                        title: "Start Searching",
                        subtitle: "Find the perfect template for your needs",
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
