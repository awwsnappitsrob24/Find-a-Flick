import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  Overview(this.overview);
  final String overview;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Story line',
          style: textTheme.subtitle1.copyWith(fontSize: 18.0),
        ),
        SizedBox(height: 8.0),
        Text(
          overview,
          style: textTheme.bodyText1.copyWith(
            color: Colors.black45,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
