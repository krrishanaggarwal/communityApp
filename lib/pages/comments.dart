import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;
import '../widgets/header.dart';
import '../widgets/progress.dart';
import 'home.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String postUserId;
  final String postMediaUrl;

  Comments({this.postId, this.postMediaUrl, this.postUserId});

  @override
  CommentsState createState() => CommentsState(
        postId: this.postId,
        postMediaUrl: this.postMediaUrl,
        postUserId: this.postUserId,
      );
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String postUserId;
  final String postMediaUrl;

  CommentsState({this.postId, this.postMediaUrl, this.postUserId});
  buildComments() {
    return StreamBuilder(
      stream: commentRef
          .document(postId)
          .collection("comments")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<CommentWidget> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(CommentWidget.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addComment() {
    commentRef.document(postId).collection("comments").add({
      "username": currentUser.username,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser.photoUrl,
      "userId": currentUser.id,
    });
    addCommentToActivityFeed();
    commentController.clear();
  }

  addCommentToActivityFeed() {
    bool isNotPostOwner = postUserId != currentUser.id;
    if (isNotPostOwner) {
      activityFeedRef.document(postUserId).collection("feedItems").add({
        "type": "comment",
        "username": currentUser.username,
        "userId": currentUser.id,
        "userProfileImg": currentUser.photoUrl,
        "postId": postId,
        "mediaUrl": postMediaUrl,
        "timestamp": timestamp,
        "commentText": commentController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        "Comments",
        context,
        fontsize: 40,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 66,
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(postMediaUrl),
            ),
          ),
          Expanded(child: buildComments()),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ListTile(
              title: TextFormField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: "Write a comment.....",
                ),
              ),
              trailing: OutlineButton(
                onPressed: addComment,
                child: Text("Post"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;
  CommentWidget(
      {this.avatarUrl,
      this.comment,
      this.timestamp,
      this.userId,
      this.username});

  factory CommentWidget.fromDocument(DocumentSnapshot doc) {
    return CommentWidget(
      userId: doc['userId'],
      username: doc["username"],
      comment: doc["comment"],
      timestamp: doc["timestamp"],
      avatarUrl: doc["avatarUrl"],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider()
      ],
    );
  }
}
