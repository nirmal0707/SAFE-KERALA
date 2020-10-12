import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safekerala/models/data_model.dart';
import 'package:safekerala/models/symptom_data_model.dart';

class HealthCheck extends StatefulWidget {
  int dl;
  DataModel dm;

  HealthCheck({this.dm, this.dl});

  @override
  _HealthCheckState createState() => _HealthCheckState();
}

class _HealthCheckState extends State<HealthCheck>
    with TickerProviderStateMixin {
  final databaseReference = Firestore.instance;
  AnimationController _questionAnimationController;
  AnimationController _buttonAnimationController;

  int counter = 0;
  bool isFinish = false;
  List<String> ans = ['no', 'no', 'no', 'no', 'no', 'no', 'no'];
  SymptomData symptomData = SymptomData();

  setStatus() async {
    int dayCount = 14 - widget.dl;
    if (dayCount == 0) {
      await databaseReference
          .collection(widget.dm.state)
          .document(widget.dm.district)
          .collection(widget.dm.email)
          .document("HealthStatus")
          .setData({
        'day$dayCount': ans,
      }).then((onValue) {
        setState(() {
          isFinish = true;
        });
      }).catchError((onError) {
        print("some error occured");
      });
    } else {
      await databaseReference
          .collection(widget.dm.state)
          .document(widget.dm.district)
          .collection(widget.dm.email)
          .document("HealthStatus")
          .updateData({
        'day$dayCount': ans,
      }).then((onValue) {
        setState(() {
          isFinish = true;
        });
      }).catchError((onError) {
        print("some error occured");
      });
    }
  }

  void questionAnimation() {
    _questionAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _questionAnimationController.forward();
  }

  void buttonAnimation() {
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _buttonAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();
    questionAnimation();
    buttonAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Visibility(
                visible: isFinish,
                child: Container(
                  padding: EdgeInsets.only(top: 150, bottom: 30),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.pages,
                          color: Colors.blue,
                          size: 50,
                        ),
                      ),
                      Container(
                        child: Text(
                          "Congratulations",
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
//                      SizedBox(
//                        height: 20,
//                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "You have completed today's health check up",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Come back tommorow for your next health check up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Visibility(
                        visible: isFinish,
                        child: FloatingActionButton.extended(
                          heroTag: null,
                          onPressed: () {
                            Navigator.pop(context);
                          },
//                icon: Icon(Icons.arrow_forward_ios),
                          label: Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !isFinish,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                      width: double.infinity,
                      child: Text(
                        'Please Provide Correct Answer For All Questions',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: _questionAnimationController,
                        builder: (context, child) => Transform.scale(
                          scale: _questionAnimationController.value,
                          child: child,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 35, horizontal: 15),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  symptomData.symdata[counter],
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  symptomData.symdataMl[counter],
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      width: double.infinity,
                      child: AnimatedBuilder(
                        animation: _buttonAnimationController,
                        builder: (context, child) => Transform.scale(
                          scale: _buttonAnimationController.value,
                          child: child,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: MaterialButton(
//                            padding: EdgeInsets.symmetric(horizontal: 50),
                                onPressed: () {
                                  setState(() {
                                    ans[counter] = 'no';
                                    if (counter <
                                        symptomData.symdata.length - 1) {
                                      counter++;
                                      questionAnimation();
                                      buttonAnimation();
                                    } else {
                                      isFinish = true;
                                      print(ans);
                                      setStatus();
                                    }
                                  });
                                },
                                color: Colors.redAccent,
                                child: Text(
                                  'ഇല്ല / No',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                elevation: 10,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: MaterialButton(
//                            padding: EdgeInsets.symmetric(horizontal: 50),
                                onPressed: () {
                                  setState(() {
                                    ans[counter] = 'yes';
                                    if (counter <
                                        symptomData.symdata.length - 1) {
                                      counter++;
                                      questionAnimation();
                                      buttonAnimation();
                                    } else {
                                      print(ans);
                                      setStatus();
                                    }
                                  });
                                },
                                color: Colors.teal,
                                child: Text(
                                  'ഉണ്ട് / Yes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                elevation: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
