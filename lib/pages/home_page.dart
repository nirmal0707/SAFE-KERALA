import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:safekerala/models/data_model.dart';
import 'package:safekerala/pages/certificate_page.dart';
//import 'package:safekerala/pages/complaint_page.dart';
import 'package:safekerala/pages/nearby_service_page.dart';
import 'package:safekerala/pages/symptoms_page.dart';
import 'package:safekerala/widgets/does_donts_widget.dart';
import 'package:safekerala/widgets/drawer_widget.dart';
import 'package:safekerala/widgets/homepage_notification_widget.dart';
//import 'package:safekerala/widgets/popup_menu_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  String pwd;
  String eml;
  String dst;
  String st;

  MyHomePage({this.pwd, this.eml, this.dst, this.st});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = Firestore.instance;
  int daysLeft = 14;
  DataModel cfModel = DataModel();
  String signUpUsername;
  String signUpDate;

  showExitDialog() {
    return AlertDialog(
      title: Text(
        'Do You Want To Exit!',
        style: TextStyle(color: Colors.black87),
      ),
      actions: <Widget>[
        MaterialButton(
          color: Colors.red,
          child: Text(
            'Cancel',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        MaterialButton(
          color: Colors.teal,
          child: Text(
            'Exit',
          ),
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ],
    );
  }

//  showLocationDialog() {
//    return AlertDialog(
//      title: Text(
//        'Are You Sure, You Want To Change Your Resident Location',
//        style: TextStyle(color: Colors.black87),
//      ),
//      content: Text(
//        'Note: Make sure you are inside your home to get correct location.\nChanging your location periodically is considered as illegal and actions will be taken accordingly.',
//        style: TextStyle(color: Colors.red),
//      ),
//      actions: <Widget>[
//        MaterialButton(
//          color: Colors.red,
//          child: Text(
//            'No',
//          ),
//          onPressed: () {
//            Navigator.pop(context);
//          },
//        ),
//        MaterialButton(
//          color: Colors.teal,
//          child: Text(
//            'Yes',
//          ),
//          onPressed: () {
//            getCurrentLocation();
//            Navigator.pop(context);
//          },
//        ),
//      ],
//    );
//  }

  showCertificateDialog() {
    return AlertDialog(
      title: Text(
        'Unable To Generate Certificate!',
        style: TextStyle(color: Colors.black87),
      ),
      content: Text(
        'Seems like your quarantine period is not completed.',
        style: TextStyle(color: Colors.red),
      ),
      actions: <Widget>[
        MaterialButton(
          color: Colors.red,
          child: Text(
            'Ok',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      changeLocation(position);
    }).catchError((e) {
      print(e);
    });
  }

  changeLocation(Position pos) async {
    await databaseReference
        .collection(widget.st)
        .document(widget.dst)
        .collection(widget.eml)
        .document("Locations")
        .updateData({
          'latitude': pos.latitude,
          'longitude': pos.longitude,
        })
        .then((onValue) {})
        .catchError((onError) {});
  }

  _exit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return showExitDialog();
      },
    );

    return false;
  }

  _getThresholdLocation() async {
    await databaseReference
        .collection(widget.st)
        .document("threshold")
        .get()
        .then((snapshot) async {
      var dist = snapshot.data['${widget.dst}'] ?? 100;
//      print(dist);
      await databaseReference
          .collection(widget.st)
          .document(widget.dst)
          .collection(widget.eml)
          .document("Locations")
          .get()
          .then((snapshot) {
        var lt = snapshot.data['latitude'];
        var lng = snapshot.data['longitude'];
        _getAndSetLocation(lt, lng, dist);
      });
    });
  }

  _getAndSetLocation(var lt, var lng, var dist) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> strLats = prefs.getStringList('listLats') ?? [];
    List<String> strLongs = prefs.getStringList('listLongs') ?? [];
    List<double> lats = strLats.map((i) => double.parse(i)).toList();
    List<double> longs = strLongs.map((i) => double.parse(i)).toList();
    print(strLats);
    if (lats.length >= 0 && longs.length >= 0) {
      int i = 0;
      while (i < lats.length) {
        double distance =
            await Geolocator().distanceBetween(lt, lng, lats[i], longs[i]);
        if (distance >= dist) {
//          print("check");
          await _setLocs(lats[i], longs[i]);
        }
        i++;
      }
//      print(i);
    }
    await prefs.setStringList('listLats', []);
    await prefs.setStringList('listLongs', []);
  }

  _setLocs(var lat, var long) async {
    await databaseReference
        .collection(widget.st)
        .document(widget.dst)
        .collection(widget.eml)
        .document("Locations")
        .get()
        .then((snapShot) async {
      var d = snapShot.data['counter'];
      await databaseReference
          .collection(widget.st)
          .document(widget.dst)
          .collection(widget.eml)
          .document("Locations")
          .updateData({
            'counter': d + 1,
            'latitudeVariation$d': lat,
            'longitudeVariation$d': long,
          })
          .then((onValue) {})
          .catchError((onError) {});
    }).catchError((onError) {});
  }

  _fetchDetails() async {
    await databaseReference
        .collection(widget.st)
        .document(widget.dst)
        .collection(widget.eml)
        .document("SignUp")
        .get()
        .then((snapshot) {
      String name = snapshot.data['username'];
      String date = snapshot.data['dateTime'];
      String ward = snapshot.data['ward'];
      String passportID = snapshot.data['passportID'];
      String panchayath = snapshot.data['panchayath'];
      String address = snapshot.data['address'];
      var date1 = DateTime.parse(date);
      var date2 = DateTime.now();
      int diff = date2.difference(date1).inDays;
      setState(() {
        signUpUsername = name;
        signUpDate = date;
        cfModel.date = date;
        cfModel.name = name;
        cfModel.district = widget.dst;
        cfModel.email = widget.eml;
        cfModel.state = widget.st;
        cfModel.ward = ward;
        cfModel.houseName = address;
        cfModel.passportID = passportID;
        cfModel.panchayath = panchayath;
        if (diff < 15) {
          daysLeft = daysLeft - diff;
        } else {
          daysLeft = 0;
        }
//        print(cfModel.name);
      });
      _storeDetails();
    });
  }

  _storeDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignIn', true);
    await prefs.setString('username', signUpUsername);
    await prefs.setString('password', widget.pwd);
    await prefs.setString('email', widget.eml);
    await prefs.setString('signUpDate', signUpDate);
    await prefs.setString('district', widget.dst);
    await prefs.setString('state', widget.st);
//    print('stored successfully');
  }

  @override
  void initState() {
    super.initState();
    _fetchDetails();
    _getThresholdLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _exit(),
      child: Stack(
        children: <Widget>[
          Scaffold(
            drawer: DrawerWidget(
              st: widget.st,
              dst: widget.dst,
              dm: cfModel,
            ),
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Safe Kerala',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
//              actions: <Widget>[
//                PopUpMenuWidget(),
//              ],
            ),
            body: ListView(
//              primary: false,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(right: 30, top: 5),
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Icon(
//                              Icons.event_available,
//                              color: Colors.teal,
//                              size: 30,
//                            ),
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Text(
//                              'Days Left: ',
//                              textAlign: TextAlign.center,
//                              style: TextStyle(fontSize: 20),
//                            ),
//                            Text(
//                              '$daysLeft',
//                              textAlign: TextAlign.center,
//                              style: TextStyle(
//                                  color: Colors.teal,
//                                  fontSize: 20,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      HomeNotificationWidget(
                        st: widget.st,
                        dst: widget.dst,
                      ),
                      SizedBox(
                        height: 20,
                      ),
//                      Container(
//                        margin:
//                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                        width: double.infinity,
//                        child: InkWell(
//                          splashColor: Colors.grey,
//                          child: Card(
//                            elevation: 10,
//                            child: Container(
//                              padding: EdgeInsets.symmetric(
//                                  horizontal: 10, vertical: 20),
////                            height: 100,
//                              child: Stack(
//                                children: <Widget>[
//                                  Container(
//                                    width:
//                                        MediaQuery.of(context).size.width * 0.6,
//                                    child: Column(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Text(
//                                          'Change Location Of Your Home',
//                                          style: TextStyle(
//                                              fontSize: 17,
//                                              fontWeight: FontWeight.bold),
//                                          textAlign: TextAlign.start,
//                                        ),
//                                        SizedBox(
//                                          height: 5,
//                                        ),
//                                        Text(
//                                          'Click here to change your resident location.\nYou can only change your reident location if you signed up from non-resident location.',
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                  Positioned(
//                                    right: 10,
//                                    child: Icon(
//                                      Icons.pin_drop,
//                                      size: 50,
//                                      color: Colors.blueGrey.shade700,
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                          onTap: () {
//                            showDialog(
//                              context: context,
//                              builder: (BuildContext context) {
//                                return showLocationDialog();
//                              },
//                            );
//                          },
//                        ),
//                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        child: InkWell(
                          splashColor: Colors.grey,
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
//                            height: 100,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Generate Your Certificate',
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Click here for certificate on completion of quarantine.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: Image.asset(
                                          'assets/images/certificate.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            if (daysLeft == 0) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Certificate(
                                    isCompleted: daysLeft == 0 ? true : false,
                                    cfM: cfModel,
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return showCertificateDialog();
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        child: InkWell(
                          splashColor: Colors.grey,
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
//                            height: 100,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Daily Health Check Up',
                                          style: TextStyle(
                                              color: Colors.red.shade400,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Take a health check up daily to know your health status.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      right: 10,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Image.asset(
                                            'assets/images/medical.png'),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => SymptomsAnalysis(
                                  dm: cfModel,
                                  dl: daysLeft,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        child: InkWell(
                          splashColor: Colors.grey,
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
//                            height: 100,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Get Nearby Services',
                                          style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Click here to get available services nearby.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      child: Image.asset(
                                          'assets/images/service.jpg'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => NearbyServices(),
                              ),
                            );
                          },
                        ),
                      ),
//                      Container(
//                        margin:
//                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                        width: double.infinity,
//                        child: InkWell(
//                          splashColor: Colors.grey,
//                          child: Card(
//                            elevation: 10,
//                            child: Container(
//                              padding: EdgeInsets.symmetric(
//                                  horizontal: 10, vertical: 10),
////                            height: 100,
//                              child: Stack(
//                                children: <Widget>[
//                                  Container(
//                                    width:
//                                        MediaQuery.of(context).size.width * 0.6,
//                                    child: Column(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Text(
//                                          'Feedback/Complaints',
//                                          style: TextStyle(
//                                              color: Colors.blueGrey.shade900,
//                                              fontSize: 17,
//                                              fontWeight: FontWeight.bold),
//                                          textAlign: TextAlign.start,
//                                        ),
//                                        SizedBox(
//                                          height: 5,
//                                        ),
//                                        Text(
//                                          'You can post your problems and complaints here',
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                  Positioned(
//                                    right: 10,
//                                    child: Container(
//                                      width: 60,
//                                      height: 60,
//                                      child: Image.asset(
//                                          'assets/images/complaint.png'),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                          onTap: () {
//                            Navigator.push(
//                              context,
//                              CupertinoPageRoute(
//                                builder: (context) => Complaint(
//                                  dm: cfModel,
//                                ),
//                              ),
//                            );
//                          },
//                        ),
//                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
                elevation: 10,
                backgroundColor: Colors.amber.shade400,
                onPressed: () {},
                icon: Icon(
                  Icons.event_available,
                  color: Colors.teal,
                  size: 30,
                ),
                label: Row(
                  children: <Widget>[
                    Text(
                      'Days Left in Quarantine: ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.teal),
                    ),
                    Text(
                      '$daysLeft',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
//              color: Colors.teal,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  color: Colors.teal,
                ),
                height: 50.0,
              ),
            ),
          ),
          DoesDonts(),
        ],
      ),
    );
  }
}
