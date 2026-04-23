// import 'package:flutter/material.dart';
// import 'package:posternova/widgets/language_widget.dart';

// class AboutScreen extends StatelessWidget {
//   const AboutScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Get the current theme
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final backgroundColor = isDarkMode
//         ? const Color(0xFF0F172A)
//         : const Color(0xFFF8FAFC);
//     final cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
//     final textColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
//     final subtextColor = isDarkMode
//         ? Colors.grey[400]
//         : const Color(0xFF64748B);
//     // final accentColor = const Color(0xFFF5C518);
//     final accentColor = const Color.fromARGB(255, 26, 67, 145);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         title: AppText(
//           "about_us",
//           style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: cardColor,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(Icons.arrow_back_ios, color: textColor),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [accentColor, accentColor.withOpacity(0.7)],
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
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       // color: Colors.white.withOpacity(0.2),
//                       // shape: BoxShape.circle,
//                     ),

//                     // child: const Icon(
//                     //   Icons.design_services,
//                     //   size: 60,
//                     //   color: Colors.white,
//                     // ),
//                     child: Image.asset('assets/appstore.png', width: 90),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     "Editezy",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Text(
//                       "Create. Manage. Grow.",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 24),

//             // About Description
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Card(
//                 elevation: 4,
//                 color: cardColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: accentColor.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Icon(
//                               Icons.info_outline,
//                               color: accentColor,
//                               size: 24,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               "About Editezy",
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: textColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         '''Editezy is an all-in-one creative and business management platform built to simplify how you design, organize, and grow your brand. Designed for creators, entrepreneurs, and businesses, Editezy brings powerful tools together in one seamless experience.
// In today’s fast-paced digital world, you need more than just good design—you need speed, consistency, and smart management. That’s where Editezy comes in.
// With Editezy, you can create stunning visuals using ready-made posters, customizable templates, logos, and professional business cards—helping you build a strong and professional brand identity effortlessly. Our background remover makes editing quick and easy, even if you have no prior design experience.
// Beyond creativity, Editezy helps you stay organized with a business and customer database management system, allowing you to manage client information, track your work, and keep everything in one place.
// What We Offer
// Ready-made posters for quick and impactful content
// Customizable templates for social media and branding
// Logo creation tools to build your identity
// Professional business card designs
// Background remover for clean, high-quality visuals
// Business & customer database management system
// At Editezy, our mission is to empower you with simple, smart, and effective tools that help you focus on what matters—growing your brand.
// Editezy – Create. Manage. Grow.''',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: textColor,
//                           height: 1.6,
//                         ),
//                         textAlign: TextAlign.start,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 24),

//             // What We Offer Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: accentColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(Icons.stars, color: accentColor, size: 24),
//                       ),
//                       const SizedBox(width: 12),
//                       Text(
//                         "What We Offer",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: textColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Feature Grid
//                   GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                     childAspectRatio: 1.2,
//                     children: [
//                       _featureItem(
//                         icon: Icons.image,
//                         title: "Ready-made posters",
//                         color: accentColor,
//                         textColor: textColor,
//                         cardColor: cardColor,
//                       ),
//                       _featureItem(
//                         icon: Icons.image,
//                         title: "Customizable templates",
//                         color: accentColor,
//                         textColor: textColor,
//                         cardColor: cardColor,
//                       ),
//                       _featureItem(
//                         icon: Icons.emoji_objects,
//                         title: "Logo design tools",
//                         color: accentColor,
//                         textColor: textColor,
//                         cardColor: cardColor,
//                       ),
//                       _featureItem(
//                         icon: Icons.credit_card,
//                         title: "Business card creation",
//                         color: accentColor,
//                         textColor: textColor,
//                         cardColor: cardColor,
//                       ),
//                       // _featureItem(
//                       //   icon: Icons.remove,
//                       //   title: "AI-powered background remover",
//                       //   color: accentColor,
//                       //   textColor: textColor,
//                       //   cardColor: cardColor,
//                       // ),
//                       // _featureItem(
//                       //   icon: Icons.receipt,
//                       //   title: "Invoice generation",
//                       //   color: accentColor,
//                       //   textColor: textColor,
//                       //   cardColor: cardColor,
//                       // ),
//                       _featureItem(
//                         icon: Icons.storage,
//                         title: "Customer database management",
//                         color: accentColor,
//                         textColor: textColor,
//                         cardColor: cardColor,
//                       ),
//                       _featureItem(
//                         icon: Icons.business_center,
//                         title: "Business management tools",
//                         color: accentColor,
//                         textColor: textColor,
//                         cardColor: cardColor,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _featureItem({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required Color textColor,
//     required Color cardColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.2), width: 1),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 28, color: color),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: textColor,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }





















import 'package:flutter/material.dart';
import 'package:posternova/widgets/language_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);
    final cardColor = isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final subtextColor = isDarkMode
        ? Colors.grey[400]
        : const Color(0xFF64748B);
    final accentColor = const Color.fromARGB(255, 26, 67, 145);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: AppText(
          "about_us",
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accentColor, accentColor.withOpacity(0.7)],
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(),
                    child: Image.asset('assets/editezylogo.png', width: 100),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Edit Ezy",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Create. Manage. Grow.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 4,
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: accentColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "About Edit Ezy",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Edit Ezy is a smart and simple platform designed to help you create, manage, and grow your business effortlessly. Built for entrepreneurs, small business owners, and creators, Editezy brings everything you need into one easy-to-use app.\n\n'
                        'In today\'s fast-moving digital world, creating professional designs and staying connected with customers should be quick and hassle-free. Editezy makes this possible with ready-made posters and customizable templates that allow you to design stunning visuals in just a few taps—no design skills required.\n\n'
                        'Whether you want to promote your business, share festival wishes, or create daily social media content, Editezy gives you professionally designed templates that you can easily customize with your text, logo, and branding.\n\n'
                        'Beyond design, Editezy helps you build stronger customer relationships. With the built-in customer management feature, you can add and organize your contacts, track important dates like birthdays and anniversaries, and stay connected with your customers consistently.\n\n'
                        'You can also create professional business cards to establish your brand identity and leave a lasting impression.\n\n'
                        'At Editezy, our goal is simple — to give you the tools you need to design faster, connect better, and grow your business smarter.',
                        
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // What We Offer Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.stars, color: accentColor, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "What Edit Ezy Offers",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Feature Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                    children: [
                      _featureItem(
                        icon: Icons.image,
                        title: "Ready-made posters",
                        color: accentColor,
                        textColor: textColor,
                        cardColor: cardColor,
                      ),
                      _featureItem(
                        icon: Icons.dashboard_customize,
                        title: "Customizable templates",
                        color: accentColor,
                        textColor: textColor,
                        cardColor: cardColor,
                      ),
                      _featureItem(
                        icon: Icons.credit_card,
                        title: "Business card creation",
                        color: accentColor,
                        textColor: textColor,
                        cardColor: cardColor,
                      ),
                      _featureItem(
                        icon: Icons.people_alt,
                        title: "Customer management with reminders",
                        color: accentColor,
                        textColor: textColor,
                        cardColor: cardColor,
                      ),
                      _featureItem(
                        icon: Icons.edit,
                        title: "Easy editing & personalization",
                        color: accentColor,
                        textColor: textColor,
                        cardColor: cardColor,
                      ),
                      _featureItem(
                        icon: Icons.trending_up,
                        title: "Tools to grow your business",
                        color: accentColor,
                        textColor: textColor,
                        cardColor: cardColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Footer tagline
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                "Editezy – Create. Manage. Grow.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureItem({
    required IconData icon,
    required String title,
    required Color color,
    required Color textColor,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}