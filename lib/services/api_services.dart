import 'package:find_a_flick/models/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class APIServices {
  List<dynamic> listMovie = [];
  Future<List<dynamic>> fetchMovies() async {
    final response = await http.get(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=240dfc01e28615025eb43251da180035');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> map = convert.json.decode(response.body);
      List<dynamic> data = map["results"];
      Movie resultMovie;
      for (int i = 0; i < data.length; i++) {
        resultMovie = Movie(
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
}
