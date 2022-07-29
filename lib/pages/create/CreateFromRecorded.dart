import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../../commons/profile.dart' as profile;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dio/dio.dart';
import 'SecondPagefromCreate.dart';

class CreateRecordedPage extends StatefulWidget {
  const CreateRecordedPage({Key? key}) : super(key: key);

  @override
  State<CreateRecordedPage> createState() => _CreateRecordedPageState();
}

class _CreateRecordedPageState extends State<CreateRecordedPage> {
  final myController = TextEditingController();
  final passController = TextEditingController();
  var imageID;
  var podcastID;

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
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              const Padding(padding: EdgeInsets.all(20.0)),
              Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(padding: EdgeInsets.all(7.0)),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (imageID != null) {
                                  print(imageID);
                                  final uri5 = Uri.parse(
                                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/images/$imageID/delete");
                                  http.Response response5 = await http.post(
                                      uri5,
                                      body: {'idToken': profile.myIdToken});
                                  print(response5.body);
                                }
                                if (podcastID != null) {
                                  final uri5 = Uri.parse(
                                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/podcasts/$podcastID/delete");
                                  http.Response response5 = await http.post(
                                      uri5,
                                      body: {'idToken': profile.myIdToken});
                                  print(response5.body);
                                }
                                Navigator.pop(context);
                              },
                              child: const Text("← back",
                                  style: TextStyle(
                                    color: Color(0xffb257a84),
                                  ))),
                        ],
                      ),
                      const Text("Something's Brewing",
                          style: TextStyle(
                            color: Color(0xffb257a84),
                            fontSize: 37,
                          )),
                    ]),
              ),
              const Padding(padding: EdgeInsets.all(7.0)),
              const Text("Upload Audio",
                  style: TextStyle(
                    color: Color(0xffb257a84),
                    fontSize: 23,
                  )),
              const Padding(padding: EdgeInsets.all(7.0)),
              Row(
                children: [
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
                        if (res.statusCode == 200) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: const Text(
                                      'Your audio file submission was a success.'),
                                  actions: [
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red),
                                          ),
                                          onPressed: () async {
                                            if (podcastID != null) {
                                              final uri5 = Uri.parse(
                                                  "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/podcasts/$podcastID/delete");
                                              http.Response response5 =
                                                  await http.post(uri5, body: {
                                                'idToken': profile.myIdToken
                                              });
                                              print(response5.body);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text("Cancel",
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color(0xffb257a84)),
                                            ),
                                            child: const Text("Ok",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            }),
                                      ],
                                    )
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: const Text(
                                      'Your audio file submission was not received please try again'),
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
                                        child: const Text("ok",
                                            style: TextStyle(
                                              color: Colors.white,
                                            )),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ],
                                );
                              });
                        }
                      }

                      uploadFileToServer(audio);
                      //add text controller data and send a post request to make a podcast
                    },
                    child: Text("Select audio".toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  const Spacer(),
                ],
              ),
              const Padding(padding: EdgeInsets.all(7.0)),
              const Text("Cover Photo",
                  style: TextStyle(
                    color: Color(0xffb257a84),
                    fontSize: 23,
                  )),
              const Padding(padding: EdgeInsets.all(7.0)),
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
                      if (res.statusCode == 200) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text(
                                    'Your image submission was a success'),
                                actions: [
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red),
                                        ),
                                        onPressed: () async {
                                          if (imageID != null) {
                                            print(imageID);
                                            final uri5 = Uri.parse(
                                                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/images/$imageID/delete");
                                            http.Response response5 = await http
                                                .post(uri5, body: {
                                              'idToken': profile.myIdToken
                                            });
                                            print(response5.body);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text("Cancel",
                                            style: TextStyle(
                                              color: Colors.white,
                                            )),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xffb257a84)),
                                          ),
                                          child: const Text("Ok",
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                  )
                                ],
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text(
                                    'Your image submission was not received please try again'),
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
                                      child: const Text("ok",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              );
                            });
                      }
                    }

                    uploadFileToServer(img);
                  },
                  child: Column(
                    children: const [
                      Icon(
                        Icons.photo,
                        size: 93.0,
                      ),
                      Text('Select image',
                          style: TextStyle(
                            fontSize: 15,
                          )),
                      Padding(padding: EdgeInsets.all(5.0)),
                    ],
                  )
                  // child: Text("Click to upload".toUpperCase(),
                  //     style: const TextStyle(color: Colors.white, fontSize: 14)),
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
                        minimumSize:
                            MaterialStateProperty.all(const Size(200, 40)),
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
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: const Text('Confirm podcast creation.'),
                              actions: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    ),
                                    const Spacer(),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color(0xffb257a84)),
                                        ),
                                        child: const Text("Confirm",
                                            style: TextStyle(
                                              color: Colors.white,
                                            )),
                                        onPressed: () async {
                                          if (imageID != null &&
                                              myController.text != null &&
                                              passController.text != null &&
                                              selected != null) {
                                            var data = {
                                              'idToken': profile.myIdToken,
                                              'podcastUploadId': podcastID,
                                              "imageUploadId": imageID,
                                              'title': myController.text,
                                              'description':
                                                  passController.text,
                                              'genres': selected,
                                              'public': true
                                            };
                                            Dio dio = Dio();
                                            Response response = await dio.post(
                                              "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts",
                                              options: Options(headers: {
                                                HttpHeaders.contentTypeHeader:
                                                    "application/json",
                                              }),
                                              data: jsonEncode(data),
                                            );
                                            print(response.data);
                                            final uri2 = Uri.parse(
                                                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                                            http.Response response2 =
                                                await http.get(
                                              uri2,
                                            );
                                            profile.allPodcasts =
                                                await jsonDecode(
                                                    response2.body);
                                            final uri5 = Uri.parse(
                                                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                                            http.Response response5 = await http
                                                .post(uri5, body: {
                                              'idToken': profile.myIdToken
                                            });
                                            print(response5.body);
                                            profile.myCreations =
                                                await jsonDecode(
                                                    response5.body);
                                            final uri4 = Uri.parse(
                                                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/info");
                                            http.Response response4 = await http
                                                .post(uri4, body: {
                                              'idToken': profile.myIdToken
                                            });
                                            print(response4.body);
                                            profile.email = await jsonDecode(
                                                response4.body)['email'];
                                            profile.displayName =
                                                await jsonDecode(response4
                                                    .body)['displayName'];
                                            profile.numCre = await jsonDecode(
                                                response4
                                                    .body)['numberOfCreations'];
                                            profile.numFav = await jsonDecode(
                                                response4
                                                    .body)['numberOfFavorites'];
                                            if (response.statusCode == 200) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        scrollable: true,
                                                        title: const Text(
                                                            'Success your podcast was uploaded'),
                                                        actions: [
                                                          ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                foregroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        const Color(
                                                                            0xffb257a84)),
                                                              ),
                                                              child: const Text(
                                                                  "Ok",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) {
                                                                  return const SecondPageC(
                                                                      title:
                                                                          'SecondPage');
                                                                }));
                                                              })
                                                        ]);
                                                  });
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        scrollable: true,
                                                        title: const Text(
                                                            'Error your podcast was not uploaded try again'),
                                                        actions: [
                                                          ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                foregroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        const Color(
                                                                            0xffb257a84)),
                                                              ),
                                                              child: const Text(
                                                                  "Ok",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              })
                                                        ]);
                                                  });
                                            }
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      scrollable: true,
                                                      title: const Text(
                                                          'Error your podcast was not uploaded try again'),
                                                      actions: [
                                                        ElevatedButton(
                                                            style: ButtonStyle(
                                                              foregroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .white),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      const Color(
                                                                          0xffb257a84)),
                                                            ),
                                                            child: const Text(
                                                                "Ok",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            onPressed:
                                                                () async {
                                                              if (podcastID !=
                                                                  null) {
                                                                final uri5 =
                                                                    Uri.parse(
                                                                        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/podcasts/$podcastID/delete");
                                                                http.Response
                                                                    response5 =
                                                                    await http.post(
                                                                        uri5,
                                                                        body: {
                                                                      'idToken':
                                                                          profile
                                                                              .myIdToken
                                                                    });
                                                                print(response5
                                                                    .body);
                                                              }
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                return const SecondPageC(
                                                                    title:
                                                                        'SecondPage');
                                                              }));
                                                            })
                                                      ]);
                                                });
                                          }
                                        }),
                                  ],
                                )
                              ],
                            );
                          });
                      //add text controller data and send a post request to make a podcast
                    },
                    child: Text("PUBLISH".toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const Spacer(),
                ],
              ),
              const Padding(padding: EdgeInsets.all(5.0)),
            ]),
          ),
        ),
      ),
    );
  }
}
