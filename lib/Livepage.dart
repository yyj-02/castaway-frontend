import 'dart:convert';
import 'package:flutter/material.dart';
import 'ProfileDetails.dart' as profile;
import 'package:http/http.dart' as http;
import 'package:multi_page_castaway/ProfileDetails.dart' as profile;
import 'live.dart';

var add = "ws://35.213.151.122:3000/streamer";

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}
// var alllive;
//
getall() async {
  http.Response socketres = await http.get(
      Uri.parse(
          "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/livestreams"),);
  profile.alllive = await jsonDecode(socketres.body);

}

class _LivePageState extends State<LivePage> {

  @override

  Widget build(BuildContext context) {
    getall();
    print(profile.alllive);
  return SingleChildScrollView(
        child: Center(
          child: SizedBox(
          width: 350,
          height: 50000,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(30.0)),
                  const Text("Coming live",
                      style: TextStyle(
                        color: Color(0xffb257a84),
                        fontSize: 40,
                      )),

            ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
            children: profile.alllive.map((livestream){
          return SizedBox(
            width: 350,
           child: ElevatedButton(
             style: ButtonStyle(
               backgroundColor: livestream['streamerConnected'] == true ? MaterialStateProperty.all(const Color(0xffb257a84)) : MaterialStateProperty.all(Colors.grey),
             ),
             onPressed: () {
             profile.viewlive = livestream['livestreamId'];
             Navigator.push(context,
             MaterialPageRoute(builder: (context) {
               return  LiveStream(livedes: livestream['description'], livename: livestream['title'], liveid: livestream["livestreamId"],);}));},
             child: Text("${livestream['title']} - by ${livestream['artistName']}",style: const TextStyle(
                 color: Colors.white,)),

           ),
          );
          }).toList(),),
                  const Spacer()
                ]

            ),
              ),
        ));
  }
}
