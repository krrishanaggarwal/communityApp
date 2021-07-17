import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../pages/activity_feed.dart';
import '../pages/comments.dart';
import '../pages/home.dart';
import 'custom_image.dart';
import 'progress.dart';

class Post extends StatefulWidget {
  final String postId;
  final String userId;
  final String username;
  final String tag;
  final String caption;
  final String mediaUrl;
  final dynamic likes;

  Post({
    this.postId,
    this.userId,
    this.username,
    this.tag,
    this.caption,
    this.mediaUrl,
    this.likes,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      userId: doc['userId'],
      username: doc['username'],
      tag: doc['tag'],
      caption: doc['caption'],
      mediaUrl: doc['mediaUrl'],
      likes: doc['likes'],
    );
  }

  int getLikesCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _PostState createState() => _PostState(
      postId: this.postId,
      userId: this.userId,
      username: this.username,
      tag: this.tag,
      caption: this.caption,
      mediaUrl: this.mediaUrl,
      likes: this.likes,
      likecount: getLikesCount(this.likes));
}

class _PostState extends State<Post> {
  final String currentUserId = currentUser?.id;
  final String postId;
  final String userId;
  final String username;
  final String tag;
  final String caption;
  final String mediaUrl;
  Map likes;
  int likecount;
  bool isLiked;
  bool showHeart = false;

  _PostState({
    this.postId,
    this.userId,
    this.username,
    this.tag,
    this.caption,
    this.mediaUrl,
    this.likes,
    this.likecount,
  });

  buildHeader() {
    return FutureBuilder(
      future: userRef.document(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        OurUser user = OurUser.fromDocument(snapshot.data);
        bool isPostOwner = currentUserId == userId;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          ),
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: userId),
            child: Text(
              user.username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text("# $tag"),
          trailing: isPostOwner
              ? IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => handleDeletePost(context),
                )
              : Text(""),
        );
      },
    );
  }

  handleDeletePost(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Remove this post?"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                deletePost();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
              ),
            )
          ],
        );
      },
    );
  }

  deletePost() async {
    postRef
        .document(userId)
        .collection("userPosts")
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    QuerySnapshot postByCategory = await postByCategoryRef
        .where("postId", isEqualTo: postId)
        .getDocuments();
    postByCategory.documents.forEach((element) {
      if (element.exists) {
        element.reference.delete();
      }
    });
    storageRef.child("post_$postId.jpg").delete();
    QuerySnapshot activityFeedSnapShot = await activityFeedRef
        .document(userId)
        .collection("feedItems")
        .where("postId", isEqualTo: postId)
        .getDocuments();
    activityFeedSnapShot.documents.forEach((element) {
      if (element.exists) {
        element.reference.delete();
      }
    });
    QuerySnapshot commentsSnapshot =
        await commentRef.document(postId).collection('comments').getDocuments();
    commentsSnapshot.documents.forEach((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleLikePost() {
    bool _isLiked = likes[currentUserId] == true;

    if (_isLiked) {
      postRef
          .document(userId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentUserId': false});
      removeLikeFromActivityFeed();

      setState(() {
        likecount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      postRef
          .document(userId)
          .collection('userPosts')
          .document(postId)
          .updateData({'likes.$currentUserId': true});
      addLikeToActivityFeed();

      setState(() {
        likecount += 1;
        isLiked = true;
        likes[currentUserId] = true;
        showHeart = true;
      });

      Timer(Duration(milliseconds: 600), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  addLikeToActivityFeed() {
    bool isNotPostOwner = currentUserId != userId;
    if (isNotPostOwner) {
      activityFeedRef
          .document(userId)
          .collection("feedItems")
          .document(postId)
          .setData({
        "type": "like",
        "username": currentUser.username,
        "userProfileImg": currentUser.photoUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "timestamp": timestamp
      });
    }
  }

  removeLikeFromActivityFeed() {
    bool isNotPostOwner = currentUserId != userId;
    if (isNotPostOwner) {
      activityFeedRef
          .document(userId)
          .collection("feedItems")
          .document(postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: handleLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: [
          cachedNetworkImage(mediaUrl),
          showHeart
              ? Animator(
                  duration: Duration(milliseconds: 300),
                  tween: Tween(begin: 0.3, end: 1.3),
                  curve: Curves.elasticOut,
                  cycles: 0,
                  builder: (anim) => Transform.scale(
                    scale: anim.value,
                    child: Icon(
                      Icons.thumb_up,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                )
              : Text("")
        ],
      ),
    );
  }

  buildFooter(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 10),
                child: GestureDetector(
                  onTap: handleLikePost,
                  child: Icon(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 28,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: () => showComments(context,
                      postId: postId, userId: userId, mediaUrl: mediaUrl),
                  child: Icon(
                    Icons.chat,
                    size: 28,
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$likecount likes",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5, left: 20),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "$username:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
                child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 6),
                child: Text(
                  caption,
                  overflow: TextOverflow.clip,
                  maxLines: 20,
                ),
              ),
            ))
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = likes[currentUserId] == true;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildHeader(),
        buildPostImage(),
        buildFooter(context),
      ],
    );
  }
}

showComments(BuildContext context,
    {String postId, String userId, String mediaUrl}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(
      postId: postId,
      postUserId: userId,
      postMediaUrl: mediaUrl,
    );
  }));
}
