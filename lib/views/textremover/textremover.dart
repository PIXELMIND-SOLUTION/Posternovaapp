// import 'dart:io';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class WebViewScreen extends StatefulWidget {
//   final String url;

//   const WebViewScreen({super.key, required this.url});

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late final WebViewController _controller;
//   bool isLoading = true;
//   String? errorMessage;
//   double progress = 0;
//   final ImagePicker _picker = ImagePicker();

//   // Track consecutive errors to avoid false positives
//   int _errorCount = 0;
//   bool _pageLoadedOnce = false;

//   @override
//   void initState() {
//     super.initState();
//     _initWebView();
//   }

//   void _initWebView() {
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..enableZoom(true)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             setState(() {
//               isLoading = true;
//               errorMessage = null;
//               progress = 0;
//             });
//           },
//           onProgress: (p) {
//             setState(() => progress = p / 100);
//           },
//           onPageFinished: (url) {
//             setState(() {
//               isLoading = false;
//               _pageLoadedOnce = true;
//               _errorCount = 0;
//             });
//             _injectJavaScriptHandlers();
//           },
//           onWebResourceError: (error) {
//             // Ignore sub-resource errors (ads, trackers, fonts, etc.)
//             // Only show error if the MAIN frame fails
//             if (error.isForMainFrame == true) {
//               _errorCount++;
//               // Small delay to check if page still loads despite the error
//               Future.delayed(const Duration(seconds: 2), () {
//                 if (mounted && !_pageLoadedOnce && _errorCount > 0) {
//                   setState(() {
//                     isLoading = false;
//                     errorMessage =
//                         "Could not load page.\nPlease check your connection.";
//                   });
//                 }
//               });
//             }
//           },
//           // REMOVED onHttpError — it fires for redirects and sub-resources too
//         ),
//       );

//     // ✅ Fix for Android file upload — must be set BEFORE loadRequest
//     _setupAndroidFileChooser();

//     _controller.addJavaScriptChannel(
//       'FileUploadChannel',
//       onMessageReceived: (JavaScriptMessage message) {
//         _showImagePickerOptions();
//       },
//     );

//     _controller.loadRequest(Uri.parse(widget.url));
//   }

//   /// ✅ Key fix: Android needs explicit file chooser setup
//   void _setupAndroidFileChooser() {
//     if (Platform.isAndroid) {
//       final androidController =
//           _controller.platform as AndroidWebViewController;
//       AndroidWebViewController.enableDebugging(false);
//       androidController.setOnShowFileSelector((
//         FileSelectorParams params,
//       ) async {
//         await _requestPermissions();
//         final result = await _showFilePickerDialog(params);
//         return result;
//       });
//     }
//   }

//   /// Shows picker and returns selected file URIs for Android's file chooser
//   Future<List<String>> _showFilePickerDialog(FileSelectorParams params) async {
//     final List<String> result = [];

//     await showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (ctx) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 10),
//             ListTile(
//               leading: const Icon(Icons.photo_library, size: 30),
//               title: const Text('Choose from Gallery'),
//               onTap: () async {
//                 Navigator.pop(ctx);
//                 final XFile? image = await _picker.pickImage(
//                   source: ImageSource.gallery,
//                   maxWidth: 1920,
//                   maxHeight: 1920,
//                   imageQuality: 85,
//                 );
//                 if (image != null) result.add('file://${image.path}');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt, size: 30),
//               title: const Text('Take a Photo'),
//               onTap: () async {
//                 Navigator.pop(ctx);
//                 final XFile? image = await _picker.pickImage(
//                   source: ImageSource.camera,
//                   maxWidth: 1920,
//                   maxHeight: 1920,
//                   imageQuality: 85,
//                 );
//                 if (image != null) result.add('file://${image.path}');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.insert_drive_file, size: 30),
//               title: const Text('Choose File'),
//               onTap: () async {
//                 Navigator.pop(ctx);
//                 final r = await FilePicker.pickFiles(
//                   type: FileType.custom,
//                   allowedExtensions: [
//                     'jpg',
//                     'jpeg',
//                     'png',
//                     'gif',
//                     'pdf',
//                     'doc',
//                     'docx',
//                     'txt',
//                   ],
//                 );
//                 if (r != null && r.files.single.path != null) {
//                   result.add('file://${r.files.single.path}');
//                 }
//               },
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );

//     return result;
//   }

//   Future<void> _injectJavaScriptHandlers() async {
//     const jsCode = '''
//       (function() {
//         function setupFileInputs() {
//           const fileInputs = document.querySelectorAll('input[type="file"]');
//           fileInputs.forEach(function(input) {
//             if (!input.hasAttribute('data-flutter-handler')) {
//               input.setAttribute('data-flutter-handler', 'true');
//             }
//           });
//         }
//         setupFileInputs();
//         const observer = new MutationObserver(() => setupFileInputs());
//         observer.observe(document.body, { childList: true, subtree: true });
//       })();
//     ''';
//     await _controller.runJavaScript(jsCode);
//   }

//   Future<void> _showImagePickerOptions() async {
//     await _requestPermissions();
//     await _showFilePickerDialog(
//       FileSelectorParams(
//         isCaptureEnabled: true,
//         acceptTypes: ['image/*'],
//         mode: FileSelectorMode.open,
//       ),
//     );
//   }

//   Future<void> _requestPermissions() async {
//     if (Platform.isAndroid) {
//       await Permission.camera.request();
//       // Android 13+ uses granular media permissions
//       if (await Permission.photos.isDenied) {
//         await Permission.photos.request();
//       } else {
//         await Permission.storage.request();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("WebView"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 errorMessage = null;
//                 _pageLoadedOnce = false;
//                 _errorCount = 0;
//               });
//               _controller.reload();
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),

//           if (isLoading && progress < 1 && progress > 0)
//             LinearProgressIndicator(value: progress),

//           if (errorMessage != null)
//             Container(
//               color: Colors.white,
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.error_outline,
//                         size: 60,
//                         color: Colors.red,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(errorMessage!, textAlign: TextAlign.center),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             errorMessage = null;
//                             isLoading = true;
//                             _errorCount = 0;
//                             _pageLoadedOnce = false;
//                           });
//                           _controller.reload();
//                         },
//                         child: const Text("Retry"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text Remover"), centerTitle: true),
      // body: InAppWebView(
      //   initialUrlRequest: URLRequest(
      //     url: WebUri("https://api.editezy.com/test-api"),
      //   ),

      //   initialSettings: InAppWebViewSettings(
      //     javaScriptEnabled: true,
      //     domStorageEnabled: true,

      //     // 🔥 CRITICAL FIXES
      //     useHybridComposition: true,
      //     allowFileAccess: true,
      //     allowContentAccess: true,
      //     mediaPlaybackRequiresUserGesture: false,

      //     mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      //   ),

      //   /// ✅ VERY IMPORTANT (permissions)
      //   androidOnPermissionRequest: (controller, origin, resources) async {
      //     return PermissionRequestResponse(
      //       resources: resources,
      //       action: PermissionRequestResponseAction.GRANT,
      //     );
      //   },

      //   onConsoleMessage: (controller, msg) {
      //     print("JS LOG: ${msg.message}");
      //   },
      // ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://api.editezy.com/test-api"),
        ),

        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          domStorageEnabled: true,
          useHybridComposition: true,
          allowFileAccess: true,
          allowContentAccess: true,
          mediaPlaybackRequiresUserGesture: false,
          mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
        ),

        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },

        /// 🔥 ADD THIS (IMPORTANT)
        onDownloadStartRequest: (controller, request) async {
          final url = request.url.toString();

          print("Download URL: $url");

          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        },

        onConsoleMessage: (controller, msg) {
          print("JS LOG: ${msg.message}");
        },
      ),
    );
  }
}
