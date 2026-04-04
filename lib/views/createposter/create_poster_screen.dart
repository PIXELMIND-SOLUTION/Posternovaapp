import 'package:flutter/material.dart';
import 'package:posternova/models/create_poster_model.dart';
import 'package:posternova/views/NavBar/navbar_screen.dart';
import 'package:posternova/views/SecondPhase/template_create.dart';
import 'package:posternova/widgets/language_widget.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> with TickerProviderStateMixin {
  final List<Map<String, String>> postTypes = const [
    {"title": "square_post", "size": "2400*2400", "icon": "square"},
    {"title": "story_post", "size": "750*1334", "icon": "portrait"},
    {"title": "display_picture", "size": "1200*1200", "icon": "account"},
    {"title": "instagram_post", "size": "1080*1350", "icon": "instagram"},
    {"title": "a4_size", "size": "2480*3507", "icon": "document"},
    {"title": "certificate", "size": "850*1100", "icon": "award"},
  ];

  String search = '';
  late AnimationController _fadeController;
  late AnimationController _listController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _listController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredList {
    final q = search.trim().toLowerCase();
    if (q.isEmpty) return postTypes;
    return postTypes.where((p) {
      final title = p['title']!.toLowerCase();
      return title.contains(q);
    }).toList();
  }

  String humanizeTitle(String raw) {
    final parts = raw.split(RegExp(r'[_\s]+'));
    final capitalized = parts
        .map((p) {
          if (p.isEmpty) return '';
          return p[0].toUpperCase() + p.substring(1);
        })
        .join(' ');
    return capitalized.trim();
  }

  IconData _getIconForType(String iconType) {
    switch (iconType) {
      case 'square':
        return Icons.crop_square;
      case 'portrait':
        return Icons.crop_portrait;
      case 'landscape':
        return Icons.crop_landscape;
      case 'account':
        return Icons.account_circle_outlined;
      case 'instagram':
        return Icons.photo_library_outlined;
      case 'video':
        return Icons.play_circle_outline;
      case 'document':
        return Icons.description_outlined;
      case 'award':
        return Icons.workspace_premium_outlined;
      default:
        return Icons.image_outlined;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Social':
        return const Color(0xFF3B82F6);
      case 'Print':
        return const Color(0xFF10B981);
      case 'Profile':
        return const Color(0xFFEC4899);
      case 'Cover':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 800;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
            ),
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F172A)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'choose_canvas_size',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDarkMode ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            AppText(
              'select_perfect_size',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.help_outline,
        //       color: isDarkMode ? Colors.grey[400] : const Color(0xFF64748B),
        //     ),
        //     tooltip: 'Help',
        //   ),
        // ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _listController,
                builder: (context, child) {
                  return _buildGridView(isWide, isDarkMode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(bool isWide, bool isDarkMode) {
    final filtered = filteredList;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No sizes found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final post = filtered[index];
        final delay = index * 60;

        final slideAnimation =
            Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _listController,
                curve: Interval(
                  (delay / 900).clamp(0.0, 1.0),
                  ((delay + 400) / 900).clamp(0.0, 1.0),
                  curve: Curves.easeOutCubic,
                ),
              ),
            );

        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _listController,
            curve: Interval(
              (delay / 900).clamp(0.0, 1.0),
              ((delay + 400) / 900).clamp(0.0, 1.0),
              curve: Curves.easeOut,
            ),
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: _buildSizeCard(post, isDarkMode),
          ),
        );
      },
    );
  }

  Widget _buildSizeCard(Map<String, String> post, bool isDarkMode) {
    final posterSize = PosterSize.fromMap(post);
    final title = humanizeTitle(post['title'] ?? '');
    final category = post['category'] ?? 'Social';
    final categoryColor = _getColorForCategory(category);
    final icon = _getIconForType(post['icon'] ?? 'square');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                TemplateCreate(posterSize: posterSize),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  );
                  return FadeTransition(
                    opacity: curvedAnimation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.95,
                        end: 1.0,
                      ).animate(curvedAnimation),
                      child: child,
                    ),
                  );
                },
            transitionDuration: const Duration(milliseconds: 350),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      categoryColor.withOpacity(isDarkMode ? 0.2 : 0.1),
                      categoryColor.withOpacity(isDarkMode ? 0.05 : 0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 48,
                    color: categoryColor.withOpacity(isDarkMode ? 0.4 : 0.3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.crop_free,
                        size: 14,
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          post['size'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
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
      ),
    );
  }
}
