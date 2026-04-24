// business_card_result_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BusinessCardResultScreen extends StatefulWidget {
  final String userId;
  final String templateId;

  const BusinessCardResultScreen({
    super.key,
    required this.userId,
    required this.templateId,
  });

  @override
  State<BusinessCardResultScreen> createState() =>
      _BusinessCardResultScreenState();
}

class _BusinessCardResultScreenState extends State<BusinessCardResultScreen> {
  bool _loading = true;
  String? _error;
  String? _overlaidImage;
  String? _overlaidPdf;

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _fetchResult();
  }

  Future<void> _fetchResult() async {
    try {
      final uri = Uri.parse(
        'http://31.97.228.17:4061/api/users/getsinglebusinesscards'
        '/${widget.userId}/${widget.templateId}',
      );
      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() {
          _overlaidImage = data['overlaidImage'] as String?;
          _overlaidPdf = data['overlaidPdf'] as String?;
          _loading = false;
        });
      } else {
        setState(() {
          _error = data['message'] ?? 'Failed to load result';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  Future<void> _downloadPdf() async {
    if (_overlaidPdf == null) return;

    try {
      final Uri url = Uri.parse(_overlaidPdf!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open PDF'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open PDF: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Your Business Card',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFEEEEEE),
            height: 1,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color(0xFFF5C518),
              ),
            )
          : _error != null
          ? _buildError()
          : _buildResult(),
    );
  }

  Widget _buildError() {
    final isDarkMode = _isDarkMode;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 56,
              color: isDarkMode ? Colors.red[400] : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.red[400] : Colors.red,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _fetchResult();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5C518),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    final isDarkMode = _isDarkMode;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Success badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                SizedBox(width: 6),
                Text(
                  'Your card is ready!',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Card preview
          if (_overlaidImage != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  _overlaidImage!,
                  fit: BoxFit.contain,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                              : null,
                          color: const Color(0xFFF5C518),
                          strokeWidth: 2.5,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: isDarkMode ? Colors.grey[600] : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Action buttons
          if (_overlaidPdf != null)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _downloadPdf,
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
                label: const Text(
                  'Download PDF',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Go back to browse more
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: const Text(
                'Browse More Templates',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF5C518),
                side: const BorderSide(color: Color(0xFFF5C518), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}