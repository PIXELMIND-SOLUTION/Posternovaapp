import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posternova/providers/chat/chat_provider.dart';
import 'package:posternova/helper/storage_helper.dart';

class ChatModule extends StatefulWidget {
  final String posterImagePath;
  final List<Map<String, dynamic>> selectedCustomers;

  const ChatModule({
    super.key,
    required this.posterImagePath,
    required this.selectedCustomers,
  });

  @override
  State<ChatModule> createState() => _ChatModuleState();
}

class _ChatModuleState extends State<ChatModule> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentCustomerIndex = 0;
  String? _currentUserId;
  bool _isInitialized = false;

  // Get current customer
  Map<String, dynamic> get _currentCustomer =>
      widget.selectedCustomers[_currentCustomerIndex];

  String get _currentReceiverId => _currentCustomer['_id'] ?? '';

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    // Load user data
    final userData = await AuthPreferences.getUserData();
    if (userData != null) {
      setState(() {
        _currentUserId = userData.user.id;
      });

      if (_currentUserId != null) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        
        // Initialize socket connection
        chatProvider.initSocket(_currentUserId!);
        
        // Join room with current customer
        chatProvider.joinRoom(_currentUserId!, _currentReceiverId);
        
        // Load chat history
        await chatProvider.loadMessages(_currentUserId!, _currentReceiverId);
        
        // Send initial poster message
        await _sendInitialPosterMessage();
        
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  Future<void> _sendInitialPosterMessage() async {
    if (_currentUserId == null) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    // Send message with poster image
    await chatProvider.sendMessage(
      senderId: _currentUserId!,
      receiverId: _currentReceiverId,
      message: 'Hi ${_currentCustomer['name']}, check out this poster!',
      images: [File(widget.posterImagePath)],
    );

    _scrollToBottom();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _currentUserId == null) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    final success = await chatProvider.sendMessage(
      senderId: _currentUserId!,
      receiverId: _currentReceiverId,
      message: _messageController.text.trim(),
    );

    if (success) {
      _messageController.clear();
      _scrollToBottom();
    } else {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(chatProvider.error ?? 'Failed to send message'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _nextCustomer() async {
    if (_currentUserId == null) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    // Leave current room
    chatProvider.leaveRoom(_currentUserId!, _currentReceiverId);

    if (_currentCustomerIndex < widget.selectedCustomers.length - 1) {
      setState(() {
        _currentCustomerIndex++;
      });

      // Join new room
      chatProvider.joinRoom(_currentUserId!, _currentReceiverId);
      
      // Clear old messages and load new chat
      chatProvider.clearMessages();
      await chatProvider.loadMessages(_currentUserId!, _currentReceiverId);
      
      // Send initial poster message to new customer
      await _sendInitialPosterMessage();
    } else {
      // All customers completed
      chatProvider.disconnect();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All messages sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _scrollToBottom() {
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

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    // Leave room and disconnect when leaving
    if (_currentUserId != null) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.leaveRoom(_currentUserId!, _currentReceiverId);
      chatProvider.disconnect();
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _currentUserId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing chat...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () {
            // Disconnect before leaving
            final chatProvider = Provider.of<ChatProvider>(context, listen: false);
            chatProvider.leaveRoom(_currentUserId!, _currentReceiverId);
            chatProvider.disconnect();
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: Text(
                    _currentCustomer['name']?.toString().substring(0, 1).toUpperCase() ?? 'C',
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      return Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: chatProvider.isConnected
                              ? const Color(0xFF4CAF50)
                              : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentCustomer['name']?.toString() ?? 'Customer',
                    style: const TextStyle(
                      color: Color(0xFF2C3E50),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _currentCustomer['mobile']?.toString() ?? '',
                    style: const TextStyle(
                      color: Color(0xFF95A5A6),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentCustomerIndex + 1}/${widget.selectedCustomers.length}',
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection status indicator
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (!chatProvider.isConnected) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(Icons.warning_amber, size: 16, color: Colors.orange.shade900),
                      // const SizedBox(width: 8),
                      // Text(
                      //   'Reconnecting...',
                      //   style: TextStyle(
                      //     color: Colors.orange.shade900,
                      //     fontSize: 12,
                      //   ),
                      // ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Messages list
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (chatProvider.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // Auto-scroll when new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    final isSentByMe = message.senderId == _currentUserId;

                    return ChatBubble(
                      message: message.message,
                      isSent: isSentByMe,
                      time: _formatTime(message.timestamp),
                      isRead: message.isSent,
                      images: message.images,
                    );
                  },
                );
              },
            ),
          ),

          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Color(0xFF95A5A6),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF8B7FF4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return IconButton(
                    icon: chatProvider.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                    onPressed: chatProvider.isLoading ? null : _sendMessage,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 22),
                onPressed: _nextCustomer,
                tooltip: 'Next Customer',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSent;
  final String time;
  final bool isRead;
  final List<String>? images;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSent,
    required this.time,
    required this.isRead,
    this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSent) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Display images if any
                if (images != null && images!.isNotEmpty)
                  ...images!.map((imagePath) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imagePath.startsWith('http')
                            ? Image.network(
                                imagePath,
                                width: 200,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              )
                            : Image.file(
                                File(imagePath),
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                      ),
                    );
                  }).toList(),
                
                // Message bubble
                if (message.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isSent
                          ? const LinearGradient(
                              colors: [Color(0xFF6C5CE7), Color(0xFF8B7FF4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSent ? null : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                            color: isSent ? Colors.white : Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                color: isSent
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.black54,
                                fontSize: 11,
                              ),
                            ),
                            if (isSent) ...[
                              const SizedBox(width: 4),
                              Icon(
                                isRead ? Icons.done_all : Icons.done,
                                size: 14,
                                color: isRead
                                    ? const Color(0xFF4CAF50)
                                    : Colors.white.withOpacity(0.8),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (isSent) const SizedBox(width: 8),
        ],
      ),
    );
  }
}