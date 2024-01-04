

class User {
  String username;
  String firstname;
  String lastname;
  String email;
  String password;
  String adress;
  String description;
  int number;
  List<String> skills;
  List<dynamic> followers;
  List<dynamic> following;
  DateTime birthday;
  String image;
  String role;
  String banned;
  String banduration;
  String reason;
  bool verifierd;
  String restcode;

  User({
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.adress,
    required this.description,
    required this.number,
    required this.skills,
    required this.followers,
    required this.following,
    required this.birthday,
    required this.image,
    required this.role,
    required this.banned,
    required this.banduration,
    required this.reason,
    required this.verifierd,
    required this.restcode,
  });
}