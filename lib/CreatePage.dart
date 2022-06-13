import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'ProfileDetails.dart' as profile;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
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
              final pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              var pather = pickedFile?.path;
              print(pather);
              File img = File(pather!);
              print(img.runtimeType);
              Image finale = Image.file(img);

              void uploadFileToServer(File imagePath) async {
                var request = new http.MultipartRequest(
                    "POST",
                    Uri.parse(
                        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/images"));
                request.fields['idToken'] = profile.myIdToken;
                request.files.add(http.MultipartFile(
                    'image',
                    File(pather).readAsBytes().asStream(),
                    File(pather).lengthSync(),
                    filename: pather.split("/").last,
                    contentType: new MediaType('image', 'jpeg')));
                var res = await request.send();
                final respStr = await res.stream.bytesToString();
                print(respStr);
              }

              uploadFileToServer(img);

              final uri = Uri.parse(
                  "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/uploads/images");

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
                  size: 170.0,
                ),
                Text("Click to upload",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Padding(padding: EdgeInsets.all(5.0)),
              ],
            )
            // child: Text("Click to upload".toUpperCase(),
            //     style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
        const Padding(padding: EdgeInsets.all(7.0)),
        const Text("Title",
            style: TextStyle(
              color: Color(0xffb257a84),
              fontSize: 23,
            )),
        const Padding(padding: EdgeInsets.all(7.0)),
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
        const Padding(padding: EdgeInsets.all(7.0)),
        const Text("Genre",
            style: TextStyle(
              color: Color(0xffb257a84),
              fontSize: 23,
            )),
        const Padding(padding: EdgeInsets.all(7.0)),
        SizedBox(
          width: 300,
          child: DropdownButtonFormField(
              items: categories.map((String category) {
                return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: <Widget>[
                        Text(category),
                      ],
                    ));
              }).toList(),
              onChanged: (newValue) {
                // do other stuff with _category
                // setState(() => _category = newValue);
              },
              // value: _category,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                filled: true,
                fillColor: Colors.white70,
              )),
        ),
        const Padding(padding: EdgeInsets.all(7.0)),
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
              },
              child: Text("Select audio".toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            Spacer(),
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
