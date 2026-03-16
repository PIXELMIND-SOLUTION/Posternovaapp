import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Helvetica Neue'),
      home: const NotificationScreen(),
    );
  }
}

enum NotifCategory { all, design, updates, promo }

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final NotifType type;
  final bool isRead;
  final Color accentColor;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    required this.accentColor,
    this.isRead = false,
  });
}

enum NotifType { design, export, comment, update, promo }

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  NotifCategory _selected = NotifCategory.all;
  late AnimationController _animController;

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Your poster is ready!',
      subtitle: 'Summer Sale 2025 has been exported as PNG (4K).',
      time: '2m ago',
      type: NotifType.export,
      accentColor: Color(0xFF00E5A0),
    ),
    NotificationItem(
      id: '2',
      title: 'New comment on your design',
      subtitle: '"This looks amazing! Can you adjust the contrast?" — Sarah K.',
      time: '18m ago',
      type: NotifType.comment,
      accentColor: Color(0xFF7B6EF6),
      isRead: true,
    ),
    NotificationItem(
      id: '3',
      title: 'AI Suggestion Available',
      subtitle:
          'We found 3 layout improvements for your "Event Flyer" template.',
      time: '1h ago',
      type: NotifType.design,
      accentColor: Color(0xFFFF6B35),
    ),
    NotificationItem(
      id: '4',
      title: 'PosterCraft updated to v4.2',
      subtitle: 'New gradient mesh tool, improved layer panel & 40+ templates.',
      time: '3h ago',
      type: NotifType.update,
      accentColor: Color(0xFF38BEFF),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Unlock Pro — 50% Off Today',
      subtitle:
          'Limited time: Get unlimited exports, brand kits & premium fonts.',
      time: '5h ago',
      type: NotifType.promo,
      accentColor: Color(0xFFFFD166),
    ),
    NotificationItem(
      id: '6',
      title: 'Design autosaved',
      subtitle: 'Your "Product Launch" poster was saved to the cloud.',
      time: 'Yesterday',
      type: NotifType.design,
      accentColor: Color(0xFF00E5A0),
      isRead: true,
    ),
    NotificationItem(
      id: '7',
      title: 'Collaboration invite',
      subtitle: 'Marcus T. invited you to edit "Brand Identity Pack".',
      time: 'Yesterday',
      type: NotifType.comment,
      accentColor: Color(0xFF7B6EF6),
    ),
    NotificationItem(
      id: '8',
      title: 'Weekly design recap',
      subtitle: 'You created 7 posters this week — your best week yet 🎉',
      time: '2 days ago',
      type: NotifType.update,
      accentColor: Color(0xFF38BEFF),
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationItem> get _filtered {
    switch (_selected) {
      case NotifCategory.all:
        return _notifications;
      case NotifCategory.design:
        return _notifications
            .where(
                (n) => n.type == NotifType.design || n.type == NotifType.export)
            .toList();
      case NotifCategory.updates:
        return _notifications
            .where((n) => n.type == NotifType.update)
            .toList();
      case NotifCategory.promo:
        return _notifications
            .where(
                (n) => n.type == NotifType.promo || n.type == NotifType.comment)
            .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  IconData _iconFor(NotifType type) {
    switch (type) {
      case NotifType.export:
        return Icons.download_rounded;
      case NotifType.comment:
        return Icons.chat_bubble_outline_rounded;
      case NotifType.design:
        return Icons.auto_awesome_rounded;
      case NotifType.update:
        return Icons.system_update_alt_rounded;
      case NotifType.promo:
        return Icons.local_offer_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCategories(),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) {
                        final item = filtered[i];
                        return _buildNotifTile(item, i);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C22),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                if (_unreadCount > 0)
                  Text(
                    '$_unreadCount unread',
                    style: const TextStyle(
                      color: Color(0xFF888899),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
          if (_unreadCount > 0)
            GestureDetector(
              onTap: () {
                setState(() {
                  for (var i = 0; i < _notifications.length; i++) {
                    _notifications[i] = NotificationItem(
                      id: _notifications[i].id,
                      title: _notifications[i].title,
                      subtitle: _notifications[i].subtitle,
                      time: _notifications[i].time,
                      type: _notifications[i].type,
                      accentColor: _notifications[i].accentColor,
                      isRead: true,
                    );
                  }
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2E2E3A),
                    width: 1,
                  ),
                ),
                child: const Text(
                  'Mark all read',
                  style: TextStyle(
                    color: Color(0xFF7B6EF6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final cats = [
      (NotifCategory.all, 'All'),
      (NotifCategory.design, 'Design'),
      (NotifCategory.updates, 'Updates'),
      (NotifCategory.promo, 'Social'),
    ];

    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: cats.map((cat) {
          final isActive = _selected == cat.$1;
          return GestureDetector(
            onTap: () => setState(() => _selected = cat.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF7B6EF6)
                    : const Color(0xFF1C1C22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isActive ? const Color(0xFF7B6EF6) : const Color(0xFF2E2E3A),
                  width: 1,
                ),
              ),
              child: Text(
                cat.$2,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF888899),
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotifTile(NotificationItem item, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 60),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFF4466),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.delete_outline_rounded,
              color: Colors.white, size: 22),
        ),
        onDismissed: (_) {
          setState(() => _notifications.removeWhere((n) => n.id == item.id));
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              final idx = _notifications.indexWhere((n) => n.id == item.id);
              if (idx != -1) {
                _notifications[idx] = NotificationItem(
                  id: item.id,
                  title: item.title,
                  subtitle: item.subtitle,
                  time: item.time,
                  type: item.type,
                  accentColor: item.accentColor,
                  isRead: true,
                );
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: item.isRead
                  ? const Color(0xFF141418)
                  : const Color(0xFF1A1A24),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: item.isRead
                    ? const Color(0xFF222228)
                    : const Color(0xFF2E2E42),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon bubble
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _iconFor(item.type),
                    color: item.accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: item.isRead
                                    ? const Color(0xFFCCCCDD)
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: item.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            item.time,
                            style: const TextStyle(
                              color: Color(0xFF55556A),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF666677),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!item.isRead) ...[
                  const SizedBox(width: 10),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B6EF6),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B6EF6).withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C22),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              color: Color(0xFF444455),
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No notifications here',
            style: TextStyle(
              color: Color(0xFF888899),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'You\'re all caught up!',
            style: TextStyle(
              color: Color(0xFF444455),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}