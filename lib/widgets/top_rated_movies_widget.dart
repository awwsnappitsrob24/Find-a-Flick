import 'package:find_a_flick/models/sizeconfig.dart';
import 'package:flutter/material.dart';

class TopRatedMovies extends StatelessWidget {
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
              Text("Top Rated Movies Widget",
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 15)),
            ]),
      ),
    );
  }
}
