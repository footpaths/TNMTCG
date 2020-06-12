import 'dart:async';

import 'package:environmental_management/utils/my_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class LogoutScreen extends StatefulWidget {
  @override
  _pdLogoutScreenState createState() => _pdLogoutScreenState();
}

class _pdLogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              height: 100.0,
              decoration: new BoxDecoration(
                color: Colors.green,
                boxShadow: [new BoxShadow(blurRadius: 2.0)],
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0)),
              ),
              child: Center(
                child: Text(
                  "Đăng xuất",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24.0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              child: Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      MyNavigator.goToLogin(context);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Đăng xuất"),
                  )),
            )
            //Header Container

            //Body Container

            //Footer Container
            //Here you will get unexpected behaviour when keyboard pops-up.
            //So its better to use `bottomNavigationBar` to avoid this.
          ],
        ),
      ),

      /* Center(
          child:  RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.green)),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              MyNavigator.goToLogin(context);
            },
            color: Colors.green,
            textColor: Colors.white,
            child: Text("Đăng xuất"),
          )

      ),*/
    );
  }
}
