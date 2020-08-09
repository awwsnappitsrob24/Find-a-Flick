import 'package:find_a_flick/models/movie.dart';
import 'package:find_a_flick/widgets/arcbanner_widget.dart';
import 'package:find_a_flick/widgets/poster_widget.dart';
import 'package:find_a_flick/widgets/rating_info_widget.dart';
import 'package:flutter/material.dart';

class MovieHeader extends StatelessWidget {
  MovieHeader(this.movie);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var movieInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.movieName,
          style: textTheme.headline6,
        ),
        SizedBox(height: 8.0),
        RatingInformation(movie),
        SizedBox(height: 12.0),
      ],
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: ArcBanner(movie.movieImage),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Poster(
                movie.movieImage,
                height: 180.0,
              ),
              SizedBox(width: 16.0),
              Expanded(child: movieInformation),
            ],
          ),
        ),
      ],
    );
  }
}
