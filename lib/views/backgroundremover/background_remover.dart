import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class BackgroundRemoverScreen extends StatelessWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Background Remover"),
        centerTitle: true,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://api.editezy.com/bg-removal"),
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
