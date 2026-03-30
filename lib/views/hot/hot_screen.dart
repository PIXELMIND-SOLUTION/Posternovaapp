import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/models/hot_top.dart';
import 'package:posternova/providers/topics/hot_topic_provider.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:posternova/views/reels/exo_video_player.dart';

class HotScreen extends StatefulWidget {
  final int? initialIndex;
  const HotScreen({Key? key, this.initialIndex}) : super(key: key);

  @override
  State<HotScreen> createState() => _HotScreenState();
}

class _HotScreenState extends State<HotScreen> {
  String? userId;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex ?? 0; // Set current page immediately
    _pageController = PageController(initialPage: widget.initialIndex ?? 0);
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
      final hotTopicsProvider = Provider.of<HotTopicsProvider>(
        context,
        listen: false,
      );
      await hotTopicsProvider.fetchHotTopicReels(userId: userId);
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
      body: Consumer<HotTopicsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
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
                key: ValueKey(reel.id),
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
  bool _isPlaying = false;
  bool _showPlayPause = false;
  String _username = 'Username';
  String? _profileImage;

  // Download state
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _downloadStatus = ''; // 'downloading' | 'processing' | ''

  // Business info
  String _businessName = 'Business Name';
  String _phoneNumber = 'Not Set';
  double _businessNameFontSize = 16.0;
  double _phoneNumberFontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isCurrentPage;
    _loadUsername();
    _loadBusinessInfo();
  }

  @override
  void didUpdateWidget(HotReelItem oldWidget) {
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
    final provider = Provider.of<HotTopicsProvider>(context, listen: false);

    // Optimistically update UI
    setState(() {
      // Update local state immediately for better UX
      if (widget.reel.isLiked) {
        widget.reel.likes--;
        widget.reel.isLiked = false;
      } else {
        widget.reel.likes++;
        widget.reel.isLiked = true;
      }
    });

    // Call the API
    final success = await provider.toggleLike(widget.reel.id);

    // If failed, revert the optimistic update
    if (!success && mounted) {
      setState(() {
        if (widget.reel.isLiked) {
          widget.reel.likes--;
          widget.reel.isLiked = false;
        } else {
          widget.reel.likes++;
          widget.reel.isLiked = true;
        }
      });

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
      await Share.share(
        'Check out this hot topic!\n${widget.reel.videoUrl}\n\nBy ❤️ using Edit Ezy',
        subject: 'Hot Topic from EditEzy',
      );
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  Future<String?> _createVideoWithOverlaySimple(
    String videoPath,
    int ts,
  ) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/hot_overlay_$ts.mp4';

      // Get video dimensions
      final dimensions = await _getVideoDimensionsCorrect(videoPath);
      final videoWidth = dimensions['width']!;
      final videoHeight = dimensions['height']!;

      debugPrint('✅ Correct video dimensions: ${videoWidth}x${videoHeight}');

      // Calculate position - bar at the BOTTOM
      final barY = videoHeight - 80;

      // Escape text properly
      final safeBizName = _businessName
          .replaceAll("'", r"\'")
          .replaceAll(":", r"\:")
          .replaceAll(",", r"\,")
          .replaceAll("=", r"\=");

      final safePhone = _phoneNumber
          .replaceAll("'", r"\'")
          .replaceAll(":", r"\:")
          .replaceAll(",", r"\,")
          .replaceAll("=", r"\=");

      // Use a built-in font
      final fontFile = '/system/fonts/DroidSans.ttf';

      // Create filter with absolute positioning
      final command = [
        '-i',
        '"$videoPath"',
        '-vf',
        '"' +
            // Draw black bar at bottom
            'drawbox=x=0:y=$barY:w=$videoWidth:h=80:color=black@0.85:t=fill,' +
            // Draw white top border
            'drawbox=x=0:y=$barY:w=$videoWidth:h=2:color=white@0.5:t=fill,' +
            // Business name text with explicit font
            'drawtext=text=\'BUSINESS\':' +
            'x=16:y=${barY + 20}:' +
            'fontsize=10:' +
            'fontcolor=white@0.6:' +
            'fontfile=$fontFile,' +
            // Business name value
            'drawtext=text=\'$safeBizName\':' +
            'x=16:y=${barY + 40}:' +
            'fontsize=${_businessNameFontSize.round()}:' +
            'fontcolor=white:' +
            'fontfile=$fontFile:' +
            'fontweight=bold,' +
            // Draw divider
            'drawbox=x=${videoWidth ~/ 2}:y=${barY + 10}:w=2:h=60:color=white@0.4:t=fill,' +
            // Phone label text
            'drawtext=text=\'CALL US\':' +
            'x=${videoWidth ~/ 2 + 20}:y=${barY + 20}:' +
            'fontsize=10:' +
            'fontcolor=white@0.6:' +
            'fontfile=$fontFile,' +
            // Phone number value
            'drawtext=text=\'$safePhone\':' +
            'x=${videoWidth ~/ 2 + 20}:y=${barY + 40}:' +
            'fontsize=${_phoneNumberFontSize.round()}:' +
            'fontcolor=white:' +
            'fontfile=$fontFile:' +
            'fontweight=bold' +
            '"',
        '-c:v',
        'libx264',
        '-preset',
        'ultrafast',
        '-crf',
        '28',
        '-c:a',
        'copy',
        '-y',
        '"$outputPath"',
      ].join(' ');

      debugPrint('FFmpeg command: $command');

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final file = File(outputPath);
        if (await file.exists()) {
          final size = await file.length();
          debugPrint('✅ Output file created, size: $size bytes');
          return outputPath;
        }
      }

      final logs = await session.getAllLogsAsString();
      debugPrint('❌ FFmpeg failed: $logs');
      return null;
    } catch (e) {
      debugPrint('Simple overlay error: $e');
      return null;
    }
  }

  // Correct dimension detection using ffprobe
  Future<Map<String, int>> _getVideoDimensionsCorrect(String videoPath) async {
    try {
      // Use ffprobe to get video dimensions
      final command = '-i "$videoPath" -hide_banner';
      final session = await FFmpegKit.execute(command);
      final logs = await session.getAllLogsAsString();

      debugPrint('FFprobe output: $logs');

      // Look for the video stream info - the pattern is "Stream #0:0: Video: ... 480x848"
      final regex = RegExp(r'Stream #0:\d+.*Video:.* (\d+)x(\d+)');
      final match = regex.firstMatch(logs.toString());

      if (match != null) {
        final width = int.parse(match.group(1)!);
        final height = int.parse(match.group(2)!);
        debugPrint('✅ Detected dimensions: ${width}x$height');
        return {'width': width, 'height': height};
      }

      // If that fails, try a simpler regex
      final simpleRegex = RegExp(r'(\d+)x(\d+)');
      final matches = simpleRegex.allMatches(logs.toString());

      // Get the first match that looks reasonable (not 0x0)
      for (final m in matches) {
        final w = int.parse(m.group(1)!);
        final h = int.parse(m.group(2)!);
        if (w > 100 && h > 100) {
          debugPrint('✅ Detected dimensions (alt): ${w}x$h');
          return {'width': w, 'height': h};
        }
      }
    } catch (e) {
      debugPrint('Error getting dimensions: $e');
    }

    // Default fallback - your video is 480x848
    debugPrint('⚠️ Using default dimensions: 480x848');
    return {'width': 480, 'height': 848};
  }

  // ── FFmpeg: burn business bar overlay onto video before saving ──
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
      _downloadStatus = 'downloading';
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final videoPath = '${tempDir.path}/hot_video_$ts.mp4';
      final outputPath = '${tempDir.path}/hot_output_$ts.mp4';

      // Step 1: Download video
      final dio = Dio();
      await dio.download(
        widget.reel.videoUrl,
        videoPath,
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => _downloadProgress = received / total);
          }
        },
      );

      if (mounted) {
        setState(() {
          _downloadStatus = 'processing';
          _downloadProgress = 0.0;
        });
      }

      // Try multiple methods in order of preference
      String? finalPath;

      // Method 1: Try FFmpeg with simplest possible filter
      debugPrint('METHOD 1: Trying simple FFmpeg overlay');
      finalPath = await _createVideoWithOverlaySimple(videoPath, ts);

      // Method 2: If Method 1 fails, try with image overlay approach
      if (finalPath == null) {
        debugPrint('METHOD 2: Trying image-based overlay');
        finalPath = await _createVideoWithImageOverlay(videoPath, ts);
      }

      // Method 3: If all else fails, save original video
      if (finalPath == null) {
        debugPrint('METHOD 3: Saving original video');
        finalPath = videoPath;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saving video without branding bar'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }

      // Save to gallery
      if (finalPath != null && await File(finalPath).exists()) {
        await Gal.putVideo(finalPath, album: 'EditEzy');

        if (mounted) {
          final hasBar = finalPath != videoPath;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                hasBar
                    ? 'Video with branding saved!'
                    : 'Video saved (branding unavailable)',
              ),
              backgroundColor: hasBar ? Colors.green : Colors.blue,
            ),
          );
        }
      }

      // Cleanup
      for (final path in [videoPath, outputPath]) {
        try {
          if (path != videoPath && await File(path).exists()) {
            await File(path).delete();
          }
        } catch (e) {
          debugPrint('Cleanup error: $e');
        }
      }
    } catch (e) {
      debugPrint('Download error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
          _downloadStatus = '';
        });
      }
    }
  }

  Future<String?> _createVideoWithImageOverlay(String videoPath, int ts) async {
    try {
      final tempDir = await getTemporaryDirectory();

      // Get video dimensions
      final dimensions = await _getVideoDimensionsCorrect(videoPath);
      final videoWidth = dimensions['width']!;
      final videoHeight = dimensions['height']!;

      debugPrint('Creating overlay for ${videoWidth}x$videoHeight');

      // Step 1: Create overlay image with CORRECT positioning
      final imagePath = '${tempDir.path}/overlay_$ts.png';
      await _createCorrectOverlayImage(imagePath, videoWidth, videoHeight);

      // Verify image was created
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        debugPrint('❌ Failed to create overlay image');
        return null;
      }

      // Step 2: Overlay image on video - use main_h - overlay_h to position at bottom
      final outputPath = '${tempDir.path}/hot_final_$ts.mp4';

      // The correct filter: overlay=0:main_h-overlay_h (places overlay at bottom)
      final command =
          '''
    -i "$videoPath" 
    -i "$imagePath" 
    -filter_complex "[0:v][1:v]overlay=0:main_h-overlay_h"
    -c:v libx264 -preset ultrafast -crf 28 -c:a copy -y "$outputPath"
    '''
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();

      debugPrint('Image overlay command: $command');

      final session = await FFmpegKit.execute(command);
      final returnCode = await session.getReturnCode();

      // Cleanup image
      try {
        await imageFile.delete();
      } catch (_) {}

      if (ReturnCode.isSuccess(returnCode)) {
        final file = File(outputPath);
        if (await file.exists()) {
          final size = await file.length();
          debugPrint('✅ Output file created, size: $size bytes');
          return outputPath;
        }
      }

      final logs = await session.getAllLogsAsString();
      debugPrint('❌ Image overlay failed: $logs');
      return null;
    } catch (e) {
      debugPrint('Image overlay error: $e');
      return null;
    }
  }

  Future<void> _createCorrectOverlayImage(
    String path,
    int videoWidth,
    int videoHeight,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    const barHeight = 80.0;
    final width = videoWidth.toDouble();

    // Draw the bar at the BOTTOM of the image
    // Draw background bar (at the top of the image since image will be at bottom)
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.85);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, barHeight), bgPaint);

    // Draw top border (at the top of the image)
    final borderPaint = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, 2), borderPaint);

    // Draw business name
    _drawTextCorrect(
      canvas,
      _businessName,
      70,
      50,
      _businessNameFontSize,
      Colors.white,
    );

    // Draw divider
    final dividerPaint = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawRect(Rect.fromLTWH(width / 2, 10, 2, 60), dividerPaint);

    // Draw phone number
    _drawTextCorrect(
      canvas,
      _phoneNumber,
      width / 2 + 70,
      50,
      _phoneNumberFontSize,
      Colors.white,
    );

    // Convert to image - create an image that's ONLY the bar height
    final picture = recorder.endRecording();
    final image = await picture.toImage(videoWidth, barHeight.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    if (bytes != null) {
      await File(path).writeAsBytes(bytes.buffer.asUint8List());
      debugPrint('✅ Overlay image created: ${videoWidth}x$barHeight');
    }
  }

  void _drawTextCorrect(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
    Color color,
  ) {
    final builder =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontSize: fontSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          )
          ..pushStyle(ui.TextStyle(color: color))
          ..addText(text);

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: 200));

    canvas.drawParagraph(paragraph, Offset(x, y - fontSize / 2));
  }

  void _showEditDialog({
    required String title,
    required String currentValue,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onSave,
  }) {
    final controller = TextEditingController(text: currentValue);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header with gradient
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Update your $title',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, indent: 24, endIndent: 24),

            // Form content
            Expanded(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Input field with modern design
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextFormField(
                          controller: controller,
                          keyboardType: keyboardType,
                          autofocus: true,
                          style: const TextStyle(fontSize: 16),
                          maxLength: keyboardType == TextInputType.phone
                              ? 15
                              : 50,
                          decoration: InputDecoration(
                            hintText: 'Enter $title',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(
                              icon,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            counterStyle: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter $title';
                            }
                            if (keyboardType == TextInputType.phone &&
                                value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                      ),

                      const Spacer(),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                side: BorderSide(color: Colors.grey[300]!),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  onSave(controller.text);
                                  Navigator.pop(context);

                                  // Show success snackbar with animation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                color: Colors.white24,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    'Success',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    '$title updated successfully',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: const EdgeInsets.all(16),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C3AED),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text('Save Changes'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Customize Branding Bar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),

              // Business Name tile
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
                  'Business Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _businessName,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
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

              // Business name font size
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_size,
                      color: Colors.purple.shade400,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _businessNameFontSize,
                        min: 10,
                        max: 24,
                        divisions: 14,
                        activeColor: Colors.purple.shade600,
                        inactiveColor: Colors.purple.shade100,
                        onChanged: (v) {
                          setState(() => _businessNameFontSize = v);
                          setModalState(() {});
                        },
                      ),
                    ),
                    Container(
                      width: 30,
                      alignment: Alignment.center,
                      child: Text(
                        '${_businessNameFontSize.round()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, indent: 16, endIndent: 16),

              // Phone tile
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
                  'Phone Number',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _phoneNumber,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Colors.grey,
                ),
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

              // Phone font size
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_size,
                      color: Colors.blue.shade400,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _phoneNumberFontSize,
                        min: 10,
                        max: 24,
                        divisions: 14,
                        activeColor: Colors.blue.shade600,
                        inactiveColor: Colors.blue.shade100,
                        onChanged: (v) {
                          setState(() => _phoneNumberFontSize = v);
                          setModalState(() {});
                        },
                      ),
                    ),
                    Container(
                      width: 30,
                      alignment: Alignment.center,
                      child: Text(
                        '${_phoneNumberFontSize.round()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Info note
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber.shade700,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Branding bar is burned into downloaded videos',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.amber.shade800,
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
      ),
    );
  }

  // ── Professional Business Info Bar ──
  Widget _buildBusinessInfoBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: _showBottomInfoEditOptions,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.75),
                Colors.black.withOpacity(0.92),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // ── Business Name Section (Text Only) ──
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'BUSINESS',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.5),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _businessName,
                        style: TextStyle(
                          fontSize: _businessNameFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Divider ──
              Container(
                width: 1,
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.4),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // ── Phone Number Section (Text Only) ──
              Expanded(
                child: GestureDetector(
                  onTap: () => _showEditDialog(
                    title: 'Edit Number',
                    currentValue: _phoneNumber,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onSave: (v) => setState(() => _phoneNumber = v),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CALL US',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.5),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _phoneNumber,
                        style: TextStyle(
                          fontSize: _phoneNumberFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
          // ── Video using ExoVideoPlayer ──
          ExoVideoPlayer(
            key: ValueKey('${widget.reel.id}_${widget.isCurrentPage}'),
            url: widget.reel.videoUrl,
            autoPlay: _isPlaying,
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
                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
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
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),

          // ── Right side actions ──
          // In the build method of _HotReelItemState, replace the Consumer section:

          // ── Right side actions ──
          // ── Right side actions ──
          Positioned(
            right: 12,
            bottom: 145,
            child: Column(
              children: [
                // Like button - FIXED VERSION
                // Consumer<HotTopicsProvider>(
                //   builder: (context, provider, _) {
                //     // Find the current reel
                //     final currentReel = provider.reels.firstWhere(
                //       (r) => r.id == widget.reel.id,
                //       orElse: () => widget.reel, // Fallback to local reel
                //     );

                //     final bool isLiked = currentReel.isLiked;
                //     final int likeCount = currentReel.likes;

                //     return _ActionButton(
                //       icon: isLiked ? Icons.favorite : Icons.favorite_border,
                //       iconColor: isLiked ? Colors.red : Colors.white,
                //       label: _formatCount(likeCount),
                //       onTap: () => _toggleLike(),
                //     );
                //   },
                // ),
                // const SizedBox(height: 20),
                _ActionButton(icon: Icons.reply, label: '', onTap: _shareReel),
                const SizedBox(height: 20),

                // Download button
                _isDownloading
                    ? SizedBox(
                        width: 48,
                        height: 64,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CircularProgressIndicator(
                                    value: _downloadStatus == 'processing'
                                        ? null
                                        : (_downloadProgress > 0
                                              ? _downloadProgress
                                              : null),
                                    color: _downloadStatus == 'processing'
                                        ? Colors.orangeAccent
                                        : Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                                Icon(
                                  _downloadStatus == 'processing'
                                      ? Icons.auto_fix_high
                                      : Icons.download,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ],
                            ),
                            Text(
                              _downloadStatus == 'processing'
                                  ? 'Branding'
                                  : _downloadProgress > 0
                                  ? '${(_downloadProgress * 100).toInt()}%'
                                  : '...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 6,
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
                // const SizedBox(height: 20),

                // _ActionButton(
                //   icon: Icons.more_vert,
                //   label: '',
                //   onTap: () => _showOptionsBottomSheet(context),
                // ),
              ],
            ),
          ),

          // ── Bottom left: user info ──
          Positioned(
            left: 16,
            right: 80,
            bottom: 85,
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
              ],
            ),
          ),

          // ── Business Info Bar (always on top) ──
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
              label: 'Save with branding',
              onTap: () {
                Navigator.pop(context);
                _downloadReel();
              },
            ),
            _BottomSheetOption(
              icon: Icons.tune,
              label: 'Edit branding bar',
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
