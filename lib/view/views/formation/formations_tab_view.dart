import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../api/response/status.dart';
import '../../../../model/formation.dart';
import '../../../api/response/api_response.dart';
import '../../../api/utils/api_image_loader.dart';
import '../../../utils/custom_date_utils.dart';
import '../../../utils/dimensions.dart';
import '../../../view_model/formation_view_model.dart';
import 'formation_add_update_view.dart';
import 'formation_details_view.dart';
import '../../widgets/custom_error_widget.dart';
import '../../widgets/loading_widget.dart';

class FormationsTabView extends StatefulWidget {
  const FormationsTabView({Key? key}) : super(key: key);

  @override
  State<FormationsTabView> createState() => _FormationsTabViewState();
}

class _FormationsTabViewState extends State<FormationsTabView> {
  // API
  FormationViewModel formationViewModel = FormationViewModel();

  void loadData() {
    formationViewModel.getAll();
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
                    "List of formations",
                    style: TextStyle(fontSize: 45),
                  ),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const FormationAddUpdateView(),
                        ),
                      )
                      .then(
                        (value) => loadData(),
                      ),
                  child: const Text("New formation"),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ChangeNotifierProvider(
                create: (context) => formationViewModel,
                child: Consumer<FormationViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.apiResponse.status == Status.completed) {
                      return _buildFormationsTableWidget();
                    } else if (viewModel.apiResponse.status == Status.loading) {
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

  Widget _buildFormationsTableWidget() {
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
                borderRadius: Dimensions.roundedBorderTopMedium,
              ),
              children: [
                _makeTitleTableRowWidget(text: "Title"),
                _makeTitleTableRowWidget(text: "Nb place"),
                _makeTitleTableRowWidget(text: "Nb participant"),
                _makeTitleTableRowWidget(text: "Description"),
                _makeTitleTableRowWidget(text: "Start date"),
                _makeTitleTableRowWidget(text: "End date"),
                _makeTitleTableRowWidget(text: "Image"),
                _makeTitleTableRowWidget(text: "Actions"),
              ],
            ),
            for (Formation formation in formationViewModel.itemList)
              _buildFormationTableRow(formation)
          ],
        ),
      ),
    );
  }

  TableRow _buildFormationTableRow(Formation formation) {
    return TableRow(
      children: [
        _makeTableRowWidget(text: formation.title),
        _makeTableRowWidget(text: formation.nbPlace.toInt().toString()),
        _makeTableRowWidget(text: formation.nbParticipant.toInt().toString()),
        _makeTableRowWidget(text: formation.description),
        _makeTableRowWidget(
          text: CustomDateUtils.getStringFromDate(formation.startDate),
        ),
        _makeTableRowWidget(
          text: CustomDateUtils.getStringFromDate(formation.endDate),
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ApiImageLoader(imageUrl: formation.image),
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
                          FormationDetailsView(formation: formation),
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
                              FormationAddUpdateView(formation: formation),
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
                      formationViewModel.delete(id: formation.id!).then(
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
