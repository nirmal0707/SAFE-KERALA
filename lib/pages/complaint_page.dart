import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:safekerala/models/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complaint extends StatefulWidget {
  DataModel dm;

  Complaint({this.dm});

  @override
  _ComplaintState createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  final databaseReference = Firestore.instance;
  final complaintFormKey = new GlobalKey<FormState>();
  final complaintTextCtrl = TextEditingController();
  String complaintText;
  int counter = 0;

  showSentDialog() {
    return AlertDialog(
      title: Text(
        'Complaint Send',
        style: TextStyle(color: Colors.black87),
      ),
      content: Text(
          'Your complaint has been send successfully.\nYou will be notified about the status soon.'),
      actions: <Widget>[
        MaterialButton(
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.teal,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  confirmDialog() {
    return AlertDialog(
      title: Text(
        'Sent Message',
        style: TextStyle(color: Colors.black87),
      ),
      content: Text('Are you sure you want to send complaint'),
      actions: <Widget>[
        MaterialButton(
          child: Text(
            'No',
            style: TextStyle(
              color: Colors.teal,
            ),
          ),
          onPressed: () {
            complaintTextCtrl.clear();
            Navigator.pop(context);
          },
        ),
        MaterialButton(
          child: Text(
            'Yes',
            style: TextStyle(
              color: Colors.teal,
            ),
          ),
          onPressed: () {
            _sendComplaint();
            complaintTextCtrl.clear();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  _getComplaintCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter${widget.dm.email}') ?? 0;
    });
  }

  _setComplaintCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter${widget.dm.email}', counter + 1);
    setState(() {
      counter++;
    });
  }

  _sendComplaint() async {
    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    String time = DateFormat("H:m:s").format(DateTime.now());
    if (counter == 0) {
      await databaseReference
          .collection(widget.dm.state)
          .document(widget.dm.district)
          .collection(widget.dm.email)
          .document("Complaints")
          .setData({
        'email': widget.dm.email,
        'complaint$counter': complaintText,
        'complaint${counter}_date': date,
        'complaint${counter}_time': time,
      }).then((onValue) {
        _setComplaintCounter();
      }).catchError((onError) {});
    } else {
      await databaseReference
          .collection(widget.dm.state)
          .document(widget.dm.district)
          .collection(widget.dm.email)
          .document("Complaints")
          .updateData({
        'complaint$counter': complaintText,
        'complaint${counter}_date': date,
        'complaint${counter}_time': time,
      }).then((onValue) {
        print('how is');
        _setComplaintCounter();
      }).catchError((onError) {
        print('that is');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getComplaintCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Feedback/Complaints'),
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
                    margin: EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    child: Text(
                      'Note: All complaints are validated.\nPlease ensure you have valid complaint',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 10),
                    width: double.infinity,
                    child: Text(
                      'Complaint Form:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
//                      height: 150,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.amber.shade100),
                    ),
                    child: Form(
                      key: complaintFormKey,
                      child: TextFormField(
                        controller: complaintTextCtrl,
//                          initialValue: complaintText,
                        keyboardType: TextInputType.text,
                        maxLines: 8,
                        maxLength: 150,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: 'Write your complaint here...',
                        ),
                        onChanged: (text) {
                          setState(
                            () {
                              complaintText = text;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Text('Cancel  '),
                            Icon(
                              Icons.cancel,
                              color: Colors.red.shade400,
                            ),
                          ],
                        ),
                        color: Colors.red.shade100,
                        onPressed: () {
                          setState(() {
                            complaintText = '';
                            complaintTextCtrl.clear();
                          });
                        },
                      ),
                      MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Text('Send  '),
                            Icon(
                              Icons.send,
                              color: Colors.blueGrey.shade700,
                            ),
                          ],
                        ),
                        color: Colors.teal.shade100,
                        onPressed: () {
                          if (complaintText.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  confirmDialog(),
                            );
                          }
                        },
                      ),
                    ],
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
