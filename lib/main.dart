import 'package:flutter/material.dart';
import 'package:syncio/screens/login/login.dart';

void main() {
  runApp(Syncio());
}

class Syncio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
