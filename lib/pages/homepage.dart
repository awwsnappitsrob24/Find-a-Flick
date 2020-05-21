import 'package:flutter/material.dart';
import 'package:find_a_flick/screensize/sizeconfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as Location;
import 'package:android_intent/android_intent.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  bool _isLoading = false;
  GoogleMapController mapController;
  Position currentLocation;
  Location.Location myLocation;
  Set<Marker> markers = Set();
  
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

    return WillPopScope(
      onWillPop: () async => false,
      child: ModalProgressHUD(
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
            mapType: MapType.normal,
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLocation.latitude, currentLocation.longitude),
              zoom: 17.0,
            ),
          ),
        )
      ),
    );
  }

  // Set the primary position of the camera to the user's location
  Future<void> _getLocation() async {
    currentLocation = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    // Continue to emit user's location as it changes
    Geolocator().getPositionStream(LocationOptions(
      accuracy: LocationAccuracy.best,
      timeInterval: 500)).listen((position) {
        // Handle real time location
        print(position.latitude);
        print(position.longitude);

        // Set state to rebuild GoogleMap widget
        setState(() {
          // Remove current marker if it exists
          if(markers.isNotEmpty) {
            print(markers.length);
            markers.clear();
            print(markers.length);
          }
          print(markers.length);
          
          // Add marker at latitude and longitude
          markers.add(
            Marker(
              markerId: MarkerId("Your Location"),
              position: LatLng(position.latitude, position.longitude),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: "You"),
            )
          );
          print(markers.length);

          // Move camera to the new position
          mapController?.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  position.latitude,
                  position.longitude
                ),
                zoom: 18.0,
              ),
            ),
          );

          // While getting the realt time location, get the nearest *ANYTHING* around the location
          // Get nearest movie theaters in a 10 mile radius.

        }
      );
    });
  }

  // Prompt user to open location services
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