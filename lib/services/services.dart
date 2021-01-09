import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

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
  try {
    var _authToken = await SpotifySdk.getAuthenticationToken(
        clientId: _clientId, redirectUrl: _redirectUri, scope: _scope);
  } on PlatformException catch (e) {}
}

///
///  Use device apps or some other way to detect spotify is installed or not and then redirect to app
///
