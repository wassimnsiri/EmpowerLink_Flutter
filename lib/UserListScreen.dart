import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import './widgets/appBarWidget.dart';
import './widgets/sideMenuWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  late String username;
  late String email;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
    });
  }

  void filterUsers(String query) {
    List<Map<String, dynamic>> filteredList = users
        .where((user) =>
            user['username'].toLowerCase().contains(query.toLowerCase()) ||
            user['email'].toLowerCase().contains(query.toLowerCase()) ||
            user['lastname'].toLowerCase().contains(query.toLowerCase()) ||
            user['firstname'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredUsers = filteredList;
    });
  }

  Future<void> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:9090/user/getuser'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          users = jsonResponse.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> banUser(int index) async {
    try {
      final user = users[index];
      final response = await http.post(
        Uri.parse('http://localhost:9090/user/${user['username']}/ban'),
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

  @override
  Widget build(BuildContext context) {
    int activeUsers = users.where((user) => user['banned'] == 'active').length;
    int bannedUsers = users.where((user) => user['banned'] == 'banned').length;

    return Scaffold(
      appBar: ReusableAppBar(
        title: username,
      ),
      drawer: ReusableSideMenu(),
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReusableSideMenu(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        filterUsers(value);
                      },
                      style: TextStyle(color: Colors.black), // Set text color
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText:
                            'Enter username, email, lastname, or firstname',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (users.isEmpty)
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DataTable(
                          columns: [
                            DataColumn(
                                label: Text('Username',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Email',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Lastname',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Firstname',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Banned',
                                    style: TextStyle(color: Colors.black))),
                            DataColumn(
                                label: Text('Action',
                                    style: TextStyle(color: Colors.black))),
                          ],
                          rows:
                              (filteredUsers.isNotEmpty ? filteredUsers : users)
                                  .asMap()
                                  .entries
                                  .map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> user = entry.value;

                            return DataRow(
                              cells: [
                                DataCell(Text(user['username'],
                                    style: TextStyle(color: Colors.black))),
                                DataCell(Text(user['email'],
                                    style: TextStyle(color: Colors.black))),
                                DataCell(Text(user['lastname'],
                                    style: TextStyle(color: Colors.black))),
                                DataCell(Text(user['firstname'],
                                    style: TextStyle(color: Colors.black))),
                                DataCell(Text(user['banned'].toString(),
                                    style: TextStyle(color: Colors.black))),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      banUser(index);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Ban',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onSelectChanged: (selected) {},
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        width: 300,
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: [
                              PieChartSectionData(
                                color: Colors.green,
                                value: activeUsers.toDouble(),
                                title: '$activeUsers',
                                radius: 80,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              PieChartSectionData(
                                value: bannedUsers.toDouble(),
                                title: '$bannedUsers',
                                radius: 80,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Statistics',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Active Users: $activeUsers',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Banned Users: $bannedUsers',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
