import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:syncio/screens/home/home-screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  ///
  /// hide these client id and rest using some means
  ///

  String _clientId = "9ebc175b68c84e4c8fc8417c9ab4cbcd";
  String _redirectUri = "syncio:/";
  String _scope =
      "app-remote-control,user-modify-playback-state,playlist-read-private,user-library-read,user-library-read,user-read-email";

  void webAuth() async {
    var _authToken = await SpotifySdk.getAuthenticationToken(
        clientId: _clientId, redirectUrl: _redirectUri, scope: _scope);
    if (_authToken != null)
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  var error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(),
    );
  }
}

///
///  Use device apps or some other way to detect spotify is installed or not and then redirect to app
///
///
// void connectToSpotify() async {
//   try {
//     final _authToken = await SpotifySdk.connectToSpotifyRemote(
//       clientId: _clientId,
//       redirectUrl: _redirectUri,
//     );

//     if (_authToken != null) {
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => Home()));
//     }
//   } on PlatformException catch (e) {
//     setState(() {
//       error = "Spotify App Not Installed";
//     });
//     webAuth();
//     print('error : $e');
//   } on MissingPluginException catch (e) {
//     setState(() {
//       error = "Missing Plugin Exception";
//     });
//     print('error: $e');
//   }
// }
