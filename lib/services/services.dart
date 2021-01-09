import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///
/// hide these client id and rest using some means
///

String _url = "https://accounts.spotify.com/authorize?";
String _clientId = "9ebc175b68c84e4c8fc8417c9ab4cbcd";
String _redirectUri = "syncio:/";
String _scope =
    "app-remote-control,user-modify-playback-state,playlist-read-private,user-library-read,user-library-read,user-read-email";

class ConnectToSpotify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void webAuth() async {
  http.Response _response = await http.get(
      '${_url}client_id=$_clientId&response_type=code&redirect_uri=$_redirectUri&scope=$_scope&state=34fFs29kd09');

  print('${_response.body}');
  
  // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
}

///
///  Use device apps or some other way to detect spotify is installed or not and then redirect to app
///
