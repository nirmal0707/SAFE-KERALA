import 'package:flutter/material.dart';

class NearbyServices extends StatefulWidget {
  @override
  _NearbyServicesState createState() => _NearbyServicesState();
}

class _NearbyServicesState extends State<NearbyServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Nearby Services'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 50),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    width: double.infinity,
//                    height: 300,
                    child: Card(
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset('assets/images/heroes.jpg'),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    height: 150,
                    child: Card(
                      elevation: 10,
                      child: Stack(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    height: 150,
                    child: Card(
                      elevation: 10,
                      child: Stack(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
