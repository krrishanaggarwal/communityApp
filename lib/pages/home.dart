import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:community/state/currentUser.dart'; // import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import 'activity_feed.dart';

import 'loginform.dart';
import 'profile.dart';
import 'search_post.dart';
import 'timeline.dart';
import 'uploadbycategory.dart';

final googleSignIn = GoogleSignIn();
final timestamp = DateTime.now();
final userRef = Firestore.instance.collection('users');
final postRef = Firestore.instance.collection('posts');
final postByCategoryRef = Firestore.instance.collection('postsByCategory');
final commentRef = Firestore.instance.collection('comments');
final activityFeedRef = Firestore.instance.collection('feed');
final organizerEntry = Firestore.instance.collection('OrganizersEntries');

final storageRef = FirebaseStorage.instance.ref();
OurUser currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  PageController pageController;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    checkUser();
    pageController = PageController();
  }

  checkUser() async {
    FirebaseUser _firebaseUser = await _auth.currentUser();
    var doc = await userRef.document(_firebaseUser.uid).get();
    print("ewerwerwerwerwerwerwrwrwerwrwrwerwerwrwrwerwrwrw");
    print(doc.data);

    if (!doc.exists) {
      RaisedButton(
        onPressed: () async {
          CurrentState _currentUser =
              Provider.of(context)<CurrentState>(context, listen: false);
          String retVal = await _currentUser.signOut();
          if (retVal == "success") {
            Text("adg");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginForm()),
                (route) => false);
          }
        },
        child: Text("Signvv Out"),
      );
    } else {
      Text("Abc");
    }

    doc = await userRef.document(_firebaseUser.uid).get();

    currentUser = OurUser.fromDocument(doc);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        curve: Curves.easeIn, duration: Duration(milliseconds: 300));
  }

  Widget buildAuthScreen(context) {
    return Scaffold(
      body: PageView(
        children: [
          Timeline(),
          ActivityFeed(),
          UploadFile(currentUser: currentUser),
          // Search(),
          SearchPost(),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: onTap,

        animationDuration: Duration(microseconds: 300),
        backgroundColor: Colors.grey[800],

        height: MediaQuery.of(context).size.height * 0.06,
        items: [
          Icon(
            Icons.whatshot_rounded,
            color: Colors.black,
          ),
          Icon(
            Icons.notifications_active,
            color: Colors.black,
          ),
          Icon(
            Icons.photo_camera,
            color: Colors.black,
          ),
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          Icon(
            Icons.account_circle,
            color: Colors.black,
          ),
        ],
        // activeColor: Theme.of(context).accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildAuthScreen(context);
  }
}
