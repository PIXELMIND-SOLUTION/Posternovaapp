// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ChatService {
//   static const String baseUrl = 'http://31.97.206.144:4061';
//   late final Dio _dio;
//   IO.Socket? _socket;
  
//   // Socket event callbacks
//   Function(Map<String, dynamic>)? onReceiveMessage;
//   Function(List)? onChatsFetched;
//   Function()? onConnected;
//   Function()? onDisconnected;

//   ChatService() {
//     _dio = Dio(BaseOptions(
//       baseUrl: baseUrl,
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//     ));
//   }

//   /// Initialize Socket.IO connection
//   void initSocket(String userId) {
//     print('🔌 Initializing socket for user: $userId');
    
//     _socket = IO.io(baseUrl, <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });

//     _socket!.connect();

//     // Connection events
//     _socket!.onConnect((_) {
//       print('✅ Socket connected');
//       onConnected?.call();
//     });

//     _socket!.onDisconnect((_) {
//       print('❌ Socket disconnected');
//       onDisconnected?.call();
//     });

//     _socket!.onConnectError((error) {
//       print('⚠️ Connection error: $error');
//     });

//     _socket!.onError((error) {
//       print('⚠️ Socket error: $error');
//     });

//     // Listen for 'receiveMessage' event (backend emits this)
//     _socket!.on('receiveMessage', (data) {
//       print('📨 Socket event - receiveMessage: $data');
//       if (data is Map<String, dynamic>) {
//         onReceiveMessage?.call(data);
//       }
//     });

//     // Listen for 'chatsFetched' event (optional)
//     _socket!.on('chatsFetched', (data) {
//       print('📥 Socket event - chatsFetched: $data');
//       if (data is List) {
//         onChatsFetched?.call(data);
//       }
//     });
//   }

//   /// Join a chat room (emits 'joinRoom' event)
//   void joinRoom(String senderId, String receiverId) {
//     print('🚪 Joining room: $senderId <-> $receiverId');
//     _socket?.emit('joinRoom', {
//       'senderId': senderId,
//       'receiverId': receiverId,
//     });
//   }

//   /// Leave a chat room (emits 'leaveRoom' event)
//   void leaveRoom(String senderId, String receiverId) {
//     print('🚪 Leaving room: $senderId <-> $receiverId');
//     _socket?.emit('leaveRoom', {
//       'senderId': senderId,
//       'receiverId': receiverId,
//     });
//   }

//   /// Send message via HTTP API
//   Future<Map<String, dynamic>> sendMessage({
//     required String senderId,
//     required String receiverId,
//     required String message,
//     List<File>? images,
//   }) async {
//     try {
//       print('📤 Sending message via API');
//       print('   Sender: $senderId');
//       print('   Receiver: $receiverId');
//       print('   Message: $message');
//       print('   Images: ${images?.length ?? 0}');
      
//       FormData formData = FormData();
//       formData.fields.add(MapEntry('message', message));
      
//       // Add images if provided
//       if (images != null && images.isNotEmpty) {
//         for (var image in images) {
//           String fileName = image.path.split('/').last;
//           formData.files.add(
//             MapEntry(
//               'images',
//               await MultipartFile.fromFile(image.path, filename: fileName),
//             ),
//           );
//         }
//       }

//       final response = await _dio.post(
//         '/api/users/sendchat/$senderId/$receiverId',
//         data: formData,
//       );

//       print('✅ API Response: ${response.statusCode}');
//       print('   Data: ${response.data}');

//       return {
//         'success': true,
//         'data': response.data,
//       };
//     } on DioException catch (e) {
//       print('❌ DioException: ${e.message}');
//       print('   Response: ${e.response?.data}');
//       return {
//         'success': false,
//         'error': e.response?.data ?? e.message,
//       };
//     } catch (e) {
//       print('❌ Error: $e');
//       return {
//         'success': false,
//         'error': e.toString(),
//       };
//     }
//   }

//   /// Get chat messages between two users
//   Future<Map<String, dynamic>> getChatMessages({
//     required String senderId,
//     required String receiverId,
//   }) async {
//     try {
//       print('📥 Fetching chat history');
//       print('   Sender: $senderId');
//       print('   Receiver: $receiverId');
      
//       final response = await _dio.get(
//         '/api/users/getchat/$senderId/$receiverId',
//       );

//       print('✅ Chat history fetched');
      
//       return {
//         'success': true,
//         'data': response.data,
//       };
//     } on DioException catch (e) {
//       print('❌ DioException: ${e.message}');
//       return {
//         'success': false,
//         'error': e.response?.data ?? e.message,
//       };
//     } catch (e) {
//       print('❌ Error: $e');
//       return {
//         'success': false,
//         'error': e.toString(),
//       };
//     }
//   }

//   /// Disconnect socket
//   void disconnect() {
//     print('🔌 Disconnecting socket');
//     _socket?.disconnect();
//     _socket?.dispose();
//   }
// }














// chat_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  static const String baseUrl = 'http://82.29.162.67:4061';
  late final Dio _dio;
  IO.Socket? _socket;
  
  // Socket event callbacks
  Function(Map<String, dynamic>)? onReceiveMessage;
  Function(List)? onChatsFetched;
  Function()? onConnected;
  Function()? onDisconnected;

  ChatService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }

  /// Initialize Socket.IO connection
  void initSocket(String userId) {
    print('🔌 Initializing socket for user: $userId');
    
    _socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      // Remove the query parameter if not needed by your backend
      // 'query': {'userId': userId}
    });

    _socket!.connect();

    // Connection events
    _socket!.onConnect((_) {
      print('✅ Socket connected');
      onConnected?.call();
    });

    _socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
      onDisconnected?.call();
    });

    _socket!.onConnectError((error) {
      print('⚠️ Connection error: $error');
    });

    _socket!.onError((error) {
      print('⚠️ Socket error: $error');
    });

    // Listen for 'receiveMessage' event (backend emits this)
    _socket!.on('receiveMessage', (data) {
      print('📨 Socket event - receiveMessage: $data');
      if (data is Map<String, dynamic>) {
        onReceiveMessage?.call(data);
      }
    });

    // Listen for 'chatsFetched' event (optional)
    _socket!.on('chatsFetched', (data) {
      print('📥 Socket event - chatsFetched: $data');
      if (data is List) {
        onChatsFetched?.call(data);
      }
    });
  }

  /// Join a chat room (emits 'joinRoom' event)
  void joinRoom(String senderId, String receiverId) {
    print('🚪 Joining room: $senderId <-> $receiverId');
    _socket?.emit('joinRoom', {
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }

  /// Leave a chat room (emits 'leaveRoom' event)
  void leaveRoom(String senderId, String receiverId) {
    print('🚪 Leaving room: $senderId <-> $receiverId');
    _socket?.emit('leaveRoom', {
      'senderId': senderId,
      'receiverId': receiverId,
    });
  }

  /// Send message via HTTP API
  Future<Map<String, dynamic>> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    List<File>? images,
  }) async {
    try {
      print('📤 Sending message via API');
      print('   Sender: $senderId');
      print('   Receiver: $receiverId');
      print('   Message: $message');
      print('   Images: ${images?.length ?? 0}');
      
      FormData formData = FormData();
      formData.fields.add(MapEntry('message', message));
      
      // Add images if provided
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          String fileName = image.path.split('/').last;
          formData.files.add(
            MapEntry(
              'images',
              await MultipartFile.fromFile(image.path, filename: fileName),
            ),
          );
        }
      }

      final response = await _dio.post(
        '/api/users/sendchat/$senderId/$receiverId',
        data: formData,
      );

      print('✅ API Response: ${response.statusCode}');
      print('   Data: ${response.data}');

      return {
        'success': true,
        'data': response.data,
      };
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('   Response: ${e.response?.data}');
      return {
        'success': false,
        'error': e.response?.data ?? e.message,
      };
    } catch (e) {
      print('❌ Error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get chat messages between two users
  Future<Map<String, dynamic>> getChatMessages({
    required String senderId,
    required String receiverId,
  }) async {
    try {
      print('📥 Fetching chat history');
      print('   Sender: $senderId');
      print('   Receiver: $receiverId');
      
      final response = await _dio.get(
        '/api/users/getchat/$senderId/$receiverId',
      );

      print('✅ Chat history fetched');
      
      return {
        'success': true,
        'data': response.data,
      };
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      return {
        'success': false,
        'error': e.response?.data ?? e.message,
      };
    } catch (e) {
      print('❌ Error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Disconnect socket
  void disconnect() {
    print('🔌 Disconnecting socket');
    _socket?.disconnect();
    _socket?.dispose();
  }
}