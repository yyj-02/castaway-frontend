import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import "dart:io";
import 'ProfileDetails.dart' as profile;
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:multi_page_castaway/ProfileDetails.dart' as Profile;

// var add = "ws://35.213.151.122:3000/streamer";
var add = "ws://10.0.2.2:3000/streamer";

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}


class _LiveStreamPageState extends State<LiveStreamPage> {
  bool check = false;
  String pather = "";
  bool flag = true;
  late Stream<int> timerStream;
  late StreamSubscription<int> timerSubscription;
  String hoursStr = '00';
  String minutesStr = '00';
  String secondsStr = '00';
  late StreamController<int> streamController;
  late Timer timer;
  Duration timerInterval = const Duration(seconds: 1);
  int counter = 0;
  int newflag = 1;
  Icon fab = const Icon(Icons.mic, color: Colors.white);

  int fabIconNumber = 0;

  Stream<int> stopWatchStream() {
    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  // disconnect() async {
  //   socket.disconnect();
  // }
  //
  // socketdispose() async {
  //   socket.dispose();
  // }

  // emit() async {
  //   socket.emit("upload",
  //       File(pather).readAsBytesSync()); //just put the file in an array
  // }

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

  final myController = TextEditingController();
  final nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
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
                            if (fabIconNumber == 1 || fabIconNumber == 2) {
                              Navigator.pop(context);

                              setState(() {
                                hoursStr = '00';
                                minutesStr = '00';
                                secondsStr = '00';
                              });
                              newflag = 0;
                              stop();
                              //disconnect();
                              recorder.dispose();
                              // socketdispose();
                              dispose();
                              newflag = 4;
                              if (Profile.currlive != "") {
                                http.Response socketres = await http.delete(
                                  Uri.parse(
                                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/livestreams/${Profile
                                          .currlive}"),
                                  headers: {
                                    "idToken": Profile.myIdToken,
                                  },
                                );
                                var status = await jsonDecode(socketres.body);
                                print(status);
                                timerSubscription.cancel();
                              }

                            }else {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("← back",
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    ],
                  ),
                  const Spacer(),
                  const Text("Lets get started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      )),
                  const Spacer(),
                  Text(("$hoursStr:$minutesStr:$secondsStr"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      )),
                  const Spacer(),
                  const Text("Title",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        labelText: '',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(6.0)),
                  const Text("Description",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  const Padding(padding: EdgeInsets.all(5.0)),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: myController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        labelText: '',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(5.0)),

                  FloatingActionButton(
                    child: fab,
                    onPressed: () => setState(() async {
                      bool check = false;
                      if (fabIconNumber == 0) {
                        fab = const Icon(
                          Icons.mic_off,
                          color: Colors.white,
                        );

                        http.Response socketres = await http.post(
                            Uri.parse(
                                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/livestreams"),
                            headers: {
                              "idToken": Profile.myIdToken,
                            },
                            body: {
                              "title": nameController.text,
                              "description": myController.text,
                            });
                        if(socketres.statusCode != 200){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: const Text('Something went wrong try again'),
                                  actions: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(Colors.white),
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                              const Color(0xffb257a84)),
                                        ),
                                        child: const Text("ok",
                                            style: TextStyle(
                                              color: Colors.white,
                                            )),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ],
                                );
                              });
                        } else {
                          fabIconNumber = 1;
                          Profile.currlive =
                          await jsonDecode(socketres.body)['livestreamId'];
                          print(Profile.currlive);
                          IO.Socket socket = IO.io(add, <String, dynamic>{
                            "transports": ["websocket"],
                            "autoConnect": false,
                            "extraHeaders": {
                              "id-token": profile.myIdToken,
                              "livestream-id": await jsonDecode(
                                  socketres.body)['livestreamId'],
                              //hard coded as of now but supposed to get livestream id using the api
                            },
                          });
                          socket.on(
                              "connect_error", (error) =>
                          {print(error.toString())});
                          socket.onConnect((_) =>
                              () async {
                            print('connected!');

                          });

                          socket.on("success", (message) {
                            print(message);
                            this.check = true;

                          });
                          socket.on("error", (error) {
                            print(error);
                          });
                          socket.on('disconnect', (_) => print("disconnected"));
                          socket.connect();
                          await Future.delayed(const Duration(seconds: 5), (){});
                          if(this.check) {
                            timerStream = stopWatchStream();
                            timerSubscription =
                                timerStream.listen((int newTick) {
                                  setState(() {
                                    hoursStr = ((newTick / (60 * 60)) % 60)
                                        .floor()
                                        .toString()
                                        .padLeft(2, '0');
                                    minutesStr = ((newTick / 60) % 60)
                                        .floor()
                                        .toString()
                                        .padLeft(2, '0');
                                    secondsStr =
                                        (newTick % 60).floor()
                                            .toString()
                                            .padLeft(2, '0');
                                  });
                                });
                            recs() async {
                              if (newflag == 1) {
                                recorded();
                                await Future.delayed(const Duration(seconds: 4),
                                        () async {
                                      final path = await recorder.stop();
                                      final audiofile = File(path!);
                                      print(path);
                                      pather = path;
                                    });
                                socket.emit(
                                    "upload", File(pather).readAsBytesSync());
                              }
                              if (newflag == 4) {
                                socket.disconnect();
                                socket.dispose();
                              }
                            }

                            // Timer.periodic(const Duration(seconds: 5), (Timer t) => recorded());
                            Timer.periodic(
                                const Duration(seconds: 5), (Timer t) =>
                            {
                              recs()
                            });
                          }
                        }} else if (fabIconNumber == 2) {
                        newflag = 1;
                        fab = const Icon(Icons.mic_off, color: Colors.white);
                        fabIconNumber = 1;
                      } else {
                        fab = const Icon(Icons.mic, color: Colors.white);
                        fabIconNumber = 2;
                        newflag = 0;
                      }
                    }),
                  ),

                  // IconButton(
                  //   icon: const Icon(
                  //     Icons.mic,
                  //     size: 40.0,
                  //     color: Colors.white,
                  //   ),
                  //   color: Colors.white,
                  //   onPressed: () async {
                  //       connect();
                  //       timerStream = stopWatchStream();
                  //       timerSubscription = timerStream.listen((int newTick) {
                  //         setState(() {
                  //           hoursStr = ((newTick / (60 * 60)) % 60)
                  //               .floor()
                  //               .toString()
                  //               .padLeft(2, '0');
                  //           minutesStr = ((newTick / 60) % 60)
                  //               .floor()
                  //               .toString()
                  //               .padLeft(2, '0');
                  //           secondsStr =
                  //               (newTick % 60).floor().toString().padLeft(2, '0');
                  //         });
                  //       });
                  //       // Timer.periodic(const Duration(seconds: 5), (Timer t) => recorded());
                  //       Timer.periodic(
                  //           const Duration(seconds: 5), (Timer t) => {recs()});
                  //
                  //     }
                  //
                  //
                  // ),
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
                ])));
  }
}