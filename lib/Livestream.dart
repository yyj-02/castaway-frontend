import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io/socket_io.dart';
import 'package:record/record.dart';
import 'Recorder.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  connect() {
    var io = new Server();
    var nsp = io.of('localhost:8080');
    nsp.on('connection', (client) {
      print('connection /some');
      client.on('msg', (data) {
        print('data from /some => $data');
        client.emit('fromServer', "ok 2");
      });
    });
    io.on('connection', (client) {
      print('connection default namespace');
      client.on('msg', (data) {
        print('data from default => $data');
        client.emit('fromServer', "ok");
      });
    });
    io.listen(8080);
  }

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  connect() {
    var io = new Server();
    var nsp = io.of('localhost:8080/streamer');
    nsp.on('connection', (client) {
      print('connection /some');
      client.on('msg', (data) {
        print('data from /some => $data');
        client.emit('fromServer', "ok 2");
      });
    });
    io.on('connection', (client) {
      print('connection default namespace');
      client.on('msg', (data) {
        print('data from default => $data');
        client.emit('fromServer', "ok");
      });
    });
    io.listen(8080);
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
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
