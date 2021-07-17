import 'dart:async';

import 'package:community/pages/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/header.dart';
import 'home.dart';

class RegisterationForm extends StatefulWidget {
  final String username;
  final String email;
  final String weblink;

  RegisterationForm({this.email, this.username, this.weblink});

  @override
  _RegisterationFormState createState() => _RegisterationFormState();
}

class _RegisterationFormState extends State<RegisterationForm> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool isUploading = false;
  TextEditingController numberController = TextEditingController();
  String number;
  _RegisterationFormState();
  createOrganizerEntry(number) {
    organizerEntry.document(widget.email).setData(
        {"username": widget.username, "email": widget.email, "number": number});
  }

  buildLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/logo.svg",
          height: 150,
          matchTextDirection: true,
        ),
        logo(),
      ],
    );
  }

  handleSubmit() {
    setState(() {
      isUploading = true;
    });
    createOrganizerEntry(
      number = numberController.text,
    );
    setState(() {
      isUploading = false;
    });
  }

  submit() async {
    await handleSubmit();
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(
        content:
            Text("We Have got your response..\nOur Team will contact you soon"),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext parentcontext) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: header("Registration Form", context, fontfamily: ""),
        body: Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(70),
                            bottomRight: Radius.circular(70))),
                  ),
                ),
              ),
              ListView(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  buildLogo(),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.blueGrey
                                  : Colors.white),
                          child: ListView(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Username : ${widget.username}",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Email : ${widget.email}",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Form(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          cursorColor: Colors.black,
                                          keyboardType: TextInputType.phone,
                                          validator: (val) {
                                            if (val.trim().length < 10 ||
                                                val.isEmpty ||
                                                val.length > 12) {
                                              return "Please provide us the Valid Phone Number";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (val) => number = val,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            labelText: "Mobile Number",
                                            labelStyle: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 32.0),
                                          child: GestureDetector(
                                            onTap: submit,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              width: 270,
                                              height: 45,
                                              child: Center(
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
