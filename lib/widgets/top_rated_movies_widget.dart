import 'package:find_a_flick/models/sizeconfig.dart';
import 'package:find_a_flick/views/movie_info_page.dart';
import 'package:flutter/material.dart';
import 'package:find_a_flick/services/api_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class TopRatedMovies extends StatefulWidget {
  @override
  _TopRatedMoviesState createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies>
    with SingleTickerProviderStateMixin {
  List<dynamic> listMovie = [];
  bool _isLoading = false;
  APIServices apiService = APIServices();

  @override
  void initState() {
    super.initState();

    // Get top rated movies on start up of widget
    populateMovieList();
  }

  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Best Rated',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          Expanded(
            child: ModalProgressHUD(
              inAsyncCall: _isLoading,
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: List.generate(listMovie.length, (index) {
                    return _buildMovieItem(context, index);
                  })),
            ),
          )
        ],
      ),
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
            Expanded(
              child: Stack(
                children: <Widget>[
                  Image.network(
                    'http://image.tmdb.org/t/p/w185/${listMovie[index].movieImage}',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void populateMovieList() async {
    setState(() {
      _isLoading = true;
    });
    List<dynamic> movieList = await apiService.fetchTopRatedMovies();
    if (mounted) {
      setState(() {
        listMovie = movieList;
        _isLoading = false;
      });
    }
  }
}
