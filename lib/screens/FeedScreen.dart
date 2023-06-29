import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/widgets/post_widget.dart';

class FeedScreen extends StatelessWidget {
  final String currentUserPicUrl;
  final String currentUserUsername;
  final String uid;

  const FeedScreen({
    super.key,
    required this.uid,
    required this.currentUserUsername,
    required this.currentUserPicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.message),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return PostWidget(
                snap: snapshot.data!.docs[index],
                uid: uid,
                currentUserPicUrl: currentUserPicUrl,
                currentUserUsername: currentUserUsername,
              );
            },
          );
        },
      ),
    );
  }
}
