import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class report extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;

  const report({Key key, this.globalKey}) : super(key: key);

  @override
  _reportPageState createState() => _reportPageState();
}

class _reportPageState extends State<report> {
  String _locationMessage = "Đang dò địa chỉ, vui lòng chờ...";
  String _subAdminArea = "";
    String phonTemp = "";
//  String imagesAttach = "và không có ảnh được chọn";
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _phoneControllerTemp = TextEditingController();

  // List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  List<String> listUrls = <String>[];

  FocusNode textSecondFocusNode = new FocusNode();

  bool _validate = false;
  bool _validatePhone = false;
  bool _validateLocation = false;
  bool _validateImg = false;
  bool _statusProcess = false;

  String _dropdownValue = 'Lấn đất';
  //dynamic _image;
//  final databaseReference = FirebaseDatabase.instance.reference();
  final picker = ImagePicker();
  File _image;
  int counter = 0;
  List<File> images =  [];
  double lat = 0.0;
  double long = 0.0;
  bool isReady = false;
  GlobalKey<FormState> _key = new GlobalKey();

  String name, email, mobile;
  @override
  void initState() {
    super.initState();



  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,maxHeight: 800.0,
        maxWidth: 800.0);
    phonTemp= _phoneController.text;
    setState(() {
      FocusScope.of(context).unfocus();
      phonTemp= _phoneController.text;
      _image = File(pickedFile.path);
      images.add(_image);
//      print('aaaaaa'+ _image.path)
      counter++;

    });
  }



  Future<dynamic> postImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
        reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
   // print('link sau khi up len firebase' + imageUrl);
    listUrls.add(imageUrl);

    if (listUrls.length == images.length) {
    //  print('bat dau up date record');
      updateRecord();
    }
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  void uploadImages() {

    for (var imageFile in images) {
//      print('link :'+ imageFile.toString());
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          Firestore.instance
              .collection('images')
              .document(documnetID)
              .setData({'urls': imageUrls}).then((val) {
//            print('succccccccccccccccccccccccccccccccccccccccccccc');
            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  void updateRecord() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
//    print('dateeeee'+formattedDate);


    if (listUrls.length > 0) {
    } else {
      listUrls.add("nodata");
    }

    var _firebaseRef = FirebaseDatabase().reference().child('chats');
    _firebaseRef.push().set({
      "name": name,
      "timestamp": formattedDate,
      "phone": mobile,
      "address": _locationMessage,
      "typeprocess": _dropdownValue,
      "statusProcess": _statusProcess,
      "images": listUrls,
      "personProcess": "",
      "lat": lat,
      "long": long,
      "subAdminArea": _subAdminArea,
      "imgPerson": "",
    }).then((val) {
     // print('aaaaaaaaa thanh cong');
      _showDialogSuccess();
//      Navigator.pop(context);
    });

  }

  void createRecord() {
//    if (images.length > 0) {
      uploadImages();
//    } else {
//      updateRecord();
//    }
  }

  void _showDialogSuccess() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: new Text(
              'Xác nhận!!!',
              style: TextStyle(color: Colors.red),
            ),
          ),
          content: new SingleChildScrollView(
              child: Container(
            alignment: Alignment.center,
            child: Text("Phản ánh thành công"),
          )),
          actions: [
            new FlatButton(
              child: new Text('Đồng ý'),
              onPressed: () {
                setState(() {
                  FirebaseAuth.instance.currentUser().then((firebaseUser){
                    if(firebaseUser == null)
                    {
                      setState(() {
                        isReady = false;
                      });
                      //signed out
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    }
                    else{
                      Navigator.pop(context);
                      Navigator.pop(context);


                    }
                  }
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showcontent() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            'Xác nhận!!!',
            style: TextStyle(color: Colors.red),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: [
                new Text('Họ tên: ' + name),
                SizedBox(height: 10),
                new Text('Số điện thoại: ' + mobile),
                SizedBox(height: 10),
                new Text('địa chỉ: ' + _locationMessage),
                SizedBox(height: 10),
                new Text('Loại xử lý: ' + _dropdownValue),

              ],
            ),
          ),
          actions: [
            new FlatButton(
              child: new Text('Bỏ qua'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('Đồng ý'),
              onPressed: () {
                setState(() {
                  isReady = true;
                });
                createRecord();
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        File  asset = images[index];
        return new Image.file(asset);
      }),
    );
  }

  void _getCurrentLocation() async {
    final Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   /// debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    lat = position.latitude;
    long = position.longitude;
    if(mounted){
      setState(() {

        _locationMessage = "${first.addressLine}";
        _subAdminArea = first.subAdminArea;



      });
    }

  }
  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _phoneController.dispose();
    _userController.dispose();

    super.dispose();
  }
  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Vui lòng nhập họ tên";
    }
    return null;
  }

  String validateMobile(String value) {
    if (value.length == 0) {
      return "Vui lòng nhập số điện thoại";
    }
    return null;
  }

  Widget FormUI() {
    return new Column(
      children: <Widget>[
        Container(
          child: Text(
            'Thông tin người phản ánh',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
        ),
        SizedBox(height: 30),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'Họ tên',border: OutlineInputBorder(),),

          validator: validateName,
          onSaved: (String val) {
            name = val;
          },
        ),
        SizedBox(height: 20),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Số điện thoại',border: OutlineInputBorder(),),
            keyboardType: TextInputType.phone,


            validator: validateMobile,
            onSaved: (String val) {
              mobile = val;
            }),

        new SizedBox(height: 20.0),
        Text(
          "Chọn nội dung cần phản ánh",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        Container(
          width: 300.0,
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: DropdownButton<String>(
            style: new TextStyle(
              color: Colors.red,
              fontSize: 18.0,
            ),
            isExpanded: true,
            value: _dropdownValue,

            onChanged: (String newValue) {
              setState(() {
                _dropdownValue = newValue;
              });
            },
            items: <String>[
              'Lấn đất',
              'Chiếm đất',
              'Xả rác thải không đúng quy định',
              'Ô nhiễm không khí',
              'Ô nhiễm tiếng ồn',
              'Khai thác cát trái phép',
              'Xây dựng trái phép',
              'Lấn chiếm lòng lề đường',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(left: 40, right: 40),
          child: Text(
            _locationMessage,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
        ),
        SizedBox(height: 10),
        Container(

          margin: const EdgeInsets.only(left: 40, right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green)),
                onPressed: () {
                  FocusScope.of(context).requestFocus(textSecondFocusNode);
                  //print('tétttttt'+ _phoneController.text);
                  //captureImage(ImageSource.camera)
//                                    loadAssets();
                  // openCamera(context);
                  FocusScope.of(context).unfocus();
                  //  print('click');
                  if(counter > 1){
                    Toast.show("không vượt quá 2 hình", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                  }else{

                    getImage();
                  }

                },
                color: Colors.green,
                textColor: Colors.white,
                child: Container(
                  width: 150,

                  child: Text("Chụp ảnh",textAlign: TextAlign.center,),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: buildGridView(),
        )
      ],
    );
  }
  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();

      if(_locationMessage.contains("Đang dò địa chỉ, vui lòng chờ...")){
        _validateLocation = true;
        Toast.show("Vui lòng cung cấp quyền truy cập vị trí ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

      }else{
        _validateLocation = false;
      }
      if(!_validateLocation){
        if(_image == null){
          _validateImg = true;
          Toast.show("Chụp ảnh xác thực phản ánh", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
        }else{
          _validateImg = false;
        }
      }
      if (!_validateLocation && !_validateImg) {


        _showcontent();
      }
      print("Name $name");
      print("Mobile $mobile");

    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    _phoneController.text = phonTemp;
    _getCurrentLocation();
   // print('llllllllllllll'+phonTemp);
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, bottom: 10.0, top: 10.0),
              child: Container(
                height: 20.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {

                    _sendToServer();

                   /* if(_locationMessage.contains("Đang dò địa chỉ, vui lòng chờ...")){
                      _validateLocation = true;
                      Toast.show("Vui lòng cung cấp quyền truy cập vị trí ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

                    }else{
                      _validateLocation = false;
                    }
                    if(!_validateLocation){
                      if(_image == null){
                        _validateImg = true;
                        Toast.show("Chụp ảnh xác thực phản ánh", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                      }else{
                        _validateImg = false;
                      }
                    }


                    if (!_validate && !_validatePhone && !_validateLocation && !_validateImg) {


                      _showcontent();
                    }*/
                    //_showcontent();
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Gửi phản ánh"),
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Header Container

            //Body Container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Container(
                      child:new Form(
                        key: _key,
                        autovalidate: _validate,
                        child: FormUI(),
                      ),
                     /* child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              'Thông tin người phản ánh',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              controller: _userController,

                              //controller: _controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Họ tên',
                                errorText:
                                    _validate ? 'Vui lòng nhập họ tên' : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              focusNode: textSecondFocusNode,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Số điện thoại',
                                errorText: _validatePhone
                                    ? 'Vui lòng nhập số điện thoại'
                                    : null,
                              ),
                            ),
                          ),


                          SizedBox(height: 10),
                          Text(
                            "Chọn nội dung cần phản ánh",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          Container(
                            width: 300.0,
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _dropdownValue,
                              onChanged: (String newValue) {
                                setState(() {
                                  _dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Lấn đất',
                                'Chiếm đất',
                                'Xả rác thải không đúng quy định',
                                'Ô nhiễm không khí',
                                'Ô nhiễm tiếng ồn',
                                'Khai thác cát trái phép'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              _locationMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 10),
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)),
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(textSecondFocusNode);
                                    //print('tétttttt'+ _phoneController.text);
                                    //captureImage(ImageSource.camera)
//                                    loadAssets();
                                   // openCamera(context);
                                    FocusScope.of(context).unfocus();
                                  //  print('click');
                                    if(counter > 1){
                                      Toast.show("không vượt quá 2 hình", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                                    }else{

                                      getImage();
                                    }

                                  },
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  child: Text("Chụp ảnh"),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                            child: buildGridView(),
                          )
                        ],
                      ),*/
                    ),isReady
                        ?
                     Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                          ),
                          Text(
                            "Vui lòng chờ trong giây lát..",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black),
                          )
                        ],
                      ) :  Offstage()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
