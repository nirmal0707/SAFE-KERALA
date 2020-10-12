import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NewsUpdates extends StatefulWidget {
  String st, dst;
  NewsUpdates({this.st, this.dst});
  @override
  _NewsUpdatesState createState() => _NewsUpdatesState();
}

class _NewsUpdatesState extends State<NewsUpdates> {
  final databaseReference = Firestore.instance;
  VideoPlayerController _controller;
  bool videoUrlStatus;

  _launchURL(String newsUrl) async {
    if (await canLaunch(newsUrl)) {
      await launch(newsUrl);
    } else {
      throw 'Could not launch $newsUrl';
    }
  }

  void initVideo() {
    _controller = VideoPlayerController.asset('assets/videos/covid.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Daily News Updates",
        ),
      ),
      body: ListView(
        primary: false,
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 40,
            color: Colors.teal,
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40))),
            ),
          ),
          Container(
            height: 250,
            width: double.infinity,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _controller.value.initialized
                    ? AspectRatio(
                        aspectRatio: 3 / 2.1,
                        child: VideoPlayer(_controller),
                      )
                    : Container(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: databaseReference
                .collection('${widget.st}')
                .document("NewsUpdates")
                .collection('${widget.dst}')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    'Loading...',
                    textAlign: TextAlign.center,
                  ));
                default:
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data.documents.map<Widget>(
                        (DocumentSnapshot document) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: InkWell(
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  leading: Image.network(document['imageUrl']),
                                  title: Text(document['title']),
                                  subtitle: Text(document['content']),
                                ),
                              ),
                              onTap: () {
                                _launchURL(document['newsLink']);
                              },
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
