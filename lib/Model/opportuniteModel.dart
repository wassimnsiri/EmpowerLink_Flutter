class Opportunite {
  int? id;
  String? skill;
  String? contactEmail;
  String? salary;
  String? nomEntreprise;
  String? title;
  String? description;
  String? lieu;
  String? typeDeContrat;
  List<String>? applicants;

  Opportunite({
    this.id,
    this.skill,
    this.contactEmail,
    this.salary,
    this.nomEntreprise,
    required this.title,
    required this.description,
    required this.lieu,
    required this.typeDeContrat,
    required this.applicants,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skill': skill,
      'contactEmail': contactEmail,
      'salary': salary,
      'nomEntreprise': nomEntreprise,
      'title': title,
      'description': description,
      'lieu': lieu,
      'Typedecontrat': typeDeContrat,
      'applicants': applicants,
    };
  }

  factory Opportunite.fromJson(Map<String, dynamic> json) {
  return Opportunite(
    id: json['id'] is int ? json['id'] : null, // Check if 'id' is an integer
    skill: json['skill'],
    contactEmail: json['contactEmail'],
    salary: json['salary'],
    nomEntreprise: json['nomEntreprise'],
    title: json['title'],
    description: json['description'],
    lieu: json['lieu'],
    typeDeContrat: json['Typedecontrat'],
    applicants: List<String>.from(json['applicants'] ?? []),
  );
}

}