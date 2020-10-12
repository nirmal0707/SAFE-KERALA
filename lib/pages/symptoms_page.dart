import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safekerala/models/data_model.dart';
import 'package:safekerala/subpages/health_checkup.dart';

class SymptomsAnalysis extends StatefulWidget {
  int dl;
  DataModel dm;

  SymptomsAnalysis({this.dm, this.dl});

  @override
  _SymptomsAnalysisState createState() => _SymptomsAnalysisState();
}

class _SymptomsAnalysisState extends State<SymptomsAnalysis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Health Check Up'),
      ),
      body: ListView(
        primary: false,
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
//                      height: 150,
                    child: InkWell(
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                "Take Your Daily Health Check Up To Know Your Health Status",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    width: 80,
//                                    decoration: BoxDecoration(
//                                        borderRadius:
//                                            BorderRadius.circular(20)),
                                    child: ClipOval(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Image.asset(
                                        'assets/images/checkup.png',
                                        filterQuality: FilterQuality.high,
                                        colorBlendMode: BlendMode.colorBurn,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    color: Colors.black87,
                                    child: Text(
                                      "Take Health Check Up",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => HealthCheck(
                                            dm: widget.dm,
                                            dl: widget.dl,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                HealthCheck(dm: widget.dm, dl: widget.dl),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    width: double.infinity,
//                    height: 300,
                    child: Card(
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset('assets/images/precaution.jpg'),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    width: double.infinity,
//                    height: 300,
                    child: Card(
                      elevation: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset('assets/images/prevention.jpg'),
                      ),
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
