// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:posternova/providers/story/story_provider.dart';
// import 'package:provider/provider.dart';

// class AddStoryScreen extends StatefulWidget {
//   final VoidCallback onStoryAdded;

//   const AddStoryScreen({
//     Key? key,
//     required this.onStoryAdded,
//   }) : super(key: key);

//   @override
//   State<AddStoryScreen> createState() => _AddStoryScreenState();
// }

// class _AddStoryScreenState extends State<AddStoryScreen> 
//     with SingleTickerProviderStateMixin {
//   File? _image;
//   final TextEditingController _captionController = TextEditingController();
//   bool _isUploading = false;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   final FocusNode _captionFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     _animationController.forward();
//   }

//   void _setupAnimations() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
//     );
//   }

//   @override
//   void dispose() {
//     _captionController.dispose();
//     _captionFocusNode.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       HapticFeedback.mediumImpact();
//       final storyProvider = Provider.of<StoryProvider>(context, listen: false);
//       final pickedFile = await storyProvider.pickImage(source);

//       if (pickedFile != null) {
//         setState(() {
//           _image = pickedFile;
//         });
        
//         // Animate to image preview
//         _animationController.reset();
//         _animationController.forward();
//       }
//     } catch (e) {
//       _showErrorSnackBar('Failed to pick image. Please try again.');
//     }
//   }

//   Future<void> _uploadStory() async {
//     if (_image == null) {
//       _showErrorSnackBar('Please select an image first');
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       HapticFeedback.lightImpact();
//       final storyProvider = Provider.of<StoryProvider>(context, listen: false);
//       final success = await storyProvider.postStory(
//         _image!,
//         _captionController.text.trim(),
//       );

//       if (success) {
//         // HapticFeedback.successFeedback();
//         _showSuccessSnackBar('Story shared successfully!');
//         widget.onStoryAdded();
//         Navigator.pop(context);
//       } else {
//         _showErrorSnackBar(storyProvider.error ?? 'Failed to upload story');
//       }
//     } catch (e) {
//       _showErrorSnackBar('Something went wrong. Please try again.');
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.red[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: Colors.green[600],
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   void _removeImage() {
//     HapticFeedback.lightImpact();
//     setState(() {
//       _image = null;
//       _captionController.clear();
//     });
//     _animationController.reset();
//     _animationController.forward();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       resizeToAvoidBottomInset: true,
//       appBar: _buildAppBar(),
//       body: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           return FadeTransition(
//             opacity: _fadeAnimation,
//             child: _image == null ? _buildImagePickerUI() : _buildImagePreviewUI(),
//           );
//         },
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.black87,
//       systemOverlayStyle: SystemUiOverlayStyle.dark,
//       leading: IconButton(
//         onPressed: () => Navigator.pop(context),
//         icon: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(Icons.arrow_back_ios_new, size: 18),
//         ),
//       ),
//       title: Text(
//         _image == null ? 'Create Story' : 'Edit Story',
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: Colors.black87,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         if (_image != null)
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             child: _isUploading
//                 ? Container(
//                     width: 40,
//                     height: 40,
//                     padding: const EdgeInsets.all(10),
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.blue[600],
//                     ),
//                   )
//                 : Material(
//                     color: Colors.blue[600],
//                     borderRadius: BorderRadius.circular(25),
//                     child: InkWell(
//                       onTap: _uploadStory,
//                       borderRadius: BorderRadius.circular(25),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(Icons.send_rounded, color: Colors.white, size: 18),
//                             const SizedBox(width: 8),
//                             const Text(
//                               'Share',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//           ),
//       ],
//     );
//   }

//   Widget _buildImagePickerUI() {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Header Section
//               ScaleTransition(
//                 scale: _scaleAnimation,
//                 child: Container(
//                   width: 120,
//                   height: 120,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blue[400]!, Colors.purple[400]!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.blue.withOpacity(0.3),
//                         blurRadius: 20,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.add_photo_alternate_outlined,
//                     size: 50,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 32),
              
//               const Text(
//                 'Share Your Story',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
              
//               const SizedBox(height: 12),
              
//               Text(
//                 'Choose a photo to share with your friends',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                   height: 1.5,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
              
//               const SizedBox(height: 48),
              
//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildActionButton(
//                       icon: Icons.photo_library_outlined,
//                       label: 'Gallery',
//                       subtitle: 'Choose from photos',
//                       gradient: LinearGradient(
//                         colors: [Colors.green[400]!, Colors.teal[400]!],
//                       ),
//                       onTap: () => _pickImage(ImageSource.gallery),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: _buildActionButton(
//                       icon: Icons.camera_alt_outlined,
//                       label: 'Camera',
//                       subtitle: 'Take a new photo',
//                       gradient: LinearGradient(
//                         colors: [Colors.orange[400]!, Colors.red[400]!],
//                       ),
//                       onTap: () => _pickImage(ImageSource.camera),
//                     ),
//                   ),
//                 ],
//               ),
              
//               const SizedBox(height: 24),
              
//               // Tips Section
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.blue[100]!),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.lightbulb_outline, color: Colors.blue[600], size: 24),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Pro Tip',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.blue[800],
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Stories disappear after 24 hours. Make them count!',
//                             style: TextStyle(
//                               color: Colors.blue[700],
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required String subtitle,
//     required Gradient gradient,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: gradient,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, color: Colors.white, size: 32),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.9),
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePreviewUI() {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: SingleChildScrollView(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image Preview Card
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(24),
//                   child: Stack(
//                     children: [
//                       AspectRatio(
//                         aspectRatio: 9 / 16,
//                         child: Image.file(
//                           _image!,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                         ),
//                       ),
                      
//                       // Gradient overlay
//                       Positioned.fill(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Colors.transparent,
//                                 Colors.black.withOpacity(0.3),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
                      
//                       // Remove button
//                       Positioned(
//                         top: 16,
//                         right: 16,
//                         child: Material(
//                           color: Colors.black.withOpacity(0.5),
//                           shape: const CircleBorder(),
//                           child: InkWell(
//                             onTap: _removeImage,
//                             customBorder: const CircleBorder(),
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               child: const Icon(
//                                 Icons.close,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 24),
              
//               // Caption Section
//               const Text(
//                 'Add Caption',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
              
//               const SizedBox(height: 12),
              
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _captionController,
//                   focusNode: _captionFocusNode,
//                   maxLines: null,
//                   minLines: 3,
//                   maxLength: 200,
//                   decoration: InputDecoration(
//                     hintText: 'Write a caption for your story...',
//                     hintStyle: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 16,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     fillColor: Colors.transparent,
//                     contentPadding: const EdgeInsets.all(20),
//                     counterStyle: TextStyle(
//                       color: Colors.grey[500],
//                       fontSize: 12,
//                     ),
//                   ),
//                   style: const TextStyle(
//                     fontSize: 16,
//                     height: 1.5,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 24),
              
//               // Story Preview Info
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.amber[50],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.amber[200]!),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.access_time, color: Colors.amber[700], size: 20),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         'Your story will be visible for 24 hours',
//                         style: TextStyle(
//                           color: Colors.amber[800],
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }












import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:provider/provider.dart';

class AddStoryScreen extends StatefulWidget {
  final VoidCallback onStoryAdded;

  const AddStoryScreen({
    Key? key,
    required this.onStoryAdded,
  }) : super(key: key);

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();
  bool _isUploading = false;
  final FocusNode _captionFocusNode = FocusNode();

  @override
  void dispose() {
    _captionController.dispose();
    _captionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      HapticFeedback.mediumImpact();
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      final pickedFile = await storyProvider.pickImage(source);

      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image. Please try again.');
    }
  }

  Future<void> _uploadStory() async {
    if (_image == null) {
      _showErrorSnackBar('Please select an image first');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      HapticFeedback.lightImpact();
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      final success = await storyProvider.postStory(
        _image!,
        _captionController.text.trim(),
      );

      if (success) {
        _showSuccessSnackBar('Story shared successfully!');
        widget.onStoryAdded();
        Navigator.pop(context);
      } else {
        _showErrorSnackBar(storyProvider.error ?? 'Failed to upload story');
      }
    } catch (e) {
      _showErrorSnackBar('Something went wrong. Please try again.');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF388E3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _removeImage() {
    HapticFeedback.lightImpact();
    setState(() {
      _image = null;
      _captionController.clear();
    });
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Choose Photo Source',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text('Choose from your photos'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text('Take a new photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _image == null ? _buildEmptyState() : _buildImagePreview(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close, color: Colors.black87),
      ),
      title: Text(
        _image == null ? 'Create Story' : 'New Story',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      actions: [
        if (_image != null)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _isUploading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: _uploadStory,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Share',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_outlined,
                size: 64,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Create Your Story',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Share a photo or video to let your\nfriends know what you\'re up to',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showImageSourceDialog,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text(
                  'Add Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Stories are visible for 24 hours and can be viewed by your friends',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 500),
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: Image.file(
                    _image!,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: _removeImage,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Caption Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add a caption',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _captionController,
                  focusNode: _captionFocusNode,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText: 'Write something...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1976D2),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    counterStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.amber[800],
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your story will disappear after 24 hours',
                          style: TextStyle(
                            color: Colors.amber[900],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}