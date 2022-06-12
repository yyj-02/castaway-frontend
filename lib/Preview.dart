import 'package:flutter/material.dart';
import 'PodcastView.dart';

class Previewpage extends StatefulWidget {
  const Previewpage({Key? key}) : super(key: key);

  @override
  State<Previewpage> createState() => _PreviewpageState();
}

class _PreviewpageState extends State<Previewpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Column(children: [
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
                              color: Color(0xffb257a84),
                            ))),
                  ),
                ],
              ),

              const Text("Like what you see?",
                  style: TextStyle(
                    color: Color(0xffb257a84),
                    fontSize: 35,
                  )),
              const Spacer(),
                  const Text("Click the card to start listening",
                      style: TextStyle(
                        color: Color(0xffb257a84),
                        fontSize: 15,
                      )),
                  const Spacer(),
              Card(
                color: const Color(0xffb257a84),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: InkWell(
                  onTap: () {Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return const podcastview();
                      }));
                  },
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: Column(
                      children: [
                        IconButton(
                          // width: MediaQuery.of(context).size.width,
                          // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          //
                          // decoration: const BoxDecoration(
                          //     color: Color(0xffb257a84),
                          //     borderRadius: BorderRadius.all(Radius.circular(18))),
                          icon: const Icon(Icons.access_alarm),
                          onPressed: () {},
                          // child: Text(
                          //   '$i',
                          //   style: const TextStyle(fontSize: 16.0),
                          // )
                        ),
                        const Text(
                          'IS this displaying',
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
            ]))));
  }
}
