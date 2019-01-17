import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class Audios extends StatefulWidget {
  @override
  _AudiosState createState() => _AudiosState();
}

class _AudiosState extends State<Audios> {
  List audioList;
  AudioPlayer audioPlayer = AudioPlayer();
  bool loading;
  int playaudio;

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
    });
  }

  playpause(int play, String url) async {
    switch (play) {
      case 0:
        {
          setState(() {
            playaudio = 1;
          });
          await audioPlayer.play(url);
        }
        break;
      case 1:
        {
          setState(() {
            playaudio = 2;
          });
          await audioPlayer.pause();
        }
        break;
      case 2:
        {
          setState(() {
            playaudio = 1;
          });
          await audioPlayer.resume();
        }
        break;
    }
  }

  Widget playerIcon() {
    if (playaudio != 1) {
      return Icon(
        Icons.play_arrow,
        color: Colors.deepOrange,
      );
    } else {
      return Icon(
        Icons.pause,
        color: Colors.deepOrangeAccent,
      );
    }
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
                      title: Text(
                          '${audioList[index]['title']['rendered'].toString()}'),
                      trailing: IconButton(
                        icon: playerIcon(),
                        onPressed: () => playpause(playaudio,
                            '${audioList[index]['source_url'].toString()}'),
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