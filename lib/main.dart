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
    return MaterialApp(
      title: 'Navigation Demo',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FirstPage(title: 'FirstPage'),
    );
  }
}
