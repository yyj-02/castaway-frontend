import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:multi_page_castaway/SecondPage.dart';
import 'Login.dart';
import 'SecondPage.dart';
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
          "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/livestreams"),
    );
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

class Frontpage extends StatefulWidget {
  const Frontpage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Frontpage> createState() => _FrontpageState();
}

class _FrontpageState extends State<Frontpage> {
  @override
  Widget build(BuildContext context) {
    checks().then((bool result) async {
      if (result) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const SecondPage(title: 'SecondPage');
        }));
      } else {
        await Future.delayed(const Duration(seconds: 5));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const FirstPage(title: "hi");
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
              const Padding(padding: EdgeInsets.all(10.0)),
              const Text("Castaway",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  )),
              const Padding(padding: EdgeInsets.all(10.0)),
              const Text("Your friendly podcast app",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
              Image.asset('assets/images/Login.png', height: 180, width: 500)
            ],
          ),
        ),
      ),
    );
  }
}

//Login Form
