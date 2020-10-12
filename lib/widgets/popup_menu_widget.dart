//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:safekerala/pages/about_page.dart';
//import 'package:safekerala/pages/terms_policy_page.dart';
//
//enum popUpMenu { policy, about }
//
//class PopUpMenuWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return PopupMenuButton<popUpMenu>(
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.only(
//          topLeft: Radius.circular(20),
//          bottomLeft: Radius.circular(20),
//          bottomRight: Radius.circular(20),
//        ),
//      ),
//      color: Colors.teal.withOpacity(0.95),
//      onSelected: (value) {
//        if (value == popUpMenu.policy) {
//          Navigator.push(
//            context,
//            CupertinoPageRoute(builder: (context) => TermsPage()),
//          );
//        } else if (value == popUpMenu.about) {
//          Navigator.push(
//            context,
//            CupertinoPageRoute(builder: (context) => About()),
//          );
//        }
//      },
//      itemBuilder: (BuildContext context) => [
//        PopupMenuItem(
//          value: popUpMenu.policy,
//          child: ListTile(
//            leading: Icon(
//              Icons.enhanced_encryption,
//              color: Colors.white,
//            ),
//            title: Text(
//              'Terms & Policy',
//              style: TextStyle(color: Colors.white),
//            ),
//          ),
//        ),
//        PopupMenuItem(
//          value: popUpMenu.about,
//          child: ListTile(
//            leading: Icon(
//              Icons.info,
//              color: Colors.white,
//            ),
//            title: Text(
//              'About Us',
//              style: TextStyle(color: Colors.white),
//            ),
//          ),
//        ),
//      ],
//    );
//  }
//}
