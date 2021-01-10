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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return Scaffold(
              appBar: AppBar(),
              body: _body(context, snapshot.data as List<Widget>));

        return Container(
          color: Colors.blue,
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ),
        );
      },
      future: getToken(),
    );
  }

  Widget _body(BuildContext context, List data) => Center(
        child: Column(
          children: data,
        ),
      );
}
