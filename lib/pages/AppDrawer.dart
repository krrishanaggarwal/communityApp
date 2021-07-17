import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/pages/edit_profile.dart';
import 'package:community/pages/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/progress.dart';

import 'home.dart';
import 'register_Organizer.dart';
import 'usertile.dart';

class AppDrawer extends StatefulWidget {
  final String userId;
  final String username;
  final String mediaUrl;
  AppDrawer({this.userId, this.username, this.mediaUrl});

  @override
  _AppDrawerState createState() => _AppDrawerState(
      userId: this.userId, username: this.username, mediaUrl: this.mediaUrl);
}

class _AppDrawerState extends State<AppDrawer> {
  final String userId;
  final String username;
  final String mediaUrl;
  Future<QuerySnapshot> organizers;
  _AppDrawerState({this.userId, this.username, this.mediaUrl});
  eventOrganizers() {
    // Future<QuerySnapshot> registeredUsers = userRef.getDocuments();
    Future<QuerySnapshot> registeredUsers =
        userRef.where('isOrganizer', isEqualTo: true).getDocuments();
    setState(() {
      organizers = registeredUsers;
      print(organizers);
    });
  }

  buildOrganizers() {
    eventOrganizers();

    return FutureBuilder(
        future: organizers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }

          // print(snapshot.data);

          List<EventOrganizers> results = [];
          snapshot.data.documents.forEach((doc) {
            OurUser user = OurUser.fromDocument(doc);
            EventOrganizers searchResult = EventOrganizers(user);
            results.add(searchResult);
          });
          return ListView(children: results);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10, left: 20),
                child: CircleAvatar(
                  backgroundImage: mediaUrl == null
                      ? CachedNetworkImageProvider("")
                      : CachedNetworkImageProvider(mediaUrl),
                  backgroundColor: Colors.grey,
                  radius: 50,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                  onPressed: () => logout(context),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.logout), Text("Logout")])),
            ),

            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    notifier.darktheme
                        ? FlatButton(
                            onPressed: () => notifier.toggleTheme(),
                            child: Text("Switch to Light Mode"))
                        : FlatButton(
                            onPressed: () => notifier.toggleTheme(),
                            child: Text("Switch to Dark Mode")),
                    notifier.darktheme
                        ? IconButton(
                            onPressed: () => notifier.toggleTheme(),
                            icon: Icon(
                              WeatherIcons.wi_day_sunny,
                              size: 15,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 9.0),
                            child: IconButton(
                              icon: Icon(
                                WeatherIcons.wi_moon_waning_crescent_2,
                                size: 23,
                              ),
                              onPressed: () => notifier.toggleTheme(),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: FlatButton(
            //       onPressed: () => DynamicTheme.of(context).setBrightness(
            //           Theme.of(context).brightness == Brightness.light
            //               ? Brightness.dark
            //               : Brightness.light),
            //       child: Row(children: [
            //         Icon(Theme.of(context).brightness == Brightness.light
            //             ? Icons.lightbulb
            //             : Icons.highlight),
            //         Text("Switch Theme")
            //       ])),
            // ),

            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/logo.svg",
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Event Organizers",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: buildOrganizers(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 20),
              child: currentUser.isOrganizer == true
                  ? Text("")
                  : GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterationForm(
                                    email: currentUser.email,
                                    // weblink: currentUser.webLink,
                                    username: currentUser.username,
                                  ))),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        width: 300,
                        height: 45,
                        child: Center(
                          child: Text(
                            "Register as a event Organizer",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
            )

            // Padding(
            //   padding: const EdgeInsets.only(top: 10, bottom: 14),
            //   child: RaisedButton(
            //     onPressed: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => RegisterationForm(
            //                   email: currentUser.email,
            //                   weblink: currentUser.webLink,
            //                   username: currentUser.username,
            //                 ))),
            //     child: Text("Register as a event Organizer"),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
