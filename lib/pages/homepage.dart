import 'package:flutter/material.dart';
import 'package:find_a_flick/screensize/sizeconfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  bool _isLoading = false;
  GoogleMapController mapController;
  Position currentLocation;
  
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
  
    // Get user's location at startup to instantiate the center of the primary camera position
    _getLocation();

    turnOffLoadingCircle();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Homepage', style: TextStyle(color: Colors.white)),
        ),
        body: currentLocation == null ? 
          Container(
            height:SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Find-A-Flick could not find your current location.", textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                  Text("Please turn on location services.\n", textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
                  RaisedButton(
                    onPressed: enableLocationServices,
                    color: Colors.orange[300],
                    child: Text('Enable Location Services'),
                  ),
                ]
              ),
            ),
          ): GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 15.0,
          ),
        ),
      )
    );
  }

  // Set the primary position of the camera to the user's location
  Future<void> _getLocation() async {
    currentLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    turnOffLoadingCircle();
  }

  void enableLocationServices() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  void turnOffLoadingCircle() {
    setState(() {
      _isLoading = false;
    });
  }

   void turnOnLoadingCircle() {
    setState(() {
      _isLoading = true;
    });
  }
}