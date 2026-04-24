import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/views/business/business_card_form_screen.dart';

class BusinessCardScreen extends StatefulWidget {
  const BusinessCardScreen({super.key});

  @override
  State<BusinessCardScreen> createState() => _BusinessCardScreenState();
}

class _BusinessCardScreenState extends State<BusinessCardScreen> {
  List<_CardItem> _trendingCards = [];
  List<_CardItem> _professionalCards = [];
  bool _loading = true;
  String? _error;

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future<void> _fetchCards() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://31.97.228.17:4061/api/admin/getbusinesscardsforusers',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          final List data = json['data'] as List;
          final cards = data
              .map(
                (e) => _CardItem(
                  id: e['_id'] as String,
                  previewImage: e['previewImage'] as String,
                ),
              )
              .toList();

          // split into trending / professional (or show all as trending if few)
          setState(() {
            _trendingCards = cards.length > 3 ? cards.sublist(0, 3) : cards;
            _professionalCards = cards.length > 3 ? cards.sublist(3) : [];
            _loading = false;
          });
        } else {
          setState(() {
            _error = 'Failed to load cards';
            _loading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Server error: ${response.statusCode}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFFF5C518),
                      ),
                    )
                  : _error != null
                  ? _buildError()
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    final isDarkMode = _isDarkMode;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: isDarkMode ? Colors.red[400] : Colors.red,
          ),
          const SizedBox(height: 12),
          Text(
            _error!,
            style: TextStyle(color: isDarkMode ? Colors.red[400] : Colors.red),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              setState(() {
                _loading = true;
                _error = null;
              });
              _fetchCards();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFF5C518),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final isDarkMode = _isDarkMode;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _loading = true;
          _error = null;
        });
        await _fetchCards();
      },
      color: const Color(0xFFF5C518),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            if (_trendingCards.isNotEmpty) ...[
              _buildSectionHeader('Trending Cards'),
              const SizedBox(height: 12),
              _buildHorizontalList(_trendingCards),
              const SizedBox(height: 20),
            ],

            if (_professionalCards.isNotEmpty) ...[
              _buildSectionHeader('Professional Cards'),
              const SizedBox(height: 12),
              _buildGridCards(_professionalCards),
              const SizedBox(height: 20),
            ],

            // show all cards in grid if we have more
            if (_trendingCards.isEmpty && _professionalCards.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No cards available',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final isDarkMode = _isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? const Color(0xFF334155)
                : const Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Digital Business Card',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final isDarkMode = _isDarkMode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Row(
            children: [
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.black54,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Horizontal scroll — each card sizes itself to its image's aspect ratio
  Widget _buildHorizontalList(List<_CardItem> cards) {
    return SizedBox(
      height: 380,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _DynamicCard(card: cards[i], fixedHeight: 320),
      ),
    );
  }

  // 2-column grid — cards size to their image aspect ratio
  Widget _buildGridCards(List<_CardItem> cards) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: cards.length,
        itemBuilder: (_, i) => _DynamicCard(card: cards[i]),
      ),
    );
  }
}

// ─── Promo CTA ────────────────────────────────────────────────────────────────

class _PromoButton extends StatelessWidget {
  const _PromoButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Explore Now',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E),
        ),
      ),
    );
  }
}

// ─── Dynamic Card ─────────────────────────────────────────────────────────────
// Loads the image, reads its natural size, renders at correct aspect ratio

class _DynamicCard extends StatefulWidget {
  final _CardItem card;
  final double? fixedHeight; // if set, width is derived from aspect ratio

  const _DynamicCard({required this.card, this.fixedHeight});

  @override
  State<_DynamicCard> createState() => _DynamicCardState();
}

class _DynamicCardState extends State<_DynamicCard> {
  double? _aspectRatio; // width / height
  bool _imageLoaded = false;

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _resolveAspectRatio();
  }

  void _resolveAspectRatio() {
    final image = NetworkImage(widget.card.previewImage);
    final stream = image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (info, _) {
          if (mounted) {
            setState(() {
              _aspectRatio = info.image.width / info.image.height;
              _imageLoaded = true;
            });
          }
        },
        onError: (_, __) {
          if (mounted) {
            setState(() {
              _aspectRatio = 0.6; // fallback portrait ratio
              _imageLoaded = true;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    // While loading, show placeholder of sensible size
    if (!_imageLoaded) {
      return _cardShell(
        width: widget.fixedHeight != null ? (widget.fixedHeight! * 0.6) : null,
        child: _shimmer(),
      );
    }

    final ratio = _aspectRatio ?? 0.6;
    final double? width = widget.fixedHeight != null
        ? widget.fixedHeight! * ratio
        : null;

    return _cardShell(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview image — fills to natural ratio
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BusinessCardFormScreen(templateId: widget.card.id),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: AspectRatio(
                aspectRatio: ratio,
                child: Image.network(
                  widget.card.previewImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return _shimmer();
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: isDarkMode
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFEEEEEE),
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: isDarkMode ? Colors.grey[600] : Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Price row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Text(
                  '₹ 299',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹ 499',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '40% OFF',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
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

  Widget _cardShell({double? width, required Widget child}) {
    final isDarkMode = _isDarkMode;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.black : Colors.grey).withOpacity(
              isDarkMode ? 0.3 : 0.18,
            ),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _shimmer() {
    final isDarkMode = _isDarkMode;

    return Container(
      color: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFEEEEEE),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: const Color(0xFFF5C518),
          ),
        ),
      ),
    );
  }
}

// ─── Model ────────────────────────────────────────────────────────────────────

class _CardItem {
  final String id;
  final String previewImage;

  const _CardItem({required this.id, required this.previewImage});
}
