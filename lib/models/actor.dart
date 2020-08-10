class Actor {
  Actor({this.actorName, this.characterName, this.actorPhotoUrl});

  // Variables that make up an actor
  final String actorName;
  final String characterName;
  final String actorPhotoUrl;

  // Get all variables from the JSON result
  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
        actorName: json["name"],
        characterName: json["character"],
        actorPhotoUrl: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        'name': actorName,
        'character': characterName,
        'profile_path': actorPhotoUrl,
      };
}
