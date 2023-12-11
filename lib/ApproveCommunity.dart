import 'package:flutter/material.dart';
import './widgets/appBarWidget.dart';
import './widgets/sideMenuWidget.dart';
import '../services/communityServices.dart';
import './models/communityModel.dart';

class ApproveCommunityPage extends StatefulWidget {
  @override
  _ApproveCommunityPageState createState() => _ApproveCommunityPageState();
}

class _ApproveCommunityPageState extends State<ApproveCommunityPage> {
  final CommunityService communityService = CommunityService();
  List<Community> communitiesWithPending = [];

  @override
  void initState() {
    super.initState();
    showJoinRequests();
  }

  Future<void> showJoinRequests() async {
    final List<Community> result = await communityService.showJoinRequests();
    setState(() {
      communitiesWithPending = result;
    });
  }

  Future<void> approveCommunityMember(String username, int communityId) async {
    try {
      // Approve the request
      await communityService.approveCommunityMember(username, communityId);

      // Update the UI by removing the user from the list and incrementing members count
      setState(() {
        communitiesWithPending.forEach((community) {
          if (community.communityId == communityId) {
            community.pending.remove(username);
            community.members.add(username);
          }
        });
      });

      print('Request approved successfully.');
      // Refresh the UI or perform any other actions after approval
    } catch (e) {
      print('Failed to approve request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(title: 'Approve Community Requests'),
      body: Row(
        children: [
          ReusableSideMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: communitiesWithPending.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      '../build/flutter_assets/9278608.png'),
                                  radius: 20,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      communitiesWithPending[index].name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Objectif: ${communitiesWithPending[index].objectif}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Members: ${communitiesWithPending[index].members.length}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Pending Requests:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              if (communitiesWithPending[index].pending.isEmpty)
                                Center(
                                  child: Text(
                                    'All requests have been approved!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                )
                              else
                                Column(
                                  children: communitiesWithPending[index]
                                      .pending
                                      .map(
                                        (user) => ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                '../build/flutter_assets/3135715.png'),
                                            radius: 15,
                                          ),
                                          title: Text(user),
                                          trailing: ElevatedButton.icon(
                                            onPressed: () {
                                              approveCommunityMember(
                                                user,
                                                communitiesWithPending[index]
                                                    .communityId,
                                              );
                                            },
                                            icon: Icon(Icons.check,
                                                color: Colors.white),
                                            label: Text(
                                              'Approve',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                            ],
                          ),
                        );
                      },
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
