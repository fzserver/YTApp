import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:marquee/marquee.dart';
import 'package:ytapp/post.dart';
import 'package:ytapp/transparent.dart';
import 'package:ytapp/youtube_data_api.dart';
import 'package:ytapp/ytplayer.dart';
import 'package:audioplayers/audio_cache.dart';

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

  List audioList = [];
  AudioPlayer audioPlayer = AudioPlayer();
  // AudioCache prayer = AudioCache();
  int playaudio;
  int currentPlaying;
  PlayerStatus _playerStatus;
  // String localFilePath;

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
    fetchListAudio();
    getPosts();
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

  // Base URL for our wordpress API
  final String apiUrl = "https://damdamitaksal.net/wp-json/wp/v2/";
  // Empty list for our posts
  List posts = [];

  // Function to fetch list of posts
  void getPosts() async {
    var res = await http.get(Uri.encodeFull(apiUrl + "posts?_embed&per_page=3"),
        headers: {"Accept": "application/json"});

    // fill our posts list with results and update state
    setState(() {
      var resBody = json.decode(res.body);
      posts = resBody;
    });
  }

  void fetchListAudio() async {
    final response = await http.get(
        'https://damdamitaksal.net/wp-json/wp/v2/media?per_page=5&media_type=audio');
    List audios = json.decode(response.body);
    setState(() {
      audioList = audios;
      playaudio = 0;
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
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      color: Color.fromRGBO(247, 247, 247,
          1.0), // List Image isn't clear so match it with that background
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FadeInImage(
                image: AssetImage('baba2.jpg'),
                placeholder: AssetImage('baba2.jpg'),
                fit: BoxFit.scaleDown,
              ),
              Container(
                color: Colors.deepOrange,
                height: 20.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Marquee(
//                    test:"asdfsadfasfd"
                    texts: [
                      "Sri Guru Gobind Singh Sahib Ji",
                      "Sri Guru Granth Sahib Ji",
                      "Sri Dasam Guru Granth Sahib Ji"
                    ],
                    blankSpace: 5.0, // to add space between text
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ),
              title("LATEST VIDEOS"),
              bgImage(),
              HomeTabVideoList(
                data: _searchResult,
                ytApi: ytAPI,
              ),
              title("LATEST AUDIOS"),
              bgImage(),
              HomeTabAudioList(
                audioList: audioList,
                playerIcon: (index) => playerIcon(index),
                playpause: (url, audioIndex) => playpause(url, audioIndex),
              ),
              title("UPCOMING UPDATES/EVENTS"),
              bgImage(),
              HomeTabEventList(eventsList: posts),
            ],
          ),
        ),
      ),
    );
  }

  Padding title(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Color.fromRGBO(17, 28, 59, 1.0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  FadeInImage bgImage() {
    return FadeInImage(
      image: AssetImage('bg.jpg'),
      placeholder: AssetImage('bg.jpg'),
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      fit: BoxFit.contain,
    );
  }
}

class HomeTabVideoList extends StatelessWidget {
  final SearchResultModel data;
  final String ytApi;

  const HomeTabVideoList({Key key, this.data, this.ytApi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return Column(
        children: _generateList(context),
      );
    }
    return Center(
      child: Text("No videos found"),
    );
  }

  List<Widget> _generateList(context) {
    return data.items.map((item) {
      return Column(
        children: <Widget>[
          ListTile(
            leading: FadeInImage(
              width: 75.0,
              height: 60.0,
              image: NetworkImage(item.mediumThumbnail),
              fit: BoxFit.contain,
              placeholder: AssetImage('1.jpg'),
            ),
            title: Text(item.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YTPlayer(
                        youtubeapi: ytApi,
                        videoID: '${item.id}',
                        title: '${item.title}',
                      ),
                ),
              );
            },
          ),
          Container(
            color: Colors.grey,
            height: 0.5,
          )
        ],
      );
    }).toList();
  }
}

class HomeTabAudioList extends StatelessWidget {
  final List audioList;
  final Function playerIcon;
  final Function playpause;

  const HomeTabAudioList(
      {Key key, this.audioList, this.playerIcon, this.playpause})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (audioList.length < 1) {
      return Center();
    }
    return Column(
      children: _generateList(),
    );
  }

  List<Widget> _generateList() {
    return audioList.map((audio) {
      return Column(
        children: <Widget>[
          ListTile(
            leading: FadeInImage(
              width: 50.0,
              height: 50.0,
              image: AssetImage('music.png'),
              fit: BoxFit.contain,
              placeholder: AssetImage('music.png'),
            ),
            title: Text('${audio['title']['rendered'].toString()}'),
            trailing: IconButton(
              icon: playerIcon(audio['id']),
              onPressed: () =>
                  playpause('${audio['source_url'].toString()}', audio['id']),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 0.5,
          )
        ],
      );
    }).toList();
  }
}

class HomeTabEventList extends StatelessWidget {
  final List eventsList;

  const HomeTabEventList({Key key, this.eventsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (eventsList.length < 1) {
      return Center();
    }
    return Column(
      children: _generatePosts(context),
    );
  }

  List<Widget> _generatePosts(BuildContext context) {
    return eventsList.map((event) {
      return Column(
        children: <Widget>[
          InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Post(
                            event["featured_media"] == 0
                                ? 'placeholder.jpg'
                                : event["_embedded"]["wp:featuredmedia"]
                                    [0]["source_url"],
                            event["title"]["rendered"],
                            event["content"]["rendered"]))),
                            child: ListTile(
            leading: FadeInImage.memoryNetwork(
              width: 50.0,
              height: 50.0,
              image: event['featured_media'] == 0
                  ? 'assets/placeholder.jpg'
                  : event["_embedded"]["wp:featuredmedia"][0]["source_url"],
              fit: BoxFit.contain,
              placeholder: transparentImage,
            ),
            title: Text(event["title"]["rendered"]),
            subtitle: Text(event["excerpt"]["rendered"]
                .replaceAll(RegExp(r'<[^>]*>'), '')),
          ),),
          Container(
            color: Colors.grey,
            height: 0.5,
          )
        ],
      );
    }).toList();
  }
}
