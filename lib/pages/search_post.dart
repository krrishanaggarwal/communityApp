import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../models/postByCategory.dart';
import '../widgets/progress.dart';
import 'home.dart';
import 'postgrid.dart';
import 'search.dart';

class SearchPost extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPost> {
  TextEditingController searchController = TextEditingController();
  Stream<QuerySnapshot> searchResultsFuture;
  List<dynamic> tagItems = [];
  double height = 120;
  int itemsVisibleInDropdown = 1;

  @override
  void initState() {
    getTags();

    super.initState();
  }

  handleSearch(query) {
    setState(() {
      height = 70;
    });
    if (query != "") {
      Stream<QuerySnapshot> searchedPosts =
          postByCategoryRef.where('tag', isEqualTo: query).snapshots();
      setState(() {
        searchResultsFuture = searchedPosts;
      });
    } else {
      print("object");
    }
  }

  getTags() async {
    var snapshots = await postByCategoryRef.getDocuments();

    List<String> tags = [];

    var snap = snapshots.documents.map((i) => i['tag']).toList();
    for (var i = 0; i < snap.length; i++) {
      tags.add(snap[i]);
    }
    setState(() {
      tagItems = tags;
    });
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      itemsVisibleInDropdown = 1;
      height = 120;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      // backgroundColor: Colors.white,
      title: SafeArea(
        child: DropDownField(
          strict: true,
          // enabled: true,
          enabled: true,

          controller: searchController,
          items: tagItems,
          itemsVisibleInDropdown: itemsVisibleInDropdown,
          hintText: "Search by tag",
          onValueChanged: (value) {
            setState(() {
              searchController.text = value;
              itemsVisibleInDropdown = 0;
            });
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            onPressed: clearSearch,
            icon: Icon(Icons.clear),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => handleSearch(searchController.text)),
        )
      ],
    );
  }

  // filled: true,

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SvgPicture.asset(
                'assets/images/search.svg',
                height: orientation == Orientation.portrait ? 300.0 : 200.0,
              ),
            ),
            // RaisedButton(
            //   color: Theme.of(context).accentColor,
            //   onPressed: () => Navigator.push(
            //       context, MaterialPageRoute(builder: (context) => Search())),
            //   child: Text(
            //     " Tap to Search Profiles by Username",
            //     style: TextStyle(color: Colors.white, fontSize: 20),
            //   ),

            // ),
            Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.black54,
              child: FlatButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search())),
                child: Text(
                  "Tap to Search By userName",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              // child: GestureDetector(
              //   onTap: () => Navigator.push(
              //       context, MaterialPageRoute(builder: (context) => Search())),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).accentColor,
              //       borderRadius: BorderRadius.circular(18),
              //     ),
              //     width: 270,
              //     height: 45,
              //     child: Center(
              //       child: Text(
              //         "Search by User ",
              //         style: TextStyle(
              //             color: Colors.pink,
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),
              // ),
            ),
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
          List<PostResult> searchResults = [];
          snapshot.data.documents.forEach((doc) {
            PostByCategory post = PostByCategory.fromDocument(doc);
            PostResult searchResult = PostResult(post);
            searchResults.add(searchResult);
            // print(snapshot.data);
          });
          return GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: searchResults);
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
        appBar: buildSearchField(),
        body: searchResultsFuture == null
            ? buildNoContent()
            : buildSearchResult(),
      ),
    );
  }
}
