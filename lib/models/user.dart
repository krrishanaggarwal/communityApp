import 'package:cloud_firestore/cloud_firestore.dart';

class OurUser {
  String id;
  String username;
  String email;
  String photoUrl = "";
  String fieldOfInterest = "Ds";
  String displayName = "not assigned";
  bool isOrganizer = false;

  OurUser(
      {
      // this.fieldOfInterest,
      this.displayName,
      this.email,
      this.id,
      this.photoUrl,
      this.fieldOfInterest,
      this.username,
      this.isOrganizer});

  factory OurUser.fromDocument(DocumentSnapshot doc) {
    return OurUser(
        id: doc['id'],
        email: doc['email'],
        username: doc['username'],
        photoUrl: doc['photoUrl'],
        displayName: doc['displayName'],
        isOrganizer: doc['isOrganizer'],
        fieldOfInterest: doc['fieldOfInterest']);
  }
}
