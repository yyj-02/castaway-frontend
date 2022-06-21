import 'dart:async';
import 'Login.dart';
import 'package:flutter/material.dart';
import 'Palette.dart';
import 'ProfileDetails.dart' as profile;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

Future<void> refresh() async {
  if (profile.myRefreshToken != null) {
    var data = {
      'refreshToken': profile.myRefreshToken,
    };
    final uri = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/auth/refreshToken");
    http.Response response = await http.post(
      uri,
      body: data,
    );
    profile.myIdToken = await jsonDecode(response.body)['idToken'];
    profile.myRefreshToken = await jsonDecode(response.body)['refreshToken'];
    profile.displayName = await jsonDecode(response.body)['displayName'];
    print(profile.myIdToken);
    print(profile.myRefreshToken);
  }
}

Future<void> refreshall() async {
  if (profile.myRefreshToken != null) {
    final uri = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/podcasts");
    http.Response response = await http.get(uri);
    profile.allPodcasts = await jsonDecode(response.body);
    final uri3 = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/favorites");
    http.Response response3 =
        await http.post(uri3, body: {'idToken': profile.myIdToken});
    profile.favePodcasts = await jsonDecode(response3.body);
    final uri4 = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/info");
    http.Response response4 =
        await http.post(uri4, body: {'idToken': profile.myIdToken});
    profile.email = await jsonDecode(response4.body)['email'];
    profile.displayName = await jsonDecode(response4.body)['displayName'];
    profile.numCre = await jsonDecode(response4.body)['numberOfCreations'];
    profile.numFav = await jsonDecode(response4.body)['numberOfFavorites'];
    final uri5 = Uri.parse(
        "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/users/creations");
    http.Response response5 =
        await http.post(uri5, body: {'idToken': profile.myIdToken});
    profile.myCreations = await jsonDecode(response5.body);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 3600), (Timer t) => refresh());
    Timer.periodic(const Duration(seconds: 1000), (Timer t) => refreshall());
    return MaterialApp(
      title: 'Navigation Demo',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        fontFamily: 'Poppins',
        primaryColor: const Color(0xffb257a84),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FirstPage(title: 'FirstPage'),
    );
  }
}
