import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/resources/firestore_methods.dart';
import 'package:insta_app/utils/colors.dart';
import 'package:insta_app/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final String username;
  final String userPicUrl;
  final String uid;
  final snap;

  const CommentsScreen({
    super.key,
    required this.username,
    required this.userPicUrl,
    required this.uid,
    required this.snap,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap['postId'])
            .collection("comments")
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return CommentCard(
                snap: snapshot.data!.docs[index].data(),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(widget.userPicUrl),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 8,
                  ),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "What are waiting for ${widget.username}?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  FirestoreMethods().postComment(
                    widget.snap['postId'],
                    commentController.text,
                    widget.uid,
                    widget.username,
                    widget.userPicUrl,
                  );
                  commentController.clear();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
