import 'dart:async';
import 'dart:io';
import 'package:file/local.dart';
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
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:audioplayers/audioplayers.dart';


class report extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;

  const report({Key key, this.globalKey }) : super(key: key);
   @override
  _reportPageState createState() => _reportPageState();
}

class _reportPageState extends State<report> {
  String _locationMessage = "Đang dò địa chỉ, vui lòng chờ...";
  String _subAdminArea = "";
  // LocalFileSystem localFileSystem;
  final LocalFileSystem localFileSystem = new LocalFileSystem();


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
  bool visibilityLayoutCamera = true;
  bool visibilityLayoutRecord = false;
  bool visibilityLayoutTextRecord = false;
  bool visibilityLayoutTextRecordStatus = false;
  bool visibilityButtonDone= false;
  bool visibilityButtonPlay= false;
  ProgressDialog pr;

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
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  String name, email, mobile;
  String filePathsRecord= "";
  String stopLabel = "Ghi âm";
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    super.initState();
    _init();


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

  Future<void> uploadImages() async {

    if(_dropdownValue == "Ô nhiễm tiếng ồn"){

      if(_current !=null){
        pr.show();
        uploadToStorage();
      }else{

        Toast.show("Vui lòng ghi âm tiếng ồn", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
      }

    }else{
      pr.show();
      for (var imageFile in images) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = reference.putFile(imageFile);
        StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

        String url = (await downloadUrl.ref.getDownloadURL());
        listUrls.add(url);

        if (listUrls.length == images.length) {

          updateRecord();
        }

      }
    }

  }
  Future uploadToStorage() async {
    try {
// _recorder.recording.path;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // File file =  new File(_current.path);
      File file =  new File(_current.path);
       final StorageReference storageRef = FirebaseStorage.instance.ref().child(fileName);
       final StorageUploadTask uploadTask = storageRef.putFile(file, StorageMetadata(contentType: 'audio/wav'));
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      print('$url');
      if(url.isNotEmpty){
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
        var _firebaseRef = FirebaseDatabase().reference().child('chats');
        _firebaseRef.push().set({
          "name": name,
          "timestamp": formattedDate,
          "phone": mobile,
          "address": _locationMessage,
          "typeprocess": _dropdownValue,
          "statusProcess": _statusProcess,
          "images": "nodata",
          "personProcess": "",
          "lat": lat,
          "long": long,
          "subAdminArea": _subAdminArea,
          "imgPerson": "",
          "sound": url,
          'times': ServerValue.timestamp
        }).then((val) {
          // print('aaaaaaaaa thanh cong');
          pr.hide();
          _showDialogSuccess();
//      Navigator.pop(context);
        });
      }
    } catch (error) {
    print(error);
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


    // if(_dropdownValue == "Ô nhiễm tiếng ồn"){
    //   if(_current.path !=null){
    //       uploadToStorage();
    //   }
    //
    // }else{
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
        "sound": "",
        'times': ServerValue.timestamp
      }).then((val) {
        // print('aaaaaaaaa thanh cong');
        pr.hide();
        _showDialogSuccess();
//      Navigator.pop(context);
      });




  }

  void createRecord() {

      uploadImages();

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
                Navigator.of(context).pop();
                createRecord();


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
    try {
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

    } on Exception catch (_) {


    }

  }
  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Vui lòng vào cài đặt để kích hoạt quyền truy cập vị trí'),
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
          autofocus: false,
          validator: validateName,
          onSaved: (String val) {
            name = val;
          },
        ),
        SizedBox(height: 20),
        new TextFormField(
            decoration: new InputDecoration(hintText: 'Số điện thoại',border: OutlineInputBorder(),),
            keyboardType: TextInputType.phone,
            autofocus: false,
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
                if(newValue.contains("Ô nhiễm tiếng ồn")){
                  visibilityLayoutRecord = true;
                  visibilityLayoutCamera = false;
                  visibilityLayoutTextRecord = true;
                  images.clear();
                }else{
                  visibilityLayoutRecord = false;
                  visibilityLayoutCamera = true;
                  visibilityLayoutTextRecord = false;
                  visibilityLayoutTextRecordStatus = false;
                  stopLabel = "Ghi âm";
                  _stop();

                }
              });
            },
            items: <String>[
              'Lấn đất',
              'Chiếm đất',
              'Xả rác thải không đúng quy định',
              'Ô nhiễm không khí',
              'Ô nhiễm tiếng ồn',
              'Khai thác cát trái phép',
             /* 'Xây dựng trái phép',*/
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
        Visibility(
          child: Container(

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
//                     openCamera(context);
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
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibilityLayoutCamera,
        ),

        SizedBox(height: 10),
        Visibility(
          child: Container(
            alignment: Alignment.center,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 RaisedButton(
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(18.0),
                       side: BorderSide(color: Colors.green)),
                   onPressed: () {
                     if(stopLabel.contains("Dừng")){
                       // visibilityLayoutTextRecordStatus =  false;
                       // visibilityLayoutTextRecord =  true;
                       setState(() {
                         visibilityButtonDone = true;
                         visibilityLayoutTextRecord = false;
                         visibilityLayoutTextRecordStatus = true;
                       });
                       _currentStatus != RecordingStatus.Unset ? _stop() : null;
                       stopLabel = "Khởi tạo";
                     }else if(stopLabel.contains("Khởi tạo")){
                        _init();
                        stopLabel = "Ghi âm";
                        visibilityButtonDone = false;
                        visibilityLayoutTextRecord = true;
                        visibilityLayoutTextRecordStatus = false;
                     }else{
                       _start();
                       stopLabel = "Dừng";
                       setState(() {
                         visibilityButtonDone = false;
                         visibilityLayoutTextRecord = true;
                         visibilityLayoutTextRecordStatus = false;
                       });
                     }
                   },
                   color: Colors.green,
                   textColor: Colors.white,
                   child: Container(
                     width: 70,

                     child: Text(stopLabel,textAlign: TextAlign.center,),
                   ),
                 ),
                 // Visibility(child: Text("Play",textAlign: TextAlign.center,
                 //
                 // ),visible: false,)
                 SizedBox(width: 10),
                 Visibility(child:  RaisedButton(

                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(18.0),
                       side: BorderSide(color: Colors.green)),

                   onPressed: () {

                     setState(() {

                       if(_current !=null){
                         onPlayAudio();
                         // visibilityLayoutTextRecordStatus = true;
                         // visibilityLayoutTextRecord = false;
                       }
                       // ignore: unnecessary_statements

                       // }else{
                       //
                       //   onPlayAudio();
                       // }
                       // visibilityButtonDone = false;
                       // visibilityButtonPlay = true;
                     });

                   },
                   color: Colors.green,
                   textColor: Colors.white,
                   child: Container(

                     width: 70,

                     child: Text("Play",textAlign: TextAlign.center,),
                   ),
                 ),

                   visible: visibilityButtonDone,

                 )
               ],
             )

          ),
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibilityLayoutRecord,
        ),
        Visibility(child:  Text(
            "Thời gian ghi âm : ${_current?.duration.toString()}"),
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibilityLayoutTextRecord,
        ),
        Visibility(child:  Text(
            "Bạn đã ghi âm thành công",style: TextStyle(color: Colors.red)),
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: visibilityLayoutTextRecordStatus,
        ),
        Container(
          height: 200,
          child: buildGridView(),
        )
      ],
    );
  }
  _stop() async {
    if(_current != null){
      var result = await _recorder.stop();
      print("Stop recording: ${result.path}");
      print("Stop recording: ${result.duration}");
      File file =  localFileSystem.file(result.path);
      print("File length: ${await file.length()}");
      setState(() {
        _current = result;
        _currentStatus = _current.status;
      });
      // _init();
    }

  }

  // void onPlayAudio() async {
  //
  //   AudioPlayer audioPlayer = AudioPlayer();
  //   audioPlayer.stop();
  //   await audioPlayer.play(filePathsRecord, isLocal: true);
  // }
  void onPlayAudio() async {

    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.stop();
    await audioPlayer.play(_current.path, isLocal: true);
  }
  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';

         var appDocDirectory = await getExternalStorageDirectory();


        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }
 /* _start() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';



        var appDocDirectory = await getExternalStorageDirectory();


        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;

        await _recorder.start();
        var recording = await _recorder.current(channel: 0);
        setState(() {
          _current = recording;
        });

        const tick = const Duration(milliseconds: 50);
        new Timer.periodic(tick, (Timer t) async {
          if (_currentStatus == RecordingStatus.Stopped) {
            t.cancel();
          }
          filePathsRecord =  _current.path;

          var current = await _recorder.current(channel: 0);
          // print(current.status);
          setState(() {
            _current = current;
            _currentStatus = _current.status;
          });
        });
      }else{
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("Bạn phải cấp quyền ghi âm")));
      }

    } catch (e) {
      print(e);
    }
  }*/
  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
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
          if(_dropdownValue == "Ô nhiễm tiếng ồn"){

          }else{
            Toast.show("Chụp ảnh xác thực phản ánh", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);

          }
        }else{
          _validateImg = false;
        }
      }
      if(_dropdownValue == "Ô nhiễm tiếng ồn"){
        if(!_validateLocation){
          _showcontent();
        }
      }else{
        if (!_validateLocation && !_validateImg) {


          _showcontent();
        }
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
    // Custom body test
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Download,

      isDismissible: false,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );

    pr.style(
//      message: 'Downloading file...',
      message:
      'Vui lòng chờ trong giây lát...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,

      progressWidgetAlignment: Alignment.center,

      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    if(_locationMessage.contains("Đang dò địa chỉ, vui lòng chờ...")){
      _getCurrentLocation();
    }

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

                    _stop();
                    _sendToServer();

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

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child:new Form(
                        key: _key,
                        autovalidate: _validate,
                        child: FormUI(),

                      ),

                    )
                    // ,isReady
                    //     ? Center(
                    //   child: CircularProgressIndicator()
                    // ):  Offstage()
                     // Column(
                     //    mainAxisAlignment: MainAxisAlignment.center,
                     //    children: <Widget>[
                     //      CircularProgressIndicator(),
                     //      Padding(
                     //        padding: EdgeInsets.only(top: 20.0),
                     //      ),
                     //      Text(
                     //        "Vui lòng chờ trong giây lát..",
                     //        softWrap: true,
                     //        textAlign: TextAlign.center,
                     //        style: TextStyle(
                     //            fontWeight: FontWeight.bold,
                     //            fontSize: 18.0,
                     //            color: Colors.black),
                     //      )
                     //    ],
                     //  ) :  Offstage()
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
