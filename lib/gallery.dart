import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ytapp/transparent.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final String apiUrl =
      "https://firebasestorage.googleapis.com/v0/b/flutter-884a9.appspot.com/o/ph.json?alt=media&token=e56b2a14-c32b-4e6b-9144-ca7f4b0801b9";
  List photos;
  bool _loading = false;

  getphotos() async {
    var res = await http.get(apiUrl);

    setState(() {
      var gallery = json.decode(res.body);
      photos = gallery;
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;
    super.initState();
    this.getphotos();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        child: Builder(builder: (BuildContext context) {
          if (this._loading == true) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (this.photos == null) {
            return Center(
              child: Text("No Photos found"),
            );
          }
          return ListView.builder(
            itemCount: photos == null ? 0 : photos.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => {},
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          FadeInImage.memoryNetwork(
                            placeholder: transparentImage,
                            image: photos[index]["url"],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }),
      ),
    ]);
  }
}
