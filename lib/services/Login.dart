import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginService {
  static const String apiUrl = 'http://localhost:9090/user/login';

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('token')) {
          return data;
        } else {
          throw ('Error: Token not found in API response');
        }
      } else {
        throw ('Login failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ('An error occurred. Please try again later.');
    }
  }
}
