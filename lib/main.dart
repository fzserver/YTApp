import 'package:flutter/material.dart';
import 'package:ytapp/home.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(YTAPP());
}

class YTAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(primaryColor: Colors.white, accentColor: Colors.black),
        title: "DAMDAMI TAKSAL",
        home: YTHome(),
      );
}
