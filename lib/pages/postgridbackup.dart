import 'package:cached_network_image/cached_network_image.dart';
import 'package:community/pages/showImage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/postByCategory.dart';
import 'activity_feed.dart';

class PostResult extends StatefulWidget {
  final PostByCategory post;
  PostResult(this.post);

  @override
  _PostResultState createState() => _PostResultState();
}

class _PostResultState extends State<PostResult> {
  bool isLoading = false;

  imageOptions(parentContext,
      {String userId, String mediaUrl, String caption}) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
                child: Text("View Profile"),
                onPressed: () => showProfile(
                      context,
                      profileId: userId,
                    )),
            SimpleDialogOption(
                child: Text("Download Image"),
                onPressed: () => downloadImage(mediaUrl)),
            SimpleDialogOption(
              child: Text("Show Image"),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowImage(
                            mediaUrl: mediaUrl,
                            profileId: userId,
                            description: caption,
                          ))),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Text(post.category);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 6,
        child: Material(
          animationDuration: Duration(minutes: 1),
          child: InkWell(
            onLongPress: () => imageOptions(context,
                userId: widget.post.userId,
                mediaUrl: widget.post.mediaUrl,
                caption: widget.post.caption),
            onDoubleTap: () =>
                showProfile(context, profileId: widget.post.userId),
            child: GridTile(
              child: Image(
                image: CachedNetworkImageProvider(widget.post.mediaUrl),
                fit: BoxFit.cover,
              ),
              footer: Container(
                height: 26,
                color: Colors.black45,
                child: Center(
                  child: Text(
                    widget.post.username.toUpperCase(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

downloadImage(mediaUrl) async {
  final status = await Permission.storage.request();

  if (status.isGranted) {
    final externalDirectory = await getExternalStorageDirectory();
    await FlutterDownloader.enqueue(
        url: mediaUrl,
        savedDir: externalDirectory.path,
        openFileFromNotification: true,
        fileName: "SocialClone_download.jpg",
        showNotification: true);
  }
}
