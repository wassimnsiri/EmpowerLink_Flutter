import 'package:flutter/material.dart';
import 'package:pdm/view/views/education/educations_tab_view.dart';
import 'package:pdm/view/views/formation/formations_tab_view.dart';

import '../widgets/header.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  // UI
  PageController pageController = PageController();

  int currentPage = 0;

  List<String> tabTitles = [
    "Courses",
    "Formations",
  ];

  List<IconData> tabIcons = [
    Icons.book_outlined,
    Icons.group_work_outlined,
  ];

  List<IconData> tabIconsSelected = [
    Icons.book,
    Icons.group_work,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: false,
            onDestinationSelected: (int index) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
              setState(() => currentPage = index);
            },
            selectedIndex: currentPage,
            destinations: List.generate(
              tabIcons.length,
              (index) => NavigationRailDestination(
                icon: Icon(tabIcons[index]),
                selectedIcon: Icon(tabIconsSelected[index]),
                label: Text(tabTitles[index]),
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(child: _buildBodyWidget())
        ],
      ),
    );
  }

  Widget _buildBodyWidget() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: const [
          EducationsTabView(),
          FormationsTabView(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Icon(tabIcons[currentPage]),
              const SizedBox(width: 15),
              Text(
                tabTitles[currentPage],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
