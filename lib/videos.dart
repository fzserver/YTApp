import 'package:flutter/material.dart';
import 'package:ytapp/youtube_data_api.dart';
import 'package:ytapp/ytplayer.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  static final String ytAPI = 'AIzaSyBVjvKsh8X0W-xjD6kC3I1J5uK1jAF-35E';
  final YouTubeDataAPI _youTubeDataAPI = YouTubeDataAPI(
    apiKey: ytAPI,
  );

  bool _loading;
  SearchOptions _searchOptions;
  SearchResultModel _searchResult;

  @override
  void initState() {
    super.initState();

    this._searchOptions = SearchOptions(
      pageSize: 10,
      order: YouTubeSearchOrder.date,
      channelId: "UCsUF4ujGalaBkLzNkbxKW3Q",
    );
    this._search();
  }

  void _search() async {
    setState(() {
      this._loading = true;
    });

    this._youTubeDataAPI.videos.search(null, options: this._searchOptions).then((result) {
      setState(() {
        this._searchResult = result;
        this._loading = false;
      });
    });
  }

  void _prevPage() async {
    setState(() {
      this._loading = true;
    });

    this._youTubeDataAPI.videos.search(null, options: this._searchOptions.copyWith(pageToken: this._searchResult.prevPageToken)).then((result) {
      setState(() {
        this._searchResult = result;
        this._loading = false;
      });
    });
  }

  void _nextPage() async {
    setState(() {
      this._loading = true;
    });

    this._youTubeDataAPI.videos.search(null, options: this._searchOptions.copyWith(pageToken: this._searchResult.nextPageToken)).then((result) {
      setState(() {
        this._searchResult = result;
        this._loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Builder(
            builder: (BuildContext context) {
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

              return ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.grey, height: 1.0),
                itemCount: this._searchResult.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: FadeInImage(
                      width: 75.0,
                      height: 60.0,
                      image: NetworkImage(this._searchResult.items[index].mediumThumbnail),
                      fit: BoxFit.contain,
                      placeholder: AssetImage('1.jpg'),
                    ),
                    title: Text(this._searchResult.items[index].title),
                    onTap: () {
                      // print("VIDEO ID: ${this._searchResult.items[index].id}");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YTPlayer(
                                youtubeapi: ytAPI,
                                videoID: '${this._searchResult.items[index].id}',
                                title: '${this._searchResult.items[index].title}',
                              ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        Divider(height: 1, color: Colors.grey),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  child: Text("Previous"),
                  onPressed: this._prevPage,
                  splashColor: Colors.deepOrangeAccent,
                  height: 30.0,
                  color: Colors.deepOrange,
                  textColor: Colors.yellow,
                ),
              ),
              SizedBox(
                height: 1.0,
                width: 8.0,
              ),
              Expanded(
                child: MaterialButton(
                  child: Text("Next"),
                  onPressed: this._nextPage,
                  splashColor: Colors.deepOrangeAccent,
                  height: 30.0,
                  color: Colors.deepOrange,
                  textColor: Colors.yellow,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
