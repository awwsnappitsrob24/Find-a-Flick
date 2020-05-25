class Movie {

/*
  // Variables that make up a movie
  final String theaterName;
  final String theaterAddress;
  final String theaterCity;
  final String theaterZIP;

  // Constructor to create an instance of a movie
  Movie({
    this.theaterName,
    this.theaterAddress,
    this.theaterCity,
    this.theaterZIP
  });


  // Get all variables from the JSON result
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      theaterName: json['cinema_name'],
      theaterAddress: json['address'],
      theaterCity: json['city'],
      theaterZIP: json['postcode'],
    );
  } */

  final int userId;
  final int id;
  final String title;

  Movie({this.userId, this.id, this.title});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}