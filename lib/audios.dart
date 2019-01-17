import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.get('https://damdamitaksal.net/wp-json/wp/v2/media?per_page=20&media_type=audio');
    List audios = json.decode(response.body);
    setState(() {
      audioList = audios;
      playaudio = 0;
      loading = false;
      currentPlaying = -1;
    });
  }

  playpause(int play, String url, int audioIndex) async {
    int currentAction = 0;
    if (play == 0) {
      currentAction = 1;
      await audioPlayer.play(url);
    } else if (play == 1) {
      currentAction = 2;
      await audioPlayer.pause();
    } else if (play == 2) {
      currentAction = 1;
      await audioPlayer.resume();
    }
    setState(() {
      playaudio = currentAction;
      currentPlaying = audioIndex;
    });
  }

  Widget playerIcon(index) {
    if(index == currentPlaying) {
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
                  separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey, height: 1.0),
                  itemCount: audioList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('${audioList[index]['title']['rendered'].toString()}'),
                      trailing: IconButton(
                        icon: playerIcon(index),
                        onPressed: () => playpause(playaudio, '${audioList[index]['source_url'].toString()}', index),
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
