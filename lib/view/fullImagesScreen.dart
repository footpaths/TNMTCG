import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';



class FullScreenImg extends StatefulWidget {
  @override
  _FullScreenImgState createState() => _FullScreenImgState();
}

class _FullScreenImgState extends State<FullScreenImg> {

  String url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      this.url = arguments['url'];
    }
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover
          ) ,
        ),
      )

    );
  }
}