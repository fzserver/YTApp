import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player/youtube_player.dart';

class YTPlayer extends StatefulWidget {
  final String youtubeapi;
  final String videoID;
  final String title;

  YTPlayer({this.youtubeapi, this.videoID, this.title});

  @override
  _YTPlayerState createState() => _YTPlayerState();
}

class _YTPlayerState extends State<YTPlayer> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Center _ytPlayer() {
    return Center(
      child: YoutubePlayer(
        source: widget.videoID,
        quality: YoutubeQuality.HD,
        showThumbnail: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Scaffold(
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
                  _ytPlayer(),
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
        } else {
          return _ytPlayer();
        }
      },
    );
  }

}
