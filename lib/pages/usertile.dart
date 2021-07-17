import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../models/user.dart';
import 'activity_feed.dart';

class UserResult extends StatelessWidget {
  final OurUser user;
  UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white54,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName == null ? user.username : user.displayName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Divider(
            height: 3,
            color: Colors.white54,
          )
        ],
      ),
    );
  }
}

class EventOrganizers extends StatelessWidget {
  final OurUser user;
  EventOrganizers(this.user);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showProfile(context, profileId: user.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              title: Text(
                user.displayName == null ? user.username : user.displayName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
              ),
              trailing: Container(
                height: 30,
                width: 60,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        customLaunch(
                            "mailto:${user.email}?subject=test%20subject&body=test%20body");
                      },
                      child: Icon(
                        Icons.mail,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: 3,
            color: Colors.white70,
          )
        ],
      ),
    );
  }
}

void customLaunch(command) async {
  if (await canLaunch(command)) {
    await launch(command);
  } else {
    print("");
  }
}
