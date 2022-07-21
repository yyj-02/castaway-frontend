//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ProfileDetails.dart' as profile;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:audioplayers/audioplayers.dart';

var add =  "ws://10.0.2.2:3000/listener";

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
        "livestream-id":
        "yiqQ45RXdDYZemAA1RrS", //hard coded as of now but supposed to get livestream id using the api
      },
    });
    socket.on("connect_error", (error) => {print(error.toString())});
    socket.on('connect', (_) {
      print('connected!');
    });
    socket.on("success", (message) {print(message);});
    socket.on('disconnect', (_) => print("disconnected"));
    socket.on("error", (error) {print(error);});
    socket.on("audio", (audioFile) => {
      player.play(BytesSource(audioFile)),player.getDuration()
      //print(audioFile)

// audio stream can be the continuous stream of audio files beign played in order
    });
    // to emit audio I think you do socket.emit("audio", audioPackets), hence you need to export the socket in a separate dart file
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    DateTime datetime = (DateTime.now());
    String current = DateFormat.Hms().format(datetime);
    return Scaffold(
        backgroundColor: const Color(0xffb7bb9b9),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Spacer(),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text("<- Back",
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    ],
                  ),
                  const Spacer(),
                  const Text("You're Listening",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      )),
                  const Spacer(),
                  Text((current),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      )),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.mic,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      connect();
                    },
                  ),
                  const Spacer(),
                  const Text("Press mic icon to record",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  const Spacer(),
                  // Row(
                  //   children: const [
                  //     Spacer(),
                  //     Icon(
                  //       Icons.people_alt_outlined,
                  //       size: 40.0,
                  //       color: Colors.white,
                  //     ),
                  //     Spacer(),
                  //     Icon(
                  //       Icons.stop_circle,
                  //       size: 140.0,
                  //       color: Colors.white,
                  //     ),
                  //     Spacer(),
                  //     Icon(
                  //       Icons.messenger_outline,
                  //       size: 40.0,
                  //       color: Colors.white,
                  //     ),
                  //     Spacer(),
                  //   ],
                  // ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                ]
            )
        )
    );
  }
}