import 'dart:convert';
import 'dart:io';
import 'ProfileDetails.dart' as profile;
import 'package:flutter/material.dart';
import "DeleteCreation.dart";
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dio/dio.dart';

class UpdateDetailsPage extends StatefulWidget {
  final podcast;

  const UpdateDetailsPage({Key? key, required this.podcast}) : super(key: key);

  @override
  State<UpdateDetailsPage> createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  final myController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    passController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int pos = profile.myCreations.indexOf(widget.podcast);
    List<String>? categories = [
      "Classic",
      "NFT",
      "Music",
      "Gaming",
      "Tech",
      "Sports",
      "Maternity",
      "Self-Help",
      "Others"
    ];
    var selected;
    return Center(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            const Padding(padding: EdgeInsets.all(35.0)),
            Form(
              key: _formKey,
              child: Column(children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text("← back",
                            style: TextStyle(
                              color: Color(0xffb257a84),
                            ))),
                  ],
                ),
                const Text("Update Details",
                    style: TextStyle(
                      color: Color(0xffb257a84),
                      fontSize: 37,
                    )),
              ]),
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            const Text("Title",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 23,
                )),
            const Padding(padding: EdgeInsets.all(5.0)),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: myController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  labelText: '',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            const Text("Description",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 23,
                )),
            const Padding(padding: EdgeInsets.all(5.0)),
            SizedBox(
              width: 300,
              child: TextFormField(
                controller: passController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  labelText: '',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            const Text("Genre",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 23,
                )),
            const Padding(padding: EdgeInsets.all(5.0)),
            SizedBox(
                width: 300,
                child: MultiSelectDialogField(
                  items: categories
                      .map((String catagory) =>
                          MultiSelectItem(catagory, catagory))
                      .toList(),
                  onConfirm: (values) {
                    selected = values;
                    print(selected);
                  },
                )),
            const Padding(padding: EdgeInsets.all(5.0)),
            Row(
              children: [
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
                              side: const BorderSide(
                                  color: Color(0xffb257a84))))),
                  onPressed: () async {
                    var data = {
                      'idToken': profile.myIdToken,
                      'title': myController.text,
                      'description': passController.text,
                      'genres': selected,
                      'public': true
                    };

                    Dio dio = Dio();
                    Response response = await dio.put(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts/${widget.podcast['podcastId']}",
                      options: Options(headers: {
                        HttpHeaders.contentTypeHeader: "application/json",
                      }),
                      data: jsonEncode(data),
                    );
                    print(response.data);
                    final uri2 = Uri.parse(
                        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                    http.Response response2 = await http.get(
                      uri2,
                    );
                    profile.allPodcasts = await jsonDecode(response2.body);
                    final uri5 = Uri.parse(
                        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                    http.Response response5 = await http
                        .post(uri5, body: {'idToken': profile.myIdToken});
                    print(response5.body);
                    profile.myCreations = await jsonDecode(response5.body);
                    if (response.statusCode == 200) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                scrollable: true,
                                title: const Text('Details Updated'),
                                actions: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xffb257a84)),
                                      ),
                                      child: const Text("Ok",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      onPressed: () {
                                        print(profile.myCreations[pos]);
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return DeleteCreationsPage(
                                              podcastdet:
                                                  profile.myCreations[pos]);
                                        }));
                                      })
                                ]);
                          });
                    }
                  },
                  child: Text("Update Details".toUpperCase(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                ),
                const Spacer(),
                // ElevatedButton(
                //   style: ButtonStyle(
                //       foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                //       backgroundColor:
                //       MaterialStateProperty.all<Color>(const Color(0xffb257a84)),
                //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //           RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(18.0),
                //               side: const BorderSide(color: Color(0xffb257a84))))),
                //   onPressed: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (context) {
                //       return LiveStreamPage();
                //     }));
                //   },
                //   child: Text("      Go live      ".toUpperCase(),
                //       style: const TextStyle(color: Colors.white, fontSize: 14)),
                // ),
                // Spacer(),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
