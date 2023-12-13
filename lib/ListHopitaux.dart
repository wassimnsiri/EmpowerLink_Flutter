import 'package:flutter/material.dart';
import './HospitalDetailPage.dart';
import './widgets/sideMenuWidget.dart';
import './widgets/appBarWidget.dart';

import './Model/ServiceSociaux.dart';
import './services/ServicesSocservices.dart';

class HospitalListPage extends StatefulWidget {
  @override
  _HospitalListPageState createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  List<ServiceSociaux> hospitals = [];
  late List<ServiceSociaux> filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    fetchHospitals().then((fetchedHospitals) {
      setState(() {
        hospitals = fetchedHospitals;
        filteredHospitals = hospitals;
      });
    }).catchError((error) {
      print('Error fetching hospitals: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(title: 'Liste des Hopitaux'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white], // Change the gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [
            ReusableSideMenu(),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        filterHospitals(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Rechercher un hôpital',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blue, // Change the search icon color
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: buildHospitalList(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHospitalList(BuildContext context) {
    return ListView.builder(
      itemCount: filteredHospitals.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HospitalDetailPage(
                  hospital: filteredHospitals[index],
                  parentContext: context,
                ),
              ),
            );
          },
          child: Card(
            elevation: 2.0,
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(20.0),
              title: Text(
                filteredHospitals[index].nom ?? '',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(
                      255, 0, 0, 0), // Change text color to black
                ),
              ),
              subtitle: Text(
                'Emplacement: ${filteredHospitals[index].lieu ?? ''}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: Colors.blue, // Change the arrow icon color
              ),
            ),
          ),
        );
      },
    );
  }

  void filterHospitals(String query) {
    print("Query: $query");
    setState(() {
      filteredHospitals = hospitals
          .where((hospital) =>
              hospital.nom?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    });
    print("Filtered Hospitals after filtering: $filteredHospitals");
  }
}
