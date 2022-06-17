import 'ProfileDetails.dart' as profile;
import 'package:flutter/material.dart';

class viewProfilePage extends StatefulWidget {
  const viewProfilePage({Key? key}) : super(key: key);

  @override
  State<viewProfilePage> createState() => _viewProfilePageState();
}

class _viewProfilePageState extends State<viewProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            const Text("View profile",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 40,
                )),
            const Spacer(),
            const Text("Email address",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 25,
                )),
            const Spacer(),
            Text(profile.email,
                style: const TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 20,
                )),
            const Spacer(),
            const Text("Display name",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 25,
                )),
            const Spacer(),
            Text(profile.displayName,
                style: const TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 20,
                )),
            const Spacer(),
            const Text("Number of podcasts created",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 25,
                )),
            const Spacer(),
            Text(profile.numCre.toString(),
                style: const TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 20,
                )),
            const Spacer(),
            const Text("Number of favourites",
                style: TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 20,
                )),
            const Spacer(),
            Text(profile.numFav.toString(),
                style: const TextStyle(
                  color: Color(0xffb257a84),
                  fontSize: 20,
                )),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
