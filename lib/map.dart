import 'dart:async';

import 'package:environmental_management/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeMapPage extends StatefulWidget {
  @override
  _HomeMapPageState createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {
  Completer<GoogleMapController> _controller = Completer();


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.668071, 106.775452),
    zoom: 14.4746,
  );
  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }

  void _showOverlay(BuildContext context) {
    MyNavigator.goToPort(context);


  }


  @override
  Widget build(BuildContext context) {
    print("build UI");
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationEnabled: true,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: new FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: _currentLocation,
                child: new Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.green,
                heroTag: 'unique_key',
                onPressed: () {
                  _showOverlay(context);
                },
                icon: Icon(
                  Icons.file_upload,
                  color: Colors.white,
                ),
                label: Text(
                  "Gửi phản ánh",
                  style: TextStyle(color: Colors.white.withOpacity(1.0)),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}

