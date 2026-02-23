import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:gal/gal.dart';
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
  final ScrollController _scrollController = ScrollController();

  File? _logoFile;
  bool _isImageGenerationMode = false;

  // ❌ NOT SAFE – ONLY FOR TESTING - Replace with your actual API key
  static final String? openAiKey = dotenv.env['OPEN_AI_KEY'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _logoFile = File(file.path);
      });
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
      await _generatePosterWithAI(userMessage);
    } else {
      await _sendChatMessage(userMessage);
    }
  }

  // Future<void> _sendChatMessage(String userMessage) async {
  //   setState(() {
  //     _messages.add({'role': 'user', 'text': userMessage, 'type': 'text'});
  //     _isLoading = true;
  //     _messageController.clear();
  //   });

  //   _scrollToBottom();

  //   try {
  //     final now = DateTime.now();
  //     final today =
  //         "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  //     List<Map<String, dynamic>> conversationHistory = [
  //       {
  //         "role": "system",
  //         "content":
  //             "You are Chicha AI. Today's date is $today. If user asks about current date/time, always answer using this date.",
  //       },
  //       ..._messages.where((msg) => msg['type'] == 'text').map((msg) {
  //         return {
  //           'role': msg['role'] == 'user' ? 'user' : 'assistant',
  //           'content': msg['text'],
  //         };
  //       }).toList(),
  //     ];

  //     final response = await http.post(
  //       Uri.parse('https://api.openai.com/v1/chat/completions'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $openAiKey",
  //       },
  //       body: jsonEncode({
  //         "model": "gpt-4o-mini",
  //         "messages": conversationHistory,
  //         "temperature": 0.7,
  //         "max_tokens": 1000,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final botReply = data['choices'][0]['message']['content'];

  //       setState(() {
  //         _messages.add({'role': 'bot', 'text': botReply, 'type': 'text'});
  //       });
  //     } else {
  //       debugPrint('API Error: ${response.statusCode} - ${response.body}');
  //       setState(() {
  //         _messages.add({
  //           'role': 'bot',
  //           'text':
  //               'Sorry, I encountered an error (${response.statusCode}). Please try again.',
  //           'type': 'text',
  //         });
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('Error sending message: $e');
  //     setState(() {
  //       _messages.add({
  //         'role': 'bot',
  //         'text': 'Connection issue. Please check your internet and try again.',
  //         'type': 'text',
  //       });
  //     });
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //       _scrollToBottom();
  //     }
  //   }
  // }



  Future<void> _sendChatMessage(String userMessage) async {
  setState(() {
    _messages.add({'role': 'user', 'text': userMessage, 'type': 'text'});
    _isLoading = true;
    _messageController.clear();
  });

  _scrollToBottom();

  try {
    final now = DateTime.now();
    final today =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Build conversation history for Gemini's "contents" format
    final List<Map<String, dynamic>> contents = [
      // System-like instruction as first user turn
      {
        "role": "user",
        "parts": [
          {
            "text":
                "You are Chicha AI. Today's date is $today. If the user asks about the current date/time, always answer using this date. Acknowledge this with OK.",
          }
        ],
      },
      {
        "role": "model",
        "parts": [
          {"text": "OK"},
        ],
      },
      // Actual conversation history
      ..._messages.where((msg) => msg['type'] == 'text').map((msg) {
        return {
          "role": msg['role'] == 'user' ? 'user' : 'model',
          "parts": [
            {"text": msg['text'] ?? ''},
          ],
        };
      }).toList(),
    ];

    final response = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${dotenv.env['OPEN_AI_KEY']}',
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": contents,
        "generationConfig": {
          "temperature": 0.7,
          "maxOutputTokens": 1000,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final botReply =
          data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

      setState(() {
        _messages.add({'role': 'bot', 'text': botReply, 'type': 'text'});
      });
    } else {
      debugPrint('Gemini Chat Error: ${response.statusCode} - ${response.body}');
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': 'Sorry, I encountered an error (${response.statusCode}). Please try again.',
          'type': 'text',
        });
      });
    }
  } catch (e) {
    debugPrint('Error sending message: $e');
    setState(() {
      _messages.add({
        'role': 'bot',
        'text': 'Connection issue. Please check your internet and try again.',
        'type': 'text',
      });
    });
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }
}

//   Future<void> _generatePosterWithAI(String userPrompt) async {
//     debugPrint('================= AI POSTER FLOW START =================');
//     debugPrint('[INIT] User prompt: $userPrompt');

//     setState(() {
//       _messages.add({'role': 'user', 'text': userPrompt, 'type': 'text'});
//       _isLoading = true;
//       _messageController.clear();
//     });

//     _scrollToBottom();

//     try {
//       // ======================================================
//       // STEP 1: ENHANCE PROMPT (CHAT COMPLETION)
//       // ======================================================
//       debugPrint('[STEP 1] Enhancing prompt');

//       final enhancePayload = {
//         "model": "gpt-4o-mini",
//         "messages": [
//           {
//             "role": "system",
//             "content":
//                 "You are a professional prompt engineer. Convert the user's simple request into a detailed, professional image generation prompt. Include colors, style, composition, and specific details. Keep it under 150 words. Only return the enhanced prompt, nothing else.",
//           },
//           {"role": "user", "content": userPrompt},
//         ],
//         "temperature": 0.7,
//         "max_tokens": 200,
//       };

//       final enhanceResponse = await http.post(
//         Uri.parse('https://api.openai.com/v1/chat/completions'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $openAiKey",
//         },
//         body: jsonEncode(enhancePayload),
//       );

//       debugPrint('[STEP 1] Status: ${enhanceResponse.statusCode}');
//       debugPrint('[STEP 1] Body: ${enhanceResponse.body}');

//       if (enhanceResponse.statusCode != 200) {
//         throw Exception('Prompt enhancement failed');
//       }

//       final enhanceJson = jsonDecode(enhanceResponse.body);
//       final enhancedPrompt = enhanceJson['choices']?[0]?['message']?['content'];

//       if (enhancedPrompt == null || enhancedPrompt.toString().isEmpty) {
//         throw Exception('Enhanced prompt is empty');
//       }

//       debugPrint('[STEP 1] Enhanced prompt:\n$enhancedPrompt');

//       setState(() {
//         _messages.add({
//           'role': 'bot',
//           'text': '✨ Enhanced prompt:\n\n$enhancedPrompt',
//           'type': 'text',
//         });
//       });

//       _scrollToBottom();

//       // ======================================================
//       // STEP 2: SHOW LOADING PLACEHOLDER
//       // ======================================================
//       debugPrint('[STEP 2] Showing image loading');

//       setState(() {
//         _messages.add({
//           'role': 'bot',
//           'text': 'Generating image...',
//           'type': 'loading',
//         });
//       });

//       _scrollToBottom();

//       // ======================================================
//       // STEP 3: IMAGE GENERATION / EDIT
//       // ======================================================
//       debugPrint('[STEP 3] Logo present: ${_logoFile != null}');

//       if (_logoFile != null) {
//         // ---------------- IMAGE EDIT ----------------
//         debugPrint('[STEP 3A] Using image edit endpoint');

//         final finalPrompt =
//             '''
// Create a professional Diwali festival poster.
// Use warm golden, purple and orange colors.
// Place the uploaded company logo at the top center.
// Add diya lamps, lights, fireworks and festive decorations.
// Text style should be modern and clean.

// $enhancedPrompt
// ''';

//         final request = http.MultipartRequest(
//           'POST',
//           Uri.parse('https://api.openai.com/v1/images/edits'),
//         );

//         request.headers['Authorization'] = 'Bearer $openAiKey';
//         request.fields['model'] = 'gpt-image-1';
//         request.fields['prompt'] = finalPrompt;
//         request.fields['size'] = '1024x1024';

//         // Detect correct MIME type
//         final ext = _logoFile!.path.split('.').last.toLowerCase();
//         final mimeType = ext == 'png' ? 'png' : 'jpeg';

//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'image',
//             _logoFile!.path,
//             contentType: MediaType('image', mimeType),
//           ),
//         );

//         debugPrint('[STEP 3A] Sending image edit request');
//         debugPrint('[STEP 3A] Logo path: ${_logoFile!.path}');

//         final response = await request.send();
//         final responseBody = await response.stream.bytesToString();

//         debugPrint('[STEP 3A] Status: ${response.statusCode}');
//         debugPrint('[STEP 3A] Body: $responseBody');

//         if (response.statusCode != 200) {
//           throw Exception('Image edit failed');
//         }

//         final json = jsonDecode(responseBody);

//         // ✅ Image is BASE64, not URL
//         final base64Image = json['data']?[0]?['b64_json'];

//         if (base64Image == null) {
//           throw Exception('No image data returned from edit API');
//         }

//         final imageBytes = base64Decode(base64Image);

//         setState(() {
//           _messages.removeLast(); // remove loading
//           _messages.add({'role': 'bot', 'type': 'image', 'image': imageBytes});
//         });
//       } else {
//         // ---------------- IMAGE GENERATION ----------------
//         debugPrint('[STEP 3B] Using image generation endpoint');

//         final imagePayload = {
//           "model": "gpt-image-1",
//           "prompt": enhancedPrompt,
//           "size": "1024x1024",
//           "response_format": "b64_json",
//         };

//         final imageResponse = await http.post(
//           Uri.parse('https://api.openai.com/v1/images/generations'),
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $openAiKey",
//           },
//           body: jsonEncode(imagePayload),
//         );

//         debugPrint('[STEP 3B] Status: ${imageResponse.statusCode}');
//         debugPrint('[STEP 3B] Body: ${imageResponse.body}');

//         if (imageResponse.statusCode != 200) {
//           throw Exception('Image generation failed');
//         }

//         final imageJson = jsonDecode(imageResponse.body);
//         final base64Image = imageJson['data']?[0]?['b64_json'];

//         if (base64Image == null) {
//           throw Exception('No image data received');
//         }

//         final imageBytes = base64Decode(base64Image);

//         setState(() {
//           _messages.removeLast();
//           _messages.add({'role': 'bot', 'type': 'image', 'image': imageBytes});
//         });
//       }

//       debugPrint('================= AI POSTER FLOW SUCCESS =================');
//     } catch (e, stack) {
//       debugPrint('❌ ERROR: $e');
//       debugPrint('STACK TRACE:\n$stack');

//       setState(() {
//         if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
//           _messages.removeLast();
//         }
//         _messages.add({
//           'role': 'bot',
//           'text': 'Failed to generate poster.\n$e',
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




Future<void> _generatePosterWithAI(String userPrompt) async {
  debugPrint('================= GEMINI POSTER FLOW START =================');

  setState(() {
    _messages.add({'role': 'user', 'text': userPrompt, 'type': 'text'});
    _isLoading = true;
    _messageController.clear();
  });

  _scrollToBottom();

  try {
    // ======================================================
    // STEP 1: ENHANCE PROMPT via Gemini Chat
    // ======================================================
    debugPrint('[STEP 1] Enhancing prompt with Gemini');

    final enhanceResponse = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${dotenv.env['OPEN_AI_KEY']}',
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text":
                    "You are a professional prompt engineer. Convert the user's simple request into a detailed, vivid image generation prompt. Include colors, style, composition, lighting, and specific visual details. Keep it under 150 words. Only return the enhanced prompt, nothing else.\n\nUser request: $userPrompt",
              }
            ],
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "maxOutputTokens": 300,
        },
      }),
    );

    debugPrint('[STEP 1] Status: ${enhanceResponse.statusCode}');

    if (enhanceResponse.statusCode != 200) {
      throw Exception('Prompt enhancement failed: ${enhanceResponse.body}');
    }

    final enhanceJson = jsonDecode(enhanceResponse.body);
    final enhancedPrompt =
        enhanceJson['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

    if (enhancedPrompt.isEmpty) {
      throw Exception('Enhanced prompt is empty');
    }

    debugPrint('[STEP 1] Enhanced: $enhancedPrompt');

    setState(() {
      _messages.add({
        'role': 'bot',
        'text': '✨ Enhanced prompt:\n\n$enhancedPrompt',
        'type': 'text',
      });
    });

    _scrollToBottom();

    // ======================================================
    // STEP 2: SHOW LOADING PLACEHOLDER
    // ======================================================
    setState(() {
      _messages.add({
        'role': 'bot',
        'text': 'Generating image...',
        'type': 'loading',
      });
    });

    _scrollToBottom();

    // ======================================================
    // STEP 3: IMAGE GENERATION via Gemini imagen model
    // ======================================================
    debugPrint('[STEP 3] Generating image with Gemini imagen');

    // Build the final prompt (include logo instruction if logo is selected)
    final String finalPrompt = _logoFile != null
        ? '''Create a professional poster. Place the company logo prominently at the top center. $enhancedPrompt'''
        : enhancedPrompt;

    // Prepare content parts
    final List<Map<String, dynamic>> imageParts = [];

    // If logo is selected, send it as inline image data
    if (_logoFile != null) {
      final logoBytes = await _logoFile!.readAsBytes();
      final logoBase64 = base64Encode(logoBytes);
      final ext = _logoFile!.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      imageParts.add({
        "inlineData": {
          "mimeType": mimeType,
          "data": logoBase64,
        }
      });
    }

    imageParts.add({"text": finalPrompt});

    final imageResponse = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=${dotenv.env['GEMINI_API_KEY']}',
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": imageParts,
          }
        ],
        "generationConfig": {
          "responseModalities": ["TEXT", "IMAGE"],
        },
      }),
    );

    debugPrint('[STEP 3] Status: ${imageResponse.statusCode}');

    if (imageResponse.statusCode != 200) {
      throw Exception('Image generation failed: ${imageResponse.body}');
    }

    final imageJson = jsonDecode(imageResponse.body);
    final parts =
        imageJson['candidates']?[0]?['content']?['parts'] as List<dynamic>?;

    if (parts == null || parts.isEmpty) {
      throw Exception('No content returned from Gemini image generation');
    }

    // Find the image part in the response
    String? base64Image;
    for (final part in parts) {
      if (part['inlineData'] != null) {
        base64Image = part['inlineData']['data'];
        break;
      }
    }

    if (base64Image == null) {
      throw Exception('No image data found in Gemini response');
    }

    final imageBytes = base64Decode(base64Image);

    setState(() {
      _messages.removeLast(); // remove loading
      _messages.add({'role': 'bot', 'type': 'image', 'image': imageBytes});
    });

    debugPrint('================= GEMINI POSTER FLOW SUCCESS =================');
  } catch (e, stack) {
    debugPrint('❌ ERROR: $e');
    debugPrint('STACK: $stack');

    setState(() {
      if (_messages.isNotEmpty && _messages.last['type'] == 'loading') {
        _messages.removeLast();
      }
      _messages.add({
        'role': 'bot',
        'text': 'Failed to generate poster.\n$e',
        'type': 'text',
      });
    });
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }
}


  Future<void> _downloadImage(Uint8List imageBytes) async {
    try {
      // Save to temporary file first
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await tempFile.writeAsBytes(imageBytes);

      // Save to gallery using gal
      await Gal.putImage(tempFile.path);

      // Delete temp file
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
      final file = await File(
        '${tempDir.path}/poster_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Check out this poster created with Chicha AI!');
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
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    if (message['type'] == 'loading') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Generating your image...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF667EEA),
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        message['image'] as Uint8List,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () =>
                            _downloadImage(message['image'] as Uint8List),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Download'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF667EEA),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () =>
                            _shareImage(message['image'] as Uint8List),
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text('Share'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF667EEA),
                        ),
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
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? const Color(0xFF667EEA).withOpacity(0.3)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message['text'] ?? '',
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF2D3748),
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF4FD1C5), Color(0xFF3182CE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4FD1C5).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            AppText(
              _isImageGenerationMode
                  ? 'Create Amazing Posters'
                  : 'chat_with_chicha',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppText(
              _isImageGenerationMode
                  ? 'Describe your poster and let AI create it'
                  : 'ask_me_anything',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
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
              ),
            ),
            const SizedBox(width: 12),
            AppText(
              _isImageGenerationMode ? 'Post with Chicha' : 'chat_with_chicha',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          InkWell(
            onTap: _toggleImageGenerationMode,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isImageGenerationMode ? Icons.chat : Icons.image,
                    size: 22,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    _isImageGenerationMode ? 'Chat' : 'poster',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _logoFile!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Logo selected',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _logoFile = null),
                    color: Colors.grey[600],
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
                    itemBuilder: (context, index) {
                      return _buildMessage(_messages[index]);
                    },
                  ),
          ),
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF667EEA),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isImageGenerationMode
                          ? 'Creating magic...'
                          : 'AI analyzing',
                      style: TextStyle(
                        color: Colors.grey[700],
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
                    if (_isImageGenerationMode) ...[
                      // OutlinedButton.icon(
                      //   onPressed: _pickLogo,
                      //   icon: const Icon(Icons.image, size: 18),
                      //   label: Text(
                      //     _logoFile == null
                      //         ? 'Add Logo (Optional)'
                      //         : 'Change Logo',
                      //     style: const TextStyle(fontSize: 14),
                      //   ),
                      //   style: OutlinedButton.styleFrom(
                      //     foregroundColor: const Color(0xFF667EEA),
                      //     side: const BorderSide(color: Color(0xFF667EEA)),
                      //     padding: const EdgeInsets.symmetric(vertical: 12),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FAFC),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: TextField(
                              controller: _messageController,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                              decoration: InputDecoration(
                                hintText: _isImageGenerationMode
                                    ? AppText.translate(
                                        context,
                                        'describe_poster',
                                      )
                                    : AppText.translate(
                                        context,
                                        'ask_me_anything',
                                      ),
                                // hintText: _isImageGenerationMode
                                //     ? 'Describe your poster...'
                                //     : 'Ask me anything...',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 15,
                                ),
                              ),
                              minLines: 1,
                              maxLines: 4,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF667EEA).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: _isLoading ? null : _sendMessage,
                            icon: Icon(
                              _isImageGenerationMode
                                  ? Icons.auto_awesome
                                  : Icons.send_rounded,
                              size: 22,
                            ),
                            color: Colors.white,
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
              backgroundColor: const Color(0xFF667EEA),
              elevation: 6,
              tooltip: _logoFile == null ? 'Add Logo' : 'Change Logo',
              child: Icon(
                _logoFile == null ? Icons.add_photo_alternate : Icons.edit,
                color: Colors.white,
                size: 26,
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
