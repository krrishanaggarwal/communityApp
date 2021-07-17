import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/postByCategory.dart';
import '../widgets/header.dart';
import '../widgets/progress.dart';
import 'home.dart';
import 'postgrid.dart';

class ShowMore extends StatefulWidget {
  final String tag;

  final bool isOrganizer;
  ShowMore({this.tag, this.isOrganizer = false});
  @override
  _ShowMoreState createState() => _ShowMoreState();
}

class _ShowMoreState extends State<ShowMore> {
  Stream<QuerySnapshot> searchResultsFuture;

  // @override
  // void initState() {
  //   handleSearch(widget.tag);

  //   super.initState();
  // }

  handleSearch(tag, isOrganizer) {
    {
      if (tag != null) {
        Stream<QuerySnapshot> searchedPosts = postByCategoryRef
            .where('tag', isEqualTo: tag)
            .where('isOrganizer', isEqualTo: isOrganizer)
            .snapshots();
        setState(() {
          searchResultsFuture = searchedPosts;
        });
      } else {
        print("object");
      }
    }
  }

  buildSearchResult() {
    return StreamBuilder(
        stream: postByCategoryRef
            .where("tag", isEqualTo: widget.tag)
            .where("isOrganizer", isEqualTo: widget.isOrganizer)
            .snapshots(),
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
              padding: const EdgeInsets.all(11),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 10,
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 14,
                childAspectRatio: 1,
              ),
              children: searchResults);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(widget.tag, context),
      body: buildSearchResult(),
    );
  }
}
