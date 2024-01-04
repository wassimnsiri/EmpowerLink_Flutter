import 'package:flutter/material.dart';

import '../../../api/utils/api_view_handler.dart';
import '../../../model/formation.dart';
import '../../../utils/custom_date_utils.dart';
import '../../../view_model/formation_view_model.dart';

class FormationAddUpdateView extends StatefulWidget {
  final Formation? formation;

  const FormationAddUpdateView({
    Key? key,
    this.formation,
  }) : super(key: key);

  @override
  State<FormationAddUpdateView> createState() => _FormationAddUpdateViewState();
}

class _FormationAddUpdateViewState extends State<FormationAddUpdateView> {
  FormationViewModel formationViewModel = FormationViewModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController nbPlaceController = TextEditingController();
  final TextEditingController nbParticipantController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        controller.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  void addOrUpdate() {
    Formation formation = Formation(
      id: widget.formation?.id,
      title: titleController.text,
      nbPlace: int.parse(nbPlaceController.text),
      nbParticipant: int.parse(nbParticipantController.text),
      description: descriptionController.text,
      image: imageController.text,
      startDate: CustomDateUtils.getDateFromString(startDateController.text),
      endDate: CustomDateUtils.getDateFromString(endDateController.text),
    );

    ApiViewHandler.handleApiCallWithAlert(
      context: context,
      apiCall: () => widget.formation?.id == null
          ? formationViewModel.add(formation: formation)
          : formationViewModel.update(formation: formation),
      successFunction: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.formation?.id == null
                  ? "Formation successfully added"
                  : "Formation successfully updated",
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.of(context).pop();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.formation?.id != null) {
      titleController.text = widget.formation?.title ?? "";
      nbPlaceController.text = widget.formation?.nbPlace.toString() ?? "0";
      nbParticipantController.text =
          widget.formation?.nbParticipant.toString() ?? "0";
      descriptionController.text = widget.formation?.description ?? "";
      imageController.text = widget.formation?.image ?? "";
      startDateController.text = CustomDateUtils.getStringFromDate(widget.formation?.startDate);
      endDateController.text = CustomDateUtils.getStringFromDate(widget.formation?.endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formation?.id == null
            ? "Create formation"
            : "Update formation"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: <Widget>[
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text("Title"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      hintText: "Formation Type",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter the formation type";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text("Description"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      hintText: "Formation Description",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter the formation description";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text("Duration"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: nbPlaceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.confirmation_number_outlined),
                      hintText: "Formation Duration (in hours)",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter the formation duration";
                      }
                      if (int.tryParse(value) == null) {
                        return "Please enter a valid number";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text("Number of Participants"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: nbParticipantController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.people),
                      hintText: "Number of Participants",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter the number of participants";
                      }
                      if (int.tryParse(value) == null) {
                        return "Please enter a valid number";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text("Image"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: imageController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.image),
                      hintText: "Image URL",
                    ),
                    validator: (String? value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text("Start Date"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: startDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true, // Make the text field unmodifiable
                    onTap: () => _selectDate(startDateController),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: "Start Date",
                    ),
                    validator: (String? value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text("End Date"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: endDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true, // Make the text field unmodifiable
                    onTap: () => _selectDate(endDateController),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: "End Date",
                    ),
                    validator: (String? value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) addOrUpdate();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ),
                          Text(widget.formation?.id == null ? "Add" : "Update"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
