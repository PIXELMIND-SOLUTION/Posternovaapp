// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:gal/gal.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/providers/reels/reels_provider.dart';
// import 'package:posternova/views/reels/exo_video_player.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:share_plus/share_plus.dart';

// class ReelsScreen extends StatefulWidget {
//   const ReelsScreen({Key? key}) : super(key: key);

//   @override
//   State<ReelsScreen> createState() => _ReelsScreenState();
// }

// class _ReelsScreenState extends State<ReelsScreen> {
//   String? userId;
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadReels();
//     _pageController.addListener(() {
//       final page = _pageController.page?.round();
//       if (page != null && page != _currentPage) {
//         setState(() => _currentPage = page);
//       }
//     });
//   }

//   Future<void> _loadReels() async {
//     final userData = await AuthPreferences.getUserData();
//     userId = userData?.user.id;
//     if (userId != null && mounted) {
//       Provider.of<ReelProvider>(context, listen: false).fetchAllReels(userId!);
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const AppText(
//           'reels',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Consumer<ReelProvider>(
//         builder: (context, reelProvider, child) {
//           if (reelProvider.isLoading) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 strokeWidth: 2,
//               ),
//             );
//           }
//           if (reelProvider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.error_outline,
//                     color: Colors.white54,
//                     size: 64,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     reelProvider.error!,
//                     style: const TextStyle(color: Colors.white70, fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       if (userId != null) reelProvider.fetchAllReels(userId!);
//                     },
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Retry'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           if (reelProvider.reels.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.movie_outlined,
//                     size: 80,
//                     color: Colors.white.withOpacity(0.3),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No reels yet',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.7),
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Create your first reel',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.5),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return PageView.builder(
//             controller: _pageController,
//             scrollDirection: Axis.vertical,
//             itemCount: reelProvider.reels.length,
//             onPageChanged: (index) {
//               setState(() => _currentPage = index);
//             },
//             itemBuilder: (context, index) {
//               final reel = reelProvider.reels[index];
//               return ReelItem(
//                 key: ValueKey(reel.id),
//                 reel: reel,
//                 userId: userId ?? '',
//                 isCurrentPage: index == _currentPage,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class ReelItem extends StatefulWidget {
//   final dynamic reel;
//   final String userId;
//   final bool isCurrentPage;

//   const ReelItem({
//     Key? key,
//     required this.reel,
//     required this.userId,
//     required this.isCurrentPage,
//   }) : super(key: key);

//   @override
//   State<ReelItem> createState() => _ReelItemState();
// }

// class _ReelItemState extends State<ReelItem>
//     with AutomaticKeepAliveClientMixin {
//   bool _isPlaying = false;
//   bool _showPlayPause = false;
//   String _username = 'Username';
//   String? _profileImage;

//   bool _isDownloading = false;
//   double _downloadProgress = 0.0;

//   String _businessName = 'Business Name';
//   String _phoneNumber = 'Not Set';
//   double _businessNameFontSize = 16.0;
//   double _phoneNumberFontSize = 16.0;

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     _isPlaying = widget.isCurrentPage;
//     _loadUsername();
//     _loadBusinessInfo();
//   }

//   @override
//   void didUpdateWidget(ReelItem oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Critical fix: Update playback state when page changes
//     if (oldWidget.isCurrentPage != widget.isCurrentPage) {
//       _updatePlaybackState();
//     }
//   }

//   void _updatePlaybackState() {
//     setState(() {
//       _isPlaying = widget.isCurrentPage;
//       // Reset play/pause overlay when switching pages
//       _showPlayPause = false;
//     });
//   }

//   @override
//   void dispose() {
//     // Ensure video stops when widget is disposed
//     _isPlaying = false;
//     super.dispose();
//   }

//   Future<void> _loadBusinessInfo() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedName = prefs.getString('business_name');
//       final userData = await AuthPreferences.getUserData();
//       if (mounted) {
//         setState(() {
//           if (savedName != null && savedName.isNotEmpty)
//             _businessName = savedName;
//           if (userData?.user.mobile != null &&
//               userData!.user.mobile!.isNotEmpty) {
//             _phoneNumber = userData.user.mobile!;
//           }
//         });
//       }
//     } catch (e) {
//       debugPrint('Error loading business info: $e');
//     }
//   }

//   Future<void> _saveBusinessName(String name) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('business_name', name);
//   }

//   Future<void> _loadUsername() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData == null || !mounted) return;
//       final userId = userData.user.id;
//       final response = await http.get(
//         Uri.parse('http://31.97.228.17:4061/api/users/get-profile/$userId'),
//         headers: {'Content-Type': 'application/json'},
//       );
//       if (response.statusCode == 200 && mounted) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _username = data['name']?.toString() ?? 'Username';
//           _profileImage = data['profileImage']?.toString();
//         });
//       }
//     } catch (e) {
//       debugPrint('Error loading username: $e');
//     }
//   }

//   void _togglePlayPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       _showPlayPause = true;
//     });
//     Future.delayed(const Duration(milliseconds: 600), () {
//       if (mounted) setState(() => _showPlayPause = false);
//     });
//   }

//   void _toggleLike() async {
//     final reelProvider = Provider.of<ReelProvider>(context, listen: false);
//     final success = await reelProvider.toggleLike(
//       widget.reel.id,
//       widget.userId,
//     );
//     if (!success && mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Failed to update like status'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _shareReel() async {
//     try {
//       final shareText =
//           'Check out this amazing reel!\n${widget.reel.videoUrl}\n\nBy ❤️ using Edit Ezy';
//       await Share.share(shareText, subject: 'Reel from PosterNova');
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to share reel'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _downloadReel() async {
//     if (_isDownloading) return;
//     final hasAccess = await Gal.hasAccess(toAlbum: true);
//     if (!hasAccess) {
//       final granted = await Gal.requestAccess(toAlbum: true);
//       if (!granted) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Gallery permission denied'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//         return;
//       }
//     }
//     setState(() {
//       _isDownloading = true;
//       _downloadProgress = 0.0;
//     });
//     try {
//       final tempDir = await getTemporaryDirectory();
//       final fileName = 'reel_${DateTime.now().millisecondsSinceEpoch}.mp4';
//       final savePath = '${tempDir.path}/$fileName';
//       final dio = Dio();
//       await dio.download(
//         widget.reel.videoUrl,
//         savePath,
//         onReceiveProgress: (received, total) {
//           if (total > 0 && mounted)
//             setState(() => _downloadProgress = received / total);
//         },
//       );
//       await Gal.putVideo(savePath, album: 'EditEzy');
//       final tempFile = File(savePath);
//       if (await tempFile.exists()) await tempFile.delete();
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.white),
//                 SizedBox(width: 8),
//                 Text('Reel saved to gallery!'),
//               ],
//             ),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to download reel'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted)
//         setState(() {
//           _isDownloading = false;
//           _downloadProgress = 0.0;
//         });
//     }
//   }

//   void _showEditDialog({
//     required String title,
//     required String currentValue,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     required Function(String) onSave,
//   }) {
//     final controller = TextEditingController(text: currentValue);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(icon, color: Colors.deepPurple),
//             const SizedBox(width: 12),
//             Text(title),
//           ],
//         ),
//         content: TextField(
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLines: keyboardType == TextInputType.phone ? 1 : null,
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: keyboardType == TextInputType.phone
//                 ? 'Enter phone...'
//                 : 'Enter business name...',
//             border: const OutlineInputBorder(),
//             prefixIcon: Icon(icon),
//             counterText: '',
//           ),
//           maxLength: keyboardType == TextInputType.phone ? 15 : 50,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               onSave(controller.text);
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('$title updated successfully!'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepPurple,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showBottomInfoEditOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setModalState) => Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 margin: const EdgeInsets.only(top: 12, bottom: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               ListTile(
//                 leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.purple.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(Icons.business, color: Colors.purple.shade700),
//                 ),
//                 title: const Text(
//                   'Edit Business Name',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 subtitle: Text(
//                   _businessName,
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//                 trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showEditDialog(
//                     title: 'Edit Name',
//                     currentValue: _businessName,
//                     icon: Icons.business,
//                     onSave: (newValue) async {
//                       await _saveBusinessName(newValue);
//                       setState(() => _businessName = newValue);
//                     },
//                   );
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.purple.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.text_fields,
//                         color: Colors.purple.shade700,
//                         size: 20,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'Name Size: ',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     Expanded(
//                       child: Slider(
//                         value: _businessNameFontSize,
//                         min: 10.0,
//                         max: 24.0,
//                         divisions: 14,
//                         label: '${_businessNameFontSize.round()}',
//                         activeColor: Colors.purple.shade700,
//                         onChanged: (value) {
//                           setState(() => _businessNameFontSize = value);
//                           setModalState(() {});
//                         },
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.purple.shade100,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         '${_businessNameFontSize.round()}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.purple.shade900,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1),
//               ListTile(
//                 leading: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(Icons.phone, color: Colors.blue.shade700),
//                 ),
//                 title: const Text(
//                   'Edit Phone Number',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 subtitle: Text(
//                   _phoneNumber,
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//                 trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showEditDialog(
//                     title: 'Edit Number',
//                     currentValue: _phoneNumber,
//                     icon: Icons.phone,
//                     keyboardType: TextInputType.phone,
//                     onSave: (newValue) =>
//                         setState(() => _phoneNumber = newValue),
//                   );
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.text_fields,
//                         color: Colors.blue.shade700,
//                         size: 20,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     const Text(
//                       'Phone Size: ',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     Expanded(
//                       child: Slider(
//                         value: _phoneNumberFontSize,
//                         min: 10.0,
//                         max: 24.0,
//                         divisions: 14,
//                         label: '${_phoneNumberFontSize.round()}',
//                         activeColor: Colors.blue.shade700,
//                         onChanged: (value) {
//                           setState(() => _phoneNumberFontSize = value);
//                           setModalState(() {});
//                         },
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         '${_phoneNumberFontSize.round()}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue.shade900,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBusinessInfoBar() {
//     return Positioned(
//       left: 0,
//       right: 0,
//       bottom: 0,
//       child: GestureDetector(
//         onTap: _showBottomInfoEditOptions,
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Colors.black.withOpacity(0.8),
//                 Colors.black.withOpacity(0.9),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//             border: Border(
//               top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
//             ),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => _showEditDialog(
//                     title: 'Edit Name',
//                     currentValue: _businessName,
//                     icon: Icons.business,
//                     onSave: (newValue) async {
//                       await _saveBusinessName(newValue);
//                       setState(() => _businessName = newValue);
//                     },
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.purple.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(
//                           Icons.business,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           _businessName,
//                           style: TextStyle(
//                             fontSize: _businessNameFontSize,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 40,
//                 width: 1,
//                 margin: const EdgeInsets.symmetric(horizontal: 15),
//                 color: Colors.white.withOpacity(0.3),
//               ),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => _showEditDialog(
//                     title: 'Edit Number',
//                     currentValue: _phoneNumber,
//                     icon: Icons.phone,
//                     keyboardType: TextInputType.phone,
//                     onSave: (newValue) =>
//                         setState(() => _phoneNumber = newValue),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(
//                           Icons.phone,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           _phoneNumber,
//                           style: TextStyle(
//                             fontSize: _phoneNumberFontSize,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   // Widget build(BuildContext context) {
//   //   super.build(context);
//   //   return GestureDetector(
//   //     behavior: HitTestBehavior.translucent,
//   //     onTap: _togglePlayPause,
//   //     child: Stack(
//   //       fit: StackFit.expand,
//   //       children: [
//   //         // Critical fix: Use a unique key that changes when isCurrentPage changes
//   //         // This forces the video player to rebuild and properly update playback state
//   //         ExoVideoPlayer(
//   //           key: ValueKey('${widget.reel.id}_${widget.isCurrentPage}'),
//   //           url: widget.reel.videoUrl,
//   //           autoPlay: _isPlaying,
//   //         ),
//   //         // Gradient overlay
//   //         Positioned(
//   //           left: 0,
//   //           right: 0,
//   //           bottom: 0,
//   //           child: Container(
//   //             height: 260,
//   //             decoration: BoxDecoration(
//   //               gradient: LinearGradient(
//   //                 begin: Alignment.bottomCenter,
//   //                 end: Alignment.topCenter,
//   //                 colors: [Colors.black.withOpacity(0.9), Colors.transparent],
//   //               ),
//   //             ),
//   //           ),
//   //         ),
//   //         // Play/Pause icon
//   //         if (_showPlayPause)
//   //           Center(
//   //             child: AnimatedOpacity(
//   //               opacity: _showPlayPause ? 1.0 : 0.0,
//   //               duration: const Duration(milliseconds: 300),
//   //               child: Container(
//   //                 padding: const EdgeInsets.all(20),
//   //                 decoration: BoxDecoration(
//   //                   color: Colors.black.withOpacity(0.5),
//   //                   shape: BoxShape.circle,
//   //                 ),
//   //                 child: Icon(
//   //                   _isPlaying ? Icons.pause : Icons.play_arrow,
//   //                   color: Colors.white,
//   //                   size: 50,
//   //                 ),
//   //               ),
//   //             ),
//   //           ),
//   //         // Right side actions
//   //         Positioned(
//   //           right: 12,
//   //           bottom: 145,
//   //           child: Column(
//   //             children: [
//   //               Consumer<ReelProvider>(
//   //                 builder: (context, reelProvider, child) {
//   //                   final currentReel = reelProvider.getReelById(
//   //                     widget.reel.id,
//   //                   );
//   //                   final isLiked = currentReel?.isLiked ?? widget.reel.isLiked;
//   //                   final likeCount =
//   //                       currentReel?.likeCount ?? widget.reel.likeCount;
//   //                   return _ActionButton(
//   //                     icon: isLiked ? Icons.favorite : Icons.favorite_border,
//   //                     iconColor: isLiked ? Colors.red : Colors.white,
//   //                     label: _formatCount(likeCount),
//   //                     onTap: _toggleLike,
//   //                   );
//   //                 },
//   //               ),
//   //               const SizedBox(height: 20),
//   //               _ActionButton(
//   //                 icon: Icons.send_outlined,
//   //                 label: '',
//   //                 onTap: _shareReel,
//   //               ),
//   //               const SizedBox(height: 20),
//   //               _isDownloading
//   //                   ? SizedBox(
//   //                       width: 48,
//   //                       height: 48,
//   //                       child: Stack(
//   //                         alignment: Alignment.center,
//   //                         children: [
//   //                           CircularProgressIndicator(
//   //                             value: _downloadProgress > 0
//   //                                 ? _downloadProgress
//   //                                 : null,
//   //                             color: Colors.white,
//   //                             strokeWidth: 2.5,
//   //                           ),
//   //                           Text(
//   //                             _downloadProgress > 0
//   //                                 ? '${(_downloadProgress * 100).toInt()}%'
//   //                                 : '',
//   //                             style: const TextStyle(
//   //                               color: Colors.white,
//   //                               fontSize: 9,
//   //                               fontWeight: FontWeight.bold,
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     )
//   //                   : _ActionButton(
//   //                       icon: Icons.download_outlined,
//   //                       label: '',
//   //                       onTap: _downloadReel,
//   //                     ),
//   //             ],
//   //           ),
//   //         ),
//   //         // Bottom left: user info
//   //         Positioned(
//   //           left: 16,
//   //           right: 80,
//   //           bottom: 80,
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Row(
//   //                 children: [
//   //                   Container(
//   //                     width: 32,
//   //                     height: 32,
//   //                     decoration: BoxDecoration(
//   //                       shape: BoxShape.circle,
//   //                       border: Border.all(color: Colors.white, width: 1),
//   //                       color: Colors.grey[800],
//   //                     ),
//   //                     child: _profileImage != null && _profileImage!.isNotEmpty
//   //                         ? ClipOval(
//   //                             child: Image.network(
//   //                               _profileImage!,
//   //                               width: 32,
//   //                               height: 32,
//   //                               fit: BoxFit.cover,
//   //                               errorBuilder: (_, __, ___) => const Icon(
//   //                                 Icons.person,
//   //                                 color: Colors.white,
//   //                                 size: 18,
//   //                               ),
//   //                             ),
//   //                           )
//   //                         : const Icon(
//   //                             Icons.person,
//   //                             color: Colors.white,
//   //                             size: 18,
//   //                           ),
//   //                   ),
//   //                   const SizedBox(width: 8),
//   //                   AppText(
//   //                     _username,
//   //                     style: const TextStyle(
//   //                       color: Colors.white,
//   //                       fontWeight: FontWeight.w600,
//   //                       fontSize: 14,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //               const SizedBox(height: 8),
//   //               const AppText(
//   //                 'amazing_video_editezy',
//   //                 style: TextStyle(color: Colors.white, fontSize: 14),
//   //                 maxLines: 2,
//   //                 overflow: TextOverflow.ellipsis,
//   //               ),
//   //               const SizedBox(height: 6),
//   //               Row(
//   //                 children: [
//   //                   const Icon(Icons.music_note, color: Colors.white, size: 14),
//   //                   const SizedBox(width: 4),
//   //                   Expanded(
//   //                     child: Text(
//   //                       'Original Audio',
//   //                       style: TextStyle(
//   //                         color: Colors.white.withOpacity(0.8),
//   //                         fontSize: 12,
//   //                       ),
//   //                       overflow: TextOverflow.ellipsis,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //         _buildBusinessInfoBar(),
//   //       ],
//   //     ),
//   //   );
//   // }
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         // Video player
//         ExoVideoPlayer(
//           key: ValueKey('${widget.reel.id}_${widget.isCurrentPage}'),
//           url: widget.reel.videoUrl,
//           autoPlay: _isPlaying,
//         ),

//         // Gradient overlay
//         Positioned(
//           left: 0,
//           right: 0,
//           bottom: 0,
//           child: Container(
//             height: 260,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//                 colors: [Colors.black.withOpacity(0.9), Colors.transparent],
//               ),
//             ),
//           ),
//         ),

//         // ✅ FULL SCREEN TAP DETECTOR (but doesn't block buttons)
//         Positioned.fill(
//           child: GestureDetector(
//             behavior: HitTestBehavior.translucent,
//             onTap: _togglePlayPause,
//           ),
//         ),

//         // Play/Pause icon
//         if (_showPlayPause)
//           Center(
//             child: AnimatedOpacity(
//               opacity: _showPlayPause ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 300),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.5),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   color: Colors.white,
//                   size: 50,
//                 ),
//               ),
//             ),
//           ),

//         // Right side actions (these will be above the tap detector)
//         Positioned(
//           right: 12,
//           bottom: 145,
//           child: Column(
//             children: [
//               Consumer<ReelProvider>(
//                 builder: (context, reelProvider, child) {
//                   final currentReel = reelProvider.getReelById(widget.reel.id);
//                   final isLiked = currentReel?.isLiked ?? widget.reel.isLiked;
//                   final likeCount =
//                       currentReel?.likeCount ?? widget.reel.likeCount;
//                   return _ActionButton(
//                     icon: isLiked ? Icons.favorite : Icons.favorite_border,
//                     iconColor: isLiked ? Colors.red : Colors.white,
//                     label: _formatCount(likeCount),
//                     onTap: _toggleLike,
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),
//               _ActionButton(
//                 icon: Icons.send_outlined,
//                 label: '',
//                 onTap: _shareReel,
//               ),
//               const SizedBox(height: 20),
//               _isDownloading
//                   ? SizedBox(
//                       width: 48,
//                       height: 48,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           CircularProgressIndicator(
//                             value: _downloadProgress > 0
//                                 ? _downloadProgress
//                                 : null,
//                             color: Colors.white,
//                             strokeWidth: 2.5,
//                           ),
//                           Text(
//                             _downloadProgress > 0
//                                 ? '${(_downloadProgress * 100).toInt()}%'
//                                 : '',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : _ActionButton(
//                       icon: Icons.download_outlined,
//                       label: '',
//                       onTap: _downloadReel,
//                     ),
//             ],
//           ),
//         ),

//         // Bottom left: user info
//         Positioned(
//           left: 16,
//           right: 80,
//           bottom: 80,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 1),
//                       color: Colors.grey[800],
//                     ),
//                     child: _profileImage != null && _profileImage!.isNotEmpty
//                         ? ClipOval(
//                             child: Image.network(
//                               _profileImage!,
//                               width: 32,
//                               height: 32,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => const Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                           )
//                         : const Icon(
//                             Icons.person,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                   ),
//                   const SizedBox(width: 8),
//                   AppText(
//                     _username,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               const AppText(
//                 'amazing_video_editezy',
//                 style: TextStyle(color: Colors.white, fontSize: 14),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 6),
//               Row(
//                 children: [
//                   const Icon(Icons.music_note, color: Colors.white, size: 14),
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: Text(
//                       'Original Audio',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 12,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),

//         // Business info bar (bottom)
//         _buildBusinessInfoBar(),
//       ],
//     );
//   }

//   void _showOptionsBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF262626),
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 8),
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey[600],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 16),
//             _BottomSheetOption(
//               icon: Icons.share_outlined,
//               label: 'Share to...',
//               onTap: () {
//                 Navigator.pop(context);
//                 _shareReel();
//               },
//             ),
//             _BottomSheetOption(
//               icon: Icons.download_outlined,
//               label: 'Save to gallery',
//               onTap: () {
//                 Navigator.pop(context);
//                 _downloadReel();
//               },
//             ),
//             _BottomSheetOption(
//               icon: Icons.edit_outlined,
//               label: 'Edit business info',
//               onTap: () {
//                 Navigator.pop(context);
//                 _showBottomInfoEditOptions();
//               },
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatCount(int count) {
//     if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
//     if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
//     return count.toString();
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//   final Color? iconColor;

//   const _ActionButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//     this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.black.withOpacity(0.3),
//             ),
//             child: Icon(icon, color: iconColor ?? Colors.white, size: 28),
//           ),
//           if (label.isNotEmpty) ...[
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class _BottomSheetOption extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   const _BottomSheetOption({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 24),
//             const SizedBox(width: 16),
//             Text(
//               label,
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///////////////////////// New code added for showing the download animation with logo/////////////////

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/reels/reels_provider.dart';
import 'package:posternova/views/reels/exo_video_player.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({Key? key}) : super(key: key);

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  String? userId;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadReels();
    _pageController.addListener(() {
      final page = _pageController.page?.round();
      if (page != null && page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  Future<void> _loadReels() async {
    final userData = await AuthPreferences.getUserData();
    userId = userData?.user.id;
    if (userId != null && mounted) {
      Provider.of<ReelProvider>(context, listen: false).fetchAllReels(userId!);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //    Future<void> _showExitDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: const Color(0xFF1E1E1E),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       title: const Text(
  //         'Exit?',
  //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //       ),
  //       content: const Text(
  //         'Are you sure you want to exit?',
  //         style: TextStyle(color: Colors.white70),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context); // close dialog
  //             Navigator.pop(context); // exit screen
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.redAccent,
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //           ),
  //           child: const Text('Exit', style: TextStyle(color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _showExitDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Exit?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to exit?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Exit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const AppText(
            'reels',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Consumer<ReelProvider>(
          builder: (context, reelProvider, child) {
            if (reelProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              );
            }
            if (reelProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white54,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      reelProvider.error!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (userId != null) reelProvider.fetchAllReels(userId!);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (reelProvider.reels.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_outlined,
                      size: 80,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reels yet',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your first reel',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: reelProvider.reels.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final reel = reelProvider.reels[index];
                return ReelItem(
                  key: ValueKey(reel.id),
                  reel: reel,
                  userId: userId ?? '',
                  isCurrentPage: index == _currentPage,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DownloadOverlay extends StatefulWidget {
  final double progress;

  const _DownloadOverlay({required this.progress});

  @override
  State<_DownloadOverlay> createState() => _DownloadOverlayState();
}

class _DownloadOverlayState extends State<_DownloadOverlay>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _orbitController;
  late AnimationController _shimmerController;

  late Animation<double> _pulse;
  late Animation<double> _shimmer;

  static const Color _tealDark = Color(0xFF0077A8);
  static const Color _tealLight = Color(0xFF00BCD4);
  static const Color _accent = Color(0xFF00E5FF);

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _pulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    _orbitController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Widget _buildOrbitDot(double angle, Color color, double size) {
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (_, __) {
        final computedAngle = angle + (_orbitController.value * 2 * math.pi);
        const radius = 52.0;
        final dx = math.cos(computedAngle) * radius;
        final dy = math.sin(computedAngle) * radius;
        return Transform.translate(
          offset: Offset(dx, dy),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.8), blurRadius: 6),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final percent = (widget.progress * 100).toInt();

    return Container(
      color: Colors.black.withOpacity(0.82),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer rotating ring
                  AnimatedBuilder(
                    animation: _rotateController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: _rotateController.value * 2 * math.pi,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.transparent, width: 0),
                        gradient: const SweepGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            _tealLight,
                            _accent,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.4, 0.6, 0.75, 1.0],
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // Reverse rotating inner ring
                  AnimatedBuilder(
                    animation: _rotateController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: -_rotateController.value * 2 * math.pi * 1.5,
                        child: child,
                      );
                    },
                    child: Container(
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const SweepGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            _tealDark,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.5, 0.65, 1.0],
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // Orbit dots
                  _buildOrbitDot(0.0, _accent, 7),
                  _buildOrbitDot(math.pi * 2 / 3, _tealLight, 5),
                  _buildOrbitDot(math.pi * 4 / 3, _tealDark, 6),

                  // Pulse glow behind logo
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) {
                      return Container(
                        width: 90 * _pulse.value,
                        height: 90 * _pulse.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _tealLight.withOpacity(0.35),
                              blurRadius: 24,
                              spreadRadius: 8,
                            ),
                            BoxShadow(
                              color: _accent.withOpacity(0.2),
                              blurRadius: 40,
                              spreadRadius: 14,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Logo with shimmer
                  AnimatedBuilder(
                    animation: _shimmer,
                    builder: (_, child) {
                      return ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: const [
                              Colors.white,
                              Colors.white,
                              Color(0xFFB2EBF2),
                              Colors.white,
                              Colors.white,
                            ],
                            stops: [
                              0.0,
                              (_shimmer.value - 0.3).clamp(0.0, 1.0),
                              _shimmer.value.clamp(0.0, 1.0),
                              (_shimmer.value + 0.3).clamp(0.0, 1.0),
                              1.0,
                            ],
                          ).createShader(bounds);
                        },
                        child: child!,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/mainlogo.jpeg',
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [_tealDark, _tealLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Progress Arc + Percentage ────────────────────────
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(80, 80),
                    painter: _ArcProgressPainter(
                      progress: widget.progress,
                      trackColor: Colors.white12,
                      progressColor: _tealLight,
                      glowColor: _accent,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Label ────────────────────────────────────────────
            _AnimatedDownloadLabel(),

            const SizedBox(height: 8),

            Text(
              'Saving to gallery…',
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final Color glowColor;

  _ArcProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const startAngle = -math.pi / 2;
    const fullSweep = 2 * math.pi;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Glow
    final glowPaint = Paint()
      ..color = glowColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep * progress,
      false,
      glowPaint,
    );

    // Progress arc
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + fullSweep * progress,
        colors: [progressColor, glowColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ArcProgressPainter old) => old.progress != progress;
}

class _AnimatedDownloadLabel extends StatefulWidget {
  @override
  State<_AnimatedDownloadLabel> createState() => _AnimatedDownloadLabelState();
}

class _AnimatedDownloadLabelState extends State<_AnimatedDownloadLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _wave;
  final String _label = 'Downloading';

  static const Color _tealLight = Color(0xFF00BCD4);
  static const Color _accent = Color(0xFF00E5FF);
  static const Color _tealDark = Color(0xFF0077A8);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _wave = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _wave,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...List.generate(_label.length, (i) {
              final offset =
                  math.sin((_wave.value * 2 * math.pi) + (i * 0.45)) * 4.0;
              final t =
                  (math.sin((_wave.value * 2 * math.pi) + (i * 0.5)) + 1) / 2;
              final color = Color.lerp(_tealDark, _accent, t) ?? _tealLight;
              return Transform.translate(
                offset: Offset(0, offset),
                child: Text(
                  _label[i],
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            }),
            // Animated dots
            ...List.generate(3, (i) {
              final dotPhase = (_wave.value * 3 - i).floor() % 3 == 0;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: dotPhase ? 5 : 0,
                  left: i == 0 ? 2 : 1,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotPhase ? _accent : Colors.white.withOpacity(0.3),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// ReelItem
// ──────────────────────────────────────────────────────────────────────────────

class ReelItem extends StatefulWidget {
  final dynamic reel;
  final String userId;
  final bool isCurrentPage;

  const ReelItem({
    Key? key,
    required this.reel,
    required this.userId,
    required this.isCurrentPage,
  }) : super(key: key);

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem>
    with AutomaticKeepAliveClientMixin {
  bool _isPlaying = false;
  bool _showPlayPause = false;
  String _username = 'Username';
  String? _profileImage;

  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  String _businessName = 'Business Name';
  String _phoneNumber = 'Not Set';
  double _businessNameFontSize = 16.0;
  double _phoneNumberFontSize = 16.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isCurrentPage;
    _loadUsername();
    _loadBusinessInfo();
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCurrentPage != widget.isCurrentPage) {
      _updatePlaybackState();
    }
  }

  void _updatePlaybackState() {
    setState(() {
      _isPlaying = widget.isCurrentPage;
      _showPlayPause = false;
    });
  }

  @override
  void dispose() {
    _isPlaying = false;
    super.dispose();
  }

  Future<void> _loadBusinessInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('business_name');
      final userData = await AuthPreferences.getUserData();
      if (mounted) {
        setState(() {
          if (savedName != null && savedName.isNotEmpty)
            _businessName = savedName;
          if (userData?.user.mobile != null &&
              userData!.user.mobile!.isNotEmpty) {
            _phoneNumber = userData.user.mobile!;
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading business info: $e');
    }
  }

  Future<void> _saveBusinessName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('business_name', name);
  }

  Future<void> _loadUsername() async {
    try {
      final userData = await AuthPreferences.getUserData();
      if (userData == null || !mounted) return;
      final userId = userData.user.id;
      final response = await http.get(
        Uri.parse('http://31.97.228.17:4061/api/users/get-profile/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);
        setState(() {
          _username = data['name']?.toString() ?? 'Username';
          _profileImage = data['profileImage']?.toString();
        });
      }
    } catch (e) {
      debugPrint('Error loading username: $e');
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      _showPlayPause = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showPlayPause = false);
    });
  }

  void _toggleLike() async {
    final reelProvider = Provider.of<ReelProvider>(context, listen: false);
    final success = await reelProvider.toggleLike(
      widget.reel.id,
      widget.userId,
    );
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update like status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _shareReel() async {
    try {
      final shareText =
          'Check out this amazing reel!\n${widget.reel.videoUrl}\n\nBy ❤️ using Edit Ezy';
      await Share.share(shareText, subject: 'Reel from PosterNova');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share reel'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _downloadReel() async {
    if (_isDownloading) return;
    final hasAccess = await Gal.hasAccess(toAlbum: true);
    if (!hasAccess) {
      final granted = await Gal.requestAccess(toAlbum: true);
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gallery permission denied'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = 'reel_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final savePath = '${tempDir.path}/$fileName';
      final dio = Dio();
      await dio.download(
        widget.reel.videoUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => _downloadProgress = received / total);
          }
        },
      );
      await Gal.putVideo(savePath, album: 'EditEzy');
      final tempFile = File(savePath);
      if (await tempFile.exists()) await tempFile.delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Reel saved to gallery!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download reel'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
        });
      }
    }
  }

  void _showEditDialog({
    required String title,
    required String currentValue,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onSave,
  }) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: keyboardType == TextInputType.phone ? 1 : null,
          autofocus: true,
          decoration: InputDecoration(
            hintText: keyboardType == TextInputType.phone
                ? 'Enter phone...'
                : 'Enter business name...',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(icon),
            counterText: '',
          ),
          maxLength: keyboardType == TextInputType.phone ? 15 : 50,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showBottomInfoEditOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.business, color: Colors.purple.shade700),
                ),
                title: const Text(
                  'Edit Business Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _businessName,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(
                    title: 'Edit Name',
                    currentValue: _businessName,
                    icon: Icons.business,
                    onSave: (newValue) async {
                      await _saveBusinessName(newValue);
                      setState(() => _businessName = newValue);
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.text_fields,
                        color: Colors.purple.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Name Size: ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Slider(
                        value: _businessNameFontSize,
                        min: 10.0,
                        max: 24.0,
                        divisions: 14,
                        label: '${_businessNameFontSize.round()}',
                        activeColor: Colors.purple.shade700,
                        onChanged: (value) {
                          setState(() => _businessNameFontSize = value);
                          setModalState(() {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${_businessNameFontSize.round()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.phone, color: Colors.blue.shade700),
                ),
                title: const Text(
                  'Edit Phone Number',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _phoneNumber,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(
                    title: 'Edit Number',
                    currentValue: _phoneNumber,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onSave: (newValue) =>
                        setState(() => _phoneNumber = newValue),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.text_fields,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Phone Size: ',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Slider(
                        value: _phoneNumberFontSize,
                        min: 10.0,
                        max: 24.0,
                        divisions: 14,
                        label: '${_phoneNumberFontSize.round()}',
                        activeColor: Colors.blue.shade700,
                        onChanged: (value) {
                          setState(() => _phoneNumberFontSize = value);
                          setModalState(() {});
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${_phoneNumberFontSize.round()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessInfoBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: _showBottomInfoEditOptions,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEditDialog(
                    title: 'Edit Name',
                    currentValue: _businessName,
                    icon: Icons.business,
                    onSave: (newValue) async {
                      await _saveBusinessName(newValue);
                      setState(() => _businessName = newValue);
                    },
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _businessName,
                          style: TextStyle(
                            fontSize: _businessNameFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEditDialog(
                    title: 'Edit Number',
                    currentValue: _phoneNumber,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onSave: (newValue) =>
                        setState(() => _phoneNumber = newValue),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _phoneNumber,
                          style: TextStyle(
                            fontSize: _phoneNumberFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player
        ExoVideoPlayer(
          key: ValueKey('${widget.reel.id}_${widget.isCurrentPage}'),
          url: widget.reel.videoUrl,
          autoPlay: _isPlaying,
        ),

        // Gradient overlay
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.9), Colors.transparent],
              ),
            ),
          ),
        ),

        // Full-screen tap detector (doesn't block buttons)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _togglePlayPause,
          ),
        ),

        // Play/Pause icon
        if (_showPlayPause)
          Center(
            child: AnimatedOpacity(
              opacity: _showPlayPause ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),

        // Right side actions
        Positioned(
          right: 12,
          bottom: 145,
          child: Column(
            children: [
              Consumer<ReelProvider>(
                builder: (context, reelProvider, child) {
                  final currentReel = reelProvider.getReelById(widget.reel.id);
                  final isLiked = currentReel?.isLiked ?? widget.reel.isLiked;
                  final likeCount =
                      currentReel?.likeCount ?? widget.reel.likeCount;
                  return _ActionButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    iconColor: isLiked ? Colors.red : Colors.white,
                    label: _formatCount(likeCount),
                    onTap: _toggleLike,
                  );
                },
              ),
              const SizedBox(height: 20),
              _ActionButton(
                icon: Icons.send_outlined,
                label: '',
                onTap: _shareReel,
              ),
              const SizedBox(height: 20),
              // Download button — always visible; overlay covers screen
              _ActionButton(
                icon: Icons.download_outlined,
                label: '',
                onTap: _downloadReel,
              ),
            ],
          ),
        ),

        // Bottom left: user info
        Positioned(
          left: 16,
          right: 80,
          bottom: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                      color: Colors.grey[800],
                    ),
                    child: _profileImage != null && _profileImage!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              _profileImage!,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          ),
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    _username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const AppText(
                'amazing_video_editezy',
                style: TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Original Audio',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Business info bar (bottom)
        _buildBusinessInfoBar(),

        // ── Animated Download Overlay ──────────────────────────
        if (_isDownloading)
          Positioned.fill(child: _DownloadOverlay(progress: _downloadProgress)),
      ],
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF262626),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _BottomSheetOption(
              icon: Icons.share_outlined,
              label: 'Share to...',
              onTap: () {
                Navigator.pop(context);
                _shareReel();
              },
            ),
            _BottomSheetOption(
              icon: Icons.download_outlined,
              label: 'Save to gallery',
              onTap: () {
                Navigator.pop(context);
                _downloadReel();
              },
            ),
            _BottomSheetOption(
              icon: Icons.edit_outlined,
              label: 'Edit business info',
              onTap: () {
                Navigator.pop(context);
                _showBottomInfoEditOptions();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Shared widgets
// ──────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
            ),
            child: Icon(icon, color: iconColor ?? Colors.white, size: 28),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BottomSheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomSheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
