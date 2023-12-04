import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    // Fetch the list of users when the widget is created
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.139.1:9090/user/getuser'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          // Update the state with the list of users
          users = jsonResponse.cast<Map<String, dynamic>>();
        });
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load users');
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user[
                'username']), // Replace 'username' with the actual field name in your user model
            subtitle: Text(user[
                'email']), // Replace 'email' with the actual field name in your user model
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle ban button click
                    // You can implement the logic to ban the user here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                  ),
                  child: Text('Ban'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle delete button click
                    // You can implement the logic to delete the user here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
