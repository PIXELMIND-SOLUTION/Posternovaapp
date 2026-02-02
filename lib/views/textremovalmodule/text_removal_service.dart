import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AiTextRemovalService {
  static const String baseUrl =
      'http://31.97.206.144:4061/api/poster/removaltext';

  static Future<String> removeText({
    required String userId,
    required Uint8List image,
    required Uint8List mask,
  }) async {
    final uri = Uri.parse('$baseUrl/$userId');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        image,
        filename: 'image.png',
        contentType: MediaType('image', 'png'),
      ),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'mask',
        mask,
        filename: 'mask.png',
        contentType: MediaType('image', 'png'),
      ),
    );

    final response = await request.send();
    final responseBytes = await response.stream.toBytes();


    print('Response status code for text editor ${response.statusCode}');


    if (response.statusCode != 200) {
      throw Exception(
        'Backend failed: ${utf8.decode(responseBytes)}',
      );
    }

    final json = jsonDecode(utf8.decode(responseBytes));
    return json['imageUrl']; // ✅ Cloudinary URL
  }
}