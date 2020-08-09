import 'package:find_a_flick/models/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class APIServices {
  List<dynamic> listMovie = [];
  List<dynamic> listImages = [];

  // Function that gets showtimes from nearest theater (or queried theater by user)
  // NOTE: This function now only gets showtimes for movies that are currently playing
  // This is because the pandemic has closed down all theaters.
  Future<List<dynamic>> fetchMovies() async {
    final response = await http.get(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=your-key-here');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> map = convert.json.decode(response.body);
      List<dynamic> data = map["results"];
      Movie resultMovie;
      for (int i = 0; i < data.length; i++) {
        resultMovie = Movie(
          movieId: data[i]["id"],
          movieName: data[i]["title"],
          movieReleaseDate: data[i]["release_date"],
          movieOverview: data[i]["overview"],
          movieImage: data[i]["poster_path"],
          movieRating: data[i]["vote_average"].toDouble(),
        );
        listMovie.add(resultMovie);
      }
      return listMovie;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movie');
    }
  }

  // Function that gets the highest rated movies that are currently playing
  Future<List<dynamic>> fetchTopRatedMovies() async {
    // Todo: populate list of movies to be returned
    final response = await http.get(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=your-key-here&language=en-US&page=1');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> map = convert.json.decode(response.body);
      List<dynamic> data = map["results"];
      Movie resultMovie;
      for (int i = 0; i < data.length; i++) {
        resultMovie = Movie(
          movieId: data[i]["id"],
          movieName: data[i]["title"],
          movieReleaseDate: data[i]["release_date"],
          movieOverview: data[i]["overview"],
          movieImage: data[i]["poster_path"],
          movieRating: data[i]["vote_average"].toDouble(),
        );
        listMovie.add(resultMovie);
      }
      return listMovie;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movie');
    }
  }

  // Function that gets a list of photos from a movie using the TMDB api
  Future<List<dynamic>> fetchMovieImageUrls(int movieId) async {
    // Todo: populate list of movies to be returned
    final response = await http.get(
        'https://api.themoviedb.org/3/movie/$movieId/images?api_key=your-key-here');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> map = convert.json.decode(response.body);
      List<dynamic> data = map["backdrops"];
      String imageUrl;
      for (int i = 0; i < data.length; i++) {
        imageUrl = data[i]["file_path"];
        imageUrl = 'http://image.tmdb.org/t/p/w185/${data[i]["file_path"]}';
        listImages.add(imageUrl);
      }
      return listImages;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movie images');
    }
  }
}
