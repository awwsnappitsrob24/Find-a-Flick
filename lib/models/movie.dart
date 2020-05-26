//import 'package:flutter/material.dart';

class Movie {

  // Variables that make up a movie
  final String movieName;
  final String movieReleaseDate;
  final String movieOverview;
  final String movieImage;

  // Constructor to create an instance of a movie
  Movie({
    this.movieName,
    this.movieReleaseDate,
    this.movieOverview,
    this.movieImage
  });


  // Get all variables from the JSON result
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    movieName: json["title"],
    movieReleaseDate: json["release_date"],
    movieOverview: json["overview"],
    movieImage: json["poster_path"],
  );

  Map<String, dynamic> toJson() =>
    {
      'title': movieName,
      'release_date': movieReleaseDate,
      'overview': movieOverview,
      'poster_path' : movieImage,
    };
}