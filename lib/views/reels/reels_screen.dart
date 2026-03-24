// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:gal/gal.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/providers/reels/reels_provider.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
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
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
//             onPressed: () {
//               // Navigate to create reel
//             },
//           ),
//         ],
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
//                       if (userId != null) {
//                         reelProvider.fetchAllReels(userId!);
//                       }
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
//               setState(() {
//                 _currentPage = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               final reel = reelProvider.reels[index];
//               return ReelItem(
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

// class _ReelItemState extends State<ReelItem> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _showPlayPause = false;
//   String _username = 'Username';
//   String? _profileImage;

//   // Download state
//   bool _isDownloading = false;
//   double _downloadProgress = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//     _loadUsername();
//   }

//   Future<void> _loadUsername() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData == null || !mounted) return;

//       final userId = userData.user.id;
//       final response = await http.get(
//         Uri.parse('http://31.97.206.144:4061/api/users/get-profile/$userId'),
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
//       print('Error loading username: $e');
//     }
//   }

//   @override
//   void didUpdateWidget(ReelItem oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.isCurrentPage && !_controller.value.isPlaying) {
//       _controller.play();
//     } else if (!widget.isCurrentPage && _controller.value.isPlaying) {
//       _controller.pause();
//     }
//   }

//   void _initializeVideo() {
//     _controller = VideoPlayerController.network(widget.reel.videoUrl)
//       ..initialize()
//           .then((_) {
//             if (mounted) {
//               setState(() {
//                 _isInitialized = true;
//               });
//               if (widget.isCurrentPage) {
//                 _controller.play();
//               }
//               _controller.setLooping(true);
//             }
//           })
//           .catchError((error) {
//             print('Error initializing video: $error');
//           });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//         _showPlayPause = true;
//       } else {
//         _controller.play();
//         _showPlayPause = true;
//       }
//     });

//     Future.delayed(const Duration(milliseconds: 600), () {
//       if (mounted) {
//         setState(() {
//           _showPlayPause = false;
//         });
//       }
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
//           duration: Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   void _shareReel() async {
//     try {
//       final shareText =
//           'Check out this amazing reel!\n'
//           '${widget.reel.videoUrl}\n\n'
//           'By ❤️ using Edit Ezy';

//       await Share.share(shareText, subject: 'Reel from PosterNova');
//     } catch (e) {
//       print('Error sharing reel: $e');
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

//   /// ─── DOWNLOAD REEL ───────────────────────────────────────────────────────
//   Future<void> _downloadReel() async {
//     if (_isDownloading) return;

//     // Check / request gallery permission
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
//       // Save to a temp file first
//       final tempDir = await getTemporaryDirectory();
//       final fileName = 'reel_${DateTime.now().millisecondsSinceEpoch}.mp4';
//       final savePath = '${tempDir.path}/$fileName';

//       final dio = Dio();
//       await dio.download(
//         widget.reel.videoUrl,
//         savePath,
//         onReceiveProgress: (received, total) {
//           if (total > 0 && mounted) {
//             setState(() {
//               _downloadProgress = received / total;
//             });
//           }
//         },
//       );

//       // Save the file to the device gallery
//       await Gal.putVideo(savePath, album: 'EditEzy');

//       // Clean up temp file
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
//       print('Error downloading reel: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to download reel'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isDownloading = false;
//           _downloadProgress = 0.0;
//         });
//       }
//     }
//   }
//   // ─────────────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Video player
//           if (_isInitialized)
//             Center(
//               child: AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               ),
//             )
//           else
//             Container(
//               color: Colors.black,
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               ),
//             ),

//           // Gradient overlay at bottom
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [Colors.black.withOpacity(0.8), Colors.transparent],
//                 ),
//               ),
//             ),
//           ),

//           // Play/Pause indicator
//           if (_showPlayPause)
//             Center(
//               child: AnimatedOpacity(
//                 opacity: _showPlayPause ? 1.0 : 0.0,
//                 duration: const Duration(milliseconds: 300),
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     _controller.value.isPlaying
//                         ? Icons.play_arrow
//                         : Icons.pause,
//                     color: Colors.white,
//                     size: 50,
//                   ),
//                 ),
//               ),
//             ),

//           // Right side actions
//           Positioned(
//             right: 12,
//             bottom: 100,
//             child: Column(
//               children: [
//                 // Like button
//                 Consumer<ReelProvider>(
//                   builder: (context, reelProvider, child) {
//                     final currentReel = reelProvider.getReelById(
//                       widget.reel.id,
//                     );
//                     final isLiked = currentReel?.isLiked ?? widget.reel.isLiked;
//                     final likeCount =
//                         currentReel?.likeCount ?? widget.reel.likeCount;

//                     return _ActionButton(
//                       icon: isLiked ? Icons.favorite : Icons.favorite_border,
//                       iconColor: isLiked ? Colors.red : Colors.white,
//                       label: _formatCount(likeCount),
//                       onTap: _toggleLike,
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Share button
//                 _ActionButton(
//                   icon: Icons.send_outlined,
//                   label: '',
//                   onTap: _shareReel,
//                 ),
//                 const SizedBox(height: 20),

//                 // ── Download button ──────────────────────────────────────
//                 _isDownloading
//                     ? SizedBox(
//                         width: 48,
//                         height: 48,
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             CircularProgressIndicator(
//                               value: _downloadProgress > 0
//                                   ? _downloadProgress
//                                   : null,
//                               color: Colors.white,
//                               strokeWidth: 2.5,
//                             ),
//                             Text(
//                               _downloadProgress > 0
//                                   ? '${(_downloadProgress * 100).toInt()}%'
//                                   : '',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : _ActionButton(
//                         icon: Icons.download_outlined,
//                         label: '',
//                         onTap: _downloadReel,
//                       ),
//                 // ────────────────────────────────────────────────────────
//                 const SizedBox(height: 20),

//                 // More options
//                 _ActionButton(
//                   icon: Icons.more_vert,
//                   label: '',
//                   onTap: () {
//                     _showOptionsBottomSheet(context);
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Bottom info section
//           Positioned(
//             left: 16,
//             right: 80,
//             bottom: 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // User info
//                 Row(
//                   children: [
//                     Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 1),
//                         color: Colors.grey[800],
//                       ),
//                       child: _profileImage != null && _profileImage!.isNotEmpty
//                           ? ClipOval(
//                               child: Image.network(
//                                 _profileImage!,
//                                 width: 32,
//                                 height: 32,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return const Icon(
//                                     Icons.person,
//                                     color: Colors.white,
//                                     size: 18,
//                                   );
//                                 },
//                               ),
//                             )
//                           : const Icon(
//                               Icons.person,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                     ),
//                     const SizedBox(width: 8),
//                     AppText(
//                       _username,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Caption
//                 const AppText(
//                   'amazing_video_editezy',
//                   style: TextStyle(color: Colors.white, fontSize: 14),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),

//                 // Audio
//                 Row(
//                   children: [
//                     const Icon(Icons.music_note, color: Colors.white, size: 14),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         'Original Audio',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 12,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
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
//             // ── Download option in bottom sheet ──────────────────────────
//             _BottomSheetOption(
//               icon: Icons.download_outlined,
//               label: 'Save to gallery',
//               onTap: () {
//                 Navigator.pop(context);
//                 _downloadReel();
//               },
//             ),
//             // ─────────────────────────────────────────────────────────────
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatCount(int count) {
//     if (count >= 1000000) {
//       return '${(count / 1000000).toStringAsFixed(1)}M';
//     } else if (count >= 1000) {
//       return '${(count / 1000).toStringAsFixed(1)}K';
//     }
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

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/reels/reels_provider.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            onPressed: () {
              // Navigate to create reel
            },
          ),
        ],
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
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (userId != null) {
                        reelProvider.fetchAllReels(userId!);
                      }
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
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final reel = reelProvider.reels[index];
              return ReelItem(
                reel: reel,
                userId: userId ?? '',
                isCurrentPage: index == _currentPage,
              );
            },
          );
        },
      ),
    );
  }
}

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

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  bool _isInitialized = false;
  bool _showPlayPause = false;
  String _username = 'Username';
  String? _profileImage;

  // Download state
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  // Business info state
  String _businessName = 'Business Name';
  String _phoneNumber = 'Not Set';
  double _businessNameFontSize = 16.0;
  double _phoneNumberFontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _loadUsername();
    _loadBusinessInfo();
  }

  /// Load saved business name and phone number from SharedPreferences
  Future<void> _loadBusinessInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('business_name');
      final userData = await AuthPreferences.getUserData();

      if (mounted) {
        setState(() {
          if (savedName != null && savedName.isNotEmpty) {
            _businessName = savedName;
          }
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
        Uri.parse('http://31.97.206.144:4061/api/users/get-profile/$userId'),
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
      print('Error loading username: $e');
    }
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.network(
      widget.reel.videoUrl,
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
        mixWithOthers: false,
      ),
    );

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: widget.isCurrentPage,
      looping: true,
      showControls: false,
      allowFullScreen: false,
      allowMuting: false,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      customControls: const CupertinoControls(
        backgroundColor: Colors.transparent,
        iconColor: Colors.white,
      ),
      // CRITICAL: Force high quality rendering
      autoInitialize: true,
      allowedScreenSleep: false,
      hideControlsTimer: const Duration(seconds: 3),
      // Force specific rendering for better quality
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.white,
        handleColor: Colors.white,
        backgroundColor: Colors.white30,
        bufferedColor: Colors.white70,
      ),
      // Add error handling with retry
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              Text(
                'Failed to load video',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  _reinitializeVideo();
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );

    _videoController
        .initialize()
        .then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            if (widget.isCurrentPage) {
              _videoController.play();
              // Force high volume for better audio sync
              _videoController.setVolume(1.0);
            }
            _videoController.setLooping(true);
          }
        })
        .catchError((error) {
          print('Error initializing video: $error');
          if (mounted) {
            setState(() {
              _isInitialized = false;
            });
          }
        });
  }

  void _reinitializeVideo() {
    _videoController.dispose();
    _chewieController.dispose();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrentPage &&
        !_videoController.value.isPlaying &&
        _isInitialized) {
      _videoController.play();
    } else if (!widget.isCurrentPage &&
        _videoController.value.isPlaying &&
        _isInitialized) {
      _videoController.pause();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_isInitialized) return;

    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
        _showPlayPause = true;
      } else {
        _videoController.play();
        _showPlayPause = true;
      }
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showPlayPause = false;
        });
      }
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
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareReel() async {
    try {
      final shareText =
          'Check out this amazing reel!\n'
          '${widget.reel.videoUrl}\n\n'
          'By ❤️ using Edit Ezy';

      await Share.share(shareText, subject: 'Reel from PosterNova');
    } catch (e) {
      print('Error sharing reel: $e');
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

  /// Download reel to gallery
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
            setState(() {
              _downloadProgress = received / total;
            });
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
      print('Error downloading reel: $e');
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

  /// Shows a dialog to edit a text field (business name or phone number)
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
                  duration: const Duration(seconds: 2),
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

  /// Shows a bottom sheet to edit business name / phone with size sliders
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
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Business Name Edit
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

              // Business Name Size Slider
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

              // Phone Number Edit
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
                    onSave: (newValue) {
                      setState(() => _phoneNumber = newValue);
                    },
                  );
                },
              ),

              // Phone Number Size Slider
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

  /// Builds the business info bottom bar
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
              // Business Name
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

              // Vertical divider
              Container(
                height: 40,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                color: Colors.white.withOpacity(0.3),
              ),

              // Phone Number
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEditDialog(
                    title: 'Edit Number',
                    currentValue: _phoneNumber,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onSave: (newValue) {
                      setState(() => _phoneNumber = newValue);
                    },
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
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player with Chewie
          if (_isInitialized)
            Chewie(controller: _chewieController)
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
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

          // Play/Pause indicator
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
                    _videoController.value.isPlaying
                        ? Icons.play_arrow
                        : Icons.pause,
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
                // Like button
                Consumer<ReelProvider>(
                  builder: (context, reelProvider, child) {
                    final currentReel = reelProvider.getReelById(
                      widget.reel.id,
                    );
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

                // Share button
                _ActionButton(
                  icon: Icons.send_outlined,
                  label: '',
                  onTap: _shareReel,
                ),
                const SizedBox(height: 20),

                // Download button
                _isDownloading
                    ? SizedBox(
                        width: 48,
                        height: 48,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: _downloadProgress > 0
                                  ? _downloadProgress
                                  : null,
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                            Text(
                              _downloadProgress > 0
                                  ? '${(_downloadProgress * 100).toInt()}%'
                                  : '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _ActionButton(
                        icon: Icons.download_outlined,
                        label: '',
                        onTap: _downloadReel,
                      ),
                const SizedBox(height: 20),

                // More options
                _ActionButton(
                  icon: Icons.more_vert,
                  label: '',
                  onTap: () => _showOptionsBottomSheet(context),
                ),
              ],
            ),
          ),

          // Bottom left: user info + caption
          Positioned(
            left: 16,
            right: 80,
            bottom: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info
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
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 18,
                                  );
                                },
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

                // Caption
                const AppText(
                  'amazing_video_editezy',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Audio
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

          // Business Info Bar at the very bottom
          _buildBusinessInfoBar(),
        ],
      ),
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
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

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
