class Education {
  String? id;
  String type;
  String description;
  int dure;
  int views;
  bool isRecommended;
  bool isTrending;
  bool isPopular;
  String? image;

  Education({
    this.id,
    required this.type,
    required this.description,
    required this.dure,
    this.views = 0,
    required this.isRecommended,
    required this.isTrending,
    required this.isPopular,
    this.image,
  });

  Education.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        type = json["type"] ?? "",
        description = json["description"] ?? "",
        dure = json["dure"] ?? 0,
        views = json["views"] ?? 0,
        isRecommended = json["isRecommended"] ?? false,
        isTrending = json["isTrending"] ?? false,
        isPopular = json["isPopular"] ?? false,
        image = json["image"];

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "type": type,
      "description": description,
      "dure": dure,
      "isRecommended": isRecommended,
      "isTrending": isTrending,
      "isPopular": isPopular,
      "image": image,
    };
  }
}
