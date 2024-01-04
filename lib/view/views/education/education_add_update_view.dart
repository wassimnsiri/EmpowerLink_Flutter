import 'package:flutter/material.dart';

import '../../../model/education.dart';
import '../../../api/utils/api_view_handler.dart';
import '../../../view_model/education_view_model.dart';


class EducationAddUpdateView extends StatefulWidget {
  final Education? education;

  const EducationAddUpdateView({
    Key? key,
    this.education,
  }) : super(key: key);

  @override
  State<EducationAddUpdateView> createState() => _EducationAddUpdateViewState();
}

class _EducationAddUpdateViewState extends State<EducationAddUpdateView> {
  // API
  EducationViewModel educationViewModel = EducationViewModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dureController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  bool isTrending = false;
  bool isRecommended = false;
  bool isPopular = false;

  void addOrUpdate() {
    Education education = Education(
      id: widget.education?.id,
      type: typeController.text,
      description: descriptionController.text,
      dure: int.parse(dureController.text),
      isRecommended: isRecommended,
      isTrending: isTrending,
      isPopular: isPopular,
      image: imageController.text,
    );

    ApiViewHandler.handleApiCallWithAlert(
      context: context,
      apiCall: () => widget.education?.id == null
          ? educationViewModel.add(education: education)
          : educationViewModel.update(education: education),
      successFunction: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.education?.id == null
                  ? "Course successfully added"
                  : "Course successfully updated",
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

    if (widget.education?.id != null) {
      typeController.text = widget.education?.type ?? "";
      descriptionController.text = widget.education?.description ?? "";
      dureController.text = widget.education?.dure.toString() ?? "";
      imageController.text = widget.education?.image ?? "";
      isTrending = widget.education?.isTrending ?? false;
      isRecommended = widget.education?.isRecommended ?? false;
      isPopular = widget.education?.isPopular ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.education?.id == null
            ? "Create course"
            : "Update course"),
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
                    child: Text("Type"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: typeController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category),
                      hintText: "Course Type",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter the course type";
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
                      hintText: "Course Description",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter the course description";
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
                    controller: dureController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.timelapse),
                      hintText: "Course Duration",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Please enter the course duration";
                      } else if (int.tryParse(value) == null) {
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
                  Row(
                    children: [
                      Checkbox(
                        value: isTrending,
                        onChanged: (value) {
                          setState(() {
                            isTrending = value ?? false;
                          });
                        },
                      ),
                      const Text('Is Trending'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isRecommended,
                        onChanged: (value) {
                          setState(() {
                            isRecommended = value ?? false;
                          });
                        },
                      ),
                      const Text('Is Recommended'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isPopular,
                        onChanged: (value) {
                          setState(() {
                            isPopular = value ?? false;
                          });
                        },
                      ),
                      const Text('Is Popular'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
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
                          Text(widget.education?.id == null ? "Add" : "Update"),
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
