import 'package:find_a_flick/models/movie.dart';
import 'package:find_a_flick/models/sizeconfig.dart';
import 'package:flutter/material.dart';

class MovieInfoPage extends StatefulWidget {
  final Movie movie;

  const MovieInfoPage({Key key, this.movie}) : super(key: key);

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.movie.movieName}',
            style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('${widget.movie.movieName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15)),
              ]),
        ),
      ),
    );
  }
}
