// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:posternova/providers/story/story_provider.dart';
// import 'package:posternova/widgets/language_widget.dart';
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

// class _AddStoryScreenState extends State<AddStoryScreen> {
//   File? _image;
//   final TextEditingController _captionController = TextEditingController();
//   bool _isUploading = false;
//   final FocusNode _captionFocusNode = FocusNode();

//   @override
//   void dispose() {
//     _captionController.dispose();
//     _captionFocusNode.dispose();
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
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color(0xFFD32F2F),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: const Color(0xFF388E3C),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   void _removeImage() {
//     HapticFeedback.lightImpact();
//     setState(() {
//       _image = null;
//       _captionController.clear();
//     });
//   }

//   void _showImageSourceDialog() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Choose Photo Source',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ListTile(
//                   leading: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1976D2).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.photo_library,
//                       color: Color(0xFF1976D2),
//                     ),
//                   ),
//                   title: const Text(
//                     'Gallery',
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   subtitle: const Text('Choose from your photos'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickImage(ImageSource.gallery);
//                   },
//                 ),
//                 ListTile(
//                   leading: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1976D2).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.camera_alt,
//                       color: Color(0xFF1976D2),
//                     ),
//                   ),
//                   title: const Text(
//                     'Camera',
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   subtitle: const Text('Take a new photo'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _pickImage(ImageSource.camera);
//                   },
//                 ),
//                 const SizedBox(height: 10),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: _image == null ? _buildEmptyState() : _buildImagePreview(),
//     );
//   }

//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       surfaceTintColor: Colors.white,
//       leading: IconButton(
//         onPressed: () => Navigator.pop(context),
//         icon: const Icon(Icons.close, color: Colors.black87),
//       ),
//       title: AppText(
//         _image == null ? 'create_story' : 'new_story',
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: Colors.black87,
//         ),
//       ),
//       centerTitle: true,
//       actions: [
//         if (_image != null)
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: _isUploading
//                 ? const Center(
//                     child: SizedBox(
//                       width: 24,
//                       height: 24,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   )
//                 : TextButton(
//                     onPressed: _uploadStory,
//                     style: TextButton.styleFrom(
//                       backgroundColor: const Color(0xFF1976D2),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     child: const Text(
//                       'Share',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),
//           ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 140,
//               height: 140,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1976D2).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.add_photo_alternate_outlined,
//                 size: 64,
//                 color: Color(0xFF1976D2),
//               ),
//             ),
//             const SizedBox(height: 32),
//             const AppText(
//               'create_your_story',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 12),
//             AppText(
//               'share_story_prompt',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: Colors.grey[600],
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 48),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _showImageSourceDialog,
//                 icon: const Icon(Icons.add_photo_alternate),
//                 label: const AppText(
//                   'add_photo',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1976D2),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey[200]!),
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.info_outline,
//                     color: Colors.grey[600],
//                     size: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: AppText(
//                       'story_visible_24h',
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontSize: 13,
//                         height: 1.4,
//                       ),
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

//   Widget _buildImagePreview() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image Container
//           Container(
//             width: double.infinity,
//             constraints: const BoxConstraints(maxHeight: 500),
//             color: Colors.black,
//             child: Stack(
//               children: [
//                 Center(
//                   child: Image.file(
//                     _image!,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//                 Positioned(
//                   top: 16,
//                   right: 16,
//                   child: IconButton(
//                     onPressed: _removeImage,
//                     icon: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.6),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Caption Section
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const AppText(
//                   'add_caption',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: _captionController,
//                   focusNode: _captionFocusNode,
//                   maxLines: 3,
//                   maxLength: 200,
//                   decoration: InputDecoration(
//                     hintText: 'Write something...',
//                     hintStyle: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 15,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                         color: Color(0xFF1976D2),
//                         width: 2,
//                       ),
//                     ),
//                     contentPadding: const EdgeInsets.all(16),
//                     counterStyle: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12,
//                     ),
//                   ),
//                   style: const TextStyle(
//                     fontSize: 15,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.amber[50],
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.amber[200]!),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.access_time,
//                         color: Colors.amber[800],
//                         size: 18,
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: AppText(
//                           'story_disappear_24h',
//                           style: TextStyle(
//                             color: Colors.amber[900],
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';

class AddStoryScreen extends StatefulWidget {
  final VoidCallback onStoryAdded;

  const AddStoryScreen({Key? key, required this.onStoryAdded})
    : super(key: key);

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  File? _mediaFile;
  bool _isVideo = false;
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
          _mediaFile = pickedFile;
          _isVideo = false;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image. Please try again.');
    }
  }

  Future<void> _pickVideo() async {
    try {
      HapticFeedback.mediumImpact();
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      final pickedFile = await storyProvider.pickVideo();

      if (pickedFile != null) {
        setState(() {
          _mediaFile = pickedFile;
          _isVideo = true;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick video. Please try again.');
    }
  }

  Future<void> _uploadStory() async {
    if (_mediaFile == null) {
      _showErrorSnackBar('Please select a media file first');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      HapticFeedback.lightImpact();
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      final success = await storyProvider.postStory(
        _mediaFile!,
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
              child: Text(message, style: const TextStyle(fontSize: 14)),
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
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 14)),
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

  void _removeMedia() {
    HapticFeedback.lightImpact();
    setState(() {
      _mediaFile = null;
      _isVideo = false;
      _captionController.clear();
    });
  }

  void _showMediaSourceDialog() {
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
                  'Choose Media Source',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.video_library,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  title: const Text(
                    'Video',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text('Choose a video from gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideo();
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
      body: _mediaFile == null ? _buildEmptyState() : _buildMediaPreview(),
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
      title: AppText(
        _mediaFile == null ? 'create_story' : 'new_story',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
      actions: [
        if (_mediaFile != null)
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
            const AppText(
              'create_your_story',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            AppText(
              'share_story_prompt',
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
                onPressed: _showMediaSourceDialog,
                icon: const Icon(Icons.add_photo_alternate),
                label: const AppText(
                  'add_photo_video',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      'story_visible_24h',
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

  Widget _buildMediaPreview() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media Container
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 500),
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: _isVideo
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_circle_filled,
                                color: Colors.white,
                                size: 64,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Video selected',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : Image.file(_mediaFile!, fit: BoxFit.contain),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: _removeMedia,
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
                if (_isVideo)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.videocam, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Video',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
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
                const AppText(
                  'add_caption',
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
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
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
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
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
                        child: AppText(
                          'story_disappear_24h',
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
