import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/post.dart';
import '../widgets/progress.dart';
import 'home.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;
  PostScreen({this.postId, this.userId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: postRef
            .document(userId)
            .collection("userPosts")
            .document(postId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          Post post = Post.fromDocument(snapshot.data);
          return Center(
              child: Scaffold(
            appBar: header("Post", context),
            body: ListView(children: [
              Container(alignment: Alignment.center, child: post)
            ]),
          ));
        });
  }
}
