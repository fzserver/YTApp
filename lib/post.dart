import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ytapp/transparent.dart';
import 'package:html/dom.dart' as dom;

class Post extends StatefulWidget {
  final String pImg;
  final String pTitle;
  final String pSubtitle;
  Post(this.pImg, this.pTitle, this.pSubtitle);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Post', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Card(
                child: Column(
              children: <Widget>[
                FadeInImage.memoryNetwork(
                  placeholder: transparentImage,
                  image: widget.pImg,
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          widget.pTitle,
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Html(
                        data: "${widget.pSubtitle}",
                        //Optional parameters:
                        padding: EdgeInsets.all(0.0),
                        onLinkTap: (url) {
                          print("Opening $url...");
                        },
                        customRender: (node, children) {
                          if (node is dom.Element) {
                            switch (node.localName) {
                              case "custom_tag":
                                return Column(children: children);
                            }
                          }
                        },
                      ),
                    )),
              ],
            )),
          ]),
        ),
      );
}
