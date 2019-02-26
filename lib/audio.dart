import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum PlayerStatus { Playing, Paused, Resume, Stop }

class SingleAudio extends StatefulWidget {
  final String audioPath;
  SingleAudio(this.audioPath);

  @override
  _SingleAudioState createState() => _SingleAudioState();
}

class _SingleAudioState extends State<SingleAudio> {
  AudioPlayer audioPlayer = AudioPlayer();
  // int currentPlaying;
  PlayerStatus _playerStatus;
  Duration _duration;
  Duration _position;

  @override
  void initState() {
    // currentPlaying = -1;
    super.initState();
  }

  playpause(String url) async {
    PlayerStatus _playerStatusUpdate;
    if (_playerStatus == PlayerStatus.Playing) {
      await audioPlayer.pause();
      _playerStatusUpdate = PlayerStatus.Paused;
    } else if (_playerStatus == PlayerStatus.Paused) {
      await audioPlayer.resume();
      _playerStatusUpdate = PlayerStatus.Playing;
    } else {
      await audioPlayer.play(url);
      _playerStatusUpdate = PlayerStatus.Playing;
    }
    setState(() {
      _playerStatus = _playerStatusUpdate;
    });
  }

  stop() async {
    await audioPlayer.stop();
    _playerStatus = PlayerStatus.Stop;
    setState(() {
      playerIcon();
    });
  }

  // playpause(String url, int audioIndex) async {
  //   PlayerStatus _playerStatusUpdate;
  //   if (audioIndex == currentPlaying) {
  //     if (_playerStatus == PlayerStatus.Playing) {
  //       await audioPlayer.pause();
  //       _playerStatusUpdate = PlayerStatus.Paused;
  //     } else if (_playerStatus == PlayerStatus.Paused) {
  //       await audioPlayer.resume();
  //       _playerStatusUpdate = PlayerStatus.Playing;
  //     }
  //   } else {
  //     await audioPlayer.play(url);
  //     _playerStatusUpdate = PlayerStatus.Playing;
  //   }
  //   setState(() {
  //     currentPlaying = audioIndex;
  //     _playerStatus = _playerStatusUpdate;
  //   });
  // }

  Widget playerIcon() {
    if (_playerStatus == PlayerStatus.Playing) {
      return Icon(
        Icons.pause,
        color: Colors.deepOrangeAccent,
        size: 50.0,
      );
    }
    return Icon(
      Icons.play_arrow,
      color: Colors.deepOrange,
      size: 50.0,
    );
  }

  Widget stopIcon() {
    return Icon(
      Icons.stop,
      color: Colors.deepOrangeAccent,
      size: 50.0,
    );
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  // Widget playerIcon(index) {
  //   if (index == currentPlaying && _playerStatus == PlayerStatus.Playing) {
  //     return Icon(
  //       Icons.pause,
  //       color: Colors.deepOrangeAccent,
  //     );
  //   }
  //   return Icon(
  //     Icons.play_arrow,
  //     color: Colors.deepOrange,
  //   );
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Media'),
        ),
        body: Center(
          child: Container(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 200.0,
                    height: 200.0,
                    child: Center(
                      child: Image.asset('music.png'),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: playerIcon(),
                          onPressed: () => playpause(widget.audioPath),
                        ),
                        IconButton(
                          icon: stopIcon(),
                          onPressed: () => stop(),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Center(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Stack(
                          children: <Widget>[
                            CircularProgressIndicator(
                              value: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.grey[300]),
                            ),
                            CircularProgressIndicator(
                              value: (_position != null &&
                                      _duration ! -null &&
                                      _position.inMilliseconds > 0 &&
                                      _position.inMilliseconds <
                                          _duration.inMilliseconds)
                                  ? _position.inMilliseconds /
                                      _duration.inMilliseconds
                                  : 0.0,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.deepOrange),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      );
}
