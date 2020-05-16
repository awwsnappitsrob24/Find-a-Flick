import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            // Button to set the user's location on the map
            ButtonTheme(
              minWidth: 300.0,
              child: RaisedButton(
                onPressed: setUserLocation,
                child: Text('Set Location'), color: Colors.orange,
              )
            )

            // The map itself
            
          ],
        ),
      ),
    );
  }
}

void setUserLocation() {
  print('Set user location.');
}