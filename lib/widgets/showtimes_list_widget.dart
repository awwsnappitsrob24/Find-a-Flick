import 'package:find_a_flick/models/sizeconfig.dart';
import 'package:find_a_flick/services/api_services.dart';
import 'package:find_a_flick/views/movie_info_page.dart';
import 'package:find_a_flick/widgets/custom_movielist_widget.dart';
import 'package:flutter/material.dart';

class ShowtimesListWidget extends StatefulWidget {
  @override
  _ShowtimesListWidgetState createState() => _ShowtimesListWidgetState();
}

class _ShowtimesListWidgetState extends State<ShowtimesListWidget> {
  APIServices apiService = APIServices();
  List<dynamic> listMovie = [];

  @override
  void initState() {
    super.initState();

    // Get top rated movies on start up of widget
    populateResultMovieList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              child: Expanded(child: buildMovies(context)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMovies(BuildContext context) {
    return _buildMoviesList(context);
  }

  ListView _buildMoviesList(context) {
    return ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: listMovie.length,
      // A callback that will return a widget.
      itemBuilder: _buildMovieItem,
    );
  }

  Widget _buildMovieItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        // Go to the movie info page for selected movie
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieInfoPage(movie: listMovie[index])));
      },
      child: Card(
        child: Column(
          children: <Widget>[
            CustomMovieList(
              image: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'http://image.tmdb.org/t/p/w185/${listMovie[index].movieImage}'),
                      fit: BoxFit.fill),
                ),
              ),
              movie: listMovie[index],
            )
          ],
        ),
      ),
    );
  }

  void populateResultMovieList() async {
    List<dynamic> movieList = await apiService.fetchMovies();
    if (mounted) {
      setState(() {
        listMovie = movieList;
      });
    }
  }
}
