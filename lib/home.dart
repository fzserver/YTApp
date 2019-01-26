import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ytapp/audios.dart';
import 'package:ytapp/events.dart';
import 'package:ytapp/gallery.dart';
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
    _tabController = TabController(vsync: this, initialIndex: 0, length: 6);
  }

  // final YouTubeDataAPI _youTubeDataAPI = YouTubeDataAPI(
  //   apiKey: 'AIzaSyBVjvKsh8X0W-xjD6kC3I1J5uK1jAF-35E',
  // );

  @override
  Widget build(BuildContext context) { 
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarBrightness: Brightness.light));
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share, color: Colors.white,),
              onPressed: () => Share.share('Check the app https://damdamitaksal.net'),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorColor: Colors.yellow,
            labelColor: Colors.yellow,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(text: 'HOME',),
              Tab(text: 'VIDEOS',),
              Tab(text: 'AUDIOS'),
              Tab(text: 'UPCOMING EVENTS'),
              Tab(text: 'PHOTO GALLERY'),
              Tab(text: 'HISTORY'),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Home(),
              Videos(),
              Audios(),
              Events(),
              Gallery(),
              History(),
            ],
          ),
        ),
      );
  }
}
