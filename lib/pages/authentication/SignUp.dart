import 'dart:convert';
import '../../commons/profile.dart' as profile;
import 'package:flutter/material.dart';
import '../others/SecondPage.dart';
import 'Login.dart';
import '../others/Loading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffb7bb9b9),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.all(21.0)),
              const Text("Castaway",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  )),
              const Padding(padding: EdgeInsets.all(3.0)),
              const Text("Be part of our family today",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
              const MyCustomForm(),
              const Padding(padding: EdgeInsets.all(3.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const FirstPage(title: 'SecondPage');
                        }));
                      },
                      child: const Text("Login",
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

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    nameController.dispose();
    passController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(6.0)),
        const Text("Email Address",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        const Padding(padding: EdgeInsets.all(5.0)),
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
        const Padding(padding: EdgeInsets.all(6.0)),
        const Text("Display Name",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        const Padding(padding: EdgeInsets.all(5.0)),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: nameController,
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
        const Padding(padding: EdgeInsets.all(6.0)),
        const Text("Password",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        const Padding(padding: EdgeInsets.all(5.0)),
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
        const Padding(padding: EdgeInsets.all(6.0)),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const loading();
            }));
            var data = {
              'email': myController.text,
              'displayName': nameController.text,
              'password': passController.text,
            };
            final uri = Uri.parse(
                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/auth/signup");
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
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffb257a84)),
                            ),
                            child: const Text("ok",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const Signup();
                              }));
                            })
                      ],
                    );
                  });
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('email', myController.text);
              prefs.setString('password', passController.text);
              prefs.setBool("val", true);
              profile.myIdToken = await jsonDecode(response.body)['idToken'];
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
              profile.displayName =
                  await jsonDecode(response4.body)['displayName'];
              profile.numCre =
                  await jsonDecode(response4.body)['numberOfCreations'];
              profile.numFav =
                  await jsonDecode(response4.body)['numberOfFavorites'];
              http.Response socketres = await http.get(
                Uri.parse(
                    "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/livestreams"),
              );
              profile.alllive = await jsonDecode(socketres.body);
              final uri5 = Uri.parse(
                  "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
              http.Response response5 =
                  await http.post(uri5, body: {'idToken': profile.myIdToken});
              print(response5.body);
              profile.myCreations = await jsonDecode(response5.body);

              if (profile.myIdToken != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SecondPage(title: 'SecondPage');
                }));
              }
            }
          },
          child: Text("   Sign up   ".toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ],
    );
  }
}
