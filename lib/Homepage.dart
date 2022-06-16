import 'dart:convert';
import 'package:flutter/material.dart';
import 'Preview.dart';
import 'ProfileDetails.dart' as profile;
import 'package:http/http.dart' as http;

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  favesync() async {
    final uri3 = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/favorites");
    http.Response response3 =
        await http.post(uri3, body: {'idToken': profile.myIdToken});
    print(response3.body);
    profile.favePodcasts = await jsonDecode(response3.body);
  }

  @override
  Widget build(BuildContext context) {
    favesync();
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
            const Padding(padding: EdgeInsets.all(5.0)),
            GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: profile.favePodcasts.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return SizedBox(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(i['imgUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(18.0))),
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
                                      return Previewpage(podcastdet: i);
                                    }));
                                  },
                                  child: SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          i['title'],
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),

                                        Text(
                                          i['artistName'],
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        // Text(
                                        //   i['genres'] ,
                                        //   style: const TextStyle(fontSize: 16.0),
                                        // )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList())
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(children: [
            //           SizedBox(
            //               child: Column(children: [
            //             IconButton(
            //               icon: const Icon(Icons.access_alarm),
            //               iconSize: 100, onPressed: () {},
            //               // onPressed: () {
            //               //   Navigator.push(context,
            //               //       MaterialPageRoute(builder: (context) {
            //               //     return const podcastview();
            //               //   }));
            //               // },
            //             ),
            //             const Text("The cons of a lunk alarm"),
            //             const Text("Fitness . 1 hour . 4.9")
            //           ])),
            //           const Padding(padding: EdgeInsets.all(15.0)),
            //           SizedBox(
            //             child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Column(children: [
            //                   IconButton(
            //                     icon: const Icon(
            //                         Icons.phone_bluetooth_speaker_outlined),
            //                     iconSize: 100,
            //                     onPressed: () {},
            //                   ),
            //                   const Text("What is phone \nbluetooth"),
            //                   const Text("Tech . 2 hours . 4.6")
            //                 ])),
            //           )
            //         ]),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(children: [
            //           SizedBox(
            //               child: Column(children: [
            //             IconButton(
            //               icon: const Icon(Icons.access_alarm),
            //               iconSize: 100, onPressed: () {},
            //               // onPressed: () {
            //               //   Navigator.push(context,
            //               //       MaterialPageRoute(builder: (context) {
            //               //     return const podcastview();
            //               //   }));
            //               // },
            //             ),
            //             const Text("The cons of a lunk alarm"),
            //             const Text("Fitness . 1 hour . 4.9")
            //           ])),
            //           const Padding(padding: EdgeInsets.all(15.0)),
            //           SizedBox(
            //             child: Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Column(children: [
            //                   IconButton(
            //                     icon: const Icon(
            //                         Icons.phone_bluetooth_speaker_outlined),
            //                     iconSize: 100,
            //                     onPressed: () {},
            //                   ),
            //                   const Text("What is phone \nbluetooth"),
            //                   const Text("Tech . 2 hours . 4.6")
            //                 ])),
            //           )
            //         ]),
            //       ),
            //     ])
          ])
    ]);
  }
}
