import 'package:flutter/material.dart';
import 'Podcastplayer.dart';

class podcastview extends StatefulWidget {
  const podcastview({Key? key}) : super(key: key);

  @override
  State<podcastview> createState() => _podcastviewState();
}

class _podcastviewState extends State<podcastview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffb7BB9B9),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(15.0)),
                  Row(
                    children: [
                      SizedBox(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("<- Back",
                                style: TextStyle(
                                  color: Colors.white,
                                ))),
                      ),
                    ],
                  ),

                  const Text("You're listening to..",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      )),
                  const Spacer(),
                  const Spacer(),
                  // const Padding(padding: const EdgeInsets.all(30.0),),
                  SizedBox(
                    child: IconButton(
                      icon: const Icon(Icons.alarm),
                      iconSize: 100,
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                  const Text("The cons of a lunk Alarm",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  const Spacer(),
                  const podcastplayer(),
                  const Spacer(),
                ],
              )),
        ));
  }
}