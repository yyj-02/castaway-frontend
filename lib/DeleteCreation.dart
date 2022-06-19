import 'package:flutter/material.dart';
import 'PodcastFromCreate.dart';
import 'ProfileDetails.dart' as profile;
import 'dart:convert';
import 'package:http/http.dart' as http;
import "ViewCreations.dart";
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'UpdateDetails.dart';

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
    int pos = profile.myCreations.indexOf(widget.podcastdet);
    String name = widget.podcastdet['artistName'];
    print(name);
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
                          return podcastview(podcast: profile.myCreations[pos]);
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
              Row(
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffb257a84)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Color(0xffb257a84))))),
                    onPressed: () async {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1800,
                        maxHeight: 1800,
                      );
                      var pather = pickedFile?.path;
                      File img = File(pather!);

                      void uploadFileToServer(File imagePath) async {
                        var request = http.MultipartRequest(
                            "POST",
                            Uri.parse(
                                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/images"));
                        request.fields['idToken'] = profile.myIdToken;
                        request.files.add(http.MultipartFile(
                            'image',
                            File(pather).readAsBytes().asStream(),
                            File(pather).lengthSync(),
                            filename: pather.split("/").last,
                            contentType: MediaType('image', 'jpeg')));
                        var res = await request.send();
                        final respStr = await http.Response.fromStream(res);
                        String imageid =
                            (jsonDecode(respStr.body)['imageUploadId']);
                        imageID = imageid;
                        print(imageID);
                        final uri5 = Uri.parse(
                            "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts/${widget.podcastdet['podcastId']}/image");
                        http.Response response5 = await http.put(uri5, body: {
                          'idToken': profile.myIdToken,
                          'updatedImageUploadId': imageID
                        });
                        print(response5.body);
                        final uri2 = Uri.parse(
                            "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                        http.Response response2 = await http.get(
                          uri2,
                        );
                        profile.allPodcasts = await jsonDecode(response2.body);
                        final uri3 = Uri.parse(
                            "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/favorites");
                        http.Response response3 = await http
                            .post(uri3, body: {'idToken': profile.myIdToken});
                        //print(response3.body);
                        profile.favePodcasts = await jsonDecode(response3.body);
                        final uri6 = Uri.parse(
                            "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                        http.Response response6 = await http
                            .post(uri6, body: {'idToken': profile.myIdToken});
                        //print(response6.body);
                        profile.myCreations = await jsonDecode(response6.body);
                        print(profile.myCreations[pos]);

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  scrollable: true,
                                  title:
                                      const Text('Your image has been updated'),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Ok",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return DeleteCreationsPage(
                                              podcastdet:
                                                  profile.myCreations[pos]);
                                        }));
                                      },
                                    )
                                  ]);
                            });
                      }

                      uploadFileToServer(img);
                    },
                    child: Text("Update Image".toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffb257a84)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Color(0xffb257a84))))),
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      var path = result?.paths[0];
                      File audio = File(path!);
                      void uploadFileToServer(File imagePath) async {
                        var request = http.MultipartRequest(
                            "POST",
                            Uri.parse(
                                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/podcasts"));
                        request.fields['idToken'] = profile.myIdToken;
                        request.files.add(http.MultipartFile(
                            'podcast',
                            File(path).readAsBytes().asStream(),
                            File(path).lengthSync(),
                            filename: path.split("/").last,
                            contentType: MediaType('audio', 'mpeg')));
                        var res = await request.send();
                        final respStr = await http.Response.fromStream(res);
                        String podcastId =
                            (jsonDecode(respStr.body)['podcastUploadId']);
                        podcastID = podcastId;
                        final uri5 = Uri.parse(
                            "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts/${widget.podcastdet['podcastId']}/podcast");
                        http.Response response5 = await http.put(uri5, body: {
                          'idToken': profile.myIdToken,
                          'updatedPodcastUploadId': podcastID
                        });
                        print(response5.body);
                        final uri2 = Uri.parse(
                            "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                        http.Response response2 = await http.get(
                          uri2,
                        );
                        profile.allPodcasts = await jsonDecode(response2.body);
                        final uri3 = Uri.parse(
                            "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/favorites");
                        http.Response response3 = await http
                            .post(uri3, body: {'idToken': profile.myIdToken});
                        //print(response3.body);
                        profile.favePodcasts = await jsonDecode(response3.body);
                        final uri6 = Uri.parse(
                            "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                        http.Response response6 = await http
                            .post(uri6, body: {'idToken': profile.myIdToken});
                        //print(response6.body);
                        profile.myCreations = await jsonDecode(response6.body);
                        print(profile.myCreations[pos]);

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  scrollable: true,
                                  title:
                                      const Text('Your audio has been updated'),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text("Ok",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return DeleteCreationsPage(
                                              podcastdet:
                                                  profile.myCreations[pos]);
                                        }));
                                      },
                                    )
                                  ]);
                            });
                      }

                      uploadFileToServer(audio);
                    },
                    child: Text("Update Audio".toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffb257a84)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Color(0xffb257a84))))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UpdateDetailsPage(podcast: widget.podcastdet);
                      }));
                    },
                    child: Text("Update Details".toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
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
