import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:posternova/services/chat/chat_service.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final List<String>? images;
  final DateTime timestamp;
  final bool isSent;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.images,
    required this.timestamp,
    this.isSent = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : (json['createdAt'] != null 
              ? DateTime.parse(json['createdAt'])
              : DateTime.now()),
      isSent: json['isSent'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'images': images,
      'timestamp': timestamp.toIso8601String(),
      'isSent': isSent,
    };
  }

  ChatMessage copyWith({
    String? id,
    bool? isSent,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      images: images,
      timestamp: timestamp,
      isSent: isSent ?? this.isSent,
    );
  }
}

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isConnected = false;
  String? _error;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String? get error => _error;

  ChatProvider() {
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    // Connection status callbacks
    _chatService.onConnected = () {
      _isConnected = true;
      print('✅ ChatProvider: Socket connected');
      notifyListeners();
    };

    _chatService.onDisconnected = () {
      _isConnected = false;
      print('❌ ChatProvider: Socket disconnected');
      notifyListeners();
    };

    // Listen for 'receiveMessage' event from backend
    _chatService.onReceiveMessage = (data) {
      print('📨 ChatProvider: Received message via socket: $data');
      
      try {
        final message = ChatMessage.fromJson(data);
        
        // Prevent duplicate messages
        final exists = _messages.any((msg) => msg.id == message.id);
        
        if (!exists) {
          _messages.add(message);
          print('✅ Message added. Total: ${_messages.length}');
          notifyListeners();
        } else {
          print('⚠️ Duplicate message ignored');
        }
      } catch (e) {
        print('❌ Error parsing received message: $e');
      }
    };

    // Optional: Listen for 'chatsFetched' event
    _chatService.onChatsFetched = (chats) {
      print('📥 ChatProvider: Chats fetched via socket: ${chats.length}');
      try {
        for (final chatData in chats) {
          final msg = ChatMessage.fromJson(chatData);
          if (!_messages.any((m) => m.id == msg.id)) {
            _messages.add(msg);
          }
        }
        _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        notifyListeners();
      } catch (e) {
        print('❌ Error processing fetched chats: $e');
      }
    };
  }

  /// Initialize socket connection
  void initSocket(String userId) {
    print('🔌 Initializing socket for user: $userId');
    _chatService.initSocket(userId);
  }

  /// Join chat room
  void joinRoom(String senderId, String receiverId) {
    print('🚪 Joining room: $senderId <-> $receiverId');
    _chatService.joinRoom(senderId, receiverId);
  }

  /// Leave chat room
  void leaveRoom(String senderId, String receiverId) {
    print('🚪 Leaving room: $senderId <-> $receiverId');
    _chatService.leaveRoom(senderId, receiverId);
  }

  /// Load chat history from server
  Future<void> loadMessages(String senderId, String receiverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _chatService.getChatMessages(
        senderId: senderId,
        receiverId: receiverId,
      );

      _isLoading = false;

      if (result['success']) {
        final data = result['data'];
        
        if (data != null) {
          List<ChatMessage> loadedMessages = [];
          
          // Handle response: { success: true, chats: [...] }
          if (data is Map && data['chats'] != null) {
            loadedMessages = (data['chats'] as List)
                .map((msg) => ChatMessage.fromJson(msg))
                .toList();
          } else if (data is List) {
            loadedMessages = data.map((msg) => ChatMessage.fromJson(msg)).toList();
          }
          
          _messages = loadedMessages;
          print('📥 Loaded ${_messages.length} messages');
        }
      } else {
        _error = result['error']?.toString() ?? 'Failed to load messages';
        print('❌ Error: $_error');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Exception: $e');
      _isLoading = false;
    }

    notifyListeners();
  }

  /// Send message with optional images
  Future<bool> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
    List<File>? images,
  }) async {
    print('📤 Sending message: "$message"');
    
    if (message.trim().isEmpty && (images == null || images.isEmpty)) {
      print('⚠️ Empty message');
      return false;
    }

    // Optimistic UI update
    ChatMessage? tempMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      receiverId: receiverId,
      message: message.trim(),
      images: images?.map((f) => f.path).toList(),
      timestamp: DateTime.now(),
      isSent: false,
    );
    
    _messages.add(tempMessage);
    notifyListeners();
    print('➕ Optimistic message added');

    try {
      final result = await _chatService.sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        message: message.trim(),
        images: images,
      );

      // Remove temp message
      _messages.removeWhere((msg) => msg.id == tempMessage.id);

      if (result['success']) {
        print('✅ Message sent - waiting for socket confirmation');
        notifyListeners();
        return true;
      } else {
        _error = result['error']?.toString() ?? 'Send failed';
        print('❌ Send failed: $_error');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _messages.removeWhere((msg) => msg.id == tempMessage.id);
      _error = e.toString();
      print('❌ Exception: $e');
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void disconnect() {
    _chatService.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }
}