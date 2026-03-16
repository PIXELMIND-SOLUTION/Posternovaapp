// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/views/chat/chat_module.dart';

// class CustomerList extends StatefulWidget {
//   final String? posterImagePath;

//   const CustomerList({super.key, this.posterImagePath});

//   @override
//   State<CustomerList> createState() => _CustomerListState();
// }

// class _CustomerListState extends State<CustomerList> {
//   List<Map<String, dynamic>> _customers = [];
//   List<Map<String, dynamic>> _filteredCustomers = [];
//   bool _isLoading = true;
//   String? _error;
//   final TextEditingController _searchController = TextEditingController();
//   String? _currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAndFetchCustomers();
//   }

//   Future<void> _initializeAndFetchCustomers() async {
//     // Get current user ID
//     final userData = await AuthPreferences.getUserData();
//     if (userData != null) {
//       setState(() {
//         _currentUserId = userData.user.id;
//       });
//       await _fetchCustomers();
//     } else {
//       setState(() {
//         _error = 'User not authenticated';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _fetchCustomers() async {
//     if (_currentUserId == null) return;

//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse(
//           'http://31.97.206.144:4061/api/users/allcustomers/$_currentUserId',
//         ),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         // Handle different response structures
//         List<dynamic> customersList;
//         if (data is List) {
//           customersList = data;
//         } else if (data['customers'] != null) {
//           customersList = data['customers'];
//         } else if (data['data'] != null) {
//           customersList = data['data'];
//         } else {
//           throw Exception('Unexpected response format');
//         }

//         setState(() {
//           _customers = customersList.map((customer) {
//             return {
//               '_id': customer['_id'] ?? customer['id'] ?? '',
//               'name': customer['name'] ?? 'Unknown',
//               'mobile': customer['mobile'] ?? customer['phone'] ?? '',
//               'email': customer['email'] ?? '',
//               'lastMessage': customer['lastMessage'] ?? '',
//               'lastMessageTime': customer['lastMessageTime'] ?? '',
//               'unreadCount': customer['unreadCount'] ?? 0,
//               'isOnline': customer['isOnline'] ?? false,
//             };
//           }).toList();
//           _filteredCustomers = _customers;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _error = 'Failed to load customers: ${response.statusCode}';
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Error: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   void _filterCustomers(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredCustomers = _customers;
//       } else {
//         _filteredCustomers = _customers.where((customer) {
//           final name = customer['name'].toString().toLowerCase();
//           final mobile = customer['mobile'].toString().toLowerCase();
//           final searchLower = query.toLowerCase();
//           return name.contains(searchLower) || mobile.contains(searchLower);
//         }).toList();
//       }
//     });
//   }

//   // void _navigateToChat(Map<String, dynamic> customer) {
//   //   if (widget.posterImagePath != null) {
//   //     // Navigate with poster image
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => ChatModule(
//   //           posterImagePath: widget.posterImagePath!,
//   //           selectedCustomers: [customer],
//   //         ),
//   //       ),
//   //     );
//   //   } else {
//   //     // Navigate without poster image (you might want to handle this differently)
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('No poster image selected'),
//   //         backgroundColor: Colors.orange,
//   //       ),
//   //     );
//   //   }
//   // }

//   void _navigateToChat(Map<String, dynamic> customer) {
//     if (widget.posterImagePath != null) {
//       // Navigate with poster image
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatModule(
//             posterImagePath: widget.posterImagePath!,
//             selectedCustomers: [customer],
//           ),
//         ),
//       );
//     } else {
//       // Navigate without poster image for regular chat
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ChatModule(
//             posterImagePath: '', // Empty string for regular chat
//             selectedCustomers: [customer],
//           ),
//         ),
//       );
//     }
//   }

//   String _formatTime(String? timestamp) {
//     if (timestamp == null || timestamp.isEmpty) return '';

//     try {
//       final dateTime = DateTime.parse(timestamp);
//       final now = DateTime.now();
//       final difference = now.difference(dateTime);

//       if (difference.inDays == 0) {
//         // Today - show time
//         return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
//       } else if (difference.inDays == 1) {
//         return 'Yesterday';
//       } else if (difference.inDays < 7) {
//         return '${difference.inDays}d ago';
//       } else {
//         return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
//       }
//     } catch (e) {
//       return '';
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFF6C5CE7),
//         title: const Text(
//           'Select Customer',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _fetchCustomers,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFF6C5CE7),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: _filterCustomers,
//                   decoration: InputDecoration(
//                     hintText: 'Search customers...',
//                     hintStyle: const TextStyle(
//                       color: Color(0xFF95A5A6),
//                       fontSize: 15,
//                     ),
//                     prefixIcon: const Icon(
//                       Icons.search,
//                       color: Color(0xFF6C5CE7),
//                     ),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                             icon: const Icon(
//                               Icons.clear,
//                               color: Color(0xFF95A5A6),
//                             ),
//                             onPressed: () {
//                               _searchController.clear();
//                               _filterCustomers('');
//                             },
//                           )
//                         : null,
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Customer List
//           Expanded(child: _buildBody()),
//         ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: Color(0xFF6C5CE7)),
//             SizedBox(height: 16),
//             Text(
//               'Loading customers...',
//               style: TextStyle(color: Color(0xFF95A5A6), fontSize: 14),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
//             const SizedBox(height: 16),
//             Text(
//               _error!,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.red, fontSize: 14),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _fetchCustomers,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF6C5CE7),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(24),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_filteredCustomers.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               _searchController.text.isEmpty
//                   ? Icons.people_outline
//                   : Icons.search_off,
//               size: 64,
//               color: const Color(0xFF95A5A6),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _searchController.text.isEmpty
//                   ? 'No customers found'
//                   : 'No results for "${_searchController.text}"',
//               style: const TextStyle(color: Color(0xFF95A5A6), fontSize: 16),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchCustomers,
//       color: const Color(0xFF6C5CE7),
//       child: ListView.separated(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         itemCount: _filteredCustomers.length,
//         separatorBuilder: (context, index) =>
//             Divider(height: 1, indent: 88, color: Colors.grey.shade200),
//         itemBuilder: (context, index) {
//           final customer = _filteredCustomers[index];
//           return _buildCustomerTile(customer);
//         },
//       ),
//     );
//   }

//   Widget _buildCustomerTile(Map<String, dynamic> customer) {
//     final String name = customer['name'] ?? 'Unknown';
//     final String mobile = customer['mobile'] ?? '';
//     final String lastMessage = customer['lastMessage'] ?? 'No messages yet';
//     final String lastMessageTime = _formatTime(customer['lastMessageTime']);
//     final int unreadCount = customer['unreadCount'] ?? 0;
//     final bool isOnline = customer['isOnline'] ?? false;

//     return Material(
//       color: Colors.white,
//       child: InkWell(
//         onTap: () => _navigateToChat(customer),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             children: [
//               // Avatar with online indicator
//               Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [
//                           Color(0xFF6C5CE7).withOpacity(0.8),
//                           const Color(0xFF8B7FF4),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: CircleAvatar(
//                       radius: 28,
//                       backgroundColor: Colors.transparent,
//                       child: Text(
//                         name.substring(0, 1).toUpperCase(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (isOnline)
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         width: 16,
//                         height: 16,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF4CAF50),
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.white, width: 2),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(width: 16),

//               // Customer Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             name,
//                             style: const TextStyle(
//                               color: Color(0xFF2C3E50),
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         if (lastMessageTime.isNotEmpty)
//                           Text(
//                             lastMessageTime,
//                             style: TextStyle(
//                               color: unreadCount > 0
//                                   ? const Color(0xFF6C5CE7)
//                                   : const Color(0xFF95A5A6),
//                               fontSize: 12,
//                               fontWeight: unreadCount > 0
//                                   ? FontWeight.w600
//                                   : FontWeight.normal,
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             mobile.isNotEmpty ? mobile : lastMessage,
//                             style: const TextStyle(
//                               color: Color(0xFF95A5A6),
//                               fontSize: 14,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         if (unreadCount > 0)
//                           Container(
//                             margin: const EdgeInsets.only(left: 8),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 colors: [Color(0xFF6C5CE7), Color(0xFF8B7FF4)],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               unreadCount > 99 ? '99+' : unreadCount.toString(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





















import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/views/chat/chat_module.dart';
import 'package:posternova/widgets/language_widget.dart';

class CustomerList extends StatefulWidget {
  final String? posterImagePath;

  const CustomerList({super.key, this.posterImagePath});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  String? _currentUserId;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeAndFetchCustomers();
  }

  Future<void> _initializeAndFetchCustomers() async {
    // Get current user ID
    final userData = await AuthPreferences.getUserData();
    if (userData != null) {
      setState(() {
        _currentUserId = userData.user.id;
      });
      await _fetchCustomers();
    } else {
      setState(() {
        _error = 'User not authenticated';
        _isLoading = false;
      });
    }
  }
  

  Future<void> _fetchCustomers() async {
    if (_currentUserId == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'http://31.97.206.144:4061/api/users/allcustomers/$_currentUserId',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle different response structures
        List<dynamic> customersList;
        if (data is List) {
          customersList = data;
        } else if (data['customers'] != null) {
          customersList = data['customers'];
        } else if (data['data'] != null) {
          customersList = data['data'];
        } else {
          throw Exception('Unexpected response format');
        }

        setState(() {
          _customers = customersList.map((customer) {
            return {
              '_id': customer['_id'] ?? customer['id'] ?? '',
              'name': customer['name'] ?? 'Unknown',
              'mobile': customer['mobile'] ?? customer['phone'] ?? '',
              'email': customer['email'] ?? '',
              'lastMessage': customer['lastMessage'] ?? '',
              'lastMessageTime': customer['lastMessageTime'] ?? '',
              'unreadCount': customer['unreadCount'] ?? 0,
              'isOnline': customer['isOnline'] ?? false,
            };
          }).toList();
          _filteredCustomers = _customers;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load customers: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _filterCustomers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCustomers = _customers;
      } else {
        _filteredCustomers = _customers.where((customer) {
          final name = customer['name'].toString().toLowerCase();
          final mobile = customer['mobile'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return name.contains(searchLower) || mobile.contains(searchLower);
        }).toList();
      }
    });
  }

  void _navigateToChat(Map<String, dynamic> customer) {
    if (widget.posterImagePath != null) {
      // Navigate with poster image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatModule(
            posterImagePath: widget.posterImagePath!,
            selectedCustomers: [customer],
          ),
        ),
      );
    } else {
      // Navigate without poster image for regular chat
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatModule(
            posterImagePath: '', // Empty string for regular chat
            selectedCustomers: [customer],
          ),
        ),
      );
    }
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        // Today - show time
        return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return weekdays[dateTime.weekday - 1];
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year.toString().substring(2)}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isSearching ? _buildSearchAppBar() : _buildNormalAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF075E54), // WhatsApp green
      title: const AppText(
        'select_contact',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back, color: Colors.white),
      //   onPressed: () => Navigator.pop(context),
      // ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            if (value == 'refresh') {
              _fetchCustomers();
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: Text('Refresh'),
            ),
          ],
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF075E54),
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
            _filterCustomers('');
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: _filterCustomers,
        style: const TextStyle(color: Colors.white, fontSize: 17),
        decoration: const InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white70, fontSize: 17),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF075E54)),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: _fetchCustomers,
              child: const Text(
                'RETRY',
                style: TextStyle(
                  color: Color(0xFF075E54),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredCustomers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isEmpty
                  ? Icons.people_outline
                  : Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No contacts found'
                  : 'No results found for "${_searchController.text}"',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCustomers,
      color: const Color(0xFF075E54),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _filteredCustomers.length,
        itemBuilder: (context, index) {
          final customer = _filteredCustomers[index];
          return _buildCustomerTile(customer);
        },
      ),
    );
  }

  Widget _buildCustomerTile(Map<String, dynamic> customer) {
    final String name = customer['name'] ?? 'Unknown';
    final String mobile = customer['mobile'] ?? '';
    final String lastMessage = customer['lastMessage'] ?? 'Tap to message';
    final String lastMessageTime = _formatTime(customer['lastMessageTime']);
    final int unreadCount = customer['unreadCount'] ?? 0;
    final bool isOnline = customer['isOnline'] ?? false;

    return InkWell(
      onTap: () => _navigateToChat(customer),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade300,
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366), // WhatsApp green
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Customer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMessageTime.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            lastMessageTime,
                            style: TextStyle(
                              color: unreadCount > 0
                                  ? const Color(0xFF25D366)
                                  : Colors.grey.shade600,
                              fontSize: 12.5,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mobile.isNotEmpty ? mobile : lastMessage,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.5,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF25D366), // WhatsApp green
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 999
                                  ? '999+'
                                  : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
    );
  }
}