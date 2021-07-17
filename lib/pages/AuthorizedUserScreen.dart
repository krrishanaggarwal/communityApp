// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:community/models/user.dart';
// import 'package:community/pages/profile.dart';
// import 'package:community/pages/search_post.dart';
// import 'package:community/pages/timeline.dart';
// import 'package:community/pages/uploadbycategory.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// // import 'package:google_sign_in/google_sign_in.dart';

// import 'activity_feed.dart';

// //

// class AuthScreen extends StatefulWidget {
//   final String currentUser;
//   final User user;
//   AuthScreen({this.currentUser, this.user});

//   // const AuthScreen({ Key? key }) : super(key: key);

//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   PageController pageController;
//   int pageIndex = 3;

//   onTap(int pageIndex) {
//     pageController.animateToPage(pageIndex,
//         curve: Curves.easeIn, duration: Duration(milliseconds: 300));
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }

//   onPageChanged(int pageIndex) {
//     setState(() {
//       this.pageIndex = pageIndex;
//     });
//   }

//   Widget buildAuthScreen(context) {
//     return Scaffold(
//       body: PageView(
//         children: [
//           // RaisedButton(
//           //   onPressed: logout,
//           //   child: Text("Logout"),
//           // ),
//           Timeline(),
//           ActivityFeed(),
//           UploadFile(currentUser: widget.user),
//           // Search(),
//           SearchPost(),
//           Profile(profileId: widget.user?.id),
//         ],
//         controller: pageController,
//         onPageChanged: onPageChanged,
//         physics: NeverScrollableScrollPhysics(),
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//         onTap: onTap,

//         animationDuration: Duration(microseconds: 300),
//         backgroundColor: Colors.grey[800],

//         height: MediaQuery.of(context).size.height * 0.06,
//         items: [
//           Icon(
//             Icons.whatshot_rounded,
//             color: Colors.black,
//           ),
//           Icon(
//             Icons.notifications_active,
//             color: Colors.black,
//           ),
//           Icon(
//             Icons.photo_camera,
//             color: Colors.black,
//           ),
//           Icon(
//             Icons.search,
//             color: Colors.black,
//           ),
//           Icon(
//             Icons.account_circle,
//             color: Colors.black,
//           ),
//         ],
//         // activeColor: Theme.of(context).accentColor,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildAuthScreen(context);
//   }
// }
