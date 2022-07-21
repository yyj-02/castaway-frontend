import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "dart:io";
import 'ProfileDetails.dart' as profile;
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:record/record.dart';

var add = "ws://10.0.2.2:3000/streamer";

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

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

class _LiveStreamPageState extends State<LiveStreamPage> {
  String pather = "";

  connect() async {
    socket.on("connect_error", (error) => {print(error.toString())});
    socket.onConnect((_) => () async {
          print('connected!');
        });

    socket.on("success", (message) {
      print(message);
    });
    socket.on("error", (error) {
      print(error);
    });
    socket.on('disconnect', (_) => print("disconnected"));
    socket.connect();
  }

  disconnect() async {
    socket.disconnect();
  }

  socketdispose() async {
    socket.dispose();
  }

  emit() async {
    socket.emit("upload",
        File(pather).readAsBytesSync()); //just put the file in an array
  }

  final recorder = Record();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      print("Mic available");
    }
    if (status != PermissionStatus.granted) {
      throw "Mic not available";
    }
  }

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future recorded() async {
    await recorder.start(
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
        samplingRate: 44100);
  }

  Future stop() async {
    final path = await recorder.stop();
    final audiofile = File(path!);
    print(path);
    pather = path;
  }

  recs() async {
    recorded();
    await Future.delayed(const Duration(seconds: 4), () {
      stop();
    });
    emit();
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
              const Text("You're Live",
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
                onPressed: () async {
                  connect();
                  // Timer.periodic(const Duration(seconds: 5), (Timer t) => recorded());
                  Timer.periodic(
                      const Duration(seconds: 5), (Timer t) => {recs()});
                },
              ),
              const Spacer(),
              const Text("Press mic icon to record",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
            ]
            )
        )
    );
  }
}
