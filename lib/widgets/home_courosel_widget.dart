
// import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

// class HomeCarousel extends StatefulWidget {
//   const HomeCarousel({super.key});

//   @override
//   State<HomeCarousel> createState() => _HomeCarouselState();
// }

// class _HomeCarouselState extends State<HomeCarousel>
//     with SingleTickerProviderStateMixin {
//   final PageController _pageController = PageController(viewportFraction: 0.9);
//   int _currentPage = 0;
//   Timer? _autoScrollTimer;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   List<CarouselItem> _carouselItems = [];
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     // Setup animation controller
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
//     );

//     // Fetch banners from API
//     _fetchBanners();
//   }

//   Future<void> _fetchBanners() async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://194.164.148.244:4061/api/poster/getbanners'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final List<dynamic> bannerData = json.decode(response.body);

//         if (bannerData.isNotEmpty) {
//           setState(() {
//             _carouselItems = bannerData.expand((banner) {
//               final images = List<String>.from(banner['images'] ?? []);
//               return images.map((image) => CarouselItem(
//                     title:'',
//                     subtitle: '',
//                     buttonText: '',
//                     category: '',
//                     imagePath: image,
//                     isNetworkImage: true,
//                     bannerId: banner['_id'],
//                   ));
//             }).toList();

//             _isLoading = false;
//             _errorMessage = null;
//           });

//           // Start animations and auto-scrolling
//           _animationController.forward();
//           _startAutoScroll();
//         } else {
//           _useDefaultItems();
//         }
//       } else {
//         throw Exception('Failed to load banners: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching banners: $e');
//       setState(() {
//         _errorMessage = 'Failed to load banners';
//         _isLoading = false;
//       });
//       _useDefaultItems();
//     }
//   }

//   void _useDefaultItems() {
//     setState(() {
//       _carouselItems = [
//         CarouselItem(
//           title: 'Welcome to Our Platform',
//           subtitle: 'Discover amazing features and content',
//           buttonText: 'Get Started',
//           category: 'Featured',
//           imagePath: 'assets/images/default_banner1.jpg',
//           isNetworkImage: false,
//         ),
//       ];
//       _isLoading = false;
//     });
//     _animationController.forward();
//     _startAutoScroll();
//   }

//   void _startAutoScroll() {
//     _autoScrollTimer?.cancel();
//     if (_carouselItems.length > 1) {
//       _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
//         if (_carouselItems.isNotEmpty) {
//           final nextPage = (_currentPage + 1) % _carouselItems.length;
//           _pageController.animateToPage(
//             nextPage,
//             duration: const Duration(milliseconds: 600),
//             curve: Curves.easeInOutCubic,
//           );
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _autoScrollTimer?.cancel();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Container(
//         height: 220,
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           color: Colors.grey[100],
//         ),
//         child: const Center(
//           child: CircularProgressIndicator(
//             strokeWidth: 3,
//             color: Colors.blue,
//           ),
//         ),
//       );
//     }

//     if (_carouselItems.isEmpty) {
//       return Container(
//         height: 220,
//         margin: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(24),
//           color: Colors.grey[50],
//           border: Border.all(color: Colors.grey[200]!),
//         ),
//         child: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.image_not_supported_outlined, 
//                    size: 48, color: Colors.grey),
//               SizedBox(height: 12),
//               Text(
//                 'No banners available',
//                 style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return SlideTransition(
//           position: _slideAnimation,
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Featured',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       // if (_carouselItems.length > 1)
//                       //   Container(
//                       //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       //     decoration: BoxDecoration(
//                       //       color: Colors.blue[50],
//                       //       borderRadius: BorderRadius.circular(20),
//                       //     ),
//                       //     child: Text(
//                       //       '${_currentPage + 1} of ${_carouselItems.length}',
//                       //       style: TextStyle(
//                       //         fontSize: 12,
//                       //         fontWeight: FontWeight.w600,
//                       //         color: Colors.blue[700],
//                       //       ),
//                       //     ),
//                       //   ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
                
//                 // Carousel Section
//                 SizedBox(
//                   height: 150,
//                   child: PageView.builder(
//                     controller: _pageController,
//                     itemCount: _carouselItems.length,
//                     onPageChanged: (index) {
//                       setState(() {
//                         _currentPage = index;
//                       });
//                     },
//                     itemBuilder: (context, index) {
//                       final item = _carouselItems[index];
//                       final isActive = index == _currentPage;
                      
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeOutCubic,
//                         margin: EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: isActive ? 0 : 12,
//                         ),
//                         child: ProfessionalCarouselCard(
//                           carouselItem: item,
//                           isActive: isActive,
//                           onTap: () {
//                             // Handle tap - navigate to details or perform action
//                             print('Tapped on banner: ${item.bannerId}');
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
                
//                 const SizedBox(height: 16),
                
//                 // Page Indicator
//                 if (_carouselItems.length > 1)
//                   Center(
//                     child: SmoothPageIndicator(
//                       controller: _pageController,
//                       count: _carouselItems.length,
//                       effect: ExpandingDotsEffect(
//                         activeDotColor: Colors.blue[600]!,
//                         dotColor: Colors.grey[300]!,
//                         dotHeight: 8,
//                         dotWidth: 8,
//                         expansionFactor: 4,
//                         spacing: 6,
//                       ),
//                     ),
//                   ),
                
//                 // Error Message
//                 if (_errorMessage != null)
//                   Container(
//                     margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.orange[50],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.orange[200]!),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.cloud_off_outlined, 
//                              size: 20, color: Colors.orange[700]),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             'Using offline content - Check your connection',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.orange[700],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ProfessionalCarouselCard extends StatefulWidget {
//   final CarouselItem carouselItem;
//   final bool isActive;
//   final VoidCallback? onTap;

//   const ProfessionalCarouselCard({
//     super.key,
//     required this.carouselItem,
//     this.isActive = false,
//     this.onTap,
//   });

//   @override
//   State<ProfessionalCarouselCard> createState() => _ProfessionalCarouselCardState();
// }

// class _ProfessionalCarouselCardState extends State<ProfessionalCarouselCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _hoverController;
//   late Animation<double> _hoverAnimation;
//   bool _isHovered = false;

//   @override
//   void initState() {
//     super.initState();
//     _hoverController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     );
//     _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
//     );
//   }

//   @override
//   void dispose() {
//     _hoverController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       onTapDown: (_) => _hoverController.forward(),
//       onTapUp: (_) => _hoverController.reverse(),
//       onTapCancel: () => _hoverController.reverse(),
//       child: AnimatedBuilder(
//         animation: _hoverAnimation,
//         builder: (context, child) {
//           return Transform.scale(
//             scale: _hoverAnimation.value,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: widget.isActive
//                     ? [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                           spreadRadius: 0,
//                         ),
//                         BoxShadow(
//                           color: Colors.blue.withOpacity(0.1),
//                           blurRadius: 40,
//                           offset: const Offset(0, 16),
//                           spreadRadius: 0,
//                         ),
//                       ]
//                     : [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           blurRadius: 12,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(24),
//                 child: Stack(
//                   children: [
//                     // Background Image
//                     Positioned.fill(
//                       child: widget.carouselItem.isNetworkImage
//                           ? Image.network(
//                               widget.carouselItem.imagePath,
//                               fit: BoxFit.fill,
//                               loadingBuilder: (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [Colors.grey[300]!, Colors.grey[100]!],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                   ),
//                                   child: Center(
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Colors.blue[300],
//                                       value: loadingProgress.expectedTotalBytes != null
//                                           ? loadingProgress.cumulativeBytesLoaded /
//                                               loadingProgress.expectedTotalBytes!
//                                           : null,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               errorBuilder: (context, error, stackTrace) {
//                                 return _buildErrorPlaceholder();
//                               },
//                             )
//                           : Image.asset(
//                               widget.carouselItem.imagePath,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return _buildErrorPlaceholder();
//                               },
//                             ),
//                     ),

//                     // Gradient Overlays
//                     Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.3),
//                             Colors.black.withOpacity(0.7),
//                           ],
//                           stops: const [0.0, 0.6, 1.0],
//                         ),
//                       ),
//                     ),

//                     // Content Overlay
//                     Positioned(
//                       left: 20,
//                       right: 20,
//                       bottom: 20,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Category Badge
//                           if (widget.carouselItem.category.isNotEmpty)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: Border.all(
//                                   color: Colors.white.withOpacity(0.3),
//                                 ),
//                               ),
//                               child: Text(
//                                 widget.carouselItem.category.toUpperCase(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600,
//                                   letterSpacing: 1.2,
//                                 ),
//                               ),
//                             ),
                          
//                           const SizedBox(height: 12),
                          
//                           // Title
//                           if (widget.carouselItem.title.isNotEmpty)
//                             Text(
//                               widget.carouselItem.title,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 height: 1.2,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
                          
//                           // Subtitle
//                           if (widget.carouselItem.subtitle.isNotEmpty) ...[
//                             const SizedBox(height: 6),
//                             Text(
//                               widget.carouselItem.subtitle,
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.9),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 height: 1.3,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
                          
//                           const SizedBox(height: 16),
                          
//                           // Action Button
//                           if (widget.carouselItem.buttonText.isNotEmpty)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(25),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.2),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(
//                                     widget.carouselItem.buttonText,
//                                     style: const TextStyle(
//                                       color: Colors.black87,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   const Icon(
//                                     Icons.arrow_forward_rounded,
//                                     color: Colors.black87,
//                                     size: 16,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),

//                     // Active Indicator (subtle border)
//                     if (widget.isActive)
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.3),
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildErrorPlaceholder() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.grey[300]!, Colors.grey[100]!],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.image_outlined,
//               size: 48,
//               color: Colors.grey[600],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Image not available',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CarouselItem {
//   final String title;
//   final String subtitle;
//   final String buttonText;
//   final String category;
//   final String imagePath;
//   final bool isNetworkImage;
//   final String? bannerId;

//   CarouselItem({
//     required this.title,
//     this.subtitle = '',
//     required this.buttonText,
//     required this.category,
//     required this.imagePath,
//     this.isNetworkImage = false,
//     this.bannerId,
//   });
// }










import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(
    viewportFraction: 0.9,
    initialPage: 10000, // Start at a high number for infinite scroll
  );
  int _currentPage = 0;
  Timer? _autoScrollTimer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<CarouselItem> _carouselItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );

    // Fetch banners from API
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse('http://194.164.148.244:4061/api/poster/getbanners'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> bannerData = json.decode(response.body);

        if (bannerData.isNotEmpty) {
          setState(() {
            _carouselItems = bannerData.expand((banner) {
              final images = List<String>.from(banner['images'] ?? []);
              return images.map((image) => CarouselItem(
                    title:'',
                    subtitle: '',
                    buttonText: '',
                    category: '',
                    imagePath: image,
                    isNetworkImage: true,
                    bannerId: banner['_id'],
                  ));
            }).toList();

            _isLoading = false;
            _errorMessage = null;
          });

          // Start animations and auto-scrolling
          _animationController.forward();
          _startAutoScroll();
        } else {
          _useDefaultItems();
        }
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching banners: $e');
      setState(() {
        _errorMessage = 'Failed to load banners';
        _isLoading = false;
      });
      _useDefaultItems();
    }
  }

  void _useDefaultItems() {
    setState(() {
      _carouselItems = [
        CarouselItem(
          title: 'Welcome to Our Platform',
          subtitle: 'Discover amazing features and content',
          buttonText: 'Get Started',
          category: 'Featured',
          imagePath: 'assets/images/default_banner1.jpg',
          isNetworkImage: false,
        ),
      ];
      _isLoading = false;
    });
    _animationController.forward();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (_carouselItems.length > 1) {
      _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
        if (_carouselItems.isNotEmpty && _pageController.hasClients) {
          // Simply move to next page - infinite scroll handles the looping
          _pageController.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.grey[100],
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.blue,
          ),
        ),
      );
    }

    if (_carouselItems.isEmpty) {
      return Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.grey[50],
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported_outlined, 
                   size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'No banners available',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Carousel Section with Infinite Scroll
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      // Use modulo to create infinite loop
                      final actualIndex = index % _carouselItems.length;
                      final item = _carouselItems[actualIndex];
                      
                      // Calculate if this is the "current" page for visual feedback
                      final currentPageIndex = _pageController.hasClients 
                          ? (_pageController.page ?? 0).round() % _carouselItems.length
                          : 0;
                      final isActive = actualIndex == currentPageIndex;
                      
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: isActive ? 0 : 12,
                        ),
                        child: ProfessionalCarouselCard(
                          carouselItem: item,
                          isActive: isActive,
                          onTap: () {
                            print('Tapped on banner: ${item.bannerId}');
                          },
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Page Indicator
                if (_carouselItems.length > 1)
                  Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: _pageController.hasClients 
                          ? (_pageController.page ?? 0).round() % _carouselItems.length
                          : 0,
                      count: _carouselItems.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Colors.blue[600]!,
                        dotColor: Colors.grey[300]!,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 4,
                        spacing: 6,
                      ),
                    ),
                  ),
                
                // Error Message
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.cloud_off_outlined, 
                             size: 20, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Using offline content - Check your connection',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfessionalCarouselCard extends StatefulWidget {
  final CarouselItem carouselItem;
  final bool isActive;
  final VoidCallback? onTap;

  const ProfessionalCarouselCard({
    super.key,
    required this.carouselItem,
    this.isActive = false,
    this.onTap,
  });

  @override
  State<ProfessionalCarouselCard> createState() => _ProfessionalCarouselCardState();
}

class _ProfessionalCarouselCardState extends State<ProfessionalCarouselCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _hoverAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) => _hoverController.reverse(),
      onTapCancel: () => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _hoverAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                          spreadRadius: 0,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: widget.carouselItem.isNetworkImage
                          ? Image.network(
                              widget.carouselItem.imagePath,
                              fit: BoxFit.fill,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.grey[300]!, Colors.grey[100]!],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.blue[300],
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return _buildErrorPlaceholder();
                              },
                            )
                          : Image.asset(
                              widget.carouselItem.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildErrorPlaceholder();
                              },
                            ),
                    ),

                    // Gradient Overlays
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),

                    // Content Overlay
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Category Badge
                          if (widget.carouselItem.category.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                widget.carouselItem.category.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 12),
                          
                          // Title
                          if (widget.carouselItem.title.isNotEmpty)
                            Text(
                              widget.carouselItem.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          
                          // Subtitle
                          if (widget.carouselItem.subtitle.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              widget.carouselItem.subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          
                          const SizedBox(height: 16),
                          
                          // Action Button
                          if (widget.carouselItem.buttonText.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.carouselItem.buttonText,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.black87,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Active Indicator (subtle border)
                    if (widget.isActive)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselItem {
  final String title;
  final String subtitle;
  final String buttonText;
  final String category;
  final String imagePath;
  final bool isNetworkImage;
  final String? bannerId;

  CarouselItem({
    required this.title,
    this.subtitle = '',
    required this.buttonText,
    required this.category,
    required this.imagePath,
    this.isNetworkImage = false,
    this.bannerId,
  });
}