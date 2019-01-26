import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          'Photo Gallery',
          style: TextStyle(
              color: Color.fromRGBO(17, 28, 59, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 18.0),
        ),
      );
}
