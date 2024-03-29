import 'package:flutter/material.dart';
import '../../commons/profile.dart' as profile;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:audioplayers/audioplayers.dart';

// var add = "ws://10.0.2.2:3000/listener";
var add = "ws://35.213.151.122:3000/listener";

class LiveStream extends StatefulWidget {
  final livename;
  final livedes;
  final liveid;

  const LiveStream(
      {Key? key,
      required this.livename,
      required this.livedes,
      required this.liveid})
      : super(key: key);

  @override
  State<LiveStream> createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  AudioPlayer player = AudioPlayer();
  Icon fab = const Icon(Icons.play_arrow, color: Colors.white);

  int fabIconNumber = 0;
  bool check = false;

  IO.Socket socket = IO.io(add, <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    "extraHeaders": {
      "id-token": profile.myIdToken,
      "livestream-id": profile.viewlive,
      //hard coded as of now but supposed to get livestream id using the api
    },
  });

  connect() async {
// this should be a variable

    socket.on("connect_error", (error) => {print(error.toString())});
    socket.on(
      'connect',
      (_) => setState(() {
        fab = const Icon(Icons.stop, color: Colors.white);
        fabIconNumber = 1;
        print("connected");
      }),
    );
    socket.on("success", (message) {
      print(message);
      this.check = true;
    });
    socket.on(
      'disconnect',
      (_) => setState(() {
        fab = const Icon(Icons.play_arrow, color: Colors.white);
        fabIconNumber = 0;
        print("disconnected");
      }),
    );
    socket.on("error", (error) {
      print(error);
    });
    socket.on(
        "audio",
        (audioFile) => {
              player.play(BytesSource(audioFile))

// audio stream can be the continuous stream of audio files beign played in order
            });
    socket.connect();
  }

  disconnect() {
    socket.disconnect();
  }

  dispose() {
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SizedBox(
      width: 1000,
      height: 1000,
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            const Spacer(),
            Row(
              children: [
                TextButton(
                    onPressed: () async {
                      disconnect();
                      dispose();
                      super.dispose();
                      Navigator.pop(context);
                    },
                    child: const Text("← back",
                        style: TextStyle(
                          color: Color(0xffb7bb9b9),
                        ))),
                const Spacer(),
              ],
            ),
            const Spacer(),
            const Text("You're Listening to",
                style: TextStyle(
                  color: Color(0xffb7bb9b9),
                  fontSize: 40,
                )),
            const Spacer(),
            Text("${widget.livename}",
                style: TextStyle(
                  color: Color(0xffb7bb9b9),
                  fontSize: 30,
                )),
            const Spacer(),
            Text("${widget.livedes}",
                style: TextStyle(
                  color: Color(0xffb7bb9b9),
                  fontSize: 15,
                )),
            const Spacer(),
            FloatingActionButton(
              child: fab,
              onPressed: () => setState(() {
                if (fabIconNumber == 0) {
                  connect();
                } else {
                  player.pause();
                  disconnect();
                  dispose();
                }
              }),
            ),
            const Spacer(),
            const Spacer(),
            const Spacer(),
            const Spacer(),
          ])),
    )));
  }
}
