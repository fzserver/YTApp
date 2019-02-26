import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ytapp/audio.dart';

enum PlayerStatus { Playing, Paused, Resume, Stop }

class Audios extends StatefulWidget {
  @override
  _AudiosState createState() => _AudiosState();
}

class _AudiosState extends State<Audios> {
  List audioList;
  bool loading;

  @override
  void initState() {
    loading = true;
    fetchListAudio();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchListAudio() async {
    final response = await http.get(
        'https://damdamitaksal.net/wp-json/wp/v2/media?per_page=20&media_type=audio');
    List audios = json.decode(response.body);
    setState(() {
      audioList = audios;
      loading = false;
    });
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
                          image: AssetImage('music.png'),
                          fit: BoxFit.contain,
                          placeholder: AssetImage('music.png'),
                        ),
                      ),
                      title: Text(
                          '${audioList[index]['title']['rendered'].toString()}'),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SingleAudio('${audioList[index]['source_url'].toString()}')))
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
