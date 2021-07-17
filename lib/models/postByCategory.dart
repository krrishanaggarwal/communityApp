import 'package:cloud_firestore/cloud_firestore.dart';

class PostByCategory {
  final String tag;
  final String postId;
  final String mediaUrl;
  final String userId;
  final String username;
  final String caption;
  final Timestamp timestamp;

  PostByCategory(
      {this.tag,
      this.mediaUrl,
      this.postId,
      this.caption,
      this.userId,
      this.username,
      this.timestamp});

  factory PostByCategory.fromDocument(DocumentSnapshot doc) {
    return PostByCategory(
        tag: doc['tag'],
        postId: doc['postId'],
        mediaUrl: doc['mediaUrl'],
        username: doc['username'],
        userId: doc['userId'],
        caption: doc['caption'],
        timestamp: doc['timestamp']);
  }
}
