import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "dart:io";
import 'ProfileDetails.dart' as profile;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;


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

    // to emit audio I think you do socket.emit("audio", audioPackets), hence you need to export the socket in a separate dart file
    socket.connect();

  }
  disconnect() async {
    socket.disconnect();
  }

  socketdispose() async {
    socket.dispose();
  }

  emit() async{
    // await Future.delayed(const Duration(seconds: 5),
    //         () {}); // so think of a way to export this socket and wait a while after it connects to send packages
    socket.emit(
        "upload",
        File("/data/user/0/com.example.multi_page_castaway/cache/audio").readAsBytesSync()
    ); //just put the file in an array
  }
  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted){
      print("Mic available");
    }
    if (status != PermissionStatus.granted){
      throw "Mic not available";
    }
    await recorder.openRecorder();
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
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    final path = await recorder.stopRecorder();
    final audiofile = File(path!);
    print("Recorded audio $audiofile");


  }
  recs() async {
    recorded();
    await Future.delayed(const Duration(seconds: 4), () {stop();});
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
                  Timer.periodic(const Duration(seconds: 5), (Timer t) => {
                    recs()
                  }
                  );

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
            ])));
  }
}
