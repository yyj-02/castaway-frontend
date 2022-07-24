import 'package:flutter/material.dart';
import 'PodcastView.dart';
import 'ProfileDetails.dart' as profile;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SecondpagefromExplore.dart';

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
        resizeToAvoidBottomInset: false,
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
                            return const SecondPage(title: 'SecondPage');
                          }));
                        },
                        child: const Text("← back",
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
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
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
                          Colors.black12,
                          Colors.black26,
                          Colors.black38,
                          Colors.black45,
                          Colors.black54,
                          Colors.black87,
                          Colors.black,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.podcastdet['title'],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.podcastdet['description'],
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                                Text(
                                  widget.podcastdet['artistName'],
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                                Text(
                                  "Genres: ${widget.podcastdet['genres'].toString().substring(1, widget.podcastdet['genres'].toString().length - 1)}",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
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
                  http.Response response = await http.put(
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
                  http.Response response4 = await http
                      .post(uri4, body: {'idToken': profile.myIdToken});
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
                                  'This podcast has been added to your favourites'),
                              actions: [
                                ElevatedButton(
                                  child: const Text("Ok",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  onPressed: () {
                                    Navigator.pop(context);
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
                child: Text("Add to favourites".toUpperCase(),
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
