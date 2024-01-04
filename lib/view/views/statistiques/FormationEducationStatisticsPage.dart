import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/response/api_response.dart';
import '../../../model/education.dart';
import '../../../model/formation.dart';
import '../../../view_model/education_view_model.dart';
import '../../../view_model/formation_view_model.dart';
import '../../../widgets/header.dart';

class FormationEducationStatisticsPage extends StatefulWidget {
  const FormationEducationStatisticsPage({super.key});

  @override
  State<FormationEducationStatisticsPage> createState() =>
      _FormationEducationStatisticsPageState();
}

class _FormationEducationStatisticsPageState
    extends State<FormationEducationStatisticsPage> {
  FormationViewModel formationViewModel = FormationViewModel();
  EducationViewModel educationViewModel = EducationViewModel();

  @override
  void initState() {
    super.initState();

    formationViewModel.getAll();
    educationViewModel.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formation/Education Statistics'),
      ),
      body: Column(
        children: [
          const Header(),
          Expanded(child: _buildStatistics()),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => educationViewModel),
        ChangeNotifierProvider(create: (context) => formationViewModel),
      ],
      child: Consumer2<EducationViewModel, FormationViewModel>(
        builder: (context, educationViewModel, formationViewModel, child) {
          if (formationViewModel.apiResponse.status == Status.loading ||
              educationViewModel.apiResponse.status == Status.loading) {
            return const Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            List<Education> educationList = educationViewModel.itemList;
            List<Formation> formationList = formationViewModel.itemList;

            return Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 62, 64, 180),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Formation statistics',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          _buildStatTile(
                              'Formation Count', '${formationList.length}'),
                          _buildStatTile('Average Views',
                              '${calculateAverageViewsFormation(formationList)}'),
                          _buildStatTile('Total Places',
                              '${calculateTotalPlaces(formationList)}'),
                          _buildStatTile('Participants Count',
                              '${calculateParticipantsCount(formationList)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 136, 69, 69),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Education statistics',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          _buildStatTile(
                              'Education Count', '${educationList.length}'),
                          _buildStatTile('Average Views',
                              '${calculateAverageViewsEducation(educationList)}'),
                          _buildStatTile('Recommended Count',
                              '${calculateRecommendedCount(educationList)}'),
                          _buildStatTile('Trending Count',
                              '${calculateTrendingCount(educationList)}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  double calculateAverageViewsEducation(List<Education> itemList) {
    double totalViews = 0;

    for (var item in itemList) {
      totalViews += item.views;
    }

    return itemList.isEmpty ? 0 : totalViews / itemList.length;
  }

  double calculateAverageViewsFormation(List<Formation> itemList) {
    double totalViews = 0;

    for (var item in itemList) {
      totalViews += item.views;
    }

    return itemList.isEmpty ? 0 : totalViews / itemList.length;
  }

  int calculateTotalPlaces(List<Formation> formationList) {
    int totalPlaces = 0;

    for (var formation in formationList) {
      totalPlaces += formation.nbPlace;
    }

    return totalPlaces;
  }

  int calculateParticipantsCount(List<Formation> formationList) {
    int participantsCount = 0;

    for (var formation in formationList) {
      participantsCount += formation.participants.length;
    }

    return participantsCount;
  }

  int calculateRecommendedCount(List<Education> educationList) {
    int recommendedCount = 0;

    for (var education in educationList) {
      if (education.isRecommended) {
        recommendedCount++;
      }
    }

    return recommendedCount;
  }

  int calculateTrendingCount(List<Education> educationList) {
    int trendingCount = 0;

    for (var education in educationList) {
      if (education.isTrending) {
        trendingCount++;
      }
    }

    return trendingCount;
  }

  Widget _buildStatTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
