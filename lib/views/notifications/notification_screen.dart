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

  final String baseUrl = "http://31.97.206.144:4061/api/users";

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
          "notificationIds": [notificationId]
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
    return Scaffold(
      // backgroundColor: const Color(0xFF0C0C0F),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 10),

            /// BODY
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
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
          const Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
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
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) {
        deleteNotification(item.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF2E2E42),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
                color: Colors.deepPurple,
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
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
            "You're all caught up!",
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