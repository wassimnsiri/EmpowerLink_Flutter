import 'package:flutter/material.dart';
import 'package:pdm/ListHopitaux.dart';
import 'login_page.dart';
import './UserListScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmpowerLink',
   
      home: LoginPage(),
    );
  }
}
