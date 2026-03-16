

// ─── Data Models ────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class StickerCategory {
  final String title;
  final int count;
  final IconData icon;
  final Color iconBg;
  final List<StickerItem> stickers;

  const StickerCategory({
    required this.title,
    required this.count,
    required this.icon,
    required this.iconBg,
    required this.stickers,
  });
}

class StickerItem {
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData icon;
  final String? subtitle;

  const StickerItem({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.icon,
    this.subtitle,
  });
}

// ─── Sample Data ─────────────────────────────────────────────────────────────

final List<StickerCategory> brandingCategories = [
  StickerCategory(
    title: 'Arts & Entertainment',
    count: 34,
    icon: Icons.brush,
    iconBg: const Color(0xFFFFC107),
    stickers: [
      StickerItem(label: 'Vocal Vibes', bgColor: const Color(0xFF1A1A2E), textColor: Colors.white, icon: Icons.mic),
      StickerItem(label: 'String Thing', bgColor: const Color(0xFF2D2D2D), textColor: Colors.white, icon: Icons.music_note),
      StickerItem(label: 'Craft Queen', bgColor: const Color(0xFFFFF3E0), textColor: Colors.orange, icon: Icons.palette),
      StickerItem(label: 'Ballet Boss', bgColor: const Color(0xFFFCE4EC), textColor: Colors.pink, icon: Icons.accessibility_new),
      StickerItem(label: 'Handmade Hustle', bgColor: const Color(0xFF1A1A1A), textColor: Colors.white, icon: Icons.favorite),
      StickerItem(label: 'Modern Music', bgColor: const Color(0xFF0D47A1), textColor: Colors.white, icon: Icons.headphones),
      StickerItem(label: 'Make Creative', bgColor: const Color(0xFFF3E5F5), textColor: Colors.purple, icon: Icons.lightbulb),
      StickerItem(label: 'Singing Classes', bgColor: const Color(0xFF4A0404), textColor: Colors.amber, icon: Icons.mic_external_on),
      StickerItem(label: 'Casting Call', bgColor: const Color(0xFF0A0A0A), textColor: Colors.white, icon: Icons.theater_comedy),
      StickerItem(label: 'Kala Kendra', bgColor: const Color(0xFF880E4F), textColor: Colors.white, icon: Icons.sports_gymnastics),
      StickerItem(label: 'Art Workshop', bgColor: const Color(0xFFE8F5E9), textColor: Colors.green, icon: Icons.draw),
      StickerItem(label: 'Dance Academy', bgColor: const Color(0xFFE3F2FD), textColor: Colors.blue, icon: Icons.self_improvement),
    ],
  ),
  StickerCategory(
    title: 'Payment Reminders',
    count: 79,
    icon: Icons.notifications,
    iconBg: const Color(0xFFFFC107),
    stickers: [
      StickerItem(label: 'Cash Clear Karo', bgColor: const Color(0xFF1B5E20), textColor: Colors.white, icon: Icons.payments),
      StickerItem(label: 'Paise De Do', bgColor: const Color(0xFFFFF9C4), textColor: Colors.orange, icon: Icons.currency_rupee),
      StickerItem(label: 'Payment Due', bgColor: const Color(0xFFFFEBEE), textColor: Colors.red, icon: Icons.warning),
      StickerItem(label: 'Bill Clear', bgColor: const Color(0xFF0D47A1), textColor: Colors.white, icon: Icons.receipt),
      StickerItem(label: 'Amount Pending', bgColor: const Color(0xFF4A148C), textColor: Colors.white, icon: Icons.pending),
      StickerItem(label: 'Pay Now', bgColor: const Color(0xFFE65100), textColor: Colors.white, icon: Icons.send),
      StickerItem(label: 'Due Today', bgColor: const Color(0xFFF3E5F5), textColor: Colors.purple, icon: Icons.today),
      StickerItem(label: 'Invoice Ready', bgColor: const Color(0xFFE8F5E9), textColor: Colors.green, icon: Icons.description),
    ],
  ),
  StickerCategory(
    title: 'Anniversary',
    count: 31,
    icon: Icons.calendar_month,
    iconBg: const Color(0xFFFFC107),
    stickers: [
      StickerItem(label: 'Happy Anniversary', bgColor: const Color(0xFF880E4F), textColor: Colors.white, icon: Icons.favorite),
      StickerItem(label: 'Years Together', bgColor: const Color(0xFFB71C1C), textColor: Colors.white, icon: Icons.celebration),
      StickerItem(label: 'Golden Memories', bgColor: const Color(0xFFFFF8E1), textColor: Colors.amber, icon: Icons.star),
      StickerItem(label: 'Love Forever', bgColor: const Color(0xFFFCE4EC), textColor: Colors.pink, icon: Icons.favorite_border),
      StickerItem(label: 'Special Day', bgColor: const Color(0xFF1A237E), textColor: Colors.white, icon: Icons.cake),
      StickerItem(label: 'Celebrate Love', bgColor: const Color(0xFFE8EAF6), textColor: Colors.indigo, icon: Icons.emoji_events),
    ],
  ),
  StickerCategory(
    title: 'Thank You For Your Purchase',
    count: 19,
    icon: Icons.thumb_up,
    iconBg: const Color(0xFFFFC107),
    stickers: [
      StickerItem(label: 'Thank You', bgColor: const Color(0xFF1B5E20), textColor: Colors.white, icon: Icons.thumb_up),
      StickerItem(label: 'Shopping Done', bgColor: const Color(0xFFE3F2FD), textColor: Colors.blue, icon: Icons.shopping_bag),
      StickerItem(label: 'Come Back', bgColor: const Color(0xFFFFF3E0), textColor: Colors.orange, icon: Icons.store),
      StickerItem(label: 'Enjoy!', bgColor: const Color(0xFFF3E5F5), textColor: Colors.purple, icon: Icons.celebration),
    ],
  ),
];

final List<StickerCategory> allIndustryCategories = [
  StickerCategory(
    title: 'Food & Restaurant',
    count: 45,
    icon: Icons.restaurant,
    iconBg: const Color(0xFFFFC107),
    stickers: [
      StickerItem(label: 'Taste of India', bgColor: const Color(0xFFBF360C), textColor: Colors.white, icon: Icons.restaurant_menu),
      StickerItem(label: 'Fresh Daily', bgColor: const Color(0xFF1B5E20), textColor: Colors.white, icon: Icons.eco),
      StickerItem(label: 'Chef Special', bgColor: const Color(0xFF4A148C), textColor: Colors.white, icon: Icons.soup_kitchen),
      StickerItem(label: 'Order Now', bgColor: const Color(0xFFE65100), textColor: Colors.white, icon: Icons.delivery_dining),
    ],
  ),
  StickerCategory(
    title: 'Healthcare',
    count: 28,
    icon: Icons.local_hospital,
    iconBg: const Color(0xFFFFC107),
    stickers: [
      StickerItem(label: 'Stay Healthy', bgColor: const Color(0xFF006064), textColor: Colors.white, icon: Icons.health_and_safety),
      StickerItem(label: 'Clinic Hours', bgColor: const Color(0xFFE3F2FD), textColor: Colors.blue, icon: Icons.access_time),
      StickerItem(label: 'Book Appointment', bgColor: const Color(0xFFE8F5E9), textColor: Colors.green, icon: Icons.calendar_today),
    ],
  ),
  StickerCategory(
    title: 'Education',
    count: 52,
    icon: Icons.school,
    iconBg: const Color(0xFFFFC107),
    stickers: [
      StickerItem(label: 'Enroll Now', bgColor: const Color(0xFF0D47A1), textColor: Colors.white, icon: Icons.school),
      StickerItem(label: 'Learn Today', bgColor: const Color(0xFFFFF9C4), textColor: Colors.orange, icon: Icons.menu_book),
      StickerItem(label: 'New Batch', bgColor: const Color(0xFF1B5E20), textColor: Colors.white, icon: Icons.group),
      StickerItem(label: 'Scholarship', bgColor: const Color(0xFFE8EAF6), textColor: Colors.indigo, icon: Icons.emoji_events),
    ],
  ),
];

// ─── Main Screen ─────────────────────────────────────────────────────────────

class WhatsAppStickerScreen extends StatefulWidget {
  const WhatsAppStickerScreen({super.key});

  @override
  State<WhatsAppStickerScreen> createState() => _WhatsAppStickerScreenState();
}

class _WhatsAppStickerScreenState extends State<WhatsAppStickerScreen> {
  int _selectedTab = 0; // 0 = Branding, 1 = All Industry

  List<StickerCategory> get _currentCategories =>
      _selectedTab == 0 ? brandingCategories : allIndustryCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildBanner(),
          _buildTabBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _currentCategories.length,
              itemBuilder: (context, index) {
                return _buildCategorySection(_currentCategories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: const BackButton(color: Colors.black),
      title: const Text(
        'WhatsApp Stickers',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC107), Color(0xFFFF8C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create your own',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'WhatsApp Stickers',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'in just 1 click & add to\nyour WhatsApp.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.phone_android, size: 50, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          _buildTab('Branding', 0),
          const SizedBox(width: 10),
          _buildTab('All industry', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFC107) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? const Color(0xFFFFC107) : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(StickerCategory category) {
    final visibleStickers = category.stickers.take(4).toList();
    final remaining = category.count - 4;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: category.iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${category.count} Stickers',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.diamond, color: Color(0xFFFF8C00), size: 20),
                ),
              ],
            ),
          ),

          // Sticker Grid Row
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 14),
            child: Row(
              children: [
                ...visibleStickers.map((sticker) => Expanded(
                      child: GestureDetector(
                        onTap: () => _openCategoryDetail(category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          height: 80,
                          decoration: BoxDecoration(
                            color: sticker.bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(sticker.icon, color: sticker.textColor, size: 24),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Text(
                                  sticker.label,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: sticker.textColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                // "+X More" tile
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openCategoryDetail(category),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+$remaining',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'More',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openCategoryDetail(StickerCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StickerDetailScreen(
          initialCategory: category,
          allCategories: _currentCategories,
        ),
      ),
    );
  }
}

// ─── Detail Screen ────────────────────────────────────────────────────────────

class StickerDetailScreen extends StatefulWidget {
  final StickerCategory initialCategory;
  final List<StickerCategory> allCategories;

  const StickerDetailScreen({
    super.key,
    required this.initialCategory,
    required this.allCategories,
  });

  @override
  State<StickerDetailScreen> createState() => _StickerDetailScreenState();
}

class _StickerDetailScreenState extends State<StickerDetailScreen> {
  late StickerCategory _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'WhatsApp Sticker',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(child: _buildStickerGrid()),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.allCategories.map((cat) {
            final isSelected = cat.title == _selectedCategory.title;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFC107) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFFC107) : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  cat.title,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStickerGrid() {
    final stickers = _selectedCategory.stickers;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: stickers.length,
      itemBuilder: (context, index) {
        final sticker = stickers[index];
        return _buildStickerTile(sticker);
      },
    );
  }

  Widget _buildStickerTile(StickerItem sticker) {
    return Container(
      decoration: BoxDecoration(
        color: sticker.bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade700,
          width: 2,
          style: BorderStyle.solid,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dashed border effect (simulated)
          Positioned.fill(
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: Colors.green.shade600,
                radius: 12,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(sticker.icon, color: sticker.textColor, size: 32),
                const SizedBox(height: 6),
                Text(
                  sticker.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: sticker.textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (sticker.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sticker.subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: sticker.textColor.withOpacity(0.7),
                      fontSize: 8,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Logo placeholder
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.image, size: 10, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dashed Border Painter ────────────────────────────────────────────────────

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        Radius.circular(radius),
      ));

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        final start = distance;
        final end = (distance + dashWidth).clamp(0, metric.length);
        canvas.drawPath(metric.extractPath(start, end.toDouble()), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}