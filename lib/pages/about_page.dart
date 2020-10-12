import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  VideoPlayerController _controller;

  void initVideo() {
    _controller = VideoPlayerController.asset('assets/videos/about.mp4')
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
          "About Us",
//          style: TextStyle(
//            color: Colors.white,
//            fontSize: 25,
////              fontStyle: FontStyle.italic,
//            fontWeight: FontWeight.bold,
//          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        child: ListView(
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
              height: 350,
              width: double.infinity,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _controller.value.initialized
                      ? AspectRatio(
                          aspectRatio: 3 / 3,
                          child: VideoPlayer(_controller),
                        )
                      : Container(),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Center(
                  child: Text(
                    "Developed By",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                  ),
                ),
                Center(
                  child: Text(
                    "CYBERON",
                    style: TextStyle(
                        color: Colors.purple.shade700,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Technologies",
                    style: TextStyle(
                        color: Colors.pink.shade700,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
