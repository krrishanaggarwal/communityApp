// import 'package:book_club/services/auth.dart';
// import 'package:book_club/widgets/shadowContainer.dart';
import 'package:community/pages/loginform.dart';
import 'package:community/state/currentUser.dart';
import 'package:community/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _signUpUser(String email, String password, BuildContext context,
      String fullName) async {
    CurrentState _currentUser =
        Provider.of<CurrentState>(context, listen: false);
    try {
      String _returnString =
          await _currentUser.signUpUser(email, password, fullName);
      if (_returnString == "success") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginForm()));
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(_returnString)));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (ShadowContainer(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hintText: "Full Name",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Email",
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Password",
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                hintText: "Confirm Password",
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onPressed: () {
                if (_passwordController.text ==
                    _confirmPasswordController.text) {
                  _signUpUser(_emailController.text, _passwordController.text,
                      context, _fullNameController.text);
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Passwords do not match"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ));
  }
}
