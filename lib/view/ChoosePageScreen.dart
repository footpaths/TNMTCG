 import 'dart:io';
import 'dart:ui';

import 'package:environmental_management/Constants/icon_image.dart';
import 'package:environmental_management/utils/my_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';


 import 'package:path_provider/path_provider.dart';
 import 'package:flutter_pdfview/flutter_pdfview.dart';
 import 'package:http/http.dart' as http;

import 'PdfViewPage.dart';



class ChoosePageScreen extends StatefulWidget {
  @override
  ChoosePageScreenState createState() {
    return ChoosePageScreenState();
  }
}

class ChoosePageScreenState extends State<ChoosePageScreen> {
  String assetPDFPath = "";
  String urlPDFPath = "";
  @override
  Future<void> initState()   {
    super.initState();
    setState(() {
      FirebaseAuth.instance.currentUser().then((firebaseUser){
        if(firebaseUser == null)
        {
          //signed out

        }
        else{
          //signed in
//          print('roi'+firebaseUser.email);
          MyNavigator.goToHome(context);


        }
      });
    });
    getFileFromAsset("assets/DCQH.pdf").then((f) {
      setState(() {
        assetPDFPath = f.path;
        print(assetPDFPath);
      });
    });

    getFileFromUrl("http://www.pdf995.com/samples/pdf.pdf").then((f) {
      setState(() {
        urlPDFPath = f.path;
        print(urlPDFPath);
      });
    });
  }
  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdf.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }

  Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mypdfonline.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
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
                boxShadow: [
                  new BoxShadow(blurRadius: 2.0)
                ],
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0)),
              ),
              child: Center(child: Text("UBND Huyện Cần Giờ", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 24.0),),),
            ),
            //Header Container

            //Body Container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.red,
                              backgroundImage: AssetImage(PageImage.IC_LOGO_APP),
                            ),
                          ),
                          SizedBox(height: 50),
                          Container(

                            margin: const EdgeInsets.only(left: 40,right: 40),
                            width: double.infinity,
                            height: 60,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green)),
                              onPressed: () {
                                MyNavigator.goToReport(context);
                                //_showcontent();
                              },
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Text("PHẢN ÁNH VỀ ĐẤT ĐAI & MÔI TRƯỜNG",textAlign: TextAlign.center,),
                            ) ,
                          ),
                          SizedBox(height: 30),
                          Container(

                            margin: const EdgeInsets.only(left: 40,right: 40),
                            width: double.infinity,
                            height: 60,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.brown)),
                              onPressed: () {
                               // MyNavigator.goToPDFT(context);//
                                //_showcontent();
                                if (assetPDFPath != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PdfViewPage(path: assetPDFPath)));
                                }
                              },
                              color: Colors.brown,
                              textColor: Colors.white,
                              child: Text("XEM THÔNG TIN BẢN ĐỒ QUY HOẠCH",textAlign: TextAlign.center,),
                            ) ,
                          ),
                          SizedBox(height: 10),







                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),

              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text("Phòng Tài nguyên Và Môi trường huyện Cần Giờ",maxLines: 2, textAlign: TextAlign.center,),
                  SizedBox(height: 10),
                  Text("Địa chỉ : Khu phố Giồng Ao, thị trấn Cần Thạnh, H.Cần Giờ TPHCM", maxLines: 2, textAlign: TextAlign.center,),
                  SizedBox(height: 10),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: () {
                    MyNavigator.goToLogin(context);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Đăng nhập"),
                  )
                ],
              ),
            ),

          ],
        ),
      ),

    );
  }
}

/*
 class PdfViewPage extends StatefulWidget {
   final String path;

   const PdfViewPage({Key key, this.path}) : super(key: key);
   @override
   _PdfViewPageState createState() => _PdfViewPageState();
 }

 class _PdfViewPageState extends State<PdfViewPage> {
   int _totalPages = 0;
   int _currentPage = 0;
   bool pdfReady = false;
   PDFViewController _pdfViewController;

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("My Document"),
       ),
       body: Stack(
         children: <Widget>[
           PDFView(
             filePath: widget.path,
             autoSpacing: true,
             enableSwipe: true,
             pageSnap: true,
             swipeHorizontal: true,
             nightMode: false,
             fitEachPage: false,
             onError: (e) {
               print(e);
             },
             onRender: (_pages) {
               setState(() {
                 _totalPages = _pages;
                 pdfReady = true;
               });
             },
             onViewCreated: (PDFViewController vc) {
               _pdfViewController = vc;
             },
             onPageChanged: (int page, int total) {
               setState(() {});
             },
             onPageError: (page, e) {},
           ),
           !pdfReady
               ? Center(
             child: CircularProgressIndicator(),
           )
               : Offstage()
         ],
       ),
       floatingActionButton: Row(
         mainAxisAlignment: MainAxisAlignment.end,
         children: <Widget>[
           _currentPage > 0
               ? FloatingActionButton.extended(
             backgroundColor: Colors.red,
             label: Text("Go to ${_currentPage - 1}"),
             onPressed: () {
               _currentPage -= 1;
               _pdfViewController.setPage(_currentPage);
             },
           )
               : Offstage(),
           _currentPage+1 < _totalPages
               ? FloatingActionButton.extended(
             backgroundColor: Colors.green,
             label: Text("Go to ${_currentPage + 1}"),
             onPressed: () {
               _currentPage += 1;
               _pdfViewController.setPage(_currentPage);
             },
           )
               : Offstage(),
         ],
       ),
     );
   }
 }*/
