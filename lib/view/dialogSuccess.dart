import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class dialogSuccess extends StatefulWidget {
  String msg;
  int type;
  dialogSuccess(this.msg, this.type);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<dialogSuccess>
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
            height:200,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text(widget.msg, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                Spacer(),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 40,right: 40),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.green)),
                          onPressed: () {
                            Navigator.pop(context);
                            FirebaseAuth.instance.signOut();

                            Navigator.pop(context);
                            Navigator.pop(context);
                            //_showcontent();
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                          child: Text("Đồng ý"),
                        ) ,
                      )
                     /* GestureDetector(
                        child: Text("Đồng ý"),
                        onTap: (){
                          Navigator.pop(context);
                          FirebaseAuth.instance.signOut();

                          Navigator.pop(context);
                        },
                      ),*/

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