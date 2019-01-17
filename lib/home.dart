import 'package:flutter/material.dart';
import 'package:ytapp/audios.dart';
import 'package:ytapp/history.dart';
import 'package:ytapp/homeTab.dart';
import 'package:ytapp/videos.dart';
import 'package:ytapp/youtube_data_api.dart';
import 'package:share/share.dart';

class YTHome extends StatefulWidget {
  @override
  _YTHomeState createState() => _YTHomeState();
}

class _YTHomeState extends State<YTHome> with SingleTickerProviderStateMixin {
  static TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 4);
  }

  // final YouTubeDataAPI _youTubeDataAPI = YouTubeDataAPI(
  //   apiKey: 'AIzaSyBVjvKsh8X0W-xjD6kC3I1J5uK1jAF-35E',
  // );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          // backgroundColor: Color(0xfff8faf8),
          centerTitle: true,
          elevation: 1.0,
          title: Text(
            'DAMDAMI TAKSAL',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepOrange,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share, color: Colors.white,),
              onPressed: () => Share.share('Check the app https://google.com'),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(text: 'HOME',),
              Tab(text: 'VIDEOS',),
              Tab(text: 'AUDIO'),
              Tab(text: 'HISTORY'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Home(),
            Videos(),
            Audios(),
            History(),
          ],
        ),
      );
}
