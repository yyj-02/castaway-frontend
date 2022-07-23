import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multi_page_castaway/SecondPage.dart';
import 'Loading.dart';
import 'SecondPage.dart';
import 'SignUp.dart';
import 'ProfileDetails.dart' as profile;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var password = prefs.getString('password');
  if (email != null && password != null) {
    var data = {
      'email': prefs.getString('email'),
      'password': prefs.getString("password"),
    };
    final uri = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/auth/login");
    http.Response response = await http.post(
      uri,
      body: data,
    );
    profile.myIdToken = await jsonDecode(response.body)['idToken'];
    profile.myRefreshToken = await jsonDecode(response.body)['refreshToken'];
    print("I am here");
    print(profile.myIdToken);
    print(profile.myRefreshToken);
    final uri2 = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
    http.Response response2 = await http.get(
      uri2,
    );
    profile.allPodcasts = await jsonDecode(response2.body);
    http.Response socketres = await http.get(
      Uri.parse(
          "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/livestreams"),);
    profile.alllive = await jsonDecode(socketres.body);
    final uri3 = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/favorites");
    http.Response response3 =
        await http.post(uri3, body: {'idToken': profile.myIdToken});
    print(response3.body);
    profile.favePodcasts = await jsonDecode(response3.body);
    final uri4 = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/info");
    http.Response response4 =
        await http.post(uri4, body: {'idToken': profile.myIdToken});
    print(response4.body);
    profile.email = await jsonDecode(response4.body)['email'];
    profile.displayName = await jsonDecode(response4.body)['displayName'];
    profile.numCre = await jsonDecode(response4.body)['numberOfCreations'];
    profile.numFav = await jsonDecode(response4.body)['numberOfFavorites'];
    final uri5 = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
    http.Response response5 =
        await http.post(uri5, body: {'idToken': profile.myIdToken});
    print(response5.body);
    profile.myCreations = await jsonDecode(response5.body);
    return true;
  } else {
    return false;
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    checks().then((bool result) {
      if (result) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const SecondPage(title: 'SecondPage');
        }));
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xffb7bb9b9),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.all(8.0)),
              const Text("Castaway",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  )),
              const Padding(padding: EdgeInsets.all(8.0)),
              const Text("The best way to enjoy a podcast",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
              const MyCustomForm(),
              const Padding(padding: EdgeInsets.all(8.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const Signup();
                        }));
                      },
                      child: const Text("Sign up",
                          style: TextStyle(
                            color: Colors.white,
                          )))
                ],
              ),
              Image.asset('assets/images/Login.png', height: 180, width: 500)
            ],
          ),
        ),
      ),
    );
  }
}

//Login Form
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
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
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(8.0)),
          const Text("Email Address",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
          const Padding(padding: EdgeInsets.all(7.0)),
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
          const Padding(padding: EdgeInsets.all(8.0)),
          const Text("Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
          const Padding(padding: EdgeInsets.all(7.0)),
          SizedBox(
            width: 200,
            child: TextFormField(
              controller: passController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              obscureText: true,
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
          const Padding(padding: EdgeInsets.all(8.0)),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return const loading();
                  }));
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.getString('email') == null) {
                var data = {
                  'email': myController.text,
                  'password': passController.text,
                };
                final uri = Uri.parse(
                    "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/auth/login");
                http.Response response = await http.post(
                  uri,
                  body: data,
                );
                if (response.statusCode != 200) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('Invalid Credentials try again'),
                          actions: [
                            ElevatedButton(
                                child: const Text("ok",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return const FirstPage(title: 'SecondPage');
                                      }));
                                })
                          ],
                        );
                      });
                } else {
                  prefs.setString('email', myController.text);
                  prefs.setString('password', passController.text);
                  prefs.setBool("val", true);
                  profile.myIdToken =
                      await jsonDecode(response.body)['idToken'];
                  profile.myRefreshToken =
                      await jsonDecode(response.body)['refreshToken'];
                  print(profile.myIdToken);
                  print(profile.myRefreshToken);
                  final uri2 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
                  http.Response response2 = await http.get(
                    uri2,
                  );
                  profile.allPodcasts = await jsonDecode(response2.body);
                  http.Response socketres = await http.get(
                    Uri.parse(
                        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/livestreams"),);
                  profile.alllive = await jsonDecode(socketres.body);
                  final uri3 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/favorites");
                  http.Response response3 = await http
                      .post(uri3, body: {'idToken': profile.myIdToken});
                  print(response3.body);
                  profile.favePodcasts = await jsonDecode(response3.body);
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
                  final uri5 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                  http.Response response5 = await http
                      .post(uri5, body: {'idToken': profile.myIdToken});
                  print(response5.body);
                  profile.myCreations = await jsonDecode(response5.body);
                  print(profile.alllive);

                  if (profile.myIdToken != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SecondPage(title: 'SecondPage');
                    }));
                  }
                }
              } else {
                var data = {
                  'email': prefs.getString('email'),
                  'password': prefs.getString("password"),
                };
                final uri = Uri.parse(
                    "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/auth/login");
                http.Response response = await http.post(
                  uri,
                  body: data,
                );
                if (response.statusCode != 200) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('Invalid Credentials try again'),
                          actions: [
                            ElevatedButton(
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
                } else {
                  profile.myIdToken =
                      await jsonDecode(response.body)['idToken'];
                  profile.myRefreshToken =
                      await jsonDecode(response.body)['refreshToken'];
                  print(profile.myIdToken);
                  print(profile.myRefreshToken);
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
                  print(response3.body);
                  profile.favePodcasts = await jsonDecode(response3.body);
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
                  final uri5 = Uri.parse(
                      "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
                  http.Response response5 = await http
                      .post(uri5, body: {'idToken': profile.myIdToken});
                  print(response5.body);
                  profile.myCreations = await jsonDecode(response5.body);
                  http.Response socketres = await http.get(
                    Uri.parse(
                        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/livestreams"),);
                  profile.alllive = await jsonDecode(socketres.body);
                  print(profile.alllive);

                  if (profile.myIdToken != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SecondPage(title: 'SecondPage');
                    }));
                  }
                }
              }
            },
            child: Text("     Login     ".toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
