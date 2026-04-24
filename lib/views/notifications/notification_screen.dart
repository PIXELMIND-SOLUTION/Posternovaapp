import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum NotifCategory { all }

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  final String userId;

  const NotificationScreen({super.key, required this.userId});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> _notifications = [];
  bool _loading = true;

  final String baseUrl = "http://31.97.228.17:4061/api/users";

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  /// FETCH NOTIFICATIONS
  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/getnotifications/${widget.userId}"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List list = data["notifications"];

        setState(() {
          _notifications = list.map((e) {
            return NotificationItem(
              id: e["_id"],
              title: e["title"] ?? "",
              subtitle: e["message"] ?? "",
              time: formatTime(e["createdAt"]),
            );
          }).toList();
          _loading = false;
        });
      }
    } catch (e) {
      print("Fetch notification error: $e");
      setState(() => _loading = false);
    }
  }

  /// DELETE NOTIFICATION
  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/deletenotifications/${widget.userId}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "notificationIds": [notificationId],
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notificationId);
        });
      }
    } catch (e) {
      print("Delete error: $e");
    }
  }

  /// FORMAT TIME
  String formatTime(String date) {
    final DateTime dt = DateTime.parse(date).toLocal();
    final difference = DateTime.now().difference(dt);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    if (difference.inDays == 1) return "Yesterday";

    return "${difference.inDays} days ago";
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF0F172A)
          : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),

            /// BODY
            Expanded(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFFF5C518),
                      ),
                    )
                  : _notifications.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: _notifications.length,
                      itemBuilder: (ctx, i) {
                        final item = _notifications[i];
                        return _buildNotifTile(item, i);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// HEADER
  Widget _buildHeader() {
    final isDarkMode = _isDarkMode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDarkMode ? Colors.white : Colors.black87,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// NOTIFICATION TILE
  Widget _buildNotifTile(NotificationItem item, int index) {
    final isDarkMode = _isDarkMode;

    return Dismissible(
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
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        deleteNotification(item.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDarkMode
                ? const Color(0xFF334155)
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5C518).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
                color: Color(0xFFF5C518),
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
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// EMPTY VIEW
  Widget _buildEmpty() {
    final isDarkMode = _isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              color: isDarkMode
                  ? const Color(0xFF64748B)
                  : const Color(0xFF94A3B8),
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No notifications here',
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "You're all caught up!",
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0xFF64748B)
                  : const Color(0xFF94A3B8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
