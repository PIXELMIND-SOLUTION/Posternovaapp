import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:posternova/models/poster_model.dart';
import 'package:posternova/views/PosterModule/poster_making_screen.dart';
import 'package:http/http.dart' as http;

class PosterListingScreen extends StatefulWidget {
  final String title;
  final String type; // 'festival' or 'category'
  final String? categoryName;
  final DateTime? festivalDate;

  const PosterListingScreen({
    super.key,
    required this.title,
    required this.type,
    this.categoryName,
    this.festivalDate,
  });

  @override
  State<PosterListingScreen> createState() => _PosterListingScreenState();
}

class _PosterListingScreenState extends State<PosterListingScreen> {
  List<dynamic> posters = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosters();
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _fetchPosters() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (widget.type == 'festival' && widget.festivalDate != null) {
        // Fetch festival posters
        final response = await http.post(
          Uri.parse('http://194.164.148.244:4061/api/poster/festival'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'festivalDate': _formatDate(widget.festivalDate!)}),
        );

        if (response.statusCode == 200) {
          setState(() {
            posters = jsonDecode(response.body);
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Failed to load posters';
            _isLoading = false;
          });
        }
      } else if (widget.type == 'category' && widget.categoryName != null) {
        // Fetch category posters - adjust URL based on your API
        final response = await http.get(
          Uri.parse(
            'http://194.164.148.244:4061/api/poster/canvasposters',
          ),
        );

        if (response.statusCode == 200) {
          setState(() {
            posters = jsonDecode(response.body);
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Failed to load posters';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
appBar: AppBar(
  backgroundColor: Colors.deepPurple.withOpacity(0.5),
  elevation: 3,
  shadowColor: Colors.black.withOpacity(0.1),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(16),
    ),
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
    onPressed: () => Navigator.pop(context),
  ),
  title: Text(
    widget.title,
    style: const TextStyle(
      color: Color(0xFF111827),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  centerTitle: true,
),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            )
          : _error != null
              ? _buildErrorWidget()
              : posters.isEmpty
                  ? _buildEmptyWidget()
                  : RefreshIndicator(
                      onRefresh: _fetchPosters,
                      color: const Color(0xFF6366F1),
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: posters.length,
                        itemBuilder: (context, index) {
                          return _buildPosterCard(posters[index]);
                        },
                      ),
                    ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Failed to load posters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error occurred',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchPosters,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 48,
                color: Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No posters found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try checking back later for new content',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosterCard(dynamic poster) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SamplePosterScreen(posterId: poster['_id'] ?? poster['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    color: const Color(0xFFF3F4F6),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      poster['images'] != null && poster['images'].isNotEmpty
                          ? poster['images'][0]
                          : '',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF3F4F6),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Color(0xFF9CA3AF),
                              size: 32,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      poster['categoryName'] ?? poster['name'] ?? 'Template',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (poster['price'] != null)
                          Text(
                            poster['price'] == 0 ? 'Free' : '₹${poster['price']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: poster['price'] == 0
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF6366F1),
                              fontWeight: FontWeight.w600,
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
      ),
    );
  }
}