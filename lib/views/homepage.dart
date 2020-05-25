import 'package:flutter/material.dart';
import 'package:find_a_flick/models/sizeconfig.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:google_maps_webservice/places.dart' as LocationManager;
import 'package:find_a_flick/models/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:android_intent/android_intent.dart';
import 'package:maps_launcher/maps_launcher.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> 
  with SingleTickerProviderStateMixin {

  bool _isLoading = false;
  GoogleMapController mapController;
  Geolocator.Position currentLocation;
  LocationManager.Location myLocation;
  Set<Marker> markers = Set();
  static const kGoogleApiKey = "YOUR_API_KEY";
  LocationManager.GoogleMapsPlaces _places = LocationManager.GoogleMapsPlaces(apiKey: kGoogleApiKey); 
  List<LocationManager.PlacesSearchResult> places = [];
  String errorMessage = "";
  int _selectedIndex = 0;
  Future<Movie> futureMovie;


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();

    // Get user's location at startup to instantiate the center of the primary camera position
    _getLocation();

    turnOffLoadingCircle();

    // Get movies
    futureMovie = fetchMovie();
    
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
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.theaters),
                title: Text('Nearby Theaters'),              
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.movie),
                title: Text('Showtimes'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            backgroundColor: Colors.orange[300],
            onTap: _onItemTapped,
          ),
          body: _selectedIndex == 0? currentLocation == null ? 
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
              zoom: 12.0,
            ),
          ) : MaterialApp(
            title: 'Fetch Data Example',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
              appBar: AppBar(
                title: Text('Fetch Data Example'),
              ),
              body: Container(
                height:SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: Center(
                  child: FutureBuilder<Movie>(
                    future: futureMovie,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.title);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ),
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

    // Continue to emit user's location every 10 minutes
    Geolocator.Geolocator().getPositionStream(Geolocator.LocationOptions(
      accuracy: Geolocator.LocationAccuracy.best,
      timeInterval: 600000)).listen((position) {
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
                snippet: "Tap for directions", 
                onTap: () {
                  // Show the alert dialog for user to choose b/w navigation and
                  // adding the theater to the 
                  showAlertDialog(context, f.name);
                },
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
  
  // Dialog when tapping on an info window
  void showAlertDialog(BuildContext context, String theaterName) { 
    
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(theaterName),
      content: Text(
        'Would you like to search for directions or look for showtimes?' ,
      ),
      actions: [
        // set up the buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("Directions"),
              onPressed:  () {
                openGoogleMaps(theaterName);
              },
            ),
            FlatButton(
              child: Text("Showtimes"),
              onPressed:  () {
                // Go to the showtimes tab which calls the the showtimes class
                Navigator.pop(context);
                fetchMovie();
                _onItemTapped(1);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed:  () {
                Navigator.pop(context);
              },
            ),
          ]
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Movie> fetchMovie() async {
    final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');

    print(response.statusCode);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Movie.fromJson(convert.json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  // Prompt user to open location services
  void enableLocationServices() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  // Select chosen tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  void openGoogleMaps(String destName) {
    MapsLauncher.launchQuery(destName);
  }
}