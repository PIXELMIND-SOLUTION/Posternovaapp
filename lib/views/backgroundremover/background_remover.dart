// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:gal/gal.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:http/http.dart' as http;


// class BackgroundRemoverScreen extends StatefulWidget {
//   const BackgroundRemoverScreen({super.key});

//   @override
//   State<BackgroundRemoverScreen> createState() => _BackgroundRemoverScreenState();
// }

// class _BackgroundRemoverScreenState extends State<BackgroundRemoverScreen>
//     with TickerProviderStateMixin {
//   File? _selectedImage;
//   Uint8List? _processedImage;
//   bool _isProcessing = false;
//   bool _isBackgroundRemoved = false;

//   // Split view position (0.0 .. 1.0). 0.5 shows half/half.
//   double _split = 0.5;

//   late AnimationController _fadeController;
//   late Animation<double> _fade;

//   // API Configuration (move to secure place in production)
//   static const String apiKey = "ANJGbHQEh4W9UmXWUvxgC9AM";
//   static const String baseUrl = "https://api.remove.bg/v1.0/removebg";

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 420),
//     );
//     _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(ImageSource src) async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: src,
//         maxWidth: 1920,
//         maxHeight: 1920,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//           _processedImage = null;
//           _isBackgroundRemoved = false;
//           _split = 0.5;
//         });
//         _fadeController.forward(from: 0);
//       }
//     } catch (e) {
//       _showErrorSnackBar('Failed to pick image: $e');
//     }
//   }

//   Future<Uint8List?> _removeBackgroundUsingAPI(String imagePath) async {
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

//       request.headers.addAll({
//         "X-API-Key": apiKey,
//       });

//       request.files.add(await http.MultipartFile.fromPath("image_file", imagePath));

//       request.fields['size'] = 'auto';
//       request.fields['format'] = 'png';
//       request.fields['type'] = 'auto';

//       final response = await request.send();

//       if (response.statusCode == 200) {
//         final bytes = await response.stream.toBytes();
//         return Uint8List.fromList(bytes);
//       } else {
//         final errorBody = await response.stream.bytesToString();
//         String errorMessage = 'Failed to remove background';
//         try {
//           final errorJson = json.decode(errorBody);
//           if (errorJson['errors'] != null && errorJson['errors'].isNotEmpty) {
//             errorMessage = errorJson['errors'][0]['title'] ?? errorMessage;
//           }
//         } catch (_) {
//           switch (response.statusCode) {
//             case 400:
//               errorMessage = 'Invalid image format or size';
//               break;
//             case 402:
//               errorMessage = 'Insufficient API credits';
//               break;
//             case 403:
//               errorMessage = 'Invalid API key';
//               break;
//             case 429:
//               errorMessage = 'Rate limit exceeded. Please try again later';
//               break;
//             default:
//               errorMessage = 'Server error (${response.statusCode})';
//           }
//         }
//         throw Exception(errorMessage);
//       }
//     } catch (e) {
//       throw Exception('Network error: ${e.toString()}');
//     }
//   }

//   Future<void> _removeBackground() async {
//     if (_selectedImage == null) return;

//     setState(() => _isProcessing = true);
//     try {
//       final processedBytes =
//           await _removeBackgroundUsingAPI(_selectedImage!.path);

//       if (processedBytes != null) {
//         setState(() {
//           _processedImage = processedBytes;
//           _isBackgroundRemoved = true;
//           _isProcessing = false;
//         });
//         _fadeController.forward(from: 0);
//         _showSuccessSnackBar('Background removed successfully');
//       } else {
//         throw Exception('Failed to process image');
//       }
//     } catch (e) {
//       setState(() => _isProcessing = false);
//       _showErrorSnackBar('Failed to remove background: ${e.toString()}');
//     }
//   }

//   Future<bool> _requestStoragePermission() async {
//     try {
//       if (await Gal.hasAccess()) return true;
//       final granted = await Gal.requestAccess();
//       return granted;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> _saveImage() async {
//     if (_processedImage == null) return;

//     try {
//       final hasPermission = await _requestStoragePermission();
//       if (!hasPermission) {
//         _showErrorSnackBar('Storage permission is required to save images');
//         return;
//       }

//       final tempDir = await getTemporaryDirectory();
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final fileName = 'bg_removed_$timestamp.png';
//       final tempFile = File('${tempDir.path}/$fileName');
//       await tempFile.writeAsBytes(_processedImage!);
//       await Gal.putImage(tempFile.path, album: 'Background Remover');
//       await tempFile.delete();
//       _showSuccessSnackBar('Saved to gallery — "Background Remover"');
//     } catch (e) {
//       _showErrorSnackBar('Failed to save image: ${e.toString()}');
//     }
//   }

//   Future<void> _shareImage() async {
//     if (_processedImage == null) return;
//     try {
//       final dir = await getTemporaryDirectory();
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final filePath = '${dir.path}/bg_removed_$timestamp.png';
//       final file = File(filePath);
//       await file.writeAsBytes(_processedImage!);
//       await Share.shareXFiles([XFile(filePath)], text: 'Background removed image');
//     } catch (e) {
//       _showErrorSnackBar('Failed to share image: $e');
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Row(children: [Icon(Icons.error_outline), SizedBox(width: 8), Expanded(child: Text(message))]),
//       backgroundColor: Colors.red.shade600,
//       behavior: SnackBarBehavior.floating,
//     ));
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Row(children: [Icon(Icons.check_circle_outline), SizedBox(width: 8), Expanded(child: Text(message))]),
//       backgroundColor: Colors.green.shade700,
//       behavior: SnackBarBehavior.floating,
//     ));
//   }

//   Widget _buildTopBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       foregroundColor: Colors.black87,
//       centerTitle: true,
//       title: const Text('Background Remover', style: TextStyle(fontWeight: FontWeight.w700)),
//       // actions: [
//       //   IconButton(
//       //     tooltip: 'Help',
//       //     onPressed: () {
//       //       showModalBottomSheet(context: context, builder: (c) => _buildHelpSheet());
//       //     },
//       //     icon: Icon(Icons.help_outline),
//       //   )
//       // ],
//     );
//   }

  

//   Widget _buildImageCanvas(BoxConstraints constraints) {
//     final width = constraints.maxWidth;
//     final leftWidth = width * _split;

//     return GestureDetector(
//       onHorizontalDragUpdate: (details) {
//         setState(() {
//           _split = (_split + details.delta.dx / width).clamp(0.1, 0.9);
//         });
//       },
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           height: 360,
//           color: Colors.grey.shade100,
//           child: Stack(children: [
//             // Original (full) at the back
//             Positioned.fill(
//               child: _selectedImage != null
//                   ? Image.file(_selectedImage!, fit: BoxFit.cover)
//                   : _placeholderCanvas(),
//             ),

//             // Processed on top, clipped by split
//             if (_processedImage != null)
//               Positioned(
//                 left: leftWidth,
//                 right: 0,
//                 top: 0,
//                 bottom: 0,
//                 child: FadeTransition(
//                   opacity: _fade,
//                   child: Container(), // placeholder for opacity effect
//                 ),
//               ),

//             if (_processedImage != null)
//               Positioned.fill(
//                 child: ClipRect(
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     widthFactor: 1.0,
//                     child: SizedBox(
//                       width: width,
//                       child: Row(children: [
//                         SizedBox(width: leftWidth),
//                         Expanded(
//                           child: Container(
//                             height: 360,
//                             child: Stack(children: [
//                               if (true)
                             

//                               Positioned.fill(
//                                 child: Image.memory(_processedImage!, fit: BoxFit.cover),
//                               ),
//                             ]),
//                           ),
//                         ),
//                       ]),
//                     ),
//                   ),
//                 ),
//               ),

//             // Vertical draggable handle
//             Positioned(
//               left: leftWidth - 12,
//               top: 0,
//               bottom: 0,
//               child: Container(
//                 width: 24,
//                 alignment: Alignment.center,
//                 child: Container(
//                   width: 4,
//                   height: 120,
//                   decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)]),
//                 ),
//               ),
//             ),

          
//           ]),
//         ),
//       ),
//     );
//   }

//   Widget _placeholderCanvas() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           Icon(Icons.photo_size_select_actual_outlined, size: 72, color: Colors.grey.shade400),
//           const SizedBox(height: 12),
//           Text('No image selected', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
//           const SizedBox(height: 8),
//           Text('Tap the gallery or camera button below to start', style: TextStyle(color: Colors.grey.shade500)),
//         ]),
//       ),
//     );
//   }

//   Widget _buildBadge(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.18))),
//       child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.6)),
//     );
//   }

//   Widget _buildControls() {
//     return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//       // Status row
//       Row(children: [

//       ]),

//       const SizedBox(height: 12),

//       // Action buttons
//       Row(children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () => _pickImage(ImageSource.gallery),
//             icon: Icon(Icons.photo_library_outlined),
//             label: Text('Gallery'),
//             style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () => _pickImage(ImageSource.camera),
//             icon: Icon(Icons.camera_alt_outlined,color: Colors.white,),
//             label: Text('Camera',style: TextStyle(color: Colors.white),),
//             style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 30, 175, 188), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//           ),
//         ),
//       ]),

//       const SizedBox(height: 12),

//       Row(children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: (_selectedImage != null && !_isProcessing) ? _removeBackground : null,
//             icon: _isProcessing ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(Icons.auto_fix_high_outlined,color: Colors.white,),
//             label: Text(_isProcessing ? 'Processing...' : 'Remove Background',style: TextStyle(color: Colors.white),),
//             style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: Colors.green.shade700),
//           ),
//         ),
//       ]),

//       const SizedBox(height: 12),

//       if (_isBackgroundRemoved) Row(children: [
//         Expanded(child: OutlinedButton.icon(onPressed: _saveImage, icon: Icon(Icons.download_outlined), label: Text('Save'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),),
//         const SizedBox(width: 12),
//         Expanded(child: OutlinedButton.icon(onPressed: _shareImage, icon: Icon(Icons.share_outlined), label: Text('Share'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),),
//       ]),
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: _buildTopBar()),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(children: [
            

//             const SizedBox(height: 16),

//             // Image canvas
//             Expanded(child: LayoutBuilder(builder: (context, constraints) {
//               return _buildImageCanvas(constraints);
//             })),

//             const SizedBox(height: 12),
//             _buildControls(),
//             const SizedBox(height: 8),
//             // Quick hint: show split value
//             // Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Compare: '), SizedBox(width: 8), Text('${(_split * 100).round()}% / ${(100 - (_split * 100)).round()}%', style: TextStyle(fontWeight: FontWeight.bold))]),
//             const SizedBox(height: 6),
//           ]),
//         ),
//       ),
//     );
//   }
// }









import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class BackgroundRemoverScreen extends StatefulWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  State<BackgroundRemoverScreen> createState() => _BackgroundRemoverScreenState();
}

class _BackgroundRemoverScreenState extends State<BackgroundRemoverScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  Uint8List? _processedImage;
  bool _isProcessing = false;
  bool _isBackgroundRemoved = false;

  // Split view position (0.0 .. 1.0). 0.5 shows half/half.
  double _split = 0.5;

  late AnimationController _fadeController;
  late Animation<double> _fade;

  // API Configuration (move to secure place in production)
  static const String apiKey = "ANJGbHQEh4W9UmXWUvxgC9AM";
  static const String baseUrl = "https://api.remove.bg/v1.0/removebg";

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fade = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource src) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: src,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _processedImage = null;
          _isBackgroundRemoved = false;
          _split = 0.5;
        });
        _fadeController.forward(from: 0);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<Uint8List?> _removeBackgroundUsingAPI(String imagePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      request.headers.addAll({
        "X-API-Key": apiKey,
      });

      request.files.add(await http.MultipartFile.fromPath("image_file", imagePath));

      request.fields['size'] = 'auto';
      request.fields['format'] = 'png';
      request.fields['type'] = 'auto';

      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        return Uint8List.fromList(bytes);
      } else {
        final errorBody = await response.stream.bytesToString();
        String errorMessage = 'Failed to remove background';
        try {
          final errorJson = json.decode(errorBody);
          if (errorJson['errors'] != null && errorJson['errors'].isNotEmpty) {
            errorMessage = errorJson['errors'][0]['title'] ?? errorMessage;
          }
        } catch (_) {
          switch (response.statusCode) {
            case 400:
              errorMessage = 'Invalid image format or size';
              break;
            case 402:
              errorMessage = 'Insufficient API credits';
              break;
            case 403:
              errorMessage = 'Invalid API key';
              break;
            case 429:
              errorMessage = 'Rate limit exceeded. Please try again later';
              break;
            default:
              errorMessage = 'Server error (${response.statusCode})';
          }
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<void> _removeBackground() async {
    if (_selectedImage == null) return;

    setState(() => _isProcessing = true);
    try {
      final processedBytes =
          await _removeBackgroundUsingAPI(_selectedImage!.path);

      if (processedBytes != null) {
        setState(() {
          _processedImage = processedBytes;
          _isBackgroundRemoved = true;
          _isProcessing = false;
        });
        _fadeController.forward(from: 0);
        _showSuccessSnackBar('Background removed successfully');
      } else {
        throw Exception('Failed to process image');
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showErrorSnackBar('Failed to remove background: ${e.toString()}');
    }
  }

  Future<bool> _requestStoragePermission() async {
    try {
      if (await Gal.hasAccess()) return true;
      final granted = await Gal.requestAccess();
      return granted;
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveImage() async {
    if (_processedImage == null) return;

    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        _showErrorSnackBar('Storage permission is required to save images');
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'bg_removed_$timestamp.png';
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(_processedImage!);
      await Gal.putImage(tempFile.path, album: 'Background Remover');
      await tempFile.delete();
      _showSuccessSnackBar('Saved to gallery — "Background Remover"');
    } catch (e) {
      _showErrorSnackBar('Failed to save image: ${e.toString()}');
    }
  }

  Future<void> _shareImage() async {
    if (_processedImage == null) return;
    try {
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${dir.path}/bg_removed_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(_processedImage!);
      await Share.shareXFiles([XFile(filePath)], text: 'Background removed image');
    } catch (e) {
      _showErrorSnackBar('Failed to share image: $e');
    }
  }

  void _openPreview() {
    if (_processedImage == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
          imageBytes: _processedImage!,
          onSave: _saveImage,
          onShare: _shareImage,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [Icon(Icons.error_outline), SizedBox(width: 8), Expanded(child: Text(message))]),
      backgroundColor: Colors.red.shade600,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [Icon(Icons.check_circle_outline), SizedBox(width: 8), Expanded(child: Text(message))]),
      backgroundColor: Colors.green.shade700,
      behavior: SnackBarBehavior.floating,
    ));
  }

  Widget _buildTopBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black87,
      centerTitle: true,
      title: const Text('Background Remover', style: TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  Widget _buildImageCanvas(BoxConstraints constraints) {
    final width = constraints.maxWidth;
    final leftWidth = width * _split;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _split = (_split + details.delta.dx / width).clamp(0.1, 0.9);
        });
      },
      onTap: _isBackgroundRemoved ? _openPreview : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 360,
          color: Colors.grey.shade100,
          child: Stack(children: [
            // Original (full) at the back
            Positioned.fill(
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : _placeholderCanvas(),
            ),

            // Processed on top, clipped by split
            if (_processedImage != null)
              Positioned(
                left: leftWidth,
                right: 0,
                top: 0,
                bottom: 0,
                child: FadeTransition(
                  opacity: _fade,
                  child: Container(),
                ),
              ),

            if (_processedImage != null)
              Positioned.fill(
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.0,
                    child: SizedBox(
                      width: width,
                      child: Row(children: [
                        SizedBox(width: leftWidth),
                        Expanded(
                          child: Container(
                            height: 360,
                            child: Stack(children: [
                              Positioned.fill(
                                child: Image.memory(_processedImage!, fit: BoxFit.cover),
                              ),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),

            // Vertical draggable handle
            if (_processedImage != null)
              Positioned(
                left: leftWidth - 12,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 24,
                  alignment: Alignment.center,
                  child: Container(
                    width: 4,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                    ),
                  ),
                ),
              ),

            // Preview hint overlay
            if (_isBackgroundRemoved)
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fullscreen, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Tap for preview',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _placeholderCanvas() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.photo_size_select_actual_outlined, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text('No image selected', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          Text('Tap the gallery or camera button below to start', style: TextStyle(color: Colors.grey.shade500)),
        ]),
      ),
    );
  }

  Widget _buildControls() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 12),

      // Action buttons
      Row(children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: Icon(Icons.photo_library_outlined),
            label: Text('Gallery'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
            label: Text('Camera', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 30, 175, 188),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ]),

      const SizedBox(height: 12),

      Row(children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: (_selectedImage != null && !_isProcessing) ? _removeBackground : null,
            icon: _isProcessing
                ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Icon(Icons.auto_fix_high_outlined, color: Colors.white),
            label: Text(_isProcessing ? 'Processing...' : 'Remove Background', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Colors.green.shade700,
            ),
          ),
        ),
      ]),

      const SizedBox(height: 12),

      if (_isBackgroundRemoved)
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _openPreview,
              icon: Icon(Icons.preview_outlined),
              label: Text('Preview'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _saveImage,
              icon: Icon(Icons.download_outlined),
              label: Text('Save'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _shareImage,
              icon: Icon(Icons.share_outlined),
              label: Text('Share'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(preferredSize: Size.fromHeight(kToolbarHeight), child: _buildTopBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const SizedBox(height: 16),

            // Image canvas
            Expanded(child: LayoutBuilder(builder: (context, constraints) {
              return _buildImageCanvas(constraints);
            })),

            const SizedBox(height: 12),
            _buildControls(),
            const SizedBox(height: 8),
            const SizedBox(height: 6),
          ]),
        ),
      ),
    );
  }
}

// Preview Screen
class ImagePreviewScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final VoidCallback onSave;
  final VoidCallback onShare;

  const ImagePreviewScreen({
    Key? key,
    required this.imageBytes,
    required this.onSave,
    required this.onShare,
  }) : super(key: key);

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  bool _showControls = true;
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image with zoom/pan
          GestureDetector(
            onTap: _toggleControls,
            child: Center(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.memory(
                  widget.imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Top app bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Preview',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.zoom_out_map, color: Colors.white),
                      onPressed: _resetZoom,
                      tooltip: 'Reset Zoom',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom action buttons
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.download_outlined,
                        label: 'Save',
                        onPressed: () {
                          widget.onSave();
                          Navigator.pop(context);
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onPressed: () {
                          widget.onShare();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 28),
            onPressed: onPressed,
            padding: EdgeInsets.all(16),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}