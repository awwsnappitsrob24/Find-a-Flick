import 'package:find_a_flick/models/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:find_a_flick/widgets/movie_description.dart';

class CustomMovieList extends StatelessWidget {
  CustomMovieList({
    this.image,
    this.movie,
  });

  final Widget image;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: image,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: MovieDescription(
                  movie: movie,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
