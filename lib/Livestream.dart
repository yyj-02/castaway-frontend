import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({Key? key}) : super(key: key);

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
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
              const Text("You're Live",style: TextStyle(
                color: Colors.white,
                fontSize: 50,
              )),
              const Spacer(),
              Text((current),style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
              )),

              const Spacer(),
              const Icon(
                Icons.mic,
                size: 160.0,
                color: Colors.white,
              ),
              const Spacer(),
              const Text("Press mic icon to mute", style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
              const Spacer(),
              Row(
                children: const [
                  Spacer(),
                  Icon(
                    Icons.people_alt_outlined,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  Spacer(),
                  Icon(
                    Icons.stop_circle,
                    size: 140.0,
                    color: Colors.white,
                  ),
                  Spacer(),
                  Icon(
                    Icons.messenger_outline,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  Spacer(),
                ],
              ),
              const Spacer(),
            ])));
  }
}
