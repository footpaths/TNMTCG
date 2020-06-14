import 'package:environmental_management/Constants/Constants.dart';
 import 'package:environmental_management/view/pdfScreen.dart';
import 'package:environmental_management/view/pdfScreenTest.dart';

import 'package:flutter/material.dart';

import 'LoginScreen.dart';
import 'home.dart';
import 'map.dart';
import 'report.dart';
import 'splash_screen.dart';
import 'view/ChangePassScreen.dart';
import 'view/ChoosePageScreen.dart';
import 'view/detailsScreen.dart';
import 'view/fullImagesScreen.dart';
import 'view/mapDetails.dart';
import 'view/ConfirmImagesProcess.dart';

//void main() => runApp(MyApp());
var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => MyHomePage(),
  "/login": (BuildContext context) => LoginScreen(),
  "/choose": (BuildContext context) => ChoosePageScreen(),
  "/map": (BuildContext context) => HomeMapPage(),
  "/pdf": (BuildContext context) => pdfScreen(),
  "/pdfT": (BuildContext context) => pdfScreenTest(),
  "/port": (BuildContext context) => report(),
  "/details": (BuildContext context) => detailsScreen(),
  "/fullScreen": (BuildContext context) => FullScreenImg(),
  "/changepass": (BuildContext context) => ChangePassScreen(),
  "/mapDetails": (BuildContext context) => mapDetails(),
  "/ConfirmPerson": (BuildContext context) => ConfirmPerson(),
};

void main() => runApp(new MaterialApp(
    theme:
    ThemeData(primaryColor: Colors.green, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes));

