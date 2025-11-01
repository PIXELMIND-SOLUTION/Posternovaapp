
import 'package:flutter/material.dart';
import 'package:posternova/models/category_model.dart';
import 'package:posternova/providers/PosterProvider/category_poster_provider.dart';
import 'package:posternova/views/PosterModule/poster_making_screen.dart';
import 'package:provider/provider.dart';


class DetailsScreen extends StatefulWidget {
  final String category;

  const DetailsScreen({super.key, required this.category});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();

    // fetch posters for the selected category
    Future.microtask(() {
      final provider =
          Provider.of<CategoryPosterProvider>(context, listen: false);
      provider.fetchPostersByCategory(widget.category);
    });
  }

  Future<void> _refresh() async {
    final provider =
        Provider.of<CategoryPosterProvider>(context, listen: false);
    await provider.fetchPostersByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    print('category nameeeeeeeeeeeee ${widget.category}');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
          
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // small header row with count + refresh
              Consumer<CategoryPosterProvider>(builder: (context, provider, _) {
                final count = provider.categoryPosters.length;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$count Posters',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh_outlined),
                      color: Colors.black54,
                    )
                  ],
                );
              }),
              const SizedBox(height: 12),

              // main content
              Expanded(
                child: Consumer<CategoryPosterProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.error.isNotEmpty) {
                      return Center(
                        child: Text('No posters found'),
                        // child: Text(
                        //   'Error: ${provider.error}',
                        //   style: const TextStyle(color: Colors.red),
                        // ),
                      );
                    }

                    if (provider.categoryPosters.isEmpty) {
                      return const Center(
                        child: Text('No posters available for this category'),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: provider.categoryPosters.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final CategoryModel poster = provider.categoryPosters[index];

                          // safe title fallback using id
                          final String shortId = poster.id != null && poster.id.length > 6
                              ? poster.id.substring(0, 6)
                              : '${poster.id}';
                          final String title = 'Poster #$shortId';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SamplePosterScreen(posterId: poster.id),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Column(
                                children: [
                                  // image area
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        // poster image (with hero for smooth transition)
                                        Hero(
                                          tag: 'poster-image-${poster.id}',
                                          child: poster.images.isNotEmpty
                                              ? Image.network(
                                                  poster.images[0],
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return const Center(child: CircularProgressIndicator());
                                                  },
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[200],
                                                      child: const Center(
                                                        child: Icon(Icons.broken_image, size: 40),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: Icon(Icons.image_not_supported, size: 40),
                                                  ),
                                                ),
                                        ),

                                        // subtle gradient at bottom
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          height: 70,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.6),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // title + actions overlaid
                                        Positioned(
                                          left: 8,
                                          right: 8,
                                          bottom: 8,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                        
                                              Row(
                                                children: [
                                            
                                                  const SizedBox(width: 8),
                      
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  // footer with small info
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.category,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () {
                                            // quick preview
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SamplePosterScreen(posterId: poster.id),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.open_in_new, size: 20),
                                          color: Colors.black54,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
