// // import 'package:flutter/material.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:intl/intl.dart';
// // import 'package:posternova/helper/storage_helper.dart';

// // class OnlinePunchangScreen extends StatefulWidget {
// //   const OnlinePunchangScreen({super.key});

// //   @override
// //   State<OnlinePunchangScreen> createState() => _OnlinePunchangScreenState();
// // }

// // class _OnlinePunchangScreenState extends State<OnlinePunchangScreen> {
// //   bool isLoading = true;
// //   Map<String, dynamic>? panchangData;
// //   String? errorMessage;
// //   Position? currentPosition;
// //   DateTime selectedDate = DateTime.now();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeData();
// //   }

// //   Future<void> _initializeData() async {
// //     await _getCurrentLocation();
// //     await _fetchPanchangData();
// //   }

// //   Future<void> _getCurrentLocation() async {
// //     try {
// //       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //       if (!serviceEnabled) {
// //         setState(() {
// //           errorMessage = 'Location services are disabled.';
// //           isLoading = false;
// //         });
// //         return;
// //       }

// //       LocationPermission permission = await Geolocator.checkPermission();
// //       if (permission == LocationPermission.denied) {
// //         permission = await Geolocator.requestPermission();
// //         if (permission == LocationPermission.denied) {
// //           setState(() {
// //             errorMessage = 'Location permissions are denied';
// //             isLoading = false;
// //           });
// //           return;
// //         }
// //       }

// //       if (permission == LocationPermission.deniedForever) {
// //         setState(() {
// //           errorMessage = 'Location permissions are permanently denied';
// //           isLoading = false;
// //         });
// //         return;
// //       }

// //       Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high,
// //       );

// //       setState(() {
// //         currentPosition = position;
// //       });
// //     } catch (e) {
// //       setState(() {
// //         errorMessage = 'Error getting location: $e';
// //         // Use default location (Delhi) if location fails
// //         currentPosition = Position(
// //           latitude: 28.6139,
// //           longitude: 77.2090,
// //           timestamp: DateTime.now(),
// //           accuracy: 0,
// //           altitude: 0,
// //           heading: 0,
// //           speed: 0,
// //           speedAccuracy: 0,
// //           altitudeAccuracy: 0,
// //           headingAccuracy: 0,
// //         );
// //       });
// //     }
// //   }

// //   Future<void> _fetchPanchangData() async {
// //     setState(() {
// //       isLoading = true;
// //       errorMessage = null;
// //     });

// //     try {
// //       final userData = await AuthPreferences.getUserData();
// //       if (userData == null) {
// //         setState(() {
// //           errorMessage = 'User not logged in';
// //           isLoading = false;
// //         });
// //         return;
// //       }

// //       final userId = userData.user.id;
// //       final url = 'http://31.97.206.144:4061/api/users/panchang/$userId';

// //       final payload = {
// //         "year": selectedDate.year,
// //         "month": selectedDate.month,
// //         "date": selectedDate.day,
// //         "latitude": currentPosition?.latitude ?? 28.6139,
// //         "longitude": currentPosition?.longitude ?? 77.2090,
// //       };

// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode(payload),
// //       );

// //       print(
// //         'Response status code for get punchangggggggggggg ${response.statusCode}',
// //       );
// //       print(
// //         'Response bodyyyyyyyyyyy code for get punchangggggggggggg ${response.body}',
// //       );

// //       print('Payloaddddddddddddddddddddddd $payload');

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         setState(() {
// //           panchangData = data;
// //           isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           errorMessage = 'Failed to load panchang data';
// //           isLoading = false;
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         errorMessage = 'Error: $e';
// //         isLoading = false;
// //       });
// //     }
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate,
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2100),
// //       builder: (context, child) {
// //         return Theme(
// //           data: Theme.of(context).copyWith(
// //             colorScheme: ColorScheme.light(
// //               primary: Colors.deepOrange,
// //               onPrimary: Colors.white,
// //               surface: Colors.white,
// //               onSurface: Colors.black,
// //             ),
// //           ),
// //           child: child!,
// //         );
// //       },
// //     );
// //     if (picked != null && picked != selectedDate) {
// //       setState(() {
// //         selectedDate = picked;
// //       });
// //       await _fetchPanchangData();
// //     }
// //   }

// //   String _formatTime(String isoTime) {
// //     try {
// //       DateTime dateTime = DateTime.parse(isoTime).toLocal();
// //       return DateFormat('hh:mm a').format(dateTime);
// //     } catch (e) {
// //       return 'N/A';
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [Colors.orange.shade50, Colors.white],
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Column(
// //             children: [
// //               _buildHeader(),
// //               Expanded(
// //                 child: isLoading
// //                     ? _buildLoadingState()
// //                     : errorMessage != null
// //                     ? _buildErrorState()
// //                     : _buildPanchangContent(),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildHeader() {
// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [Colors.deepOrange, Colors.orange.shade700],
// //         ),
// //         borderRadius: const BorderRadius.only(
// //           bottomLeft: Radius.circular(30),
// //           bottomRight: Radius.circular(30),
// //         ),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.orange.withOpacity(0.3),
// //             blurRadius: 10,
// //             offset: const Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               IconButton(
// //                 icon: const Icon(Icons.arrow_back, color: Colors.white),
// //                 onPressed: () => Navigator.pop(context),
// //               ),
// //               const Text(
// //                 'ఆన్‌లైన్ పంచాంగం',
// //                 style: TextStyle(
// //                   fontSize: 24,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.refresh, color: Colors.white),
// //                 onPressed: _fetchPanchangData,
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 15),
// //           GestureDetector(
// //             onTap: () => _selectDate(context),
// //             child: Container(
// //               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //               decoration: BoxDecoration(
// //                 color: Colors.white.withOpacity(0.2),
// //                 borderRadius: BorderRadius.circular(15),
// //                 border: Border.all(color: Colors.white.withOpacity(0.3)),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   const Icon(
// //                     Icons.calendar_today,
// //                     color: Colors.white,
// //                     size: 20,
// //                   ),
// //                   const SizedBox(width: 10),
// //                   Text(
// //                     DateFormat('dd MMMM yyyy').format(selectedDate),
// //                     style: const TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 10),
// //                   const Icon(Icons.arrow_drop_down, color: Colors.white),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildLoadingState() {
// //     return const Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(
// //             valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
// //           ),
// //           SizedBox(height: 20),
// //           Text(
// //             'పంచాంగం లోడ్ అవుతోంది...',
// //             style: TextStyle(fontSize: 16, color: Colors.grey),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildErrorState() {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
// //             const SizedBox(height: 20),
// //             Text(
// //               errorMessage ?? 'Unknown error',
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(fontSize: 16, color: Colors.red),
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton.icon(
// //               onPressed: _fetchPanchangData,
// //               icon: const Icon(Icons.refresh),
// //               label: const Text('మళ్లీ ప్రయత్నించండి'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.deepOrange,
// //                 foregroundColor: Colors.white,
// //                 padding: const EdgeInsets.symmetric(
// //                   horizontal: 30,
// //                   vertical: 12,
// //                 ),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildPanchangContent() {
// //     if (panchangData == null) return const SizedBox();

// //     final data = panchangData!['data'];
// //     final user = panchangData!['user'];

// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(20),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildUserInfo(user),
// //           const SizedBox(height: 20),
// //           _buildVaaraCard(data['vaara']),
// //           const SizedBox(height: 15),
// //           _buildSunMoonTimings(data),
// //           const SizedBox(height: 15),
// //           _buildNakshatraSection(data['nakshatra']),
// //           const SizedBox(height: 15),
// //           _buildTithiSection(data['tithi']),
// //           const SizedBox(height: 15),
// //           _buildYogaSection(data['yoga']),
// //           const SizedBox(height: 15),
// //           _buildKaranaSection(data['karana']),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildUserInfo(Map<String, dynamic> user) {
// //     return Container(
// //       padding: const EdgeInsets.all(15),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(15),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 10,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         children: [
// //           CircleAvatar(
// //             backgroundColor: Colors.deepOrange.shade100,
// //             radius: 30,
// //             child: Text(
// //               user['name'][0].toUpperCase(),
// //               style: const TextStyle(
// //                 fontSize: 24,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.deepOrange,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 15),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   user['name'],
// //                   style: const TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   'జన్మదినం: ${user['dob']}',
// //                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildVaaraCard(String vaara) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [Colors.deepOrange.shade400, Colors.orange.shade600],
// //         ),
// //         borderRadius: BorderRadius.circular(15),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.orange.withOpacity(0.3),
// //             blurRadius: 10,
// //             offset: const Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           const Text(
// //             'వారము',
// //             style: TextStyle(
// //               fontSize: 16,
// //               color: Colors.white70,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             vaara,
// //             style: const TextStyle(
// //               fontSize: 28,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.white,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildSunMoonTimings(Map<String, dynamic> data) {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: _buildTimingCard(
// //             'సూర్యోదయం',
// //             _formatTime(data['sunrise']),
// //             Icons.wb_sunny,
// //             Colors.amber,
// //           ),
// //         ),
// //         const SizedBox(width: 10),
// //         Expanded(
// //           child: _buildTimingCard(
// //             'సూర్యాస్తమయం',
// //             _formatTime(data['sunset']),
// //             Icons.nights_stay,
// //             Colors.indigo,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildTimingCard(
// //     String title,
// //     String time,
// //     IconData icon,
// //     Color color,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.all(15),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(15),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 10,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Icon(icon, color: color, size: 30),
// //           const SizedBox(height: 8),
// //           Text(
// //             title,
// //             style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             time,
// //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildNakshatraSection(List<dynamic> nakshatras) {
// //     return _buildSectionCard(
// //       'నక్షత్రం',
// //       Icons.stars,
// //       Colors.purple,
// //       Column(
// //         children: nakshatras.map((nakshatra) {
// //           return _buildListItem(
// //             nakshatra['name'],
// //             '${_formatTime(nakshatra['start'])} - ${_formatTime(nakshatra['end'])}',
// //             'Lord: ${nakshatra['lord']['vedic_name']}',
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   Widget _buildTithiSection(List<dynamic> tithis) {
// //     return _buildSectionCard(
// //       'తిథి',
// //       Icons.calendar_month,
// //       Colors.blue,
// //       Column(
// //         children: tithis.map((tithi) {
// //           return _buildListItem(
// //             tithi['name'],
// //             '${_formatTime(tithi['start'])} - ${_formatTime(tithi['end'])}',
// //             tithi['paksha'],
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   Widget _buildYogaSection(List<dynamic> yogas) {
// //     return _buildSectionCard(
// //       'యోగం',
// //       Icons.self_improvement,
// //       Colors.green,
// //       Column(
// //         children: yogas.map((yoga) {
// //           return _buildListItem(
// //             yoga['name'],
// //             '${_formatTime(yoga['start'])} - ${_formatTime(yoga['end'])}',
// //             null,
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   Widget _buildKaranaSection(List<dynamic> karanas) {
// //     return _buildSectionCard(
// //       'కరణం',
// //       Icons.av_timer,
// //       Colors.orange,
// //       Column(
// //         children: karanas.map((karana) {
// //           return _buildListItem(
// //             karana['name'],
// //             '${_formatTime(karana['start'])} - ${_formatTime(karana['end'])}',
// //             null,
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   Widget _buildSectionCard(
// //     String title,
// //     IconData icon,
// //     Color color,
// //     Widget content,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.all(15),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(15),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.grey.withOpacity(0.1),
// //             blurRadius: 10,
// //             offset: const Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: color.withOpacity(0.1),
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //                 child: Icon(icon, color: color, size: 24),
// //               ),
// //               const SizedBox(width: 10),
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   fontSize: 18,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 15),
// //           content,
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildListItem(String title, String time, String? subtitle) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade50,
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             title,
// //             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             time,
// //             style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
// //           ),
// //           if (subtitle != null) ...[
// //             const SizedBox(height: 2),
// //             Text(
// //               subtitle,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 color: Colors.grey.shade500,
// //                 fontStyle: FontStyle.italic,
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }
// // }




















// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:posternova/helper/storage_helper.dart';

// class OnlinePunchangScreen extends StatefulWidget {
//   const OnlinePunchangScreen({super.key});

//   @override
//   State<OnlinePunchangScreen> createState() => _OnlinePunchangScreenState();
// }

// class _OnlinePunchangScreenState extends State<OnlinePunchangScreen> {
//   bool isLoading = false;
//   Map<String, dynamic>? panchangData;
//   String? errorMessage;
//   DateTime selectedDate = DateTime.now();
//   final TextEditingController _locationController = TextEditingController();
//   String location = 'Hyderabad, Telangana, India';

//   @override
//   void initState() {
//     super.initState();
//     _locationController.text = location;
//     _fetchPanchangData();
//   }

//   @override
//   void dispose() {
//     _locationController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchPanchangData() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       final userData = await AuthPreferences.getUserData();
//       if (userData == null) {
//         setState(() {
//           errorMessage = 'User not logged in';
//           isLoading = false;
//         });
//         return;
//       }

//       final userId = userData.user.id;
//       final url = 'http://31.97.206.144:4061/api/users/panchang/$userId';

//       final payload = {
//         "year": selectedDate.year,
//         "month": selectedDate.month,
//         "date": selectedDate.day,
//         "location": location,
//       };

//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(payload),
//       );

//       print('Response status code: ${response.statusCode}');
//       print('Response body: ${response.body}');
//       print('Payload: $payload');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           panchangData = data;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load panchang data';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.deepOrange,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//       await _fetchPanchangData();
//     }
//   }

//   void _showLocationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text(
//             'స్థానం మార్చండి',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: TextField(
//             controller: _locationController,
//             decoration: InputDecoration(
//               labelText: 'స్థానం',
//               hintText: 'ఉదా: హైదరాబాద్, తెలంగాణ, ఇండియా',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               prefixIcon: const Icon(Icons.location_on, color: Colors.deepOrange),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('రద్దు చేయండి'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   location = _locationController.text.trim();
//                 });
//                 Navigator.pop(context);
//                 _fetchPanchangData();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepOrange,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text('సేవ్ చేయండి'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _formatTime(String isoTime) {
//     try {
//       DateTime dateTime = DateTime.parse(isoTime).toLocal();
//       return DateFormat('hh:mm a').format(dateTime);
//     } catch (e) {
//       return 'N/A';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.orange.shade50, Colors.white],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: isLoading
//                     ? _buildLoadingState()
//                     : errorMessage != null
//                     ? _buildErrorState()
//                     : _buildPanchangContent(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.deepOrange, Colors.orange.shade700],
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // IconButton(
//               //   icon: const Icon(Icons.arrow_back, color: Colors.white),
//               //   onPressed: () => Navigator.pop(context),
//               // ),
//               const Text(
//                 'ఆన్‌లైన్ పంచాంగం',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
                  
                  
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.refresh, color: Colors.white),
//                 onPressed: _fetchPanchangData,
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           GestureDetector(
//             onTap: () => _selectDate(context),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: Colors.white.withOpacity(0.3)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.calendar_today,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Text(
//                     DateFormat('dd MMMM yyyy').format(selectedDate),
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   const Icon(Icons.arrow_drop_down, color: Colors.white),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           GestureDetector(
//             onTap: _showLocationDialog,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: Colors.white.withOpacity(0.3)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.location_on,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 10),
//                   Flexible(
//                     child: Text(
//                       location,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   const Icon(Icons.edit, color: Colors.white, size: 18),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'పంచాంగం లోడ్ అవుతోంది...',
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
//             const SizedBox(height: 20),
//             // Text(
//             //   errorMessage ?? 'Unknown error',
//             //   textAlign: TextAlign.center,
//             //   style: const TextStyle(fontSize: 16, color: Colors.red),
//             // ),
//              Text(
//              'No data for the given date',
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 16, color: Colors.red),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _fetchPanchangData,
//               icon: const Icon(Icons.refresh),
//               label: const Text('మళ్లీ ప్రయత్నించండి'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.deepOrange,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPanchangContent() {
//     if (panchangData == null) return const SizedBox();

//     final data = panchangData!['data'];
//     final user = panchangData!['user'];

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildUserInfo(user),
//           const SizedBox(height: 20),
//           _buildVaaraCard(data['vaara']),
//           const SizedBox(height: 15),
//           _buildSunMoonTimings(data),
//           const SizedBox(height: 15),
//           _buildNakshatraSection(data['nakshatra']),
//           const SizedBox(height: 15),
//           _buildTithiSection(data['tithi']),
//           const SizedBox(height: 15),
//           _buildYogaSection(data['yoga']),
//           const SizedBox(height: 15),
//           _buildKaranaSection(data['karana']),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInfo(Map<String, dynamic> user) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: Colors.deepOrange.shade100,
//             radius: 30,
//             child: Text(
//               user['name'][0].toUpperCase(),
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.deepOrange,
//               ),
//             ),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   user['name'],
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'జన్మదినం: ${user['dob']}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVaaraCard(String vaara) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.deepOrange.shade400, Colors.orange.shade600],
//         ),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.orange.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Text(
//             'వారము',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white70,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             vaara,
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSunMoonTimings(Map<String, dynamic> data) {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildTimingCard(
//             'సూర్యోదయం',
//             _formatTime(data['sunrise']),
//             Icons.wb_sunny,
//             Colors.amber,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: _buildTimingCard(
//             'సూర్యాస్తమయం',
//             _formatTime(data['sunset']),
//             Icons.nights_stay,
//             Colors.indigo,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimingCard(
//     String title,
//     String time,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 30),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             time,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNakshatraSection(List<dynamic> nakshatras) {
//     return _buildSectionCard(
//       'నక్షత్రం',
//       Icons.stars,
//       Colors.purple,
//       Column(
//         children: nakshatras.map((nakshatra) {
//           return _buildListItem(
//             nakshatra['name'],
//             '${_formatTime(nakshatra['start'])} - ${_formatTime(nakshatra['end'])}',
//             'Lord: ${nakshatra['lord']['vedic_name']}',
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildTithiSection(List<dynamic> tithis) {
//     return _buildSectionCard(
//       'తిథి',
//       Icons.calendar_month,
//       Colors.blue,
//       Column(
//         children: tithis.map((tithi) {
//           return _buildListItem(
//             tithi['name'],
//             '${_formatTime(tithi['start'])} - ${_formatTime(tithi['end'])}',
//             tithi['paksha'],
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildYogaSection(List<dynamic> yogas) {
//     return _buildSectionCard(
//       'యోగం',
//       Icons.self_improvement,
//       Colors.green,
//       Column(
//         children: yogas.map((yoga) {
//           return _buildListItem(
//             yoga['name'],
//             '${_formatTime(yoga['start'])} - ${_formatTime(yoga['end'])}',
//             null,
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildKaranaSection(List<dynamic> karanas) {
//     return _buildSectionCard(
//       'కరణం',
//       Icons.av_timer,
//       Colors.orange,
//       Column(
//         children: karanas.map((karana) {
//           return _buildListItem(
//             karana['name'],
//             '${_formatTime(karana['start'])} - ${_formatTime(karana['end'])}',
//             null,
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildSectionCard(
//     String title,
//     IconData icon,
//     Color color,
//     Widget content,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           content,
//         ],
//       ),
//     );
//   }

//   Widget _buildListItem(String title, String time, String? subtitle) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             time,
//             style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//           ),
//           if (subtitle != null) ...[
//             const SizedBox(height: 2),
//             Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade500,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }




















import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:posternova/helper/storage_helper.dart';

class OnlinePunchangScreen extends StatefulWidget {
  const OnlinePunchangScreen({super.key});

  @override
  State<OnlinePunchangScreen> createState() => _OnlinePunchangScreenState();
}

class _OnlinePunchangScreenState extends State<OnlinePunchangScreen> {
  bool isLoading = false;
  Map<String, dynamic>? panchangData;
  String? errorMessage;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _locationController = TextEditingController();
  String location = 'Hyderabad, Telangana, India';

  @override
  void initState() {
    super.initState();
    _locationController.text = location;
    _fetchPanchangData();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _fetchPanchangData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      panchangData = null; // Reset data
    });

    try {
      final userData = await AuthPreferences.getUserData();
      if (userData == null) {
        setState(() {
          errorMessage = 'User not logged in';
          isLoading = false;
        });
        return;
      }

      final userId = userData.user.id;
      final url = 'http://31.97.206.144:4061/api/users/panchang/$userId';

      final payload = {
        "year": selectedDate.year,
        "month": selectedDate.month,
        "date": selectedDate.day,
        "location": location,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Payload: $payload');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Validate response structure
        if (data != null && data['data'] != null) {
          setState(() {
            panchangData = data;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'No data available for the selected date';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load panchang data';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching panchang data: $e');
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      await _fetchPanchangData();
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'స్థానం మార్చండి',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'స్థానం',
              hintText: 'ఉదా: హైదరాబాద్, తెలంగాణ, ఇండియా',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.location_on, color: Colors.deepOrange),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('రద్దు చేయండి'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  location = _locationController.text.trim();
                });
                Navigator.pop(context);
                _fetchPanchangData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('సేవ్ చేయండి'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(String? isoTime) {
    if (isoTime == null) return 'N/A';
    try {
      DateTime dateTime = DateTime.parse(isoTime).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: isLoading
                    ? _buildLoadingState()
                    : errorMessage != null
                    ? _buildErrorState()
                    : _buildPanchangContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.orange.shade700],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ఆన్‌లైన్ పంచాంగం',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _fetchPanchangData,
              ),
            ],
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat('dd MMMM yyyy').format(selectedDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _showLocationDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.edit, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
          ),
          SizedBox(height: 20),
          Text(
            'పంచాంగం లోడ్ అవుతోంది...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
            const SizedBox(height: 20),
            Text(
              errorMessage ?? 'No data available for the given date',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _fetchPanchangData,
              icon: const Icon(Icons.refresh),
              label: const Text('మళ్లీ ప్రయత్నించండి'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanchangContent() {
    if (panchangData == null || panchangData!['data'] == null) {
      return _buildErrorState();
    }

    final data = panchangData!['data'];
    final user = panchangData!['user'];

    // Additional null checks for nested data
    if (data == null || user == null) {
      return _buildErrorState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(user),
          const SizedBox(height: 20),
          if (data['vaara'] != null) _buildVaaraCard(data['vaara']),
          const SizedBox(height: 15),
          _buildSunMoonTimings(data),
          const SizedBox(height: 15),
          if (data['nakshatra'] != null && data['nakshatra'] is List)
            _buildNakshatraSection(data['nakshatra']),
          const SizedBox(height: 15),
          if (data['tithi'] != null && data['tithi'] is List)
            _buildTithiSection(data['tithi']),
          const SizedBox(height: 15),
          if (data['yoga'] != null && data['yoga'] is List)
            _buildYogaSection(data['yoga']),
          const SizedBox(height: 15),
          if (data['karana'] != null && data['karana'] is List)
            _buildKaranaSection(data['karana']),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> user) {
    final name = user['name']?.toString() ?? 'User';
    final dob = user['dob']?.toString() ?? 'N/A';
    
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepOrange.shade100,
            radius: 30,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'జన్మదినం: $dob',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaaraCard(String vaara) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade400, Colors.orange.shade600],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'వారము',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vaara,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSunMoonTimings(Map<String, dynamic> data) {
    return Row(
      children: [
        Expanded(
          child: _buildTimingCard(
            'సూర్యోదయం',
            _formatTime(data['sunrise']),
            Icons.wb_sunny,
            Colors.amber,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTimingCard(
            'సూర్యాస్తమయం',
            _formatTime(data['sunset']),
            Icons.nights_stay,
            Colors.indigo,
          ),
        ),
      ],
    );
  }

  Widget _buildTimingCard(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildNakshatraSection(List<dynamic> nakshatras) {
    return _buildSectionCard(
      'నక్షత్రం',
      Icons.stars,
      Colors.purple,
      Column(
        children: nakshatras.map((nakshatra) {
          if (nakshatra == null) return const SizedBox.shrink();
          
          final name = nakshatra['name']?.toString() ?? 'N/A';
          final start = _formatTime(nakshatra['start']);
          final end = _formatTime(nakshatra['end']);
          final lordName = nakshatra['lord']?['vedic_name']?.toString() ?? 'N/A';
          
          return _buildListItem(
            name,
            '$start - $end',
            'Lord: $lordName',
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTithiSection(List<dynamic> tithis) {
    return _buildSectionCard(
      'తిథి',
      Icons.calendar_month,
      Colors.blue,
      Column(
        children: tithis.map((tithi) {
          if (tithi == null) return const SizedBox.shrink();
          
          final name = tithi['name']?.toString() ?? 'N/A';
          final start = _formatTime(tithi['start']);
          final end = _formatTime(tithi['end']);
          final paksha = tithi['paksha']?.toString() ?? 'N/A';
          
          return _buildListItem(name, '$start - $end', paksha);
        }).toList(),
      ),
    );
  }

  Widget _buildYogaSection(List<dynamic> yogas) {
    return _buildSectionCard(
      'యోగం',
      Icons.self_improvement,
      Colors.green,
      Column(
        children: yogas.map((yoga) {
          if (yoga == null) return const SizedBox.shrink();
          
          final name = yoga['name']?.toString() ?? 'N/A';
          final start = _formatTime(yoga['start']);
          final end = _formatTime(yoga['end']);
          
          return _buildListItem(name, '$start - $end', null);
        }).toList(),
      ),
    );
  }

  Widget _buildKaranaSection(List<dynamic> karanas) {
    return _buildSectionCard(
      'కరణం',
      Icons.av_timer,
      Colors.orange,
      Column(
        children: karanas.map((karana) {
          if (karana == null) return const SizedBox.shrink();
          
          final name = karana['name']?.toString() ?? 'N/A';
          final start = _formatTime(karana['start']);
          final end = _formatTime(karana['end']);
          
          return _buildListItem(name, '$start - $end', null);
        }).toList(),
      ),
    );
  }

  Widget _buildSectionCard(
    String title,
    IconData icon,
    Color color,
    Widget content,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          content,
        ],
      ),
    );
  }

  Widget _buildListItem(String title, String time, String? subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}