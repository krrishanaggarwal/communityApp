import 'package:device_preview/plugins.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.pink,
  fontFamily: "Ubuntu",
  accentColor: Colors.pink[800],
  scaffoldBackgroundColor: Color(0xfff1f1f1),
);

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    // primarySwatch: Color(0xff3a001d),
    fontFamily: "Ubuntu",
    scaffoldBackgroundColor: Colors.blueGrey[800],
    accentColor: Colors.pink[900]
    // primaryColor: Colors.white,
    // accentColor: Colors.teal,
    // scaffoldBackgroundColor: Color(0xfff1f1f1),
    );

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferencesExplorerPlugin prefs;
  bool _darkTheme;

  bool get darktheme => _darkTheme;
  ThemeNotifier() {
    _darkTheme = false;
  }
  toggleTheme() {
    _darkTheme = !_darkTheme;
    notifyListeners();
  }
}
