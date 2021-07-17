// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/pages/usertile.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

// import 'package:fluttershare/pages/activity_feed.dart';

import '../models/user.dart';
import '../widgets/progress.dart';
import 'home.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Stream<QuerySnapshot> searchResultsFuture;
  List<dynamic> usernames = [];
  double height = 120;
  int itemsVisibleInDropdown = 1;

  @override
  void initState() {
    getUsers();

    super.initState();
  }

  // handleSearch(query) {
  //   Future<QuerySnapshot> searchedUsers = userRef
  //       .where('displayName', isGreaterThanOrEqualTo: query)
  //       .getDocuments();
  //   setState(() {
  //     searchResultsFuture = searchedUsers;
  //   });
  // }

  handleSearch(query) {
    setState(() {
      height = 100;
    });
    if (query != "") {
      Stream<QuerySnapshot> searchedPosts =
          userRef.where('username', isEqualTo: query).snapshots();
      setState(() {
        searchResultsFuture = searchedPosts;
      });
    } else {
      print("object");
    }
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      itemsVisibleInDropdown = 1;
      height = 120;
    });
  }

  getUsers() async {
    var snapshots = await userRef.getDocuments();

    List<String> names = [];

    var snap = snapshots.documents.map((i) => i['username']).toList();
    for (var i = 0; i < snap.length; i++) {
      names.add(snap[i]);
    }
    setState(() {
      usernames = names;
    });
  }

  // clearSearch() {
  //   searchController.clear();
  // }

  AppBar buildSearchField() {
    return AppBar(
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: DropDownField(
              // strict: true,
              // enabled: true,

              controller: searchController,
              items: usernames,
              itemsVisibleInDropdown: itemsVisibleInDropdown,
              hintText: "Search for Users",
              onValueChanged: (value) {
                setState(() {
                  searchController.text = value;
                  itemsVisibleInDropdown = 0;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: clearSearch,
          color: Colors.black87,
          icon: Icon(Icons.clear),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
              color: Colors.black87,
              icon: Icon(Icons.search),
              onPressed: () => handleSearch(searchController.text)),
        ),
      ],
    );
  }

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.black54,
              child: FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Tap to Search by tag",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildSearchResult() {
    return StreamBuilder(
        stream: searchResultsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<UserResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            OurUser user = OurUser.fromDocument(doc);
            UserResult searchResult = UserResult(user);
            searchResults.add(searchResult);
          });
          return ListView(children: searchResults);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildSearchField(),
        body: searchResultsFuture == null
            ? buildNoContent()
            : buildSearchResult(),
      ),
    );
  }
}
