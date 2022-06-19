import 'package:flutter/material.dart';
import 'Fromfaveplayer.dart';
import 'ProfileDetails.dart' as profile;
import 'FavPreview.dart';

class podcastview extends StatefulWidget {
  final podcast;

  const podcastview({Key? key, required this.podcast}) : super(key: key);

  @override
  State<podcastview> createState() => _podcastviewState();
}

class _podcastviewState extends State<podcastview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffb7BB9B9),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
          child: Center(
              child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(15.0)),
              Row(
                children: [
                  SizedBox(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Previewpage(podcastdet: widget.podcast);
                          }));
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
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.podcast['imgUrl']),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
                child: const SizedBox(
                  width: 300,
                  height: 350,
                ),
              ),
              const Spacer(),
              Text(widget.podcast['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  )),
              const Spacer(),
              podcastplayer(
                  id: widget.podcast['podcastId'],
                  pos: profile.favePodcasts.indexOf(widget.podcast)),
              const Spacer(),
            ],
          )),
        ));
  }
}
