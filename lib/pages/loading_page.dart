import 'package:flutter/material.dart';
import 'package:safekerala/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLoading extends StatefulWidget {
  @override
  _AppLoadingState createState() => _AppLoadingState();
}

class _AppLoadingState extends State<AppLoading> {
  bool isSignIn;
  bool rememberMe;
  String username = '';
  String pwd = '';
  String email = '';

  Future<void> fetchSignInDetaills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pwd = prefs.getString('password') ?? '';
      username = prefs.getString('username') ?? '';
      rememberMe = prefs.getBool('rememberMe') ?? false;
      isSignIn = prefs.getBool('isSignIn') ?? false;
      email = prefs.getString('email') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSignInDetaills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSignIn == null
          ? Center(child: CircularProgressIndicator())
          : LoginPage(
              getIsSignIn: isSignIn,
              rememberMe: rememberMe,
              pwd: pwd,
              usr: username,
              em: email,
            ),
    );
  }
}
