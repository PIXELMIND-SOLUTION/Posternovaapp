
// import 'package:flutter/material.dart';
// import 'package:posternova/models/create_poster_model.dart';
// import 'package:posternova/views/NavBar/navbar_screen.dart';

// class CreatePost extends StatefulWidget {
//   const CreatePost({super.key});

//   @override
//   State<CreatePost> createState() => _CreatePostState();
// }

// class _CreatePostState extends State<CreatePost> with TickerProviderStateMixin {
//   final List<Map<String, String>> postTypes = const [
//     {"title": "square_post", "size": "2400*2400", "icon": "square", "category": "Social"},
//     {"title": "story_post", "size": "750*1334", "icon": "portrait", "category": "Social"},
//     {"title": "cover_picture", "size": "812*312", "icon": "landscape", "category": "Cover"},
//     {"title": "display_picture", "size": "1200*1200", "icon": "account", "category": "Profile"},
//     {"title": "instagram_post", "size": "1080*1350", "icon": "instagram", "category": "Social"},
//     {"title": "youtube_thumbnail", "size": "1280*720", "icon": "video", "category": "Social"},
//     {"title": "a4_size", "size": "2480*3507", "icon": "document", "category": "Print"},
//     {"title": "certificate", "size": "850*1100", "icon": "award", "category": "Print"},
//   ];

//   String search = '';
//   String selectedFilter = 'All';
//   late AnimationController _fadeController;
//   late AnimationController _listController;
//   late Animation<double> _fadeAnimation;

//   final List<String> filters = ['All', 'Social', 'Print', 'Profile', 'Cover'];

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _listController = AnimationController(
//       duration: const Duration(milliseconds: 900),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
//     );
//     _fadeController.forward();
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (mounted) _listController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _listController.dispose();
//     super.dispose();
//   }

//   List<Map<String, String>> get filteredList {
//     final q = search.trim().toLowerCase();
//     return postTypes.where((p) {
//       final title = p['title']!.toLowerCase();
//       final category = p['category']!;
//       final fitsSearch = q.isEmpty || title.contains(q);
//       final fitsFilter = (selectedFilter == 'All') || (category == selectedFilter);
//       return fitsSearch && fitsFilter;
//     }).toList();
//   }

//   String humanizeTitle(String raw) {
//     final parts = raw.split(RegExp(r'[_\s]+'));
//     final capitalized = parts.map((p) {
//       if (p.isEmpty) return '';
//       return p[0].toUpperCase() + p.substring(1);
//     }).join(' ');
//     return capitalized.trim();
//   }

//   IconData _getIconForType(String iconType) {
//     switch (iconType) {
//       case 'square':
//         return Icons.crop_square;
//       case 'portrait':
//         return Icons.crop_portrait;
//       case 'landscape':
//         return Icons.crop_landscape;
//       case 'account':
//         return Icons.account_circle_outlined;
//       case 'instagram':
//         return Icons.photo_library_outlined;
//       case 'video':
//         return Icons.play_circle_outline;
//       case 'document':
//         return Icons.description_outlined;
//       case 'award':
//         return Icons.workspace_premium_outlined;
//       default:
//         return Icons.image_outlined;
//     }
//   }

//   Color _getColorForCategory(String category) {
//     switch (category) {
//       case 'Social':
//         return const Color(0xFF3B82F6);
//       case 'Print':
//         return const Color(0xFF10B981);
//       case 'Profile':
//         return const Color(0xFFEC4899);
//       case 'Cover':
//         return const Color(0xFFF59E0B);
//       default:
//         return const Color(0xFF6366F1);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isWide = MediaQuery.of(context).size.width > 800;
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: IconButton(
//             onPressed: () => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
//             ),
//             icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F172A)),
//           ),
//         ),
//         title: const Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Choose Canvas Size',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Color(0xFF0F172A),
//               ),
//             ),
//             SizedBox(height: 2),
//             Text(
//               'Select the perfect size for your design',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF64748B),
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.help_outline, color: Color(0xFF64748B)),
//             tooltip: 'Help',
//           ),
//         ],
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           children: [
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//               child: Column(
//                 children: [
//                   _buildSearchBar(),
//                   const SizedBox(height: 16),
//                   _buildFilterChips(),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: AnimatedBuilder(
//                 animation: _listController,
//                 builder: (context, child) {
//                   return _buildGridView(isWide);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF1F5F9),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TextField(
//         onChanged: (v) => setState(() => search = v),
//         decoration: InputDecoration(
//           hintText: 'Search sizes...',
//           hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
//           prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           suffixIcon: search.isNotEmpty
//               ? IconButton(
//                   icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
//                   onPressed: () => setState(() => search = ''),
//                 )
//               : null,
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterChips() {
//     return SizedBox(
//       height: 40,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: filters.length,
//         itemBuilder: (context, index) {
//           final filter = filters[index];
//           final isSelected = selectedFilter == filter;
//           return Padding(
//             padding: const EdgeInsets.only(right: 8),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               child: ChoiceChip(
//                 label: Text(filter),
//                 selected: isSelected,
//                 onSelected: (selected) {
//                   setState(() => selectedFilter = filter);
//                 },
//                 backgroundColor: Colors.white,
//                 selectedColor: const Color(0xFF2563EB),
//                 labelStyle: TextStyle(
//                   color: isSelected ? Colors.white : const Color(0xFF64748B),
//                   fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                   fontSize: 14,
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 elevation: isSelected ? 2 : 0,
//                 shadowColor: const Color(0xFF2563EB).withOpacity(0.3),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   side: BorderSide(
//                     color: isSelected
//                         ? const Color(0xFF2563EB)
//                         : const Color(0xFFE2E8F0),
//                     width: 1,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildGridView(bool isWide) {
//     final filtered = filteredList;
    
//     if (filtered.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.search_off,
//               size: 64,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No sizes found',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Try a different search or filter',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(16),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isWide ? 4 : 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: filtered.length,
//       itemBuilder: (context, index) {
//         final post = filtered[index];
//         final delay = index * 60;
        
//         final slideAnimation = Tween<Offset>(
//           begin: const Offset(0, 0.3),
//           end: Offset.zero,
//         ).animate(
//           CurvedAnimation(
//             parent: _listController,
//             curve: Interval(
//               (delay / 900).clamp(0.0, 1.0),
//               ((delay + 400) / 900).clamp(0.0, 1.0),
//               curve: Curves.easeOutCubic,
//             ),
//           ),
//         );

//         final fadeAnimation = Tween<double>(
//           begin: 0.0,
//           end: 1.0,
//         ).animate(
//           CurvedAnimation(
//             parent: _listController,
//             curve: Interval(
//               (delay / 900).clamp(0.0, 1.0),
//               ((delay + 400) / 900).clamp(0.0, 1.0),
//               curve: Curves.easeOut,
//             ),
//           ),
//         );

//         return SlideTransition(
//           position: slideAnimation,
//           child: FadeTransition(
//             opacity: fadeAnimation,
//             child: _buildSizeCard(post),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSizeCard(Map<String, String> post) {
//     final posterSize = PosterSize.fromMap(post);
//     final title = humanizeTitle(post['title'] ?? '');
//     final category = post['category'] ?? 'Social';
//     final categoryColor = _getColorForCategory(category);
//     final icon = _getIconForType(post['icon'] ?? 'square');

//     return GestureDetector(
//       onTap: () {
//         // Navigator.push(
//         //   context,
//         //   PageRouteBuilder(
//         //     pageBuilder: (context, animation, secondaryAnimation) =>
//         //         PosterMaker(posterSize: posterSize),
//         //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         //       final curvedAnimation = CurvedAnimation(
//         //         parent: animation,
//         //         curve: Curves.easeOutCubic,
//         //       );
//         //       return FadeTransition(
//         //         opacity: curvedAnimation,
//         //         child: ScaleTransition(
//         //           scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
//         //           child: child,
//         //         ),
//         //       );
//         //     },
//         //     transitionDuration: const Duration(milliseconds: 350),
//         //   ),
//         // );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       categoryColor.withOpacity(0.1),
//                       categoryColor.withOpacity(0.05),
//                     ],
//                   ),
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: Icon(
//                         icon,
//                         size: 48,
//                         color: categoryColor.withOpacity(0.3),
//                       ),
//                     ),
//                     Positioned(
//                       top: 12,
//                       right: 12,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: categoryColor.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           category,
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                             color: categoryColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                       color: Color(0xFF0F172A),
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.crop_free,
//                         size: 14,
//                         color: Colors.grey[500],
//                       ),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           post['size'] ?? '',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     decoration: BoxDecoration(
//                       color: categoryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Create',
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: categoryColor,
//                           ),
//                         ),
//                         const SizedBox(width: 4),
//                         Icon(
//                           Icons.arrow_forward,
//                           size: 14,
//                           color: categoryColor,
//                         ),
//                       ],
//                     ),
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









import 'package:flutter/material.dart';
import 'package:posternova/models/create_poster_model.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:posternova/views/createposter/poster_maker_screen.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> with TickerProviderStateMixin {
  final List<Map<String, String>> postTypes = const [
    {"title": "square_post", "size": "2400*2400", "icon": "square", },
    {"title": "story_post", "size": "750*1334", "icon": "portrait",},
    {"title": "cover_picture", "size": "812*312", "icon": "landscape", },
    {"title": "display_picture", "size": "1200*1200", "icon": "account",},
    {"title": "instagram_post", "size": "1080*1350", "icon": "instagram", },
    {"title": "youtube_thumbnail", "size": "1280*720", "icon": "video", },
    {"title": "a4_size", "size": "2480*3507", "icon": "document", },
    {"title": "certificate", "size": "850*1100", "icon": "award",},
  ];

  String search = '';
  late AnimationController _fadeController;
  late AnimationController _listController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _listController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredList {
    final q = search.trim().toLowerCase();
    if (q.isEmpty) return postTypes;
    return postTypes.where((p) {
      final title = p['title']!.toLowerCase();
      return title.contains(q);
    }).toList();
  }

  String humanizeTitle(String raw) {
    final parts = raw.split(RegExp(r'[_\s]+'));
    final capitalized = parts.map((p) {
      if (p.isEmpty) return '';
      return p[0].toUpperCase() + p.substring(1);
    }).join(' ');
    return capitalized.trim();
  }

  IconData _getIconForType(String iconType) {
    switch (iconType) {
      case 'square':
        return Icons.crop_square;
      case 'portrait':
        return Icons.crop_portrait;
      case 'landscape':
        return Icons.crop_landscape;
      case 'account':
        return Icons.account_circle_outlined;
      case 'instagram':
        return Icons.photo_library_outlined;
      case 'video':
        return Icons.play_circle_outline;
      case 'document':
        return Icons.description_outlined;
      case 'award':
        return Icons.workspace_premium_outlined;
      default:
        return Icons.image_outlined;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Social':
        return const Color(0xFF3B82F6);
      case 'Print':
        return const Color(0xFF10B981);
      case 'Profile':
        return const Color(0xFFEC4899);
      case 'Cover':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
            ),
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F172A)),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Canvas Size',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Select the perfect size for your design',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: Color(0xFF64748B)),
            tooltip: 'Help',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Container(
            //   color: Colors.white,
            //   padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            //   child: _buildSearchBar(),
            // ),
            Expanded(
              child: AnimatedBuilder(
                animation: _listController,
                builder: (context, child) {
                  return _buildGridView(isWide);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSearchBar() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF1F5F9),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: TextField(
  //       onChanged: (v) => setState(() => search = v),
  //       decoration: InputDecoration(
  //         hintText: 'Search sizes...',
  //         hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
  //         prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
  //         border: InputBorder.none,
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //         suffixIcon: search.isNotEmpty
  //             ? IconButton(
  //                 icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
  //                 onPressed: () => setState(() => search = ''),
  //               )
  //             : null,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGridView(bool isWide) {
    final filtered = filteredList;
    
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No sizes found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final post = filtered[index];
        final delay = index * 60;
        
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _listController,
            curve: Interval(
              (delay / 900).clamp(0.0, 1.0),
              ((delay + 400) / 900).clamp(0.0, 1.0),
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _listController,
            curve: Interval(
              (delay / 900).clamp(0.0, 1.0),
              ((delay + 400) / 900).clamp(0.0, 1.0),
              curve: Curves.easeOut,
            ),
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: _buildSizeCard(post),
          ),
        );
      },
    );
  }

  Widget _buildSizeCard(Map<String, String> post) {
    final posterSize = PosterSize.fromMap(post);
    final title = humanizeTitle(post['title'] ?? '');
    final category = post['category'] ?? 'Social';
    final categoryColor = _getColorForCategory(category);
    final icon = _getIconForType(post['icon'] ?? 'square');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PosterMaker(posterSize: posterSize),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              );
              return FadeTransition(
                opacity: curvedAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 350),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      categoryColor.withOpacity(0.1),
                      categoryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        icon,
                        size: 48,
                        color: categoryColor.withOpacity(0.3),
                      ),
                    ),
                    // Positioned(
                    //   top: 12,
                    //   right: 12,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 8,
                    //       vertical: 4,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: categoryColor.withOpacity(0.15),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //     child: Text(
                    //       category,
                    //       style: TextStyle(
                    //         fontSize: 10,
                    //         fontWeight: FontWeight.w600,
                    //         color: categoryColor,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.crop_free,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          post['size'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(vertical: 8),
                  //   decoration: BoxDecoration(
                  //     color: categoryColor.withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         'Create',
                  //         style: TextStyle(
                  //           fontSize: 13,
                  //           fontWeight: FontWeight.w600,
                  //           color: categoryColor,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 4),
                  //       Icon(
                  //         Icons.arrow_forward,
                  //         size: 14,
                  //         color: categoryColor,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}