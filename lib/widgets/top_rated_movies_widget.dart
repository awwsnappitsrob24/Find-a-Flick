import 'package:find_a_flick/models/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:find_a_flick/services/api_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'custom_movielist_widget.dart';

class TopRatedMovies extends StatefulWidget {
  @override
  _TopRatedMoviesState createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
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
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Expanded(child: buildTopRatedMovies(context)),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildTopRatedMovies(BuildContext context) {
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
    return Card(
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
    );
  }

  void populateMovieList() async {
    setState(() {
      _isLoading = true;
    });
    List<dynamic> movieList = await apiService.fetchTopRatedMovies();
    setState(() {
      listMovie = movieList;
      _isLoading = false;
    });
  }
}
