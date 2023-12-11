import 'package:flutter/material.dart';
import './models/communityModel.dart';
import './services/communityServices.dart';
import './widgets/appBarWidget.dart';
import './widgets/sideMenuWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CommunityPage(),
    );
  }
}

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final CommunityService communityService = CommunityService();
  TextEditingController nameController = TextEditingController();
  TextEditingController objectifController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  List<Community> allCommunities = [];
  List<Community> displayedCommunities = [];

  @override
  void initState() {
    super.initState();
    getAllCommunities();
  }

  Future<void> getAllCommunities() async {
    final communities = await communityService.getAllCommunities();
    setState(() {
      allCommunities = communities;
      displayedCommunities = communities;
    });
  }

  Future<void> _showDeleteConfirmationDialog(
      String communityName, int communityId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete $communityName community?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _deleteCommunity(communityName, communityId);
                Navigator.of(context).pop(); // Close the dialog
              },
              icon: Icon(Icons.delete, color: Colors.white),
              label: Text('Delete', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showModifyDialog(String communityName) async {
    Community community =
        await communityService.getCommunityByName(communityName);

    nameController.text = community.name;
    objectifController.text = community.objectif;
    categoryController.text = community.category;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modify Community'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: objectifController,
                  decoration: InputDecoration(labelText: 'Objectif'),
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await _submitChanges(communityName);
                Navigator.of(context).pop(); // Close the dialog
              },
              icon: Icon(Icons.check, color: Colors.white),
              label: Text('Submit', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCommunity(String communityName, int communityId) async {
    await communityService.deleteCommunityById(communityId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$communityName community deleted successfully'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    getAllCommunities(); // Refresh the list
  }

  Future<void> _submitChanges(String communityName) async {
    String newName = nameController.text;
    String newObjectif = objectifController.text;
    String newCategory = categoryController.text;

    Community community =
        await communityService.getCommunityByName(communityName);

    try {
      await communityService.editCommunity(
        community.communityId,
        newName,
        newObjectif,
        newCategory,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$communityName community modified successfully'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      getAllCommunities(); // Refresh the list
    } catch (e) {
      print('Error editing community: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error editing community. Please try again.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void searchCommunities(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedCommunities = allCommunities;
      });
    } else {
      setState(() {
        displayedCommunities = allCommunities
            .where((community) =>
                community.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(title: 'Community Page'),
      body: Row(
        children: [
          ReusableSideMenu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (query) {
                      searchCommunities(query);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search Communities',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayedCommunities.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  '../build/flutter_assets/9278608.png'), // Update with your image path
                            ),
                            title: Text(
                              displayedCommunities[index].name,
                              style: TextStyle(color: Colors.black),
                            ),
                            subtitle: Text(
                              'Members: ${displayedCommunities[index].members.length}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              // TODO: Add functionality for each community item
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await _showModifyDialog(
                                        displayedCommunities[index].name);
                                    getAllCommunities();
                                  },
                                  icon: Icon(Icons.edit, color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _showDeleteConfirmationDialog(
                                      displayedCommunities[index].name,
                                      displayedCommunities[index].communityId,
                                    );
                                    getAllCommunities();
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
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
