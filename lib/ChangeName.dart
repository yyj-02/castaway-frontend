import 'dart:convert';
import 'SecondpagefromProfile.dart';
import 'ProfileDetails.dart' as profile;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class changeName extends StatefulWidget {
  const changeName({Key? key}) : super(key: key);

  @override
  State<changeName> createState() => _changeNameState();
}

class _changeNameState extends State<changeName> {
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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(30.0)),
                Row(
                  children: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: const Text("<- Back",
                            style: TextStyle(
                              color: Color(0xffb257a84),
                            ))),
                  ],
                ),
                const Spacer(),
                const Text("Change display name",
                    style: TextStyle(
                      color: Color(0xffb257a84),
                      fontSize: 30,
                    )),
                const Padding(padding: EdgeInsets.all(17.0)),
                const Text("Enter your new name here",
                    style: TextStyle(
                      color: Color(0xffb257a84),
                      fontSize: 20,
                    )),
                const Padding(padding: EdgeInsets.all(10.0)),
                SizedBox(
                  width: 200,
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
                const Padding(padding: EdgeInsets.all(10.0)),
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
                      'updatedDisplayName': myController.text,
                    };
                    final uri = Uri.parse(
                        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/displayName");
                    http.Response response = await http.put(
                      uri,
                      body: data,
                    );
                    final uri4 = Uri.parse(
                        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/info");
                    http.Response response4 = await http
                        .post(uri4, body: {'idToken': profile.myIdToken});
                    print(response4.body);
                    profile.displayName =
                        await jsonDecode(response4.body)['displayName'];
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SecondPage(title: 'SecondPage');
                    }));
                    ;
                  },
                  child: Text("Change Display name".toUpperCase(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                ),
                const Spacer(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
