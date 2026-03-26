// import 'package:flutter/material.dart';
// import 'package:posternova/models/story_model.dart';
// import 'package:posternova/providers/story/story_provider.dart';
// import 'package:posternova/views/stories/add_story_screen.dart';
// import 'package:posternova/views/stories/view_story_screen.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';

// class StoriesWidget extends StatefulWidget {
//   final String? profile;
//   StoriesWidget({Key? key, this.profile}) : super(key: key);

//   @override
//   State<StoriesWidget> createState() => _StoriesWidgetState();
// }

// class _StoriesWidgetState extends State<StoriesWidget> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch stories when widget initializes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<StoryProvider>(context, listen: false).fetchStories();
//     });
//   }

//   void _openAddStory(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddStoryScreen(
//           onStoryAdded: () {
//             // Refresh stories after adding
//             Provider.of<StoryProvider>(context, listen: false).fetchStories();
//           },
//         ),
//       ),
//     );
//   }

//   void _openStoryViewer(
//     BuildContext context,
//     List<UserStories> userStoriesList,
//     int initialUserIndex,
//   ) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StoryViewerScreen(
//           userStoriesList: userStoriesList,
//           initialUserIndex: initialUserIndex,
//           profile: widget.profile,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<StoryProvider>(
//       builder: (context, storyProvider, child) {
//         if (storyProvider.isLoading) {
//           return _buildSkeletonLoading();
//         }

//         final List<UserStories> userStoriesList = storyProvider
//             .getStoriesForDisplay();
//         final bool currentUserHasStory = storyProvider.currentUserHasStory();
//         final String? currentUserImage = storyProvider.currentUserImage;

//         return Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 110,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 255, 253, 181),
//             ),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               itemCount: userStoriesList.length + (currentUserHasStory ? 0 : 1),
//               // If user has story, it's already in userStoriesList; if not, add 1 for "Add Story"
//               itemBuilder: (context, index) {
//                 // First position is either current user's story or "Add Story"
//                 if (index == 0) {
//                   if (currentUserHasStory) {
//                     // Current user has a story, so it's the first item in userStoriesList
//                     final UserStories userStories = userStoriesList[0];
//                     return _buildStoryItem(
//                       context,
//                       userStories,
//                       true, // isCurrentUser
//                       () => _openStoryViewer(context, userStoriesList, 0),
//                       userStories.hasUnviewedStories,
//                     );
//                   } else {
//                     // Current user has no story, show "Add Story"
//                     return _buildAddStoryItem(context, currentUserImage);
//                   }
//                 }

//                 // For remaining positions, show other users' stories
//                 int adjustedIndex = index;
//                 if (!currentUserHasStory) {
//                   adjustedIndex = index - 1; // Adjust for the "Add Story" item
//                 }

//                 // Make sure index is within bounds
//                 if (adjustedIndex < userStoriesList.length) {
//                   final UserStories userStories =
//                       userStoriesList[adjustedIndex];

//                   return _buildStoryItem(
//                     context,
//                     userStories,
//                     false, // not current user (current user is always at index 0 if they have a story)
//                     () => _openStoryViewer(
//                       context,
//                       userStoriesList,
//                       adjustedIndex,
//                     ),
//                     userStories.hasUnviewedStories,
//                   );
//                 }

//                 // Fallback empty container
//                 return Container();
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSkeletonLoading() {
//     return SizedBox(
//       height: 110,
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           itemCount: 5, // Show 5 skeleton items
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//               child: Column(
//                 children: [
//                   // Skeleton circle for avatar
//                   Container(
//                     width: 65,
//                     height: 65,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   // Skeleton rectangle for text
//                   Container(
//                     width: 50,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildAddStoryItem(BuildContext context, String? userProfileImage) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//       child: GestureDetector(
//         onTap: () => _openAddStory(context),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 // User profile image
//                 Container(
//                   width: 65,
//                   height: 65,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.grey[300],
//                     image:
//                         (widget.profile != null && widget.profile!.isNotEmpty)
//                         ? DecorationImage(
//                             image: NetworkImage(widget.profile!),
//                             fit: BoxFit.cover,
//                             onError: (exception, stackTrace) {
//                               print('Error loading profile image: $exception');
//                             },
//                           )
//                         : (userProfileImage != null &&
//                               userProfileImage.isNotEmpty)
//                         ? DecorationImage(
//                             image: NetworkImage(userProfileImage),
//                             fit: BoxFit.cover,
//                             onError: (exception, stackTrace) {
//                               print('Error loading profile image: $exception');
//                             },
//                           )
//                         : null,
//                   ),
//                   child:
//                       (widget.profile == null || widget.profile!.isEmpty) &&
//                           (userProfileImage == null || userProfileImage.isEmpty)
//                       ? const Icon(Icons.person, size: 35, color: Colors.white)
//                       : null,
//                 ),
//                 // Plus icon overlay
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: Container(
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: const Icon(Icons.add, color: Colors.white, size: 14),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             const AppText(
//               'your_story',
//               style: TextStyle(fontSize: 12, color: Colors.black),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _buildStoryItem(
//   //   BuildContext context,
//   //   UserStories userStories,
//   //   bool isCurrentUser,
//   //   VoidCallback onTap,
//   //   bool hasUnviewedStories,
//   // ) {
//   //   // Get user's profile image instead of story content image
//   //   String? profileImageUrl;

//   //   if (isCurrentUser) {
//   //     // For current user, use the profile image from StoryProvider
//   //     profileImageUrl = Provider.of<StoryProvider>(
//   //       context,
//   //       listen: false,
//   //     ).currentUserImage;
//   //   } else {
//   //     // For other users, get profile image from UserStories or first story's profile image
//   //     if (userStories.userAvatar.isNotEmpty &&
//   //         userStories.userAvatar != 'default-profile-image.jpg') {
//   //       profileImageUrl = userStories.userAvatar;
//   //     } else if (userStories.stories.isNotEmpty) {
//   //       // Fallback to first story's profile image
//   //       final firstStory = userStories.stories.first;
//   //       if (firstStory.hasCustomProfileImage) {
//   //         profileImageUrl = firstStory.profileImage;
//   //       }
//   //     }
//   //   }

//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//   //     child: GestureDetector(
//   //       onTap: onTap,
//   //       child: Column(
//   //         children: [
//   //           Container(
//   //             width: 68,
//   //             height: 68,
//   //             decoration: BoxDecoration(
//   //               shape: BoxShape.circle,
//   //               gradient: hasUnviewedStories
//   //                   ? const LinearGradient(
//   //                       colors: [Colors.purple, Colors.orange, Colors.pink],
//   //                       begin: Alignment.topLeft,
//   //                       end: Alignment.bottomRight,
//   //                     )
//   //                   : null,
//   //               border: !hasUnviewedStories
//   //                   ? Border.all(color: Colors.grey, width: 2)
//   //                   : null,
//   //             ),
//   //             padding: const EdgeInsets.all(2),
//   //             child: Container(
//   //               decoration: BoxDecoration(
//   //                 shape: BoxShape.circle,
//   //                 color: Colors.grey[300],
//   //                 border: Border.all(color: Colors.white, width: 2),
//   //                 image: profileImageUrl != null && profileImageUrl.isNotEmpty
//   //                     ? DecorationImage(
//   //                         image: NetworkImage(profileImageUrl),
//   //                         fit: BoxFit.cover,
//   //                         onError: (exception, stackTrace) {
//   //                           // Handle image loading errors
//   //                           print('Error loading profile image: $exception');
//   //                         },
//   //                       )
//   //                     : null,
//   //               ),
//   //               child: profileImageUrl == null || profileImageUrl.isEmpty
//   //                   ? const Icon(Icons.person, color: Colors.white)
//   //                   : null,
//   //             ),
//   //           ),
//   //           const SizedBox(height: 4),
//   //           Text(
//   //             isCurrentUser
//   //                 ? AppText.translate(context, 'your_story')
//   //                 : userStories.username.isNotEmpty
//   //                 ? userStories.username
//   //                 : 'Story',
//   //             style: TextStyle(
//   //               color: Colors.black,
//   //               fontSize: 12,
//   //               fontWeight: hasUnviewedStories
//   //                   ? FontWeight.bold
//   //                   : FontWeight.normal,
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   Widget _buildStoryItem(
//     BuildContext context,
//     UserStories userStories,
//     bool isCurrentUser,
//     VoidCallback onTap,
//     bool hasUnviewedStories,
//   ) {
//     // Get user's profile image instead of story content image
//     String? profileImageUrl;
//     String? firstVideoUrl;
//     bool hasVideo = false;
//     int storyCount = userStories.stories.length;
//     int viewedCount = userStories.stories.where((s) => s.isViewed).length;

//     if (isCurrentUser) {
//       // For current user, use the profile image from StoryProvider
//       profileImageUrl = Provider.of<StoryProvider>(
//         context,
//         listen: false,
//       ).currentUserImage;
//     } else {
//       // For other users, get profile image from UserStories or first story's profile image
//       if (userStories.userAvatar.isNotEmpty &&
//           userStories.userAvatar != 'default-profile-image.jpg') {
//         profileImageUrl = userStories.userAvatar;
//       } else if (userStories.stories.isNotEmpty) {
//         // Check if first story has a video
//         final firstStory = userStories.stories.first;
//         if (firstStory.hasCustomProfileImage) {
//           profileImageUrl = firstStory.profileImage;
//         }

//         // If the story has a video but no profile image, show video icon
//         if (firstStory.videos.isNotEmpty &&
//             (profileImageUrl == null || profileImageUrl!.isEmpty)) {
//           hasVideo = true;
//           firstVideoUrl = firstStory.videos.first;
//         }
//       }
//     }

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Column(
//           children: [
//             // Story ring with segments for multiple stories
//             storyCount > 1
//                 ? Container(
//                     width: 68,
//                     height: 68,
//                     decoration: const BoxDecoration(shape: BoxShape.circle),
//                     child: CustomPaint(
//                       painter: StoryRingPainter(
//                         storyCount: storyCount,
//                         viewedStories: viewedCount,
//                         hasUnviewed: hasUnviewedStories,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(
//                           3,
//                         ), // Inner padding for profile image
//                         child: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey[300],
//                             border: Border.all(color: Colors.white, width: 2),
//                             image: widget.profile != null
//                                 ? DecorationImage(
//                                     image: NetworkImage(
//                                       widget.profile.toString(),
//                                     ),
//                                     fit: BoxFit.cover,
//                                     onError: (exception, stackTrace) {
//                                       print(
//                                         'Error loading profile image: $exception',
//                                       );
//                                     },
//                                   )
//                                 : null,
//                           ),
//                           child: widget.profile == null
//                               ? (hasVideo
//                                     ? Container(
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[800],
//                                           shape: BoxShape.circle,
//                                         ),
//                                         child: Stack(
//                                           alignment: Alignment.center,
//                                           children: [
//                                             const Icon(
//                                               Icons.play_circle_filled,
//                                               color: Colors.white,
//                                               size: 30,
//                                             ),
//                                             if (firstVideoUrl != null)
//                                               Positioned(
//                                                 bottom: 2,
//                                                 right: 2,
//                                                 child: Container(
//                                                   padding: const EdgeInsets.all(
//                                                     2,
//                                                   ),
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                         color: Colors.blue,
//                                                         shape: BoxShape.circle,
//                                                       ),
//                                                   child: const Icon(
//                                                     Icons.videocam,
//                                                     color: Colors.white,
//                                                     size: 10,
//                                                   ),
//                                                 ),
//                                               ),
//                                           ],
//                                         ),
//                                       )
//                                     : const Icon(
//                                         Icons.person,
//                                         color: Colors.white,
//                                       ))
//                               : null,
//                         ),
//                       ),
//                     ),
//                   )
//                 : Container(
//                     width: 68,
//                     height: 68,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: hasUnviewedStories
//                           ? const LinearGradient(
//                               colors: [
//                                 Colors.purple,
//                                 Colors.orange,
//                                 Colors.pink,
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             )
//                           : null,
//                       border: !hasUnviewedStories
//                           ? Border.all(color: Colors.grey, width: 2)
//                           : null,
//                     ),
//                     padding: const EdgeInsets.all(2),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey[300],
//                         border: Border.all(color: Colors.white, width: 2),
//                         image:
//                             profileImageUrl != null &&
//                                 profileImageUrl.isNotEmpty
//                             ? DecorationImage(
//                                 image: NetworkImage(profileImageUrl),
//                                 fit: BoxFit.cover,
//                                 onError: (exception, stackTrace) {
//                                   print(
//                                     'Error loading profile image: $exception',
//                                   );
//                                 },
//                               )
//                             : null,
//                       ),
//                       child: profileImageUrl == null || profileImageUrl.isEmpty
//                           ? (hasVideo
//                                 ? Container(
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[800],
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         const Icon(
//                                           Icons.play_circle_filled,
//                                           color: Colors.white,
//                                           size: 30,
//                                         ),
//                                         if (firstVideoUrl != null)
//                                           Positioned(
//                                             bottom: 2,
//                                             right: 2,
//                                             child: Container(
//                                               padding: const EdgeInsets.all(2),
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.blue,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: const Icon(
//                                                 Icons.videocam,
//                                                 color: Colors.white,
//                                                 size: 10,
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   )
//                                 : const Icon(Icons.person, color: Colors.white))
//                           : null,
//                     ),
//                   ),
//             const SizedBox(height: 4),
//             Text(
//               isCurrentUser
//                   ? AppText.translate(context, 'your_story')
//                   : userStories.username.isNotEmpty
//                   ? userStories.username
//                   : 'Story',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 12,
//                 fontWeight: hasUnviewedStories
//                     ? FontWeight.bold
//                     : FontWeight.normal,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Custom painter for segmented story ring with gaps - MOVE THIS OUTSIDE THE CLASS
// class StoryRingPainter extends CustomPainter {
//   final int storyCount;
//   final int viewedStories;
//   final bool hasUnviewed;

//   StoryRingPainter({
//     required this.storyCount,
//     required this.viewedStories,
//     required this.hasUnviewed,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;
//     final strokeWidth = 3.0;
//     final rect = Rect.fromCircle(center: center, radius: radius - 1);

//     // Gap between segments (in radians) - small but visible gap
//     final gapAngle = 0.15; // Slightly larger gap for better visibility

//     // Available angle for each segment (total circle minus gaps)
//     final totalGaps = gapAngle * storyCount;
//     final availableAngle = 2 * 3.14159 - totalGaps;
//     final segmentAngle = availableAngle / storyCount;

//     for (int i = 0; i < storyCount; i++) {
//       // Start angle with gap
//       final startAngle = (i * (segmentAngle + gapAngle)) - 3.14159 / 2;

//       final paint = Paint()
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = strokeWidth
//         ..strokeCap = StrokeCap.round; // Rounded ends for better look

//       // Determine color based on viewed status
//       if (i < viewedStories) {
//         // Viewed stories - grey
//         paint.color = Colors.grey;
//       } else {
//         // Unviewed stories - gradient colors
//         paint.shader = const SweepGradient(
//           startAngle: 0,
//           endAngle: 2 * 3.14159,
//           colors: [Colors.purple, Colors.orange, Colors.pink],
//         ).createShader(rect);
//       }

//       canvas.drawArc(rect, startAngle, segmentAngle, false, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant StoryRingPainter oldDelegate) {
//     return oldDelegate.storyCount != storyCount ||
//         oldDelegate.viewedStories != viewedStories ||
//         oldDelegate.hasUnviewed != hasUnviewed;
//   }
// }

import 'package:flutter/material.dart';
import 'package:posternova/models/story_model.dart';
import 'package:posternova/providers/celebration/celebration_provider.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/views/stories/add_story_screen.dart';
import 'package:posternova/views/stories/view_story_screen.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StoriesWidget extends StatefulWidget {
  final String? profile;
  const StoriesWidget({Key? key, this.profile}) : super(key: key);

  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoryProvider>(context, listen: false).fetchStories();
    });
  }

  void _openAddStory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStoryScreen(
          onStoryAdded: () {
            Provider.of<StoryProvider>(context, listen: false).fetchStories();
          },
        ),
      ),
    );
  }

  void _openStoryViewer(
    BuildContext context,
    List<UserStories> userStoriesList,
    int initialUserIndex,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          userStoriesList: userStoriesList,
          initialUserIndex: initialUserIndex,
          profile: widget.profile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final celebrationProvider = Provider.of<CelebrationProvider>(context);

    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        if (storyProvider.isLoading) {
          return _buildSkeletonLoading(celebrationProvider);
        }

        final List<UserStories> userStoriesList = storyProvider
            .getStoriesForDisplay();
        final bool currentUserHasStory = storyProvider.currentUserHasStory();
        final String? currentUserImage = storyProvider.currentUserImage;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 110,
            // decoration: BoxDecoration(
            //   color: celebrationProvider.sectionBgColor,
            // ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: userStoriesList.length + (currentUserHasStory ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == 0) {
                  if (currentUserHasStory) {
                    final UserStories userStories = userStoriesList[0];
                    return _buildStoryItem(
                      context,
                      userStories,
                      true,
                      () => _openStoryViewer(context, userStoriesList, 0),
                      userStories.hasUnviewedStories,
                      celebrationProvider,
                    );
                  } else {
                    return _buildAddStoryItem(
                      context,
                      currentUserImage,
                      celebrationProvider,
                    );
                  }
                }

                int adjustedIndex = index;
                if (!currentUserHasStory) {
                  adjustedIndex = index - 1;
                }

                if (adjustedIndex < userStoriesList.length) {
                  final UserStories userStories =
                      userStoriesList[adjustedIndex];

                  return _buildStoryItem(
                    context,
                    userStories,
                    false,
                    () => _openStoryViewer(
                      context,
                      userStoriesList,
                      adjustedIndex,
                    ),
                    userStories.hasUnviewedStories,
                    celebrationProvider,
                  );
                }

                return Container();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoading(CelebrationProvider celebrationProvider) {
    return SizedBox(
      height: 110,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          color: celebrationProvider.sectionBgColor,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 50,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddStoryItem(
    BuildContext context,
    String? userProfileImage,
    CelebrationProvider celebrationProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () => _openAddStory(context),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image:
                        (widget.profile != null && widget.profile!.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(widget.profile!),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              print('Error loading profile image: $exception');
                            },
                          )
                        : (userProfileImage != null &&
                              userProfileImage.isNotEmpty)
                        ? DecorationImage(
                            image: NetworkImage(userProfileImage),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              print('Error loading profile image: $exception');
                            },
                          )
                        : null,
                  ),
                  child:
                      (widget.profile == null || widget.profile!.isEmpty) &&
                          (userProfileImage == null || userProfileImage.isEmpty)
                      ? Icon(Icons.person, size: 35, color: Colors.grey[600])
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: celebrationProvider.accentColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            AppText(
              'your_story',
              style: TextStyle(
                fontSize: 12,
                color: celebrationProvider.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryItem(
    BuildContext context,
    UserStories userStories,
    bool isCurrentUser,
    VoidCallback onTap,
    bool hasUnviewedStories,
    CelebrationProvider celebrationProvider,
  ) {
    String? profileImageUrl;
    String? firstVideoUrl;
    bool hasVideo = false;
    int storyCount = userStories.stories.length;
    int viewedCount = userStories.stories.where((s) => s.isViewed).length;

    if (isCurrentUser) {
      profileImageUrl = Provider.of<StoryProvider>(
        context,
        listen: false,
      ).currentUserImage;
    } else {
      if (userStories.userAvatar.isNotEmpty &&
          userStories.userAvatar != 'default-profile-image.jpg') {
        profileImageUrl = userStories.userAvatar;
      } else if (userStories.stories.isNotEmpty) {
        final firstStory = userStories.stories.first;
        if (firstStory.hasCustomProfileImage) {
          profileImageUrl = firstStory.profileImage;
        }
        if (firstStory.videos.isNotEmpty &&
            (profileImageUrl == null || profileImageUrl!.isEmpty)) {
          hasVideo = true;
          firstVideoUrl = firstStory.videos.first;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            storyCount > 1
                ? Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CustomPaint(
                      painter: StoryRingPainter(
                        storyCount: storyCount,
                        viewedStories: viewedCount,
                        hasUnviewed: hasUnviewedStories,
                        accentColor: celebrationProvider.accentColor,
                        gradientColors: celebrationProvider.gradientColors,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            border: Border.all(color: Colors.white, width: 2),
                            image: widget.profile != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      widget.profile.toString(),
                                    ),
                                    fit: BoxFit.cover,
                                    onError: (exception, stackTrace) {
                                      print(
                                        'Error loading profile image: $exception',
                                      );
                                    },
                                  )
                                : null,
                          ),
                          child: widget.profile == null
                              ? (hasVideo
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.play_circle_filled,
                                              color: celebrationProvider
                                                  .accentColor,
                                              size: 30,
                                            ),
                                            if (firstVideoUrl != null)
                                              Positioned(
                                                bottom: 2,
                                                right: 2,
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: celebrationProvider
                                                        .accentColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.videocam,
                                                    color: Colors.white,
                                                    size: 10,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    : Icon(
                                        Icons.person,
                                        color: Colors.grey[600],
                                      ))
                              : null,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          hasUnviewedStories &&
                              celebrationProvider.gradientColors != null
                          ? LinearGradient(
                              colors: celebrationProvider.gradientColors!,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      border: !hasUnviewedStories
                          ? Border.all(color: Colors.grey, width: 2)
                          : null,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        border: Border.all(color: Colors.white, width: 2),
                        image:
                            profileImageUrl != null &&
                                profileImageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(profileImageUrl),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {
                                  print(
                                    'Error loading profile image: $exception',
                                  );
                                },
                              )
                            : null,
                      ),
                      child: profileImageUrl == null || profileImageUrl.isEmpty
                          ? (hasVideo
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_circle_filled,
                                          color:
                                              celebrationProvider.accentColor,
                                          size: 30,
                                        ),
                                        if (firstVideoUrl != null)
                                          Positioned(
                                            bottom: 2,
                                            right: 2,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: celebrationProvider
                                                    .accentColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.videocam,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                : Icon(Icons.person, color: Colors.grey[600]))
                          : null,
                    ),
                  ),
            const SizedBox(height: 4),
            Text(
              isCurrentUser
                  ? AppText.translate(context, 'your_story')
                  : userStories.username.isNotEmpty
                  ? userStories.username
                  : 'Story',
              style: TextStyle(
                color: celebrationProvider.primaryTextColor,
                fontSize: 12,
                fontWeight: hasUnviewedStories
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Updated StoryRingPainter to use celebration colors
class StoryRingPainter extends CustomPainter {
  final int storyCount;
  final int viewedStories;
  final bool hasUnviewed;
  final Color accentColor;
  final List<Color>? gradientColors;

  StoryRingPainter({
    required this.storyCount,
    required this.viewedStories,
    required this.hasUnviewed,
    required this.accentColor,
    this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 3.0;
    final rect = Rect.fromCircle(center: center, radius: radius - 1);

    final gapAngle = 0.15;
    final totalGaps = gapAngle * storyCount;
    final availableAngle = 2 * 3.14159 - totalGaps;
    final segmentAngle = availableAngle / storyCount;

    for (int i = 0; i < storyCount; i++) {
      final startAngle = (i * (segmentAngle + gapAngle)) - 3.14159 / 2;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      if (i < viewedStories) {
        paint.color = Colors.grey;
      } else {
        if (gradientColors != null && gradientColors!.length >= 2) {
          paint.shader = SweepGradient(
            startAngle: 0,
            endAngle: 2 * 3.14159,
            colors: gradientColors!,
          ).createShader(rect);
        } else {
          paint.color = accentColor;
        }
      }

      canvas.drawArc(rect, startAngle, segmentAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StoryRingPainter oldDelegate) {
    return oldDelegate.storyCount != storyCount ||
        oldDelegate.viewedStories != viewedStories ||
        oldDelegate.hasUnviewed != hasUnviewed ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.gradientColors != gradientColors;
  }
}
