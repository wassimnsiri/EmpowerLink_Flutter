import 'package:flutter/material.dart';
import 'package:pdm/Provider/UserProvider.dart';
import 'package:pdm/UserListScreen.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(), // Provide the UserProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmpowerLink',
      home: UserListScreen(),
    );
  }
}
