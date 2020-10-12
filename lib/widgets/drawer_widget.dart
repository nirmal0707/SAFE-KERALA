import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safekerala/models/data_model.dart';
import 'package:safekerala/pages/about_page.dart';
import 'package:safekerala/pages/complaint_page.dart';
import 'package:safekerala/pages/covid_updates_page.dart';
import 'package:safekerala/pages/daily_quiz.dart';
import 'package:safekerala/pages/entertainment.dart';
import 'package:safekerala/pages/live_section.dart';
import 'package:safekerala/pages/news_updates.dart';
import 'package:safekerala/pages/terms_policy_page.dart';

class DrawerWidget extends StatefulWidget {
  DataModel dm;
  String st, dst;
  DrawerWidget({this.st, this.dst, this.dm});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.0),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors
                    .white, //This will change the drawer background to blue.
                //other styles
              ),
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.fiber_new,
                            color: Colors.deepOrangeAccent,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Covid-19 Updates',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => CovidUpdates(
                                    st: widget.st,
                                    dst: widget.dst,
                                  )),
                        ).then((res) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.new_releases,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'News Updates',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => NewsUpdates(
                                    st: widget.st,
                                    dst: widget.dst,
                                  )),
                        ).then((res) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.videocam,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Live Section',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => LiveSection()),
                        ).then((res) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.live_tv,
                            color: Colors.deepPurple,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Entertainment',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Entertainment()),
                        ).then((res) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.query_builder,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Daily Quiz',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => DailyQuiz()),
                        ).then((res) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.feedback,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Feedback/Complaints',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Complaint(
                                    dm: widget.dm,
                                  )),
                        ).then((res) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.enhanced_encryption,
                            color: Colors.indigo,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Terms & Policy',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => TermsPage()),
                        ).then((res) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.info,
                            color: Colors.teal,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'About Us',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => About()),
                        ).then((res) {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
