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
  Widget build(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            Center(
              child: YoutubePlayer(
                source: widget.videoID,
                quality: YoutubeQuality.HD,
                showThumbnail: true,
              ),
            ),
          ],
        ),
      );
}
