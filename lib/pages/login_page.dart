import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:safekerala/pages/home_page.dart';
import 'package:safekerala/services/email_auth_service.dart';
import 'package:safekerala/widgets/mobile_verification_widget.dart';
import 'package:safekerala/widgets/password_rest_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  bool getIsSignIn;
  bool rememberMe;
  String pwd;
  String usr;
  String em;

  LoginPage({this.getIsSignIn, this.rememberMe, this.pwd, this.usr, this.em});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final databaseReference = Firestore.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final signInFormKey = new GlobalKey<FormState>();
  final signUpFormKey = new GlobalKey<FormState>();
  Position _currentPosition;
  String _currentDistrict;
  String _currentState;
  bool isSignIn = false;
  bool signRememberMe = false;
  String signUpUsername,
      signUpPassword,
      signUpPassportId,
      signUpWard,
      signUpPanchayath,
      signUpHouseName,
      signUpAge,
      signUpSex,
      international,
      interstate,
      signUpMobile;
  String signUpConfirmPassword, signInEmail, signInPassword;
  String email;
  bool isPwdVisisible = false;
  bool isPwdSignUpVisible = false;
  bool isCnfmPwdSignUpVisible = false;
  bool runner = false;

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentDistrict = "${place.subAdministrativeArea}";
        _currentState = "${place.administrativeArea}";
      });
    } catch (e) {
      print(e);
    }
    if (widget.getIsSignIn == false) {
      mobileVerification();
    }
  }

  _checkConnectivity(int val) async {
    var result = await Connectivity().checkConnectivity();
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (result == ConnectivityResult.none) {
      showVerifyDialog(
          'No internet!',
          "No connection found \nPlease check your internet connection.",
          Colors.red);
    } else if (geolocationStatus == GeolocationStatus.disabled) {
      showVerifyDialog(
          'Location disabled!', "Turn on location for Signing In.", Colors.red);
    } else if (_currentDistrict == null || _currentState == null) {
      showVerifyDialog(
          'Location Denied!',
          "Some Problem Occured.\nTurn on location and restart the App.",
          Colors.red);
    } else {
      setState(() {
        runner = true;
      });
      if (val == 1) {
        _verificationProcess();
      } else {
        verifySignIn();
      }
    }
  }

  _storeDetails() async {
    String signUpDate = DateTime.now().toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignIn', isSignIn);
    await prefs.setString('username', signUpUsername);
    await prefs.setString('password', signUpPassword);
    await prefs.setString('passportID', signUpPassportId);
    await prefs.setString('panchayath', signUpPanchayath);
    await prefs.setString('ward', signUpWard);
    await prefs.setString('houseName', signUpHouseName);
    await prefs.setString('email', email);
    await prefs.setString('signUpDate', signUpDate);
    await prefs.setString('district', _currentDistrict);
    await prefs.setString('state', _currentState);
    print('stored successfully');
  }

  showResetDialog() {
    return AlertDialog(
      title: Text(
        " A Password Reset Mail has Send To Your E-Mail Address",
        style: TextStyle(color: Colors.teal),
      ),
      content: Text('Check your email to reset Password'),
      actions: <Widget>[
        MaterialButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  showVerifyDialog(String title, String content, Color color) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      content: Text(content),
      actions: <Widget>[
        MaterialButton(
          color: color,
          child: Text(
            'OK',
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  verifySignIn() async {
    var result = await AuthenticationService()
        .loginWithEmail(email: signInEmail, password: signInPassword);
    setState(() {
      runner = false;
    });
    if (result == true) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MyHomePage(
            pwd: signInPassword,
            eml: signInEmail,
            dst: _currentDistrict,
            st: _currentState,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return showVerifyDialog('Signing In Failed!',
              'Please enter correct email or password', Colors.red);
        },
      );
    }
  }

  createSignUpRecord() async {
    String dateTime = DateTime.now().toString();
//    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
//    String time = DateFormat("H:m:s").format(DateTime.now());
    await databaseReference
        .collection(_currentState)
        .document(_currentDistrict)
        .collection(email)
        .document("Locations")
        .setData({
          'mob': signUpMobile,
          'name': signUpUsername,
          'counter': 0,
          'latitude': _currentPosition.latitude,
          'longitude': _currentPosition.longitude,
        })
        .then((onValue) {})
        .catchError((onError) {});
    await databaseReference
        .collection(_currentState)
        .document(_currentDistrict)
        .collection(email)
        .document("SignUp")
        .setData({
      'username': signUpUsername,
      'passportID': signUpPassportId,
      'panchayath': signUpPanchayath,
      'ward': signUpWard,
      'houseName': signUpHouseName,
      'dateTime': dateTime,
      'age': signUpAge,
      'sex': signUpSex,
      'international': international,
      'interstate': interstate,
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude,
      'completionStatus': 0,
      'mobileNumber': signUpMobile,
    }).then((onValue) {
      _storeDetails();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return showVerifyDialog('Verification Successful',
              'Now Sign In To Continue', Colors.teal);
        },
      );
      setState(() {
        isSignIn = true;
      });
    }).catchError((onError) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return showVerifyDialog('Verification Failed',
              'Some Error Occured.\nTry Again Later', Colors.red);
        },
      );
    });
  }

  _verificationProcess() async {
    var result = await AuthenticationService()
        .signUpWithEmail(email: email, password: signUpPassword)
        .then((onValue) {
      if (onValue == true) {
        createSignUpRecord();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return showVerifyDialog(
                'Verification Failed!',
                'Try again with correct email address or Account exist',
                Colors.red);
          },
        );
      }
    });
    setState(() {
      runner = false;
    });
  }

  void _saveSignUp() {
    final isValid = signUpFormKey.currentState.validate();
    if (!isValid) {
      return;
    }
    if (signUpMobile == null || signUpMobile.length != 10) {
      showDialog(
          context: context,
          builder: (context) => mobVerifyFailDialog(
              "Mobile Verification Failed!",
              'You are not permitted to Sign Up',
              Colors.red));
      return;
    }
    _checkConnectivity(1);
    signUpFormKey.currentState.save();
  }

  void _saveSignIn() {
    final isValid = signInFormKey.currentState.validate();
    if (!isValid) {
      return;
    }
    if (email == '') {}
    _checkConnectivity(2);
    signInFormKey.currentState.save();
  }

  _setRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', signRememberMe);
  }

  _initializeSignIn() {
    setState(() {
      isSignIn = widget.getIsSignIn;
      signRememberMe = widget.rememberMe;
      email = widget.em;
      if (signRememberMe == true) {
        signInPassword = widget.pwd;
        signInEmail = widget.em;
      } else {
        signInPassword = '';
        signInEmail = '';
      }
    });
  }

  mobVerifyFailDialog(String title, String content, Color color) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,
        style: TextStyle(color: color),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'OK',
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }

  mobileVerification() async {
    var result = await showDialog(
      context: context,
      builder: (context) => MobileVerificationWidget(
        st: _currentState,
        dst: _currentDistrict,
      ),
    );
    if (result != null) {
      showDialog(
          context: context,
          builder: (context) => mobVerifyFailDialog(
              "Mobile Verification Successful!",
              'You can now Sign Up',
              Colors.teal));
    } else {
      showDialog(
          context: context,
          builder: (context) => mobVerifyFailDialog(
              "Mobile Verification Failed!",
              'You are not permitted to Sign Up',
              Colors.red));
    }
    setState(() {
      signUpMobile = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeSignIn();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
//          height: 300,
              margin: EdgeInsets.only(
                  top: isSignIn == true ? 150 : 20,
                  bottom: 20,
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.4),
                    blurRadius: 5.0,
                    // has the effect of softening the shadow
                    spreadRadius: 5.0,
                    // has the effect of extending the shadow
                    offset: Offset(
                      3, // horizontal, move right 10
                      8, // vertical, move down 10
                    ),
                  )
                ],
              ),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: <Widget>[
                              Text(
                                isSignIn == true ? 'Sign In' : 'Sign Up',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(isSignIn == true
                                      ? 'Create an Account?  '
                                      : 'Already have Account?  '),
                                  InkWell(
                                    splashColor: Colors.blue,
                                    child: Text(
                                      isSignIn == true ? 'Sign Up' : 'Sign In',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        isSignIn = !isSignIn;
                                        if (isSignIn == false) {
                                          mobileVerification();
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: !isSignIn,
                                child: Form(
                                  key: signUpFormKey,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Note: Password should be minimum 6 character long.\nYou cannot change your details after Signing Up. Make sure you have entered the correct details before signing up.',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.person,
                                            size: 20,
                                          ),
                                          labelText: 'Name',
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter valid name!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signUpUsername = value;
                                          });
                                        },
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Flexible(
                                            flex: 2,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.person_add,
                                                  size: 20,
                                                ),
                                                labelText: 'Age',
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter valid Age!';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  signUpAge = value;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            flex: 5,
                                            child: DropdownButtonFormField(
                                              items: [
                                                'male',
                                                'female'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              value: signUpSex,
                                              onChanged: (value) {
                                                setState(() {
                                                  signUpSex = value;
                                                });
                                              },
                                              validator: (value) {
                                                if (value == null) {
                                                  return 'Choose your Sex!';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                icon: Icon(
                                                  Icons.person_outline,
                                                  size: 20,
                                                ),
//                                                labelText: 'Sex',
                                              ),
                                              hint: Text(
                                                'Sex',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.chrome_reader_mode,
                                            size: 20,
                                          ),
                                          labelText: 'Passport ID',
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter valid Passport ID!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signUpPassportId = value;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.location_city,
                                            size: 20,
                                          ),
                                          labelText: 'Panchayath/Muncipality',
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter valid Panchayath/Muncipality!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signUpPanchayath = value;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.location_on,
                                            size: 20,
                                          ),
                                          labelText: 'Ward',
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter valid Ward!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signUpWard = value;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.home,
                                            size: 20,
                                          ),
                                          labelText: 'House Name',
                                        ),
                                        maxLines: 2,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter valid House Name!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signUpHouseName = value;
                                          });
                                        },
                                      ),
                                      DropdownButtonFormField(
                                        items: ['Yes', 'No']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        value: international,
                                        onChanged: (value) {
                                          setState(() {
                                            international = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Choose an Option!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.local_airport,
                                            size: 20,
                                          ),
                                          labelText: 'International',
                                        ),
//                                        hint: Text(
//                                          'International',
//                                        ),
                                      ),
                                      DropdownButtonFormField(
                                        items: ['Yes', 'No']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        value: interstate,
                                        onChanged: (value) {
                                          setState(() {
                                            interstate = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Choose an Option!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            icon: Icon(
                                              Icons.train,
                                              size: 20,
                                            ),
                                            labelText: 'Inter-State'),
//                                        hint: Text(
//                                          'Inter-State',
//                                        ),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.email,
                                            size: 20,
                                          ),
                                          labelText: 'Email Address',
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter valid email address!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            email = value;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: isPwdSignUpVisible
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                isPwdSignUpVisible =
                                                    !isPwdSignUpVisible;
                                              });
                                            },
                                          ),
                                          icon: Icon(
                                            Icons.lock,
                                            size: 20,
                                          ),
                                          labelText: 'Create Password',
                                        ),
                                        obscureText: !isPwdSignUpVisible,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter valid password!';
                                          } else if (value.contains(' ')) {
                                            return 'Password cannot contain white space!';
                                          } else if (value.length < 6) {
                                            return 'Password should contain atleast 6 character!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signUpPassword = value;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: isCnfmPwdSignUpVisible
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                isCnfmPwdSignUpVisible =
                                                    !isCnfmPwdSignUpVisible;
                                              });
                                            },
                                          ),
                                          icon: Icon(
                                            Icons.lock_outline,
                                            size: 20,
                                          ),
                                          labelText: 'Confirm Password',
                                        ),
                                        obscureText: !isCnfmPwdSignUpVisible,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              value != signUpPassword) {
                                            return 'Renter correct password!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signUpConfirmPassword = value;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      RaisedButton(
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          _saveSignUp();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isSignIn,
                                child: Form(
                                  key: signInFormKey,
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        decoration: InputDecoration(
                                          icon: Icon(
                                            Icons.email,
                                            size: 20,
                                          ),
                                          labelText: 'Email Address',
                                        ),
                                        initialValue: signInEmail,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Enter valid email address!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signInEmail = value;
                                          });
                                        },
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: isPwdVisisible
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                isPwdVisisible =
                                                    !isPwdVisisible;
                                              });
                                            },
                                          ),
                                          icon: Icon(
                                            Icons.lock,
                                            size: 20,
                                          ),
                                          labelText: 'Password',
                                        ),
                                        obscureText: !isPwdVisisible,
                                        initialValue: signInPassword,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              value.contains(' ') ||
                                              value.length < 6) {
                                            return 'Enter valid password!';
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            signInPassword = value;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Checkbox(
                                            value: signRememberMe,
                                            onChanged: (value) {
                                              setState(() {
                                                signRememberMe = value;
                                                _setRememberMe();
                                              });
                                            },
                                          ),
                                          Text('Remember Me'),
                                        ],
                                      ),
//                              SizedBox(
//                                height: 5,
//                              ),
                                      RaisedButton(
                                        color: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          _saveSignIn();
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: InkWell(
                                          child: Text(
                                            'Forgot Password?',
                                            textAlign: TextAlign.right,
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          onTap: () async {
                                            var result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  PasswordResetDialog(),
                                            );
                                            if (result == true) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        showResetDialog(),
                                              );
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    splashColor: Colors.blue,
                                    child: Text(
                                      'Verify Your Mobile Number',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onTap: () {
                                      mobileVerification();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: runner,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AlertDialog(
                      title: Text(
                        "Please wait a Second..",
                        style: TextStyle(color: Colors.blue),
                      ),
                      content: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
