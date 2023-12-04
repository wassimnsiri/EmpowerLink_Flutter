import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdmadmin/page_accueil.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';
  bool obscurePassword = true;

  Future<void> loginUser() async {
    final String apiUrl = 'http://192.168.139.1:9090/user/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('token')) {
          String token = data['token'];

          // Decode le token
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

          // Obtenez le nom d'utilisateur du payload
          String username = decodedToken['username'];
          String email = decodedToken['email'];

          // Enregistrez le token et le nom d'utilisateur dans shared_preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
          prefs.setString('username', username);
          prefs.setString('email', email);

          // Accédez à la page d'accueil avec le nom d'utilisateur
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PageAccueil()),
          );
        } else {
          print('Error: Token not found in API response');
        }
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          errorMessage = 'Login failed. Please check your credentials.';
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Admin Dashboard Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                    contentPadding: EdgeInsets.all(16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                    contentPadding: EdgeInsets.all(16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
             ElevatedButton(
                onPressed: () async {
    // Clear previous error messages
               setState(() {
                errorMessage = '';
                 });

    // Perform login
               await loginUser();

    // Check for errors and update error message
              if (errorMessage.isNotEmpty) {
                setState(() {
                  errorMessage = 'Login failed. Please check your credentials.';
               });
             }
           },
  style: ElevatedButton.styleFrom(
    primary: Colors.green, // Background color
    onPrimary: Colors.white, // Text color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0), // Adjust the border radius
    ),
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // Adjust padding
    elevation: 8.0,
  ),
  child: Text(
    'Login',
    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), // Increase font size and make it bold
  ),
),

                SizedBox(height: 20),
                // Display error message
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Implement Google login logic
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Background color
                    onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png', // Replace with your Google logo asset path
                        height: 24.0,
                      ),
                      SizedBox(width: 8.0),
                      Text('Login with Google'),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // Implement GitHub login logic
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black, // Background color
                    onPrimary: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png', // Replace with your GitHub logo asset path
                        height: 24.0,
                      ),
                      SizedBox(width: 8.0),
                      Text('Login with GitHub'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
