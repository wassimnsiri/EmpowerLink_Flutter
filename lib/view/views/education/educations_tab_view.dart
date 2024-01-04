import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../api/response/status.dart';
import '../../../api/response/api_response.dart';
import '../../../model/education.dart';
import '../../../api/utils/api_image_loader.dart';
import '../../../utils/dimensions.dart';
import '../../../view_model/education_view_model.dart';
import 'education_add_update_view.dart';
import 'education_details_view.dart';
import '../../widgets/custom_error_widget.dart';
import '../../widgets/loading_widget.dart';

class EducationsTabView extends StatefulWidget {
  const EducationsTabView({Key? key}) : super(key: key);

  @override
  State<EducationsTabView> createState() => _EducationsTabViewState();
}

class _EducationsTabViewState extends State<EducationsTabView> {
  // API
  EducationViewModel educationViewModel = EducationViewModel();

  void loadData() {
    educationViewModel.getAll();
  }

  // LIFECYCLE

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => _buildMainWidget(context),
          );
        },
      ),
    );
  }

  Widget _buildMainWidget(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "List of courses",
                    style: TextStyle(fontSize: 45),
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) =>
                      const EducationAddUpdateView(),
                    ),
                  )
                      .then(
                        (value) => loadData(),
                  ),
                  child: const Text("New course"),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ChangeNotifierProvider(
                create: (context) => educationViewModel,
                child: Consumer<EducationViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.apiResponse.status == Status.completed) {
                      return _buildEducationsTableWidget();
                    } else if (viewModel.apiResponse.status ==
                        Status.loading) {
                      return const LoadingWidget();
                    } else {
                      return const CustomErrorWidget();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationsTableWidget() {
    return Card(
      elevation: 5,
      child: ClipRect(
        child: Table(
          border: TableBorder.all(
              borderRadius: Dimensions.roundedBorderMedium,
              color: Colors.black.withOpacity(0.15)),
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: Dimensions.roundedBorderTopMedium,
              ),
              children: [
                _makeTitleTableRowWidget(text: "Type"),
                _makeTitleTableRowWidget(text: "Description"),
                _makeTitleTableRowWidget(text: "Duration"),
                _makeTitleTableRowWidget(text: "Is recommended"),
                _makeTitleTableRowWidget(text: "Is trending"),
                _makeTitleTableRowWidget(text: "Is popular"),
                _makeTitleTableRowWidget(text: "Image"),
                _makeTitleTableRowWidget(text: "Actions"),
              ],
            ),
            for (Education education in educationViewModel.itemList)
              _buildEducationTableRow(education)
          ],
        ),
      ),
    );
  }

  TableRow _buildEducationTableRow(Education education) {
    return TableRow(
      children: [
        _makeTableRowWidget(text: education.type),
        _makeTableRowWidget(text: education.description),
        _makeTableRowWidget(text: education.dure.toInt().toString()),
        _makeTableRowWidget(text: education.isRecommended ? "Yes" : "No"),
        _makeTableRowWidget(text: education.isTrending ? "Yes" : "No"),
        _makeTableRowWidget(text: education.isPopular ? "Yes" : "No"),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ApiImageLoader(imageUrl: education.image),
          ),
        ),
        Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EducationDetailsView(education: education),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.cyan.withOpacity(0.3),
                    ),
                  ),
                  icon: const Icon(Icons.remove_red_eye, color: Colors.cyan),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EducationAddUpdateView(education: education),
                        ),
                      )
                      .then((value) => loadData()),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.yellow.withOpacity(0.3),
                    ),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.yellow),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                child: IconButton(
                  onPressed: () =>
                      educationViewModel.delete(id: education.id!).then(
                            (value) => loadData(),
                          ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.red.withOpacity(0.3),
                    ),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _makeTitleTableRowWidget({required String text}) {
    return Center(
      child: Padding(
        padding: Dimensions.bigPadding,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _makeTableRowWidget({required String? text}) {
    return Center(
      child: Padding(
        padding: Dimensions.bigPadding,
        child: Text("$text"),
      ),
    );
  }
}
