import 'package:community/root/root.dart';

import 'package:community/state/currentUser.dart';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentState(),
      // create: (_) => ThemeNotifier(),
      child: MaterialApp(
        title: 'community',
        debugShowCheckedModeBanner: false,
        // theme: notifier.darktheme ? dark : light,
        home: OurRoot(),
      ),
    );
  }
}
