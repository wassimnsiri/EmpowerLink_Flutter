import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/ServiceSociaux.dart';

Future<List<ServiceSociaux>> fetchHospitals() async {
  try {
    final response =
        await http.get(Uri.parse('http://localhost:9090/service/all'));

    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);

      if (jsonData != null && jsonData is Iterable) {
        List<ServiceSociaux> hospitals = jsonData.map((item) {
          print("Services received for ${item['nom']}: ${item['services']}");
          return ServiceSociaux.fromJson(item); // Use fromJson here
        }).toList();

        return hospitals;
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to fetch hospitals');
    }
  } catch (error) {
    print('Error fetching hospitals: $error');
    throw error;
  }
}