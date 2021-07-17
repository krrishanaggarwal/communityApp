import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/root/root.dart';
import 'package:community/state/currentUser.dart';
import "package:flutter/material.dart";

import 'package:dropdownfield/dropdownfield.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../widgets/progress.dart';
import 'home.dart';
import 'loginform.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;
  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  OurUser user;
  TextEditingController displayNameText = TextEditingController();
  TextEditingController linkText = TextEditingController();
  TextEditingController fieldOfInterest = TextEditingController();
  bool _islinkValid = true;
  bool _isDisplayNameValid = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await userRef.document(widget.currentUserId).get();
    user = OurUser.fromDocument(doc);
    displayNameText.text = user.displayName;
    // linkText.text = user.webLink;
    fieldOfInterest.text = user.fieldOfInterest;
    setState(() {
      isLoading = false;
    });
  }

  buildDisplayNameField() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          TextField(
            controller: displayNameText,
            decoration: InputDecoration(
                errorText:
                    _isDisplayNameValid ? null : "Display Name too short",
                labelText: "DisplayName",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: "Update displayName"),
          )
        ],
      ),
    );
  }

  buildlinkField() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14),
      child: Column(
        children: [
          TextField(
            controller: linkText,
            maxLines: 2,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                errorText: _islinkValid ? null : "Link too long",
                labelText: "WebLink",
                hintText: "Update link"),
          )
        ],
      ),
    );
  }

  addFieldOfInterest() {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropDownField(
            enabled: true,
            itemsVisibleInDropdown: 3,
            items: fields,
            hintText: "Choose your Field Of Interest",
            controller: fieldOfInterest,
          )
        ],
      ),
    );
  }

  List<String> fields = [
    'DS and Algorithm',
    'Operating System',
    'Compiler Design',
    'Theory of Computation',
    'Competitive Programming',
    'DCLD',
    'Python',
    'Maths',
    'COA',
    'Computer Net',
    'DBMS',
    'Interview Prep',
  ];

  updateProfileData() {
    setState(() {
      displayNameText.text.trim().length < 3 || displayNameText.text.isEmpty
          ? _isDisplayNameValid = false
          : _isDisplayNameValid = true;
      linkText.text.length > 100 ? _islinkValid = false : _islinkValid = true;
    });

    if (_islinkValid && _isDisplayNameValid) {
      userRef.document(widget.currentUserId).updateData({
        "displayName": displayNameText.text,
        "webLink": linkText.text,
        "fieldOfInterest": fieldOfInterest.text
      });
    }
    if (fieldOfInterest.text != "Let's leave it for future") {
      userRef
          .document(widget.currentUserId)
          .updateData({"fieldOfInterest": fieldOfInterest.text});
    }

    SnackBar snackbar =
        SnackBar(content: Text("Profile Updated Successfully !"));

    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Center(
                child: Text(
              "EditProfile",
              style: TextStyle(color: Colors.black),
            )),
            backgroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: Icon(
                    Icons.done,
                    size: 30,
                  ),
                  color: Colors.green,
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
          body: isLoading
              ? circularProgress()
              : ListView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 8),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 50,
                              backgroundImage:
                                  CachedNetworkImageProvider(user.photoUrl),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: buildDisplayNameField(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: buildlinkField(),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: addFieldOfInterest(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: GestureDetector(
                              onTap: updateProfileData,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                width: 270,
                                height: 45,
                                child: Center(
                                  child: Text(
                                    "Update Profile",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: GestureDetector(
                              onTap: () => logout(context),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                width: 270,
                                height: 45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout),
                                    Center(
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
    );
  }
}

logout(context) async {
  CurrentState _currentUser =
      // Provider.of(context)<CurrentState>(context, listen: false);
      Provider.of<CurrentState>(context, listen: false);
  String retVal = await _currentUser.signOut();
  print(retVal);
  if (retVal == "success") {
    Text("adg");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => OurRoot()), (route) => false);
  }
}
