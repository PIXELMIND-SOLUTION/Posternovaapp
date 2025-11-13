// import 'package:flutter/material.dart';

// class AboutScreen extends StatelessWidget {
//   const AboutScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: const Text(
//           "About Us",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.purple.shade400, Colors.blue.shade400],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: const [
//                   Icon(Icons.design_services, size: 70, color: Colors.white),
//                   SizedBox(height: 12),
//                   Text(
//                     "PosterNova",
//                     style: TextStyle(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 6),
//                   Text(
//                     "Create stunning posters & logos effortlessly",
//                     style: TextStyle(fontSize: 16, color: Colors.white70),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             // About Description
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Card(
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: const [
//                       Text(
//                         "About PosterNova",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         "PosterNova is your all-in-one creative studio for designing stunning posters, logos, and promotional content. Whether you are a business owner, influencer, or designer, PosterMaker helps you bring your ideas to life with ready-made templates and powerful editing tools.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.black87,
//                           height: 1.6,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Features Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   _featureCard(
//                     icon: Icons.palette,
//                     title: "Custom Templates",
//                     description:
//                         "Choose from thousands of templates designed for every purpose.",
//                   ),
//                   // _featureCard(
//                   //   icon: Icons.auto_fix_high,
//                   //   title: "AI Logo Generator",
//                   //   description: "Generate unique logos matching your brand’s style.",
//                   // ),
//                   _featureCard(
//                     icon: Icons.share,
//                     title: "Easy Sharing",
//                     description:
//                         "Share your designs instantly on social media.",
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),

//             // Footer Section
//             const Padding(
//               padding: EdgeInsets.only(bottom: 30),
//               child: Text(
//                 "Version 1.0.0\nMade with ❤️ by PosterNova Team",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _featureCard({
//     required IconData icon,
//     required String title,
//     required String description,
//   }) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       child: ListTile(
//         leading: CircleAvatar(
//           radius: 25,
//           backgroundColor: Colors.purple.shade400,
//           child: Icon(icon, color: Colors.blue.shade400, size: 26),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         subtitle: Text(
//           description,
//           style: const TextStyle(fontSize: 14, color: Colors.black87),
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtextColor = isDarkMode ? Colors.grey[400] : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade400, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.design_services, size: 70, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    "PosterNova",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Create stunning posters & logos effortlessly",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // About Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 4,
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "About PosterNova",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "PosterNova is your all-in-one creative studio for designing stunning posters, logos, and promotional content. Whether you are a business owner, influencer, or designer, PosterMaker helps you bring your ideas to life with ready-made templates and powerful editing tools.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: textColor,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Features Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _featureCard(
                    context: context,
                    icon: Icons.palette,
                    title: "Custom Templates",
                    description:
                        "Choose from thousands of templates designed for every purpose.",
                    cardColor: cardColor,
                    textColor: textColor,
                  ),
                  _featureCard(
                    context: context,
                    icon: Icons.share,
                    title: "Easy Sharing",
                    description:
                        "Share your designs instantly on social media.",
                    cardColor: cardColor,
                    textColor: textColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Footer Section
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                "Version 1.0.0\nMade with ❤️ by Editezy Team",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: subtextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color? cardColor,
    required Color textColor,
  }) {
    return Card(
      elevation: 2,
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.purple.shade400,
          child: Icon(icon, color: Colors.blue.shade400, size: 26),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
      ),
    );
  }
}