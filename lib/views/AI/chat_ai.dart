
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:posternova/widgets/language_widget.dart';
// import 'dart:convert';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:permission_handler/permission_handler.dart';

// class AiScreen extends StatefulWidget {
//   const AiScreen({super.key});

//   @override
//   State<AiScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<AiScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, String>> _messages = [];
//   bool _isLoading = false;
//   final ScrollController _scrollController = ScrollController();

//   stt.SpeechToText? _speech; // nullable to avoid LateInitializationError
//   bool _isListening = false;
//   bool _speechAvailable = false;
//   String _lastError = '';

//   static const String apiKey = 'AIzaSyCOi06p94fKvs4Qpy_hOZezoZW9QO-qU3o';
//   static const String apiUrl =
//       "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent$apiKey";

//   @override
//   void initState() {
//     super.initState();
//     // Ensure we request permission first and only initialize if granted.
//     _prepareSpeech();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       setState(() {
//         // _messages.add({
//         //   'role': 'bot',
//         //   'text': AppText.translate(context, 'ai_welcome_message')
//         // });
//       });
//     });
//   }

//   // Request microphone permission, then create & initialize speech instance.
//   Future<void> _prepareSpeech() async {
//     try {
//       final status = await Permission.microphone.status;
//       if (!status.isGranted) {
//         final result = await Permission.microphone.request();
//         if (!result.isGranted) {
//           setState(() {
//             // _lastError = 'Microphone permission denied. Enable in settings.';
//             _speechAvailable = false;
//           });
//           return;
//         }
//       }

//       // Create instance (only once)
//       _speech ??= stt.SpeechToText();
//       await _initSpeech();
//     } catch (e, st) {
//       debugPrint('Error preparing speech: $e\n$st');
//       setState(() {
//         _lastError = 'Error preparing speech: $e';
//         _speechAvailable = false;
//       });
//     }
//   }

//   Future<void> _initSpeech() async {
//     if (_speech == null) {
//       setState(() {
//         _lastError = 'Speech instance not created';
//         _speechAvailable = false;
//       });
//       return;
//     }

//     try {
//       final available = await _speech!.initialize(
//         onStatus: (status) {
//           debugPrint('Speech status: $status');
//           if (status == 'done' || status == 'notListening') {
//             if (mounted) setState(() => _isListening = false);
//           }
//         },
//         onError: (errorNotification) {
//           debugPrint('Speech error: ${errorNotification.errorMsg}');
//           if (mounted) {
//             setState(() {
//               _lastError = errorNotification.errorMsg ?? 'Unknown speech error';
//               _isListening = false;
//             });
//           }
//         },
//       );

//       if (!mounted) return;
//       setState(() {
//         _speechAvailable = available;
//         if (!available) _lastError = 'Speech recognition not available';
//       });
//     } catch (e, st) {
//       debugPrint('Failed to initialize speech: $e\n$st');
//       if (mounted) {
//         setState(() {
//           _lastError = 'Failed to initialize speech: $e';
//           _speechAvailable = false;
//         });
//       }
//     }
//   }

//   void _listen() async {
//     // Guard: ensure instance exists and availability is true
//     if (_speech == null) {
//       setState(() => _lastError = 'Speech instance not ready. Try again.');
//       return;
//     }
//     if (!_speechAvailable) {
//       setState(() => _lastError = 'Microphone not available or permission not granted.');
//       return;
//     }

//     if (_isListening) {
//       try {
//         await _speech!.stop();
//       } catch (e) {
//         debugPrint('Error stopping speech: $e');
//       }
//       if (mounted) setState(() => _isListening = false);
//       return;
//     }

//     // Start listening
//     if (mounted) setState(() {
//       _lastError = '';
//       _isListening = true;
//     });

//     try {
//       await _speech!.listen(
//         onResult: (result) {
//           if (!mounted) return;
//           setState(() {
//             _messageController.text = result.recognizedWords;
//           });
//         },
//         listenFor: const Duration(seconds: 60),
//         pauseFor: const Duration(seconds: 3),
//         partialResults: true,
//         localeId: null,
//       );
//     } catch (e) {
//       debugPrint('Error starting listen: $e');
//       if (mounted) {
//         setState(() {
//           _isListening = false;
//           _lastError = 'Error starting listen: $e';
//         });
//       }
//     }
//   }

//   Future<void> _sendMessage() async {
//     final userMessage = _messageController.text.trim();
//     if (userMessage.isEmpty) return;

//     setState(() {
//       _messages.add({'role': 'user', 'text': userMessage});
//       _isLoading = true;
//       _messageController.clear();
//     });

//     _scrollToBottom();

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "contents": [
//             {
//               "parts": [
//                 {"text": userMessage}
//               ]
//             }
//           ]
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final botReply = data['candidates'][0]['content']['parts'][0]['text'];

//         setState(() {
//           _messages.add({'role': 'bot', 'text': botReply});
//         });
//       } else {
//         setState(() {
//           _messages.add({'role': 'bot', 'text': 'Sorry, I encountered an error. Please try again.'});
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _messages.add({'role': 'bot', 'text': 'Connection issue. Please check your internet and try again.'});
//       });
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//         _scrollToBottom();
//       }
//     }
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   Widget _buildMessage(Map<String, String> message) {
//     final isUser = message['role'] == 'user';
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           if (!isUser)
//             Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                 color: Colors.blue[700],
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
//             ),
//           const SizedBox(width: 8),
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 color: isUser ? Colors.blue[700] : Colors.grey[100],
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(16),
//                   topRight: const Radius.circular(16),
//                   bottomLeft: Radius.circular(isUser ? 16 : 4),
//                   bottomRight: Radius.circular(isUser ? 4 : 16),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 2,
//                     offset: const Offset(0, 1),
//                   )
//                 ],
//               ),
//               child: Text(
//                 message['text'] ?? '',
//                 style: TextStyle(
//                   color: isUser ? Colors.white : Colors.grey[800],
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//           if (isUser)
//             const SizedBox(width: 8),
//           if (isUser)
//             Container(
//               width: 30,
//               height: 30,
//               decoration: const BoxDecoration(
//                 color: Colors.blueAccent,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.person, color: Colors.white, size: 16),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           }, 
//           icon: const Icon(Icons.arrow_back_ios, size: 20),
//         ),
//         title: Text(
//           AppText.translate(context, 'chat_with_ai'),
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//         elevation: 2,
//         shadowColor: Colors.black.withOpacity(0.1),
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 16),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     AppText.translate(context, 'ai_assistant_tip'),
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 13,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (_lastError.isNotEmpty)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               color: Colors.orange[50],
//               child: Row(
//                 children: [
//                   Icon(Icons.error_outline, color: Colors.orange[700], size: 16),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       _lastError,
//                       style: TextStyle(
//                         color: Colors.orange[700],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           Expanded(
//             child: Container(
//               color: Colors.grey[50],
//               child: _messages.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.chat_bubble_outline, 
//                               size: 64, color: Colors.grey[300]),
//                           const SizedBox(height: 16),
//                           Text(
//                             AppText.translate(context, 'start_conversation'),
//                             style: TextStyle(
//                               color: Colors.grey[500],
//                               fontSize: 16,
//                             ),
//                           ),
//                           if (!_speechAvailable)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 16),
//                               // child: Text(
//                               //   'Microphone access not available',
//                               //   style: TextStyle(
//                               //     color: Colors.red[300],
//                               //     fontSize: 14,
//                               //   ),
//                               // ),
//                             ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.all(16),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         return _buildMessage(_messages[index]);
//                       },
//                     ),
//             ),
//           ),
//           if (_isLoading)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     AppText.translate(context, 'ai_thinking'),
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(top: BorderSide(color: Colors.grey[200]!)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, -2),
//                 )
//               ],
//             ),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               children: [
//                 // Container(
//                 //   decoration: BoxDecoration(
//                 //     color: _speechAvailable ? Colors.grey[100] : Colors.grey[200],
//                 //     borderRadius: BorderRadius.circular(20),
//                 //   ),
//                 //   child: IconButton(
//                 //     icon: Icon(
//                 //       _isListening ? Icons.mic_off : Icons.mic, 
//                 //       size: 22,
//                 //       color: _speechAvailable 
//                 //         ? (_isListening ? Colors.red : Colors.blue[700])
//                 //         : Colors.grey,
//                 //     ),
//                 //     onPressed: _speechAvailable ? _listen : () async {
//                 //       // Try re-preparing speech if user taps mic while unavailable
//                 //       await _prepareSpeech();
//                 //     },
//                 //     splashRadius: 20,
//                 //   ),
//                 // ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: TextField(
//                       controller: _messageController,
//                       textInputAction: TextInputAction.send,
//                       onSubmitted: (_) => _sendMessage(),
//                       decoration: InputDecoration(
//                         hintText: AppText.translate(context, 'ask_me_anything'),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                       ),
//                       minLines: 1,
//                       maxLines: 3,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.blue[700],
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     onPressed: _sendMessage,
//                     icon: const Icon(Icons.send, size: 22),
//                     color: Colors.white,
//                     splashRadius: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     _speech?.stop();
//     super.dispose();
//   }
// }









import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/widgets/language_widget.dart';
import 'dart:convert';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<AiScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  stt.SpeechToText? _speech;
  bool _isListening = false;
  bool _speechAvailable = false;
  String _lastError = '';

  static const String apiKey = 'AIzaSyCOi06p94fKvs4Qpy_hOZezoZW9QO-qU3o';
  static const String apiUrl =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _prepareSpeech();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> _prepareSpeech() async {
    try {
      final status = await Permission.microphone.status;
      if (!status.isGranted) {
        final result = await Permission.microphone.request();
        if (!result.isGranted) {
          setState(() {
            _speechAvailable = false;
          });
          return;
        }
      }

      _speech ??= stt.SpeechToText();
      await _initSpeech();
    } catch (e, st) {
      debugPrint('Error preparing speech: $e\n$st');
      setState(() {
        _lastError = 'Error preparing speech: $e';
        _speechAvailable = false;
      });
    }
  }

  Future<void> _initSpeech() async {
    if (_speech == null) {
      setState(() {
        _lastError = 'Speech instance not created';
        _speechAvailable = false;
      });
      return;
    }

    try {
      final available = await _speech!.initialize(
        onStatus: (status) {
          debugPrint('Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          debugPrint('Speech error: ${errorNotification.errorMsg}');
          if (mounted) {
            setState(() {
              _lastError = errorNotification.errorMsg ?? 'Unknown speech error';
              _isListening = false;
            });
          }
        },
      );

      if (!mounted) return;
      setState(() {
        _speechAvailable = available;
        if (!available) _lastError = 'Speech recognition not available';
      });
    } catch (e, st) {
      debugPrint('Failed to initialize speech: $e\n$st');
      if (mounted) {
        setState(() {
          _lastError = 'Failed to initialize speech: $e';
          _speechAvailable = false;
        });
      }
    }
  }

  void _listen() async {
    if (_speech == null) {
      setState(() => _lastError = 'Speech instance not ready. Try again.');
      return;
    }
    if (!_speechAvailable) {
      setState(() => _lastError = 'Microphone not available or permission not granted.');
      return;
    }

    if (_isListening) {
      try {
        await _speech!.stop();
      } catch (e) {
        debugPrint('Error stopping speech: $e');
      }
      if (mounted) setState(() => _isListening = false);
      return;
    }

    if (mounted) setState(() {
      _lastError = '';
      _isListening = true;
    });

    try {
      await _speech!.listen(
        onResult: (result) {
          if (!mounted) return;
          setState(() {
            _messageController.text = result.recognizedWords;
          });
        },
        listenFor: const Duration(seconds: 60),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: null,
      );
    } catch (e) {
      debugPrint('Error starting listen: $e');
      if (mounted) {
        setState(() {
          _isListening = false;
          _lastError = 'Error starting listen: $e';
        });
      }
    }
  }

  // Future<void> _sendMessage() async {
  //   final userMessage = _messageController.text.trim();
  //   if (userMessage.isEmpty) return;

  //   setState(() {
  //     _messages.add({'role': 'user', 'text': userMessage});
  //     _isLoading = true;
  //     _messageController.clear();
  //   });

  //   _scrollToBottom();

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "contents": [
  //           {
  //             "parts": [
  //               {"text": userMessage}
  //             ]
  //           }
  //         ]
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final botReply = data['candidates'][0]['content']['parts'][0]['text'];

  //       setState(() {
  //         _messages.add({'role': 'bot', 'text': botReply});
  //       });
  //     } else {
  //       setState(() {
  //         _messages.add({'role': 'bot', 'text': 'Sorry, I encountered an error. Please try again.'});
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _messages.add({'role': 'bot', 'text': 'Connection issue. Please check your internet and try again.'});
  //     });
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       _scrollToBottom();
  //     }
  //   }
  // }


  Future<void> _sendMessage() async {
  final userMessage = _messageController.text.trim();
  if (userMessage.isEmpty) return;

  setState(() {
    _messages.add({'role': 'user', 'text': userMessage});
    _isLoading = true;
    _messageController.clear();
  });

  _scrollToBottom();

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": userMessage}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final botReply = data['candidates'][0]['content']['parts'][0]['text'];

      setState(() {
        _messages.add({'role': 'bot', 'text': botReply});
      });
    } else {
      // Log the actual error for debugging
      debugPrint('API Error: ${response.statusCode} - ${response.body}');
      setState(() {
        _messages.add({
          'role': 'bot', 
          'text': 'Sorry, I encountered an error (${response.statusCode}). Please try again.'
        });
      });
    }
  } catch (e) {
    debugPrint('Error sending message: $e');
    setState(() {
      _messages.add({
        'role': 'bot', 
        'text': 'Connection issue. Please check your internet and try again.'
      });
    });
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
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

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                  )
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
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
                  )
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
                  )
                ],
              ),
              child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
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
                  )
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
               'Start chat with AI',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 12),
            // Text(
            //   'Ask me anything and I\'ll help you out',
            //   style: TextStyle(
            //     fontSize: 15,
            //     color: Colors.grey[600],
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            const SizedBox(height: 32),
            // Wrap(
            //   spacing: 12,
            //   runSpacing: 12,
            //   alignment: WrapAlignment.center,
            //   children: [
            //     _buildSuggestionChip('Plan a trip', Icons.flight_takeoff),
            //     _buildSuggestionChip('Write an email', Icons.email_outlined),
            //     _buildSuggestionChip('Get ideas', Icons.lightbulb_outline),
            //     _buildSuggestionChip('Learn something', Icons.school_outlined),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label, IconData icon) {
    return InkWell(
      onTap: () {
        _messageController.text = label;
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF667EEA)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
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
              child: const Icon(Icons.auto_awesome, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              AppText.translate(context, 'chat_with_ai'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
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
      ),
      body: Column(
        children: [
          if (_lastError.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _lastError,
                      style: TextStyle(
                        color: Colors.orange[900],
                        fontSize: 13,
                      ),
                    ),
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
            )
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
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF667EEA),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                       'AI analyzing',
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
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _sendMessage(),
                                decoration: InputDecoration(
                                  hintText: AppText.translate(context, 'ask_me_anything'),
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
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
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
                          )
                        ],
                      ),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.send_rounded, size: 22),
                        color: Colors.white,
                        splashRadius: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    _speech?.stop();
    super.dispose();
  }
}