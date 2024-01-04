import 'package:flutter/material.dart';

import '../../../api/utils/api_image_loader.dart';
import '../../../model/formation.dart';
import '../../../utils/custom_date_utils.dart';
import '../../../utils/dimensions.dart';

class FormationDetailsView extends StatelessWidget {
  final Formation formation;
  final VoidCallback? tapAction;

  const FormationDetailsView({
    Key? key,
    required this.formation,
    this.tapAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Formation Details"),
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
                        child: ApiImageLoader(imageUrl: formation.image),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  formationDetailsRow(context, "Title", formation.title),
                  formationDetailsRow(
                    context,
                    "Nb place",
                    formation.nbPlace.toString(),
                  ),
                  formationDetailsRow(
                    context,
                    "Nb participant",
                    formation.nbParticipant.toString(),
                  ),
                  formationDetailsRow(
                    context,
                    "Description",
                    formation.description,
                    jumpToLine: true,
                  ),
                  formationDetailsRow(
                    context,
                    "Start date",
                    CustomDateUtils.getStringFromDate(formation.startDate),
                    jumpToLine: true,
                  ),
                  formationDetailsRow(
                    context,
                    "End date",
                    CustomDateUtils.getStringFromDate(formation.endDate),
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

  Widget formationDetailsRow(
    BuildContext context,
    String label,
    String value, {
    bool jumpToLine = false,
  }) {
    if (jumpToLine){
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
