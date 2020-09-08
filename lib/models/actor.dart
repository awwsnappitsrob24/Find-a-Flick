class Actor {
  Actor({this.actorId, this.actorName, this.characterName, this.actorPhotoUrl});

  // Variables that make up an actor
  final int actorId;
  final String actorName;
  final String characterName;
  final String actorPhotoUrl;

  // Get all variables from the JSON result
  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
        actorId: json["id"],
        actorName: json["name"],
        characterName: json["character"],
        actorPhotoUrl: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        'id': actorId,
        'name': actorName,
        'character': characterName,
        'profile_path': actorPhotoUrl,
      };
}
