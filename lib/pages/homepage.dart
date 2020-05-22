import 'package:flutter/material.dart';
import 'package:find_a_flick/screensize/sizeconfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:location/location.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart' as LocationManager;
import 'package:android_intent/android_intent.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  bool _isLoading = false;
  GoogleMapController mapController;
  Geolocator.Position currentLocation;
  LocationManager.Location myLocation;
  Set<Marker> markers = Set();
  static const kGoogleApiKey = "YOUR_API_KEY";
  
  LocationManager.GoogleMapsPlaces _places = LocationManager.GoogleMapsPlaces(apiKey: kGoogleApiKey); 
  List<LocationManager.PlacesSearchResult> places = [];
  String errorMessage = "";
  
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
              zoom: 11.0,
            ),
          ),
        )
      ),
    );
  }

  // Set the primary position of the camera to the user's location
  Future<void> _getLocation() async {
    currentLocation = await Geolocator.Geolocator()
      .getCurrentPosition(desiredAccuracy: Geolocator.LocationAccuracy.best);

    // Continue to emit user's location as it changes
    Geolocator.Geolocator().getPositionStream(Geolocator.LocationOptions(
      accuracy: Geolocator.LocationAccuracy.best,
      timeInterval: 500)).listen((position) {
        // Handle real time location
        // Set state to rebuild GoogleMap widget
        setState(() {          
          // Add marker at latitude and longitude of current user location
          markers.add(
            Marker(
              markerId: MarkerId("Your Location"),
              position: LatLng(position.latitude, position.longitude),
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: "You"),
            )
          );

          // Get nearest movie theaters in a 10 mile radius.
          getNearbyPlaces(position);
        }
      );
    });
  }

  // Get nearby places from current position
  void getNearbyPlaces(Geolocator.Position currPosition) async {

    // Get user's currentLocation and uses it to search nearby places
    myLocation = LocationManager.Location(currPosition.latitude, currPosition.longitude);
    final result = await _places.searchNearbyWithRadius(myLocation, 100000, type: "movie_theater");

    setState(() {
      // Turn off loading progress hud
      turnOffLoadingCircle();

      // Get all the results if there are any
      if (result.status == "OK") {
        // Place all results in the list
        this.places = result.results;
        // Iterate through the list, and markers on all the results
        result.results.forEach((f) {
          // Only mark those that are movie theaters
          if(f.types.contains("movie_theater")) {
            // Add markers in nearby places results
            Marker resultMarker = Marker(
              markerId: MarkerId(f.name),
              infoWindow: InfoWindow(
                title: "${f.name}",
                //snippet: "${f.types?.first}"
              ),
              position: LatLng(f.geometry.location.lat,
                f.geometry.location.lng              
              ),
            );
            // Add it to Set
            markers.add(resultMarker);
          }
        });
      } else {
        this.errorMessage = result.errorMessage;
      }    
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