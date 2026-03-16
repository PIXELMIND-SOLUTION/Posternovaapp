import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/providers/topics/hot_topic_provider.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';

class HotScreen extends StatefulWidget {
  const HotScreen({Key? key}) : super(key: key);

  @override
  State<HotScreen> createState() => _HotScreenState();
}

class _HotScreenState extends State<HotScreen> {
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
      Provider.of<HotTopicReelsProvider>(context, listen: false)
          .loadHotTopicReels(userId!);
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
        title: const Text(
          'Hot Topics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<HotTopicReelsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            );
          }

          if (provider.status == ReelsStatus.error) {
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
                    provider.errorMessage ?? 'Something went wrong',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (userId != null) {
                        provider.loadHotTopicReels(userId!);
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

          if (provider.reels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department_outlined,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hot topics yet',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later',
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
            itemCount: provider.reels.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final reel = provider.reels[index];
              return HotReelItem(
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

// ══════════════════════════════════════════════════════════════════════════════
// HOT REEL ITEM
// ══════════════════════════════════════════════════════════════════════════════

class HotReelItem extends StatefulWidget {
  final dynamic reel;
  final String userId;
  final bool isCurrentPage;

  const HotReelItem({
    Key? key,
    required this.reel,
    required this.userId,
    required this.isCurrentPage,
  }) : super(key: key);

  @override
  State<HotReelItem> createState() => _HotReelItemState();
}

class _HotReelItemState extends State<HotReelItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showPlayPause = false;
  String _username = 'Username';
  String? _profileImage;

  // Download state
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  // Business info
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
      final uid = userData.user.id;
      final response = await http.get(
        Uri.parse('http://31.97.206.144:4061/api/users/get-profile/$uid'),
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

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.reel.videoUrl)
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() => _isInitialized = true);
              if (widget.isCurrentPage) _controller.play();
              _controller.setLooping(true);
            }
          })
          .catchError((e) => debugPrint('Video init error: $e'));
  }

  @override
  void didUpdateWidget(HotReelItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrentPage && !_controller.value.isPlaying) {
      _controller.play();
    } else if (!widget.isCurrentPage && _controller.value.isPlaying) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
      _showPlayPause = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showPlayPause = false);
    });
  }

  void _toggleLike() {
    final provider =
        Provider.of<HotTopicReelsProvider>(context, listen: false);
    provider.toggleLike(widget.reel.id);
  }

  void _shareReel() async {
    try {
      await Share.share(
        'Check out this hot topic!\n${widget.reel.videoUrl}\n\nBy ❤️ using Edit Ezy',
        subject: 'Hot Topic from EditEzy',
      );
    } catch (e) {
      debugPrint('Share error: $e');
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
      final fileName = 'hot_${DateTime.now().millisecondsSinceEpoch}.mp4';
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
                Text('Saved to gallery!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Download error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download'),
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
          autofocus: true,
          decoration: InputDecoration(
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
                  content: Text('$title updated!'),
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
                title: const Text('Edit Business Name',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(_businessName,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(
                    title: 'Edit Name',
                    currentValue: _businessName,
                    icon: Icons.business,
                    onSave: (v) async {
                      await _saveBusinessName(v);
                      setState(() => _businessName = v);
                    },
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.text_fields,
                        color: Colors.purple.shade700, size: 20),
                    const SizedBox(width: 12),
                    const Text('Name Size:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Expanded(
                      child: Slider(
                        value: _businessNameFontSize,
                        min: 10,
                        max: 24,
                        divisions: 14,
                        activeColor: Colors.purple.shade700,
                        onChanged: (v) {
                          setState(() => _businessNameFontSize = v);
                          setModalState(() {});
                        },
                      ),
                    ),
                    Text('${_businessNameFontSize.round()}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
                title: const Text('Edit Phone Number',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(_phoneNumber,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(
                    title: 'Edit Number',
                    currentValue: _phoneNumber,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onSave: (v) => setState(() => _phoneNumber = v),
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.text_fields,
                        color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 12),
                    const Text('Phone Size:',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Expanded(
                      child: Slider(
                        value: _phoneNumberFontSize,
                        min: 10,
                        max: 24,
                        divisions: 14,
                        activeColor: Colors.blue.shade700,
                        onChanged: (v) {
                          setState(() => _phoneNumberFontSize = v);
                          setModalState(() {});
                        },
                      ),
                    ),
                    Text('${_phoneNumberFontSize.round()}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    onSave: (v) async {
                      await _saveBusinessName(v);
                      setState(() => _businessName = v);
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
                        child: const Icon(Icons.business,
                            color: Colors.white, size: 20),
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
                    onSave: (v) => setState(() => _phoneNumber = v),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.phone,
                            color: Colors.white, size: 20),
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
          // ── Video ──
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
                    color: Colors.white, strokeWidth: 2),
              ),
            ),

          // ── Gradient ──
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
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Play/Pause indicator ──
          if (_showPlayPause)
            Center(
              child: AnimatedOpacity(
                opacity: 1.0,
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

          // ── Right side actions ──
          Positioned(
            right: 12,
            bottom: 145,
            child: Column(
              children: [
                // Like button
                Consumer<HotTopicReelsProvider>(
                  builder: (context, provider, _) {
                    final current = provider.reels.firstWhere(
                      (r) => r.id == widget.reel.id,
                      orElse: () => widget.reel,
                    );
                    return _ActionButton(
                      icon: current.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      iconColor: current.isLiked ? Colors.red : Colors.white,
                      label: _formatCount(current.likeCount),
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

                _ActionButton(
                  icon: Icons.more_vert,
                  label: '',
                  onTap: () => _showOptionsBottomSheet(context),
                ),
              ],
            ),
          ),

          // ── Bottom left: user info ──
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
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 18),
                              ),
                            )
                          : const Icon(Icons.person,
                              color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Text(
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
                const Text(
                  'Hot Topic 🔥',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Trending Now',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Business Info Bar ──
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
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

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
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}