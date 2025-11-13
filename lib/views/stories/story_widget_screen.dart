import 'package:flutter/material.dart';
import 'package:posternova/models/story_model.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/views/stories/add_story_screen.dart';
import 'package:posternova/views/stories/view_story_screen.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class StoriesWidget extends StatefulWidget {
  const StoriesWidget({Key? key}) : super(key: key);

  @override
  State<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch stories when widget initializes
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
            // Refresh stories after adding
            Provider.of<StoryProvider>(context, listen: false).fetchStories();
          },
        ),
      ),
    );
  }
  
  void _openStoryViewer(BuildContext context, List<UserStories> userStoriesList, int initialUserIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          userStoriesList: userStoriesList,
          initialUserIndex: initialUserIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, storyProvider, child) {
        if (storyProvider.isLoading) {
          return _buildSkeletonLoading();
        }
        
        final List<UserStories> userStoriesList = storyProvider.getStoriesForDisplay();
        final bool currentUserHasStory = storyProvider.currentUserHasStory();
        final String? currentUserImage = storyProvider.currentUserImage;

        return Container(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: userStoriesList.length + (currentUserHasStory ? 0 : 1), 
            // If user has story, it's already in userStoriesList; if not, add 1 for "Add Story"
            itemBuilder: (context, index) {
              // First position is either current user's story or "Add Story"
              if (index == 0) {
                if (currentUserHasStory) {
                  // Current user has a story, so it's the first item in userStoriesList
                  final UserStories userStories = userStoriesList[0];
                  return _buildStoryItem(
                    context, 
                    userStories, 
                    true, // isCurrentUser
                    () => _openStoryViewer(context, userStoriesList, 0),
                    userStories.hasUnviewedStories,
                  );
                } else {
                  // Current user has no story, show "Add Story"
                  return _buildAddStoryItem(context, currentUserImage);
                }
              }
              
              // For remaining positions, show other users' stories
              int adjustedIndex = index;
              if (!currentUserHasStory) {
                adjustedIndex = index - 1; // Adjust for the "Add Story" item
              }
              
              // Make sure index is within bounds
              if (adjustedIndex < userStoriesList.length) {
                final UserStories userStories = userStoriesList[adjustedIndex];
                
                return _buildStoryItem(
                  context, 
                  userStories, 
                  false, // not current user (current user is always at index 0 if they have a story)
                  () => _openStoryViewer(context, userStoriesList, adjustedIndex),
                  userStories.hasUnviewedStories,
                );
              }
              
              // Fallback empty container
              return Container();
            },
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoading() {
    return SizedBox(
      height: 110,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: 5, // Show 5 skeleton items
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Column(
                children: [
                  // Skeleton circle for avatar
                  Container(
                    width: 65,
                    height: 65,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Skeleton rectangle for text
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
    );
  }

  Widget _buildAddStoryItem(BuildContext context, String? userProfileImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: () => _openAddStory(context),
        child: Column(
          children: [
            Stack(
              children: [
                // User profile image
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: userProfileImage != null
                        ? DecorationImage(
                            image: NetworkImage(userProfileImage),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: userProfileImage == null
                      ? const Icon(Icons.person, size: 35, color: Colors.white)
                      : null,
                ),
                // Plus icon overlay
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Your Story',
              style: TextStyle(fontSize: 12, color: Colors.black),
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
  ) {
    // Get user's profile image instead of story content image
    String? profileImageUrl;
    
    if (isCurrentUser) {
      // For current user, use the profile image from StoryProvider
      profileImageUrl = Provider.of<StoryProvider>(context, listen: false).currentUserImage;
    } else {
      // For other users, get profile image from UserStories or first story's profile image
      if (userStories.userAvatar.isNotEmpty && userStories.userAvatar != 'default-profile-image.jpg') {
        profileImageUrl = userStories.userAvatar;
      } else if (userStories.stories.isNotEmpty) {
        // Fallback to first story's profile image
        final firstStory = userStories.stories.first;
        if (firstStory.hasCustomProfileImage) {
          profileImageUrl = firstStory.profileImage;
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasUnviewedStories 
                    ? const LinearGradient(
                        colors: [Colors.purple, Colors.orange, Colors.pink],
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
                  image: profileImageUrl != null && profileImageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(profileImageUrl),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {
                            // Handle image loading errors
                            print('Error loading profile image: $exception');
                          },
                        )
                      : null,
                ),
                child: profileImageUrl == null || profileImageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isCurrentUser ? AppText.translate(context, 'your_story') : userStories.username.isNotEmpty ? userStories.username : 'Story',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: hasUnviewedStories ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}