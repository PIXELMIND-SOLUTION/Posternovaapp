// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:gal/gal.dart';
// import 'package:posternova/views/textremovalmodule/image_rect_utils.dart';
// import 'package:posternova/views/textremovalmodule/mask_generator.dart';
// import 'package:posternova/views/textremovalmodule/selection_painter.dart';
// import 'package:posternova/views/textremovalmodule/text_removal_service.dart';

// class ImageEditorScreen extends StatefulWidget {
//   const ImageEditorScreen({super.key});

//   @override
//   State<ImageEditorScreen> createState() => _ImageEditorScreenState();
// }

// class _ImageEditorScreenState extends State<ImageEditorScreen> {
//   Uint8List? _imageBytes;
//   String? _editedImageUrl;

//   Offset? _startPoint;
//   Offset? _currentPoint;
//   bool _isSelecting = false;

//   Size _originalImageSize = Size.zero;
//   Size _displayedSize = Size.zero;

//   bool _loadingAi = false;

//   // ───────────────────────────────
//   // PICK IMAGE
//   // ───────────────────────────────
//   Future<void> pickImage() async {
//     final picked =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked == null) return;

//     final bytes = await File(picked.path).readAsBytes();
//     final decoded = await decodeImageFromList(bytes);

//     setState(() {
//       _imageBytes = bytes;
//       _editedImageUrl = null;
//       _originalImageSize =
//           Size(decoded.width.toDouble(), decoded.height.toDouble());
//     });
//   }

//   // ───────────────────────────────
//   // AI ERASE
//   // ───────────────────────────────
//   Future<void> aiErase(Rect screenRect) async {
//     if (_imageBytes == null) return;

//     try {
//       setState(() => _loadingAi = true);

//       final renderRect = ImageRectUtils.getImageRenderRect(
//         imageSize: _originalImageSize,
//         containerSize: _displayedSize,
//       );

//       final imageRect = ImageRectUtils.scaleRectToImage(
//         screenRect: screenRect,
//         imageRect: renderRect,
//         imageSize: _originalImageSize,
//       );

//       final decoded = img.decodeImage(_imageBytes!)!;

//       final mask = MaskGenerator.generateMask(
//         decoded.width,
//         decoded.height,
//         imageRect,
//       );

//       final imageUrl = await AiTextRemovalService.removeText(
//         userId: "68e7464a4573bb20b31ea1de",
//         image: _imageBytes!,
//         mask: mask,
//       );

//       setState(() {
//         _editedImageUrl = imageUrl;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("AI erase failed: $e")),
//       );
//     } finally {
//       setState(() => _loadingAi = false);
//     }
//   }

//   // ───────────────────────────────
//   // SAVE IMAGE
//   // ───────────────────────────────
//   Future<void> saveImage() async {
//     if (_editedImageUrl == null) return;

//     await Gal.putImage(
//       _editedImageUrl!,
//       album: 'AI Image Editor',
//     );

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Image saved to gallery")),
//     );
//   }

//   // ───────────────────────────────
//   // RESET
//   // ───────────────────────────────
//   void resetEditor() {
//     setState(() {
//       _imageBytes = null;
//       _editedImageUrl = null;
//       _startPoint = null;
//       _currentPoint = null;
//       _isSelecting = false;
//       _originalImageSize = Size.zero;
//       _displayedSize = Size.zero;
//     });
//   }

//   // ───────────────────────────────
//   // UI
//   // ───────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("AI Image Editor"),
//         actions: [
//           if (_editedImageUrl != null)
//             IconButton(
//               icon: const Icon(Icons.save),
//               onPressed: saveImage,
//             ),
//           if (_imageBytes != null)
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: resetEditor,
//             ),
//         ],
//       ),
//       body: _imageBytes == null
//           ? Center(
//               child: ElevatedButton(
//                 onPressed: pickImage,
//                 child: const Text("Pick Image"),
//               ),
//             )
//           : LayoutBuilder(
//               builder: (context, constraints) {
//                 _displayedSize = Size(
//                   constraints.maxWidth,
//                   constraints.maxHeight,
//                 );

//                 return Stack(
//                   children: [
//                     GestureDetector(
//                       onPanStart: (d) {
//                         if (_editedImageUrl != null) return;
//                         setState(() {
//                           _startPoint = d.localPosition;
//                           _currentPoint = d.localPosition;
//                           _isSelecting = true;
//                         });
//                       },
//                       onPanUpdate: (d) {
//                         if (_editedImageUrl != null) return;
//                         setState(() {
//                           _currentPoint = d.localPosition;
//                         });
//                       },
//                       onPanEnd: (_) async {
//                         if (_editedImageUrl != null) return;

//                         setState(() => _isSelecting = false);

//                         if (_startPoint == null ||
//                             _currentPoint == null) return;

//                         final rect = Rect.fromPoints(
//                           _startPoint!,
//                           _currentPoint!,
//                         );

//                         _startPoint = null;
//                         _currentPoint = null;

//                         await aiErase(rect);
//                       },
//                       child: _editedImageUrl != null
//                           ? Image.network(
//                               _editedImageUrl!,
//                               width: constraints.maxWidth,
//                               height: constraints.maxHeight,
//                               fit: BoxFit.contain,
//                             )
//                           : Image.memory(
//                               _imageBytes!,
//                               width: constraints.maxWidth,
//                               height: constraints.maxHeight,
//                               fit: BoxFit.contain,
//                             ),
//                     ),

//                     if (_isSelecting &&
//                         _startPoint != null &&
//                         _currentPoint != null)
//                       CustomPaint(
//                         painter: SelectionPainter(
//                           _startPoint!,
//                           _currentPoint!,
//                         ),
//                         size: _displayedSize,
//                       ),

//                     if (_loadingAi)
//                       Container(
//                         color: Colors.black45,
//                         child: const Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                   ],
//                 );
//               },
//             ),
//     );
//   }
// }

// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:gal/gal.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/views/textremovalmodule/image_rect_utils.dart';
// import 'package:posternova/views/textremovalmodule/mask_generator.dart';
// import 'package:posternova/views/textremovalmodule/selection_painter.dart';
// import 'package:posternova/views/textremovalmodule/text_removal_service.dart';

// class ImageEditorScreen extends StatefulWidget {
//   const ImageEditorScreen({super.key});

//   @override
//   State<ImageEditorScreen> createState() => _ImageEditorScreenState();
// }

// class _ImageEditorScreenState extends State<ImageEditorScreen> with SingleTickerProviderStateMixin {
//   Uint8List? _imageBytes;
//   String? _editedImageUrl;
//   Offset? _startPoint;
//   Offset? _currentPoint;
//   bool _isSelecting = false;
//   Size _originalImageSize = Size.zero;
//   Size _displayedSize = Size.zero;
//   bool _loadingAi = false;
//   String? _userId;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   // Load userId from AuthPreferences
//   Future<void> _loadUserId() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData != null) {
//         setState(() {
//           _userId = userData.user.id;
//         });
//       } else {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("User not logged in"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error loading user data: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // Pick image from gallery
//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 100,
//     );
//     if (picked == null) return;

//     final bytes = await File(picked.path).readAsBytes();
//     final decoded = await decodeImageFromList(bytes);

//     setState(() {
//       _imageBytes = bytes;
//       _editedImageUrl = null;
//       _originalImageSize = Size(
//         decoded.width.toDouble(),
//         decoded.height.toDouble(),
//       );
//       _startPoint = null;
//       _currentPoint = null;
//     });

//     _animationController.forward(from: 0);
//   }

//   // AI erase functionality
//   Future<void> aiErase(Rect screenRect) async {
//     if (_imageBytes == null) return;

//     if (_userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("User ID not available. Please log in again."),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     try {
//       setState(() => _loadingAi = true);

//       final renderRect = ImageRectUtils.getImageRenderRect(
//         imageSize: _originalImageSize,
//         containerSize: _displayedSize,
//       );

//       final imageRect = ImageRectUtils.scaleRectToImage(
//         screenRect: screenRect,
//         imageRect: renderRect,
//         imageSize: _originalImageSize,
//       );

//       final decoded = img.decodeImage(_imageBytes!)!;
//       final mask = MaskGenerator.generateMask(
//         decoded.width,
//         decoded.height,
//         imageRect,
//       );

//       final imageUrl = await AiTextRemovalService.removeText(
//         userId: _userId!,
//         image: _imageBytes!,
//         mask: mask,
//       );

//       setState(() {
//         _editedImageUrl = imageUrl;
//       });

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.check_circle, color: Colors.white),
//               SizedBox(width: 8),
//               Text("Text removed successfully!"),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               const Icon(Icons.error_outline, color: Colors.white),
//               const SizedBox(width: 8),
//               Expanded(child: Text("AI erase failed: $e")),
//             ],
//           ),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } finally {
//       setState(() => _loadingAi = false);
//     }
//   }

//   Future<void> saveImage() async {
//   if (_editedImageUrl == null) return;

//   try {
//     // Show loading indicator
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Row(
//           children: [
//             SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//             SizedBox(width: 12),
//             Text("Downloading image..."),
//           ],
//         ),
//         backgroundColor: Colors.blue,
//         behavior: SnackBarBehavior.floating,
//         duration: Duration(seconds: 2),
//       ),
//     );

//     // Download the image from URL
//     final response = await http.get(Uri.parse(_editedImageUrl!));

//     if (response.statusCode != 200) {
//       throw Exception('Failed to download image');
//     }

//     // Get temporary directory
//     final tempDir = await getTemporaryDirectory();
//     final timestamp = DateTime.now().millisecondsSinceEpoch;
//     final filePath = '${tempDir.path}/posternova_$timestamp.png';

//     // Save to temporary file
//     final file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);

//     // Save to gallery using the local file path
//     await Gal.putImage(
//       filePath,
//       album: 'PosterNova',
//     );

//     // Clean up temporary file
//     await file.delete();

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.download_done, color: Colors.white),
//             SizedBox(width: 8),
//             Text("Image saved to gallery"),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   } catch (e) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Failed to save image: $e"),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }
// }

//   // Reset editor
//   void resetEditor() {
//     setState(() {
//       _imageBytes = null;
//       _editedImageUrl = null;
//       _startPoint = null;
//       _currentPoint = null;
//       _isSelecting = false;
//       _originalImageSize = Size.zero;
//       _displayedSize = Size.zero;
//     });
//     _animationController.reverse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1a1a2e),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFF16213e),
//         title: const Text(
//           "Text Remover",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           if (_editedImageUrl != null)
//             Container(
//               margin: const EdgeInsets.only(right: 8),
//               child: IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.download_rounded,
//                     color: Colors.greenAccent,
//                   ),
//                 ),
//                 onPressed: saveImage,
//                 tooltip: "Save Image",
//               ),
//             ),
//           if (_imageBytes != null)
//             Container(
//               margin: const EdgeInsets.only(right: 12),
//               child: IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.refresh_rounded,
//                     color: Colors.orangeAccent,
//                   ),
//                 ),
//                 onPressed: resetEditor,
//                 tooltip: "Reset",
//               ),
//             ),
//         ],
//       ),
//       body: _imageBytes == null ? _buildEmptyState() : _buildImageEditor(),
//     );
//   }

//   // Empty state when no image is selected
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.purple.shade400,
//                   Colors.blue.shade400,
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.purple.withOpacity(0.3),
//                   blurRadius: 30,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.auto_fix_high_rounded,
//               size: 60,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 32),
//           const Text(
//             "Text Remover",
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 12),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 48),
//             child: Text(
//               "Remove unwanted text from your images with AI precision",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white70,
//                 height: 1.5,
//               ),
//             ),
//           ),
//           const SizedBox(height: 48),
//           ElevatedButton.icon(
//             onPressed: pickImage,
//             icon: const Icon(Icons.add_photo_alternate_outlined, size: 24),
//             label: const Text(
//               "Select Image",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple.shade600,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 32,
//                 vertical: 16,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 8,
//               shadowColor: Colors.purple.withOpacity(0.5),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Image editor interface
//   Widget _buildImageEditor() {
//     return Column(
//       children: [
//         // Instructions banner
//         if (_editedImageUrl == null)
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blue.shade700.withOpacity(0.8),
//                   Colors.purple.shade700.withOpacity(0.8),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue.withOpacity(0.3),
//                   blurRadius: 15,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: const Row(
//               children: [
//                 Icon(
//                   Icons.touch_app_rounded,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Drag to select text area you want to remove",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         // Image display area
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   _displayedSize = Size(
//                     constraints.maxWidth,
//                     constraints.maxHeight,
//                   );

//                   return Stack(
//                     children: [
//                       // Background gradient
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.grey.shade900,
//                               Colors.grey.shade800,
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
//                       ),

//                       // Image with gesture detector
//                       GestureDetector(
//                         onPanStart: (d) {
//                           if (_editedImageUrl != null) return;
//                           setState(() {
//                             _startPoint = d.localPosition;
//                             _currentPoint = d.localPosition;
//                             _isSelecting = true;
//                           });
//                         },
//                         onPanUpdate: (d) {
//                           if (_editedImageUrl != null) return;
//                           setState(() {
//                             _currentPoint = d.localPosition;
//                           });
//                         },
//                         onPanEnd: (_) async {
//                           if (_editedImageUrl != null) return;
//                           setState(() => _isSelecting = false);

//                           if (_startPoint == null || _currentPoint == null) {
//                             return;
//                           }

//                           final rect = Rect.fromPoints(
//                             _startPoint!,
//                             _currentPoint!,
//                           );

//                           _startPoint = null;
//                           _currentPoint = null;

//                           await aiErase(rect);
//                         },
//                         child: FadeTransition(
//                           opacity: _fadeAnimation,
//                           child: _editedImageUrl != null
//                               ? Image.network(
//                                   _editedImageUrl!,
//                                   width: constraints.maxWidth,
//                                   height: constraints.maxHeight,
//                                   fit: BoxFit.contain,
//                                   loadingBuilder: (context, child, progress) {
//                                     if (progress == null) return child;
//                                     return Center(
//                                       child: CircularProgressIndicator(
//                                         value: progress.expectedTotalBytes != null
//                                             ? progress.cumulativeBytesLoaded /
//                                                 progress.expectedTotalBytes!
//                                             : null,
//                                         color: Colors.purple,
//                                       ),
//                                     );
//                                   },
//                                 )
//                               : Image.memory(
//                                   _imageBytes!,
//                                   width: constraints.maxWidth,
//                                   height: constraints.maxHeight,
//                                   fit: BoxFit.contain,
//                                 ),
//                         ),
//                       ),

//                       // Selection rectangle
//                       if (_isSelecting &&
//                           _startPoint != null &&
//                           _currentPoint != null)
//                         CustomPaint(
//                           painter: SelectionPainter(
//                             _startPoint!,
//                             _currentPoint!,
//                           ),
//                           size: _displayedSize,
//                         ),

//                       // Loading overlay
//                       if (_loadingAi)
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black87,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 SizedBox(
//                                   width: 80,
//                                   height: 80,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 6,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.purple.shade400,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 const Text(
//                                   "AI is working...",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 const Text(
//                                   "Removing text from image",
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),

//         // Bottom action button
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: ElevatedButton.icon(
//             onPressed: pickImage,
//             icon: const Icon(Icons.photo_library_rounded, size: 24),
//             label: const Text(
//               "Choose Another Image",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF0f3460),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//                 vertical: 14,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               elevation: 4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }





// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:gal/gal.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/views/textremovalmodule/image_rect_utils.dart';
// import 'package:posternova/views/textremovalmodule/mask_generator.dart';
// import 'package:posternova/views/textremovalmodule/selection_painter.dart';
// import 'package:posternova/views/textremovalmodule/text_removal_service.dart';

// // Model for text overlay
// class TextOverlay {
//   String text;
//   Offset position;
//   double fontSize;
//   Color color;
//   String fontFamily;
//   FontWeight fontWeight;
//   bool isSelected;

//   TextOverlay({
//     required this.text,
//     required this.position,
//     this.fontSize = 24,
//     this.color = Colors.white,
//     this.fontFamily = 'Roboto',
//     this.fontWeight = FontWeight.bold,
//     this.isSelected = false,
//   });
// }

// class ImageEditorScreen extends StatefulWidget {
//   const ImageEditorScreen({super.key});

//   @override
//   State<ImageEditorScreen> createState() => _ImageEditorScreenState();
// }

// class _ImageEditorScreenState extends State<ImageEditorScreen>
//     with SingleTickerProviderStateMixin {
//   Uint8List? _imageBytes;
//   String? _editedImageUrl;
//   Offset? _startPoint;
//   Offset? _currentPoint;
//   bool _isSelecting = false;
//   Size _originalImageSize = Size.zero;
//   Size _displayedSize = Size.zero;
//   bool _loadingAi = false;
//   String? _userId;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   // Text overlay properties
//   List<TextOverlay> _textOverlays = [];
//   int? _selectedTextIndex;
//   bool _isTextMode = false;
//   Offset? _dragStartPosition;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadUserId() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData != null) {
//         setState(() {
//           _userId = userData.user.id;
//         });
//       } else {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("User not logged in"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Error loading user data: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 100,
//     );
//     if (picked == null) return;

//     final bytes = await File(picked.path).readAsBytes();
//     final decoded = await decodeImageFromList(bytes);

//     setState(() {
//       _imageBytes = bytes;
//       _editedImageUrl = null;
//       _originalImageSize = Size(
//         decoded.width.toDouble(),
//         decoded.height.toDouble(),
//       );
//       _startPoint = null;
//       _currentPoint = null;
//       _textOverlays.clear();
//       _selectedTextIndex = null;
//       _isTextMode = false;
//     });

//     _animationController.forward(from: 0);
//   }

//   void _editTextDialog(int index) {
//     final controller = TextEditingController(text: _textOverlays[index].text);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF16213e),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text("Edit Text", style: TextStyle(color: Colors.white)),
//         content: TextField(
//           controller: controller,
//           autofocus: true,
//           maxLines: null,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             hintText: "Edit your text",
//             hintStyle: TextStyle(color: Colors.white54),
//             filled: true,
//             fillColor: Colors.white.withOpacity(0.1),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               "Cancel",
//               style: TextStyle(color: Colors.white70),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _textOverlays[index].text = controller.text.trim();
//               });
//               Navigator.pop(context);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple.shade600,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   // Future<void> aiErase(Rect screenRect) async {
//   //   if (_imageBytes == null) return;

//   //   if (_userId == null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text("User ID not available. Please log in again."),
//   //         backgroundColor: Colors.orange,
//   //       ),
//   //     );
//   //     return;
//   //   }

//   //   try {
//   //     setState(() => _loadingAi = true);

//   //     final renderRect = ImageRectUtils.getImageRenderRect(
//   //       imageSize: _originalImageSize,
//   //       containerSize: _displayedSize,
//   //     );

//   //     final imageRect = ImageRectUtils.scaleRectToImage(
//   //       screenRect: screenRect,
//   //       imageRect: renderRect,
//   //       imageSize: _originalImageSize,
//   //     );

//   //     final decoded = img.decodeImage(_imageBytes!)!;
//   //     final mask = MaskGenerator.generateMask(
//   //       decoded.width,
//   //       decoded.height,
//   //       imageRect,
//   //     );

//   //     final imageUrl = await AiTextRemovalService.removeText(
//   //       userId: _userId!,
//   //       image: _imageBytes!,
//   //       mask: mask,
//   //     );

//   //     setState(() {
//   //       _editedImageUrl = imageUrl;
//   //     });

//   //     if (!mounted) return;
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Row(
//   //           children: [
//   //             Icon(Icons.check_circle, color: Colors.white),
//   //             SizedBox(width: 8),
//   //             Text("Text removed successfully!"),
//   //           ],
//   //         ),
//   //         backgroundColor: Colors.green,
//   //         behavior: SnackBarBehavior.floating,
//   //       ),
//   //     );
//   //   } catch (e) {
//   //     if (!mounted) return;
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Row(
//   //           children: [
//   //             const Icon(Icons.error_outline, color: Colors.white),
//   //             const SizedBox(width: 8),
//   //             Expanded(child: Text("AI erase failed: $e")),
//   //           ],
//   //         ),
//   //         backgroundColor: Colors.red,
//   //         behavior: SnackBarBehavior.floating,
//   //       ),
//   //     );
//   //   } finally {
//   //     setState(() => _loadingAi = false);
//   //   }
//   // }


//   Future<void> aiErase(Rect screenRect) async {
//   if (_imageBytes == null) return;

//   if (_userId == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("User ID not available. Please log in again."),
//         backgroundColor: Colors.orange,
//       ),
//     );
//     return;
//   }

//   try {
//     setState(() => _loadingAi = true);

//     // Get the render rect (where image is actually displayed)
//     final renderRect = ImageRectUtils.getImageRenderRect(
//       imageSize: _originalImageSize,
//       containerSize: _displayedSize,
//     );

//     // Normalize the selection rect (ensure top-left to bottom-right)
//     final normalizedScreenRect = Rect.fromLTRB(
//       screenRect.left < screenRect.right ? screenRect.left : screenRect.right,
//       screenRect.top < screenRect.bottom ? screenRect.top : screenRect.bottom,
//       screenRect.left < screenRect.right ? screenRect.right : screenRect.left,
//       screenRect.top < screenRect.bottom ? screenRect.bottom : screenRect.top,
//     );

//     // Check if selection is within image bounds
//     final intersectedRect = normalizedScreenRect.intersect(renderRect);
    
//     if (intersectedRect.isEmpty) {
//       throw Exception('Selection is outside the image area');
//     }

//     // Scale the intersected rect to image coordinates
//     final imageRect = ImageRectUtils.scaleRectToImage(
//       screenRect: intersectedRect,
//       imageRect: renderRect,
//       imageSize: _originalImageSize,
//     );

//     // Ensure the rect is within image bounds
//     final clampedImageRect = Rect.fromLTRB(
//       imageRect.left.clamp(0, _originalImageSize.width),
//       imageRect.top.clamp(0, _originalImageSize.height),
//       imageRect.right.clamp(0, _originalImageSize.width),
//       imageRect.bottom.clamp(0, _originalImageSize.height),
//     );

//     print('Screen rect: $normalizedScreenRect');
//     print('Render rect: $renderRect');
//     print('Image rect: $clampedImageRect');
//     print('Image size: $_originalImageSize');

//     final decoded = img.decodeImage(_imageBytes!)!;

//     // Generate mask ONLY for the selected area
//     final mask = MaskGenerator.generateMask(
//       decoded.width,
//       decoded.height,
//       clampedImageRect,
//     );

//     final imageUrl = await AiTextRemovalService.removeText(
//       userId: _userId!,
//       image: _imageBytes!,
//       mask: mask,
//     );

//     setState(() {
//       _editedImageUrl = imageUrl;
//     });

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.white),
//             SizedBox(width: 8),
//             Text("Text removed successfully!"),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   } catch (e) {
//     print('AI Erase Error: $e');
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 8),
//             Expanded(child: Text("AI erase failed: $e")),
//           ],
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   } finally {
//     setState(() => _loadingAi = false);
//   }
// }

//   // Add text overlay
//   void _addTextOverlay() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String textInput = '';
//         return AlertDialog(
//           backgroundColor: const Color(0xFF16213e),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text(
//             'Add Text',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           content: TextField(
//             autofocus: true,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: 'Enter text...',
//               hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
//               filled: true,
//               fillColor: Colors.white.withOpacity(0.1),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//             onChanged: (value) {
//               textInput = value;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.white70),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (textInput.trim().isNotEmpty) {
//                   setState(() {
//                     _textOverlays.add(
//                       TextOverlay(
//                         text: textInput,
//                         position: Offset(
//                           _displayedSize.width / 2 - 50,
//                           _displayedSize.height / 2 - 20,
//                         ),
//                       ),
//                     );
//                   });
//                   Navigator.pop(context);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.purple.shade600,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child:  Text('Add',style: TextStyle(color: Colors.white),),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Show text editing options
//   void _showTextOptions(int index) {
//     final overlay = _textOverlays[index];

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF16213e),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             return Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Text(
//                     'Text Options',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Font size slider
//                   Row(
//                     children: [
//                       const Icon(Icons.format_size, color: Colors.white70),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Slider(
//                           value: overlay.fontSize,
//                           min: 12,
//                           max: 72,
//                           divisions: 60,
//                           activeColor: Colors.purple.shade400,
//                           label: overlay.fontSize.round().toString(),
//                           onChanged: (value) {
//                             setModalState(() {
//                               overlay.fontSize = value;
//                             });
//                             setState(() {});
//                           },
//                         ),
//                       ),
//                     ],
//                   ),

//                   // Color picker
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       const Icon(Icons.color_lens, color: Colors.white70),
//                       const SizedBox(width: 10),
//                       const Text(
//                         'Color:',
//                         style: TextStyle(color: Colors.white70),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Wrap(
//                           spacing: 8,
//                           children:
//                               [
//                                 Colors.white,
//                                 Colors.black,
//                                 Colors.red,
//                                 Colors.blue,
//                                 Colors.green,
//                                 Colors.yellow,
//                                 Colors.purple,
//                                 Colors.orange,
//                               ].map((color) {
//                                 return GestureDetector(
//                                   onTap: () {
//                                     setModalState(() {
//                                       overlay.color = color;
//                                     });
//                                     setState(() {});
//                                   },
//                                   child: Container(
//                                     width: 32,
//                                     height: 32,
//                                     decoration: BoxDecoration(
//                                       color: color,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                         color: overlay.color == color
//                                             ? Colors.purple.shade400
//                                             : Colors.white24,
//                                         width: overlay.color == color ? 3 : 1,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Delete button
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         _textOverlays.removeAt(index);
//                         _selectedTextIndex = null;
//                       });
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(Icons.delete),
//                     label: const Text('Delete Text'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red.shade600,
//                       minimumSize: const Size(double.infinity, 48),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> saveImage() async {
//     if (_editedImageUrl == null && _imageBytes == null) return;

//     try {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Row(
//             children: [
//               SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               ),
//               SizedBox(width: 12),
//               Text("Preparing image..."),
//             ],
//           ),
//           backgroundColor: Colors.blue,
//           behavior: SnackBarBehavior.floating,
//           duration: Duration(seconds: 2),
//         ),
//       );

//       Uint8List imageBytes;

//       if (_editedImageUrl != null) {
//         final response = await http.get(Uri.parse(_editedImageUrl!));
//         if (response.statusCode != 200) {
//           throw Exception('Failed to download image');
//         }
//         imageBytes = response.bodyBytes;
//       } else {
//         imageBytes = _imageBytes!;
//       }

//       // If there are text overlays, render them on the image
//       if (_textOverlays.isNotEmpty) {
//         imageBytes = await _renderTextOnImage(imageBytes);
//       }

//       final tempDir = await getTemporaryDirectory();
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final filePath = '${tempDir.path}/posternova_$timestamp.png';

//       final file = File(filePath);
//       await file.writeAsBytes(imageBytes);

//       await Gal.putImage(filePath, album: 'PosterNova');

//       await file.delete();

//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Row(
//             children: [
//               Icon(Icons.download_done, color: Colors.white),
//               SizedBox(width: 8),
//               Text("Image saved to gallery"),
//             ],
//           ),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Failed to save image: $e"),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   // Render text overlays on image
//   Future<Uint8List> _renderTextOnImage(Uint8List imageBytes) async {
//     final image = await decodeImageFromList(imageBytes);
//     final recorder = PictureRecorder();
//     final canvas = Canvas(recorder);

//     // Draw the original image
//     final imageCodec = await instantiateImageCodec(imageBytes);
//     final frame = await imageCodec.getNextFrame();
//     canvas.drawImage(frame.image, Offset.zero, Paint());

//     // Calculate scale factor
//     final renderRect = ImageRectUtils.getImageRenderRect(
//       imageSize: _originalImageSize,
//       containerSize: _displayedSize,
//     );
//     final scaleX = _originalImageSize.width / renderRect.width;
//     final scaleY = _originalImageSize.height / renderRect.height;

//     // Draw text overlays
//     for (final overlay in _textOverlays) {
//       final textPainter = TextPainter(
//         text: TextSpan(
//           text: overlay.text,
//           style: TextStyle(
//             fontSize: overlay.fontSize * scaleX,
//             color: overlay.color,
//             fontWeight: overlay.fontWeight,
//             fontFamily: overlay.fontFamily,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       );
//       textPainter.layout();

//       final scaledPosition = Offset(
//         (overlay.position.dx - renderRect.left) * scaleX,
//         (overlay.position.dy - renderRect.top) * scaleY,
//       );

//       textPainter.paint(canvas, scaledPosition);
//     }

//     final picture = recorder.endRecording();
//     final finalImage = await picture.toImage(image.width, image.height);
//     final byteData = await finalImage.toByteData(format: ImageByteFormat.png);

//     return byteData!.buffer.asUint8List();
//   }

//   void resetEditor() {
//     setState(() {
//       _imageBytes = null;
//       _editedImageUrl = null;
//       _startPoint = null;
//       _currentPoint = null;
//       _isSelecting = false;
//       _originalImageSize = Size.zero;
//       _displayedSize = Size.zero;
//       _textOverlays.clear();
//       _selectedTextIndex = null;
//       _isTextMode = false;
//     });
//     _animationController.reverse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1a1a2e),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFF16213e),
//         title: const Text(
//           "Text Remover",
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         centerTitle: true,
//         actions: [
//           if (_imageBytes != null)
//             Container(
//               margin: const EdgeInsets.only(right: 8),
//               child: IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: _isTextMode
//                         ? Colors.blue.withOpacity(0.3)
//                         : Colors.blue.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     Icons.text_fields,
//                     color: _isTextMode
//                         ? Colors.blueAccent
//                         : Colors.blue.shade300,
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _isTextMode = !_isTextMode;
//                     _selectedTextIndex = null;
//                   });
//                 },
//                 tooltip: "Text Mode",
//               ),
//             ),
//           if (_imageBytes != null || _editedImageUrl != null)
//             Container(
//               margin: const EdgeInsets.only(right: 8),
//               child: IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.download_rounded,
//                     color: Colors.greenAccent,
//                   ),
//                 ),
//                 onPressed: saveImage,
//                 tooltip: "Save Image",
//               ),
//             ),
//           if (_imageBytes != null)
//             Container(
//               margin: const EdgeInsets.only(right: 12),
//               child: IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.refresh_rounded,
//                     color: Colors.orangeAccent,
//                   ),
//                 ),
//                 onPressed: resetEditor,
//                 tooltip: "Reset",
//               ),
//             ),
//         ],
//       ),
//       body: _imageBytes == null ? _buildEmptyState() : _buildImageEditor(),
//       floatingActionButton: _imageBytes != null && _isTextMode
//           ? FloatingActionButton.extended(
//               onPressed: _addTextOverlay,
//               backgroundColor: Colors.purple.shade600,
//               icon: const Icon(Icons.add),
//               label: Text('Add Text', style: TextStyle(color: Colors.white)),
//             )
//           : null,
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.purple.shade400, Colors.blue.shade400],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.purple.withOpacity(0.3),
//                   blurRadius: 30,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.auto_fix_high_rounded,
//               size: 60,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 32),
//           const Text(
//             "Text Remover",
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 12),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 48),
//             child: Text(
//               "Remove unwanted text from your images with AI precision",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white70,
//                 height: 1.5,
//               ),
//             ),
//           ),
//           const SizedBox(height: 48),
//           ElevatedButton.icon(
//             onPressed: pickImage,
//             icon: const Icon(Icons.add_photo_alternate_outlined, size: 24),
//             label: const Text(
//               "Select Image",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple.shade600,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               elevation: 8,
//               shadowColor: Colors.purple.withOpacity(0.5),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImageEditor() {
//     return Column(
//       children: [
//         if (_editedImageUrl == null && !_isTextMode)
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blue.shade700.withOpacity(0.8),
//                   Colors.purple.shade700.withOpacity(0.8),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue.withOpacity(0.3),
//                   blurRadius: 15,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.touch_app_rounded, color: Colors.white, size: 28),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Drag to select text area you want to remove",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         if (_isTextMode)
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.green.shade700.withOpacity(0.8),
//                   Colors.teal.shade700.withOpacity(0.8),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.green.withOpacity(0.3),
//                   blurRadius: 15,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.text_fields, color: Colors.white, size: 28),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     "Tap text to edit or drag to move. Use + button to add new text",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: LayoutBuilder(
//                 builder: (context, constraints) {
//                   _displayedSize = Size(
//                     constraints.maxWidth,
//                     constraints.maxHeight,
//                   );

//                   return Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.grey.shade900,
//                               Colors.grey.shade800,
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
//                       ),

//                       GestureDetector(
//                         onPanStart: (d) {
//                           if (_isTextMode) {
//                             // Check if tap is on any text
//                             for (int i = 0; i < _textOverlays.length; i++) {
//                               final overlay = _textOverlays[i];
//                               final textPainter = TextPainter(
//                                 text: TextSpan(
//                                   text: overlay.text,
//                                   style: TextStyle(
//                                     fontSize: overlay.fontSize,
//                                     fontWeight: overlay.fontWeight,
//                                   ),
//                                 ),
//                                 textDirection: TextDirection.ltr,
//                               );
//                               textPainter.layout();

//                               final textRect = Rect.fromLTWH(
//                                 overlay.position.dx,
//                                 overlay.position.dy,
//                                 textPainter.width,
//                                 textPainter.height,
//                               );

//                               if (textRect.contains(d.localPosition)) {
//                                 setState(() {
//                                   _selectedTextIndex = i;
//                                   _dragStartPosition = d.localPosition;
//                                 });
//                                 return;
//                               }
//                             }
//                             setState(() => _selectedTextIndex = null);
//                           } else if (_editedImageUrl == null) {
//                             setState(() {
//                               _startPoint = d.localPosition;
//                               _currentPoint = d.localPosition;
//                               _isSelecting = true;
//                             });
//                           }
//                         },
//                         onPanUpdate: (d) {
//                           if (_isTextMode && _selectedTextIndex != null) {
//                             setState(() {
//                               final offset =
//                                   d.localPosition - _dragStartPosition!;
//                               _textOverlays[_selectedTextIndex!].position +=
//                                   offset;
//                               _dragStartPosition = d.localPosition;
//                             });
//                           } else if (_editedImageUrl == null && !_isTextMode) {
//                             setState(() {
//                               _currentPoint = d.localPosition;
//                             });
//                           }
//                         },
//                         onPanEnd: (_) async {
//                           if (_isTextMode) {
//                             _dragStartPosition = null;
//                           } else if (_editedImageUrl == null) {
//                             setState(() => _isSelecting = false);

//                             if (_startPoint == null || _currentPoint == null) {
//                               return;
//                             }

//                             final rect = Rect.fromPoints(
//                               _startPoint!,
//                               _currentPoint!,
//                             );

//                             _startPoint = null;
//                             _currentPoint = null;

//                             await aiErase(rect);
//                           }
//                         },
//                         child: FadeTransition(
//                           opacity: _fadeAnimation,
//                           child: _editedImageUrl != null
//                               ? Image.network(
//                                   _editedImageUrl!,
//                                   width: constraints.maxWidth,
//                                   height: constraints.maxHeight,
//                                   fit: BoxFit.contain,
//                                   loadingBuilder: (context, child, progress) {
//                                     if (progress == null) return child;
//                                     return Center(
//                                       child: CircularProgressIndicator(
//                                         value:
//                                             progress.expectedTotalBytes != null
//                                             ? progress.cumulativeBytesLoaded /
//                                                   progress.expectedTotalBytes!
//                                             : null,
//                                         color: Colors.purple,
//                                       ),
//                                     );
//                                   },
//                                 )
//                               : Image.memory(
//                                   _imageBytes!,
//                                   width: constraints.maxWidth,
//                                   height: constraints.maxHeight,
//                                   fit: BoxFit.contain,
//                                 ),
//                         ),
//                       ),

//                       // Text overlays
//                       ..._textOverlays.asMap().entries.map((entry) {
//                         final index = entry.key;
//                         final overlay = entry.value;
//                         final isSelected = _selectedTextIndex == index;

//                         return Positioned(
//                           left: overlay.position.dx,
//                           top: overlay.position.dy,
//                           child: GestureDetector(
//                             behavior: HitTestBehavior.translucent,
//                             onPanStart: (_) {
//                               if (_isTextMode) {
//                                 setState(() => _selectedTextIndex = index);
//                               }
//                             },
//                             onPanUpdate: (details) {
//                               if (_isTextMode) {
//                                 setState(() {
//                                   overlay.position += details.delta;
//                                 });
//                               }
//                             },
//                             onTap: () {
//                               if (_isTextMode) {
//                                 _showTextOptions(index);
//                               }
//                             },
//                             onDoubleTap: () {
//                               if (_isTextMode) {
//                                 _editTextDialog(index); // edit text content
//                               }
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: _selectedTextIndex == index
//                                   ? BoxDecoration(
//                                       border: Border.all(
//                                         color: Colors.purpleAccent,
//                                         width: 2,
//                                       ),
//                                       borderRadius: BorderRadius.circular(4),
//                                     )
//                                   : null,
//                               child: Text(
//                                 overlay.text,
//                                 style: TextStyle(
//                                   fontSize: overlay.fontSize,
//                                   color: overlay.color,
//                                   fontWeight: overlay.fontWeight,
//                                   fontFamily: overlay.fontFamily,
//                                   shadows: const [
//                                     Shadow(color: Colors.black, blurRadius: 2),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );

//                         // return Positioned(
//                         //   left: overlay.position.dx,
//                         //   top: overlay.position.dy,
//                         //   child: GestureDetector(
//                         //     onTap: () {
//                         //       if (_isTextMode) {
//                         //         _showTextOptions(index);
//                         //       }
//                         //     },
//                         //     child: Container(
//                         //       padding: const EdgeInsets.all(4),
//                         //       decoration: isSelected
//                         //           ? BoxDecoration(
//                         //               border: Border.all(
//                         //                 color: Colors.purple.shade400,
//                         //                 width: 2,
//                         //               ),
//                         //               borderRadius: BorderRadius.circular(4),
//                         //             )
//                         //           : null,
//                         //       child: Text(
//                         //         overlay.text,
//                         //         style: TextStyle(
//                         //           fontSize: overlay.fontSize,
//                         //           color: overlay.color,
//                         //           fontWeight: overlay.fontWeight,
//                         //           fontFamily: overlay.fontFamily,
//                         //           shadows: [
//                         //             Shadow(
//                         //               color: overlay.color == Colors.white
//                         //                   ? Colors.black
//                         //                   : Colors.white,
//                         //               blurRadius: 2,
//                         //             ),
//                         //           ],
//                         //         ),
//                         //       ),
//                         //     ),
//                         //   ),
//                         // );
//                       }).toList(),

//                       if (_isSelecting &&
//                           _startPoint != null &&
//                           _currentPoint != null &&
//                           !_isTextMode)
//                         CustomPaint(
//                           painter: SelectionPainter(
//                             _startPoint!,
//                             _currentPoint!,
//                           ),
//                           size: _displayedSize,
//                         ),

//                       if (_loadingAi)
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.black87,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 SizedBox(
//                                   width: 80,
//                                   height: 80,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 6,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.purple.shade400,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 const Text(
//                                   "AI is working...",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 const Text(
//                                   "Removing text from image",
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),

//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: ElevatedButton.icon(
//             onPressed: pickImage,
//             icon: const Icon(Icons.photo_library_rounded, size: 24),
//             label: const Text(
//               "Choose Another Image",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF0f3460),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               elevation: 4,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


















import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/views/textremovalmodule/image_rect_utils.dart';
import 'package:posternova/views/textremovalmodule/mask_generator.dart';
import 'package:posternova/views/textremovalmodule/selection_painter.dart';
import 'package:posternova/views/textremovalmodule/text_removal_service.dart';
import 'package:posternova/widgets/language_widget.dart';

// Model for text overlay
class TextOverlay {
  String text;
  Offset position;
  double fontSize;
  Color color;
  String fontFamily;
  FontWeight fontWeight;
  bool isSelected;

  TextOverlay({
    required this.text,
    required this.position,
    this.fontSize = 24,
    this.color = Colors.white,
    this.fontFamily = 'Roboto',
    this.fontWeight = FontWeight.bold,
    this.isSelected = false,
  });
}

// Model for selected regions to remove
class SelectionRegion {
  final Rect rect;
  final Color color;

  SelectionRegion({required this.rect, required this.color});
}

class ImageEditorScreen extends StatefulWidget {
  const ImageEditorScreen({super.key});

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen>
    with SingleTickerProviderStateMixin {
  Uint8List? _imageBytes;
  String? _editedImageUrl;
  Offset? _startPoint;
  Offset? _currentPoint;
  bool _isSelecting = false;
  Size _originalImageSize = Size.zero;
  Size _displayedSize = Size.zero;
  bool _loadingAi = false;
  String? _userId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Multiple selections support
  List<SelectionRegion> _selectedRegions = [];
  final List<Color> _selectionColors = [
    Colors.red.withOpacity(0.3),
    Colors.blue.withOpacity(0.3),
    Colors.green.withOpacity(0.3),
    Colors.orange.withOpacity(0.3),
    Colors.purple.withOpacity(0.3),
    Colors.yellow.withOpacity(0.3),
    Colors.pink.withOpacity(0.3),
    Colors.teal.withOpacity(0.3),
  ];

  // Text overlay properties
  List<TextOverlay> _textOverlays = [];
  int? _selectedTextIndex;
  bool _isTextMode = false;
  Offset? _dragStartPosition;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserId() async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData != null) {
        setState(() {
          _userId = userData.user.id;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not logged in"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading user data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (picked == null) return;

    final bytes = await File(picked.path).readAsBytes();
    final decoded = await decodeImageFromList(bytes);

    setState(() {
      _imageBytes = bytes;
      _editedImageUrl = null;
      _originalImageSize = Size(
        decoded.width.toDouble(),
        decoded.height.toDouble(),
      );
      _startPoint = null;
      _currentPoint = null;
      _selectedRegions.clear();
      _textOverlays.clear();
      _selectedTextIndex = null;
      _isTextMode = false;
    });

    _animationController.forward(from: 0);
  }

  void _editTextDialog(int index) {
    final controller = TextEditingController(text: _textOverlays[index].text);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Text", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Edit your text",
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _textOverlays[index].text = controller.text.trim();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Add selection to list
  void _addSelection(Rect screenRect) {
    final normalizedRect = Rect.fromLTRB(
      screenRect.left < screenRect.right ? screenRect.left : screenRect.right,
      screenRect.top < screenRect.bottom ? screenRect.top : screenRect.bottom,
      screenRect.left < screenRect.right ? screenRect.right : screenRect.left,
      screenRect.top < screenRect.bottom ? screenRect.bottom : screenRect.top,
    );

    // Check if rect is valid
    if (normalizedRect.width < 10 || normalizedRect.height < 10) {
      return;
    }

    setState(() {
      final colorIndex = _selectedRegions.length % _selectionColors.length;
      _selectedRegions.add(
        SelectionRegion(
          rect: normalizedRect,
          color: _selectionColors[colorIndex],
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Selection ${_selectedRegions.length} added. Tap 'Generate' when ready.",
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Clear all selections
  void _clearSelections() {
    setState(() {
      _selectedRegions.clear();
    });
  }

  // Remove last selection
  void _removeLastSelection() {
    if (_selectedRegions.isEmpty) return;
    setState(() {
      _selectedRegions.removeLast();
    });
  }

  // Generate image with all selections
  Future<void> _generateWithAllSelections() async {
    if (_imageBytes == null || _selectedRegions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one area to remove"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User ID not available. Please log in again."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      setState(() => _loadingAi = true);

      final renderRect = ImageRectUtils.getImageRenderRect(
        imageSize: _originalImageSize,
        containerSize: _displayedSize,
      );

      final decoded = img.decodeImage(_imageBytes!)!;

      // Create a combined mask for all selections
      final combinedMask = img.Image(
        width: decoded.width,
        height: decoded.height,
      );

      // Fill with black initially
      for (int y = 0; y < combinedMask.height; y++) {
        for (int x = 0; x < combinedMask.width; x++) {
          combinedMask.setPixelRgba(x, y, 0, 0, 0, 255);
        }
      }

      // Process each selection
      for (final region in _selectedRegions) {
        final intersectedRect = region.rect.intersect(renderRect);

        if (intersectedRect.isEmpty) continue;

        final imageRect = ImageRectUtils.scaleRectToImage(
          screenRect: intersectedRect,
          imageRect: renderRect,
          imageSize: _originalImageSize,
        );

        final clampedImageRect = Rect.fromLTRB(
          imageRect.left.clamp(0, _originalImageSize.width),
          imageRect.top.clamp(0, _originalImageSize.height),
          imageRect.right.clamp(0, _originalImageSize.width),
          imageRect.bottom.clamp(0, _originalImageSize.height),
        );

        // Add this region to the combined mask (white = remove)
        final maskRegionBytes = MaskGenerator.generateMask(
          decoded.width,
          decoded.height,
          clampedImageRect,
        );

        // Decode the mask bytes to img.Image
        final maskRegionImage = img.decodePng(maskRegionBytes);
        if (maskRegionImage == null) continue;

        // Merge masks
        for (int y = 0; y < combinedMask.height; y++) {
          for (int x = 0; x < combinedMask.width; x++) {
            final pixel = maskRegionImage.getPixel(x, y);
            if (pixel.r > 128) {
              // If the region mask is white
              combinedMask.setPixelRgba(x, y, 255, 255, 255, 255);
            }
          }
        }
      }

      final imageUrl = await AiTextRemovalService.removeText(
        userId: _userId!,
        image: _imageBytes!,
        mask: img.encodePng(combinedMask),
      );

      setState(() {
        _editedImageUrl = imageUrl;
        _selectedRegions.clear();
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text("All text removed successfully!"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('AI Erase Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text("AI erase failed: $e")),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _loadingAi = false);
    }
  }

  // Add text overlay
  void _addTextOverlay() {
    showDialog(
      context: context,
      builder: (context) {
        String textInput = '';
        return AlertDialog(
          backgroundColor: const Color(0xFF16213e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Add Text',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter text...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              textInput = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (textInput.trim().isNotEmpty) {
                  setState(() {
                    _textOverlays.add(
                      TextOverlay(
                        text: textInput,
                        position: Offset(
                          _displayedSize.width / 2 - 50,
                          _displayedSize.height / 2 - 20,
                        ),
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Show text editing options
  void _showTextOptions(int index) {
    final overlay = _textOverlays[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16213e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Text Options',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Font size slider
                  Row(
                    children: [
                      const Icon(Icons.format_size, color: Colors.white70),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Slider(
                          value: overlay.fontSize,
                          min: 12,
                          max: 72,
                          divisions: 60,
                          activeColor: Colors.purple.shade400,
                          label: overlay.fontSize.round().toString(),
                          onChanged: (value) {
                            setModalState(() {
                              overlay.fontSize = value;
                            });
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),

                  // Color picker
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.color_lens, color: Colors.white70),
                      const SizedBox(width: 10),
                      const Text(
                        'Color:',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          children: [
                            Colors.white,
                            Colors.black,
                            Colors.red,
                            Colors.blue,
                            Colors.green,
                            Colors.yellow,
                            Colors.purple,
                            Colors.orange,
                          ].map((color) {
                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  overlay.color = color;
                                });
                                setState(() {});
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: overlay.color == color
                                        ? Colors.purple.shade400
                                        : Colors.white24,
                                    width: overlay.color == color ? 3 : 1,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Delete button
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _textOverlays.removeAt(index);
                        _selectedTextIndex = null;
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete Text'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> saveImage() async {
    if (_editedImageUrl == null && _imageBytes == null) return;

    try {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text("Preparing image..."),
            ],
          ),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      Uint8List imageBytes;

      if (_editedImageUrl != null) {
        final response = await http.get(Uri.parse(_editedImageUrl!));
        if (response.statusCode != 200) {
          throw Exception('Failed to download image');
        }
        imageBytes = response.bodyBytes;
      } else {
        imageBytes = _imageBytes!;
      }

      // If there are text overlays, render them on the image
      if (_textOverlays.isNotEmpty) {
        imageBytes = await _renderTextOnImage(imageBytes);
      }

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${tempDir.path}/posternova_$timestamp.png';

      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      await Gal.putImage(filePath, album: 'PosterNova');

      await file.delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.download_done, color: Colors.white),
              SizedBox(width: 8),
              Text("Image saved to gallery"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save image: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Render text overlays on image
  Future<Uint8List> _renderTextOnImage(Uint8List imageBytes) async {
    final image = await decodeImageFromList(imageBytes);
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw the original image
    final imageCodec = await instantiateImageCodec(imageBytes);
    final frame = await imageCodec.getNextFrame();
    canvas.drawImage(frame.image, Offset.zero, Paint());

    // Calculate scale factor
    final renderRect = ImageRectUtils.getImageRenderRect(
      imageSize: _originalImageSize,
      containerSize: _displayedSize,
    );
    final scaleX = _originalImageSize.width / renderRect.width;
    final scaleY = _originalImageSize.height / renderRect.height;

    // Draw text overlays
    for (final overlay in _textOverlays) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: overlay.text,
          style: TextStyle(
            fontSize: overlay.fontSize * scaleX,
            color: overlay.color,
            fontWeight: overlay.fontWeight,
            fontFamily: overlay.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final scaledPosition = Offset(
        (overlay.position.dx - renderRect.left) * scaleX,
        (overlay.position.dy - renderRect.top) * scaleY,
      );

      textPainter.paint(canvas, scaledPosition);
    }

    final picture = recorder.endRecording();
    final finalImage = await picture.toImage(image.width, image.height);
    final byteData = await finalImage.toByteData(format: ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  void resetEditor() {
    setState(() {
      _imageBytes = null;
      _editedImageUrl = null;
      _startPoint = null;
      _currentPoint = null;
      _isSelecting = false;
      _originalImageSize = Size.zero;
      _displayedSize = Size.zero;
      _selectedRegions.clear();
      _textOverlays.clear();
      _selectedTextIndex = null;
      _isTextMode = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          "Text Remover",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          if (_imageBytes != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isTextMode
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.text_fields,
                    color: _isTextMode
                        ? Colors.blueAccent
                        : Colors.blue.shade300,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isTextMode = !_isTextMode;
                    _selectedTextIndex = null;
                  });
                },
                tooltip: "Text Mode",
              ),
            ),
          if (_imageBytes != null || _editedImageUrl != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    color: Colors.greenAccent,
                  ),
                ),
                onPressed: saveImage,
                tooltip: "Save Image",
              ),
            ),
          if (_imageBytes != null)
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.orangeAccent,
                  ),
                ),
                onPressed: resetEditor,
                tooltip: "Reset",
              ),
            ),
        ],
      ),
      body: _imageBytes == null ? _buildEmptyState() : _buildImageEditor(),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Widget? _buildFloatingButtons() {
    if (_imageBytes == null) return null;

    if (_isTextMode) {
      return FloatingActionButton.extended(
        onPressed: _addTextOverlay,
        backgroundColor: Colors.purple.shade600,
        icon: const Icon(Icons.add),
        label: const Text('Add Text', style: TextStyle(color: Colors.white)),
      );
    }

    if (_selectedRegions.isEmpty && _editedImageUrl == null) {
      return null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_selectedRegions.isNotEmpty) ...[
          // Undo button
          FloatingActionButton(
            heroTag: 'undo',
            onPressed: _removeLastSelection,
            backgroundColor: Colors.orange.shade600,
            mini: true,
            child: const Icon(Icons.undo),
          ),
          const SizedBox(height: 8),
          // Clear all button
          FloatingActionButton(
            heroTag: 'clear',
            onPressed: _clearSelections,
            backgroundColor: Colors.red.shade600,
            mini: true,
            child: const Icon(Icons.clear_all),
          ),
          const SizedBox(height: 16),
          // Generate button
          FloatingActionButton.extended(
            heroTag: 'generate',
            onPressed: _generateWithAllSelections,
            backgroundColor: Colors.green.shade600,
            icon: const Icon(Icons.auto_fix_high),
            label: Text(
              'Generate (${_selectedRegions.length})',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_fix_high_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          const AppText(
            "text_remover",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: AppText(
              "remove_text_ai",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton.icon(
            onPressed: pickImage,
            icon: const Icon(Icons.add_photo_alternate_outlined, size: 24),
            label: const AppText(
              "select_image",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: Colors.purple.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageEditor() {
    return Column(
      children: [
        if (_editedImageUrl == null && !_isTextMode && _selectedRegions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700.withOpacity(0.8),
                  Colors.purple.shade700.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.touch_app_rounded, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Drag to select text areas. You can select multiple areas!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (_selectedRegions.isNotEmpty && !_isTextMode)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade700.withOpacity(0.8),
                  Colors.teal.shade700.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "${_selectedRegions.length} area(s) selected. Tap 'Generate' to remove all selected text",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (_isTextMode)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700.withOpacity(0.8),
                  Colors.indigo.shade700.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.text_fields, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Tap text to edit or drag to move. Use + button to add new text",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _displayedSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade900,
                              Colors.grey.shade800,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onPanStart: (d) {
                          if (_isTextMode) {
                            for (int i = 0; i < _textOverlays.length; i++) {
                              final overlay = _textOverlays[i];
                              final textPainter = TextPainter(
                                text: TextSpan(
                                  text: overlay.text,
                                  style: TextStyle(
                                    fontSize: overlay.fontSize,
                                    fontWeight: overlay.fontWeight,
                                  ),
                                ),
                                textDirection: TextDirection.ltr,
                              );
                              textPainter.layout();

                              final textRect = Rect.fromLTWH(
                                overlay.position.dx,
                                overlay.position.dy,
                                textPainter.width,
                                textPainter.height,
                              );

                              if (textRect.contains(d.localPosition)) {
                                setState(() {
                                  _selectedTextIndex = i;
                                  _dragStartPosition = d.localPosition;
                                });
                                return;
                              }
                            }
                            setState(() => _selectedTextIndex = null);
                          } else if (_editedImageUrl == null) {
                            setState(() {
                              _startPoint = d.localPosition;
                              _currentPoint = d.localPosition;
                              _isSelecting = true;
                            });
                          }
                        },
                        onPanUpdate: (d) {
                          if (_isTextMode && _selectedTextIndex != null) {
                            setState(() {
                              final offset = d.localPosition - _dragStartPosition!;
                              _textOverlays[_selectedTextIndex!].position += offset;
                              _dragStartPosition = d.localPosition;
                            });
                          } else if (_editedImageUrl == null && !_isTextMode) {
                            setState(() {
                              _currentPoint = d.localPosition;
                            });
                          }
                        },
                        onPanEnd: (_) {
                          if (_isTextMode) {
                            _dragStartPosition = null;
                          } else if (_editedImageUrl == null) {
                            setState(() => _isSelecting = false);

                            if (_startPoint != null && _currentPoint != null) {
                              final rect = Rect.fromPoints(
                                _startPoint!,
                                _currentPoint!,
                              );

                              _addSelection(rect);

                              _startPoint = null;
                              _currentPoint = null;
                            }
                          }
                        },
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _editedImageUrl != null
                              ? Image.network(
                                  _editedImageUrl!,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: progress.expectedTotalBytes != null
                                            ? progress.cumulativeBytesLoaded /
                                                progress.expectedTotalBytes!
                                            : null,
                                        color: Colors.purple,
                                      ),
                                    );
                                  },
                                )
                              : Image.memory(
                                  _imageBytes!,
                                  width: constraints.maxWidth,
                                  height: constraints.maxHeight,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),

                      // Show all saved selections
                      ..._selectedRegions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final region = entry.value;
                        return Positioned.fromRect(
                          rect: region.rect,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: region.color.withOpacity(1),
                                width: 3,
                              ),
                              color: region.color,
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      // Text overlays
                      ..._textOverlays.asMap().entries.map((entry) {
                        final index = entry.key;
                        final overlay = entry.value;

                        return Positioned(
                          left: overlay.position.dx,
                          top: overlay.position.dy,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanStart: (_) {
                              if (_isTextMode) {
                                setState(() => _selectedTextIndex = index);
                              }
                            },
                            onPanUpdate: (details) {
                              if (_isTextMode) {
                                setState(() {
                                  overlay.position += details.delta;
                                });
                              }
                            },
                            onTap: () {
                              if (_isTextMode) {
                                _showTextOptions(index);
                              }
                            },
                            onDoubleTap: () {
                              if (_isTextMode) {
                                _editTextDialog(index);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: _selectedTextIndex == index
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: Colors.purpleAccent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    )
                                  : null,
                              child: Text(
                                overlay.text,
                                style: TextStyle(
                                  fontSize: overlay.fontSize,
                                  color: overlay.color,
                                  fontWeight: overlay.fontWeight,
                                  fontFamily: overlay.fontFamily,
                                  shadows: const [
                                    Shadow(color: Colors.black, blurRadius: 2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      // Current selection being drawn
                      if (_isSelecting &&
                          _startPoint != null &&
                          _currentPoint != null &&
                          !_isTextMode)
                        CustomPaint(
                          painter: SelectionPainter(
                            _startPoint!,
                            _currentPoint!,
                          ),
                          size: _displayedSize,
                        ),

                      if (_loadingAi)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 6,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.purple.shade400,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "AI is working...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Removing ${_selectedRegions.length} selected area(s)",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: pickImage,
            icon: const Icon(Icons.photo_library_rounded, size: 24),
            label: const Text(
              "Choose Another Image",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0f3460),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}