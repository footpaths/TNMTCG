 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
 import 'package:toast/toast.dart';


 import 'package:toast/toast.dart';

import 'dialogError.dart';
import 'dialogSuccess.dart';

class ChangePassScreen extends StatefulWidget {
  @override
  ChangePassScreenState createState() {
    return ChangePassScreenState();
  }
}

class ChangePassScreenState extends State<ChangePassScreen> {

  @override
  Future<void> initState()   {
    super.initState();


  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;
  String errorMessage = '';
  String successMessage = '';

  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _newRePassController = TextEditingController();


  bool _validatePassNow = false;
  bool _validatePassNew = false;
  bool _validateRePassNew = false;
  bool _validatePassLike = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.chevron_left, size: 32.0),
            ),
            Expanded(
              child: Text("Quản lý mật khẩu ",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),),

            ),
            IconButton(
              onPressed: (){
//                      Navigator.pop(context),

              },
              icon: const Icon(Icons.exit_to_app, size: 32.0, color: Colors.green,),

            ),

          ],
//              new Text("Quản lý các phản ánh về đất đai và môi trường",maxLines: 2,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
        ),

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
                    SizedBox(height: 100),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              'THAY ĐỔI MẬT KHẨU',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                            ),
                          ),

                          SizedBox(height: 40),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              obscureText: true,
                              controller: _newPassController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mật khẩu mới',
                                errorText:
                                _validatePassNew ? 'Mật khẩu mới không được rỗng' : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(left: 40, right: 40),
                            child: TextField(
                              obscureText: true,
                              controller: _newRePassController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nhập lại mật khẩu mới',
                                errorText:
                                _validateRePassNew ? 'Mật khẩu mới không được rỗng' : null,
                              ),
                            ),
                          ),
                          SizedBox(height: 30),

                          Container(
                            margin: const EdgeInsets.only(left: 40,right: 40),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green)),
                              onPressed: () async {
                                setState(() {
                                   _newPassController.text.isEmpty ? _validatePassNew = true : _validatePassNew = false;
                                  _newRePassController.text.isEmpty ? _validateRePassNew = true : _validateRePassNew = false;
                                });
                                if(_newPassController.text != _newRePassController.text){
                                  Toast.show("Mật khẩu không giống nhau", context, duration: Toast.LENGTH_LONG, gravity:  Toast.CENTER);
                                  _validatePassLike = true;
                                }else{
                                  _validatePassLike = false;
                                }
                                if(!_validatePassNew && !_validateRePassNew && !_validatePassLike){
                                  print('vào');
                                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                  user.updatePassword( _newPassController.text).then((_){
                                    showDialog(
                                      context: context,
                                      builder: (_) => dialogSuccess("Đổi mật khẩu thành công", 0),
                                    );
                                    //Navigator.pop(context);
                                  }).catchError((error){
                                    print("Password can't be changed" + error.toString());
                                    showDialog(
                                      context: context,
                                      builder: (_) => dialogError("Đổi mật khẩu thất bại",1),
                                    );
                                    //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                                  });
                                }
                                //_showcontent();
                              },
                              color: Colors.green,
                              textColor: Colors.white,
                              child: Text("ĐĂNG NHẬP"),
                            ) ,
                          ),




                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Footer Container
            //Here you will get unexpected behaviour when keyboard pops-up.
            //So its better to use `bottomNavigationBar` to avoid this.
          ],
        ),
      ),

    );
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      FirebaseUser user = (await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password))
          .user;

      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }


  Future<bool> googleSignout() async {
    await auth.signOut();
    await googleSignIn.signOut();
    return true;
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          errorMessage = 'User Not Found!!!';
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          errorMessage = 'Wrong Password!!!';
        });
        break;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Password is empty!!!';
    }
    return null;
  }
}

