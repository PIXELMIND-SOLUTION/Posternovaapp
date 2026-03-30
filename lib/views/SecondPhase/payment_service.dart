import 'dart:io';
import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // 🔥 IMPORTANT
import 'package:posternova/constants/api_constant.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';

// Add your Razorpay key here
final razorpayKey = dotenv.env['RAZORPAY_KEY'];

class PaymentService {
  Razorpay _razorpay = Razorpay();

  final VoidCallback? onSuccess;
  final VoidCallback? onFailure;
  final Function(String)? onError;

  PaymentService({this.onSuccess, this.onFailure, this.onError}) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> initiatePayment({
    required String userId,
    required String itemName,
    required String itemId,
    required double amount,
    required File mediaFile,
    String? appName,
    Function(String)? onError,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/payfordownloads/$userId'),
      );

      request.fields['itemName'] = "poster";
      request.fields['itemId'] = itemId;
      request.fields['amount'] = amount.toString();

      // 🔥 DETECT FILE TYPE
      String ext = mediaFile.path.split('.').last.toLowerCase();

      MediaType mediaType;

      if (ext == 'png') {
        mediaType = MediaType('image', 'png');
      } else if (['jpg', 'jpeg'].contains(ext)) {
        mediaType = MediaType('image', 'jpeg');
      } else if (ext == 'webp') {
        mediaType = MediaType('image', 'webp');
      } else if (ext == 'gif') {
        mediaType = MediaType('image', 'gif');
      } else if (ext == 'mp4') {
        mediaType = MediaType('video', 'mp4');
      } else {
        throw Exception("Unsupported file type: $ext");
      }

      print("🔥 SENDING MIME TYPE: $mediaType");

      // 🔥 ADD FILE WITH CORRECT MIME TYPE
      request.files.add(
        await http.MultipartFile.fromPath(
          'media',
          mediaFile.path,
          contentType: mediaType, // 🔥 CRITICAL FIX
        ),
      );

      // 🔥 DEBUG LOGS
      print("========== PAYMENT PAYLOAD ==========");
      print("URL: ${ApiConstants.baseUrl}/payfordownloads/$userId");
      print("itemName: $itemName");
      print("itemId: $itemId");
      print("amount: $amount");
      print("file path: ${mediaFile.path}");
      print("file size: ${await mediaFile.length()} bytes");
      print("file ext: $ext");
      print("mime: $mediaType");
      print("=====================================");

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      print("========== PAYMENT RESPONSE ==========");
      print("Status Code: ${response.statusCode}");
      print("Response Body: $responseData");
      print("=====================================");

      if (jsonResponse['success'] == true) {
        String userPaymentId = jsonResponse['payment']['_id'];

        // var options = {
        //   'key': razorpayKey,
        //   'amount': (amount * 100).toInt(),
        //   'name': appName ?? 'PosterNova',
        //   'order_id': userPaymentId,
        //   'description': '$itemName Payment',
        //   'prefill': {'contact': '', 'email': ''},
        //   'theme': {'color': '#F5C518'},
        // };

        var options = {
          'key': razorpayKey,
          'amount': (amount * 100).toInt(), // Amount in paise
          'currency': 'INR',
          'name': 'EDITEZY',
          'description': 'Poster',
          'notes': {
            'userPaymentId': userPaymentId, // Important for webhook linking
          },
          'retry': {'enabled': true, 'max_count': 1},
          'send_sms_hash': true,
          'prefill': {
            'contact': "6303092897",
            'email': "info@pixelmindsolutions.com",
          },
          'external': {
            'wallets': ['paytm'],
          },
        };

        print("========== RAZORPAY OPTIONS ==========");
        print(json.encode(options));
        print("=====================================");

        _razorpay.open(options);
      } else {
        throw Exception(jsonResponse['message'] ?? 'Payment failed');
      }
    } catch (e) {
      print("========== PAYMENT ERROR ==========");
      print("Error: $e");
      print("=====================================");
      if (onError != null) onError!(e.toString());
      rethrow;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success: ${response.paymentId}");
    if (onSuccess != null) onSuccess!();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.message}");
    if (onFailure != null) onFailure!();
    if (onError != null) onError!(response.message ?? 'Payment failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
    if (onSuccess != null) onSuccess!();
  }

  void dispose() {
    _razorpay.clear();
  }
}
