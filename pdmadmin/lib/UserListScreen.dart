import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import '../../utils/colors.dart';
import 'package:pdmadmin/widgets/header.dart';
import 'package:pdmadmin/widgets/side_bar.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
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
      final response = await http.get(Uri.parse('http://192.168.139.1:9090/user/getuser'));

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
        Uri.parse('http://192.168.139.1:9090/user/${user['username']}/ban'),
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
      body: Row(
        children: [
          const SideBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        filterUsers(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Enter username, email, lastname, or firstname',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelStyle: TextStyle(fontSize: 14),
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
                    color: primaryColor,// Set the background color to orange
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
                          rows: (filteredUsers.isNotEmpty ? filteredUsers : users)
                              .asMap()
                              .entries
                              .map((entry) {
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
                      color: const Color.fromARGB(255, 85, 57, 14), // Set the background color to orange
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
                                  color: const Color(0xffffffff),
                                ),
                              ),
                              PieChartSectionData(
                                 color: primaryColor,
                                value: bannedUsers.toDouble(),
                                title: '$bannedUsers',
                                radius: 80,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xffffffff),
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
                      color: primaryColor, // Set the background color to orange
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Active Users: $activeUsers'),
                          Text('Banned Users: $bannedUsers'),
                        ],
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
