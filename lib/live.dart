import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ProfileDetails.dart' as profile;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:audioplayers/audioplayers.dart';

var add = "ws://10.0.2.2:3000/listener";

class LiveStream extends StatefulWidget {
  const LiveStream({Key? key}) : super(key: key);

  @override
  State<LiveStream> createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  AudioPlayer player = AudioPlayer();

  connect() async {
// this should be a variable
    IO.Socket socket = IO.io(add, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "extraHeaders": {
        "id-token": profile.myIdToken,
        "livestream-id": "yiqQ45RXdDYZemAA1RrS",
        //hard coded as of now but supposed to get livestream id using the api
      },
    });
    socket.on("connect_error", (error) => {print(error.toString())});
    socket.on('connect', (_) {
      print('connected!');
    });
    socket.on("success", (message) {
      print(message);
    });
    socket.on('disconnect', (_) => print("disconnected"));
    socket.on("error", (error) {
      print(error);
    });
    socket.on(
        "audio",
        (audioFile) => {
              player.play(BytesSource(audioFile)),
              player.getDuration()
              //print(audioFile)

// audio stream can be the continuous stream of audio files beign played in order
            });
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    DateTime datetime = (DateTime.now());
    String current = DateFormat.Hms().format(datetime);
    return SingleChildScrollView(
        child: SizedBox(
      width: 1000,
      height: 1000,
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            const Spacer(),
            const Spacer(),
            const Text("You're Listening",
                style: TextStyle(
                  color: Color(0xffb7bb9b9),
                  fontSize: 40,
                )),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.play_arrow,
                size: 40.0,
                color: Color(0xffb7bb9b9),
              ),
              color: Color(0xffb7bb9b9),
              onPressed: () {
                connect();
              },
            ),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
          ])),
    ));
  }
}
