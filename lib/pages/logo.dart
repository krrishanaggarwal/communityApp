import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

logo({
  String font = "",
  double fontsize = 40,
}) {
  return Shimmer.fromColors(
      baseColor: Colors.pink,
      highlightColor: Colors.deepPurple,
      period: Duration(seconds: 4),
      child: Text("Talent Arc",
          style: TextStyle(fontSize: fontsize, fontFamily: font)));
}
