// // File: logo_making_screen.dart
// // Professional redesigned LogoMakingScreen - Modern UI
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:gal/gal.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:posternova/models/logo_model.dart';
// import 'package:posternova/providers/logo/logo_provider.dart';
// import 'package:posternova/views/logo/make_logo.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';

// class LogoMakingScreen extends StatefulWidget {
//   final String categoryId;
//   final String? userId;

//   const LogoMakingScreen({super.key, required this.categoryId, this.userId});

//   @override
//   State<LogoMakingScreen> createState() => _LogoMakingScreenState();
// }

// class _LogoMakingScreenState extends State<LogoMakingScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(
//       () => Provider.of<LogoProvider>(context, listen: false).fetchLogos(
//         logoCategoryId: widget.categoryId,
//         userId: widget.userId.toString(),
//       ),
//     );

//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text.toLowerCase();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _showLogoPreviewSheet(BuildContext context, LogoItem logo) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _LogoPreviewSheet(logo: logo),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildModernAppBar(context),
//             _buildSearchSection(context),
//             Expanded(
//               child: Consumer<LogoProvider>(
//                 builder: (context, logoProvider, _) {
//                   if (logoProvider.isLoading) return _buildLoadingState();
//                   if (logoProvider.error != null)
//                     return _buildErrorState(logoProvider);

//                   final filteredLogos = logoProvider.logos.where((logo) {
//                     return logo.name.toLowerCase().contains(_searchQuery);
//                   }).toList();

//                   if (filteredLogos.isEmpty) return _buildEmptyState(context);

//                   return _buildLogoGrid(filteredLogos);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildModernAppBar(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5F7FA),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, size: 20),
//               onPressed: () => Navigator.of(context).pop(),
//               color: const Color(0xFF2D3748),
//             ),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppText(
//                   'logo_templates',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1A202C),
//                     letterSpacing: -0.5,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 AppText(
//                   'choose_perfect_design',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Color(0xFF718096),
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchSection(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       color: Colors.white,
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xFFF5F7FA),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: _searchController.text.isNotEmpty
//                 ? const Color(0xFF667EEA)
//                 : Colors.transparent,
//             width: 2,
//           ),
//         ),
//         child: TextField(
//           controller: _searchController,
//           style: const TextStyle(fontSize: 15),
//           decoration: InputDecoration(
//             hintText: 'Search logos...',
//             hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
//             prefixIcon: const Icon(
//               Icons.search_rounded,
//               color: Color(0xFF718096),
//               size: 22,
//             ),
//             suffixIcon: _searchController.text.isNotEmpty
//                 ? IconButton(
//                     onPressed: () => _searchController.clear(),
//                     icon: const Icon(
//                       Icons.close_rounded,
//                       color: Color(0xFF718096),
//                       size: 20,
//                     ),
//                   )
//                 : null,
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 16,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLogoGrid(List<LogoItem> logos) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: GridView.builder(
//         physics: const BouncingScrollPhysics(),
//         itemCount: logos.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           childAspectRatio: 0.85,
//         ),
//         itemBuilder: (context, index) {
//           return _ModernLogoCard(
//             logo: logos[index],
//             onTap: () => _showLogoPreviewSheet(context, logos[index]),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 20,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: const CircularProgressIndicator(
//               strokeWidth: 3,
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
//             ),
//           ),
//           const SizedBox(height: 24),
//           const Text(
//             'Loading templates...',
//             style: TextStyle(
//               color: Color(0xFF718096),
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState(LogoProvider provider) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 32),
//         padding: const EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 20,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFFEE2E2),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Icon(
//                 Icons.cloud_off_rounded,
//                 size: 48,
//                 color: Color(0xFFEF4444),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Connection Error',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1A202C),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               provider.error ?? 'Unable to load logos',
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Color(0xFF718096), fontSize: 14),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => provider.fetchLogos(
//                   logoCategoryId: widget.categoryId,
//                   userId: widget.userId.toString(),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF667EEA),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: const Text(
//                   'Try Again',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 32),
//         padding: const EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 20,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5F7FA),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Icon(
//                 Icons.search_off_rounded,
//                 size: 64,
//                 color: Color(0xFFCBD5E0),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'No Logos Found',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1A202C),
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Try adjusting your search to find what you\'re looking for',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Color(0xFF718096),
//                 fontSize: 14,
//                 height: 1.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // Preview Bottom Sheet
// // ─────────────────────────────────────────────
// class _LogoPreviewSheet extends StatefulWidget {
//   final LogoItem logo;
//   const _LogoPreviewSheet({required this.logo});

//   @override
//   State<_LogoPreviewSheet> createState() => _LogoPreviewSheetState();
// }

// class _LogoPreviewSheetState extends State<_LogoPreviewSheet> {
//   bool _isDownloading = false;

//   Future<void> _downloadLogo(BuildContext context) async {
//     if (_isDownloading) return;
//     setState(() => _isDownloading = true);

//     try {
//       // Check & request gallery permission using gal
//       final hasAccess = await Gal.hasAccess(toAlbum: true);
//       if (!hasAccess) {
//         final granted = await Gal.requestAccess(toAlbum: true);
//         if (!granted) {
//           if (!mounted) return;
//           _showSnackbar(
//             context,
//             message: 'Gallery permission denied.',
//             isSuccess: false,
//           );
//           return;
//         }
//       }

//       // Download image bytes
//       final response = await http.get(Uri.parse(widget.logo.image));
//       if (response.statusCode != 200) {
//         throw Exception('Failed to download image');
//       }

//       // Write to a temp file
//       final tempDir = await getTemporaryDirectory();
//       final filePath =
//           '${tempDir.path}/logo_${widget.logo.id}_${DateTime.now().millisecondsSinceEpoch}.png';
//       final file = File(filePath);
//       await file.writeAsBytes(response.bodyBytes);

//       // Save to gallery using gal — saves into a named album
//       await Gal.putImage(filePath, album: 'Logos');

//       // Clean up temp file
//       await file.delete();

//       if (!mounted) return;
//       _showSnackbar(
//         context,
//         message: 'Logo saved to gallery!',
//         isSuccess: true,
//       );
//     } on GalException catch (e) {
//       if (!mounted) return;
//       _showSnackbar(context, message: e.type.message, isSuccess: false);
//     } catch (e) {
//       if (!mounted) return;
//       _showSnackbar(
//         context,
//         message: 'Download failed. Please try again.',
//         isSuccess: false,
//       );
//     } finally {
//       if (mounted) setState(() => _isDownloading = false);
//     }
//   }

//   void _showSnackbar(
//     BuildContext context, {
//     required String message,
//     required bool isSuccess,
//   }) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(
//               isSuccess ? Icons.check_circle : Icons.error,
//               color: Colors.white,
//               size: 20,
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(message, style: const TextStyle(fontSize: 14)),
//             ),
//           ],
//         ),
//         backgroundColor: isSuccess
//             ? const Color(0xFF48BB78)
//             : const Color(0xFFEF4444),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//       ),
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Drag handle
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: const Color(0xFFE2E8F0),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Logo name
//           Text(
//             widget.logo.name,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A202C),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Logo preview with dashed border
//           Container(
//             width: double.infinity,
//             height: 260,
//             decoration: BoxDecoration(
//               color: const Color(0xFFF9FAFB),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Stack(
//               children: [
//                 // Dashed border overlay
//                 Positioned.fill(
//                   child: CustomPaint(
//                     painter: _DashedBorderPainter(
//                       color: const Color(0xFFE2C97E),
//                       strokeWidth: 2,
//                       dashWidth: 8,
//                       dashSpace: 5,
//                       radius: 20,
//                     ),
//                   ),
//                 ),
//                 // Image
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: widget.logo.image.isNotEmpty
//                         ? Hero(
//                             tag: 'logo_${widget.logo.id}',
//                             child: Image.network(
//                               widget.logo.image,
//                               fit: BoxFit.contain,
//                               loadingBuilder:
//                                   (context, child, loadingProgress) {
//                                     if (loadingProgress == null) return child;
//                                     return const Center(
//                                       child: CircularProgressIndicator(
//                                         strokeWidth: 2,
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                               Color(0xFF667EEA),
//                                             ),
//                                       ),
//                                     );
//                                   },
//                               errorBuilder: (_, __, ___) => const Icon(
//                                 Icons.image_outlined,
//                                 size: 64,
//                                 color: Color(0xFFCBD5E0),
//                               ),
//                             ),
//                           )
//                         : const Icon(
//                             Icons.image_outlined,
//                             size: 64,
//                             color: Color(0xFFCBD5E0),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Edit + Download buttons
//           Row(
//             children: [
//               // Edit Logo
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => MakeLogo(
//                           stickerUrl: widget.logo.image,
//                           // id: widget.logo.id,
//                         ),
//                       ),
//                     );
//                   },
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: const Color(0xFF1A202C),
//                     side: const BorderSide(color: Color(0xFFE2C97E), width: 2),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: const Text(
//                     'Edit Logo',
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),

//               // Download Logo
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: _isDownloading
//                       ? null
//                       : () => _downloadLogo(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFE2C97E),
//                     foregroundColor: Colors.white,
//                     disabledBackgroundColor: const Color(
//                       0xFFE2C97E,
//                     ).withOpacity(0.7),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: _isDownloading
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Colors.white,
//                             ),
//                           ),
//                         )
//                       : const Text(
//                           'Download Logo',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),
//           const Divider(color: Color(0xFFF0F0F0)),
//           const SizedBox(height: 16),

//           // Get Original Logo files banner
//           // GestureDetector(
//           //   onTap: () {
//           //     // Handle "Know more" tap — add your navigation/URL launch logic here
//           //   },
//           //   child: Container(
//           //     decoration: BoxDecoration(
//           //       color: const Color(0xFFFFD700),
//           //       borderRadius: BorderRadius.circular(18),
//           //     ),
//           //     padding:
//           //         const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           //     child: Row(
//           //       children: [
//           //         Container(
//           //           width: 70,
//           //           height: 70,
//           //           decoration: BoxDecoration(
//           //             color: Colors.white.withOpacity(0.3),
//           //             borderRadius: BorderRadius.circular(12),
//           //           ),
//           //           child: const Icon(Icons.design_services_rounded,
//           //               size: 36, color: Colors.white),
//           //         ),
//           //         const SizedBox(width: 14),
//           //         Expanded(
//           //           child: Column(
//           //             crossAxisAlignment: CrossAxisAlignment.start,
//           //             children: [
//           //               const Text(
//           //                 'Get Original Logo files\n(CDR, PSD & PNG)',
//           //                 style: TextStyle(
//           //                   fontSize: 14,
//           //                   fontWeight: FontWeight.w700,
//           //                   color: Color(0xFF1A202C),
//           //                   height: 1.4,
//           //                 ),
//           //               ),
//           //               const SizedBox(height: 10),
//           //               Container(
//           //                 padding: const EdgeInsets.symmetric(
//           //                     horizontal: 16, vertical: 8),
//           //                 decoration: BoxDecoration(
//           //                   color: Colors.white,
//           //                   borderRadius: BorderRadius.circular(30),
//           //                 ),
//           //                 child: const Row(
//           //                   mainAxisSize: MainAxisSize.min,
//           //                   children: [
//           //                     Icon(Icons.arrow_circle_right_rounded,
//           //                         size: 18, color: Color(0xFF1A202C)),
//           //                     SizedBox(width: 6),
//           //                     Text(
//           //                       'Know more',
//           //                       style: TextStyle(
//           //                         fontSize: 13,
//           //                         fontWeight: FontWeight.w600,
//           //                         color: Color(0xFF1A202C),
//           //                       ),
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ),
//           //             ],
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // Dashed Border Painter
// // ─────────────────────────────────────────────
// class _DashedBorderPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double dashWidth;
//   final double dashSpace;
//   final double radius;

//   _DashedBorderPainter({
//     required this.color,
//     required this.strokeWidth,
//     required this.dashWidth,
//     required this.dashSpace,
//     required this.radius,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;

//     final path = Path()
//       ..addRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(0, 0, size.width, size.height),
//           Radius.circular(radius),
//         ),
//       );

//     final dashPath = Path();
//     final pathMetrics = path.computeMetrics();
//     for (final metric in pathMetrics) {
//       double distance = 0;
//       while (distance < metric.length) {
//         dashPath.addPath(
//           metric.extractPath(distance, distance + dashWidth),
//           Offset.zero,
//         );
//         distance += dashWidth + dashSpace;
//       }
//     }
//     canvas.drawPath(dashPath, paint);
//   }

//   @override
//   bool shouldRepaint(_DashedBorderPainter old) => false;
// }

// // ─────────────────────────────────────────────
// // Logo Card
// // ─────────────────────────────────────────────
// class _ModernLogoCard extends StatelessWidget {
//   final LogoItem logo;
//   final VoidCallback onTap;

//   const _ModernLogoCard({required this.logo, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
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
//                 margin: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F7FA),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: logo.image.isNotEmpty
//                       ? Hero(
//                           tag: 'logo_${logo.id}',
//                           child: Image.network(
//                             logo.image,
//                             fit: BoxFit.cover,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return Center(
//                                 child: CircularProgressIndicator(
//                                   value:
//                                       loadingProgress.expectedTotalBytes != null
//                                       ? loadingProgress.cumulativeBytesLoaded /
//                                             loadingProgress.expectedTotalBytes!
//                                       : null,
//                                   strokeWidth: 2,
//                                   valueColor:
//                                       const AlwaysStoppedAnimation<Color>(
//                                         Color(0xFF667EEA),
//                                       ),
//                                 ),
//                               );
//                             },
//                             errorBuilder: (_, __, ___) => _buildPlaceholder(),
//                           ),
//                         )
//                       : _buildPlaceholder(),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//               child: Text(
//                 logo.name,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1A202C),
//                   letterSpacing: -0.2,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPlaceholder() {
//     return Container(
//       color: const Color(0xFFF5F7FA),
//       child: const Center(
//         child: Icon(Icons.image_outlined, size: 48, color: Color(0xFFCBD5E0)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogosScreen extends StatefulWidget {
  final String userId;
  final String categoryId;

  const LogosScreen({Key? key, required this.userId, required this.categoryId})
    : super(key: key);

  @override
  State<LogosScreen> createState() => _LogosScreenState();
}

class _LogosScreenState extends State<LogosScreen> {
  List<Logo> _logos = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLogos();
  }

  Future<void> _fetchLogos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse(
        'http://82.29.162.67:4061/api/admin/getlogos/${widget.userId}?logoCategoryId=${widget.categoryId}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _logos = data.map((json) => Logo.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load logos. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchLogos, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_logos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No logos found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio:
            0.8, // Adjust this ratio based on your design preference
      ),
      itemCount: _logos.length,
      itemBuilder: (context, index) {
        final logo = _logos[index];
        return _buildLogoCard(logo);
      },
    );
  }

  Widget _buildLogoCard(Logo logo) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Handle logo tap if needed
          // You can navigate to detail screen or show a dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: ${logo.name}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  logo.previewImage,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                logo.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
}

class Logo {
  final String id;
  final String name;
  final String image;
  final String previewImage;
  final LogoCategory? logoCategory;

  Logo({
    required this.id,
    required this.name,
    required this.image,
    required this.previewImage,
    this.logoCategory,
  });

  factory Logo.fromJson(Map<String, dynamic> json) {
    return Logo(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      previewImage: json['previewImage'],
      logoCategory: json['logoCategoryId'] != null
          ? LogoCategory.fromJson(json['logoCategoryId'])
          : null,
    );
  }
}

class LogoCategory {
  final String id;
  final String name;
  final String image;

  LogoCategory({required this.id, required this.name, required this.image});

  factory LogoCategory.fromJson(Map<String, dynamic> json) {
    return LogoCategory(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
