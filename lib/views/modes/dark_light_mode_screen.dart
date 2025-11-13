// import 'package:flutter/material.dart';
// import 'package:posternova/providers/theme/theme_provider.dart';
// import 'package:provider/provider.dart';

// class ThemeSettingsScreen extends StatelessWidget {
//   const ThemeSettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Theme Settings",style: TextStyle(fontWeight: FontWeight.bold),),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: ListTile(
//             leading: Icon(
//               themeProvider.isDarkMode
//                   ? Icons.dark_mode_rounded
//                   : Icons.light_mode_rounded,
//               color: themeProvider.isDarkMode ? Colors.amber : Colors.blue,
//             ),
//             title: const Text(
//               "Dark Mode",
//               style: TextStyle(fontSize: 18),
//             ),
//             trailing: Switch(
//               value: themeProvider.isDarkMode,
//               onChanged: (value) {
//                 themeProvider.toggleTheme(value);
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
