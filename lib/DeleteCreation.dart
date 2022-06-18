import 'package:flutter/material.dart';
import 'PodcastView.dart';
import 'ProfileDetails.dart' as profile;
import 'dart:convert';
import 'package:http/http.dart' as http;
import "ViewCreations.dart";
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dio/dio.dart';

class DeleteCreationsPage extends StatefulWidget {
  final podcastdet;

  const DeleteCreationsPage({Key? key, required this.podcastdet})
      : super(key: key);

  @override
  State<DeleteCreationsPage> createState() => _DeleteCreationsPageState();
}

class _DeleteCreationsPageState extends State<DeleteCreationsPage> {
  var imageID;
  var podcastID;

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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ViewCreationsPage();
                          }));
                        },
                        child: const Text("<- Back",
                            style: TextStyle(
                              color: Color(0xffb257a84),
                            ))),
                  ),
                ],
              ),
              const Text("This is all you",
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
                  };
                  final uri = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts/${widget.podcastdet["podcastId"]}/delete");
                  http.Response response = await http.post(
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
                  final uri5 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                  http.Response response5 = await http
                      .post(uri5, body: {'idToken': profile.myIdToken});
                  print(response5.body);
                  profile.myCreations = await jsonDecode(response5.body);
                  final uri2 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                  http.Response response2 = await http.get(
                    uri2,
                  );
                  profile.allPodcasts = await jsonDecode(response2.body);
                  if (response.statusCode == 200) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              scrollable: true,
                              title:
                                  const Text('This podcast has been deleted'),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Ok",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const ViewCreationsPage();
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
                child: Text("Update Audio".toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
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
                  };
                  final uri = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts/${widget.podcastdet["podcastId"]}/delete");
                  http.Response response = await http.post(
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
                  final uri5 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                  http.Response response5 = await http
                      .post(uri5, body: {'idToken': profile.myIdToken});
                  print(response5.body);
                  profile.myCreations = await jsonDecode(response5.body);
                  final uri2 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                  http.Response response2 = await http.get(
                    uri2,
                  );
                  profile.allPodcasts = await jsonDecode(response2.body);
                  if (response.statusCode == 200) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              scrollable: true,
                              title:
                                  const Text('This podcast has been deleted'),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Ok",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const ViewCreationsPage();
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
                child: Text("Update image".toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
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
                  };
                  final uri = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts/${widget.podcastdet["podcastId"]}/delete");
                  http.Response response = await http.post(
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
                  final uri5 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                  http.Response response5 = await http
                      .post(uri5, body: {'idToken': profile.myIdToken});
                  print(response5.body);
                  profile.myCreations = await jsonDecode(response5.body);
                  final uri2 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                  http.Response response2 = await http.get(
                    uri2,
                  );
                  profile.allPodcasts = await jsonDecode(response2.body);
                  if (response.statusCode == 200) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              scrollable: true,
                              title:
                                  const Text('This podcast has been deleted'),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Ok",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const ViewCreationsPage();
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
                child: Text("Delete Podcast".toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
              )
            ]))));
  }
}
