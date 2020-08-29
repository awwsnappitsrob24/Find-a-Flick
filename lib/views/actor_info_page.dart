import 'package:find_a_flick/models/actor.dart';
import 'package:flutter/material.dart';

class ActorInfoPage extends StatelessWidget {
  ActorInfoPage(this.actor);
  final Actor actor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(actor.actorName),
        ),
      ),
    );
  }
}
