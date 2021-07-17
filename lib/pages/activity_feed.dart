// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import 'package:timeago/timeago.dart' as timeago;

// import '../widgets/header.dart';
// import '../widgets/progress.dart';
// import 'home.dart';
// import 'post_screen.dart';
// import 'profile.dart';

// class ActivityFeed extends StatefulWidget {
//   @override
//   _ActivityFeedState createState() => _ActivityFeedState();
// }

// class _ActivityFeedState extends State<ActivityFeed> {
//   getActivityFeed() async {
//     QuerySnapshot snapshot = await activityFeedRef
//         .document(currentUser.id)
//         .collection("feedItems")
//         .orderBy("timestamp", descending: true)
//         .limit(35)
//         .getDocuments();
//     List<ActivityFeedItem> feedItems = [];
//     snapshot.documents.forEach((element) {
//       feedItems.add(ActivityFeedItem.fromDocument(element));
//     });
//     return feedItems;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).accentColor.withOpacity(0.6),
//       appBar: header("Activity Feed", context, removeBackButton: true),
//       body: Container(
//         child: FutureBuilder(
//           future: getActivityFeed(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return circularProgress();
//             }
//             return GestureDetector(child: ListView(children: snapshot.data));
//           },
//         ),
//       ),
//     );
//   }
// }

// Widget mediaPreview;
// String activityItemText;

// class ActivityFeedItem extends StatelessWidget {
//   final String username;
//   final String userId;
//   final String type;
//   final String mediaUrl;
//   final String postId;
//   final String userProfileImg;
//   final String commentText;
//   final Timestamp timestamp;

//   ActivityFeedItem(
//       {this.commentText,
//       this.mediaUrl,
//       this.postId,
//       this.timestamp,
//       this.type,
//       this.userId,
//       this.userProfileImg,
//       this.username});

//   factory ActivityFeedItem.fromDocument(doc) {
//     return ActivityFeedItem(
//       commentText: doc["commentText"],
//       userId: doc["userId"],
//       postId: doc["postId"],
//       timestamp: doc["timestamp"],
//       type: doc["type"],
//       mediaUrl: doc["mediaUrl"],
//       userProfileImg: doc["userProfileImg"],
//       username: doc["username"],
//     );
//   }
//   showPost(context) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PostScreen(
//             postId: postId,
//             userId: userId,
//           ),
//         ));
//   }

//   configureMediaPreview(context) {
//     if (type == "like" || type == "comment") {
//       mediaPreview = InkWell(
//         splashColor: Colors.pink,
//         onTap: () => showPost(context),
//         child: Container(
//           height: 50,
//           width: 50,
//           child: AspectRatio(
//             aspectRatio: 1,
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: CachedNetworkImageProvider(mediaUrl),
//                     fit: BoxFit.cover),
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       mediaPreview = Text("");
//     }
//     if (type == "like") {
//       activityItemText = "liked your post";
//     } else if (type == "comment") {
//       activityItemText = "replied :$commentText";
//     } else if (type == "follow") {
//       activityItemText = "started following you";
//     } else {
//       activityItemText = "Error :Unknow type '$type'";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     configureMediaPreview(context);
//     return Container(
//       color: Colors.white54,
//       child: ListTile(
//         title: GestureDetector(
//           onTap: () => showProfile(context, profileId: userId),
//           child: RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 fontSize: 16,
//                 // fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//               children: [
//                 TextSpan(
//                     text: username,
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 TextSpan(
//                   text: "  $activityItemText",
//                 ),
//               ],
//             ),
//           ),
//         ),
//         leading: CircleAvatar(
//           backgroundImage: CachedNetworkImageProvider(userProfileImg),
//         ),
//         subtitle: Text(
//           timeago.format(timestamp.toDate()),
//           overflow: TextOverflow.ellipsis,
//         ),
//         trailing: mediaPreview,
//       ),
//     );
//   }
// }

// showProfile(context, {String profileId}) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => Profile(
//                 profileId: profileId,
//               )));
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home.dart';

import '../widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../widgets/header.dart';
import 'profile.dart';

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();
    List<ActivityFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(ActivityFeedItem.fromDocument(doc));
      // print('Activity Feed Item: ${doc.data}');
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header("Activity Feed", context),
      body: Container(
          child: FutureBuilder(
        future: getActivityFeed(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      )),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  final String mediaUrl;
  final String postId;
  final String userProfileImg;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this.timestamp,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
    );
  }

  configureMediaPreview(context) {
    if (type == "like" || type == 'comment') {
      mediaPreview = GestureDetector(
        // onTap: () => showPost(context, postId, userId),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(mediaUrl),
                  ),
                ),
              )),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like') {
      activityItemText = "liked your post";
    } else if (type == 'follow') {
      activityItemText = "is following you";
    } else if (type == 'comment') {
      activityItemText = 'replied: $commentData';
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $activityItemText',
                    ),
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}

showProfile(BuildContext context, {String profileId}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Profile(
        profileId: profileId,
      ),
    ),
  );
}
