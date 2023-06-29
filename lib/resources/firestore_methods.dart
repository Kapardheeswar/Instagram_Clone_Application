import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    Uint8List file,
    String description,
    String uid,
    String username,
    String userProfUrl,
  ) async {
    String res = "some err occurred";
    try {
      String postId = Uuid().v1();
      String photoUrl = await StorageMethods().uploadPostToStorage(
        "posts",
        file,
        postId,
      );

      Post post = Post(
        username: username,
        uid: uid,
        datePublished: DateTime.now(),
        description: description,
        postId: postId,
        postUrl: photoUrl,
        userPicUrl: userProfUrl,
        likes: [],
      );
      await firestore.collection("posts").doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid,
      String username, String userPicUrl) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          'profilePic': userPicUrl,
          'name': username,
          'text': text,
          'uid': uid,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print("Text is empty");
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    print(uid + " " + followId);
    var userData = {};
    try {
      var snap =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      userData = snap.data()!;
      print(userData['username']);
      List following = userData['following'];
      if (following.contains(followId)) {
        await firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await firestore.collection("users").doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

}
