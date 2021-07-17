import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community/models/user.dart';

class OurDatabase {
  final Firestore _firestore = Firestore.instance;
  Future<String> createUser(OurUser user) async {
    String retVal = "error";
    try {
      await _firestore.collection("users").document(user.id).setData({
        'username': user.username,
        'email': user.email,
        // 'fieldOfInterest': user.fieldOfInterest,
        'isOrganiser': user.isOrganizer,
        'photoUrl': user.photoUrl,
        'displayName': user.username,
        'id': user.id,
      });
      retVal = "Success";
      return retVal;
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<OurUser> getUserInfo(String uid) async {
    OurUser retVal = OurUser();
    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection("users").document(uid).get();
      retVal.id = uid;
      retVal.username = _docSnapshot.data["username"];
      retVal.email = _docSnapshot.data["email"];
      retVal.photoUrl = _docSnapshot.data["photoUrl"];
      retVal.isOrganizer = _docSnapshot.data["isOrganiser"];
      retVal.displayName = _docSnapshot.data["displayName"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
