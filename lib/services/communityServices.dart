import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/communityModel.dart';

class CommunityService {
  Future<List<Community>> getAllCommunities() async {
    final response = await http.get(
      Uri.parse('http://localhost:9090/community/getAllCommunities'),
    );

    if (response.statusCode == 200 || response.statusCode == 300) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'communities' key
      if (jsonResponse['communities'] != null) {
        final List<dynamic> communityList = jsonResponse['communities'];
        return communityList.map((data) => Community.fromJson(data)).toList();
      } else {
        throw Exception('No "communities" key found in the response.');
      }
    } else {
      throw Exception('Failed to load communities');
    }
  }

  Future<void> deleteCommunityById(int communityId) async {
    final response = await http.post(
      Uri.parse('http://localhost:9090/community/deleteCommunity'),
      body: {'groupId': communityId.toString()},
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'message' key
      if (jsonResponse['message'] == 'Community deleted') {
        print('Community with ID $communityId deleted successfully.');
      } else {
        throw Exception(
            'Failed to delete community. Server response: $jsonResponse');
      }
    } else {
      throw Exception(
          'Failed to delete community. Status code: ${response.statusCode}');
    }
  }

  Future<Community> getCommunityByName(String communityName) async {
    final response = await http.post(
      Uri.parse('http://localhost:9090/community/getCommunityByName'),
      body: {'name': communityName},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'community' key
      if (jsonResponse['community'] != null) {
        final dynamic communityData = jsonResponse['community'];
        return Community.fromJson(communityData);
      } else {
        throw Exception('No "community" key found in the response.');
      }
    } else {
      throw Exception('Failed to load community details');
    }
  }

  Future<void> editCommunity(
      int communityId, String name, String objectif, String category) async {
    final response = await http.post(
      Uri.parse('http://localhost:9090/community/editCommunity'),
      body: {
        'communityId': communityId.toString(),
        'name': name,
        'objectif': objectif,
        'category': category,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'message' key
      if (jsonResponse['message'] == 'Community edited') {
        print('Community with ID $communityId edited successfully.');
      } else {
        throw Exception(
            'Failed to edit community. Server response: $jsonResponse');
      }
    } else {
      throw Exception(
          'Failed to edit community. Status code: ${response.statusCode}');
    }
  }

  Future<List<Community>> showJoinRequests() async {
    final response = await http.get(
      Uri.parse('http://localhost:9090/community/getAllCommunities'),
    );

    if (response.statusCode == 200 || response.statusCode == 300) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'communities' key
      if (jsonResponse['communities'] != null) {
        final List<dynamic> communityList = jsonResponse['communities'];

        // Filter communities with pending requests
        final List<Community> communitiesWithPending = communityList
            .where((data) => (data['pending'] as List<dynamic>).isNotEmpty)
            .map((data) => Community.fromJson(data))
            .toList();

        return communitiesWithPending;
      } else {
        throw Exception('No "communities" key found in the response.');
      }
    } else {
      throw Exception('Failed to load communities');
    }
  }

  Future<void> approveCommunityMember(String username, int communityId) async {
    final response = await http.post(
      Uri.parse('http://localhost:9090/community/approveRequest'),
      body: {
        'username': username,
        'communityId': communityId.toString(),
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response contains a 'message' key
      if (jsonResponse['message'] == 'Request approved') {
        print(
            'Request for $username in community $communityId approved successfully.');
      } else {
        throw Exception(
            'Failed to approve request. Server response: $jsonResponse');
      }
    } else {
      throw Exception(
          'Failed to approve request. Status code: ${response.statusCode}');
    }
  }
}
