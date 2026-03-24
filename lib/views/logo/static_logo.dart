import 'package:flutter/material.dart';
import 'package:posternova/views/logo/new_logo.dart';
import 'package:posternova/widgets/language_widget.dart';

// ─────────────────────────────────────────────
//  STATIC LOGO DATA
// ─────────────────────────────────────────────

class StaticLogoData {
  static List<LogoListItem> getAllLogos() {
    return [
      LogoListItem(
        id: 'business_logo_1',
        name: 'Business Logo',
        category: 'Business',
        imageUrl:
            'https://res.cloudinary.com/dgl8iwzq8/image/upload/v1774330290/profile_images/jpzsdumnwwlmnka3oras.png',
        isPremium: false,
        description: 'Professional business logo template',
        placeholders: [
          LogoPlaceholder(
            id: 'business_name',
            type: 'text',
            label: 'Business Name',
            defaultValue: 'PIXELMIND',
            position: const Offset(0, 200), // ← Changed from (0,0) to center
            size: const Size(400, 80), // ← Full width for centering
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            textAlign: TextAlign.center, // ← Centers text horizontally
            required: true,
            maxLength: 50,
          ),
        ],
      ),
    ];
  }
}

// ─────────────────────────────────────────────
//  LOGO LIST ITEM MODEL
// ─────────────────────────────────────────────

class LogoListItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final bool isPremium;
  final String description;
  final List<LogoPlaceholder> placeholders;

  LogoListItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.isPremium,
    required this.description,
    required this.placeholders,
  });

  LogoData toLogoData() {
    return LogoData(
      id: id,
      name: name,
      category: category,
      imageUrl: imageUrl,
      imageType: 'png',
      isPremium: isPremium,
      tags: [category.toLowerCase()],
      placeholders: placeholders,
    );
  }
}

// ─────────────────────────────────────────────
//  LOGO LISTING SCREEN
// ─────────────────────────────────────────────

class LogoListingScreen extends StatefulWidget {
  const LogoListingScreen({super.key});

  @override
  State<LogoListingScreen> createState() => _LogoListingScreenState();
}

class _LogoListingScreenState extends State<LogoListingScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<String> get _categories {
    final categories = StaticLogoData.getAllLogos()
        .map((logo) => logo.category)
        .toSet()
        .toList();
    categories.sort();
    return ['All', ...categories];
  }

  List<LogoListItem> get _filteredLogos {
    var logos = StaticLogoData.getAllLogos();

    // Filter by category
    if (_selectedCategory != 'All') {
      logos = logos
          .where((logo) => logo.category == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      logos = logos
          .where(
            (logo) =>
                logo.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                logo.category.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                logo.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return logos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          Expanded(child: _buildLogoGrid()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Color(0xFF2D3142),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const AppText(
        'logo_maker',
        style: TextStyle(
          color: Color(0xFF2D3142),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.favorite_border,
              color: Color(0xFF2D3142),
              size: 20,
            ),
          ),
          onPressed: () {
            // Navigate to favorites
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search logos...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF6C63FF)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF6C63FF).withOpacity(0.1),
              checkmarkColor: const Color(0xFF6C63FF),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF6C63FF) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF6C63FF)
                      : Colors.grey[300]!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoGrid() {
    final logos = _filteredLogos;

    if (logos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No logos found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: logos.length,
      itemBuilder: (context, index) {
        final logo = logos[index];
        return _buildLogoCard(logo);
      },
    );
  }

  Widget _buildLogoCard(LogoListItem logo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LogoEditorScreen(logoData: logo.toLogoData()),
          ),
        );
      },
      child: Container(
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
            // Logo Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      logo.imageUrl,
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (logo.isPremium)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars, size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'PREMIUM',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Logo Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      logo.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      logo.description,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        logo.category,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PREVIEW CARD WIDGET
// ─────────────────────────────────────────────

class LogoPreviewCard extends StatelessWidget {
  final LogoListItem logo;
  const LogoPreviewCard({super.key, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              logo.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                color: Colors.grey[100],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  logo.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  logo.category,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
