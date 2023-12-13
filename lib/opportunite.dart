import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import './Model/opportuniteModel.dart';
import './services/opportuniteService.dart';
import './widgets/appBarWidget.dart';
import './widgets/sideMenuWidget.dart';

class OpportunitePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: ReusableAppBar(title: 'Opportunité'),
        body: OpportunityList(),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}

class OpportunityList extends StatefulWidget {
  const OpportunityList({Key? key}) : super(key: key);

  @override
  _OpportunityListState createState() => _OpportunityListState();
}

class _OpportunityListState extends State<OpportunityList> {
  List<Opportunite> opportunities = [];
  String selectedDropdownValueLocation = 'Paris';
  String selectedDropdownValueType = 'CDI';
  String searchQuery = '';
  String newOpportunityDescription = '';

  List<String> locations = ['Paris', 'Lyon', 'Marseille', 'Autre'];
  List<String> contractTypes = [
    'CDI',
    'CDD',
    'Stage',
    'Alternance',
    'Freelance'
  ];

  int selectedOpportunityIndex = -1;

  final TextEditingController newOpportunityController =
      TextEditingController();
  final TextEditingController newDescriptionController =
      TextEditingController();
  final TextEditingController newSkillController = TextEditingController();
  final TextEditingController newContactEmailController =
      TextEditingController();
  final TextEditingController newContactContratController =
      TextEditingController();
  final TextEditingController newContactLieuController =
      TextEditingController();
  final TextEditingController newContactSalaryController =
      TextEditingController();
  final TextEditingController newContactEntepriseController =
      TextEditingController();

  final TextEditingController editOpportunityController =
      TextEditingController();
  final TextEditingController editDescriptionController =
      TextEditingController();
  final TextEditingController editSkillController = TextEditingController();
  final TextEditingController editContactEmailController =
      TextEditingController();
  final TextEditingController editContactContratController =
      TextEditingController();
  final TextEditingController editContactLieuController =
      TextEditingController();
  final TextEditingController editContactSalaryController =
      TextEditingController();
  final TextEditingController editContactEntepriseController =
      TextEditingController();

  OpportuniteService opportuniteService = OpportuniteService();

  @override
  void initState() {
    super.initState();
    fetchOpportunities();
  }

  Future<void> _editOpportunity(
    int index,
    String editedTitle,
    String editedDescription,
    String editedSkill,
    String editedContactEmail,
    String editedNomEntreprise,
    String editedSalary,
    String editedLieu,
    String editedTypeDeContrat,
  ) async {
    try {
      Opportunite updatedOpportunity = Opportunite(
        id: opportunities[index]
            .id, // Include the id when creating the updated opportunity
        title: editedTitle,
        description: editedDescription,
        skill: editedSkill,
        contactEmail: editedContactEmail,
        nomEntreprise: editedNomEntreprise,
        salary: editedSalary,
        lieu: editedLieu,
        typeDeContrat: editedTypeDeContrat,
        applicants: [], // Example value for applicants
      );
      print(updatedOpportunity.title);

      await opportuniteService.editOpportunity(updatedOpportunity);
      await fetchOpportunities();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Opportunity edited successfully"),
      ));
      Navigator.pop(
          context); // Close the AlertDialog or navigate to another screen if needed
    } catch (e) {
      print('Error editing opportunity: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error editing opportunity"),
      ));
    }
  }

  Future<void> fetchOpportunities() async {
    try {
      List<Opportunite?> fetchedOpportunities =
          await opportuniteService.fetchOpportunites();
      setState(() {
        opportunities = fetchedOpportunities
            .where((opportunity) => opportunity != null)
            .cast<Opportunite>()
            .toList();
      });
    } catch (e) {
      print('Error fetching opportunities: $e');
    }
  }

  void addOpportunity(Opportunite newOpportunity) async {
    try {
      await opportuniteService.createOpportunity(newOpportunity);
      await fetchOpportunities(); // Assuming fetchOpportunities is a method to refresh the opportunity list
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Opportunity added successfully"),
      ));
      Navigator.pop(
          context); // Close the AlertDialog or navigate to another screen if needed
    } catch (e) {
      print('Error adding opportunity: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error adding opportunity"),
      ));
    }
  }

  void editOpportunity(
      int index, String editedOpportunity, String editedDescription) {
    // Implement the logic to edit an opportunity on the server using the service
    // Update the state if necessary
  }

  Future<void> deleteOpportunity(int index) async {
    try {
      await opportuniteService.deleteOpportunite(opportunities[index].id!);
      await fetchOpportunities();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Opportunité supprimée avec succès"),
      ));
    } catch (e) {
      print('Error deleting opportunity: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur lors de la suppression de l'opportunité"),
      ));
    }
  }

  Future<bool?> _showDeleteDialog(BuildContext context, int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer l\'opportunité'),
          content: Text('Voulez-vous vraiment supprimer cette opportunité?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler', style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                await deleteOpportunity(index);
                Navigator.pop(context, true);
              },
              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
      BuildContext context, Opportunite? opportunity, int index) {
    TextEditingController titleController =
        TextEditingController(text: opportunity?.title ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: opportunity?.description ?? '');
    TextEditingController skillController =
        TextEditingController(text: opportunity?.skill ?? '');
    TextEditingController contactEmailController =
        TextEditingController(text: opportunity?.contactEmail ?? '');
    TextEditingController nomEntrepriseController =
        TextEditingController(text: opportunity?.nomEntreprise ?? '');
    TextEditingController salaryController =
        TextEditingController(text: opportunity?.salary ?? '');
    TextEditingController lieuController =
        TextEditingController(text: opportunity?.lieu ?? '');
    TextEditingController typeDeContratController =
        TextEditingController(text: opportunity?.typeDeContrat ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier une opportunité'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Modifier l\'opportunité',
                  fillColor: Colors.white,
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Modifier la description',
                  fillColor: Colors.white,
                ),
              ),
              TextField(
                controller: skillController,
                decoration: InputDecoration(
                  labelText: 'Modifier le skill',
                  fillColor: Colors.white,
                ),
              ),
              TextField(
                controller: contactEmailController,
                decoration: InputDecoration(
                  labelText: 'Modifier l\'email de contact',
                  fillColor: Colors.white,
                ),
              ),
              TextField(
                controller: nomEntrepriseController,
                decoration: InputDecoration(
                  labelText: 'Modifier le nom de l\'entreprise',
                  fillColor: Colors.white,
                ),
              ),
              TextField(
                controller: salaryController,
                decoration: InputDecoration(
                  labelText: 'Modifier le salaire',
                  fillColor: Colors.white,
                ),
              ),
              TextField(
                controller: lieuController,
                decoration: InputDecoration(
                  labelText: 'Modifier le lieu',
                  fillColor: Colors.white,
                ),
              ),
              TextField(
                controller: typeDeContratController,
                decoration: InputDecoration(
                  labelText: 'Modifier le type de contrat',
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                _editOpportunity(
                  index,
                  titleController.text,
                  descriptionController.text,
                  skillController.text,
                  contactEmailController.text,
                  nomEntrepriseController.text,
                  salaryController.text,
                  lieuController.text,
                  typeDeContratController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Modifier', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showContractTypePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          Text('Annuler', style: TextStyle(color: Colors.red)),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context, selectedDropdownValueType);
                      },
                      child: Text('Valider',
                          style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  backgroundColor: Colors.white, // Set background color
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedDropdownValueType = contractTypes[index];
                    });
                  },
                  children: contractTypes.map<Widget>((String value) {
                    return Center(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    );
                  }).toList(),
                  looping: true, // Enable looping of items
                  scrollController: FixedExtentScrollController(
                    initialItem:
                        contractTypes.indexOf(selectedDropdownValueType),
                  ),
                  // Add a border
                  selectionOverlay: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.blue, width: 0.8),
                        bottom: BorderSide(color: Colors.blue, width: 0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLieuTypePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child:
                          Text('Annuler', style: TextStyle(color: Colors.red)),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context, selectedDropdownValueType);
                      },
                      child: Text('Valider',
                          style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40,
                  backgroundColor: Colors.white, // Set background color
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedDropdownValueType = contractTypes[index];
                    });
                  },
                  children: contractTypes.map<Widget>((String value) {
                    return Center(
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    );
                  }).toList(),
                  looping: true, // Enable looping of items
                  scrollController: FixedExtentScrollController(
                    initialItem:
                        contractTypes.indexOf(selectedDropdownValueType),
                  ),
                  // Add a border
                  selectionOverlay: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.blue, width: 0.8),
                        bottom: BorderSide(color: Colors.blue, width: 0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Opportunite> filteredOpportunities = opportunities
        .where((opportunity) =>
            opportunity.title
                ?.toLowerCase()
                .contains(searchQuery.toLowerCase()) ??
            false)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(CupertinoIcons.location, color: Colors.blue),
              SizedBox(width: 8.0),
              Text('Lieu: ',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  _showLieuTypePicker(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    selectedDropdownValueType,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(CupertinoIcons.briefcase, color: Colors.blue),
              SizedBox(width: 8.0),
              Text('Type de contrat: ',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  _showLieuTypePicker(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    selectedDropdownValueType,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Ajouter une opportunité'),
                      content: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: newOpportunityController,
                              decoration: InputDecoration(
                                labelText: 'Nouvelle opportunité',
                              ),
                            ),
                            TextFormField(
                              controller: newDescriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                            TextFormField(
                              controller:
                                  newSkillController, // Add a controller for skill
                              decoration: InputDecoration(
                                labelText: 'Skill',
                              ),
                            ),
                            TextFormField(
                              controller:
                                  newContactEmailController, // Add a controller for contactEmail
                              decoration: InputDecoration(
                                labelText: 'Contact Email',
                              ),
                            ),
                            TextFormField(
                              controller:
                                  newContactContratController, // Add a controller for contactEmail
                              decoration: InputDecoration(
                                labelText: 'Type de Contrat',
                              ),
                            ),
                            TextFormField(
                              controller:
                                  newContactLieuController, // Add a controller for contactEmail
                              decoration: InputDecoration(
                                labelText: 'Lieu',
                              ),
                            ),
                            TextFormField(
                              controller:
                                  newContactSalaryController, // Add a controller for contactEmail
                              decoration: InputDecoration(
                                labelText: 'Salary',
                              ),
                            ),
                            TextFormField(
                              controller:
                                  newContactEntepriseController, // Add a controller for contactEmail
                              decoration: InputDecoration(
                                labelText: 'Nom de entreprise',
                              ),
                            ),
                            // Add additional TextFormField widgets for other fields
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Annuler',
                              style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () {
                            Opportunite newOpportunity = Opportunite(
                              title: newOpportunityController.text,
                              description: newDescriptionController.text,
                              skill: newSkillController.text,
                              contactEmail: newContactEmailController.text,
                              nomEntreprise: newContactEntepriseController.text,
                              salary: newContactSalaryController.text,
                              // Add other field values as needed
                              lieu: newContactLieuController
                                  .text, // Example value for lieu
                              typeDeContrat: newContactContratController.text,
                              // Example value for typeDeContrat
                              applicants: [], // Example value for applicants
                            );

                            addOpportunity(newOpportunity);
                            Navigator.pop(context);
                          },
                          child: Text('Ajouter',
                              style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8.0),
                  Text('Ajouter', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredOpportunities.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(filteredOpportunities[index].title!),
                direction: DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    return await _showDeleteDialog(context, index);
                  } else if (direction == DismissDirection.startToEnd) {
                    _showEditDialog(
                        context, filteredOpportunities[index], index);
                    return false; // Prevent dismiss until the edit is completed
                  }
                  return false;
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
                child: Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Text(
                      filteredOpportunities[index]?.title ?? 'No Title',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      filteredOpportunities[index]?.description ??
                          'No Description',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpportunityDetailScreen(
                              opportunity: filteredOpportunities[index],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class OpportunityDetailScreen extends StatelessWidget {
  final Opportunite? opportunity;

  OpportunityDetailScreen({Key? key, required this.opportunity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDetailRow('Title', opportunity?.title),
        buildDetailRow('Description', opportunity?.description),
        buildDetailRow('Skill', opportunity?.skill),
        buildDetailRow('Contact Email', opportunity?.contactEmail),
        buildDetailRow('Salary', opportunity?.salary),
        buildDetailRow('Nom Entreprise', opportunity?.nomEntreprise),
        buildDetailRow('Lieu', opportunity?.lieu),
        buildDetailRow('Type de Contrat', opportunity?.typeDeContrat),
      ],
    );
  }

  Widget buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            value ?? 'Non spécifié',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
