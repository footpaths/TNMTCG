import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Constants/Constants.dart';
import 'utils/my_navigator.dart';
import 'package:toast/toast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  String mail = "@gmail.com";

  @override
  Future<void> initState() {
    super.initState();
    setState(() {
      FirebaseAuth.instance.currentUser().then((firebaseUser) {
        if (firebaseUser == null) {
          //signed out

        }
        else {
          //signed in
          print('roi');
          Navigator.pushNamed(context, '/home').then((_) {
            // This block runs when you have returned back to the 1st Page from 2nd.
            Navigator.of(context).pop();
          });

         // MyNavigator.goToHome(context);
//          Navigator.of(context).pushReplacementNamed('/login');
//          Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new MyHomePage()));

        }
      });
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;
  String errorMessage = '';
  String successMessage = '';

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool isReady = false;
  bool _validate = false;
  bool _validatePhone = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          title: Center(
            child: Text('Đăng nhập'),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
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
                                'QUẢN TRỊ HỆ THỐNG',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0),
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 40, right: 40),
                              child: TextField(
                                controller: _userController,

                                //controller: _controller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Tài khoản',
                                  errorText:
                                  _validate
                                      ? 'Tài khoản không được rỗng'
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 40, right: 40),
                              child: TextField(
                                obscureText: true,
                                controller: _passController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Mật khẩu',
                                  errorText:
                                  _validatePhone
                                      ? 'Mật khẩu không được rỗng'
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),

                            Container(
                              margin: const EdgeInsets.only(
                                  left: 40, right: 40),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.green)),
                                onPressed: () {
                                  setState(() {


                                    _userController.text.isEmpty ?
                                    _validate = true : _validate = false;
                                    _passController.text.isEmpty ?
                                    _validatePhone = true : _validatePhone =
                                    false;
                                  });
                                  if (!_validate && !_validatePhone) {
                                    isReady = true;
                                    signIn(_userController.text + mail,
                                        _passController.text).then((user) {
                                      if (user != null) {
                                        print('Logged in successfully.');
                                        setState(() {
                                          isReady = false;
                                        });
                                        MyNavigator.goToHome(context);
                                      } else {
                                        Toast.show("Đăng nhập lỗi", context,
                                            duration: Toast.LENGTH_LONG,
                                            gravity: Toast.CENTER);
                                        setState(() {
                                          isReady = false;
                                        });
                                        print('Error while Login.');
                                      }
                                    });
                                  }
                                  //_showcontent();
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Text("ĐĂNG NHẬP"),
                              ),
                            ),
                          ],
                        ),
                      ), isReady
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
              ) : Offstage()
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

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
    if (value
        .trim()
        .isEmpty) {
      return 'Password is empty!!!';
    }
    return null;
  }
}