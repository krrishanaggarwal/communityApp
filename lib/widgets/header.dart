import 'package:flutter/material.dart';

header(String title, context,
    {bool removeBackButton = false,
    double fontsize = 25,
    bool logo = false,
    String fontfamily = "Signatra"}) {
  return AppBar(
      titleSpacing: 20,
      automaticallyImplyLeading: removeBackButton ? false : true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo
              ? Image.asset(
                  "assets/images/logo2.png",
                  height: 130,
                  width: 130,
                )
              : Text(""),
          Text(
            title,
            style: TextStyle(
                fontFamily: fontfamily,
                fontSize: fontsize,
                color: Colors.white),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent);
}
