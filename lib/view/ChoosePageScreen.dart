 import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:environmental_management/Constants/icon_image.dart';
import 'package:environmental_management/utils/my_navigator.dart';
import 'package:environmental_management/view/PdfViewPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
 import 'package:path_provider/path_provider.dart';
 import 'package:pdf_render/pdf_render_widgets2.dart';

 import 'package:pdf_render/pdf_render.dart';
 import 'package:flutter_pdfview/flutter_pdfview.dart';

 import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';



class ChoosePageScreen extends StatefulWidget {
  @override
  ChoosePageScreenState createState() {
    return ChoosePageScreenState();
  }
}

class ChoosePageScreenState extends State<ChoosePageScreen> {

  String pathPDF = "";
  // String urlPDFPath = "";
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

    fromAsset('assets/DCQH.pdf', 'DCQH.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });

  }
  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/sample.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error opening asset file");
    }
  }


  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.green);
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
                              child: Text("PHẢN ÁNH VỀ ĐẤT ĐAI, MÔI TRƯỜNG & TIẾNG ỒN",textAlign: TextAlign.center,),
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

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PdfViewPage( path: pathPDF)
                                    ),
                                  );
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             PdfViewPage(path: pathPDF)));

                              },
                              color: Colors.brown,
                              textColor: Colors.white,
                              child: Text("CÔNG BỐ BẢN ĐỒ QUY HOẠCH",textAlign: TextAlign.center,),
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

 // class PDFScreen extends StatefulWidget {
 //
 //
 //   PDFScreen({Key key}) : super(key: key);
 //
 //   _PDFScreenState createState() => _PDFScreenState();
 // }
 //
 // class _PDFScreenState extends State<PDFScreen>  {
 //
 //   final controller = PdfViewerController();
 //
 //   @override
 //   void dispose() {
 //     controller.dispose();
 //     super.dispose();
 //   }
 //
 //   @override
 //   Widget build(BuildContext context) {
 //     return Scaffold(
 //       appBar: AppBar(
 //         title: Text("Document"),
 //         actions: <Widget>[
 //           IconButton(
 //             icon: Icon(Icons.share),
 //             onPressed: () {},
 //           ),
 //         ],
 //       ),
 //       body: Stack(
 //         children: <Widget>[
 //           PdfViewer(
 //             assetName: 'assets/DCQH.pdf', padding: 16,
 //             minScale: 1.0,
 //             viewerController: controller,
 //           )
 //         ],
 //       ),
 //
 //     );
 //   }
 // }

