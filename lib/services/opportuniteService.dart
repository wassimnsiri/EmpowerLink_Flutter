import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/opportuniteModel.dart';

class OpportuniteService {
  final String baseUrl = 'http://localhost:9090/api/opportunite';

  Future<List<Opportunite>> fetchOpportunites() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode != 500) {
        List<dynamic> data = json.decode(response.body);
        List<Opportunite> opportuniteList =
            data.map((item) => Opportunite.fromJson(item)).toList();
        return opportuniteList;
      } else {
        throw Exception(
            'Failed to load opportunites - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load opportunites - Error: $e');
    }
  }

  Future<void> deleteOpportunite(int id) async {
    try {
      const String baseUrl = 'http://localhost:9090/api/opportunite';

      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        // La suppression a réussi, aucun contenu retourné
      } else {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to delete opportunite - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting opportunite: $e');
      throw Exception('Failed to delete opportunite - Error: $e');
    }
  }

  Future<void> createOpportunity(Opportunite newOpportunite) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newOpportunite.toJson()),
      );

      if (response.statusCode == 201) {
        // Opportunite created successfully
      } else {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to create opportunite - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating opportunite: $e');
      throw Exception('Failed to create opportunite - Error: $e');
    }
  }

  Future<void> editOpportunity(Opportunite updated) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost:9090/api/updateOpportuniteById/${updated.id}'), // Include the id in the URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updated.toJson()),
      );

      if (response.statusCode != 500) {
        // Opportunite updated successfully
      } else {
        print('Error response body: ${response.body}');
        throw Exception(
            'Failed to edit opportunite - Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error editing opportunite: $e');
      throw Exception('Failed to edit opportunite - Error: $e');
    }
  }
}
