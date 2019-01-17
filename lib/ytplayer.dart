import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class YTPlayer extends StatefulWidget {
  String youtubeapi;
  String videoID;
  String title;
  YTPlayer({this.youtubeapi, this.videoID, this.title});
  @override
  _YTPlayerState createState() => _YTPlayerState();
}

class _YTPlayerState extends State<YTPlayer> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          // backgroundColor: Color(0xfff8faf8),
          centerTitle: true,
          elevation: 1.0,
          title: Text(
            'DAMDAMI TAKSAL',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: YoutubePlayer(
                  source: widget.videoID,
                  quality: YoutubeQuality.HD,
                  showThumbnail: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 80.0,
                  width: double.infinity,
                  child: Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          '${widget.title}',
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    color: Colors.yellow,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
