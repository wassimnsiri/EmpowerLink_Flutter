import 'package:flutter/material.dart';
import 'package:pdm/service_detail.dart';
import './Model/ServiceSociaux.dart';
import './widgets/sideMenuWidget.dart';
import './widgets/appBarWidget.dart';

class HospitalDetailPage extends StatelessWidget {
  final ServiceSociaux hospital;
  final BuildContext parentContext;

  HospitalDetailPage({
    required this.hospital,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(title: 'Détails de l\'Hôpital'),
      drawer: ReusableSideMenu(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  'https://example.com/path-to-your-image.jpg',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Nom de l\'hôpital : ${hospital.nom}',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Hospital name text color
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Date : 01/01/2023', // Replace with the actual date of the hospital
                    style: TextStyle(
                        fontSize: 18.0, color: Colors.black), // Date text color
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blueAccent,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Lieu : Ville, Pays', // Replace with the actual location of the hospital
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black), // Location text color
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Soins disponibles :',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // "Soins disponibles" text color
                ),
              ),
            ),
            SizedBox(height: 10),
            buildServicesList(),
          ],
        ),
      ),
    );
  }

  Widget buildServicesList() {
    print("Hospital: $hospital");
    if (hospital != null) {
      print("Nom de l'hôpital: ${hospital.nom}");
      print("Services disponibles: ${hospital.services}");
    } else {
      print("Hospital is null");
    }
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: hospital.services.length,
      itemBuilder: (context, index) {
        final service = hospital.services[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              parentContext,
              MaterialPageRoute(
                builder: (context) =>
                    ServiceDetailPage(serviceName: service ?? ""),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    service ?? "",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black, // Service text color
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
