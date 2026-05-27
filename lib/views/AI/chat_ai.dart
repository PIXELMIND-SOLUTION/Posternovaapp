// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'dart:typed_data';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // // import 'package:flutter_tts/flutter_tts.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:image_picker/image_picker.dart';
// // // import 'package:gal/gal.dart';
// // // import 'package:posternova/widgets/language_widget.dart';
// // // import 'package:share_plus/share_plus.dart';
// // // import 'package:path_provider/path_provider.dart';

// // // class AiScreen extends StatefulWidget {
// // //   const AiScreen({super.key});

// // //   @override
// // //   State<AiScreen> createState() => _AiScreenState();
// // // }

// // // class _AiScreenState extends State<AiScreen> {
// // //   final TextEditingController _messageController = TextEditingController();
// // //   final List<Map<String, dynamic>> _messages = [];
// // //   bool _isLoading = false;
// // //   final ScrollController _scrollController = ScrollController();

// // //   File? _logoFile;
// // //   bool _isImageGenerationMode = false;

// // //   // TTS
// // //   final FlutterTts _flutterTts = FlutterTts();

// // //   static final String? openAiKey = dotenv.env['OPEN_AI_KEY'];

// // //   bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _initTts();
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       if (mounted) {
// // //         setState(() {});
// // //         _speakGreeting();
// // //       }
// // //     });
// // //   }

// // //   Future<void> _initTts() async {
// // //     await _flutterTts.setLanguage("en-US");
// // //     await _flutterTts.setSpeechRate(0.45);
// // //     await _flutterTts.setVolume(1.0);
// // //     await _flutterTts.setPitch(1.0);

// // //     final voices = await _flutterTts.getVoices;
// // //     if (voices != null) {
// // //       final voiceList = List<Map>.from(voices);
// // //       final preferred = voiceList.firstWhere(
// // //         (v) =>
// // //             (v['name']?.toString().toLowerCase().contains('female') == true ||
// // //                 v['name']?.toString().toLowerCase().contains('samantha') ==
// // //                     true ||
// // //                 v['name']?.toString().toLowerCase().contains('karen') ==
// // //                     true) &&
// // //             v['locale']?.toString().startsWith('en') == true,
// // //         orElse: () => {},
// // //       );
// // //       if (preferred.isNotEmpty && preferred['name'] != null) {
// // //         await _flutterTts.setVoice({
// // //           "name": preferred['name'],
// // //           "locale": preferred['locale'] ?? "en-US",
// // //         });
// // //       }
// // //     }
// // //   }

// // //   String _getTimeGreeting() {
// // //     final hour = DateTime.now().hour;
// // //     if (hour >= 5 && hour < 12) {
// // //       return "Good morning";
// // //     } else if (hour >= 12 && hour < 17) {
// // //       return "Good afternoon";
// // //     } else if (hour >= 17 && hour < 21) {
// // //       return "Good evening";
// // //     } else {
// // //       return "Good night";
// // //     }
// // //   }

// // //   // Future<void> _speakGreeting() async {
// // //   //   final greeting = _getTimeGreeting();
// // //   //   final text = "$greeting! I am Chicha AI. How can I help you today?";
// // //   //   await _flutterTts.speak(text);
// // //   // }


// // //     //// This is the new code for showing the message///

// // //     Future<void> _speakGreeting() async {
// // //     final greeting = _getTimeGreeting();
// // //     final text = "Hello Welcome back! I am Chicha AI. How can I help you today?";
// // //     await _flutterTts.speak(text);
// // //   }

// // //   Future<void> _pickLogo() async {
// // //     final picker = ImagePicker();
// // //     final file = await picker.pickImage(source: ImageSource.gallery);
// // //     if (file != null) {
// // //       setState(() {
// // //         _logoFile = File(file.path);
// // //       });
// // //       _showSnackbar('Logo selected successfully!');
// // //     }
// // //   }

// // //   void _toggleImageGenerationMode() {
// // //     setState(() {
// // //       _isImageGenerationMode = !_isImageGenerationMode;
// // //       _logoFile = null;
// // //       _messageController.clear();
// // //     });
// // //   }

// // //   Future<void> _sendMessage() async {
// // //     final userMessage = _messageController.text.trim();
// // //     if (userMessage.isEmpty) return;

// // //     if (_isImageGenerationMode) {
// // //       await _generatePosterWithAI(userMessage);
// // //     } else {
// // //       await _sendChatMessage(userMessage);
// // //     }
// // //   }

// // //   Future<void> _sendChatMessage(String userMessage) async {
// // //     setState(() {
// // //       _messages.add({'role': 'user', 'text': userMessage, 'type': 'text'});
// // //       _isLoading = true;
// // //       _messageController.clear();
// // //     });

// // //     _scrollToBottom();

// // //     try {
// // //       final now = DateTime.now();
// // //       final today =
// // //           "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

// // //       final List<Map<String, dynamic>> contents = [
// // //         {
// // //           "role": "user",
// // //           "parts": [
// // //             {
// // //               "text":
// // //                   "You are Chicha AI. Today's date is $today. If the user asks about the current date/time, always answer using this date. Acknowledge this with OK.",
// // //             },
// // //           ],
// // //         },
// // //         {
// // //           "role": "model",
// // //           "parts": [
// // //             {"text": "OK"},
// // //           ],
// // //         },
// // //         ..._messages.where((msg) => msg['type'] == 'text').map((msg) {
// // //           return {
// // //             "role": msg['role'] == 'user' ? 'user' : 'model',
// // //             "parts": [
// // //               {"text": msg['text'] ?? ''},
// // //             ],
// // //           };
// // //         }).toList(),
// // //       ];

// // //       final response = await http.post(
// // //         Uri.parse(
// // //           'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${dotenv.env['OPEN_AI_KEY']}',
// // //         ),
// // //         headers: {"Content-Type": "application/json"},
// // //         body: jsonEncode({
// // //           "contents": contents,
// // //           "generationConfig": {"temperature": 0.7, "maxOutputTokens": 1000},
// // //         }),
// // //       );

// // //       if (response.statusCode == 200) {
// // //         final data = jsonDecode(response.body);
// // //         final botReply =
// // //             data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

// // //         setState(() {
// // //           _messages.add({'role': 'bot', 'text': botReply, 'type': 'text'});
// // //         });
// // //       } else {
// // //         debugPrint(
// // //           'Gemini Chat Error: ${response.statusCode} - ${response.body}',
// // //         );
// // //         setState(() {
// // //           _messages.add({
// // //             'role': 'bot',
// // //             'text':
// // //                 'Sorry, I encountered an error (${response.statusCode}). Please try again.',
// // //             'type': 'text',
// // //           });
// // //         });
// // //       }
// // //     } catch (e) {
// // //       debugPrint('Error sending message: $e');
// // //       setState(() {
// // //         _messages.add({
// // //           'role': 'bot',
// // //           'text': 'Connection issue. Please check your internet and try again.',
// // //           'type': 'text',
// // //         });
// // //       });
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() => _isLoading = false);
// // //         _scrollToBottom();
// // //       }
// // //     }
// // //   }

// // //   Future<void> _generatePosterWithAI(String userPrompt) async {
// // //     debugPrint('================= GEMINI POSTER FLOW START =================');

// // //     setState(() {
// // //       _messages.add({'role': 'user', 'text': userPrompt, 'type': 'text'});
// // //       _isLoading = true;
// // //       _messageController.clear();
// // //     });

// // //     _scrollToBottom();

// // //     try {
// // //       // STEP 1: ENHANCE PROMPT via Gemini Chat
// // //       debugPrint('[STEP 1] Enhancing prompt with Gemini');

// // //       final enhanceResponse = await http.post(
// // //         Uri.parse(
// // //           'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${dotenv.env['OPEN_AI_KEY']}',
// // //         ),
// // //         headers: {"Content-Type": "application/json"},
// // //         body: jsonEncode({
// // //           "contents": [
// // //             {
// // //               "role": "user",
// // //               "parts": [
// // //                 {
// // //                   "text":
// // //                       "You are a professional prompt engineer. Convert the user's simple request into a detailed, vivid image generation prompt. Include colors, style, composition, lighting, and specific visual details. Keep it under 150 words. Only return the enhanced prompt, nothing else.\n\nUser request: $userPrompt",
// // //                 },
// // //               ],
// // //             },
// // //           ],
// // //           "generationConfig": {"temperature": 0.7, "maxOutputTokens": 300},
// // //         }),
// // //       );

// // //       debugPrint('[STEP 1] Status: ${enhanceResponse.statusCode}');

// // //       if (enhanceResponse.statusCode != 200) {
// // //         throw Exception('Prompt enhancement failed: ${enhanceResponse.body}');
// // //       }

// // //       final enhanceJson = jsonDecode(enhanceResponse.body);
// // //       final enhancedPrompt =
// // //           enhanceJson['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
// // //           '';

// // //       if (enhancedPrompt.isEmpty) {
// // //         throw Exception('Enhanced prompt is empty');
// // //       }

// // //       debugPrint('[STEP 1] Enhanced: $enhancedPrompt');

// // //       setState(() {
// // //         _messages.add({
// // //           'role': 'bot',
// // //           'text': '✨ Enhanced prompt:\n\n$enhancedPrompt',
// // //           'type': 'text',
// // //         });
// // //       });

// // //       _scrollToBottom();

// // //       // STEP 2: SHOW LOADING PLACEHOLDER
// // //       setState(() {
// // //         _messages.add({
// // //           'role': 'bot',
// // //           'text': 'Generating image...',
// // //           'type': 'loading',
// // //         });
// // //       });

// // //       _scrollToBottom();

// // //       // STEP 3: IMAGE GENERATION via Gemini imagen model
// // //       debugPrint('[STEP 3] Generating image with Gemini imagen');

// // //       final String finalPrompt = _logoFile != null
// // //           ? '''Create a professional poster. Place the company logo prominently at the top center. $enhancedPrompt'''
// // //           : enhancedPrompt;

// // //       final List<Map<String, dynamic>> imageParts = [];

// // //       if (_logoFile != null) {
// // //         final logoBytes = await _logoFile!.readAsBytes();
// // //         final logoBase64 = base64Encode(logoBytes);
// // //         final ext = _logoFile!.path.split('.').last.toLowerCase();
// // //         final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

// // //         imageParts.add({
// // //           "inlineData": {"mimeType": mimeType, "data": logoBase64},
// // //         });
// // //       }

// // //       imageParts.add({"text": finalPrompt});

// // //       final imageResponse = await http.post(
// // //         Uri.parse(
// // //           'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=${dotenv.env['GEMINI_API_KEY']}',
// // //         ),
// // //         headers: {"Content-Type": "application/json"},
// // //         body: jsonEncode({
// // //           "contents": [
// // //             {"role": "user", "parts": imageParts},
// // //           ],
// // //           "generationConfig": {
// // //             "responseModalities": ["TEXT", "IMAGE"],
// // //           },
// // //         }),
// // //       );

// // //       debugPrint('[STEP 3] Status: ${imageResponse.statusCode}');

// // //       if (imageResponse.statusCode != 200) {
// // //         throw Exception('Image generation failed: ${imageResponse.body}');
// // //       }

// // //       final imageJson = jsonDecode(imageResponse.body);
// // //       final parts =
// // //           imageJson['candidates']?[0]?['content']?['parts'] as List<dynamic>?;

// // //       if (parts == null || parts.isEmpty) {
// // //         throw Exception('No content returned from Gemini image generation');
// // //       }

// // //       String? base64Image;
// // //       for (final part in parts) {
// // //         if (part['inlineData'] != null) {
// // //           base64Image = part['inlineData']['data'];
// // //           break;
// // //         }
// // //       }

// // //       if (base64Image == null) {
// // //         throw Exception('No image data found in Gemini response');
// // //       }

// // //       final imageBytes = base64Decode(base64Image);

// // //       setState(() {
// // //         _messages.removeLast();
// // //         _messages.add({'role': 'bot', 'type': 'image', 'image': imageBytes});
// // //       });

// // //       debugPrint(
// // //         '================= GEMINI POSTER FLOW SUCCESS =================',
// // //       );
// // //     } catch (e, stack) {
// // //       debugPrint('❌ ERROR: $e');
// // //       debugPrint('STACK: $stack');

// // //       setState(() {
// // //         if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
// // //           _messages.removeLast();
// // //         }
// // //         _messages.add({
// // //           'role': 'bot',
// // //           'text': 'Failed to generate poster.\n$e',
// // //           'type': 'text',
// // //         });
// // //       });
// // //     } finally {
// // //       if (mounted) {
// // //         setState(() => _isLoading = false);
// // //         _scrollToBottom();
// // //       }
// // //     }
// // //   }

// // //   Future<void> _downloadImage(Uint8List imageBytes) async {
// // //     try {
// // //       final tempDir = await getTemporaryDirectory();
// // //       final tempFile = File(
// // //         '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
// // //       );
// // //       await tempFile.writeAsBytes(imageBytes);
// // //       await Gal.putImage(tempFile.path);
// // //       await tempFile.delete();
// // //       _showSnackbar('Image saved to gallery!');
// // //     } catch (e) {
// // //       debugPrint('Error saving image: $e');
// // //       _showSnackbar('Error saving image: $e');
// // //     }
// // //   }

// // //   Future<void> _shareImage(Uint8List imageBytes) async {
// // //     try {
// // //       final tempDir = await getTemporaryDirectory();
// // //       final file = await File(
// // //         '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
// // //       ).create();
// // //       await file.writeAsBytes(imageBytes);
// // //       await Share.shareXFiles([
// // //         XFile(file.path),
// // //       ], text: 'Check out this poster created with Chicha AI!');
// // //     } catch (e) {
// // //       debugPrint('Error sharing image: $e');
// // //       _showSnackbar('Error sharing image: $e');
// // //     }
// // //   }

// // //   void _scrollToBottom() {
// // //     if (_scrollController.hasClients) {
// // //       Future.delayed(const Duration(milliseconds: 100), () {
// // //         if (_scrollController.hasClients) {
// // //           _scrollController.animateTo(
// // //             _scrollController.position.maxScrollExtent,
// // //             duration: const Duration(milliseconds: 300),
// // //             curve: Curves.easeOut,
// // //           );
// // //         }
// // //       });
// // //     }
// // //   }

// // //   void _showSnackbar(String message) {
// // //     final isDarkMode = _isDarkMode;
// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: Text(
// // //           message,
// // //           style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
// // //         ),
// // //         backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// // //         behavior: SnackBarBehavior.floating,
// // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // //         margin: const EdgeInsets.all(16),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildMessage(Map<String, dynamic> message) {
// // //     final isDarkMode = _isDarkMode;

// // //     if (message['type'] == 'loading') {
// // //       return Padding(
// // //         padding: const EdgeInsets.only(bottom: 16),
// // //         child: Row(
// // //           mainAxisAlignment: MainAxisAlignment.start,
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Container(
// // //               width: 36,
// // //               height: 36,
// // //               decoration: BoxDecoration(
// // //                 gradient: const LinearGradient(
// // //                   colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// // //                   begin: Alignment.topLeft,
// // //                   end: Alignment.bottomRight,
// // //                 ),
// // //                 borderRadius: BorderRadius.circular(12),
// // //               ),
// // //               child: const Icon(
// // //                 Icons.auto_awesome,
// // //                 color: Colors.black87,
// // //                 size: 20,
// // //               ),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             Container(
// // //               width: 300,
// // //               height: 300,
// // //               decoration: BoxDecoration(
// // //                 color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// // //                 borderRadius: BorderRadius.circular(20),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
// // //                     blurRadius: 12,
// // //                     offset: const Offset(0, 4),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: Center(
// // //                 child: Column(
// // //                   mainAxisAlignment: MainAxisAlignment.center,
// // //                   children: [
// // //                     CircularProgressIndicator(color: const Color(0xFFF5C518)),
// // //                     const SizedBox(height: 16),
// // //                     Text(
// // //                       'Generating your image...',
// // //                       style: TextStyle(
// // //                         fontSize: 14,
// // //                         color: const Color(0xFFF5C518),
// // //                         fontWeight: FontWeight.w500,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //     }

// // //     if (message['type'] == 'image') {
// // //       return Padding(
// // //         padding: const EdgeInsets.only(bottom: 16),
// // //         child: Row(
// // //           mainAxisAlignment: MainAxisAlignment.start,
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Container(
// // //               width: 36,
// // //               height: 36,
// // //               decoration: BoxDecoration(
// // //                 gradient: const LinearGradient(
// // //                   colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// // //                   begin: Alignment.topLeft,
// // //                   end: Alignment.bottomRight,
// // //                 ),
// // //                 borderRadius: BorderRadius.circular(12),
// // //               ),
// // //               child: const Icon(
// // //                 Icons.auto_awesome,
// // //                 color: Colors.black87,
// // //                 size: 20,
// // //               ),
// // //             ),
// // //             const SizedBox(width: 12),
// // //             Flexible(
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   Container(
// // //                     decoration: BoxDecoration(
// // //                       color: isDarkMode
// // //                           ? const Color(0xFF1E293B)
// // //                           : Colors.white,
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.black.withOpacity(
// // //                             isDarkMode ? 0.3 : 0.08,
// // //                           ),
// // //                           blurRadius: 12,
// // //                           offset: const Offset(0, 4),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: ClipRRect(
// // //                       borderRadius: BorderRadius.circular(20),
// // //                       child: Image.memory(
// // //                         message['image'] as Uint8List,
// // //                         fit: BoxFit.cover,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 8),
// // //                   Row(
// // //                     children: [
// // //                       TextButton.icon(
// // //                         onPressed: () =>
// // //                             _downloadImage(message['image'] as Uint8List),
// // //                         icon: const Icon(Icons.download, size: 18),
// // //                         label: const Text('Download'),
// // //                         style: TextButton.styleFrom(
// // //                           foregroundColor: const Color(0xFFF5C518),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 8),
// // //                       TextButton.icon(
// // //                         onPressed: () =>
// // //                             _shareImage(message['image'] as Uint8List),
// // //                         icon: const Icon(Icons.share, size: 18),
// // //                         label: const Text('Share'),
// // //                         style: TextButton.styleFrom(
// // //                           foregroundColor: const Color(0xFFF5C518),
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //     }

// // //     final isUser = message['role'] == 'user';
// // //     return Padding(
// // //       padding: const EdgeInsets.only(bottom: 16),
// // //       child: Row(
// // //         mainAxisAlignment: isUser
// // //             ? MainAxisAlignment.end
// // //             : MainAxisAlignment.start,
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           if (!isUser) ...[
// // //             Container(
// // //               width: 36,
// // //               height: 36,
// // //               decoration: BoxDecoration(
// // //                 gradient: const LinearGradient(
// // //                   colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// // //                   begin: Alignment.topLeft,
// // //                   end: Alignment.bottomRight,
// // //                 ),
// // //                 borderRadius: BorderRadius.circular(12),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: const Color(0xFFF5C518).withOpacity(0.3),
// // //                     blurRadius: 8,
// // //                     offset: const Offset(0, 2),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: const Icon(
// // //                 Icons.auto_awesome,
// // //                 color: Colors.black87,
// // //                 size: 20,
// // //               ),
// // //             ),
// // //             const SizedBox(width: 12),
// // //           ],
// // //           Flexible(
// // //             child: Container(
// // //               padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
// // //               decoration: BoxDecoration(
// // //                 gradient: isUser
// // //                     ? const LinearGradient(
// // //                         colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// // //                         begin: Alignment.topLeft,
// // //                         end: Alignment.bottomRight,
// // //                       )
// // //                     : null,
// // //                 color: isUser
// // //                     ? null
// // //                     : (isDarkMode ? const Color(0xFF1E293B) : Colors.white),
// // //                 borderRadius: BorderRadius.only(
// // //                   topLeft: const Radius.circular(20),
// // //                   topRight: const Radius.circular(20),
// // //                   bottomLeft: Radius.circular(isUser ? 20 : 4),
// // //                   bottomRight: Radius.circular(isUser ? 4 : 20),
// // //                 ),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: isUser
// // //                         ? const Color(0xFFF5C518).withOpacity(0.3)
// // //                         : Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
// // //                     blurRadius: 12,
// // //                     offset: const Offset(0, 4),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: Text(
// // //                 message['text'] ?? '',
// // //                 style: TextStyle(
// // //                   color: isUser
// // //                       ? Colors.black87
// // //                       : (isDarkMode ? Colors.white : const Color(0xFF2D3748)),
// // //                   fontSize: 15,
// // //                   height: 1.5,
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //           if (isUser) ...[
// // //             const SizedBox(width: 12),
// // //             Container(
// // //               width: 36,
// // //               height: 36,
// // //               decoration: BoxDecoration(
// // //                 gradient: const LinearGradient(
// // //                   colors: [Color(0xFF4FD1C5), Color(0xFF3182CE)],
// // //                   begin: Alignment.topLeft,
// // //                   end: Alignment.bottomRight,
// // //                 ),
// // //                 borderRadius: BorderRadius.circular(12),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: const Color(0xFF4FD1C5).withOpacity(0.3),
// // //                     blurRadius: 8,
// // //                     offset: const Offset(0, 2),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: const Icon(
// // //                 Icons.person_outline,
// // //                 color: Colors.white,
// // //                 size: 20,
// // //               ),
// // //             ),
// // //           ],
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildEmptyState() {
// // //     final isDarkMode = _isDarkMode;

// // //     return Center(
// // //       child: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(32),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Container(
// // //               padding: const EdgeInsets.all(24),
// // //               decoration: BoxDecoration(
// // //                 gradient: const LinearGradient(
// // //                   colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// // //                   begin: Alignment.topLeft,
// // //                   end: Alignment.bottomRight,
// // //                 ),
// // //                 borderRadius: BorderRadius.circular(24),
// // //                 boxShadow: [
// // //                   BoxShadow(
// // //                     color: const Color(0xFFF5C518).withOpacity(0.3),
// // //                     blurRadius: 20,
// // //                     offset: const Offset(0, 10),
// // //                   ),
// // //                 ],
// // //               ),
// // //               child: const Icon(
// // //                 Icons.auto_awesome,
// // //                 size: 48,
// // //                 color: Colors.black87,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 32),
// // //             AppText(
// // //               _isImageGenerationMode
// // //                   ? 'Create Amazing Posters'
// // //                   : 'chat_with_chicha',
// // //               style: TextStyle(
// // //                 fontSize: 20,
// // //                 fontWeight: FontWeight.w600,
// // //                 color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
// // //               ),
// // //               textAlign: TextAlign.center,
// // //             ),
// // //             const SizedBox(height: 16),
// // //             AppText(
// // //               _isImageGenerationMode
// // //                   ? 'Describe your poster and let AI create it'
// // //                   : 'ask_me_anything',
// // //               style: TextStyle(
// // //                 fontSize: 14,
// // //                 color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
// // //               ),
// // //               textAlign: TextAlign.center,
// // //             ),
// // //             const SizedBox(height: 12),
// // //             Text(
// // //               '${_getTimeGreeting()}! 👋',
// // //               style: const TextStyle(
// // //                 fontSize: 16,
// // //                 color: Color(0xFFF5C518),
// // //                 fontWeight: FontWeight.w500,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final isDarkMode = _isDarkMode;

// // //     return SafeArea(
// // //       child: Scaffold(
// // //         backgroundColor: isDarkMode
// // //             ? const Color(0xFF0F172A)
// // //             : const Color(0xFFF7FAFC),
// // //         appBar: AppBar(
// // //           leading: IconButton(
// // //             onPressed: () => Navigator.of(context).pop(),
// // //             icon: const Icon(Icons.arrow_back_ios_new, size: 20),
// // //             color: Colors.white,
// // //           ),
// // //           title: Row(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               Container(
// // //                 padding: const EdgeInsets.all(8),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.white.withOpacity(0.2),
// // //                   borderRadius: BorderRadius.circular(10),
// // //                 ),
// // //                 child: Icon(
// // //                   _isImageGenerationMode ? Icons.image : Icons.auto_awesome,
// // //                   size: 18,
// // //                   color: Colors.white,
// // //                 ),
// // //               ),
// // //               const SizedBox(width: 12),
// // //               AppText(
// // //                 _isImageGenerationMode
// // //                     ? 'Post with Chicha'
// // //                     : 'chat_with_chicha',
// // //                 style: const TextStyle(
// // //                   fontWeight: FontWeight.w600,
// // //                   fontSize: 15,
// // //                   color: Colors.white,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           centerTitle: true,
// // //           flexibleSpace: Container(
// // //             decoration: const BoxDecoration(
// // //               gradient: LinearGradient(
// // //                 colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// // //                 begin: Alignment.topLeft,
// // //                 end: Alignment.bottomRight,
// // //               ),
// // //             ),
// // //           ),
// // //           foregroundColor: Colors.white,
// // //           elevation: 0,
// // //           actions: [
// // //             IconButton(
// // //               onPressed: _speakGreeting,
// // //               icon: const Icon(Icons.volume_up_rounded, size: 22),
// // //               color: Colors.white,
// // //               tooltip: 'Replay greeting',
// // //             ),
// // //             InkWell(
// // //               onTap: _toggleImageGenerationMode,
// // //               borderRadius: BorderRadius.circular(12),
// // //               child: Padding(
// // //                 padding: const EdgeInsets.symmetric(
// // //                   horizontal: 12,
// // //                   vertical: 6,
// // //                 ),
// // //                 child: Column(
// // //                   mainAxisSize: MainAxisSize.min,
// // //                   children: [
// // //                     Icon(
// // //                       _isImageGenerationMode ? Icons.chat : Icons.image,
// // //                       size: 22,
// // //                       color: Colors.white,
// // //                     ),
// // //                     const SizedBox(height: 2),
// // //                     AppText(
// // //                       _isImageGenerationMode ? 'Chat' : 'poster',
// // //                       style: const TextStyle(
// // //                         fontSize: 11,
// // //                         color: Colors.white,
// // //                         fontWeight: FontWeight.w500,
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //         body: Column(
// // //           children: [
// // //             if (_isImageGenerationMode && _logoFile != null)
// // //               Container(
// // //                 margin: const EdgeInsets.all(16),
// // //                 padding: const EdgeInsets.all(12),
// // //                 decoration: BoxDecoration(
// // //                   color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// // //                   borderRadius: BorderRadius.circular(12),
// // //                   boxShadow: [
// // //                     BoxShadow(
// // //                       color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
// // //                       blurRadius: 8,
// // //                       offset: const Offset(0, 2),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 child: Row(
// // //                   children: [
// // //                     ClipRRect(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                       child: Image.file(
// // //                         _logoFile!,
// // //                         width: 60,
// // //                         height: 60,
// // //                         fit: BoxFit.cover,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 12),
// // //                     Expanded(
// // //                       child: Text(
// // //                         'Logo selected',
// // //                         style: TextStyle(
// // //                           fontSize: 14,
// // //                           fontWeight: FontWeight.w500,
// // //                           color: isDarkMode
// // //                               ? Colors.white
// // //                               : const Color(0xFF2D3748),
// // //                         ),
// // //                       ),
// // //                     ),
// // //                     IconButton(
// // //                       icon: const Icon(Icons.close, size: 20),
// // //                       onPressed: () => setState(() => _logoFile = null),
// // //                       color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             Expanded(
// // //               child: _messages.isEmpty
// // //                   ? _buildEmptyState()
// // //                   : ListView.builder(
// // //                       controller: _scrollController,
// // //                       padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
// // //                       itemCount: _messages.length,
// // //                       itemBuilder: (context, index) {
// // //                         return _buildMessage(_messages[index]);
// // //                       },
// // //                     ),
// // //             ),
// // //           ],
// // //         ),
// // //         bottomSheet: Container(
// // //           decoration: BoxDecoration(
// // //             color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// // //             boxShadow: [
// // //               BoxShadow(
// // //                 color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
// // //                 blurRadius: 20,
// // //                 offset: const Offset(0, -4),
// // //               ),
// // //             ],
// // //           ),
// // //           child: Column(
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               if (_isLoading)
// // //                 Container(
// // //                   padding: const EdgeInsets.symmetric(vertical: 16),
// // //                   child: Row(
// // //                     mainAxisAlignment: MainAxisAlignment.center,
// // //                     children: [
// // //                       const SizedBox(
// // //                         width: 20,
// // //                         height: 20,
// // //                         child: CircularProgressIndicator(
// // //                           strokeWidth: 2.5,
// // //                           valueColor: AlwaysStoppedAnimation<Color>(
// // //                             Color(0xFFF5C518),
// // //                           ),
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 12),
// // //                       Text(
// // //                         _isImageGenerationMode
// // //                             ? 'Creating magic...'
// // //                             : 'AI analyzing',
// // //                         style: TextStyle(
// // //                           color: isDarkMode
// // //                               ? Colors.grey[400]
// // //                               : Colors.grey[700],
// // //                           fontSize: 14,
// // //                           fontWeight: FontWeight.w500,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               SafeArea(
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.all(16),
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                     children: [
// // //                       if (_isImageGenerationMode) ...[
// // //                         const SizedBox(height: 12),
// // //                       ],
// // //                       Row(
// // //                         children: [
// // //                           Expanded(
// // //                             child: Container(
// // //                               decoration: BoxDecoration(
// // //                                 color: isDarkMode
// // //                                     ? const Color(0xFF0F172A)
// // //                                     : const Color(0xFFF7FAFC),
// // //                                 borderRadius: BorderRadius.circular(24),
// // //                                 border: Border.all(
// // //                                   color: isDarkMode
// // //                                       ? const Color(0xFF334155)
// // //                                       : Colors.grey[200]!,
// // //                                 ),
// // //                               ),
// // //                               child: TextField(
// // //                                 controller: _messageController,
// // //                                 textInputAction: TextInputAction.send,
// // //                                 onSubmitted: (_) => _sendMessage(),
// // //                                 style: TextStyle(
// // //                                   fontSize: 15,
// // //                                   color: isDarkMode
// // //                                       ? Colors.white
// // //                                       : const Color(0xFF2D3748),
// // //                                 ),
// // //                                 decoration: InputDecoration(
// // //                                   hintText: _isImageGenerationMode
// // //                                       ? AppText.translate(
// // //                                           context,
// // //                                           'describe_poster',
// // //                                         )
// // //                                       : AppText.translate(
// // //                                           context,
// // //                                           'ask_me_anything',
// // //                                         ),
// // //                                   border: InputBorder.none,
// // //                                   contentPadding: const EdgeInsets.symmetric(
// // //                                     horizontal: 20,
// // //                                     vertical: 14,
// // //                                   ),
// // //                                   hintStyle: TextStyle(
// // //                                     color: isDarkMode
// // //                                         ? Colors.grey[500]
// // //                                         : Colors.grey[500],
// // //                                     fontSize: 15,
// // //                                   ),
// // //                                 ),
// // //                                 minLines: 1,
// // //                                 maxLines: 4,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 12),
// // //                           Container(
// // //                             decoration: BoxDecoration(
// // //                               gradient: const LinearGradient(
// // //                                 colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// // //                                 begin: Alignment.topLeft,
// // //                                 end: Alignment.bottomRight,
// // //                               ),
// // //                               shape: BoxShape.circle,
// // //                               boxShadow: [
// // //                                 BoxShadow(
// // //                                   color: const Color(
// // //                                     0xFFF5C518,
// // //                                   ).withOpacity(0.4),
// // //                                   blurRadius: 12,
// // //                                   offset: const Offset(0, 4),
// // //                                 ),
// // //                               ],
// // //                             ),
// // //                             child: IconButton(
// // //                               onPressed: _isLoading ? null : _sendMessage,
// // //                               icon: Icon(
// // //                                 _isImageGenerationMode
// // //                                     ? Icons.auto_awesome
// // //                                     : Icons.send_rounded,
// // //                                 size: 22,
// // //                               ),
// // //                               color: Colors.black87,
// // //                               splashRadius: 24,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //         floatingActionButton: _isImageGenerationMode
// // //             ? FloatingActionButton(
// // //                 onPressed: _pickLogo,
// // //                 backgroundColor: const Color(0xFFF5C518),
// // //                 foregroundColor: Colors.black87,
// // //                 elevation: 6,
// // //                 tooltip: _logoFile == null ? 'Add Logo' : 'Change Logo',
// // //                 child: Icon(
// // //                   _logoFile == null ? Icons.add_photo_alternate : Icons.edit,
// // //                   size: 26,
// // //                 ),
// // //               )
// // //             : null,
// // //       ),
// // //     );
// // //   }

// // //   void dispose() {
// // //     _flutterTts.stop();
// // //     _messageController.dispose();
// // //     _scrollController.dispose();
// // //     super.dispose();
// // //   }
// // // }


















// // import 'dart:convert';
// // import 'dart:io';
// // import 'dart:math';
// // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:image_picker/image_picker.dart';
// // import 'package:gal/gal.dart';
// // import 'package:posternova/widgets/language_widget.dart';
// // import 'package:share_plus/share_plus.dart';
// // import 'package:path_provider/path_provider.dart';

// // class AiScreen extends StatefulWidget {
// //   const AiScreen({super.key});

// //   @override
// //   State<AiScreen> createState() => _AiScreenState();
// // }

// // class _AiScreenState extends State<AiScreen> {
// //   final TextEditingController _messageController = TextEditingController();
// //   final List<Map<String, dynamic>> _messages = [];
// //   bool _isLoading = false;
// //   final ScrollController _scrollController = ScrollController();

// //   File? _logoFile;
// //   bool _isImageGenerationMode = false;

// //   // TTS
// //   final FlutterTts _flutterTts = FlutterTts();

// //   // Use a single unified key for all Gemini calls
// //   static String get _geminiKey =>
// //       dotenv.env['GEMINI_API_KEY'] ?? dotenv.env['OPEN_AI_KEY'] ?? '';

// //   bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initTts();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (mounted) {
// //         setState(() {});
// //         _speakGreeting();
// //       }
// //     });
// //   }

// //   // ─── Retry helper ────────────────────────────────────────────────────────────
// //   /// POST with automatic retry on 429 (rate-limit) using exponential back-off.
// //   Future<http.Response> _postWithRetry(
// //     Uri url,
// //     Map<String, String> headers,
// //     String body, {
// //     int maxRetries = 3,
// //   }) async {
// //     int attempt = 0;
// //     while (true) {
// //       final response = await http.post(url, headers: headers, body: body);

// //       if (response.statusCode != 429 || attempt >= maxRetries) {
// //         return response;
// //       }

// //       attempt++;
// //       final delaySec = pow(2, attempt).toInt(); // 2 → 4 → 8 seconds
// //       debugPrint(
// //         '[Retry] 429 rate-limited. Waiting ${delaySec}s before attempt $attempt/$maxRetries...',
// //       );

// //       // Show a non-intrusive snackbar so the user knows we're retrying
// //       if (mounted) {
// //         // ScaffoldMessenger.of(context).showSnackBar(
// //         //   SnackBar(
// //         //     content: Text('Rate limited. Retrying in ${delaySec}s… (attempt $attempt)',style: TextStyle(color: Colors.black),),
// //         //     duration: Duration(seconds: delaySec),
// //         //     behavior: SnackBarBehavior.floating,
// //         //     backgroundColor:
// //         //         _isDarkMode ? const Color(0xFF1E293B) : const Color.fromARGB(255, 211, 26, 26),
// //         //     shape:
// //         //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //         //     margin: const EdgeInsets.all(16),
// //         //   ),
// //         // );
// //       }

// //       await Future.delayed(Duration(seconds: delaySec));
// //     }
// //   }

// //   // ─── TTS ─────────────────────────────────────────────────────────────────────
// //   Future<void> _initTts() async {
// //     await _flutterTts.setLanguage("en-US");
// //     await _flutterTts.setSpeechRate(0.45);
// //     await _flutterTts.setVolume(1.0);
// //     await _flutterTts.setPitch(1.0);

// //     final voices = await _flutterTts.getVoices;
// //     if (voices != null) {
// //       final voiceList = List<Map>.from(voices);
// //       final preferred = voiceList.firstWhere(
// //         (v) =>
// //             (v['name']?.toString().toLowerCase().contains('female') == true ||
// //                 v['name']?.toString().toLowerCase().contains('samantha') ==
// //                     true ||
// //                 v['name']?.toString().toLowerCase().contains('karen') ==
// //                     true) &&
// //             v['locale']?.toString().startsWith('en') == true,
// //         orElse: () => {},
// //       );
// //       if (preferred.isNotEmpty && preferred['name'] != null) {
// //         await _flutterTts.setVoice({
// //           "name": preferred['name'],
// //           "locale": preferred['locale'] ?? "en-US",
// //         });
// //       }
// //     }
// //   }






// //   // Show exit confirmation dialog
// // Future<bool> _onWillPop() async {
// //   return await showDialog(
// //     context: context,
// //     barrierDismissible: false,
// //     builder: (BuildContext context) {
// //       return Dialog(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         child: Container(
// //           padding: const EdgeInsets.all(24),
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(28),
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: Theme.of(context).brightness == Brightness.dark
// //                   ? [const Color(0xFF1A1A24), const Color(0xFF0A0A0F)]
// //                   : [Colors.white, const Color(0xFFF7FAFC)],
// //             ),
// //             border: Border.all(
// //               color: Theme.of(context).brightness == Brightness.dark
// //                   ? Colors.white.withOpacity(0.1)
// //                   : Colors.black.withOpacity(0.1),
// //               width: 1.5,
// //             ),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Colors.black.withOpacity(0.5),
// //                 blurRadius: 30,
// //                 spreadRadius: 5,
// //                 offset: const Offset(0, 10),
// //               ),
// //             ],
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               // Icon
// //               Container(
// //                 padding: const EdgeInsets.all(16),
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   gradient: const LinearGradient(
// //                     colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// //                   ),
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: const Color(0xFFF5C518).withOpacity(0.3),
// //                       blurRadius: 12,
// //                       spreadRadius: 2,
// //                     ),
// //                   ],
// //                 ),
// //                 child: const Icon(
// //                   Icons.exit_to_app_rounded,
// //                   color: Colors.black87,
// //                   size: 32,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
              
// //               // Title
// //               const Text(
// //                 'Exit App?',
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 22,
// //                   fontWeight: FontWeight.bold,
// //                   letterSpacing: -0.5,
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
              
// //               // Message
// //               Text(
// //                 'Are you sure you want to exit the app?',
// //                 textAlign: TextAlign.center,
// //                 style: TextStyle(
// //                   color: Theme.of(context).brightness == Brightness.dark
// //                       ? Colors.white.withOpacity(0.6)
// //                       : Colors.black.withOpacity(0.6),
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w500,
// //                   height: 1.4,
// //                 ),
// //               ),
// //               const SizedBox(height: 28),
              
// //               // Buttons
// //               Row(
// //                 children: [
// //                   // Cancel button
// //                   Expanded(
// //                     child: GestureDetector(
// //                       onTap: () {
// //                         Navigator.of(context).pop(false);
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(vertical: 12),
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(16),
// //                           border: Border.all(
// //                             color: Theme.of(context).brightness == Brightness.dark
// //                                 ? Colors.white.withOpacity(0.2)
// //                                 : Colors.black.withOpacity(0.2),
// //                             width: 1.5,
// //                           ),
// //                         ),
// //                         child: Text(
// //                           'Cancel',
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(
// //                             color: Theme.of(context).brightness == Brightness.dark
// //                                 ? Colors.white.withOpacity(0.8)
// //                                 : Colors.black.withOpacity(0.8),
// //                             fontWeight: FontWeight.w600,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
                  
// //                   // Exit button
// //                   Expanded(
// //                     child: GestureDetector(
// //                       onTap: () {
// //                         Navigator.of(context).pop(true);
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(vertical: 12),
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(16),
// //                           gradient: const LinearGradient(
// //                             colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// //                           ),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: const Color(0xFFF5C518).withOpacity(0.3),
// //                               blurRadius: 8,
// //                               offset: const Offset(0, 4),
// //                             ),
// //                           ],
// //                         ),
// //                         child: const Text(
// //                           'Exit',
// //                           textAlign: TextAlign.center,
// //                           style: TextStyle(
// //                             color: Colors.black87,
// //                             fontWeight: FontWeight.w700,
// //                             fontSize: 16,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     },
// //   ) ?? false;
// // }

// //   String _getTimeGreeting() {
// //     final hour = DateTime.now().hour;
// //     if (hour >= 5 && hour < 12) return "Good morning";
// //     if (hour >= 12 && hour < 17) return "Good afternoon";
// //     if (hour >= 17 && hour < 21) return "Good evening";
// //     return "Good night";
// //   }

// //   Future<void> _speakGreeting() async {
// //     const text = "Hello Welcome back! I am Chicha AI. How can I help you today?";
// //     await _flutterTts.speak(text);
// //   }

// //   // ─── Image / Logo ─────────────────────────────────────────────────────────────
// //   Future<void> _pickLogo() async {
// //     final picker = ImagePicker();
// //     final file = await picker.pickImage(source: ImageSource.gallery);
// //     if (file != null) {
// //       setState(() => _logoFile = File(file.path));
// //       _showSnackbar('Logo selected successfully!');
// //     }
// //   }

// //   void _toggleImageGenerationMode() {
// //     setState(() {
// //       _isImageGenerationMode = !_isImageGenerationMode;
// //       _logoFile = null;
// //       _messageController.clear();
// //     });
// //   }

// //   // ─── Send ─────────────────────────────────────────────────────────────────────
// //   Future<void> _sendMessage() async {
// //     final userMessage = _messageController.text.trim();
// //     if (userMessage.isEmpty) return;

// //     if (_isImageGenerationMode) {
// //       await _generatePosterWithAI(userMessage);
// //     } else {
// //       await _sendChatMessage(userMessage);
// //     }
// //   }

// //   // ─── Chat ─────────────────────────────────────────────────────────────────────
// //   // Future<void> _sendChatMessage(String userMessage) async {
// //   //   setState(() {
// //   //     _messages.add({'role': 'user', 'text': userMessage, 'type': 'text'});
// //   //     _isLoading = true;
// //   //     _messageController.clear();
// //   //   });
// //   //   _scrollToBottom();

// //   //   try {
// //   //     final now = DateTime.now();
// //   //     final today =
// //   //         "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

// //   //     final List<Map<String, dynamic>> contents = [
// //   //       {
// //   //         "role": "user",
// //   //         "parts": [
// //   //           {
// //   //             "text":
// //   //                 "You are Chicha AI. Today's date is $today. If the user asks about the current date/time, always answer using this date. Acknowledge this with OK.",
// //   //           },
// //   //         ],
// //   //       },
// //   //       {
// //   //         "role": "model",
// //   //         "parts": [
// //   //           {"text": "OK"},
// //   //         ],
// //   //       },
// //   //       ..._messages.where((msg) => msg['type'] == 'text').map((msg) {
// //   //         return {
// //   //           "role": msg['role'] == 'user' ? 'user' : 'model',
// //   //           "parts": [
// //   //             {"text": msg['text'] ?? ''},
// //   //           ],
// //   //         };
// //   //       }),
// //   //     ];

// //   //     final response = await _postWithRetry(
// //   //       Uri.parse(
// //   //         'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_geminiKey',
// //   //       ),
// //   //       {"Content-Type": "application/json"},
// //   //       jsonEncode({
// //   //         "contents": contents,
// //   //         "generationConfig": {"temperature": 0.7, "maxOutputTokens": 1000},
// //   //       }),
// //   //     );

// //   //     if (response.statusCode == 200) {
// //   //       final data = jsonDecode(response.body);
// //   //       final botReply =
// //   //           data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
// //   //       setState(() {
// //   //         _messages.add({'role': 'bot', 'text': botReply, 'type': 'text'});
// //   //       });
// //   //     } else {
// //   //       debugPrint('Gemini Chat Error: ${response.statusCode} - ${response.body}');
// //   //       setState(() {
// //   //         _messages.add({
// //   //           'role': 'bot',
// //   //           'text':
// //   //               'Sorry, I encountered an error (${response.statusCode}). Please try again.',
// //   //           'type': 'text',
// //   //         });
// //   //       });
// //   //     }
// //   //   } catch (e) {
// //   //     debugPrint('Error sending message: $e');
// //   //     setState(() {
// //   //       _messages.add({
// //   //         'role': 'bot',
// //   //         'text': 'Connection issue. Please check your internet and try again.',
// //   //         'type': 'text',
// //   //       });
// //   //     });
// //   //   } finally {
// //   //     if (mounted) {
// //   //       setState(() => _isLoading = false);
// //   //       _scrollToBottom();
// //   //     }
// //   //   }
// //   // }


// // Future<void> _sendChatMessage(String userMessage) async {
// //   setState(() {
// //     _messages.add({'role': 'user', 'text': userMessage, 'type': 'text'});
// //     _isLoading = true;
// //     _messageController.clear();
// //   });
// //   _scrollToBottom();

// //   try {
// //     final now = DateTime.now();
// //     final today =
// //         "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

// //     // ── Detect if user is asking for an image ─────────────────────────────
// //     final imageKeywords = [
// //       'generate image', 'create image', 'show image', 'draw',
// //       'show me a', 'generate a', 'create a', 'make an image',
// //       'picture of', 'photo of', 'image of', 'illustration of',
// //       'make a picture', 'generate me', 'create me',
// //     ];
// //     final isImageRequest = imageKeywords.any(
// //       (kw) => userMessage.toLowerCase().contains(kw),
// //     );

// //     if (isImageRequest) {
// //       // ── IMAGE GENERATION via Pollinations AI (Free, no API key) ─────────
// //       setState(() {
// //         _messages.add({
// //           'role': 'bot',
// //           'text': 'Generating image...',
// //           'type': 'loading',
// //         });
// //       });
// //       _scrollToBottom();

// //       try {
// //         final encodedPrompt = Uri.encodeComponent(userMessage);
// //         final imageUrl =
// //             'https://image.pollinations.ai/prompt/$encodedPrompt?width=512&height=512&nologo=true&enhance=true';

// //         debugPrint('[IMAGE] Fetching from Pollinations: $imageUrl');

// //         final res = await http.get(Uri.parse(imageUrl)).timeout(
// //           const Duration(seconds: 30),
// //         );

// //         debugPrint('[IMAGE] Status: ${res.statusCode}');
// //         debugPrint('[IMAGE] Content-Type: ${res.headers['content-type']}');

// //         setState(() {
// //           if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
// //             _messages.removeLast();
// //           }

// //           if (res.statusCode == 200 &&
// //               res.headers['content-type']?.contains('image') == true) {
// //             // ✅ Success — show image with download/share buttons
// //             _messages.add({
// //               'role': 'bot',
// //               'type': 'image',
// //               'image': res.bodyBytes,
// //             });
// //           } else {
// //             _messages.add({
// //               'role': 'bot',
// //               'text':
// //                   'Sorry, could not generate the image. Please try again with a different description.',
// //               'type': 'text',
// //             });
// //           }
// //         });
// //       } catch (e) {
// //         debugPrint('[IMAGE] Error: $e');
// //         setState(() {
// //           if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
// //             _messages.removeLast();
// //           }
// //           _messages.add({
// //             'role': 'bot',
// //             'text':
// //                 'Image generation timed out. Please check your internet and try again.',
// //             'type': 'text',
// //           });
// //         });
// //       }
// //     } else {
// //       // ── NORMAL CHAT WITH WEB SEARCH ──────────────────────────────────────
// //       final List<Map<String, dynamic>> contents = [
// //         {
// //           "role": "user",
// //           "parts": [
// //             {
// //               "text":
// //                   "You are Chicha AI. Today's date is $today. If the user asks about the current date/time, always answer using this date. Acknowledge this with OK.",
// //             },
// //           ],
// //         },
// //         {
// //           "role": "model",
// //           "parts": [
// //             {"text": "OK"},
// //           ],
// //         },
// //         ..._messages.where((msg) => msg['type'] == 'text').map((msg) {
// //           return {
// //             "role": msg['role'] == 'user' ? 'user' : 'model',
// //             "parts": [
// //               {"text": msg['text'] ?? ''},
// //             ],
// //           };
// //         }),
// //       ];

// //       final response = await _postWithRetry(
// //         Uri.parse(
// //           'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_geminiKey',
// //         ),
// //         {"Content-Type": "application/json"},
// //         jsonEncode({
// //           "contents": contents,
// //           "tools": [
// //             {"google_search": {}} // ← Real-time web search
// //           ],
// //           "generationConfig": {
// //             "temperature": 0.7,
// //             "maxOutputTokens": 1000,
// //           },
// //         }),
// //       );

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         final parts =
// //             data['candidates']?[0]?['content']?['parts'] as List<dynamic>?;

// //         String botReply = '';
// //         if (parts != null) {
// //           for (final part in parts) {
// //             if (part['text'] != null) {
// //               botReply += part['text'];
// //             }
// //           }
// //         }

// //         if (botReply.isEmpty) {
// //           botReply =
// //               'Sorry, I could not generate a response. Please try again.';
// //         }

// //         setState(() {
// //           _messages.add({
// //             'role': 'bot',
// //             'text': botReply,
// //             'type': 'text',
// //           });
// //         });
// //       } else {
// //         debugPrint(
// //           'Gemini Chat Error: ${response.statusCode} - ${response.body}',
// //         );
// //         setState(() {
// //           _messages.add({
// //             'role': 'bot',
// //             'text':
// //                 'Sorry, I encountered an error (${response.statusCode}). Please try again.',
// //             'type': 'text',
// //           });
// //         });
// //       }
// //     }
// //   } catch (e) {
// //     debugPrint('Error sending message: $e');
// //     setState(() {
// //       if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
// //         _messages.removeLast();
// //       }
// //       _messages.add({
// //         'role': 'bot',
// //         'text': 'Connection issue. Please check your internet and try again.',
// //         'type': 'text',
// //       });
// //     });
// //   } finally {
// //     if (mounted) {
// //       setState(() => _isLoading = false);
// //       _scrollToBottom();
// //     }
// //   }
// // }

// //   // ─── Poster generation ────────────────────────────────────────────────────────
// //   Future<void> _generatePosterWithAI(String userPrompt) async {
// //     debugPrint('================= GEMINI POSTER FLOW START =================');

// //     setState(() {
// //       _messages.add({'role': 'user', 'text': userPrompt, 'type': 'text'});
// //       _isLoading = true;
// //       _messageController.clear();
// //     });
// //     _scrollToBottom();

// //     try {
// //       // STEP 1: Enhance prompt via Gemini
// //       debugPrint('[STEP 1] Enhancing prompt with Gemini');

// //       final enhanceResponse = await _postWithRetry(
// //         Uri.parse(
// //           'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_geminiKey',
// //         ),
// //         {"Content-Type": "application/json"},
// //         jsonEncode({
// //           "contents": [
// //             {
// //               "role": "user",
// //               "parts": [
// //                 {
// //                   "text":
// //                       "You are a professional prompt engineer. Convert the user's simple request into a detailed, vivid image generation prompt. Include colors, style, composition, lighting, and specific visual details. Keep it under 150 words. Only return the enhanced prompt, nothing else.\n\nUser request: $userPrompt",
// //                 },
// //               ],
// //             },
// //           ],
// //           "generationConfig": {"temperature": 0.7, "maxOutputTokens": 300},
// //         }),
// //       );

// //       debugPrint('[STEP 1] Status: ${enhanceResponse.statusCode}');

// //       if (enhanceResponse.statusCode != 200) {
// //         throw Exception('Prompt enhancement failed: ${enhanceResponse.body}');
// //       }

// //       final enhanceJson = jsonDecode(enhanceResponse.body);
// //       final enhancedPrompt =
// //           enhanceJson['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
// //           '';

// //       if (enhancedPrompt.isEmpty) {
// //         throw Exception('Enhanced prompt is empty');
// //       }

// //       debugPrint('[STEP 1] Enhanced: $enhancedPrompt');

// //       setState(() {
// //         _messages.add({
// //           'role': 'bot',
// //           'text': '✨ Enhanced prompt:\n\n$enhancedPrompt',
// //           'type': 'text',
// //         });
// //       });
// //       _scrollToBottom();

// //       // STEP 2: Show loading placeholder
// //       setState(() {
// //         _messages.add({
// //           'role': 'bot',
// //           'text': 'Generating image...',
// //           'type': 'loading',
// //         });
// //       });
// //       _scrollToBottom();

// //       // STEP 3: Image generation via Gemini imagen model
// //       debugPrint('[STEP 3] Generating image with Gemini imagen');

// //       final String finalPrompt = _logoFile != null
// //           ? 'Create a professional poster. Place the company logo prominently at the top center. $enhancedPrompt'
// //           : enhancedPrompt;

// //       final List<Map<String, dynamic>> imageParts = [];

// //       if (_logoFile != null) {
// //         final logoBytes = await _logoFile!.readAsBytes();
// //         final logoBase64 = base64Encode(logoBytes);
// //         final ext = _logoFile!.path.split('.').last.toLowerCase();
// //         final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
// //         imageParts.add({
// //           "inlineData": {"mimeType": mimeType, "data": logoBase64},
// //         });
// //       }

// //       imageParts.add({"text": finalPrompt});

// //       final imageResponse = await _postWithRetry(
// //         Uri.parse(
// //           'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=$_geminiKey',
// //         ),
// //         {"Content-Type": "application/json"},
// //         jsonEncode({
// //           "contents": [
// //             {"role": "user", "parts": imageParts},
// //           ],
// //           "generationConfig": {
// //             "responseModalities": ["TEXT", "IMAGE"],
// //           },
// //         }),
// //       );

// //       debugPrint('[STEP 3] Status: ${imageResponse.statusCode}');

// //       if (imageResponse.statusCode != 200) {
// //         throw Exception('Image generation failed: ${imageResponse.body}');
// //       }

// //       final imageJson = jsonDecode(imageResponse.body);
// //       final parts =
// //           imageJson['candidates']?[0]?['content']?['parts'] as List<dynamic>?;

// //       if (parts == null || parts.isEmpty) {
// //         throw Exception('No content returned from Gemini image generation');
// //       }

// //       String? base64Image;
// //       for (final part in parts) {
// //         if (part['inlineData'] != null) {
// //           base64Image = part['inlineData']['data'];
// //           break;
// //         }
// //       }

// //       if (base64Image == null) {
// //         throw Exception('No image data found in Gemini response');
// //       }

// //       final imageBytes = base64Decode(base64Image);

// //       setState(() {
// //         _messages.removeLast(); // remove loading
// //         _messages.add({'role': 'bot', 'type': 'image', 'image': imageBytes});
// //       });

// //       debugPrint('================= GEMINI POSTER FLOW SUCCESS =================');
// //     } catch (e, stack) {
// //       debugPrint('❌ ERROR: $e');
// //       debugPrint('STACK: $stack');

// //       setState(() {
// //         if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
// //           _messages.removeLast();
// //         }
// //         _messages.add({
// //           'role': 'bot',
// //           'text': 'Failed to generate poster.\n$e',
// //           'type': 'text',
// //         });
// //       });
// //     } finally {
// //       if (mounted) {
// //         setState(() => _isLoading = false);
// //         _scrollToBottom();
// //       }
// //     }
// //   }

// //   // ─── Download / Share ─────────────────────────────────────────────────────────
// //   Future<void> _downloadImage(Uint8List imageBytes) async {
// //     try {
// //       final tempDir = await getTemporaryDirectory();
// //       final tempFile = File(
// //         '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
// //       );
// //       await tempFile.writeAsBytes(imageBytes);
// //       await Gal.putImage(tempFile.path);
// //       await tempFile.delete();
// //       _showSnackbar('Image saved to gallery!');
// //     } catch (e) {
// //       debugPrint('Error saving image: $e');
// //       _showSnackbar('Error saving image: $e');
// //     }
// //   }

// //   Future<void> _shareImage(Uint8List imageBytes) async {
// //     try {
// //       final tempDir = await getTemporaryDirectory();
// //       final file = await File(
// //         '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
// //       ).create();
// //       await file.writeAsBytes(imageBytes);
// //       await Share.shareXFiles(
// //         [XFile(file.path)],
// //         text: 'Check out this poster created with Chicha AI!',
// //       );
// //     } catch (e) {
// //       debugPrint('Error sharing image: $e');
// //       _showSnackbar('Error sharing image: $e');
// //     }
// //   }

// //   // ─── Helpers ─────────────────────────────────────────────────────────────────
// //   void _scrollToBottom() {
// //     if (_scrollController.hasClients) {
// //       Future.delayed(const Duration(milliseconds: 100), () {
// //         if (_scrollController.hasClients) {
// //           _scrollController.animateTo(
// //             _scrollController.position.maxScrollExtent,
// //             duration: const Duration(milliseconds: 300),
// //             curve: Curves.easeOut,
// //           );
// //         }
// //       });
// //     }
// //   }

// //   void _showSnackbar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(
// //           message,
// //           style: TextStyle(
// //             color: _isDarkMode ? Colors.white : Colors.black87,
// //           ),
// //         ),
// //         backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// //         behavior: SnackBarBehavior.floating,
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //         margin: const EdgeInsets.all(16),
// //       ),
// //     );
// //   }

// //   // ─── Message bubble ───────────────────────────────────────────────────────────
// //   Widget _buildMessage(Map<String, dynamic> message) {
// //     final isDarkMode = _isDarkMode;

// //     if (message['type'] == 'loading') {
// //       return Padding(
// //         padding: const EdgeInsets.only(bottom: 16),
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _botAvatar(),
// //             const SizedBox(width: 12),
// //             Container(
// //               width: 300,
// //               height: 300,
// //               decoration: BoxDecoration(
// //                 color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// //                 borderRadius: BorderRadius.circular(20),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
// //                     blurRadius: 12,
// //                     offset: const Offset(0, 4),
// //                   ),
// //                 ],
// //               ),
// //               child: Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const CircularProgressIndicator(
// //                       color: Color(0xFFF5C518),
// //                     ),
// //                     const SizedBox(height: 16),
// //                     Text(
// //                       'Generating your image...',
// //                       style: TextStyle(
// //                         fontSize: 14,
// //                         color: const Color(0xFFF5C518),
// //                         fontWeight: FontWeight.w500,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     if (message['type'] == 'image') {
// //       return Padding(
// //         padding: const EdgeInsets.only(bottom: 16),
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _botAvatar(),
// //             const SizedBox(width: 12),
// //             Flexible(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       color:
// //                           isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// //                       borderRadius: BorderRadius.circular(20),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.black
// //                               .withOpacity(isDarkMode ? 0.3 : 0.08),
// //                           blurRadius: 12,
// //                           offset: const Offset(0, 4),
// //                         ),
// //                       ],
// //                     ),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(20),
// //                       child: Image.memory(
// //                         message['image'] as Uint8List,
// //                         fit: BoxFit.cover,
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Row(
// //                     children: [
// //                       TextButton.icon(
// //                         onPressed: () =>
// //                             _downloadImage(message['image'] as Uint8List),
// //                         icon: const Icon(Icons.download, size: 18),
// //                         label: const Text('Download'),
// //                         style: TextButton.styleFrom(
// //                           foregroundColor: const Color(0xFFF5C518),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 8),
// //                       TextButton.icon(
// //                         onPressed: () =>
// //                             _shareImage(message['image'] as Uint8List),
// //                         icon: const Icon(Icons.share, size: 18),
// //                         label: const Text('Share'),
// //                         style: TextButton.styleFrom(
// //                           foregroundColor: const Color(0xFFF5C518),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     // Text message
// //     final isUser = message['role'] == 'user';
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 16),
// //       child: Row(
// //         mainAxisAlignment:
// //             isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           if (!isUser) ...[
// //             _botAvatar(),
// //             const SizedBox(width: 12),
// //           ],
// //           Flexible(
// //             child: Container(
// //               padding:
// //                   const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
// //               decoration: BoxDecoration(
// //                 gradient: isUser
// //                     ? const LinearGradient(
// //                         colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// //                       )
// //                     : null,
// //                 color: isUser
// //                     ? null
// //                     : (isDarkMode
// //                         ? const Color(0xFF1E293B)
// //                         : Colors.white),
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: const Radius.circular(20),
// //                   topRight: const Radius.circular(20),
// //                   bottomLeft: Radius.circular(isUser ? 20 : 4),
// //                   bottomRight: Radius.circular(isUser ? 4 : 20),
// //                 ),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: isUser
// //                         ? const Color(0xFFF5C518).withOpacity(0.3)
// //                         : Colors.black
// //                             .withOpacity(isDarkMode ? 0.3 : 0.08),
// //                     blurRadius: 12,
// //                     offset: const Offset(0, 4),
// //                   ),
// //                 ],
// //               ),
// //               child: Text(
// //                 message['text'] ?? '',
// //                 style: TextStyle(
// //                   color: isUser
// //                       ? Colors.black87
// //                       : (isDarkMode
// //                           ? Colors.white
// //                           : const Color(0xFF2D3748)),
// //                   fontSize: 15,
// //                   height: 1.5,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           if (isUser) ...[
// //             const SizedBox(width: 12),
// //             Container(
// //               width: 36,
// //               height: 36,
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(
// //                   colors: [Color(0xFF4FD1C5), Color(0xFF3182CE)],
// //                 ),
// //                 borderRadius: BorderRadius.circular(12),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: const Color(0xFF4FD1C5).withOpacity(0.3),
// //                     blurRadius: 8,
// //                     offset: const Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: const Icon(
// //                 Icons.person_outline,
// //                 color: Colors.white,
// //                 size: 20,
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _botAvatar() {
// //     return Container(
// //       width: 36,
// //       height: 36,
// //       decoration: BoxDecoration(
// //         gradient: const LinearGradient(
// //           colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// //         ),
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: const Color(0xFFF5C518).withOpacity(0.3),
// //             blurRadius: 8,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: const Icon(Icons.auto_awesome, color: Colors.black87, size: 20),
// //     );
// //   }

// //   // ─── Empty state ──────────────────────────────────────────────────────────────
// //   Widget _buildEmptyState() {
// //     final isDarkMode = _isDarkMode;
// //     return Center(
// //       child: SingleChildScrollView(
// //         padding: const EdgeInsets.all(32),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Container(
// //               padding: const EdgeInsets.all(24),
// //               decoration: BoxDecoration(
// //                 gradient: const LinearGradient(
// //                   colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// //                 ),
// //                 borderRadius: BorderRadius.circular(24),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: const Color(0xFFF5C518).withOpacity(0.3),
// //                     blurRadius: 20,
// //                     offset: const Offset(0, 10),
// //                   ),
// //                 ],
// //               ),
// //               child: const Icon(
// //                 Icons.auto_awesome,
// //                 size: 48,
// //                 color: Colors.black87,
// //               ),
// //             ),
// //             const SizedBox(height: 32),
// //             AppText(
// //               _isImageGenerationMode
// //                   ? 'Create Amazing Posters'
// //                   : 'chat_with_chicha',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w600,
// //                 color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 16),
// //             AppText(
// //               _isImageGenerationMode
// //                   ? 'Describe your poster and let AI create it'
// //                   : 'ask_me_anything',
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             const SizedBox(height: 12),
// //             Text(
// //               '${_getTimeGreeting()}! 👋',
// //               style: const TextStyle(
// //                 fontSize: 16,
// //                 color: Color(0xFFF5C518),
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ─── Build ────────────────────────────────────────────────────────────────────
// //   @override
// //   Widget build(BuildContext context) {
// //     final isDarkMode = _isDarkMode;

// //     return WillPopScope(
// //       onWillPop: _onWillPop,
// //       child: SafeArea(
// //         child: Scaffold(
// //           backgroundColor:
// //               isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF7FAFC),
// //           appBar: AppBar(
// //             automaticallyImplyLeading: false,
// //             // leading: IconButton(
// //             //   onPressed: () => Navigator.of(context).pop(),
// //             //   icon: const Icon(Icons.arrow_back_ios_new, size: 20),
// //             //   color: Colors.white,
// //             // ),
// //             title: Row(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.2),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: Icon(
// //                     _isImageGenerationMode ? Icons.image : Icons.auto_awesome,
// //                     size: 18,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 AppText(
// //                   _isImageGenerationMode ? 'Post with Chicha' : 'chat_with_chicha',
// //                   style: const TextStyle(
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 15,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             centerTitle: true,
// //             flexibleSpace: Container(
// //               decoration: const BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// //                 ),
// //               ),
// //             ),
// //             foregroundColor: Colors.white,
// //             elevation: 0,
// //             actions: [
// //               IconButton(
// //                 onPressed: _speakGreeting,
// //                 icon: const Icon(Icons.volume_up_rounded, size: 22),
// //                 color: Colors.white,
// //                 tooltip: 'Replay greeting',
// //               ),
// //               InkWell(
// //                 onTap: _toggleImageGenerationMode,
// //                 borderRadius: BorderRadius.circular(12),
// //                 child: Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Icon(
// //                         _isImageGenerationMode ? Icons.chat : Icons.image,
// //                         size: 22,
// //                         color: Colors.white,
// //                       ),
// //                       const SizedBox(height: 2),
// //                       AppText(
// //                         _isImageGenerationMode ? 'Chat' : 'poster',
// //                         style: const TextStyle(
// //                           fontSize: 11,
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.w500,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           body: Column(
// //             children: [
// //               if (_isImageGenerationMode && _logoFile != null)
// //                 Container(
// //                   margin: const EdgeInsets.all(16),
// //                   padding: const EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// //                     borderRadius: BorderRadius.circular(12),
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black
// //                             .withOpacity(isDarkMode ? 0.3 : 0.05),
// //                         blurRadius: 8,
// //                         offset: const Offset(0, 2),
// //                       ),
// //                     ],
// //                   ),
// //                   child: Row(
// //                     children: [
// //                       ClipRRect(
// //                         borderRadius: BorderRadius.circular(8),
// //                         child: Image.file(
// //                           _logoFile!,
// //                           width: 60,
// //                           height: 60,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: Text(
// //                           'Logo selected',
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w500,
// //                             color: isDarkMode
// //                                 ? Colors.white
// //                                 : const Color(0xFF2D3748),
// //                           ),
// //                         ),
// //                       ),
// //                       IconButton(
// //                         icon: const Icon(Icons.close, size: 20),
// //                         onPressed: () => setState(() => _logoFile = null),
// //                         color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               Expanded(
// //                 child: _messages.isEmpty
// //                     ? _buildEmptyState()
// //                     : ListView.builder(
// //                         controller: _scrollController,
// //                         padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
// //                         itemCount: _messages.length,
// //                         itemBuilder: (context, index) =>
// //                             _buildMessage(_messages[index]),
// //                       ),
// //               ),
// //             ],
// //           ),
// //           bottomSheet: Container(
// //             decoration: BoxDecoration(
// //               color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
// //                   blurRadius: 20,
// //                   offset: const Offset(0, -4),
// //                 ),
// //               ],
// //             ),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 if (_isLoading)
// //                   Container(
// //                     padding: const EdgeInsets.symmetric(vertical: 16),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         const SizedBox(
// //                           width: 20,
// //                           height: 20,
// //                           child: CircularProgressIndicator(
// //                             strokeWidth: 2.5,
// //                             valueColor: AlwaysStoppedAnimation<Color>(
// //                               Color(0xFFF5C518),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 12),
// //                         Text(
// //                           _isImageGenerationMode
// //                               ? 'Creating magic...'
// //                               : 'AI analyzing',
// //                           style: TextStyle(
// //                             color: isDarkMode
// //                                 ? Colors.grey[400]
// //                                 : Colors.grey[700],
// //                             fontSize: 14,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 SafeArea(
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(16),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.stretch,
// //                       children: [
// //                         if (_isImageGenerationMode) const SizedBox(height: 12),
// //                         Row(
// //                           children: [
// //                             Expanded(
// //                               child: Container(
// //                                 decoration: BoxDecoration(
// //                                   color: isDarkMode
// //                                       ? const Color(0xFF0F172A)
// //                                       : const Color(0xFFF7FAFC),
// //                                   borderRadius: BorderRadius.circular(24),
// //                                   border: Border.all(
// //                                     color: isDarkMode
// //                                         ? const Color(0xFF334155)
// //                                         : Colors.grey[200]!,
// //                                   ),
// //                                 ),
// //                                 child: TextField(
// //                                   controller: _messageController,
// //                                   textInputAction: TextInputAction.send,
// //                                   onSubmitted: (_) => _sendMessage(),
// //                                   style: TextStyle(
// //                                     fontSize: 15,
// //                                     color: isDarkMode
// //                                         ? Colors.white
// //                                         : const Color(0xFF2D3748),
// //                                   ),
// //                                   decoration: InputDecoration(
// //                                     hintText: _isImageGenerationMode
// //                                         ? AppText.translate(
// //                                             context, 'describe_poster')
// //                                         : AppText.translate(
// //                                             context, 'ask_me_anything'),
// //                                     border: InputBorder.none,
// //                                     contentPadding: const EdgeInsets.symmetric(
// //                                       horizontal: 20,
// //                                       vertical: 14,
// //                                     ),
// //                                     hintStyle: TextStyle(
// //                                       color: Colors.grey[500],
// //                                       fontSize: 15,
// //                                     ),
// //                                   ),
// //                                   minLines: 1,
// //                                   maxLines: 4,
// //                                 ),
// //                               ),
// //                             ),
// //                             const SizedBox(width: 12),
// //                             Container(
// //                               decoration: BoxDecoration(
// //                                 gradient: const LinearGradient(
// //                                   colors: [Color(0xFFF5C518), Color(0xFFF5C518)],
// //                                 ),
// //                                 shape: BoxShape.circle,
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: const Color(0xFFF5C518)
// //                                         .withOpacity(0.4),
// //                                     blurRadius: 12,
// //                                     offset: const Offset(0, 4),
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: IconButton(
// //                                 onPressed: _isLoading ? null : _sendMessage,
// //                                 icon: Icon(
// //                                   _isImageGenerationMode
// //                                       ? Icons.auto_awesome
// //                                       : Icons.send_rounded,
// //                                   size: 22,
// //                                 ),
// //                                 color: Colors.black87,
// //                                 splashRadius: 24,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           floatingActionButton: _isImageGenerationMode
// //               ? FloatingActionButton(
// //                   onPressed: _pickLogo,
// //                   backgroundColor: const Color(0xFFF5C518),
// //                   foregroundColor: Colors.black87,
// //                   elevation: 6,
// //                   tooltip: _logoFile == null ? 'Add Logo' : 'Change Logo',
// //                   child: Icon(
// //                     _logoFile == null ? Icons.add_photo_alternate : Icons.edit,
// //                     size: 26,
// //                   ),
// //                 )
// //               : null,
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _flutterTts.stop();
// //     _messageController.dispose();
// //     _scrollController.dispose();
// //     super.dispose();
// //   }
// // }
























// ///////////// New screen for checking the backnd with AI//////////////


// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:math' as math;
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:gal/gal.dart';
// import 'package:posternova/helper/storage_helper.dart';
// import 'package:posternova/widgets/language_widget.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:path_provider/path_provider.dart';

// class AiScreen extends StatefulWidget {
//   const AiScreen({super.key});

//   @override
//   State<AiScreen> createState() => _AiScreenState();
// }

// class _AiScreenState extends State<AiScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, dynamic>> _messages = [];
//   bool _isLoading = false;
//   final ScrollController _scrollController = ScrollController();

//   File? _logoFile;
//   bool _isImageGenerationMode = false;


//   bool _showLoadingOverlay = false;

//   final FlutterTts _flutterTts = FlutterTts();

//   static const String _baseUrl = 'http://31.97.228.17:4061/api/users/chat';

//   bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

//   @override
//   void initState() {
//     super.initState();
//     _initTts();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         setState(() {});
//         _speakGreeting();
//       }
//     });
//   }

//   Future<http.Response> _postWithRetry(
//     Uri url,
//     Map<String, String> headers,
//     String body, {
//     int maxRetries = 3,
//   }) async {
//     int attempt = 0;
//     while (true) {
//       final response = await http.post(url, headers: headers, body: body);

//       if (response.statusCode != 429 || attempt >= maxRetries) {
//         return response;
//       }

//       attempt++;
//       final delaySec = pow(2, attempt).toInt(); 
//       debugPrint(
//         '[Retry] 429 rate-limited. Waiting ${delaySec}s before attempt $attempt/$maxRetries...',
//       );

//       await Future.delayed(Duration(seconds: delaySec));
//     }
//   }

//   Future<void> _initTts() async {
//     await _flutterTts.setLanguage("en-US");
//     await _flutterTts.setSpeechRate(0.45);
//     await _flutterTts.setVolume(1.0);
//     await _flutterTts.setPitch(1.0);

//     final voices = await _flutterTts.getVoices;
//     if (voices != null) {
//       final voiceList = List<Map>.from(voices);
//       final preferred = voiceList.firstWhere(
//         (v) =>
//             (v['name']?.toString().toLowerCase().contains('female') == true ||
//                 v['name']?.toString().toLowerCase().contains('samantha') ==
//                     true ||
//                 v['name']?.toString().toLowerCase().contains('karen') ==
//                     true) &&
//             v['locale']?.toString().startsWith('en') == true,
//         orElse: () => {},
//       );
//       if (preferred.isNotEmpty && preferred['name'] != null) {
//         await _flutterTts.setVoice({
//           "name": preferred['name'],
//           "locale": preferred['locale'] ?? "en-US",
//         });
//       }
//     }
//   }

//   Future<bool> _onWillPop() async {
//     return await showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return Dialog(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               child: Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(28),
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: Theme.of(context).brightness == Brightness.dark
//                         ? [const Color(0xFF1A1A24), const Color(0xFF0A0A0F)]
//                         : [Colors.white, const Color(0xFFF7FAFC)],
//                   ),
//                   border: Border.all(
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? Colors.white.withOpacity(0.1)
//                         : Colors.black.withOpacity(0.1),
//                     width: 1.5,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.5),
//                       blurRadius: 30,
//                       spreadRadius: 5,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: const LinearGradient(
//                           colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217)],
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color.fromARGB(255, 48, 81, 217),
//                             blurRadius: 12,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.exit_to_app_rounded,
//                         color: Color.fromARGB(221, 255, 255, 255),
//                         size: 32,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       'Exit App?',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Are you sure you want to exit the app?',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Theme.of(context).brightness == Brightness.dark
//                             ? Colors.white.withOpacity(0.6)
//                             : Colors.black.withOpacity(0.6),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         height: 1.4,
//                       ),
//                     ),
//                     const SizedBox(height: 28),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () => Navigator.of(context).pop(false),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16),
//                                 border: Border.all(
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? Colors.white.withOpacity(0.2)
//                                       : Colors.black.withOpacity(0.2),
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: Text(
//                                 'Cancel',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? Colors.white.withOpacity(0.8)
//                                       : Colors.black.withOpacity(0.8),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () => Navigator.of(context).pop(true),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16),
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color.fromARGB(255, 48, 81, 217),
//                                     Color.fromARGB(255, 48, 81, 217),
//                                   ],
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color:
//                                         const Color.fromARGB(255, 48, 81, 217),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: const Text(
//                                 'Exit',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Color.fromARGB(221, 255, 255, 255),
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ) ??
//         false;
//   }

//   String _getTimeGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour >= 5 && hour < 12) return "Good morning";
//     if (hour >= 12 && hour < 17) return "Good afternoon";
//     if (hour >= 17 && hour < 21) return "Good evening";
//     return "Good night";
//   }

//   Future<void> _speakGreeting() async {
//     const text =
//         "Hello Welcome back! I am Chicha AI. How can I help you today?";
//     await _flutterTts.speak(text);
//   }

//   Future<void> _pickLogo() async {
//     final picker = ImagePicker();
//     final file = await picker.pickImage(source: ImageSource.gallery);
//     if (file != null) {
//       setState(() => _logoFile = File(file.path));
//       _showSnackbar('Logo selected successfully!');
//     }
//   }

//   void _toggleImageGenerationMode() {
//     setState(() {
//       _isImageGenerationMode = !_isImageGenerationMode;
//       _logoFile = null;
//       _messageController.clear();
//     });
//   }

//   Future<void> _sendMessage() async {
//     final userMessage = _messageController.text.trim();
//     if (userMessage.isEmpty) return;

//     if (_isImageGenerationMode) {
//       await _generatePosterWithAPI(userMessage);
//     } else {
//       await _sendChatMessage(userMessage);
//     }
//   }

//   Future<String?> _getUserId() async {
//     try {
//       final userData = await AuthPreferences.getUserData();
//       return userData?.user.id;
//     } catch (e) {
//       debugPrint('[AUTH] Error getting user ID: $e');
//       return null;
//     }
//   }

//   Future<void> _sendChatMessage(String userMessage) async {
//     setState(() {
//       _messages.add({'role': 'user', 'text': userMessage, 'type': 'text'});
//       _isLoading = true;
//       _showLoadingOverlay = true;//////////////Newly Aded/////////
//       _messageController.clear();
//     });
//     _scrollToBottom();

//     try {
//       final userId = await _getUserId();
//       if (userId == null || userId.isEmpty) {
//         setState(() {
//           _messages.add({
//             'role': 'bot',
//             'text': 'Unable to identify user. Please log in again.',
//             'type': 'text',
//           });
//         });
//         return;
//       }

//       final url = Uri.parse('$_baseUrl/$userId');

//       debugPrint('[CHAT] POST $url');
//       debugPrint('[CHAT] Message: $userMessage');

//       final response = await _postWithRetry(
//         url,
//         {'Content-Type': 'application/json'},
//         jsonEncode({'message': userMessage}),
//       );

//       debugPrint('[CHAT] Status: ${response.statusCode}');
//       debugPrint('[CHAT] Body: ${response.body}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);

//         final String botReply = data['reply'] ??
//             data['message'] ??
//             data['response'] ??
//             data['data']?['reply'] ??
//             data['data']?['message'] ??
//             'Sorry, I could not generate a response.';

//         final String? imageUrl = data['imageUrl'] ??
//             data['image_url'] ??
//             data['data']?['imageUrl'] ??
//             data['data']?['image_url'];

//         if (imageUrl != null && imageUrl.isNotEmpty) {
//           try {
//             Uint8List imageBytes;

//             if (imageUrl.startsWith('data:')) {
   
//               final commaIndex = imageUrl.indexOf(',');
//               if (commaIndex == -1) {
//                 throw Exception('Invalid base64 data URL format');
//               }
//               final base64Str = imageUrl.substring(commaIndex + 1);
//               imageBytes = base64Decode(base64Str);
//             } else {
//               final imgRes = await http
//                   .get(Uri.parse(imageUrl))
//                   .timeout(const Duration(seconds: 30));

//               if (imgRes.statusCode != 200) {
//                 throw Exception(
//                     'Image fetch failed: ${imgRes.statusCode}');
//               }
//               imageBytes = imgRes.bodyBytes;
//             }

//             setState(() {
//               _messages.add({
//                 'role': 'bot',
//                 'type': 'image',
//                 'image': imageBytes,
//               });
//             });
//           } catch (e) {
//             debugPrint('[IMAGE LOAD] Error: $e');
//             setState(() {
//               _messages.add({
//                 'role': 'bot',
//                 'text': botReply.isNotEmpty
//                     ? botReply
//                     : 'Could not load the generated image.',
//                 'type': 'text',
//               });
//             });
//           }
//         } else {
//           setState(() {
//             _messages.add({
//               'role': 'bot',
//               'text': botReply,
//               'type': 'text',
//             });
//           });
//         }
//       } else {
//         debugPrint(
//             '[CHAT] Error: ${response.statusCode} - ${response.body}');
//         setState(() {
//           _messages.add({
//             'role': 'bot',
//             'text':
//                 'Sorry, I encountered an error (${response.statusCode}). Please try again.',
//             'type': 'text',
//           });
//         });
//       }
//     } catch (e) {
//       debugPrint('[CHAT] Exception: $e');
//       setState(() {
//         if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
//           _messages.removeLast();
//         }
//         _messages.add({
//           'role': 'bot',
//           'text':
//               'Connection issue. Please check your internet and try again.',
//           'type': 'text',
//         });
//       });
//     } finally {
//       if (mounted) {

//         setState(() {
//   _isLoading = false;
//   _showLoadingOverlay = false;  // ← add this
// });
//         // setState(() => _isLoading = false,);
//         _scrollToBottom();
//       }
//     }
//   }

//   Future<void> _generatePosterWithAPI(String userPrompt) async {
//     debugPrint('================= POSTER FLOW START =================');

//     setState(() {
//       _messages.add({'role': 'user', 'text': userPrompt, 'type': 'text'});
//       _isLoading = true;
//       _messageController.clear();
//     });
//     _scrollToBottom();

//     try {
//       final userId = await _getUserId();
//       if (userId == null || userId.isEmpty) {
//         setState(() {
//           _messages.add({
//             'role': 'bot',
//             'text': 'Unable to identify user. Please log in again.',
//             'type': 'text',
//           });
//         });
//         return;
//       }

//       setState(() {
//         _messages.add({
//           'role': 'bot',
//           'text': 'Generating image...',
//           'type': 'loading',
//         });
//       });
//       _scrollToBottom();

//       final url = Uri.parse('$_baseUrl/$userId');

//       final String message = _logoFile != null
//           ? 'Create a professional poster with a company logo: $userPrompt'
//           : userPrompt;

//       debugPrint('[POSTER] POST $url');
//       debugPrint('[POSTER] Prompt: $message');

//       http.Response response;

//       if (_logoFile != null) {
//         final request = http.MultipartRequest('POST', url)
//           ..headers['Content-Type'] = 'multipart/form-data'
//           ..fields['message'] = message
//           ..files.add(
//             await http.MultipartFile.fromPath('logo', _logoFile!.path),
//           );

//         final streamedResponse = await request.send();
//         response = await http.Response.fromStream(streamedResponse);
//       } else {
//         response = await _postWithRetry(
//           url,
//           {'Content-Type': 'application/json'},
//           jsonEncode({'message': message}),
//         );
//       }

//       debugPrint('[POSTER] Status: ${response.statusCode}');
//       debugPrint('[POSTER] Body: ${response.body}');

//       setState(() {
//         if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
//           _messages.removeLast();
//         }
//       });

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = jsonDecode(response.body);

//         final String? imageUrl = data['imageUrl'] ??
//             data['image_url'] ??
//             data['data']?['imageUrl'] ??
//             data['data']?['image_url'];

//         final String botReply = data['reply'] ??
//             data['message'] ??
//             data['response'] ??
//             data['data']?['reply'] ??
//             '';

//         if (imageUrl != null && imageUrl.isNotEmpty) {
//           try {
//             Uint8List imageBytes;

//             if (imageUrl.startsWith('data:')) {
//               final commaIndex = imageUrl.indexOf(',');
//               if (commaIndex == -1) {
//                 throw Exception('Invalid base64 data URL format');
//               }
//               final base64Str = imageUrl.substring(commaIndex + 1);
//               imageBytes = base64Decode(base64Str);
//             } else {
//               final imgRes = await http
//                   .get(Uri.parse(imageUrl))
//                   .timeout(const Duration(seconds: 30));

//               if (imgRes.statusCode != 200) {
//                 throw Exception(
//                     'Image fetch failed: ${imgRes.statusCode}');
//               }
//               imageBytes = imgRes.bodyBytes;
//             }

//             setState(() {
//               _messages.add({
//                 'role': 'bot',
//                 'type': 'image',
//                 'image': imageBytes,
//               });
//             });
//           } catch (e) {
//             debugPrint('[POSTER IMAGE] Error: $e');
//             setState(() {
//               _messages.add({
//                 'role': 'bot',
//                 'text':
//                     'Could not load the generated image. Please try again.',
//                 'type': 'text',
//               });
//             });
//           }
//         } else if (botReply.isNotEmpty) {
//           setState(() {
//             _messages.add({
//               'role': 'bot',
//               'text': botReply,
//               'type': 'text',
//             });
//           });
//         } else {
//           setState(() {
//             _messages.add({
//               'role': 'bot',
//               'text': 'No image was returned. Please try again.',
//               'type': 'text',
//             });
//           });
//         }
//       } else {
//         setState(() {
//           _messages.add({
//             'role': 'bot',
//             'text':
//                 'Failed to generate poster (${response.statusCode}). Please try again.',
//             'type': 'text',
//           });
//         });
//       }

//       debugPrint('================= POSTER FLOW END =================');
//     } catch (e, stack) {
//       debugPrint('❌ POSTER ERROR: $e');
//       debugPrint('STACK: $stack');

//       setState(() {
//         if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
//           _messages.removeLast();
//         }
//         _messages.add({
//           'role': 'bot',
//           'text': 'Failed to generate poster. Please try again.\n$e',
//           'type': 'text',
//         });
//       });
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//         _scrollToBottom();
//       }
//     }
//   }

//   Future<void> _downloadImage(Uint8List imageBytes) async {
//     try {
//       final tempDir = await getTemporaryDirectory();
//       final tempFile = File(
//         '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
//       );
//       await tempFile.writeAsBytes(imageBytes);
//       await Gal.putImage(tempFile.path);
//       await tempFile.delete();
//       _showSnackbar('Image saved to gallery!');
//     } catch (e) {
//       debugPrint('Error saving image: $e');
//       _showSnackbar('Error saving image: $e');
//     }
//   }

//   Future<void> _shareImage(Uint8List imageBytes) async {
//     try {
//       final tempDir = await getTemporaryDirectory();
//       final file = await File(
//         '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
//       ).create();
//       await file.writeAsBytes(imageBytes);
//       await Share.shareXFiles(
//         [XFile(file.path)],
//         text: 'Check out this poster created with Chicha AI!',
//       );
//     } catch (e) {
//       debugPrint('Error sharing image: $e');
//       _showSnackbar('Error sharing image: $e');
//     }
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (_scrollController.hasClients) {
//           _scrollController.animateTo(
//             _scrollController.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     }
//   }

//   void _showSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(
//             color: _isDarkMode ? Colors.white : Colors.black87,
//           ),
//         ),
//         backgroundColor:
//             _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
//         behavior: SnackBarBehavior.floating,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   Widget _buildMessage(Map<String, dynamic> message) {
//     final isDarkMode = _isDarkMode;

//     if (message['type'] == 'loading') {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _botAvatar(),
//             const SizedBox(width: 12),
//             Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                 color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black
//                         .withOpacity(isDarkMode ? 0.3 : 0.08),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const CircularProgressIndicator(
//                       color: Color.fromARGB(255, 48, 81, 217),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Generating your image...',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: const Color.fromARGB(255, 48, 81, 217),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (message['type'] == 'image') {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _botAvatar(),
//             const SizedBox(width: 12),
//             Flexible(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: isDarkMode
//                           ? const Color(0xFF1E293B)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black
//                               .withOpacity(isDarkMode ? 0.3 : 0.08),
//                           blurRadius: 12,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.memory(
//                         message['image'] as Uint8List,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       TextButton.icon(
//                         onPressed: () =>
//                             _downloadImage(message['image'] as Uint8List),
//                         icon: const Icon(Icons.download, size: 18),
//                         label: const Text('Download'),
//                         style: TextButton.styleFrom(
//                           foregroundColor: const Color.fromARGB(255, 0, 0, 0),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       TextButton.icon(
//                         onPressed: () =>
//                             _shareImage(message['image'] as Uint8List),
//                         icon: const Icon(Icons.share, size: 18),
//                         label: const Text('Share'),
//                         style: TextButton.styleFrom(
//                           foregroundColor: const Color.fromARGB(255, 0, 0, 0),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     final isUser = message['role'] == 'user';
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         mainAxisAlignment:
//             isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isUser) ...[
//             _botAvatar(),
//             const SizedBox(width: 12),
//           ],
//           Flexible(
//             child: Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//               decoration: BoxDecoration(
//                 gradient: isUser
//                     ? const LinearGradient(
//                         colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217)],
//                       )
//                     : null,
//                 color: isUser
//                     ? null
//                     : (isDarkMode
//                         ? const Color(0xFF1E293B)
//                         : Colors.white),
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(20),
//                   topRight: const Radius.circular(20),
//                   bottomLeft: Radius.circular(isUser ? 20 : 4),
//                   bottomRight: Radius.circular(isUser ? 4 : 20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: isUser
//                         ? const Color.fromARGB(255, 48, 81, 217)
//                         : Colors.black
//                             .withOpacity(isDarkMode ? 0.3 : 0.08),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 message['text'] ?? '',
//                 style: TextStyle(
//                   color: isUser
//                       ? Colors.white
//                       : (isDarkMode
//                           ? Colors.white
//                           : const Color(0xFF2D3748)),
//                   fontSize: 15,
//                   height: 1.5,
//                 ),
//               ),
//             ),
//           ),
//           if (isUser) ...[
//             const SizedBox(width: 12),
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF4FD1C5), Color(0xFF3182CE)],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xFF4FD1C5).withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.person_outline,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _botAvatar() {
//     return Container(
//       width: 36,
//       height: 36,
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217),],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: const Color.fromARGB(255, 48, 81, 217),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child:
//           const Icon(Icons.auto_awesome, color: Color.fromARGB(221, 255, 255, 255), size: 20),
//     );
//   }

//   Widget _buildEmptyState() {
//     final isDarkMode = _isDarkMode;
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217),],
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color.fromARGB(255, 48, 81, 217),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: const Icon(
//                 Icons.auto_awesome,
//                 size: 48,
//                 color: Color.fromARGB(221, 255, 255, 255),
//               ),
//             ),
//             const SizedBox(height: 32),
//             AppText(
//               _isImageGenerationMode
//                   ? 'Create Amazing Posters'
//                   : 'chat_with_chicha',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: isDarkMode
//                     ? Colors.white
//                     : const Color(0xFF2D3748),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             AppText(
//               _isImageGenerationMode
//                   ? 'Describe your poster and let AI create it'
//                   : 'ask_me_anything',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),
//             Text(
//               '${_getTimeGreeting()}! 👋',
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Color.fromARGB(255, 48, 81, 217),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = _isDarkMode;
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: SafeArea(
//         child: Scaffold(
//           backgroundColor: isDarkMode
//               ? const Color(0xFF0F172A)
//               : const Color(0xFFF7FAFC),
//           appBar: AppBar(
//             automaticallyImplyLeading: true,
//             title: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     _isImageGenerationMode
//                         ? Icons.image
//                         : Icons.auto_awesome,
//                     size: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 AppText(
//                   _isImageGenerationMode
//                       ? 'Post with Chicha'
//                       : 'chat_with_chicha',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 15,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             centerTitle: true,
//             flexibleSpace: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217),],
//                 ),
//               ),
//             ),
//             foregroundColor: Colors.white,
//             elevation: 0,
//             actions: [
//               IconButton(
//                 onPressed: _speakGreeting,
//                 icon: const Icon(Icons.volume_up_rounded, size: 22),
//                 color: Colors.white,
//                 tooltip: 'Replay greeting',
//               ),
//               InkWell(
//                 onTap: _toggleImageGenerationMode,
//                 borderRadius: BorderRadius.circular(12),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 12, vertical: 6),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         _isImageGenerationMode ? Icons.chat : Icons.image,
//                         size: 22,
//                         color: Colors.white,
//                       ),
//                       const SizedBox(height: 2),
//                       AppText(
//                         _isImageGenerationMode ? 'Chat' : 'poster',
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: Colors.white,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               if (_isImageGenerationMode && _logoFile != null)
//                 Container(
//                   margin: const EdgeInsets.all(16),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isDarkMode
//                         ? const Color(0xFF1E293B)
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black
//                             .withOpacity(isDarkMode ? 0.3 : 0.05),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.file(
//                           _logoFile!,
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           'Logo selected',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: isDarkMode
//                                 ? Colors.white
//                                 : const Color(0xFF2D3748),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close, size: 20),
//                         onPressed: () =>
//                             setState(() => _logoFile = null),
//                         color: isDarkMode
//                             ? Colors.grey[400]
//                             : Colors.grey[600],
//                       ),
//                     ],
//                   ),
//                 ),
//               Expanded(
//                 child: _messages.isEmpty
//                     ? _buildEmptyState()
//                     : ListView.builder(
//                         controller: _scrollController,
//                         padding:
//                             const EdgeInsets.fromLTRB(16, 16, 16, 100),
//                         itemCount: _messages.length,
//                         itemBuilder: (context, index) =>
//                             _buildMessage(_messages[index]),
//                       ),
//               ),
//             ],
//           ),
//           bottomSheet: Container(
//             decoration: BoxDecoration(
//               color:
//                   isDarkMode ? const Color(0xFF1E293B) : Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black
//                       .withOpacity(isDarkMode ? 0.3 : 0.05),
//                   blurRadius: 20,
//                   offset: const Offset(0, -4),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (_isLoading)
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2.5,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Color.fromARGB(255, 48, 81, 217),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           _isImageGenerationMode
//                               ? 'Creating magic...'
//                               : 'AI analyzing',
//                           style: TextStyle(
//                             color: isDarkMode
//                                 ? Colors.grey[400]
//                                 : Colors.grey[700],
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         if (_isImageGenerationMode)
//                           const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: isDarkMode
//                                       ? const Color(0xFF0F172A)
//                                       : const Color(0xFFF7FAFC),
//                                   borderRadius:
//                                       BorderRadius.circular(24),
//                                   border: Border.all(
//                                     color: isDarkMode
//                                         ? const Color(0xFF334155)
//                                         : Colors.grey[200]!,
//                                   ),
//                                 ),
//                                 child: TextField(
//                                   controller: _messageController,
//                                   textInputAction: TextInputAction.send,
//                                   onSubmitted: (_) => _sendMessage(),
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: isDarkMode
//                                         ? Colors.white
//                                         : const Color(0xFF2D3748),
//                                   ),
//                                   decoration: InputDecoration(
//                                     hintText: _isImageGenerationMode
//                                         ? AppText.translate(
//                                             context, 'describe_poster')
//                                         : AppText.translate(
//                                             context, 'ask_me_anything'),
//                                     border: InputBorder.none,
//                                     contentPadding:
//                                         const EdgeInsets.symmetric(
//                                       horizontal: 20,
//                                       vertical: 14,
//                                     ),
//                                     hintStyle: TextStyle(
//                                       color: Colors.grey[500],
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                   minLines: 1,
//                                   maxLines: 4,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Container(
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color.fromARGB(255, 48, 81, 217),
//                                     Color.fromARGB(255, 48, 81, 217),
//                                   ],
//                                 ),
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Color.fromARGB(255, 48, 81, 217),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: IconButton(
//                                 onPressed:
//                                     _isLoading ? null : _sendMessage,
//                                 icon: Icon(
//                                   _isImageGenerationMode
//                                       ? Icons.auto_awesome
//                                       : Icons.send_rounded,
//                                   size: 22,
//                                 ),
//                                 color: const Color.fromARGB(221, 255, 255, 255),
//                                 splashRadius: 24,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           floatingActionButton: _isImageGenerationMode
//               ? FloatingActionButton(
//                   onPressed: _pickLogo,
//                   backgroundColor: const Color(0xFFF5C518),
//                   foregroundColor: Colors.black87,
//                   elevation: 6,
//                   tooltip:
//                       _logoFile == null ? 'Add Logo' : 'Change Logo',
//                   child: Icon(
//                     _logoFile == null
//                         ? Icons.add_photo_alternate
//                         : Icons.edit,
//                     size: 26,
//                   ),
//                 )
//               : null,
//         ),
        
        
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _flutterTts.stop();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }














///////////////////////////// Added New code for showing the animation/////////////////////




// ignore_for_file: dangling_library_doc_comments

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:posternova/helper/storage_helper.dart';
import 'package:posternova/widgets/language_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _showLoadingOverlay = false;
  final ScrollController _scrollController = ScrollController();

  File? _logoFile;
  bool _isImageGenerationMode = false;

  final FlutterTts _flutterTts = FlutterTts();

  static const String _baseUrl = 'http://31.97.228.17:4061/api/users/chat';

  bool get _isDarkMode => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
        _speakGreeting();
      }
    });
  }

  Future<http.Response> _postWithRetry(
    Uri url,
    Map<String, String> headers,
    String body, {
    int maxRetries = 3,
  }) async {
    int attempt = 0;
    while (true) {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode != 429 || attempt >= maxRetries) {
        return response;
      }
      attempt++;
      final delaySec = pow(2, attempt).toInt();
      debugPrint('[Retry] 429 rate-limited. Waiting ${delaySec}s before attempt $attempt/$maxRetries...');
      await Future.delayed(Duration(seconds: delaySec));
    }
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    final voices = await _flutterTts.getVoices;
    if (voices != null) {
      final voiceList = List<Map>.from(voices);
      final preferred = voiceList.firstWhere(
        (v) =>
            (v['name']?.toString().toLowerCase().contains('female') == true ||
                v['name']?.toString().toLowerCase().contains('samantha') == true ||
                v['name']?.toString().toLowerCase().contains('karen') == true) &&
            v['locale']?.toString().startsWith('en') == true,
        orElse: () => {},
      );
      if (preferred.isNotEmpty && preferred['name'] != null) {
        await _flutterTts.setVoice({
          "name": preferred['name'],
          "locale": preferred['locale'] ?? "en-US",
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? [const Color(0xFF1A1A24), const Color(0xFF0A0A0F)]
                        : [Colors.white, const Color(0xFFF7FAFC)],
                  ),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.1),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 48, 81, 217),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.exit_to_app_rounded,
                        color: Color.fromARGB(221, 255, 255, 255),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Exit App?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Are you sure you want to exit the app?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.6)
                            : Colors.black.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.black.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 48, 81, 217),
                                    Color.fromARGB(255, 48, 81, 217),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 48, 81, 217),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Exit',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(221, 255, 255, 255),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good morning";
    if (hour >= 12 && hour < 17) return "Good afternoon";
    if (hour >= 17 && hour < 21) return "Good evening";
    return "Good night";
  }

  Future<void> _speakGreeting() async {
    const text = "Hello Welcome back! I am Chicha AI. How can I help you today?";
    await _flutterTts.speak(text);
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _logoFile = File(file.path));
      _showSnackbar('Logo selected successfully!');
    }
  }

  void _toggleImageGenerationMode() {
    setState(() {
      _isImageGenerationMode = !_isImageGenerationMode;
      _logoFile = null;
      _messageController.clear();
    });
  }

  Future<void> _sendMessage() async {
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    if (_isImageGenerationMode) {
      await _generatePosterWithAPI(userMessage);
    } else {
      await _sendChatMessage(userMessage);
    }
  }

  Future<String?> _getUserId() async {
    try {
      final userData = await AuthPreferences.getUserData();
      return userData?.user.id;
    } catch (e) {
      debugPrint('[AUTH] Error getting user ID: $e');
      return null;
    }
  }

  Future<void> _sendChatMessage(String userMessage) async {
    setState(() {
      _messages.add({'role': 'user', 'text': userMessage, 'type': 'text'});
      _isLoading = true;
      _showLoadingOverlay = true;
      _messageController.clear();
    });
    _scrollToBottom();

    try {
      final userId = await _getUserId();
      if (userId == null || userId.isEmpty) {
        setState(() {
          _showLoadingOverlay = false;
          _messages.add({
            'role': 'bot',
            'text': 'Unable to identify user. Please log in again.',
            'type': 'text',
          });
        });
        return;
      }

      final url = Uri.parse('$_baseUrl/$userId');
      debugPrint('[CHAT] POST $url');
      debugPrint('[CHAT] Message: $userMessage');

      final response = await _postWithRetry(
        url,
        {'Content-Type': 'application/json'},
        jsonEncode({'message': userMessage}),
      );

      debugPrint('[CHAT] Status: ${response.statusCode}');
      debugPrint('[CHAT] Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final String botReply = data['reply'] ??
            data['message'] ??
            data['response'] ??
            data['data']?['reply'] ??
            data['data']?['message'] ??
            'Sorry, I could not generate a response.';

        final String? imageUrl = data['imageUrl'] ??
            data['image_url'] ??
            data['data']?['imageUrl'] ??
            data['data']?['image_url'];

        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            Uint8List imageBytes;
            if (imageUrl.startsWith('data:')) {
              final commaIndex = imageUrl.indexOf(',');
              if (commaIndex == -1) throw Exception('Invalid base64 data URL format');
              final base64Str = imageUrl.substring(commaIndex + 1);
              imageBytes = base64Decode(base64Str);
            } else {
              final imgRes = await http.get(Uri.parse(imageUrl)).timeout(const Duration(seconds: 30));
              if (imgRes.statusCode != 200) throw Exception('Image fetch failed: ${imgRes.statusCode}');
              imageBytes = imgRes.bodyBytes;
            }
            setState(() {
              _messages.add({'role': 'bot', 'type': 'image', 'image': imageBytes});
            });
          } catch (e) {
            debugPrint('[IMAGE LOAD] Error: $e');
            setState(() {
              _messages.add({
                'role': 'bot',
                'text': botReply.isNotEmpty ? botReply : 'Could not load the generated image.',
                'type': 'text',
              });
            });
          }
        } else {
          setState(() {
            _messages.add({'role': 'bot', 'text': botReply, 'type': 'text'});
          });
        }
      } else {
        debugPrint('[CHAT] Error: ${response.statusCode} - ${response.body}');
        setState(() {
          _messages.add({
            'role': 'bot',
            'text': 'Sorry, I encountered an error (${response.statusCode}). Please try again.',
            'type': 'text',
          });
        });
      }
    } catch (e) {
      debugPrint('[CHAT] Exception: $e');
      setState(() {
        if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
          _messages.removeLast();
        }
        _messages.add({
          'role': 'bot',
          'text': 'Connection issue. Please check your internet and try again.',
          'type': 'text',
        });
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showLoadingOverlay = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _generatePosterWithAPI(String userPrompt) async {
    debugPrint('================= POSTER FLOW START =================');

    setState(() {
      _messages.add({'role': 'user', 'text': userPrompt, 'type': 'text'});
      _isLoading = true;
      _showLoadingOverlay = true;
      _messageController.clear();
    });
    _scrollToBottom();

    try {
      final userId = await _getUserId();
      if (userId == null || userId.isEmpty) {
        setState(() {
          _showLoadingOverlay = false;
          _messages.add({
            'role': 'bot',
            'text': 'Unable to identify user. Please log in again.',
            'type': 'text',
          });
        });
        return;
      }

      final url = Uri.parse('$_baseUrl/$userId');

      final String message = _logoFile != null
          ? 'Create a professional poster with a company logo: $userPrompt'
          : userPrompt;

      debugPrint('[POSTER] POST $url');
      debugPrint('[POSTER] Prompt: $message');

      http.Response response;

      if (_logoFile != null) {
        final request = http.MultipartRequest('POST', url)
          ..headers['Content-Type'] = 'multipart/form-data'
          ..fields['message'] = message
          ..files.add(await http.MultipartFile.fromPath('logo', _logoFile!.path));
        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        response = await _postWithRetry(
          url,
          {'Content-Type': 'application/json'},
          jsonEncode({'message': message}),
        );
      }

      debugPrint('[POSTER] Status: ${response.statusCode}');
      debugPrint('[POSTER] Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final String? imageUrl = data['imageUrl'] ??
            data['image_url'] ??
            data['data']?['imageUrl'] ??
            data['data']?['image_url'];

        final String botReply = data['reply'] ??
            data['message'] ??
            data['response'] ??
            data['data']?['reply'] ??
            '';

        if (imageUrl != null && imageUrl.isNotEmpty) {
          try {
            Uint8List imageBytes;
            if (imageUrl.startsWith('data:')) {
              final commaIndex = imageUrl.indexOf(',');
              if (commaIndex == -1) throw Exception('Invalid base64 data URL format');
              final base64Str = imageUrl.substring(commaIndex + 1);
              imageBytes = base64Decode(base64Str);
            } else {
              final imgRes = await http.get(Uri.parse(imageUrl)).timeout(const Duration(seconds: 30));
              if (imgRes.statusCode != 200) throw Exception('Image fetch failed: ${imgRes.statusCode}');
              imageBytes = imgRes.bodyBytes;
            }
            setState(() {
              _messages.add({'role': 'bot', 'type': 'image', 'image': imageBytes});
            });
          } catch (e) {
            debugPrint('[POSTER IMAGE] Error: $e');
            setState(() {
              _messages.add({
                'role': 'bot',
                'text': 'Could not load the generated image. Please try again.',
                'type': 'text',
              });
            });
          }
        } else if (botReply.isNotEmpty) {
          setState(() {
            _messages.add({'role': 'bot', 'text': botReply, 'type': 'text'});
          });
        } else {
          setState(() {
            _messages.add({
              'role': 'bot',
              'text': 'No image was returned. Please try again.',
              'type': 'text',
            });
          });
        }
      } else {
        setState(() {
          _messages.add({
            'role': 'bot',
            'text': 'Failed to generate poster (${response.statusCode}). Please try again.',
            'type': 'text',
          });
        });
      }

      debugPrint('================= POSTER FLOW END =================');
    } catch (e, stack) {
      debugPrint('❌ POSTER ERROR: $e');
      debugPrint('STACK: $stack');
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': 'Failed to generate poster. Please try again.\n$e',
          'type': 'text',
        });
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showLoadingOverlay = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _downloadImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png');
      await tempFile.writeAsBytes(imageBytes);
      await Gal.putImage(tempFile.path);
      await tempFile.delete();
      _showSnackbar('Image saved to gallery!');
    } catch (e) {
      debugPrint('Error saving image: $e');
      _showSnackbar('Error saving image: $e');
    }
  }

  Future<void> _shareImage(Uint8List imageBytes) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await file.writeAsBytes(imageBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Check out this poster created with Chicha AI!');
    } catch (e) {
      debugPrint('Error sharing image: $e');
      _showSnackbar('Error sharing image: $e');
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)),
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isDarkMode = _isDarkMode;

    if (message['type'] == 'loading') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _botAvatar(),
            const SizedBox(width: 12),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Color.fromARGB(255, 48, 81, 217)),
                    const SizedBox(height: 16),
                    Text(
                      'Generating your image...',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 48, 81, 217),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (message['type'] == 'image') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _botAvatar(),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(message['image'] as Uint8List, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => _downloadImage(message['image'] as Uint8List),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Download'),
                        style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _shareImage(message['image'] as Uint8List),
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share'),
                        style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final isUser = message['role'] == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _botAvatar(),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217)],
                      )
                    : null,
                color: isUser ? null : (isDarkMode ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? const Color.fromARGB(255, 48, 81, 217)
                        : Colors.black.withOpacity(isDarkMode ? 0.3 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message['text'] ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : (isDarkMode ? Colors.white : const Color(0xFF2D3748)),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF4FD1C5), Color(0xFF3182CE)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4FD1C5).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  Widget _botAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 48, 81, 217),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.auto_awesome, color: Color.fromARGB(221, 255, 255, 255), size: 20),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = _isDarkMode;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 48, 81, 217),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, size: 48, color: Color.fromARGB(221, 255, 255, 255)),
            ),
            const SizedBox(height: 32),
            AppText(
              _isImageGenerationMode ? 'Create Amazing Posters' : 'chat_with_chicha',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppText(
              _isImageGenerationMode ? 'Describe your poster and let AI create it' : 'ask_me_anything',
              style: TextStyle(fontSize: 14, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '${_getTimeGreeting()}! 👋',
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 48, 81, 217),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF7FAFC),
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _isImageGenerationMode ? Icons.image : Icons.auto_awesome,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AppText(
                      _isImageGenerationMode ? 'Post with Chicha' : 'chat_with_chicha',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217)],
                    ),
                  ),
                ),
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: _speakGreeting,
                    icon: const Icon(Icons.volume_up_rounded, size: 22),
                    color: Colors.white,
                    tooltip: 'Replay greeting',
                  ),
                  InkWell(
                    onTap: _toggleImageGenerationMode,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_isImageGenerationMode ? Icons.chat : Icons.image, size: 22, color: Colors.white),
                          const SizedBox(height: 2),
                          AppText(
                            _isImageGenerationMode ? 'Chat' : 'poster',
                            style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  if (_isImageGenerationMode && _logoFile != null)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_logoFile!, width: 60, height: 60, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Logo selected',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => setState(() => _logoFile = null),
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: _messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) => _buildMessage(_messages[index]),
                          ),
                  ),
                ],
              ),
              bottomSheet: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoading)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 48, 81, 217)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _isImageGenerationMode ? 'Creating magic...' : 'AI analyzing',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_isImageGenerationMode) const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF7FAFC),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: isDarkMode ? const Color(0xFF334155) : Colors.grey[200]!,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _messageController,
                                      textInputAction: TextInputAction.send,
                                      onSubmitted: (_) => _sendMessage(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: isDarkMode ? Colors.white : const Color(0xFF2D3748),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: _isImageGenerationMode
                                            ? AppText.translate(context, 'describe_poster')
                                            : AppText.translate(context, 'ask_me_anything'),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                                      ),
                                      minLines: 1,
                                      maxLines: 4,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color.fromARGB(255, 48, 81, 217), Color.fromARGB(255, 48, 81, 217)],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(255, 48, 81, 217),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    onPressed: _isLoading ? null : _sendMessage,
                                    icon: Icon(
                                      _isImageGenerationMode ? Icons.auto_awesome : Icons.send_rounded,
                                      size: 22,
                                    ),
                                    color: const Color.fromARGB(221, 255, 255, 255),
                                    splashRadius: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: _isImageGenerationMode
                  ? FloatingActionButton(
                      onPressed: _pickLogo,
                      backgroundColor: const Color(0xFFF5C518),
                      foregroundColor: Colors.black87,
                      elevation: 6,
                      tooltip: _logoFile == null ? 'Add Logo' : 'Change Logo',
                      child: Icon(_logoFile == null ? Icons.add_photo_alternate : Icons.edit, size: 26),
                    )
                  : null,
            ),

            // ── Animated loading overlay ──────────────────────────────────
            _showLoadingOverlay
                ? const Positioned.fill(child: _ChatLoadingOverlay())
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}


class _ChatLoadingOverlay extends StatefulWidget {
  const _ChatLoadingOverlay();

  @override
  State<_ChatLoadingOverlay> createState() => _ChatLoadingOverlayState();
}

class _ChatLoadingOverlayState extends State<_ChatLoadingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _orbitController;
  late AnimationController _shimmerController;
  late AnimationController _dotController;

  late Animation<double> _pulse;
  late Animation<double> _shimmer;
  late Animation<double> _dots;

  static const Color _brandBlue   = Color.fromARGB(255, 48, 81, 217);
  static const Color _brandLight  = Color(0xFF7B9BFF);
  static const Color _brandAccent = Color(0xFFAAC4FF);

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))..repeat();

    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);

    _orbitController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))..repeat();

    _shimmerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))..repeat();

    _dotController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))..repeat();

    _pulse = Tween<double>(begin: 0.92, end: 1.08).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
        CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut));

    _dots = Tween<double>(begin: 0, end: 1).animate(_dotController);
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    _orbitController.dispose();
    _shimmerController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  Widget _buildOrbitDot(double angle, Color color, double size) {
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (_, __) {
        final a = angle + (_orbitController.value * 2 * pi);
        const r = 52.0;
        return Transform.translate(
          offset: Offset(cos(a) * r, sin(a) * r),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _rotateController,
                    builder: (_, child) => Transform.rotate(
                      angle: _rotateController.value * 2 * pi,
                      child: child,
                    ),
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            _brandLight,
                            _brandAccent,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.4, 0.6, 0.75, 1.0],
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _rotateController,
                    builder: (_, child) => Transform.rotate(
                      angle: -_rotateController.value * 2 * pi * 1.5,
                      child: child,
                    ),
                    child: Container(
                      width: 118,
                      height: 118,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            _brandBlue,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.5, 0.65, 1.0],
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                      ),
                    ),
                  ),

                  _buildOrbitDot(0.0, _brandAccent, 7),
                  _buildOrbitDot(pi * 2 / 3, _brandLight, 5),
                  _buildOrbitDot(pi * 4 / 3, _brandBlue, 6),

                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, __) => Container(
                      width: 90 * _pulse.value,
                      height: 90 * _pulse.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: _brandLight.withOpacity(0.35), blurRadius: 24, spreadRadius: 8),
                          BoxShadow(color: _brandAccent.withOpacity(0.2), blurRadius: 40, spreadRadius: 14),
                        ],
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: _shimmer,
                    builder: (_, child) => ShaderMask(
                      blendMode: BlendMode.srcATop,
                      shaderCallback: (bounds) => LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: const [
                          Colors.white,
                          Colors.white,
                          Color(0xFFB2C8FF),
                          Colors.white,
                          Colors.white,
                        ],
                        stops: [
                          0.0,
                          (_shimmer.value - 0.3).clamp(0.0, 1.0),
                          _shimmer.value.clamp(0.0, 1.0),
                          (_shimmer.value + 0.3).clamp(0.0, 1.0),
                          1.0,
                        ],
                      ).createShader(bounds),
                      child: child!,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/mainlogo.jpeg',
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [_brandBlue, _brandLight],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(Icons.auto_awesome, size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            AnimatedBuilder(
              animation: _dots,
              builder: (_, __) {
                const label = 'Thinking';
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ...List.generate(label.length, (i) {
                      final offset = sin((_dots.value * 2 * pi) + (i * 0.45)) * 4.0;
                      final t = (sin((_dots.value * 2 * pi) + (i * 0.5)) + 1) / 2;
                      final color = Color.lerp(_brandBlue, _brandAccent, t)!;
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: Text(
                          label[i],
                          style: TextStyle(
                            color: color,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      );
                    }),
                    ...List.generate(3, (i) {
                      final dotPhase = (_dots.value * 3 - i).floor() % 3 == 0;
                      return Padding(
                        padding: EdgeInsets.only(bottom: dotPhase ? 5 : 0, left: i == 0 ? 2 : 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotPhase ? _brandAccent : Colors.white.withOpacity(0.3),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}