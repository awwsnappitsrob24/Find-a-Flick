import 'package:find_a_flick/models/movie.dart';
import 'package:flutter/material.dart';

class MovieDescription extends StatelessWidget {
  MovieDescription({
    Key key,
    this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${movie.movieName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '${movie.movieOverview}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'Release Date: ${movie.movieReleaseDate}',
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              ),
              Text(
                'Rating: ${movie.movieRating} / 10',
                style: const TextStyle(
                  fontSize: 12.0,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
