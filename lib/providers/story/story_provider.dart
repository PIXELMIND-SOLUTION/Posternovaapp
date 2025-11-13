
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:posternova/helper/network_helper.dart';
import 'package:posternova/models/story_model.dart';

class StoryProvider extends ChangeNotifier {
  final List<Story> _stories = []; // All stories from all users
  final List<Story> _currentUserStories = []; // Only logged-in user's stories
  bool _isLoading = false;
  String? _error;
  String? _currentUserId;
  String? _currentUserImage;
  String? _currentUsername;

  List<Story> get stories => _stories;
  List<Story> get currentUserStories => _currentUserStories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentUserImage => _currentUserImage;
  String? get currentUsername => _currentUsername;
  String? get currentUserId => _currentUserId;

  // Set current user info
  void setCurrentUser({required String userId, String? userImage, String? username}) {
    _currentUserId = userId;
    _currentUserImage = userImage;
    _currentUsername = username;
    // Fetch current user stories after setting user
    if (userId.isNotEmpty) {
      fetchCurrentUserStories();
    }
    notifyListeners();
  }

  // Check if current user has an active story
  bool currentUserHasStory() {
    if (_currentUserId == null) return false;
    return _currentUserStories.isNotEmpty && 
           _currentUserStories.any((story) => 
              DateTime.now().isBefore(story.expiredAt));
  }

  // Get all active stories grouped by user (excluding current user)
  List<UserStories> getUserStoriesList() {
    final Map<String?, List<Story>> grouped = {};
    
    // Only include non-expired stories and exclude current user stories
    final activeStories = _stories.where(
      (story) => DateTime.now().isBefore(story.expiredAt) && 
                 story.userId != _currentUserId
    ).toList();

    for (var story in activeStories) {
      if (!grouped.containsKey(story.userId)) {
        grouped[story.userId] = [];
      }
      grouped[story.userId]!.add(story);
    }

    // Create UserStories objects
    return grouped.entries
        .map((entry) => UserStories(
          userId: entry.key, 
          stories: entry.value,
          username: entry.value.isNotEmpty ? entry.value.first.username ?? '' : '',
        ))
        .toList();
  }

  // Get current user stories as UserStories object
  UserStories? getCurrentUserStories() {
    if (!currentUserHasStory() || _currentUserId == null) {
      return null;
    }
    
    // Filter out expired stories
    final activeStories = _currentUserStories.where(
      (story) => DateTime.now().isBefore(story.expiredAt)
    ).toList();
    
    if (activeStories.isEmpty) {
      return null;
    }
    
    return UserStories(
      userId: _currentUserId!,
      stories: activeStories,
      username: _currentUsername ?? '',
      userAvatar: _currentUserImage ?? ''
    );
  }

  // Get stories for display in the main feed
  List<UserStories> getStoriesForDisplay() {
    final List<UserStories> result = [];
    
    // Add current user's stories first (if any)
    final currentUserStories = getCurrentUserStories();
    if (currentUserStories != null) {
      result.add(currentUserStories);
    }
    
    // Add other users' stories
    result.addAll(getUserStoriesList());
    
    return result;
  }

  // Mark a story as viewed
  void markStoryAsViewed(String storyId) {
    // Mark in regular stories list
    final index = _stories.indexWhere((story) => story.id == storyId);
    if (index != -1) {
      _stories[index] = _stories[index].copyWith(isViewed: true);
    }

    // Also mark in current user stories if applicable
    final currentUserIndex = _currentUserStories.indexWhere((story) => story.id == storyId);
    if (currentUserIndex != -1) {
      _currentUserStories[currentUserIndex] = _currentUserStories[currentUserIndex].copyWith(isViewed: true);
    }
    
    notifyListeners();
  }

  // Fetch current user stories
  Future<void> fetchCurrentUserStories() async {
    if (_currentUserId == null) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://194.164.148.244:4061/api/users/getUserStories/$_currentUserId'),
      );


      
            print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        _currentUserStories.clear();
        
        if (data['stories'] != null && data['stories'] is List) {
          for (var storyJson in data['stories']) {
            try {
              final story = Story.fromJson(storyJson);
              // Only add stories that haven't expired
              if (DateTime.now().isBefore(story.expiredAt)) {
                _currentUserStories.add(story);
              }
            } catch (e) {
              print('Error parsing current user story: $e');
            }
          }
        }
      } else {
        _error = 'Failed to fetch current user stories: ${response.statusCode}';
      }
    } on SocketException {
      _error = 'Please turn on your internet connection';
    } catch (e) {
      if (NetworkHelper.isNoInternetError(e)) {
        _error = 'Please turn on your internet connection';
      } else {
        _error = 'Error fetching current user stories: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all stories (excluding current user's stories)
  Future<void> fetchStories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch all stories
      final response = await http.get(
        Uri.parse('http://194.164.148.244:4061/api/users/getAllStories'),
      );

      print("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr${response.body}");
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['stories'] != null && data['stories'] is List) {
          _stories.clear();
          
          for (var storyJson in data['stories']) {
            try {
              final story = Story.fromJson(storyJson);
              // Only add stories that haven't expired and don't belong to current user
              if (DateTime.now().isBefore(story.expiredAt) && 
                  story.userId != _currentUserId) {
                _stories.add(story);
              }
            } catch (e) {
              print('Error parsing story: $e');
            }
          }
        }
      } else {
        _error = 'Failed to fetch stories: ${response.statusCode}';
      }
      
      // Also fetch current user's stories
      await fetchCurrentUserStories();
      
    } on SocketException {
      _error = 'Please turn on your internet connection';
    } catch (e) {
      if (NetworkHelper.isNoInternetError(e)) {
        _error = 'Please turn on your internet connection';
      } else {
        _error = 'Error fetching stories: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Post a new story
  Future<bool> postStory(File imageFile, String caption) async {
    if (_currentUserId == null) return false;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      print('current user iddddddddddddddddddddddddd $_currentUserId');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://194.164.148.244:4061/api/users/post/$_currentUserId'),
      );
      
      request.fields['caption'] = caption;
      
      var imageStream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var fileExtension = extension(imageFile.path).replaceAll('.', '');
      
      var multipartFile = http.MultipartFile(
        'file',
        imageStream,
        length,
        filename: basename(imageFile.path),
        contentType: MediaType('image', fileExtension),
      );
      
      request.files.add(multipartFile);
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('response staus code for posting the story ${response.statusCode}');
      print('response bodyyy for  storyyy addinggggggggg ${response.body}');

      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Refresh both current user stories and all stories
        await fetchCurrentUserStories();
        await fetchStories();
        return true;
      } else {
        _error = 'Failed to post story: ${response.statusCode}';
        return false;
      }
    } on SocketException {
      _error = 'Please turn on your internet connection';
      return false;
    } catch (e) {
      if (NetworkHelper.isNoInternetError(e)) {
        _error = 'Please turn on your internet connection';
      } else {
        _error = 'Error posting story: $e';
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete a story
  Future<bool> deleteStory(String storyId, String userId, String mediaUrl) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('useeeeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrr$userId');
      print('storyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyid$storyId');
      print('dddddddddaaaaaaaaaaaaaaaaaaaa$mediaUrl');
      final response = await http.delete(
        Uri.parse('http://194.164.148.244:4061/api/users/deletestory/$userId/$storyId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'mediaUrl': mediaUrl
        })
      );
      print('meeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${response.statusCode}');
      if (response.statusCode == 200) {
        // Remove the story from local lists
        _stories.removeWhere((story) => story.id == storyId);
        _currentUserStories.removeWhere((story) => story.id == storyId);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to delete story: ${response.statusCode}';
        return false;
      }
    } on SocketException {
      _error = 'Please turn on your internet connection';
      return false;
    } catch (e) {
      if (NetworkHelper.isNoInternetError(e)) {
        _error = 'Please turn on your internet connection';
      } else {
        _error = 'Error deleting story: $e';
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pick image from gallery or camera
  Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}