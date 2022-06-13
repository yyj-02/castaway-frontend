import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(padding: EdgeInsets.all(35.0)),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Only for you",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 40,
                )),
            const Padding(padding: EdgeInsets.all(20.0)),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      SizedBox(
                          child: Column(children: [
                        IconButton(
                          icon: const Icon(Icons.access_alarm),
                          iconSize: 100, onPressed: () {},
                          // onPressed: () {
                          //   Navigator.push(context,
                          //       MaterialPageRoute(builder: (context) {
                          //     return const podcastview();
                          //   }));
                          // },
                        ),
                        const Text("The cons of a lunk alarm"),
                        const Text("Fitness . 1 hour . 4.9")
                      ])),
                      const Padding(padding: EdgeInsets.all(15.0)),
                      SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.phone_bluetooth_speaker_outlined),
                                iconSize: 100,
                                onPressed: () {},
                              ),
                              const Text("What is phone \nbluetooth"),
                              const Text("Tech . 2 hours . 4.6")
                            ])),
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      SizedBox(
                          child: Column(children: [
                        IconButton(
                          icon: const Icon(Icons.access_alarm),
                          iconSize: 100, onPressed: () {},
                          // onPressed: () {
                          //   Navigator.push(context,
                          //       MaterialPageRoute(builder: (context) {
                          //     return const podcastview();
                          //   }));
                          // },
                        ),
                        const Text("The cons of a lunk alarm"),
                        const Text("Fitness . 1 hour . 4.9")
                      ])),
                      const Padding(padding: EdgeInsets.all(15.0)),
                      SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.phone_bluetooth_speaker_outlined),
                                iconSize: 100,
                                onPressed: () {},
                              ),
                              const Text("What is phone \nbluetooth"),
                              const Text("Tech . 2 hours . 4.6")
                            ])),
                      )
                    ]),
                  ),
                ])
          ])
    ]);
  }
}
