import 'package:flutter/material.dart';
import 'PodcastView.dart';

class Previewpage extends StatefulWidget {
  final podcastdet;

  const Previewpage({Key? key, required this.podcastdet}) : super(key: key);

  @override
  State<Previewpage> createState() => _PreviewpageState();
}

class _PreviewpageState extends State<Previewpage> {
  @override
  Widget build(BuildContext context) {
    String name = widget.podcastdet['title'];
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
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.podcastdet['imgUrl']),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return podcastview(podcast: widget.podcastdet);
                      }));
                    },
                    child: SizedBox(
                      width: 300,
                      height: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.podcastdet['title'],
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            widget.podcastdet['description'],
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            widget.podcastdet['artistName'],
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
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
