import 'package:find_a_flick/models/actor.dart';

class Movie {
  // Variables that make up a movie
  final int movieId;
  final String movieName;
  final String movieReleaseDate;
  final String movieOverview;
  final String movieImage;
  final double movieRating;
  final List<Actor> actors;

  // Constructor to create an instance of a movie
  Movie(
      {this.movieId,
      this.movieName,
      this.movieReleaseDate,
      this.movieOverview,
      this.movieImage,
      this.movieRating,
      this.actors});

  // Get all variables from the JSON result
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
      movieId: json["id"],
      movieName: json["title"],
      movieReleaseDate: json["release_date"],
      movieOverview: json["overview"],
      movieImage: json["backdrop_path"],
      movieRating: json["vote_average"]);

  Map<String, dynamic> toJson() => {
        'id': movieId,
        'title': movieName,
        'release_date': movieReleaseDate,
        'overview': movieOverview,
        'backdrop_path': movieImage,
        'vote_average': movieRating,
      };
}
