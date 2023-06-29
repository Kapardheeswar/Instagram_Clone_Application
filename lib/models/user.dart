import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String password;
  final String uid;
  final String bio;
  final String photoUrl;
  final List following;
  final List followers;

  User({
    required this.password,
    required this.email,
    required this.photoUrl,
    required this.uid,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String,dynamic> toJson(){
    return {
      'email': email,
      'uid': uid,
      'password': password,
      'bio': bio,
      'username': username,
      'followers': [],
      'following': [],
      'photoUrl': photoUrl,
    };
  }

  static User getUserFromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return User(
      email: snapshot['email'],
      password: snapshot['password'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      username: snapshot['username'],
    );
  }
}
