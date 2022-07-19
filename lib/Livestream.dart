import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "dart:io";
import 'ProfileDetails.dart' as profile;
import 'package:record/record.dart';
import 'Recorder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

var add =  "ws://10.0.2.2:3000/streamer";

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  connect() async {
    http.Response response4 = await http
        .get(Uri.parse("http://10.0.2.2:8080")); // this should be a variable
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
    socket.on('disconnect', (_) => print("disconnected"));
    socket.emit("upload",'/data/user/0/com.example.multi_page_castaway/cache/audio');
    // to emit audio I think you do socket.emit("audio", audioPackets), hence you need to export the socket in a separate dart file
    socket.connect();
    socket.emit("upload",'/data/user/0/com.example.multi_page_castaway/cache/audio');
    // socket.emit("audio", )
  }

  @override
  Widget build(BuildContext context) {
    connect();
    final record = Record();
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
                    icon: Icon(
                      Icons.mic,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return AudioRecorder();
                      }));
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