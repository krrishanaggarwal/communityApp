import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show QuerySnapshot;
import 'package:community/pages/usertile.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/header.dart';
import '../widgets/post.dart';
import '../widgets/post_tile.dart';
import '../widgets/progress.dart';
import 'AppDrawer.dart';
import 'edit_profile.dart';
import 'home.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({this.profileId});
  @override
  _ProfileState createState() => _ProfileState();
}

buildCountColumn(String label, int count) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        count.toString(),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      Container(
        margin: EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
    ],
  );
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
  bool isLoading = false;
  bool gridView = false;
  int postCount = 0;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    getProfilePost();
  }

  getProfilePost() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postRef
        .document(widget.profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();

    setState(() {
      isLoading = false;
      postCount = snapshot.documents.length;
      posts = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: userRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        OurUser user = OurUser.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            // mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildCountColumn("posts", postCount),

                              // buildCountColumn("followers", 0),
                              // buildCountColumn("following", 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildProfileButton(),
                            ],
                          ),
                        ],
                      ))
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 14),
                child: Text(
                  user.username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      user.displayName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    currentUserId != widget.profileId
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: GestureDetector(
                                onTap: () => customLaunch(
                                    "mailto:${user.email}?subject=test%20subject&body=test%20body"),
                                child: Icon(
                                  Icons.mail,
                                  size: 21,
                                )),
                          )
                        : Text(" ")
                  ],
                ),
              ),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   padding: EdgeInsets.only(top: 4),
              //   child: InkWell(
              //     onTap: () => customLaunch(user.webLink),
              //     child: Text(
              //       user.webLink,
              //       style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 14,
              //           color: Colors.blue[700]),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  buildButton({String label, Function function}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(22),
          ),
          width: 150,
          height: 40,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  editProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUser.id)));
  }

  buildProfileButton() {
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(label: "Edit Profile", function: editProfile);
    } else {
      return Text("");
    }
  }

  gridStyle(bool style) {
    setState(() {
      this.gridView = style;
    });
  }

  buildProfilePost() {
    if (isLoading) {
      return circularProgress();
    }
    List<GridTile> gridTiles = [];
    posts.forEach((post) {
      gridTiles.add(GridTile(child: PostTile(post)));
    });
    return !gridView
        ? Column(
            children: posts,
          )
        : GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: gridTiles,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        userId: currentUser.id,
        mediaUrl: currentUser.photoUrl,
        username: currentUser.username,
      ),
      appBar: header("Profile", context, fontsize: 35),
      body: ListView(children: <Widget>[
        buildProfileHeader(),
        Divider(
          height: 3,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => gridStyle(true),
                child: Icon(
                  Icons.grid_on,
                  color: gridView ? Theme.of(context).accentColor : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () => gridStyle(false),
                child: Icon(
                  Icons.list,
                  color:
                      !gridView ? Theme.of(context).accentColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        buildProfilePost()
      ]),
    );
  }
}
