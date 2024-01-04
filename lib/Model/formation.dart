
import '../utils/custom_date_utils.dart';

class Formation {
  String? id;
  String title;
  int nbPlace;
  int nbParticipant;
  String description;
  int views;
  DateTime? startDate;
  DateTime? endDate;
  String? image;

  List<dynamic> participants;

  Formation({
    this.id,
    required this.title,
    required this.nbPlace,
    required this.nbParticipant,
    required this.description,
    this.views = 0,
    required this.startDate,
    required this.endDate,
    this.image,
    this.participants = const [],
  });

  Formation.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        title = json["title"] ?? "",
        nbPlace = json["nbPlace"] ?? "",
        nbParticipant = json["nbParticipant"] ?? "",
        description = json["description"] ?? "",
        views = json["views"] ?? 0,
        startDate = CustomDateUtils.getDateFromStringForJson(json["startDate"]),
        endDate = CustomDateUtils.getDateFromStringForJson(json["endDate"]),
        image = json["image"] ?? "",
        participants = json["participants"] ?? [];

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "nbPlace": nbPlace,
      "nbParticipant": nbParticipant,
      "description": description,
      "startDate": CustomDateUtils.getStringFromDateForJson(startDate),
      "endDate": CustomDateUtils.getStringFromDateForJson(endDate),
      "image": image,
      "participants": participants,
    };
  }
}
