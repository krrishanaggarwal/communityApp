import 'package:cached_network_image/cached_network_image.dart';
import 'package:community/pages/showImage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/postByCategory.dart';

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
            Column(
              children: [
                Card(
                  elevation: 6,
                  child: Image(
                    image: CachedNetworkImageProvider(mediaUrl),
                  ),
                ),
                Text(
                  caption,
                  maxLines: 7,
                  textAlign: TextAlign.left,
                )
              ],
            )
            // SimpleDialogOption(
            //     child: Text("View Profile"),
            //     onPressed: () => showProfile(
            //           context,
            //           profileId: userId,
            //         )),
            // SimpleDialogOption(
            //     child: Text("Download Image"),
            //     onPressed: () => downloadImage(mediaUrl)),
            // SimpleDialogOption(
            //   child: Text("Show Image"),
            //   onPressed: () => Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ShowImage(
            //                 mediaUrl: mediaUrl,
            //                 profileId: userId,
            //                 description: caption,
            //               ))),
            // )
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
      child: InkWell(
        onLongPress: () => imageOptions(context,
            userId: widget.post.userId,
            mediaUrl: widget.post.mediaUrl,
            caption: widget.post.caption),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowImage(
                      mediaUrl: widget.post.mediaUrl,
                      profileId: widget.post.userId,
                      description: widget.post.caption,
                    ))),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.post.mediaUrl),
                    fit: BoxFit.fill))),
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
