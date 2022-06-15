import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'ProfileDetails.dart' as profile;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:dio/dio.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
      child: Column(children: [
        const Padding(padding: EdgeInsets.all(35.0)),
        Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("Something's Brewing",
                    style: TextStyle(
                      color: Color(0xffb257a84),
                      fontSize: 37,
                    )),
              ]),
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
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xffb257a84)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Color(0xffb257a84))))),
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
                String imageid = (jsonDecode(respStr.body)['imageUploadId']);
                imageID = imageid;
                if (res.statusCode == 200) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text('Your image submission was a success'),
                          actions: [
                            ElevatedButton(
                                child: Text("ok",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        );
                      });
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text(
                              'Your image submission was not recieved please try again'),
                          actions: [
                            ElevatedButton(
                                child: Text("ok",
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

              // var map = new Map<dynamic, dynamic>();
              // map['idToken']=profile.myIdToken;
              // map['image'] = pickedFile;
              // http.Response response = await http.post(
              //   uri,
              //   body: map,
              // );
              // print(await jsonDecode(response.body)['imageUploadId']);
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
                  .map((String catagory) => MultiSelectItem(catagory, catagory))
                  .toList(),
              onConfirm: (values) {
                selected = values;
                print(selected);
              },
              // child: DropdownButtonFormField(
              //     items: categories.map((String category) {
              //       return DropdownMenuItem(
              //           value: category,
              //           child: Row(
              //             children: <Widget>[
              //               Text(category),
              //             ],
              //           ));
              //     }).toList(),
              //     onChanged: (newValue) {
              //       // do other stuff with _category
              //       // setState(() => _category = newValue);
              //     },
              //     // value: _category,
              //     decoration: InputDecoration(
              //       contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(18.0),
              //       ),
              //       filled: true,
              //       fillColor: Colors.white70,
              //     )),
            )),
        const Padding(padding: EdgeInsets.all(5.0)),
        Row(
          children: [
            Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xffb257a84)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Color(0xffb257a84))))),
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
                            title: Text(
                                'Your audio file submission was a success. Please click confirm to create your podcast'),
                            actions: [
                              ElevatedButton(
                                  child: Text("Confirm",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                  onPressed: () async {
                                    var data = {
                                      'idToken': profile.myIdToken,
                                      'podcastUploadId': podcastID,
                                      "imageUploadId": imageID,
                                      'title': myController.text,
                                      'description': passController.text,
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
                                    if (response.statusCode == 200) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                scrollable: true,
                                                title: Text(
                                                    'Success your podcast was uploaded'),
                                                actions: [
                                                  ElevatedButton(
                                                      child: Text("Ok",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      })
                                                ]);
                                          });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                scrollable: true,
                                                title: Text(
                                                    'Error your podcast was not uploaded try again'),
                                                actions: [
                                                  ElevatedButton(
                                                      child: Text("Ok",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      })
                                                ]);
                                          });
                                    }

                                    // final uri = Uri.parse(
                                    //     "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                                    // http.Response response = await post(
                                    //   uri,
                                    //   body:(data)
                                    // );
                                    // print(response.body);
                                  })
                            ],
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Text(
                                'Your audio file submission was not recieved please try again'),
                            actions: [
                              ElevatedButton(
                                  child: Text("ok",
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
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
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
    );
  }
}
