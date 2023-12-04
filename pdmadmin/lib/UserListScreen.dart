  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;

  import 'package:pdmadmin/widgets/header.dart';
  import 'package:pdmadmin/widgets/side_bar.dart';

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

    Future<void> banUser(int index) async {
      try {
        final user = users[index];
        final response = await http.post(
          Uri.parse('http://192.168.139.1:9090/user/${user['username']}/ban'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'duration': '2 months', // Replace with your desired duration
            'reason': 'Violating community guidelines', // Replace with your ban reason
          }),
        );

        if (response.statusCode == 200) {
          // If the server returns a 200 OK response, update the UI or handle as needed
          print('User banned successfully');
          // You may want to refresh the user list or update the UI in some way
        } else {
          // If the server did not return a 200 OK response,
          // handle the error response (you can customize this based on your server's response)
          print('Failed to ban user. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
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
        drawer: SideBar(),
        body: Column(
          children: [
            Header(),
            users.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Username')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Lastname')),
                          DataColumn(label: Text('Firstname')),
                          DataColumn(label: Text('Banned')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: users.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> user = entry.value;

                          return DataRow(
                            cells: [
                              DataCell(Text(user['username'])),
                              DataCell(Text(user['email'])),
                              DataCell(Text(user['lastname'])),
                              DataCell(Text(user['firstname'])),
                              DataCell(Text(user['banned'].toString())),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    banUser(index);
                                  },
                                  child: Text('Ban'),
                                ),
                              ),
                            ],
                            onSelectChanged: (selected) {
                              // Handle row tap if needed
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ],
        ),
      );
    }
  }
