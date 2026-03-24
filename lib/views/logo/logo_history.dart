import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/views/logo/make_logo.dart';
import 'package:posternova/widgets/language_widget.dart';

class LogoHistory extends StatefulWidget {
  const LogoHistory({super.key});

  @override
  State<LogoHistory> createState() => _LogoHistoryState();
}

class _LogoHistoryState extends State<LogoHistory> {
  List<LogoHistoryItem> _historyItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
  }

  Future<void> _fetchHistoryData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get user data from shared preferences
      final userData = await AuthPreferences.getUserData();

      if (userData == null || userData.user.id == null) {
        throw Exception('User not logged in');
      }

      final response = await http.get(
        Uri.parse(
          'http://31.97.206.144:4061/api/users/user-history/${userData.user.id}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userData.token}',
        },
      );

      // if (response.statusCode == 200) {
      //   final List<dynamic> data = jsonDecode(response.body);
      //   setState(() {
      //     _historyItems = data
      //         .map((item) => LogoHistoryItem.fromJson(item))
      //         .toList();
      //     _isLoading = false;
      //   });
      // }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['history'] ?? [];
        setState(() {
          _historyItems = data
              .map((item) => LogoHistoryItem.fromJson(item))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }

  void _showImagePreview(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const AppText(
          'logo_history',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchHistoryData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading your history...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchHistoryData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_historyItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No History Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your edited logos will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchHistoryData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _historyItems.length,
        itemBuilder: (context, index) {
          return _buildHistoryCard(_historyItems[index]);
        },
      ),
    );
  }

  Widget _buildHistoryCard(LogoHistoryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with logo name and date
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.logoName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(item.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Images comparison
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Original Logo
                Expanded(
                  child: _buildImageContainer(
                    imageUrl: item.originalImage,
                    label: 'Original',
                    onTap: () => _showImagePreview(
                      context,
                      item.originalImage,
                      '${item.logoName} - Original',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.arrow_forward, color: Colors.grey[400]),
                const SizedBox(width: 12),
                // Edited Logo
                Expanded(
                  child: _buildImageContainer(
                    imageUrl: item.editedImage,
                    label: 'Edited',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         MakeLogo(image: item.editedImage, id: item.id),
                      //   ),
                      // );
                    },
                    // onTap: () => _showImagePreview(
                    //   context,
                    //   item.editedImage,
                    //   '${item.logoName} - Edited',
                    // ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: OutlinedButton.icon(
          //           onPressed: () {
          //             // TODO: Implement download functionality
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               const SnackBar(
          //                 content: Text('Download feature coming soon'),
          //               ),
          //             );
          //           },
          //           icon: const Icon(Icons.download, size: 18),
          //           label: const Text('Download'),
          //           style: OutlinedButton.styleFrom(
          //             padding: const EdgeInsets.symmetric(vertical: 12),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: ElevatedButton.icon(
          //           onPressed: () {
          //             // TODO: Implement share functionality
          //             ScaffoldMessenger.of(context).showSnackBar(
          //               const SnackBar(
          //                 content: Text('Share feature coming soon'),
          //               ),
          //             );
          //           },
          //           icon: const Icon(Icons.share, size: 18),
          //           label: const Text('Share'),
          //           style: ElevatedButton.styleFrom(
          //             padding: const EdgeInsets.symmetric(vertical: 12),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildImageContainer({
    required String imageUrl,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class LogoHistoryItem {
  final String id;
  final String userId;
  final String logoId;
  final String logoName;
  final String originalImage;
  final String editedImage;
  final String createdAt;
  final String updatedAt;

  LogoHistoryItem({
    required this.id,
    required this.userId,
    required this.logoId,
    required this.logoName,
    required this.originalImage,
    required this.editedImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LogoHistoryItem.fromJson(Map<String, dynamic> json) {
    return LogoHistoryItem(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      logoId: json['logoId']?['_id'] ?? '',
      logoName: json['logoId']?['name'] ?? 'Unknown',
      originalImage: json['logoId']?['image'] ?? '',
      editedImage: json['editedImage'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
