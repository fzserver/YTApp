import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum PlayerStatus { Playing, Paused, Resume, Stop }

class Audios extends StatefulWidget {
  @override
  _AudiosState createState() => _AudiosState();
}

class _AudiosState extends State<Audios> {
  List audioList;
  AudioPlayer audioPlayer = AudioPlayer();
  bool loading;
  int playaudio;
  int currentPlaying;
  PlayerStatus _playerStatus;

  @override
  void initState() {
    loading = true;
    fetchListAudio();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  void fetchListAudio() async {
    final response = await http.get(
        'https://damdamitaksal.net/wp-json/wp/v2/media?per_page=20&media_type=audio');
    List audios = json.decode(response.body);
    setState(() {
      audioList = audios;
      playaudio = 0;
      loading = false;
      currentPlaying = -1;
      _playerStatus = PlayerStatus.Stop;
    });
  }

  playpause(String url, int audioIndex) async {
    PlayerStatus _playerStatusUpdate;
    if (audioIndex == currentPlaying) {
      if (_playerStatus == PlayerStatus.Playing) {
        await audioPlayer.pause();
        _playerStatusUpdate = PlayerStatus.Paused;
      } else if (_playerStatus == PlayerStatus.Paused) {
        await audioPlayer.resume();
        _playerStatusUpdate = PlayerStatus.Playing;
      }
    } else {
      await audioPlayer.play(url);
      _playerStatusUpdate = PlayerStatus.Playing;
    }
    setState(() {
      currentPlaying = audioIndex;
      _playerStatus = _playerStatusUpdate;
    });
  }

  Widget playerIcon(index) {
    if (index == currentPlaying && _playerStatus == PlayerStatus.Playing) {
      return Icon(
        Icons.pause,
        color: Colors.deepOrangeAccent,
      );
    }
    return Icon(
      Icons.play_arrow,
      color: Colors.deepOrange,
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Expanded(
            child: Builder(
              builder: (BuildContext context) {
                if (loading == true) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (audioList == null) {
                  return Center(
                    child: Text('No Audios Found.'),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(color: Colors.grey, height: 1.0),
                  itemCount: audioList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Hero(
                        tag:
                            '${audioList[index]['title']['rendered'].toString()}',
                        child: FadeInImage(
                          width: 50.0,
                          height: 50.0,
                          image: AssetImage('album.png'),
                          fit: BoxFit.contain,
                          placeholder: AssetImage('album.png'),
                        ),
                      ),
                      title: Text(
                          '${audioList[index]['title']['rendered'].toString()}'),
                      trailing: IconButton(
                        icon: playerIcon(index),
                        onPressed: () => playpause(
                            '${audioList[index]['source_url'].toString()}',
                            index),
                      ),
                    );
                  },
                );
                // return Card(child: Text('${audioList[index]['source_url'].toString()}'),);
              },
            ),
          )
        ],
      );
}
