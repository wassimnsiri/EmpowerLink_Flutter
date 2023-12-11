import 'package:flutter/material.dart';
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
      theme: ThemeData.dark().copyWith(
          //scaffoldBackgroundColor: const Color.fromARGB(255, 104, 93, 93),
          ),
      home: LoginPage(),
    );
  }
}
