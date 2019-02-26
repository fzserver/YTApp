import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ytapp/post.dart';
import 'package:ytapp/transparent.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  // Base URL for our wordpress API
  final String apiUrl = "https://damdamitaksal.net/wp-json/wp/v2/";
  // Empty list for our posts
  List posts;
  bool _loading;

  // Function to fetch list of posts
  getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed"),
        headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
      _loading = false;
    });

    return "Success!";
  }

  @override
  void initState() {
    _loading = true;
    super.initState();
    this.getPosts();
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

          if (this.posts == null) {
            return Center(
              child: Text("No Posts found"),
            );
          }
          return ListView.builder(
            itemCount: posts == null ? 0 : posts.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Post(
                                  posts[index]["featured_media"] == 0
                                      ? 'placeholder.jpg'
                                      : posts[index]["_embedded"]
                                          ["wp:featuredmedia"][0]["source_url"],
                                  posts[index]["title"]["rendered"],
                                  posts[index]["content"]["rendered"]))),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            FadeInImage.memoryNetwork(
                              placeholder: transparentImage,
                              image: posts[index]["featured_media"] == 0
                                  ? 'placeholder.jpg'
                                  : posts[index]["_embedded"]
                                      ["wp:featuredmedia"][0]["source_url"],
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: ListTile(
                                title: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text(
                                        posts[index]["title"]["rendered"])),
                                subtitle: Text(posts[index]["excerpt"]
                                        ["rendered"].replaceAll(RegExp(r'<[^>]*>'), '')),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              );
            },
          );
        }),
      ),
    ]);
  }
}
