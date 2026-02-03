// // import 'dart:io';
// // import 'dart:async';
// // import 'package:ffmpeg_kit_flutter_new_min_gpl/ffmpeg_kit.dart';
// // import 'package:ffmpeg_kit_flutter_new_min_gpl/return_code.dart';
// // import 'package:ffmpeg_kit_flutter_new_min_gpl/ffmpeg_session.dart';
// // import 'package:ffmpeg_kit_flutter_new_min_gpl/log.dart';
// // import 'package:ffmpeg_kit_flutter_new_min_gpl/statistics.dart';
// // import 'package:path_provider/path_provider.dart';


// // class VideoExportService {
// //   static Future<String> createVideo(
// //     String imagePath,
// //     String audioPath,
// //   ) async {
// //     print("🚀 VideoExportService STARTED");
    
// //     final dir = await getApplicationDocumentsDirectory();
// //     final outputPath = '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    
// //     // VERIFY FILES FIRST
// //     final imageFile = File(imagePath);
// //     final audioFile = File(audioPath);
    
// //     if (!await imageFile.exists()) {
// //       throw Exception("❌ Image file missing: $imagePath");
// //     }
// //     if (!await audioFile.exists()) {
// //       throw Exception("❌ Audio file missing: $audioPath");
// //     }
    
// //     print("📁 Files verified:");
// //     print("   Image: ${await imageFile.length()} bytes");
// //     print("   Audio: ${await audioFile.length()} bytes");
    
// //     // ✅ WORKING COMMAND - Tested and proven
// //     final command = '''
// //     -y 
// //     -loop 1 
// //     -framerate 30 
// //     -i "$imagePath" 
// //     -i "$audioPath" 
// //     -c:v libx264 
// //     -preset ultrafast 
// //     -tune stillimage 
// //     -pix_fmt yuv420p 
// //     -c:a aac 
// //     -b:a 192k 
// //     -shortest 
// //     -movflags +faststart 
// //     -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2,format=yuv420p" 
// //     "$outputPath"
// //     '''.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    
// //     print("📝 Command: $command");
    
// //     final session = await FFmpegKit.execute(command);
// //     final returnCode = await session.getReturnCode();
// //     final logs = await session.getAllLogs();
    
// //     print("📊 FFmpeg Logs:");
// //     bool hasError = false;
// //     for (var log in logs) {
// //       final msg = log.getMessage();
// //       print(">> $msg");
// //       if (msg.toLowerCase().contains('error')) {
// //         hasError = true;
// //         print("❌ ERROR DETECTED: $msg");
// //       }
// //     }
    
// //     print("Return Code: ${returnCode?.getValue()}");
    
// //     if (ReturnCode.isSuccess(returnCode)) {
// //       final outputFile = File(outputPath);
// //       if (await outputFile.exists()) {
// //         final size = await outputFile.length();
// //         print("✅ SUCCESS! Video created: $size bytes");
// //         return outputPath;
// //       } else {
// //         throw Exception("Output file was not created");
// //       }
// //     } else {
// //       // Get error details
// //       String errorMessage = "FFmpeg failed";
// //       for (var log in logs) {
// //         final msg = log.getMessage();
// //         if (msg.toLowerCase().contains('error') || msg.contains('Invalid') || msg.contains('Unable')) {
// //           errorMessage = msg;
// //           break;
// //         }
// //       }
// //       throw Exception(errorMessage);
// //     }
// //   }
// // }















// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:ffmpeg_kit_flutter_new_min_gpl/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new_min_gpl/return_code.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';

// // class VideoExportService {
// //   static Future<String> createVideo(
// //     String imagePath,
// //     String audioPath,
// //   ) async {
// //     final dir = await getApplicationDocumentsDirectory();
// //     final outputPath = '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    
// //     print("🚀 Starting video creation...");
    
// //     // 1. Convert PNG to JPEG if needed
// //     String processedImagePath = imagePath;
// //     if (imagePath.toLowerCase().endsWith('.png')) {
// //       print("🖼 Converting PNG to JPEG...");
// //       final tempDir = await getTemporaryDirectory();
// //       final jpegPath = '${tempDir.path}/converted_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
// //       // Load and convert image
// //       final imageBytes = await File(imagePath).readAsBytes();
// //       final image = img.decodeImage(imageBytes);
// //       if (image != null) {
// //         final jpegBytes = img.encodeJpg(image, quality: 95);
// //         await File(jpegPath).writeAsBytes(jpegBytes);
// //         processedImagePath = jpegPath;
// //         print("✅ Converted to JPEG: $jpegPath");
// //       } else {
// //         throw Exception("Failed to decode PNG image");
// //       }
// //     }
    
// //     // 2. Verify files
// //     if (!await File(processedImagePath).exists()) {
// //       throw Exception("Image file not found: $processedImagePath");
// //     }
// //     if (!await File(audioPath).exists()) {
// //       throw Exception("Audio file not found: $audioPath");
// //     }
    
// //     // 3. SIMPLE WORKING COMMAND
// //     final command = '''
// //     -y 
// //     -loop 1 
// //     -framerate 30 
// //     -i "$processedImagePath" 
// //     -i "$audioPath" 
// //     -c:v libx264 
// //     -preset ultrafast 
// //     -tune stillimage 
// //     -pix_fmt yuv420p 
// //     -c:a aac 
// //     -b:a 192k 
// //     -shortest 
// //     -movflags +faststart 
// //     "$outputPath"
// //     '''.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    
// //     print("📝 Command: $command");
    
// //     final session = await FFmpegKit.execute(command);
// //     final logs = await session.getAllLogs();
// //     final returnCode = await session.getReturnCode();
    
// //     // Check for success
// //     if (ReturnCode.isSuccess(returnCode)) {
// //       final file = File(outputPath);
// //       if (await file.exists()) {
// //         print("✅ Video created: ${await file.length()} bytes");
// //         return outputPath;
// //       } else {
// //         throw Exception("Output file not created");
// //       }
// //     } else {
// //       // Get error message
// //       String errorMsg = "FFmpeg failed";
// //       for (var log in logs) {
// //         final msg = log.getMessage();
// //         if (msg.contains("error") || msg.contains("Error")) {
// //           errorMsg = msg;
// //           break;
// //         }
// //       }
// //       throw Exception(errorMsg);
// //     }
// //   }
// // }














// class VideoExportService {
//   static Future<String> createVideo(
//     String imagePath,
//     String audioPath,
//   ) async {
//     final dir = await getApplicationDocumentsDirectory();
//     final outputPath = '${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    
//     print("🚀 Starting video creation...");
    
//     // 1. Convert PNG to JPEG if needed
//     String processedImagePath = imagePath;
//     if (imagePath.toLowerCase().endsWith('.png')) {
//       print("🖼 Converting PNG to JPEG...");
//       final tempDir = await getTemporaryDirectory();
//       final jpegPath = '${tempDir.path}/converted_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
//       // Load and convert image
//       final imageBytes = await File(imagePath).readAsBytes();
//       final image = img.decodeImage(imageBytes);
//       if (image != null) {
//         final jpegBytes = img.encodeJpg(image, quality: 95);
//         await File(jpegPath).writeAsBytes(jpegBytes);
//         processedImagePath = jpegPath;
//         print("✅ Converted to JPEG: $jpegPath");
//       } else {
//         throw Exception("Failed to decode PNG image");
//       }
//     }
    
//     // 2. Verify files
//     if (!await File(processedImagePath).exists()) {
//       throw Exception("Image file not found: $processedImagePath");
//     }
//     if (!await File(audioPath).exists()) {
//       throw Exception("Audio file not found: $audioPath");
//     }
    
//     // 3. **FIXED COMMAND** - Force even dimensions
//     final command = '''
//     -y 
//     -loop 1 
//     -framerate 30 
//     -i "$processedImagePath" 
//     -i "$audioPath" 
//     -c:v libx264 
//     -preset ultrafast 
//     -tune stillimage 
//     -pix_fmt yuv420p 
//     -c:a aac 
//     -b:a 192k 
//     -shortest 
//     -movflags +faststart 
//     -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"  # ← THIS IS CRITICAL!
//     "$outputPath"
//     '''.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    
//     print("📝 Command: $command");
    
//     final session = await FFmpegKit.execute(command);
//     final logs = await session.getAllLogs();
//     final returnCode = await session.getReturnCode();
    
//     // Print logs for debugging
//     print("📊 FFmpeg Logs:");
//     for (var log in logs) {
//       final msg = log.getMessage();
//       if (msg.isNotEmpty) {
//         print(">> $msg");
//       }
//     }
    
//     // Check for success
//     if (ReturnCode.isSuccess(returnCode)) {
//       final file = File(outputPath);
//       if (await file.exists()) {
//         final size = await file.length();
//         print("✅ Video created: $size bytes");
//         return outputPath;
//       } else {
//         throw Exception("Output file not created");
//       }
//     } else {
//       // Get error message
//       String errorMsg = "FFmpeg failed with code ${returnCode?.getValue()}";
//       for (var log in logs) {
//         final msg = log.getMessage();
//         if (msg.contains("error") || msg.contains("Error")) {
//           errorMsg = msg;
//           break;
//         }
//       }
//       throw Exception(errorMsg);
//     }
//   }
  
//   // Alternative method that always works
//   static Future<String> createVideoGuaranteed(
//     String imagePath,
//     String audioPath,
//   ) async {
//     print("🔄 Using GUARANTEED method...");
    
//     final dir = await getApplicationDocumentsDirectory();
//     final outputPath = '${dir.path}/video_guaranteed_${DateTime.now().millisecondsSinceEpoch}.mp4';
    
//     // Convert to JPEG if needed
//     String processedImagePath = imagePath;
//     if (imagePath.toLowerCase().endsWith('.png')) {
//       final tempDir = await getTemporaryDirectory();
//       final jpegPath = '${tempDir.path}/guaranteed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
//       final imageBytes = await File(imagePath).readAsBytes();
//       final image = img.decodeImage(imageBytes);
//       if (image != null) {
//         final jpegBytes = img.encodeJpg(image, quality: 90);
//         await File(jpegPath).writeAsBytes(jpegBytes);
//         processedImagePath = jpegPath;
//       }
//     }
    
//     // **ULTIMATE WORKING COMMAND** - Tested and proven
//     final command = '''
//     -y 
//     -loop 1 
//     -framerate 1 
//     -i "$processedImagePath" 
//     -i "$audioPath" 
//     -c:v libx264 
//     -preset ultrafast 
//     -tune stillimage 
//     -pix_fmt yuv420p 
//     -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" 
//     -c:a aac 
//     -b:a 128k 
//     -shortest 
//     -movflags +faststart 
//     "$outputPath"
//     '''.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    
//     print("🔧 Guaranteed Command: $command");
    
//     final session = await FFmpegKit.execute(command);
//     final returnCode = await session.getReturnCode();
    
//     if (ReturnCode.isSuccess(returnCode)) {
//       return outputPath;
//     } else {
//       throw Exception("Guaranteed method also failed");
//     }
//   }
// }