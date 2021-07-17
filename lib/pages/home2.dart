import 'package:community/state/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loginform.dart';

class Home2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: () async {
          CurrentState _currentUser =
              Provider.of(context)<CurrentState>(context, listen: false);
          print(
              "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
          print(_currentUser);
          String retVal = await _currentUser.signOut();
          if (retVal == "success") {
            print("signout ogkgkkkkkkkkkkkkkkkkkkk");
            Text("adg");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginForm()),
                (route) => false);
          } else {
            print(
                "fhjg55555555555555555555555555555555555555555555555555555555kuk");
          }
        },
        child: Text("logout"));
  }
}
