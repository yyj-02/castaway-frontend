import 'dart:convert';
import 'package:flutter/material.dart';
import 'ProfileDetails.dart' as profile;
import 'package:http/http.dart' as http;
import 'package:multi_page_castaway/ProfileDetails.dart' as profile;
import 'live.dart';

var add = "ws://10.0.2.2:3000/streamer";

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
                  const Text("All these choices",
                      style: TextStyle(
                        color: Color(0xffb257a84),
                        fontSize: 40,
                      )),

            ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
            children: profile.alllive.map((strone){
          return SizedBox(
            width: 350,
           child: ElevatedButton(onPressed: () {
             profile.viewlive = strone['livestreamId'];
             Navigator.push(context,
             MaterialPageRoute(builder: (context) {
               return  LiveStream(livedes: strone['description'], livename: strone['title'], liveid: strone["livestreamId"],);}));},
             child: Text(strone['title'].toString(),style: const TextStyle(
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
