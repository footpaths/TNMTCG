import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dialogError.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ConfirmPerson extends StatefulWidget {
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

final picker = ImagePicker();
File _image;

class _ConfirmPageState extends State<ConfirmPerson> {
  String individualKey;
  String personPro;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 800.0, maxWidth: 800.0);

    setState(() {
      _image = File(pickedFile.path);
    });
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
   _image =null;

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) {
      this.individualKey = arguments['individualKey'];
      this.personPro = arguments['personPro'];
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Xác nhận"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 150,
                  height: 150,
                  child: _image != null
                      ? new CircleAvatar(
                          backgroundImage: new FileImage(_image),
                          radius: 200.0,
                        )
                      : new Container(width: 0.0, height: 0.0, child: Text(""),)),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 150,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)),
                  onPressed: () {
                    getImage();
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text("Chụp ảnh"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    if (_image == null) {
                      showDialog(
                        context: context,
                        builder: (_) => dialogError("Vui lòng chụp ảnh", 1),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => FunkyOverlay(_database, individualKey, personPro,_image),
                      );
                      /*showDialog(
                          context: context,
                          builder: (_) {
                            FunkyOverlay(_database, individualKey, personPro);
                          });*/
                    }
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Xử lý"),
                ),
              )
            ],
          ),
        ));
  }
}

class FunkyOverlay extends StatefulWidget {
  FirebaseDatabase database;
  String individualKey;
  String personPro;
  File _image;

  FunkyOverlay(this.database, this.individualKey, this.personPro,this._image);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  //Choice _selectedChoice = choices[0]; // The app's "state".

  /* void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {

      print('ggggggg'+choice.toString());
    });
  }*/


  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }
  Future<dynamic> postImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
    reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    // print('link sau khi up len firebase' + imageUrl);


    processUpdate(widget.database,widget.individualKey,widget.personPro,imageUrl);
      //  print('bat dau up date record');
     // updateRecord(imageUrl);

    return storageTaskSnapshot.ref.getDownloadURL();
  }

  void uploadImages() {


//      print('link :'+ imageFile.toString());
      postImage(_image).then((downloadUrl) {
          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          Firestore.instance
              .collection('images')
              .document(documnetID)
              .setData({'urls': _image}).then((val) {

          });

      }).catchError((err) {
        print(err);
      });

  }
  void processUpdate(

      FirebaseDatabase database, String individualKey, String personPro, String imgPerson) {
    database.reference().child("chats").child(individualKey).update(
        {"statusProcess": true, "personProcess": personPro,"imgPerson": imgPerson}).then((val) {
      print('cccccccccccccccccccongggggggggggggggggg' + personPro);
      Toast.show("Thành công", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Navigator.pop(context);
      Navigator.pop(context);

//      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            padding: EdgeInsets.all(40),
            width: 300,
            height: 200,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Bạn muốn xử lý tình trạng này?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Text("Đồng ý"),
                        onTap: () {
                         uploadImages();
                        },
                      ),
                      GestureDetector(
                        child: Text("Bỏ qua"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
