import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'showImage.dart';

import '../models/postByCategory.dart';
import 'activity_feed.dart';

class TimelinePostResult extends StatelessWidget {
  final PostByCategory post;
  TimelinePostResult(this.post);
  @override
  Widget build(BuildContext context) {
    // return Text(post.category);
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(post.mediaUrl),
                    fit: BoxFit.fill)),
          ),
          // padding: EdgeInsets.all(9),

          InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowImage(
                          mediaUrl: post.mediaUrl,
                          description: post.caption,
                          profileId: post.userId,
                          username: post.username,
                        ))),
            // profileId: post.userId))),
            onDoubleTap: () => showProfile(context, profileId: post.userId),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  color: Colors.black54,
                  child: Text(post.username,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                )),
          )
        ]));
  }
}
