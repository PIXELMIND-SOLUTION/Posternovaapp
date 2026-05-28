// import 'package:flutter/material.dart';
// import 'package:posternova/providers/trendingprovider/trending_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:posternova/models/trending_model.dart';
// import 'package:posternova/providers/plans/my_plan_provider.dart';
// import 'package:posternova/views/SecondPhase/poster_editor.dart';
// import 'package:posternova/widgets/common_modal.dart';
// import 'package:posternova/widgets/home/skeleton.dart';
// import 'package:posternova/widgets/premium_widget.dart';

// class CategoryDetailScreen extends StatefulWidget {
//   final String categoryId;
//   final String categoryName;
//   final String? categoryImage;

//   const CategoryDetailScreen({
//     super.key,
//     required this.categoryId,
//     required this.categoryName,
//     this.categoryImage,
//   });

//   @override
//   State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
// }

// class _CategoryDetailScreenState extends State<CategoryDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeOut,
//     );

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context
//           .read<PosterCategoryProvider>()
//           .fetchSubcategories(widget.categoryId);
//       _fadeController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('Subcategory iddddddddddddddddddddd ${widget.categoryId}');
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FC),
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) => [
//           _buildSliverAppBar(innerBoxIsScrolled),
//         ],
//         body: Consumer<PosterCategoryProvider>(
//           builder: (context, provider, _) {
//             if (provider.isSubcategoryLoading) {
//               return _buildLoadingGrid();
//             }

//             if (provider.hasSubcategoryError) {
//               return _buildErrorState(provider.subcategoryError ?? 'Something went wrong');
//             }

//             if (!provider.hasPosters) {
//               return _buildEmptyState();
//             }

//             return FadeTransition(
//               opacity: _fadeAnimation,
//               child: _buildPostersGrid(provider.posters),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
//     return SliverAppBar(
//       expandedHeight: widget.categoryImage != null ? 200 : 120,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: const Color(0xFF448AFF),
//       leading: GestureDetector(
//         onTap: () => Navigator.pop(context),
//         child: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: const Icon(Icons.arrow_back_ios_new_rounded,
//               color: Colors.white, size: 18),
//         ),
//       ),
//       flexibleSpace: FlexibleSpaceBar(
//         titlePadding: const EdgeInsets.only(left: 52, bottom: 14, right: 16),
//         title: Text(
//           widget.categoryName,
//           style: const TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         background: widget.categoryImage != null
//             ? Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     widget.categoryImage!,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => _buildHeaderGradient(),
//                   ),
//                   // Dark gradient overlay
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.6),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : _buildHeaderGradient(),
//       ),
//     );
//   }

//   Widget _buildHeaderGradient() {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF448AFF), Color(0xFF005ECB)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Center(
//         child: Icon(
//           Icons.collections_bookmark_rounded,
//           size: 56,
//           color: Colors.white.withOpacity(0.3),
//         ),
//       ),
//     );
//   }

//   Widget _buildPostersGrid(List<PosterSubcategoryModel> posters) {
//     return Consumer<PosterCategoryProvider>(
//       builder: (context, provider, _) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Count bar
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
//               child: Row(
//                 children: [
//                   Text(
//                     '${provider.postersCount} Templates',
//                     style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF6B7280),
//                     ),
//                   ),
//                   // const Spacer(),
//                   // // Optional: sort/filter icon placeholder
//                   // Icon(Icons.tune_rounded,
//                   //     size: 20, color: Colors.grey.shade400),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 0.72,
//                 ),
//                 itemCount: posters.length,
//                 itemBuilder: (_, i) => _buildPosterCard(posters[i], i),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildPosterCard(PosterSubcategoryModel poster, int index) {
//     return Consumer<MyPlanProvider>(
//       builder: (context, myPlanProvider, _) {
//         return GestureDetector(
//           onTap: () {
//             if (myPlanProvider.isPurchase == true) {
//               final bgImageUrl = poster.designData.bgImage.url.isNotEmpty
//                   ? poster.designData.bgImage.url
//                   : poster.posterImage;
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => PosterEditorScreen(
//                     posterAsset: bgImageUrl,
//                     itemid: poster.id,
//                   ),
//                 ),
//               );
//             } else {
//               CommonModal.showWarning(
//                 context: context,
//                 title: "Premium Template",
//                 message:
//                     "This template requires a premium plan. Upgrade to unlock all exclusive templates.",
//                 primaryButtonText: "Upgrade Now",
//                 secondaryButtonText: "Cancel",
//                 onPrimaryPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => SubscriptionPlansPage(),
//                     ),
//                   );
//                 },
//                 onSecondaryPressed: () => Navigator.of(context).pop(),
//               );
//             }
//           },
//           child: TweenAnimationBuilder<double>(
//             tween: Tween(begin: 0.0, end: 1.0),
//             duration: Duration(milliseconds: 300 + (index * 40).clamp(0, 600)),
//             curve: Curves.easeOut,
//             builder: (context, value, child) => Opacity(
//               opacity: value,
//               child: Transform.translate(
//                 offset: Offset(0, 20 * (1 - value)),
//                 child: child,
//               ),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.07),
//                     blurRadius: 8,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     // Poster image
//                     _buildPosterImage(poster.posterImage),

//                     // Premium lock overlay for non-subscribers
//                     Consumer<MyPlanProvider>(
//                       builder: (_, plan, __) => plan.isPurchase == true
//                           ? const SizedBox.shrink()
//                           : Positioned(
//                               top: 6,
//                               right: 6,
//                               child: Container(
//                                 padding: const EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.55),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: const Icon(
//                                   Icons.lock_rounded,
//                                   color: Color(0xFFFFC107),
//                                   size: 13,
//                                 ),
//                               ),
//                             ),
//                     ),

//                     // Bottom label
//                     Positioned(
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6, vertical: 5),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.65),
//                             ],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                         ),
//                         child: Text(
//                           poster.title.isNotEmpty
//                               ? poster.title
//                               : poster.categoryName,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPosterImage(String url) {
//     if (url.isEmpty || url.contains('localhost') || url.startsWith('/')) {
//       return Container(
//         color: const Color(0xFFF3F4F6),
//         child: const Center(
//           child: Icon(Icons.image_outlined, color: Colors.grey, size: 32),
//         ),
//       );
//     }
//     return Image.network(
//       url,
//       fit: BoxFit.cover,
//       loadingBuilder: (_, child, progress) {
//         if (progress == null) return child;
//         return const SkeletonBox(width: double.infinity, height: double.infinity, borderRadius: 0);
//       },
//       errorBuilder: (_, __, ___) => Container(
//         color: const Color(0xFFF3F4F6),
//         child: const Center(
//           child: Icon(Icons.broken_image_outlined, color: Colors.grey, size: 28),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingGrid() {
//     return GridView.builder(
//       padding: const EdgeInsets.fromLTRB(12, 18, 12, 100),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio: 0.72,
//       ),
//       itemCount: 12,
//       itemBuilder: (_, __) => const SkeletonBox(
//         width: double.infinity,
//         height: double.infinity,
//         borderRadius: 12,
//       ),
//     );
//   }

//   Widget _buildErrorState(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.error_outline_rounded,
//                 size: 56, color: Colors.grey.shade300),
//             const SizedBox(height: 16),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () => context
//                   .read<PosterCategoryProvider>()
//                   .refreshSubcategories(widget.categoryId),
//               icon: const Icon(Icons.refresh_rounded, size: 18),
//               label: const Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF448AFF),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.collections_outlined,
//                 size: 64, color: Colors.grey.shade300),
//             const SizedBox(height: 16),
//             Text(
//               'No templates found',
//               style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade500),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               'Check back later for new content',
//               style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


















import 'package:flutter/material.dart';
import 'package:posternova/providers/trendingprovider/trending_provider.dart';
import 'package:provider/provider.dart';
import 'package:posternova/models/trending_model.dart';
import 'package:posternova/providers/PosterProvider/getall_poster_provider.dart';
import 'package:posternova/providers/plans/my_plan_provider.dart';
import 'package:posternova/views/SecondPhase/poster_editor.dart';
import 'package:posternova/widgets/common_modal.dart';
import 'package:posternova/widgets/home/skeleton.dart';
import 'package:posternova/widgets/premium_widget.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String? categoryImage;

  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.categoryImage,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<PosterCategoryProvider>()
          .fetchSubcategories(widget.categoryId);
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(innerBoxIsScrolled),
        ],
        body: Consumer<PosterCategoryProvider>(
          builder: (context, provider, _) {
            if (provider.isSubcategoryLoading) {
              return _buildLoadingGrid();
            }

            if (provider.hasSubcategoryError) {
              return _buildErrorState(provider.subcategoryError ?? 'Something went wrong');
            }

            if (!provider.hasPosters) {
              return _buildEmptyState();
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: _buildPostersGrid(provider.posters),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: widget.categoryImage != null ? 200 : 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF448AFF),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 18),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 52, bottom: 14, right: 16),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        background: widget.categoryImage != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.categoryImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildHeaderGradient(),
                  ),
                  // Dark gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              )
            : _buildHeaderGradient(),
      ),
    );
  }

  Widget _buildHeaderGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF448AFF), Color(0xFF005ECB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.collections_bookmark_rounded,
          size: 56,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildPostersGrid(List<PosterSubcategoryModel> posters) {
    return Consumer<PosterCategoryProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Count bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                children: [
                  Text(
                    '${provider.postersCount} Templates',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const Spacer(),
                  // Optional: sort/filter icon placeholder
                  Icon(Icons.tune_rounded,
                      size: 20, color: Colors.grey.shade400),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemCount: posters.length,
                itemBuilder: (_, i) => _buildPosterCard(posters[i], i),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPosterCard(PosterSubcategoryModel poster, int index) {
    return Consumer<MyPlanProvider>(
      builder: (context, myPlanProvider, _) {
        return GestureDetector(
          onTap: () {
            if (myPlanProvider.isPurchase == true) {
              final bgImageUrl = poster.designData.bgImage.url.isNotEmpty
                  ? poster.designData.bgImage.url
                  : poster.posterImage;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PosterEditorScreen(
                    posterAsset: poster.posterImage,
                    itemid: poster.id, 
                  ),
                ),
              );
            } else {
              CommonModal.showWarning(
                context: context,
                title: "Premium Template",
                message:
                    "This template requires a premium plan. Upgrade to unlock all exclusive templates.",
                primaryButtonText: "Upgrade Now",
                secondaryButtonText: "Cancel",
                onPrimaryPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubscriptionPlansPage(),
                    ),
                  );
                },
                onSecondaryPressed: () => Navigator.of(context).pop(),
              );
            }
          },
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 40).clamp(0, 600)),
            curve: Curves.easeOut,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Poster image
                    _buildPosterImage(poster.posterImage),

                    // Premium lock overlay for non-subscribers
                    Consumer<MyPlanProvider>(
                      builder: (_, plan, __) => plan.isPurchase == true
                          ? const SizedBox.shrink()
                          : Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.55),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.lock_rounded,
                                  color: Color(0xFFFFC107),
                                  size: 13,
                                ),
                              ),
                            ),
                    ),

                    // Bottom label
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.65),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Text(
                          poster.title.isNotEmpty
                              ? poster.title
                              : poster.categoryName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPosterImage(String url) {
    if (url.isEmpty || url.contains('localhost') || url.startsWith('/')) {
      return Container(
        color: const Color(0xFFF3F4F6),
        child: const Center(
          child: Icon(Icons.image_outlined, color: Colors.grey, size: 32),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const SkeletonBox(width: double.infinity, height: double.infinity, borderRadius: 0);
      },
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF3F4F6),
        child: const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.grey, size: 28),
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: 12,
      itemBuilder: (_, __) => const SkeletonBox(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 12,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<PosterCategoryProvider>()
                  .refreshSubcategories(widget.categoryId),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF448AFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.collections_outlined,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No templates found',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500),
            ),
            const SizedBox(height: 6),
            Text(
              'Check back later for new content',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}