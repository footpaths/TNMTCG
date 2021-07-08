import 'package:flutter/material.dart';

class MyNavigator {
  static void goToHome(BuildContext context) {
//    Navigator.pushNamed(context, "/home");
    Navigator.of(context).pushNamed('/home');


  }
  static void goToChangePass(BuildContext context) {
//    Navigator.pushNamed(context, "/home");
    Navigator.of(context).pushNamed('/changepass');
  }

  static void goToLogin(BuildContext context) {

    Navigator.of(context).pushNamed('/login');

  }
  static void goToChoose(BuildContext context) {

    Navigator.of(context).pushReplacementNamed('/choose');

  }
  static void goToReport(BuildContext context) {

    Navigator.of(context).pushNamed('/map');

  }
  static void goToPDF(BuildContext context) {

    Navigator.of(context).pushNamed('/pdf');

  }
  static void goToPDFT(BuildContext context) {

    Navigator.of(context).pushNamed('/pdfT');

  }
  static void goToMapDetails(BuildContext context,double lat, double long) {

    Navigator.of(context).pushNamed('/mapDetails',arguments:{'lat': lat,'long': long,});

  }

  static void goToFullScreen(BuildContext context,String url) {

    Navigator.of(context).pushNamed('/fullScreen',arguments:{'url': url,});

  }
  static void goToDetails(BuildContext context,String name, String timestamp, String phone, double lat, double long,
      String address, String typeprocess, bool statusProcess, String individualKey, dynamic images,String personProcess,String imgPerson,String sound) {

    Navigator.of(context).pushNamed('/details',arguments: {'name': name, 'timestamp':timestamp,'phone': phone,'lat': lat,'long': long,'address': address,'typeprocess': typeprocess,'statusProcess': statusProcess,'individualKey': individualKey,'images': images,'personProcess': personProcess,'imgPerson': imgPerson,"sound":sound});

  }
  static void goToPort(BuildContext context) {

    Navigator.of(context).pushReplacementNamed('/port');

  }

  static void goToConfirm(BuildContext context, String individualKey, String personPro,) {

    Navigator.of(context).pushReplacementNamed('/ConfirmPerson',arguments:{'individualKey': individualKey,'personPro': personPro,});

  }
}
