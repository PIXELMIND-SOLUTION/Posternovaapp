// lib/services/auth/google_auth_service.dart
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:posternova/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/network_helper.dart';
import 'dart:io';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Google Sign-In data that will be sent to backend
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled sign-in
        return null;
      }

      // Get authentication details from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get user details from Google
      final String? displayName = googleUser.displayName;
      final String email = googleUser.email;
      final String? photoUrl = googleUser.photoUrl;
      final String id = googleUser.id;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      // Get Firebase ID token for backend verification
      final String? firebaseIdToken = await userCredential.user?.getIdToken();

      // Prepare data to send to backend
      final Map<String, dynamic> googleData = {
        'provider': 'google',
        'firebaseIdToken': firebaseIdToken,
        'google': {
          'id': id,
          'email': email,
          'name': displayName,
          'photoUrl': photoUrl,
          'accessToken': googleAuth.accessToken,
          'idToken': googleAuth.idToken,
        },
      };

      return googleData;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      throw _handleFirebaseAuthError(e);
    } on SocketException catch (e) {
      print('Network Error: $e');
      throw 'Please check your internet connection';
    } catch (e) {
      print('Google Sign-In Error: $e');
      throw 'Google Sign-In failed: ${e.toString()}';
    }
  }

  // Send Google data to backend
  Future<http.Response?> sendGoogleDataToBackend(
    Map<String, dynamic> googleData,
    String fcmToken,
  ) async {
    try {
      final requestBody = {
        "provider": "google",
        "firebaseIdToken": googleData["firebaseIdToken"],
        "fcmToken": fcmToken,
      };

      print("Request Body: $requestBody");

      final response = await http.post(
        Uri.parse(ApiConstants.googleSignIn),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      return response;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  // Sign out from Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'Account already exists with a different credential';
      case 'invalid-credential':
        return 'Invalid credential';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      case 'user-disabled':
        return 'User has been disabled';
      case 'user-not-found':
        return 'User not found';
      case 'wrong-password':
        return 'Wrong password';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}
