// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:posternova/views/whatsppstickers/sticker_editor_screen.dart';

// // ─── Data Models ────────────────────────────────────────────────────────────

// class StickerCategory {
//   final String id;
//   final String name;
//   final String image;
//   final int stickerCount;
//   final List<String> stickersPreview;

//   StickerCategory({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.stickerCount,
//     required this.stickersPreview,
//   });

//   factory StickerCategory.fromJson(Map<String, dynamic> json) {
//     return StickerCategory(
//       id: json['_id'],
//       name: json['name'],
//       image: json['image'],
//       stickerCount: json['stickerCount'],
//       stickersPreview: List<String>.from(json['stickersPreview']),
//     );
//   }
// }

// class StickerItem {
//   final String id;
//   final String image;
//   final String categoryId;
//   final String categoryName;

//   StickerItem({
//     required this.id,
//     required this.image,
//     required this.categoryId,
//     required this.categoryName,
//   });

//   factory StickerItem.fromJson(Map<String, dynamic> json) {
//     return StickerItem(
//       id: json['_id'],
//       image: json['image'],
//       categoryId: json['stickerCategoryId']['_id'],
//       categoryName: json['stickerCategoryId']['name'],
//     );
//   }
// }

// // ─── API Service ────────────────────────────────────────────────────────────

// class StickerApiService {
//   static const String baseUrl = 'http://31.97.206.144:4061/api';

//   Future<List<StickerCategory>> fetchCategories() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/admin/allsticker-category'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success'] == true) {
//           List<StickerCategory> categories = [];
//           for (var cat in data['categories']) {
//             categories.add(StickerCategory.fromJson(cat));
//           }
//           return categories;
//         }
//       }
//       throw Exception('Failed to load categories');
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   Future<List<StickerItem>> fetchStickersByCategory(String categoryId) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//           '$baseUrl/admin/allstickerbycat?stickerCategoryId=$categoryId',
//         ),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['success'] == true) {
//           List<StickerItem> stickers = [];
//           for (var sticker in data['stickers']) {
//             stickers.add(StickerItem.fromJson(sticker));
//           }
//           return stickers;
//         }
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }
// }

// // ─── Main Screen ─────────────────────────────────────────────────────────────

// class WhatsAppStickerScreen extends StatefulWidget {
//   const WhatsAppStickerScreen({super.key});

//   @override
//   State<WhatsAppStickerScreen> createState() => _WhatsAppStickerScreenState();
// }

// class _WhatsAppStickerScreenState extends State<WhatsAppStickerScreen> {
//   List<StickerCategory> _categories = [];
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     try {
//       final categories = await StickerApiService().fetchCategories();
//       setState(() {
//         _categories = categories;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: _buildAppBar(),
//       body: _buildBody(),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0.5,
//       leading: const BackButton(color: Colors.black),
//       title: const Text(
//         'WhatsApp Stickers',
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search, color: Colors.black),
//           onPressed: () {},
//         ),
//       ],
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
//         ),
//       );
//     }

//     if (_error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 48, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               'Error loading stickers',
//               style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _error!,
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _isLoading = true;
//                   _error = null;
//                 });
//                 _loadCategories();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFFFC107),
//                 foregroundColor: Colors.black,
//               ),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_categories.isEmpty) {
//       return const Center(
//         child: Text(
//           'No stickers available',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: _categories.length,
//       itemBuilder: (context, index) {
//         return _buildCategorySection(_categories[index]);
//       },
//     );
//   }

//   Widget _buildCategorySection(StickerCategory category) {
//     final visiblePreviews = category.stickersPreview.take(3).toList();
//     final remaining = category.stickerCount - 3;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Category Header
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFC107),
//                     shape: BoxShape.circle,
//                     image: category.image.isNotEmpty
//                         ? DecorationImage(
//                             image: NetworkImage(category.image),
//                             fit: BoxFit.fill,
//                           )
//                         : null,
//                   ),
//                   child: category.image.isEmpty
//                       ? const Icon(
//                           Icons.category,
//                           color: Colors.white,
//                           size: 22,
//                         )
//                       : null,
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         category.name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       Text(
//                         '${category.stickerCount} Stickers',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFF3E0),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: const Icon(
//                     Icons.diamond,
//                     color: Color(0xFFFF8C00),
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Sticker Preview Row
//           Padding(
//             padding: const EdgeInsets.only(left: 12, right: 12, bottom: 14),
//             child: Row(
//               children: [
//                 ...visiblePreviews.map(
//                   (preview) => Expanded(
//                     child: GestureDetector(
//                       onTap: () => _openCategoryDetail(category),
//                       child: Container(
//                         margin: const EdgeInsets.only(right: 6),
//                         height: 80,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF5F5F5),
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.network(
//                             preview,
//                             fit: BoxFit.fill,
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Center(
//                                 child: Icon(
//                                   Icons.broken_image,
//                                   color: Colors.grey,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Add placeholder if less than 3 previews
//                 ...List.generate(
//                   3 - visiblePreviews.length,
//                   (index) => Expanded(
//                     child: Container(
//                       margin: const EdgeInsets.only(right: 6),
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF5F5F5),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: const Center(
//                         child: Icon(Icons.image, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // "+X More" tile
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => _openCategoryDetail(category),
//                     child: Container(
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFFC107),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             '+$remaining',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Text(
//                             'More',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _openCategoryDetail(StickerCategory category) async {
//     // Show loading indicator
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
//         ),
//       ),
//     );

//     try {
//       final stickers = await StickerApiService().fetchStickersByCategory(
//         category.id,
//       );
//       Navigator.pop(context); // Close loading dialog

//       if (context.mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => StickerDetailScreen(
//               categoryName: category.name,
//               stickers: stickers,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       Navigator.pop(context); // Close loading dialog
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to load stickers: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
// }

// // ─── Detail Screen (Separate Screen) ─────────────────────────────────────────

// class StickerDetailScreen extends StatelessWidget {
//   final String categoryName;
//   final List<StickerItem> stickers;

//   const StickerDetailScreen({
//     super.key,
//     required this.categoryName,
//     required this.stickers,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.5,
//         leading: const BackButton(color: Colors.black),
//         title: Text(
//           categoryName,
//           style: const TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: stickers.isEmpty
//           ? const Center(
//               child: Text(
//                 'No stickers available',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             )
//           : GridView.builder(
//               padding: const EdgeInsets.all(12),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 1,
//               ),
//               itemCount: stickers.length,
//               itemBuilder: (context, index) {
//                 final sticker = stickers[index];
//                 return _buildStickerTile(sticker, context);
//               },
//             ),
//     );
//   }

//   Widget _buildStickerTile(StickerItem sticker, BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.green.shade700, width: 2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Stack(
//         children: [
//           // Dashed border effect
//           Positioned.fill(
//             child: CustomPaint(
//               painter: DashedBorderPainter(
//                 color: Colors.green.shade600,
//                 radius: 12,
//               ),
//             ),
//           ),
//           // Content
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       StickerEditorScreen(stickerUrl: sticker.image),
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         sticker.image,
//                         fit: BoxFit.fill,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(
//                             Icons.broken_image,
//                             size: 32,
//                             color: Colors.grey,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     sticker.categoryName,
//                     textAlign: TextAlign.center,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Dashed Border Painter ────────────────────────────────────────────────────

// class DashedBorderPainter extends CustomPainter {
//   final Color color;
//   final double radius;

//   DashedBorderPainter({required this.color, required this.radius});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = 1.5
//       ..style = PaintingStyle.stroke;

//     const dashWidth = 5.0;
//     const dashSpace = 4.0;
//     final path = Path()
//       ..addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
//           Radius.circular(radius),
//         ),
//       );

//     final pathMetrics = path.computeMetrics();
//     for (final metric in pathMetrics) {
//       double distance = 0;
//       while (distance < metric.length) {
//         final start = distance;
//         final end = (distance + dashWidth).clamp(0, metric.length);
//         canvas.drawPath(metric.extractPath(start, end.toDouble()), paint);
//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:posternova/views/whatsppstickers/sticker_editor_screen.dart';

// ─── Data Models ────────────────────────────────────────────────────────────

class StickerCategory {
  final String id;
  final String name;
  final String image;
  final int stickerCount;
  final List<String> stickersPreview;

  StickerCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.stickerCount,
    required this.stickersPreview,
  });

  factory StickerCategory.fromJson(Map<String, dynamic> json) {
    return StickerCategory(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      stickerCount: json['stickerCount'],
      stickersPreview: List<String>.from(json['stickersPreview']),
    );
  }
}

class StickerItem {
  final String id;
  final String image;
  final String categoryId;
  final String categoryName;

  StickerItem({
    required this.id,
    required this.image,
    required this.categoryId,
    required this.categoryName,
  });

  factory StickerItem.fromJson(Map<String, dynamic> json) {
    return StickerItem(
      id: json['_id'],
      image: json['image'],
      categoryId: json['stickerCategoryId']['_id'],
      categoryName: json['stickerCategoryId']['name'],
    );
  }
}

// ─── API Service ────────────────────────────────────────────────────────────

class StickerApiService {
  static const String baseUrl = 'http://82.29.162.67:4061/api';

  Future<List<StickerCategory>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/allsticker-category'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          List<StickerCategory> categories = [];
          for (var cat in data['categories']) {
            categories.add(StickerCategory.fromJson(cat));
          }
          return categories;
        }
      }
      throw Exception('Failed to load categories');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<StickerItem>> fetchStickersByCategory(String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/admin/allstickerbycat?stickerCategoryId=$categoryId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          List<StickerItem> stickers = [];
          for (var sticker in data['stickers']) {
            stickers.add(StickerItem.fromJson(sticker));
          }
          return stickers;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

// ─── Theme Extension for Custom Colors ─────────────────────────────────────

class AppColors {
  // Light Theme Colors
  static const lightBackground = Color(0xFFF5F5F5);
  static const lightSurface = Colors.white;
  static const lightCardShadow = Color(0x0D000000); // 5% opacity
  static const lightTextPrimary = Colors.black;
  static const lightTextSecondary = Color(0xFF757575);
  static const lightBorder = Color(0xFFE0E0E0);
  static const lightAccent = Color(0xFFFFC107);
  static const lightAccentLight = Color(0xFFFFF3E0);
  static const lightAccentDark = Color(0xFFFF8C00);
  static const lightGreenBorder = Color(0xFF2E7D32);
  static const lightGreenLight = Color(0xFFE8F5E9);

  // Dark Theme Colors
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkCardShadow = Color(0x1A000000);
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Color(0xFFB0B0B0);
  static const darkBorder = Color(0xFF333333);
  static const darkAccent = Color(0xFFFFC107);
  static const darkAccentLight = Color(0xFF332900);
  static const darkAccentDark = Color(0xFFFF8C00);
  static const darkGreenBorder = Color(0xFF81C784);
  static const darkGreenLight = Color(0xFF1B3B1F);
}

// ─── Main Screen with Theme Support ─────────────────────────────────────────

class WhatsAppStickerScreen extends StatefulWidget {
  const WhatsAppStickerScreen({super.key});

  @override
  State<WhatsAppStickerScreen> createState() => _WhatsAppStickerScreenState();
}

class _WhatsAppStickerScreenState extends State<WhatsAppStickerScreen> {
  List<StickerCategory> _categories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await StickerApiService().fetchCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: _buildAppBar(isDarkMode),
      body: _buildBody(isDarkMode),
    );
  }

  AppBar _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: isDarkMode
          ? AppColors.darkSurface
          : AppColors.lightSurface,
      elevation: 0.5,
      leading: BackButton(
        color: isDarkMode
            ? AppColors.darkTextPrimary
            : AppColors.lightTextPrimary,
      ),
      title: Text(
        'WhatsApp Stickers',
        style: TextStyle(
          color: isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody(bool isDarkMode) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.lightAccent,
          ),
          backgroundColor: isDarkMode
              ? AppColors.darkBorder
              : AppColors.lightBorder,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: isDarkMode ? Colors.red.shade400 : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading stickers',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode
                    ? AppColors.darkTextSecondary.withOpacity(0.7)
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadCategories();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_categories.isEmpty) {
      return Center(
        child: Text(
          'No stickers available',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return _buildCategorySection(_categories[index], isDarkMode);
      },
    );
  }

  Widget _buildCategorySection(StickerCategory category, bool isDarkMode) {
    final visiblePreviews = category.stickersPreview.take(3).toList();
    final remaining = category.stickerCount - 3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.darkCardShadow
                : AppColors.lightCardShadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.lightAccent,
                    shape: BoxShape.circle,
                    image: category.image.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(category.image),
                            fit: BoxFit.fill,
                          )
                        : null,
                  ),
                  child: category.image.isEmpty
                      ? Icon(
                          Icons.category,
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : Colors.white,
                          size: 22,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        '${category.stickerCount} Stickers',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkAccentLight
                        : AppColors.lightAccentLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.diamond,
                    color: isDarkMode
                        ? AppColors.darkAccentDark
                        : AppColors.lightAccentDark,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Sticker Preview Row
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 14),
            child: Row(
              children: [
                ...visiblePreviews.map(
                  (preview) => Expanded(
                    child: GestureDetector(
                      onTap: () => _openCategoryDetail(category),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        height: 80,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.darkBackground
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            preview,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Add placeholder if less than 3 previews
                ...List.generate(
                  3 - visiblePreviews.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.darkBackground
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                // "+X More" tile
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openCategoryDetail(category),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.lightAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+$remaining',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'More',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCategoryDetail(StickerCategory category) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(
            AppColors.lightAccent,
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBorder
              : AppColors.lightBorder,
        ),
      ),
    );

    try {
      final stickers = await StickerApiService().fetchStickersByCategory(
        category.id,
      );
      if (context.mounted) Navigator.pop(context); // Close loading dialog

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StickerDetailScreen(
              categoryName: category.name,
              stickers: stickers,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // Close loading dialog
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load stickers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// ─── Detail Screen with Theme Support ───────────────────────────────────────

class StickerDetailScreen extends StatelessWidget {
  final String categoryName;
  final List<StickerItem> stickers;

  const StickerDetailScreen({
    super.key,
    required this.categoryName,
    required this.stickers,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        elevation: 0.5,
        leading: BackButton(
          color: isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
        title: Text(
          categoryName,
          style: TextStyle(
            color: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: stickers.isEmpty
          ? Center(
              child: Text(
                'No stickers available',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: stickers.length,
              itemBuilder: (context, index) {
                final sticker = stickers[index];
                return _buildStickerTile(sticker, context, isDarkMode);
              },
            ),
    );
  }

  Widget _buildStickerTile(
    StickerItem sticker,
    BuildContext context,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppColors.darkGreenBorder
              : AppColors.lightGreenBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.darkCardShadow
                : AppColors.lightCardShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dashed border effect
          Positioned.fill(
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: isDarkMode
                    ? AppColors.darkGreenBorder
                    : AppColors.lightGreenBorder,
                radius: 12,
              ),
            ),
          ),
          // Content
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      StickerEditorScreen(stickerUrl: sticker.image),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        sticker.image,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.broken_image,
                            size: 32,
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sticker.categoryName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dashed Border Painter ────────────────────────────────────────────────────

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
          Radius.circular(radius),
        ),
      );

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth).clamp(0, metric.length);
        canvas.drawPath(metric.extractPath(start, end.toDouble()), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Optional: Theme Configuration for your App ─────────────────────────────

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightSurface,
    dividerColor: AppColors.lightBorder,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightAccent,
      secondary: AppColors.lightAccentDark,
      surface: AppColors.lightSurface,
      background: AppColors.lightBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightTextPrimary,
      elevation: 0.5,
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextPrimary),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkSurface,
    dividerColor: AppColors.darkBorder,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkAccent,
      secondary: AppColors.darkAccentDark,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0.5,
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
    ),
  );
}
