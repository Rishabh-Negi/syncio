import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class Home extends StatefulWidget {
  final isConnected;

  const Home({Key key, this.isConnected}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            widget.isConnected
                ? FlatButton(
                    onPressed: () {
                      print('Log out');
                      Navigator.pop(context);
                    },
                    child: Text('Log Out'),
                  )
                : Container(),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Text('connected: ${widget.isConnected}'),
            ],
          ),
        ),
      ),
    );
  }
}
