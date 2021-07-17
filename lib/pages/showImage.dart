import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:slimy_card/slimy_card.dart';
// import 'activity_feed.dart';
import 'activity_feed.dart';
import 'postgrid.dart';

class ShowImage extends StatelessWidget {
  final String mediaUrl;
  final String description;
  final String profileId;
  final String username;

  ShowImage({this.description, this.mediaUrl, this.profileId, this.username});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.grey[700],
        body: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: SlimyCard(
                  color: Theme.of(context).accentColor.withOpacity(0.071),
                  width: width * 1,
                  topCardHeight: height * 0.6,
                  bottomCardHeight: height * 0.3,
                  borderRadius: 16,
                  topCardWidget: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(mediaUrl),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text("-$username",
                            style: TextStyle(
                              fontFamily: "Alison",
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                  bottomCardWidget: ListView(
                    children: [
                      description == ""
                          ? Text("")
                          : Text(
                              "Description : ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontFamily: "Ubuntu",
                                  fontSize: 25,
                                  color: Colors.amber),
                            ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 7, right: 10),
                        child: Text(
                          description,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              wordSpacing: 2,
                              letterSpacing: 1.2),
                        ),
                      ),
                    ],
                  ),
                  slimeEnabled: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      FloatingActionButton(
                          splashColor: Colors.amber,
                          onPressed: () => downloadImage(mediaUrl),
                          heroTag: null,
                          tooltip: "Download Image",
                          child: Icon(
                            Icons.download_sharp,
                          )),
                      SizedBox(
                        height: 7,
                      ),
                      FloatingActionButton(
                          onPressed: () =>
                              showProfile(context, profileId: profileId),
                          tooltip: "Visit Profile",
                          heroTag: null,
                          child: Icon(
                            Icons.account_circle,
                          )),
                      // GestureDetector(
                      //     onTap: () =>
                      //         showProfile(context, profileId: profileId),
                      //     child: Icon(
                      //       Icons.account_circle_sharp,
                      //       color: Theme.of(context).accentColor,
                      //       size: 55,
                      //     )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ]));
  }
}
