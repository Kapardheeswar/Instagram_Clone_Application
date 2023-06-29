import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_app/screens/FeedScreen.dart';
import 'package:insta_app/screens/add_post_screen.dart';
import 'package:insta_app/screens/profile_screen.dart';
import 'package:insta_app/screens/search_screen.dart';
import 'package:insta_app/utils/colors.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  String? username;
  String? userId;
  String? userPicUrl;
  int page = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChange(int currentIndex) {
    setState(() {
      page = currentIndex;
    });
  }

  void getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      username = (snap.data() as Map<String, dynamic>)['username'];
    });
    userPicUrl = (snap.data() as Map<String, dynamic>)['photoUrl'];
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(context) {
    // model.User? user = Provider.of<UserProvider>(context).getUser;
    return username == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChange,
              children: [
                FeedScreen(
                  uid: userId!,
                  currentUserUsername: username!,
                  currentUserPicUrl: userPicUrl!,
                ),
                SearchScreen(),
                AddPostScreen(
                  userPicUrl: userPicUrl,
                  userId: userId,
                  username: username,
                ),
                ProfileScreen(uid: userId!,),
              ],
            ),
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: mobileBackgroundColor,
              height: 70,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: page == 0 ? primaryColor : secondaryColor,
                  ),
                  label: "",
                  backgroundColor: primaryColor,
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      color: page == 1 ? primaryColor : secondaryColor,
                    ),
                    label: "",
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle,
                      color: page == 2 ? primaryColor : secondaryColor,
                    ),
                    label: "",
                    backgroundColor: primaryColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: page == 3 ? primaryColor : secondaryColor,
                    ),
                    label: "",
                    backgroundColor: primaryColor),
              ],
              onTap: navigationTapped,
            ),
          );
  }
}
