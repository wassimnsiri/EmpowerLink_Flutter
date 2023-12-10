// page_accueil.dart
import 'package:flutter/material.dart';
import 'package:pdmadmin/utils/media_query_values.dart';
import 'package:pdmadmin/widgets/overall_portfolio_card.dart';
import 'package:pdmadmin/widgets/overview_statistic_widget.dart';
import '../widgets/header.dart';
import '../widgets/side_bar.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Header(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        const Column(
                          children: [
                            OverallPortfolioCard(),
                            OverviewStatistic(),
                          ],
                        ),
                        SizedBox(
                          width: context.width * 0.023,
                        ),
                       // const StockWidget(),
                      ],
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