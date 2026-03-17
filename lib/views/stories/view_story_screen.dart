import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/story_model.dart';
import 'package:posternova/providers/story/report_provider.dart';
import 'package:posternova/providers/story/story_provider.dart';
import 'package:posternova/views/stories/add_story_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<UserStories> userStoriesList;
  final int initialUserIndex;
  final String? profile;

  const StoryViewerScreen({
    Key? key,
    required this.userStoriesList,
    required this.initialUserIndex,
    this.profile,
  }) : super(key: key);

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with TickerProviderStateMixin {
  late final String userId;
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  late int _currentUserIndex;
  late int _currentStoryIndex;
  bool _isPaused = false;
  bool _isShowingUserOptions = false;
  bool _shouldBlock = false;
  bool _isLoading = true;
  String? userImage;

  // Video player
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _currentUserIndex = widget.initialUserIndex;
    _currentStoryIndex = 0;

    // Main story progression animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Fade animation for UI elements
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Scale animation for story transitions
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _startAnimations();

    // Initialize media
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCurrentMedia();
      _markCurrentStoryAsViewed();
    });
  }

  void _startAnimations() {
    _animationController.forward();
    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _initializeCurrentMedia() async {
    setState(() {
      _isLoading = true;
    });

    // Dispose previous video controller
    await _videoController?.dispose();
    _videoController = null;
    _isVideoInitialized = false;

    final story = _currentStory;
    _isVideo = story.videos.isNotEmpty;

    // Update _initializeCurrentMedia method - replace the video listener section:

    if (_isVideo) {
      // Initialize video player
      _videoController = VideoPlayerController.network(story.videos.first);
      try {
        await _videoController!.initialize();
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
            _isLoading = false;
          });
        }
        _videoController!.setLooping(false);
        _videoController!.play();

        // Update animation duration based on video length
        if (_videoController!.value.duration.inSeconds > 0) {
          _animationController.duration = _videoController!.value.duration;
        }
        _animationController.forward(from: 0);

        // Add listener for video completion
        _videoController!.addListener(() {
          if (_videoController!.value.position >=
              _videoController!.value.duration) {
            // Only trigger next story if not already paused/loading
            if (!_isPaused && mounted && !_isLoading) {
              _nextStory();
            }
          }
        });
      } catch (e) {
        print('Error initializing video: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      // For images, use default duration
      _animationController.duration = const Duration(seconds: 5);
      _animationController.forward(from: 0);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    // Mark story as viewed after loading
    Future.delayed(const Duration(milliseconds: 500), () {
      _markCurrentStoryAsViewed();
    });
  }

  String? _getUserProfileImage() {
    if (_isCurrentUserOwner) {
      return Provider.of<StoryProvider>(
        context,
        listen: false,
      ).currentUserImage;
    } else {
      if (_currentUserStories.userAvatar.isNotEmpty &&
          _currentUserStories.userAvatar != 'default-profile-image.jpg') {
        return _currentUserStories.userAvatar;
      } else if (_currentUserStories.stories.isNotEmpty) {
        final firstStory = _currentUserStories.stories.first;
        if (firstStory.hasCustomProfileImage) {
          return firstStory.profileImage;
        }
      }
    }
    return null;
  }

  String _getCurrentStoryMedia() {
    final story = _currentStory;

    // Check if there are videos first
    if (story.videos.isNotEmpty) {
      return story.videos.first;
    }

    // Fallback to images if available
    if (story.images.isNotEmpty) {
      return story.images.first;
    }

    return '';
  }

  Future<void> _loadUserData() async {
    final userData = await AuthPreferences.getUserData();
    if (userData != null && userData.user.id != null) {
      setState(() {
        userId = "${userData.user.id}";
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  UserStories get _currentUserStories =>
      widget.userStoriesList[_currentUserIndex];
  Story get _currentStory => _currentUserStories.stories[_currentStoryIndex];
  bool get _isCurrentUserOwner =>
      _currentUserStories.userId ==
      Provider.of<StoryProvider>(context, listen: false).currentUserId;

  void _markCurrentStoryAsViewed() {
    Provider.of<StoryProvider>(
      context,
      listen: false,
    ).markStoryAsViewed(_currentStory.id);
  }

  // Update _nextStory method:

  void _nextStory() async {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Pause video if playing
    if (_isVideo &&
        _videoController != null &&
        _videoController!.value.isPlaying) {
      _videoController!.pause();
    }

    _scaleController.reset();
    _scaleController.forward();

    // Small delay to ensure video is paused and state is clean
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    if (_currentStoryIndex < _currentUserStories.stories.length - 1) {
      setState(() {
        _currentStoryIndex++;
      });
      _initializeCurrentMedia();
    } else if (_currentUserIndex < widget.userStoriesList.length - 1) {
      setState(() {
        _currentUserIndex++;
        _currentStoryIndex = 0;
      });
      _initializeCurrentMedia();
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    HapticFeedback.lightImpact();

    _scaleController.reset();
    _scaleController.forward();

    if (_currentStoryIndex > 0) {
      setState(() {
        _currentStoryIndex--;
      });
      _initializeCurrentMedia();
    } else if (_currentUserIndex > 0) {
      setState(() {
        _currentUserIndex--;
        _currentStoryIndex =
            widget.userStoriesList[_currentUserIndex].stories.length - 1;
      });
      _initializeCurrentMedia();
    }
  }

  void _togglePause() {
    HapticFeedback.selectionClick();
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _animationController.stop();
        if (_isVideo && _videoController != null) {
          _videoController!.pause();
        }
      } else {
        _animationController.forward();
        if (_isVideo && _videoController != null) {
          _videoController!.play();
        }
      }
    });
  }

  void _showReportDialog() {
    setState(() {
      _isPaused = true;
      _animationController.stop();
      if (_isVideo && _videoController != null) {
        _videoController!.pause();
      }
      _shouldBlock = false;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Consumer<ReportStoryProvider>(
              builder: (context, reportProvider, child) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Modern warning icon
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange[400]!, Colors.red[400]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: const Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Title with better typography
                          Text(
                            'Report ${_currentUserStories.username.isNotEmpty ? _currentUserStories.username : 'User'}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Description with improved styling
                          Text(
                            'Thank you for your report. Our moderation team will review it shortly, and the user will not be informed.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 12),

                          // Modern learn more button
                          TextButton.icon(
                            onPressed: () {},
                            label: Text(
                              '',
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Enhanced block option
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _shouldBlock
                                    ? Colors.blue[300]!
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                setDialogState(() {
                                  _shouldBlock = !_shouldBlock;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _shouldBlock
                                          ? Colors.blue[600]
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: _shouldBlock
                                            ? Colors.blue[600]!
                                            : Colors.grey[400]!,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: _shouldBlock
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Block ${_currentUserStories.username.isNotEmpty ? _currentUserStories.username : 'User'}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Color(0xFF1A1A1A),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'They won\'t be able to see your stories or interact with you.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Error message with better design
                          if (reportProvider.error != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color: Colors.red[600],
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      reportProvider.error!,
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Modern action buttons
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: reportProvider.isLoading
                                      ? null
                                      : () {
                                          reportProvider.clearMessages();
                                          Navigator.pop(context);
                                          setState(() {
                                            _isPaused = false;
                                            _animationController.forward();
                                            if (_isVideo &&
                                                _videoController != null) {
                                              _videoController!.play();
                                            }
                                          });
                                        },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: reportProvider.isLoading
                                      ? null
                                      : () async {
                                          await _handleReportSubmission(
                                            reportProvider,
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      229,
                                      70,
                                      203,
                                    ),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: reportProvider.isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Report User',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    ).then((_) {
      if (!_isPaused && mounted) {
        setState(() {
          _animationController.forward();
          if (_isVideo && _videoController != null) {
            _videoController!.play();
          }
        });
      }
    });
  }

  Future<void> _handleReportSubmission(
    ReportStoryProvider reportProvider,
  ) async {
    try {
      final success = await reportProvider.reportAndBlockUser(
        reportedUserId: _currentUserStories.userId.toString(),
        context: context,
        shouldBlock: _shouldBlock,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    reportProvider.successMessage ??
                        'Report submitted successfully',
                  ),
                ],
              ),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        if (mounted) {
          Navigator.pop(context);
          setState(() {
            _isPaused = false;
            _animationController.forward();
            if (_isVideo && _videoController != null) {
              _videoController!.play();
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text('An unexpected error occurred'),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _showAddStoryOptions() {
    final StoryProvider storyProvider = Provider.of<StoryProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isPaused = true;
      _animationController.stop();
      if (_isVideo && _videoController != null) {
        _videoController!.pause();
      }
      _isShowingUserOptions = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Options
            _buildBottomSheetOption(
              icon: Icons.add_photo_alternate_rounded,
              title: 'Add New Story',
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStoryScreen(
                      onStoryAdded: () => storyProvider.fetchStories(),
                    ),
                  ),
                );

                setState(() {
                  _isPaused = false;
                  _isShowingUserOptions = false;
                  _animationController.forward();
                  if (_isVideo && _videoController != null) {
                    _videoController!.play();
                  }
                });
              },
            ),

            if (_isCurrentUserOwner) ...[
              const SizedBox(height: 12),
              _buildBottomSheetOption(
                icon: Icons.delete_rounded,
                title: 'Delete Story',
                isDestructive: true,
                onTap: () async {
                  Navigator.pop(context);
                  await _showDeleteConfirmation();
                },
              ),
            ],

            const SizedBox(height: 12),
            _buildBottomSheetOption(
              icon: Icons.close_rounded,
              title: 'Cancel',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _isPaused = false;
                  _isShowingUserOptions = false;
                  _animationController.forward();
                  if (_isVideo && _videoController != null) {
                    _videoController!.play();
                  }
                });
              },
            ),

            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDestructive ? Colors.red[400] : Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: isDestructive ? Colors.red[400] : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarIcon() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red[600],
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Delete Story',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to delete this story? This action cannot be undone.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      final storyId = _currentStory.id;

      // Get the media URL safely
      final mediaUrl = _currentStory.videos.isNotEmpty
          ? _currentStory.videos.first
          : (_currentStory.images.isNotEmpty ? _currentStory.images.first : '');

      final success = await storyProvider.deleteStory(
        storyId,
        userId,
        mediaUrl,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Story deleted successfully'),
                ],
              ),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }

        if (storyProvider.currentUserHasStory()) {
          _nextStory();
        } else {
          if (mounted) Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(storyProvider.error ?? 'Failed to delete story'),
                ],
              ),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    }

    setState(() {
      _isPaused = false;
      _isShowingUserOptions = false;
      _animationController.forward();
      if (_isVideo && _videoController != null) {
        _videoController!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String storyMediaUrl = _getCurrentStoryMedia();
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          if (_isShowingUserOptions) return;

          final screenWidth = MediaQuery.of(context).size.width;
          final tapPosition = details.globalPosition.dx;

          if (tapPosition < screenWidth * 0.3) {
            _previousStory();
          } else if (tapPosition > screenWidth * 0.7) {
            _nextStory();
          } else {
            _togglePause();
          }
        },
        onLongPress: () {
          if (_isCurrentUserOwner) {
            HapticFeedback.mediumImpact();
            _showAddStoryOptions();
          }
        },
        child: Stack(
          children: [
            // Black background
            Container(color: Colors.black),

            // Story media container
            Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: screenSize.width,
                      height: screenSize.height * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: storyMediaUrl.isNotEmpty
                            ? (_isVideo &&
                                      _isVideoInitialized &&
                                      _videoController != null)
                                  ? AspectRatio(
                                      aspectRatio:
                                          _videoController!.value.aspectRatio,
                                      child: VideoPlayer(_videoController!),
                                    )
                                  : (!_isVideo
                                        ? Image.network(
                                            storyMediaUrl,
                                            fit: BoxFit.contain,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                color: Colors.black,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircularProgressIndicator(
                                                        value:
                                                            loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                            : null,
                                                        color: Colors.white,
                                                        strokeWidth: 3,
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                      Text(
                                                        'Loading image...',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[400],
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: Colors.black,
                                                    child: const Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .error_outline_rounded,
                                                            color:
                                                                Colors.white54,
                                                            size: 64,
                                                          ),
                                                          SizedBox(height: 16),
                                                          Text(
                                                            'Failed to load image',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white54,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            color: Colors.black,
                                            child: const Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 3,
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    'Loading video...',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                            : Container(
                                color: Colors.black,
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image_rounded,
                                        color: Colors.white54,
                                        size: 64,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No media available',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Top gradient overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Bottom gradient overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Progress indicators
            // Progress indicators
            // Replace the progress indicators section with:
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 8,
              right: 8,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  children: List.generate(
                    _currentUserStories.stories.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          height: 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.5),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1.5),
                            child: _isVideo && _videoController != null
                                ? ValueListenableBuilder(
                                    valueListenable: _videoController!,
                                    builder:
                                        (
                                          context,
                                          VideoPlayerValue value,
                                          child,
                                        ) {
                                          double progress = 0.0;
                                          if (value.isInitialized &&
                                              value.duration.inMilliseconds >
                                                  0) {
                                            progress =
                                                value.position.inMilliseconds /
                                                value.duration.inMilliseconds;
                                          }

                                          return LinearProgressIndicator(
                                            value: index < _currentStoryIndex
                                                ? 1.0
                                                : index > _currentStoryIndex
                                                ? 0.0
                                                : progress.clamp(0.0, 1.0),
                                            backgroundColor: Colors.transparent,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(Colors.white),
                                            minHeight: 2.5,
                                          );
                                        },
                                  )
                                : LinearProgressIndicator(
                                    value: index < _currentStoryIndex
                                        ? 1.0
                                        : index > _currentStoryIndex
                                        ? 0.0
                                        : _animationController.value,
                                    backgroundColor: Colors.transparent,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                    minHeight: 2.5,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // User info header
            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 12,
              right: 12,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  children: [
                    // User avatar
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: ClipOval(
                          child:
                              widget.profile != null &&
                                  widget.profile!.isNotEmpty
                              ? Image.network(
                                  widget.profile!,
                                  fit: BoxFit.cover,
                                  width: 36,
                                  height: 36,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(
                                      'Error loading profile image: $error',
                                    );
                                    return _buildAvatarIcon();
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                )
                              : _buildAvatarIcon(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Username and time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentUserStories.username.isNotEmpty
                                ? _currentUserStories.username
                                : _isCurrentUserOwner
                                ? 'Your Story'
                                : 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            _timeAgo(_currentStory.createdAt),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pause/Play button
                        // GestureDetector(
                        //   onTap: _togglePause,
                        //   child: Container(
                        //     padding: const EdgeInsets.all(6),
                        //     child: Icon(
                        //       _isPaused
                        //           ? Icons.play_arrow_rounded
                        //           : Icons.pause_rounded,
                        //       color: Colors.white,
                        //       size: 24,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(width: 4),

                        // More options button
                        GestureDetector(
                          onTap: _isCurrentUserOwner
                              ? _showAddStoryOptions
                              : _showReportDialog,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.more_vert_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),

                        const SizedBox(width: 4),

                        // Close button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Caption at bottom
            if (_currentStory.caption.isNotEmpty)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: 16,
                right: 16,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _currentStory.caption,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),

            // Loading overlay
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading story...',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Video indicator
            // if (_isVideo && _isVideoInitialized && !_isLoading)
            //   Positioned(
            //     bottom: MediaQuery.of(context).padding.bottom + 80,
            //     right: 16,
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 8,
            //         vertical: 4,
            //       ),
            //       decoration: BoxDecoration(
            //         color: Colors.black.withOpacity(0.6),
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           const Icon(Icons.videocam, color: Colors.white, size: 14),
            //           const SizedBox(width: 4),
            //           Text(
            //             _formatDuration(_videoController!.value.position),
            //             style: const TextStyle(
            //               color: Colors.white,
            //               fontSize: 12,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),

            // Pause indicator
            if (_isPaused && !_isShowingUserOptions)
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
