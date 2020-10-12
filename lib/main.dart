import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safekerala/pages/loading_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    await getCurrentLocation();
    return Future.value(true);
  });
}

getCurrentLocation() async {
  await geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) async {
    if (position != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> lats = prefs.getStringList('listLats') ?? [];
      List<String> longs = prefs.getStringList('listLongs') ?? [];

      lats.add(position.latitude.toString());
      longs.add(position.longitude.toString());
      print('lats $lats');
      print('longs $longs');
      print(lats.length);
      await prefs.setStringList('listLats', lats);
      await prefs.setStringList('listLongs', longs);
    }

    var currentPosition = position;
    print(currentPosition.latitude);
    print(currentPosition.longitude);
  }).catchError((e) {
    print(e);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: false);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  work() async {
    await Workmanager.cancelAll();
    Workmanager.registerPeriodicTask(
      "1",
      "PeriodicTask",
//      frequency: Duration(minutes: 15),
    );
  }

  @override
  void initState() {
    super.initState();
    work();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Kerala',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        canvasColor: Colors.white,
      ),
      home: AppLoading(),
    );
  }
}
