import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String description;
  final String postId;
  final String uid;
  final datePublished;
  final String postUrl;
  final String userPicUrl;
  final likes;

  Post({
    required this.description,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.userPicUrl,
    required this.likes,
    required this.uid,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'description': description,
      'postId': postId,
      'uid': uid,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'userPicUrl': userPicUrl,
      'likes': likes,
    };
  }
}
