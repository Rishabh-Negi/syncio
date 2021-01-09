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
  bool _connected = false;
  bool _loading = false;
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;

          if (snapshot.data != null) {
            _connected = snapshot.data.connected;
          }

          return Scaffold(
            appBar: AppBar(
              actions: [
                _connected
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
            body: _body(context),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: const Icon(Icons.settings_remote),
                  onPressed: connectToSpotifyRemote,
                ),
                FlatButton(
                  child: const Text('get auth token '),
                  onPressed: getAuthenticationToken,
                ),
              ],
            ),
            const Divider(),
            const Text('Player State', style: TextStyle(fontSize: 16)),
            _connected
                ? playerStateWidget()
                : const Center(
                    child: Text('Not connected'),
                  ),
            const Divider(),
            const Text('Player Context', style: TextStyle(fontSize: 16)),
            _connected
                ? playerContextWidget()
                : const Center(
                    child: Text('Not connected'),
                  ),
            
          ],
        ),
        _loading
            ? Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()))
            : const SizedBox(),
      ],
    );
  }

   Widget playerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      initialData: PlayerState(
        null,
        1,
        1,
        null,
        null,
        isPaused: false,
      ),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        if (snapshot.data != null && snapshot.data.track != null) {
          var playerState = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('''
                    ${playerState.track.name} 
                    by ${playerState.track.artist.name} 
                    from the album ${playerState.track.album.name} '''),
              Text('Speed: ${playerState.playbackSpeed}'),
              Text(
                  'Progress: ${playerState.playbackPosition}ms/${playerState.track.duration}ms'),
              Text('IsPaused: ${playerState.isPaused}'),
              Text('Is Shuffling: ${playerState.playbackOptions.isShuffling}'),
              Text('RepeatMode: ${playerState.playbackOptions.repeatMode}'),
              Text('Image URI: ${playerState.track.imageUri.raw}'),
              Text('''
                  Is episode? ${playerState.track.isEpisode}. 
                  Is podcast?: ${playerState.track.isPodcast}'''),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text(
                    'Set Shuffle and Repeat',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Repeat Mode:',
                      ),
                      DropdownButton<RepeatMode>(
                        value: RepeatMode.values[
                            playerState.playbackOptions.repeatMode.index],
                        items: [
                          DropdownMenuItem(
                            value: RepeatMode.off,
                            child: Text('off'),
                          ),
                          DropdownMenuItem(
                            value: RepeatMode.track,
                            child: Text('track'),
                          ),
                          DropdownMenuItem(
                            value: RepeatMode.context,
                            child: Text('context'),
                          ),
                        ],
                        onChanged: setRepeatMode,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Set shuffle: '),
                      Switch.adaptive(
                        value: playerState.playbackOptions.isShuffling,
                        onChanged: (bool shuffle) => setShuffle(
                          shuffle: shuffle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('Not connected'),
          );
        }
      },
    );
  }

  Widget playerContextWidget() {
    return StreamBuilder<PlayerContext>(
      stream: SpotifySdk.subscribePlayerContext(),
      initialData: PlayerContext('', '', '', ''),
      builder: (BuildContext context, AsyncSnapshot<PlayerContext> snapshot) {
        if (snapshot.data != null && snapshot.data.uri != '') {
          var playerContext = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Title: ${playerContext.title}'),
              Text('Subtitle: ${playerContext.subtitle}'),
              Text('Type: ${playerContext.type}'),
              Text('Uri: ${playerContext.uri}'),
            ],
          );
        } else {
          return const Center(
            child: Text('Not connected'),
          );
        }
      },
    );
  }

  // Widget spotifyImageWidget() {
  //   return FutureBuilder(
  //       future: SpotifySdk.getImage(
  //         imageUri: ImageUri(
  //             'spotify:image:ab67616d0000b2736b4f6358fbf795b568e7952d'),
  //         dimension: ImageDimension.large,
  //       ),
  //       builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
  //         if (snapshot.hasData) {
  //           return Image.memory(snapshot.data);
  //         } else if (snapshot.hasError) {
  //           setStatus(snapshot.error.toString());
  //           return SizedBox(
  //             width: ImageDimension.large.value.toDouble(),
  //             height: ImageDimension.large.value.toDouble(),
  //             child: const Center(child: Text('Error getting image')),
  //           );
  //         } else {
  //           return SizedBox(
  //             width: ImageDimension.large.value.toDouble(),
  //             height: ImageDimension.large.value.toDouble(),
  //             child: const Center(child: Text('Getting image...')),
  //           );
  //         }
  //       });
  // }

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: _clientId,
          redirectUrl: _redirectUri);
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<String> getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: _clientId,
          redirectUrl: _redirectUri,
          scope: _scope,);
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

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  // Future getCrossfadeState() async {
  //   try {
  //     var crossfadeStateValue = await SpotifySdk.getCrossFadeState();
  //     setState(() {
  //       crossfadeState = crossfadeStateValue;
  //     });
  //   } on PlatformException catch (e) {
  //     setStatus(e.code, message: e.message);
  //   } on MissingPluginException {
  //     setStatus('not implemented');
  //   }
  // }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setShuffle({bool shuffle}) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String message = ''}) {
    var text = message.isEmpty ? '' : ' : $message';
    _logger.d('$code$text');
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
