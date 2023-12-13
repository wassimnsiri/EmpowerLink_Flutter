class Community {
  final int communityId;
  final String name;
  final DateTime? creationDate;
  final String? image;
  final String objectif;
  final String category;
  final String username;
  final List<String> pending;
  final List<String> members;
  final List<String> pinned;

  Community({
    required this.communityId,
    required this.name,
    this.creationDate,
    this.image,
    required this.objectif,
    required this.category,
    required this.username,
    required this.pending,
    required this.members,
    required this.pinned,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      communityId: json['communityId'] as int,
      name: json['name'] as String,
      creationDate: json['creationDate'] != null
          ? DateTime.parse(json['creationDate'] as String)
          : null,
      image: json['image'] as String?,
      objectif: json['objectif'] as String,
      category: json['category'] as String,
      username: json['username'] as String,
      pending:
          (json['pending'] as List<dynamic>).map((e) => e as String).toList(),
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      pinned:
          (json['pinned'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'communityId': communityId,
      'name': name,
      'creationDate': creationDate?.toIso8601String(),
      'image': image,
      'objectif': objectif,
      'category': category,
      'username': username,
      'pending': pending,
      'members': members,
      'pinned': pinned,
    };
  }
}
