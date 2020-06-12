import 'dart:math';

import 'package:environmental_management/model/reportModel.dart';
import 'package:environmental_management/utils/my_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:tabbar/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin<MyHomePage> {
  final _text = TextEditingController();
  bool _validate = false;
  final List<reportModel> _list = List();
  final List<reportModel> _listActive = List();
  reportModel _model;
  DatabaseReference itemRefShop;
  bool _isVisible = true;
  final controller = PageController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String personPro;
  var dbRef;

  void handleClick(String value) {
    switch (value) {
      case 'Đăng xuất':
        showDialog(
          context: context,
          builder: (_) => FunkyOverlay(),
        );
        break;
      case 'Đổi mật khẩu':
        MyNavigator.goToChangePass(context);
        break;
    }
  }

  var KEYS;
  var DATA;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      setState(() {
        FirebaseAuth.instance.currentUser().then((firebaseUser) {
          if (firebaseUser == null) {
            //signed out

          } else {
            //signed in
            personPro = firebaseUser.email;
//            print('aaaa' + personPro);
//          Navigator.of(context).pushReplacementNamed('/login');
//          Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new MyHomePage()));

          }
        });
      });
    }

//   loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new MyHomePageState();
    });

    return null;
  }

  void loadData() {
    dbRef = FirebaseDatabase.instance.reference().child("chats");
    dbRef.once().then((DataSnapshot dataSnapshot) {
      try {
        if (dataSnapshot.value == null) {
//          Toast.show("Vui lòng cung cấp quyền truy cập vị trí ", context,
//              duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          _list.clear();
          _listActive.clear();
        }
        KEYS = dataSnapshot.value.keys;
        DATA = dataSnapshot.value;
      } on Exception catch (_) {
        print('never reached');
      }

      _list.clear();
      _listActive.clear();
      for (var individualKey in KEYS) {
        reportModel model = new reportModel(
          DATA[individualKey]['name'],
          DATA[individualKey]['timestamp'],
          DATA[individualKey]['phone'],
          DATA[individualKey]['lat'],
          DATA[individualKey]['long'],
          DATA[individualKey]['address'],
          DATA[individualKey]['typeprocess'],
          DATA[individualKey]['statusProcess'],
          individualKey,
          DATA[individualKey]['subAdminArea'],
          DATA[individualKey]['images'],
          DATA[individualKey]['personProcess'],
        );

        String subAdminArea = DATA[individualKey]['address'];
        String typeProcess = DATA[individualKey]['typeprocess'];
        if (personPro == "lynhon@gmail.com") {
          if (subAdminArea.contains("Lý Nhơn")) {

            if (model.statusProcess) {
              _list.add(model);
            } else {
              _listActive.add(model);
            }
          }
        } else if (personPro == "binhkhanh@gmail.com") {
          if (subAdminArea.contains("Bình Khánh")) {

            if (model.statusProcess) {
              _list.add(model);
            } else {
              _listActive.add(model);
            }
          }
        } else if (personPro == "tamthonhiep@gmail.com") {
          if (subAdminArea.contains("Tam Thôn Hiệp")) {

            if (model.statusProcess) {
              _list.add(model);
            } else {
              _listActive.add(model);
            }
          }
        } else if (personPro == "anthoidong@gmail.com") {
          if (subAdminArea.contains("An Thới Đông")) {

            if (model.statusProcess) {
              _list.add(model);
            } else {
              _listActive.add(model);
            }
          }
        } else if (personPro == "longhoa@gmail.com") {
          if (subAdminArea.contains("Long Hoà")) {

            if (model.statusProcess) {
              _list.add(model);
            } else {
              _listActive.add(model);
            }
          }
        } else if (personPro == "thanhan@gmail.com") {
          if (subAdminArea.contains("Thạnh An")) {
            if (model.statusProcess) {
              _list.add(model);
            } else {
              _listActive.add(model);
            }
          }
        } else if (personPro == "canthanh@gmail.com") {
          if (subAdminArea.contains("TT. Cần Thạnh")) {
            print('sssssssssssssssss lý nhơn' + DATA[individualKey]['name']);
            if (model.statusProcess) {
              _list.add(model);
            } else {
              _listActive.add(model);
            }
          }
        } else if (personPro == "dbplonghoa@gmail.com") {
          if (subAdminArea.contains("Long Hoà") || subAdminArea.contains("Long Hòa")) {
            if(typeProcess.contains("Khai thác cát trái phép")){

              if (model.statusProcess) {
                _list.add(model);
              } else {
                _listActive.add(model);
              }
            }

          }
        }
        else if (personPro == "dbpcanthanh@gmail.com") {
          if (subAdminArea.contains("TT. Cần Thạnh")) {
            if(typeProcess.contains("Khai thác cát trái phép")){

              if (model.statusProcess) {
                _list.add(model);
              } else {
                _listActive.add(model);
              }
            }

          }
        }
        else if (personPro == "dbpthanhan@gmail.com") {
          if (subAdminArea.contains("Thạnh An") || subAdminArea.contains("Thanh An")) {
            if(typeProcess.contains("Khai thác cát trái phép")){

              if (model.statusProcess) {
                _list.add(model);
              } else {
                _listActive.add(model);
              }
            }

          }
        }
        else if (personPro == "admin@gmail.com") {
          if (model.statusProcess) {
            _list.add(model);
          } else {
            _listActive.add(model);
          }
        }
      }
      if (mounted) {
        setState(() {
          print('leng: ' + _list.length.toString());
        });
      }
    });
  }

  Future<void> _showMyDialog(String individualKey, List images) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bạn muốn xóa? '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Vui lòng kiểm tra trước khi xóa'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Xóa'),
              onPressed: () async {
                StorageReference storageReferance =
                    FirebaseStorage.instance.ref();
                for (var i = 0; i < images.length; i++) {
                  try {
                    String pa = images[i]
                        .replaceAll(
                            new RegExp(
                                r'https://firebasestorage.googleapis.com/v0/b/managementeviros.appspot.com/o/'),
                            '')
                        .split('?')[0];


                    await storageReferance.child(pa).delete();
                  } on Exception catch (_) {

                  }
                }
                dbRef.child(individualKey).remove();
//
//                storageReferance.child(images[0]).delete().then((_) => print('Successfully deleted  storage item' ));

                //dbRef.child(individualKey).remove();
                Navigator.of(context).pop();
                dbRef = FirebaseDatabase.instance.reference().child("chats");
                dbRef.once().then((DataSnapshot dataSnapshot) {
                  if(dataSnapshot.value == null){
                   // Toast.show("hết", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    setState(() {
                      _list.clear();
                      _listActive.clear();
                    });
                  }else{
                    //Toast.show("Còn", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                });
              },
            ),
            FlatButton(
              child: Text('Bỏ qua'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    textStyle() {
      return new TextStyle(color: Colors.white, fontSize: 30.0);
    }

    print("tab1: Builder");

    loadData();
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
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
                child: Text(
                  "Quản lý ",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              /*IconButton(
                onPressed: (){
//                      Navigator.pop(context),
                  showDialog(
                    context: context,
                    builder: (_) => FunkyOverlay(),
                  );
                },
                icon: const Icon(Icons.exit_to_app, size: 32.0),

              ),*/
            ],
//              new Text("Quản lý các phản ánh về đất đai và môi trường",maxLines: 2,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Đăng xuất', 'Đổi mật khẩu'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                text: "Chưa xử lý",
              ),
              new Tab(
                text: "Đã xử lý",
              ),
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new Container(
              child: _listActive.length == 0
                  ? Center(child: Text("Chưa có dữ liệu.."))
                  : new ListView.builder(
                      itemCount: _listActive.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          child: PostsUI(
                              _listActive[index].name,
                              _listActive[index].timestamp,
                              _listActive[index].phone,
                              _listActive[index].lat,
                              _listActive[index].long,
                              _listActive[index].address,
                              _listActive[index].typeprocess,
                              _listActive[index].statusProcess,
                              _listActive[index].images,
                              _listActive[index].subAdminArea,
                              false),
                          onTap: () {
                            MyNavigator.goToDetails(
                              context,
                              _listActive[index].name,
                              _listActive[index].timestamp,
                              _listActive[index].phone,
                              _listActive[index].lat,
                              _listActive[index].long,
                              _listActive[index].address,
                              _listActive[index].typeprocess,
                              _listActive[index].statusProcess,
                              _listActive[index].individualKey,
                              _listActive[index].images,
                              _listActive[index].personProcess,
                            );
                          },
                          onLongPress: () {

                          },
                        );
                      },
                    ),
            ),
            new Container(
              child: _list.length == 0
                  ? Center(child: Text("Chưa có dữ liệu.."))
                  : new ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          child: PostsUI(
                              _list[index].name,
                              _list[index].timestamp,
                              _list[index].phone,
                              _list[index].lat,
                              _list[index].long,
                              _list[index].address,
                              _list[index].typeprocess,
                              _list[index].statusProcess,
                              _list[index].images,
                              _list[index].subAdminArea,
                              true),
                          onTap: () {
                            MyNavigator.goToDetails(
                              context,
                              _list[index].name,
                              _list[index].timestamp,
                              _list[index].phone,
                              _list[index].lat,
                              _list[index].long,
                              _list[index].address,
                              _list[index].typeprocess,
                              _list[index].statusProcess,
                              _list[index].individualKey,
                              _list[index].images,
                              _list[index].personProcess,
                            );
                          },
                          onLongPress: () {
                            if (personPro.contains("admin@gmail.com")) {
                              _showMyDialog(_list[index].individualKey,
                                  _list[index].images);
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PostsUI(
      String name,
      String timestamp,
      String phone,
      double lat,
      double long,
      String address,
      String typeprocess,
      bool statusProcess,
      dynamic images,
      String subAdminArea,
      bool color) {
    var colorType = Colors.red[200];
    if (color) {
      colorType = Colors.green[200];
    }
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 4,
      color: colorType,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Tình trạng: " + typeprocess,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 4),
            Text(
              "Vị trí: " + address,
              style: TextStyle(color: Colors.black54, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
            SizedBox(height: 4),
            Text(
              "Tọa độ : " + lat.toString() + "," + long.toString(),
              style: TextStyle(color: Colors.black54, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
            SizedBox(height: 4),
            Text("Ngày cập nhật: " + timestamp,
                style: TextStyle(color: Colors.black54, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;



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
                  "Bạn muốn thoát ứng dụng?",
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
                          Navigator.pop(context);
                          FirebaseAuth.instance.signOut();

                          Navigator.pop(context);
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
