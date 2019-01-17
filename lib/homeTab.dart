import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ytapp/youtube_data_api.dart';
import 'package:ytapp/ytplayer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum PlayerStatus { Playing, Paused, Resume, Stop }

class _HomeState extends State<Home> {
  static final String ytAPI = 'AIzaSyBVjvKsh8X0W-xjD6kC3I1J5uK1jAF-35E';
  final YouTubeDataAPI _youTubeDataAPI = YouTubeDataAPI(
    apiKey: ytAPI,
  );

  // List audioList;
  // AudioPlayer audioPlayer = AudioPlayer();
  // int playaudio;
  // int currentPlaying;
  // PlayerStatus _playerStatus;

  bool _loading;
  SearchOptions _searchOptions;
  SearchResultModel _searchResult;

  @override
  void initState() {
    super.initState();

    this._searchOptions = SearchOptions(
      pageSize: 5,
      order: YouTubeSearchOrder.date,
      channelId: "UCsUF4ujGalaBkLzNkbxKW3Q",
    );
    this._search();
    // fetchListAudio();
  }

  void _search() async {
    setState(() {
      this._loading = true;
    });

    this
        ._youTubeDataAPI
        .videos
        .search(null, options: this._searchOptions)
        .then((result) {
      setState(() {
        this._searchResult = result;
        this._loading = false;
      });
    });
  }

  //   void fetchListAudio() async {
  //   final response = await http.get('https://damdamitaksal.net/wp-json/wp/v2/media?per_page=20&media_type=audio');
  //   List audios = json.decode(response.body);
  //   setState(() {
  //     audioList = audios;
  //     playaudio = 0;
  //     loading = false;
  //     currentPlaying = -1;
  //     _playerStatus = PlayerStatus.Stop;
  //   });
  // }

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
  void dispose() {
    // audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: (BuildContext context) {
          List<Widget> children = [];

          if (this._loading == true) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (this._searchResult == null) {
            return Center(
              child: Text("No videos found"),
            );
          }

          children.add(
            Hero(
              tag: 'DAMDAMI TAKSAL',
              child: FadeInImage(
                image: AssetImage('1.jpg'),
                placeholder: AssetImage('1.jpg'),
                fit: BoxFit.contain,
              ),
            ),
          );

          children.add(
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 50.0,
                width: double.infinity,
                child: Card(
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'LATEST VIDEOS',
                        style: TextStyle(
                            color: Color.fromRGBO(17, 28, 59, 1.0),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          );

          children.add(
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: FadeInImage(
                image: AssetImage('bg.jpg'),
                placeholder: AssetImage('bg.jpg'),
                width: 100.0,
                height: 50.0,
              ),
            ),
          );

          children.addAll(_searchResult.items.map((item) {
            return ListTile(
              leading: Hero(
                tag: '${item.title}',
                child: FadeInImage(
                  width: 75.0,
                  height: 60.0,
                  image: NetworkImage(item.mediumThumbnail),
                  fit: BoxFit.contain,
                  placeholder: AssetImage('1.jpg'),
                ),
              ),
              title: Text(item.title),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YTPlayer(
                          youtubeapi: ytAPI,
                          videoID: '${item.id}',
                          title: '${item.title}',
                        ),
                  ),
                );
              },
            );
          }).toList());

          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(
                  color: Colors.grey,
                  height: 1.0,
                ),
            itemCount: children.length,
            itemBuilder: (BuildContext context, int index) => children[index],
          );
        },
      );
}
