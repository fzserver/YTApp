import 'package:flutter/material.dart';
import 'package:ytapp/home.dart';

void main() => runApp(YTAPP());

class YTAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: true,
    theme: ThemeData(primaryColor: Colors.white, accentColor: Colors.black),
    title: "Youtube Channel",
    home: YTHome(),
  );
}