import 'package:flutter/material.dart';
import '../../services/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  var error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                RaisedButton(
                  onPressed: () {
                    webAuth();
                    print('tapped');
                  },
                  child: Text('Press'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
