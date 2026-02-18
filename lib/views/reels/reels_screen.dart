// import 'package:flutter/material.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/providers/reels/reels_provider.dart';
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
//         title: const Text(
//           'Reels',
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

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//     _loadUsername();
//   }

//   Future<void> _loadUsername() async {
//     final userData = await AuthPreferences.getUserData();
//     if (mounted && userData != null) {
//       setState(() {
//         _username = userData.user.name ?? userData.user.name ?? 'Username';
//         _profileImage = userData.user.profileImage; // A
//       });
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

//   void _toggleLike() {
//     final reelProvider = Provider.of<ReelProvider>(context, listen: false);
//     final currentReel = reelProvider.getReelById(widget.reel.id);
//     final isLiked = currentReel?.isLiked ?? widget.reel.isLiked;

//     // Only allow liking, not unliking
//     if (!isLiked) {
//       reelProvider.toggleLike(widget.reel.id, widget.userId);
//     }
//   }

//   void _shareReel() async {
//     try {
//       // Construct share message
//       final shareText = 'Check out this amazing reel!\n${widget.reel.videoUrl}';

//       // Share using share_plus package
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
//                 // Like button (only allow liking, not unliking)
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
//                       onTap: isLiked
//                           ? () {}
//                           : _toggleLike, // Disable tap if already liked
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),

//                 // Comment button
//                 // _ActionButton(
//                 //   icon: Icons.mode_comment_outlined,
//                 //   label: '',
//                 //   onTap: () {
//                 //     // Show comments
//                 //   },
//                 // ),
//                 const SizedBox(height: 20),

//                 // Share button
//                 _ActionButton(
//                   icon: Icons.send_outlined,
//                   label: '',
//                   onTap: _shareReel,
//                 ),
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
//                     // Container(
//                     //   width: 32,
//                     //   height: 32,
//                     //   decoration: BoxDecoration(
//                     //     shape: BoxShape.circle,
//                     //     border: Border.all(color: Colors.white, width: 1),
//                     //     color: Colors.grey[800],
//                     //   ),
//                     //   child: const Icon(
//                     //     Icons.person,
//                     //     color: Colors.white,
//                     //     size: 18,
//                     //   ),
//                     // ),
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
//                     Text(
//                       _username,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     // Container(
//                     //   padding: const EdgeInsets.symmetric(
//                     //     horizontal: 12,
//                     //     vertical: 4,
//                     //   ),
//                     //   decoration: BoxDecoration(
//                     //     border: Border.all(color: Colors.white),
//                     //     borderRadius: BorderRadius.circular(4),
//                     //   ),
//                     //   child: const Text(
//                     //     'Follow',
//                     //     style: TextStyle(
//                     //       color: Colors.white,
//                     //       fontWeight: FontWeight.w600,
//                     //       fontSize: 12,
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),

//                 // Caption
//                 const Text(
//                   'Amazing video! Check this out 🔥',
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
//             // _BottomSheetOption(
//             //   icon: Icons.report_outlined,
//             //   label: 'Report',
//             //   onTap: () => Navigator.pop(context),
//             // ),
//             // _BottomSheetOption(
//             //   icon: Icons.block_outlined,
//             //   label: 'Not interested',
//             //   onTap: () => Navigator.pop(context),
//             // ),
//             // _BottomSheetOption(
//             //   icon: Icons.link_outlined,
//             //   label: 'Copy link',
//             //   onTap: () => Navigator.pop(context),
//             // ),
//             _BottomSheetOption(
//               icon: Icons.share_outlined,
//               label: 'Share to...',
//               onTap: () {
//                 Navigator.pop(context);
//                 _shareReel();
//               },
//             ),
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



import 'package:flutter/material.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/reels/reels_provider.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
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
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showPlayPause = false;
  String _username = 'Username';
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final userData = await AuthPreferences.getUserData();
    if (mounted && userData != null) {
      setState(() {
        _username = userData.user.name ?? userData.user.name ?? 'Username';
        _profileImage = userData.user.profileImage;
      });
    }
  }

  @override
  void didUpdateWidget(ReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrentPage && !_controller.value.isPlaying) {
      _controller.play();
    } else if (!widget.isCurrentPage && _controller.value.isPlaying) {
      _controller.pause();
    }
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.reel.videoUrl)
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _isInitialized = true;
              });
              if (widget.isCurrentPage) {
                _controller.play();
              }
              _controller.setLooping(true);
            }
          })
          .catchError((error) {
            print('Error initializing video: $error');
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showPlayPause = true;
      } else {
        _controller.play();
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

    // Call toggleLike which handles both like and unlike
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

  // void _shareReel() async {
  //   try {
  //     // Construct share message
  //     final shareText = 'Check out this amazing reel!\n${widget.reel.videoUrl}';

  //     // Share using share_plus package
  //     await Share.share(shareText, subject: 'Reel from PosterNova');
  //   } catch (e) {
  //     print('Error sharing reel: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Failed to share reel'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  // }

  void _shareReel() async {
    try {
      // Construct share message
      final shareText =
          'Check out this amazing reel!\n'
          '${widget.reel.videoUrl}\n\n'
          'By ❤️ using Edit Ezy';

      // Share using share_plus package
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video player
          if (_isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            )
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

          // Gradient overlay at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
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
                    _controller.value.isPlaying
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
            bottom: 100,
            child: Column(
              children: [
                // Like button (allows both like and unlike)
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

                // Comment button
                // _ActionButton(
                //   icon: Icons.mode_comment_outlined,
                //   label: '',
                //   onTap: () {
                //     // Show comments
                //   },
                // ),
                const SizedBox(height: 20),

                // Share button
                _ActionButton(
                  icon: Icons.send_outlined,
                  label: '',
                  onTap: _shareReel,
                ),
                const SizedBox(height: 20),

                // More options
                _ActionButton(
                  icon: Icons.more_vert,
                  label: '',
                  onTap: () {
                    _showOptionsBottomSheet(context);
                  },
                ),
              ],
            ),
          ),

          // Bottom info section
          Positioned(
            left: 16,
            right: 80,
            bottom: 20,
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
                const SizedBox(height: 12),

                // Caption
                const AppText(
                  'amazing_video_editezy',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

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
