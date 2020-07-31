import 'package:find_a_flick/models/sizeconfig.dart';
import 'package:find_a_flick/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class NoLocationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Find-A-Flick could not find your current location.",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
              Text("Please turn on location services.\n",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
              RaisedButton(
                onPressed: HelperFunctions.enableLocationServices,
                color: Colors.orange[300],
                child: Text('Enable Location Services'),
              ),
            ]),
      ),
    );
  }
}
