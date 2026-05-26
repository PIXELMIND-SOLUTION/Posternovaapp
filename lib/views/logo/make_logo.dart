// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:posternova/views/logo/new_logo.dart';

// class LogosGridScreen extends StatefulWidget {
//   final String userId;
//   final String categoryId;

//   const LogosGridScreen({
//     Key? key,
//     required this.userId,
//     required this.categoryId,
//   }) : super(key: key);

//   @override
//   State<LogosGridScreen> createState() => _LogosGridScreenState();
// }

// class _LogosGridScreenState extends State<LogosGridScreen> {
//   List<LogoData> _logos = [];
//   bool _isLoading = true;
//   String? _errorMessage;

//   bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

//   @override
//   void initState() {
//     super.initState();
//     _fetchLogos();
//   }

//   Future<void> _fetchLogos() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final url = Uri.parse(
//         'http://31.97.228.17:4061/api/admin/getlogos/${widget.userId}?logoCategoryId=${widget.categoryId}',
//       );

//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           _logos = data.map((json) => LogoData.fromJson(json)).toList();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _errorMessage =
//               'Failed to load logos. Status code: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = _isDarkMode;

//     return Scaffold(
//       backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
//       appBar: AppBar(
//         title: Text(
//           'Choose a Logo',
//           style: TextStyle(color: isDarkMode ? Colors.white : Colors.white),
//         ),
//         backgroundColor: const Color(0xFFF5C518),
//         foregroundColor: Colors.black87,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black87),
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     final isDarkMode = _isDarkMode;

//     if (_isLoading) {
//       return Center(
//         child: CircularProgressIndicator(color: const Color(0xFFF5C518)),
//       );
//     }

//     if (_errorMessage != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 64,
//               color: isDarkMode ? Colors.red[400] : Colors.red[300],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _errorMessage!,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _fetchLogos,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFF5C518),
//                 foregroundColor: Colors.black87,
//               ),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_logos.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.image_not_supported,
//               size: 64,
//               color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No logos found',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return GridView.builder(
//       padding: const EdgeInsets.all(12),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 0.8,
//       ),
//       itemCount: _logos.length,
//       itemBuilder: (context, index) {
//         final logo = _logos[index];
//         return _buildLogoCard(logo);
//       },
//     );
//   }

//   Widget _buildLogoCard(LogoData logo) {
//     final isDarkMode = _isDarkMode;

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
//       shadowColor: isDarkMode
//           ? Colors.black.withOpacity(0.3)
//           : Colors.black.withOpacity(0.1),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => LogoEditorScreen(logoData: logo),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(12),
//                 ),
//                 child: Image.network(
//                   logo.previewImageUrl,
//                   fit: BoxFit.fill,
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                                   loadingProgress.expectedTotalBytes!
//                             : null,
//                         color: const Color(0xFFF5C518),
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: isDarkMode
//                           ? const Color(0xFF0F172A)
//                           : Colors.grey[200],
//                       child: Center(
//                         child: Icon(
//                           Icons.broken_image,
//                           size: 48,
//                           color: isDarkMode
//                               ? Colors.grey[600]
//                               : Colors.grey[400],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Text(
//                 logo.name,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: isDarkMode ? Colors.white : Colors.black87,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

////////////// Added the search option in this screen/////////////

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/views/logo/new_logo.dart';

class LogosGridScreen extends StatefulWidget {
  final String userId;
  final String categoryId;

  const LogosGridScreen({
    Key? key,
    required this.userId,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<LogosGridScreen> createState() => _LogosGridScreenState();
}

class _LogosGridScreenState extends State<LogosGridScreen> {
  List<LogoData> _logos = [];
  List<LogoData> _filteredLogos = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _fetchLogos();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLogos = List.from(_logos);
      } else {
        _filteredLogos = _logos
            .where((logo) => logo.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  Future<void> _fetchLogos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = Uri.parse(
        'http://31.97.228.17:4061/api/admin/getlogos/${widget.userId}?logoCategoryId=${widget.categoryId}',
      );

      final response = await http.get(url);

      print(
        'Response status code for subcategory iddddddddddd ${response.statusCode}',
      );
      print('Response bodyyyyyyyyyyyyyy for subcategory ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _logos = data.map((json) => LogoData.fromJson(json)).toList();
          _filteredLogos = List.from(_logos);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load logos. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredLogos = List.from(_logos);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Search logos...',
                  hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white54 : Colors.black45,
                  ),
                  border: InputBorder.none,
                ),
              )
            : Text(
                'Choose a Logo',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.white,
                ),
              ),
        backgroundColor: const Color(0xFFF5C518),
        foregroundColor: Colors.black87,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.black87,
            ),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final isDarkMode = _isDarkMode;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFF5C518)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDarkMode ? Colors.red[400] : Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchLogos,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5C518),
                foregroundColor: Colors.black87,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_logos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 64,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No logos found',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredLogos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No logos match "${_searchController.text}"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _searchController.clear();
              },
              child: const Text(
                'Clear search',
                style: TextStyle(color: Color(0xFFF5C518)),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredLogos.length,
      itemBuilder: (context, index) {
        final logo = _filteredLogos[index];
        return _buildLogoCard(logo);
      },
    );
  }

  Widget _buildLogoCard(LogoData logo) {
    final isDarkMode = _isDarkMode;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shadowColor: isDarkMode
          ? Colors.black.withOpacity(0.3)
          : Colors.black.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LogoEditorScreen(logoData: logo),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  logo.previewImageUrl,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFFF5C518),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: isDarkMode
                          ? const Color(0xFF0F172A)
                          : Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: isDarkMode
                              ? Colors.grey[600]
                              : Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                logo.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
