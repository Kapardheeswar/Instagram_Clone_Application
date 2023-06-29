import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_app/models/user.dart' as model;

import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<String> SignUpUser({
    required String email,
    required String password,
    required String bio,
    required String username,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          username.isNotEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);
        String photoUrl = await StorageMethods().uploadImageToStorage(
          "profilePics",
          file,
          false,
        );

        model.User user = model.User(
          password: password,
          email: email,
          photoUrl: photoUrl,
          uid: cred.user!.uid,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );
        await firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'Success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> LoginUsers({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> signOut()async{
    await FirebaseAuth.instance.signOut();
  }
}
