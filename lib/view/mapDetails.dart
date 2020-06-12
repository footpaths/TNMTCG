import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
class PointObject {
  final Widget child;
  final LatLng location;

  PointObject({this.child, this.location});
}
class mapDetails extends StatefulWidget {



  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<mapDetails>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  double lat, long;
  Completer<GoogleMapController> _controller = Completer();
  PointObject point = PointObject(
    child:  Text('Lorem Ipsum'),
    location: LatLng(47.6, 8.8796),
  );
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.668071, 106.775452),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();


    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {

      setState(() {

      });
    });

    controller.forward();

    _currentLocation();

  }


  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/destination_map_marker.png').then((onValue) {
      pinLocationIcon = onValue;
    });

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(lat, long),
        zoom: 17.0,

      ),
    ));




   }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
    if (arguments != null) {
      this.lat = arguments['lat'];
      this.long = arguments['long'];
    }

    LatLng pinPosition = LatLng(lat, long);

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation = CameraPosition(
        zoom: 16,
        bearing: 30,
        target: pinPosition
    );

    return Center(
      child: Material(
        color: Colors.white,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: initialLocation,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setState(() {
                      _markers.add(
                          Marker(
                              markerId: MarkerId("title"),
                              position: pinPosition,
                              icon: pinLocationIcon
                          )
                      );
                    });
                  },
                  myLocationEnabled: true,
                  markers: _markers,


                ),

              ],
            ),

          )
        ),
      ),
    );
  }
}