import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:9090/user/getuser'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  static Future<void> banUser(String username) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:9090/user/$username/ban'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'duration': '2 months',
          'reason': 'Violating community guidelines',
        }),
      );

      if (response.statusCode == 200) {
        print('User banned successfully');
      } else {
        print('Failed to ban user. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  static Future<void> toggleUserRole(String username) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:9090/user/$username/admin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'duration': '2 months', // Set the required parameters as needed
        }),
      );

      if (response.statusCode == 200) {
        print('User role updated successfully');
      } else {
        print(
            'Failed to update user role. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
