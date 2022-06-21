import 'package:flutter/material.dart';
import 'FromFavePod.dart';
import 'ProfileDetails.dart' as profile;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SecondPage.dart';

class Previewpage extends StatefulWidget {
  final podcastdet;

  const Previewpage({Key? key, required this.podcastdet}) : super(key: key);

  @override
  State<Previewpage> createState() => _PreviewpageState();
}

class _PreviewpageState extends State<Previewpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 30.0),
            child: Center(
                child: Column(children: [
              const Padding(padding: EdgeInsets.all(15.0)),
              Row(
                children: [
                  SizedBox(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const SecondPage(title: 'SecondPage');
                          }));
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
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.podcastdet['imgUrl']),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0))),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.white10,
                          Colors.white24,
                          Colors.white38,
                          Colors.white54,
                          Colors.white60,
                          Colors.white70,
                          Colors.white,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
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
                                style: const TextStyle(fontSize: 18.0),
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
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffb257a84)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side:
                                const BorderSide(color: Color(0xffb257a84))))),
                onPressed: () async {
                  var data = {
                    'idToken': profile.myIdToken,
                    'podcastId': widget.podcastdet["podcastId"],
                  };
                  final uri = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/favorites");
                  http.Response response = await http.delete(
                    uri,
                    body: data,
                  );
                  final uri3 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/favorites");
                  http.Response response3 = await http
                      .post(uri3, body: {'idToken': profile.myIdToken});
                  print(response3.body);
                  profile.favePodcasts = await jsonDecode(response3.body);
                  print(jsonDecode(response.body)['message']);
                  final uri4 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/info");
                  http.Response response4 =
                  await http.post(uri4, body: {'idToken': profile.myIdToken});
                  print(response4.body);
                  profile.email = await jsonDecode(response4.body)['email'];
                  profile.displayName =
                  await jsonDecode(response4.body)['displayName'];
                  profile.numCre =
                  await jsonDecode(response4.body)['numberOfCreations'];
                  profile.numFav =
                  await jsonDecode(response4.body)['numberOfFavorites'];
                  if (response.statusCode == 200) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              scrollable: true,
                              title: const Text(
                                  'This podcast has been deleted from your favourites'),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Ok",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const SecondPage(
                                          title: 'SecondPage');
                                    }));
                                  },
                                )
                              ]);
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              scrollable: true,
                              title: const Text('Error please try again later'),
                              actions: [
                                ElevatedButton(
                                  child: const Text("OK",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ]);
                        });
                  }
                },
                child: Text("Delete from favourites".toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              const Spacer(),
            ]))));
  }
}
