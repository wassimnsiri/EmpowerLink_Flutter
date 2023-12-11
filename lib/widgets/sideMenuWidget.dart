import '../ApproveCommunity.dart';
import '../community.dart';
import 'package:flutter/material.dart';

class ReusableSideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color.fromARGB(255, 30, 145, 202),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20), // Spacer at the top
          ListTile(
            title: Text(
              'Education',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.school, color: Colors.white),
            onTap: () {
              // TODO: Add functionality for Education item
            },
          ),
          ListTile(
            title: Text(
              'Hospitals',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.local_hospital, color: Colors.white),
            onTap: () {
              // TODO: Add functionality for Hospitals item
            },
          ),
          ListTile(
            title: Text(
              'Formation',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.library_books, color: Colors.white),
            onTap: () {
              // TODO: Add functionality for Formation item
            },
          ),
          ExpansionTile(
            title: Text(
              'Communities',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.group, color: Colors.white),
            children: [
              ListTile(
                title: Text(
                  'All Communities',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Navigate to the ApproveCommunityPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Approve Requests',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Navigate to the ApproveCommunityPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApproveCommunityPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          ListTile(
            title: Text(
              'Opportunities',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.work, color: Colors.white),
            onTap: () {
              // TODO: Add functionality for Opportunities item
            },
          ),
          Expanded(child: Container()), // Spacer in the middle
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            leading: Icon(Icons.logout, color: Colors.white),
            onTap: () {
              // TODO: Add functionality for Logout item
            },
          ),
          SizedBox(height: 20), // Spacer at the bottom
        ],
      ),
    );
  }
}
