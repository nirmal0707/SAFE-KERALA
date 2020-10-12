import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CovidUpdates extends StatefulWidget {
  String st, dst;
  CovidUpdates({this.st, this.dst});
  @override
  _CovidUpdatesState createState() => _CovidUpdatesState();
}

class _CovidUpdatesState extends State<CovidUpdates> {
  final databaseReference = Firestore.instance;

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
          "Covid-19 Updates",
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
          StreamBuilder(
            stream: databaseReference
                .collection('${widget.st}')
                .document("CovidUpdates")
                .collection('${widget.dst}')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: Text('Loading...'));
                default:
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data.documents.map<Widget>(
                        (DocumentSnapshot document) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20.0, right: 10, left: 10),
                            child: Card(
                              elevation: 10,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(document['title'] ?? ''),
                                    subtitle: Text(document['detail'] ?? ''),
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(5)),
                                      child: AspectRatio(
                                          aspectRatio: 3 / 2,
                                          child: Image.network(
                                              document['imageUrl'])))
                                ],
                              ),
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
