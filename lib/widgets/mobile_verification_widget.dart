import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MobileVerificationWidget extends StatefulWidget {
  String st, dst;
  MobileVerificationWidget({this.st, this.dst});
  @override
  _MobileVerificationWidgetState createState() =>
      _MobileVerificationWidgetState();
}

class _MobileVerificationWidgetState extends State<MobileVerificationWidget> {
  final databaseReference = Firestore.instance;
  final formKey = new GlobalKey<FormState>();
  String mob;
  bool runner = false;

  verifyMob() async {
    await databaseReference
        .collection(widget.st)
        .document('Granted')
        .get()
        .then((snapshot) {
      setState(() {
        runner = false;
      });
//      List mobs = snapshot.data['${widget.dst}'];
      if (snapshot.data['${widget.dst}'].contains(mob)) {
        Navigator.of(context).pop(mob);
      } else {
        Navigator.pop(context);
      }

//      if (mobs.contains(mob)) {
//        Navigator.of(context).pop(mob);
//      } else {
//        Navigator.pop(context);
//      }
//      mobs = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Verify Mobile',
                      style: TextStyle(color: Colors.teal),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.dialpad,
                              size: 20,
                            ),
                            labelText: 'Mobile Number',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          validator: (value) {
                            if (value.isEmpty || value.length != 10) {
                              return 'Enter valid mobile number!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              mob = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: Colors.teal,
                      child: Text(
                        'Verify',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        final isValid = formKey.currentState.validate();
                        if (!isValid) {
                          return;
                        }
                        setState(() {
                          runner = true;
                        });
                        verifyMob();
                      },
                    )
                  ],
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
