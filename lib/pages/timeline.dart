// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/postByCategory.dart';
import '../models/user.dart';
import '../widgets/header.dart';
import '../widgets/progress.dart';
import 'AppDrawer.dart';
import 'home.dart';
import 'showMore.dart';
import 'timelinePOstgrid.dart';

class Timeline extends StatefulWidget {
  final OurUser currentUser;
  Timeline({this.currentUser});
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> timelinePosts;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    {
      setState(() {
        isLoading = true;
      });
      // currentUser =.currentUser as OurUser;
      FirebaseUser _firebaseUser = await _auth.currentUser();
      var doc = await userRef.document(_firebaseUser.uid).get();

      currentUser = OurUser.fromDocument(doc);
      print("2222222222222222222222222222222222222222222222222222222222222222");
      print(currentUser.username);

      Stream<QuerySnapshot> posts = postByCategoryRef.snapshots();
      setState(() {
        timelinePosts = posts;
        isLoading = false;
      });
    }
  }

  buildArtwork(tag) {
    return FutureBuilder(
        future: postByCategoryRef
            .where("tag", isEqualTo: tag)
            .orderBy("timestamp", descending: true)
            .limit(6)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<TimelinePostResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            if (!snapshot.hasData) {
              circularProgress();
            }
            PostByCategory post = PostByCategory.fromDocument(doc);
            TimelinePostResult searchResult = TimelinePostResult(post);
            searchResults.add(searchResult);
            // print(snapshot.data);
          });
          return Container(
            margin: EdgeInsets.only(left: 3, right: 3),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: GridView(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 10,
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 9,
                      childAspectRatio: 16 / 12,
                    ),
                    children: searchResults)),
          );
        });
  }

  buildDCLD(tag) {
    return FutureBuilder(
        future: postByCategoryRef
            .where("tag", isEqualTo: tag)
            .orderBy("timestamp", descending: true)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<TimelinePostResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            if (!snapshot.hasData) {
              circularProgress();
            }
            PostByCategory post = PostByCategory.fromDocument(doc);
            TimelinePostResult searchResult = TimelinePostResult(post);
            searchResults.add(searchResult);
            // print(snapshot.data);
          });
          return Container(
            margin: EdgeInsets.only(left: 3, right: 3),
            height: MediaQuery.of(context).size.height * 0.23,
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: StaggeredGridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 4,
                  crossAxisCount: 4,
                  staggeredTiles: [
                    StaggeredTile.count(2, 2),
                    StaggeredTile.count(1, 1),
                    StaggeredTile.count(1, 1),
                    StaggeredTile.count(1, 1),
                    StaggeredTile.count(1, 1),
                  ],
                  children: searchResults),
            ),
          );
        });
  }

  buildQuotes(tag) {
    return FutureBuilder(
        future: postByCategoryRef
            .where("tag", isEqualTo: tag)
            .orderBy("timestamp", descending: true)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<TimelinePostResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            if (!snapshot.hasData) {
              circularProgress();
            }
            PostByCategory post = PostByCategory.fromDocument(doc);
            TimelinePostResult searchResult = TimelinePostResult(post);
            searchResults.add(searchResult);
            // print(snapshot.data);
          });
          return Container(
            margin: EdgeInsets.only(left: 3, right: 3),
            height: MediaQuery.of(context).size.height * 0.52,
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: StaggeredGridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 6,
                  crossAxisCount: 4,
                  staggeredTiles: [
                    StaggeredTile.count(6, 3),
                    StaggeredTile.count(2, 2),
                    StaggeredTile.count(2, 2),

                    // StaggeredTile.count(1, 1),
                  ],
                  children: searchResults),
            ),
          );
        });
  }

  buildDesign(tag) {
    return FutureBuilder(
        future: postByCategoryRef
            .where("tag", isEqualTo: tag)
            .orderBy("timestamp", descending: true)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<TimelinePostResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            if (!snapshot.hasData) {
              circularProgress();
            }
            PostByCategory post = PostByCategory.fromDocument(doc);
            TimelinePostResult searchResult = TimelinePostResult(post);
            searchResults.add(searchResult);
            // print(snapshot.data);
          });
          return Container(
            margin: EdgeInsets.only(left: 3, right: 3),
            height: MediaQuery.of(context).size.height * 0.28,
            child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: GridView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      // mainAxisSpacing: 10,
                      maxCrossAxisExtent: 400,

                      crossAxisSpacing: 9,
                      childAspectRatio: 16 / 16,
                    ),
                    children: searchResults)),
          );
        });
  }

  buildUpcomingEvents(tag) {
    return FutureBuilder(
        future: postByCategoryRef
            .where("tag", isEqualTo: tag)
            .where("isOrganizer", isEqualTo: true)
            .orderBy("timestamp", descending: true)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<TimelinePostResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            if (!snapshot.hasData && isLoading == false) {
              circularProgress();
            }
            PostByCategory post = PostByCategory.fromDocument(doc);
            TimelinePostResult searchResult = TimelinePostResult(post);
            searchResults.add(searchResult);
            // print(snapshot.data);
          });
          return CarouselSlider(
              items: searchResults,
              options: optionCaroselSlider(
                  enableInfiniteScroll: true,
                  autoplay: true,
                  enlargeCenterPage: true,
                  reverse: true,
                  initialPage: 2,
                  autoPlayAnimationSeconds: 5,
                  autoPlayIntervalSeconds: 900,
                  autoPlayCurve: Curves.slowMiddle));
        });
  }

  optionCaroselSlider({
    double aspectRatio = 16 / 12,
    double viewPortFraction: 0.7,
    int initialPage: 3,
    enableInfiniteScroll: false,
    bool reverse = true,
    bool autoplay = false,
    int autoPlayIntervalSeconds = 3,
    int autoPlayAnimationSeconds = 600,
    bool enlargeCenterPage = false,
    pageSnapping: true,
    bool disableCenter = true,
    autoPlayCurve: Curves.slowMiddle,
  }) {
    return CarouselOptions(
      pageSnapping: true,
      height: MediaQuery.of(context).size.height * 0.2,
      aspectRatio: aspectRatio,
      viewportFraction: viewPortFraction,
      initialPage: initialPage,
      autoPlay: autoplay,
      enableInfiniteScroll: enableInfiniteScroll,
      reverse: reverse,
      autoPlayInterval: Duration(seconds: autoPlayAnimationSeconds),
      autoPlayAnimationDuration:
          Duration(milliseconds: autoPlayAnimationSeconds),
      autoPlayCurve: autoPlayCurve,
      enlargeCenterPage: enlargeCenterPage,
    );
  }

  heading({String heading, String tag, bool isOrganizer: false}) {
    return Padding(
        padding: const EdgeInsets.only(top: 6, left: 6),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              heading,
              style: TextStyle(
                fontFamily: "Ubuntu",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FlatButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShowMore(tag: tag, isOrganizer: isOrganizer))),
              // icon: Icon(Icons.more),
              child: Text(
                "ShowMore",
                style: TextStyle(fontFamily: "Ubuntu"),
              ),
            ),
          )
        ]));
  }

  // List<dynamic> users = [];
  @override
  Widget build(context) {
    return Scaffold(
        drawerEdgeDragWidth: 0,
        // backgroundColor: Colors.grey[200],
        appBar: header("TalentArc", context, fontsize: 40),
        drawer: AppDrawer(
          mediaUrl: currentUser.photoUrl,
          userId: currentUser.id,
          username: currentUser.username,
        ),
        body: RefreshIndicator(
          onRefresh: () => getTimeline(),
          child: ListView(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              heading(
                  heading: "Top Priority",
                  tag: "Top Priority",
                  isOrganizer: true),
              buildUpcomingEvents("Top Priority"),
              Divider(
                height: 15,
              ),
              heading(heading: "DS and Algorithm", tag: "DS and Algorithm"),
              buildArtwork("DS and Algorithm"),
              Divider(height: 15),
              heading(
                  heading: "Theory of Computation",
                  tag: "Theory of Computation"),
              buildArtwork("Theory of Computation"),
              Divider(height: 15),
              heading(heading: "Operating System", tag: "Operating System"),
              buildArtwork("Operating System"),
              Divider(height: 15),
              heading(heading: "Maths", tag: "Maths"),
              buildArtwork("Maths"),
              Divider(height: 15),
              heading(heading: "Computer Net", tag: "Computer Net"),
              buildArtwork("Computer Net"),
              Divider(height: 15),
              heading(heading: "Python", tag: "Python"),
              buildDesign("Python"),
              Divider(height: 15),
              heading(heading: "DCLD", tag: "DCLD"),
              buildDCLD("DCLD"),
              Divider(height: 15),
              heading(heading: "COA", tag: "COA"),
              buildDCLD("COA"),
              Divider(height: 15),
              heading(heading: "DBMS", tag: "DBMS"),
              buildQuotes("DBMS"),
              Divider(height: 15),
              heading(heading: "Compiler Design", tag: "Compiler Design"),
              buildArtwork("Compiler Design"),
              Divider(height: 15),
              heading(heading: "Interview Prep", tag: "Interview Prep"),
              buildArtwork("Interview Prep"),
              Divider(height: 15),
            ])
          ]),
        ));
  }
}
