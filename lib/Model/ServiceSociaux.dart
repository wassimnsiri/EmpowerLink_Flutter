class ServiceSociaux {
  final String? nom;
  final String? description;
  final String? lieu;
  final int? nombreUtilisations;
  final List<String?> services; // Updated field name

  var id;

  ServiceSociaux({
    required this.nom,
    required this.description,
    required this.lieu,
    required this.nombreUtilisations,
    required this.services, // Updated field name
  });

  // Factory method to create a ServiceSociaux object from a JSON map
  factory ServiceSociaux.fromJson(Map<String, dynamic> json) {
    return ServiceSociaux(
      nom: json['nom'],
      description: json['description'],
      lieu: json['lieu'],
      nombreUtilisations: json['nombreUtilisations'],
      services: List<String>.from(json['services'] ?? []),
    );
  }
}