import 'package:find_a_flick/models/movie.dart';
import 'package:find_a_flick/services/api_services.dart';
import 'package:find_a_flick/widgets/movie_header_widget.dart';
import 'package:find_a_flick/widgets/movie_overview_widget.dart';
import 'package:find_a_flick/widgets/photoscroller_widget.dart';
import 'package:find_a_flick/widgets/actorscroller_widget.dart';
import 'package:flutter/material.dart';

class MovieInfoPage extends StatefulWidget {
  final Movie movie;

  const MovieInfoPage({Key key, this.movie}) : super(key: key);

  @override
  _MovieInfoPageState createState() => _MovieInfoPageState();
}

class _MovieInfoPageState extends State<MovieInfoPage> {
  APIServices apiService = APIServices();
  List<dynamic> listImages = [];
  List<dynamic> listActors = [];

  @override
  void initState() {
    super.initState();

    // Get scrollable images using api
    populateImageList(widget.movie.movieId);

    // Get scrollable actors of movie using api
    populateActorList(widget.movie.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.movie.movieName}',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MovieHeader(widget.movie),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Overview(widget.movie.movieOverview),
            ),
            PhotoScroller(listImages),
            SizedBox(height: 20.0),
            ActorScroller(listActors),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  void populateImageList(int movieId) async {
    List<dynamic> imageList = await apiService.fetchMovieImageUrls(movieId);
    if (mounted) {
      setState(() {
        listImages = imageList;
      });
    }
  }

  void populateActorList(int movieId) async {
    List<dynamic> actorList = await apiService.fetchMovieActors(movieId);
    if (mounted) {
      setState(() {
        listActors = actorList;
      });
    }
  }
}
