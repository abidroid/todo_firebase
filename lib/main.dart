import 'package:flutter/material.dart';
import 'package:todo_firebase/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(

        primaryColor: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
