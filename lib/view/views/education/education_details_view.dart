import 'package:flutter/material.dart';

import '../../../model/education.dart';
import '../../../api/utils/api_image_loader.dart';
import '../../../utils/dimensions.dart';


class EducationDetailsView extends StatelessWidget {
  final Education education;
  final VoidCallback? tapAction;

  const EducationDetailsView({
    Key? key,
    required this.education,
    this.tapAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Course Details"),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Card(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: Dimensions.bigPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 200,
                        constraints: const BoxConstraints(minWidth: 200),
                        child: ApiImageLoader(imageUrl: education.image),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  educationDetailsRow(
                    context,
                    "Type",
                    education.type,
                  ),
                  educationDetailsRow(
                    context,
                    "Duration",
                    education.dure.toInt().toString(),
                  ),
                  educationDetailsRow(
                    context,
                    "Description",
                    education.description,
                    jumpToLine: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget educationDetailsRow(
    BuildContext context,
    String label,
    String value, {
    bool jumpToLine = false,
  }) {
    if (jumpToLine) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label : ",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label : ",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ],
      ),
    );
  }
}
