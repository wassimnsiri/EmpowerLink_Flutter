// page_accueil.dart
import 'package:flutter/material.dart';
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
                  Header(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                 
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
