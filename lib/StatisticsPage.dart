import 'package:flutter/material.dart';

import 'Model/User.dart';

class StatisticsPage extends StatelessWidget {
  final User user;

  StatisticsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics for ${user.username}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildStatTile('Followers', user.followers.length.toString()),
            _buildStatTile('Following', user.following.length.toString()),
            _buildStatTile('Verification Status',
                user.verifierd ? 'Verified' : 'Not Verified'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: StatisticsPage(
        user: User(
          username: 'john_doe',
          firstname: 'John',
          lastname: 'Doe',
          email: 'john@example.com',
          password: 'password123',
          adress: '123 Main St',
          description: 'Flutter Developer',
          number: 1234567890,
          skills: ['Flutter', 'Dart'],
          followers: [
            /* list of followers */
          ],
          following: [
            /* list of following */
          ],
          birthday: DateTime(1990, 1, 1),
          image: 'profile_image.jpg',
          role: 'user',
          banned: 'no',
          banduration: '',
          reason: '',
          verifierd: true,
          restcode: '',
        ),
      ),
    ),
  );
}
