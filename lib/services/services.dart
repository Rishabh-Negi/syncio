import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:syncio/models/user.dart';

///
/// hide these client id and rest using some means
///

String _clientId = "9ebc175b68c84e4c8fc8417c9ab4cbcd";
String _redirectUri = "syncio:/";
String _scope =
    "app-remote-control,user-modify-playback-state,playlist-read-private,user-library-read,user-library-read,user-read-email";

///
/// variables
///
var error;
final Logger _logger = Logger();
var _token;

///
/// Calling WEB API'S
///

Future<List> getToken() async {
  _token = await getAuthenticationToken();
  List<Widget> list = [];

  list = await getCurrentUserDetails();
  return list;
}

Future<List> getCurrentUserDetails() async {
  var headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  var res = await http.get('https://api.spotify.com/v1/me', headers: headers);
  List<Widget> list1 = [];

  if (res.statusCode == 200) {
    var data = jsonDecode(res.body);
    try {
      User _user = User.fromMap(data);
      // print(_user);
      _user.toMap().forEach((key, value) {
        Widget _element = Column(
          children: [
            Text('$key: '),
            Text(
              '$value',
              softWrap: true,
            ),
          ],
        );
        list1.add(_element);
        list1.add(Divider());
      });
    } catch (e) {
      print(e.toString());
    }
  } else
    print('error: ${res.statusCode}');
  return list1;
}

Future<String> getAuthenticationToken() async {
  try {
    var authenticationToken = await SpotifySdk.getAuthenticationToken(
      clientId: _clientId,
      redirectUrl: _redirectUri,
      scope: _scope,
    );
    setStatus('Got a token: $authenticationToken');

    return authenticationToken;
  } on PlatformException catch (e) {
    setStatus(e.code, message: e.message);
    return Future.error('$e.code: $e.message');
  } on MissingPluginException {
    setStatus('not implemented');
    return Future.error('not implemented');
  }
}

void setStatus(String code, {String message = ''}) {
  var text = message.isEmpty ? '' : ' : $message';
  _logger.d('$code$text');
}
