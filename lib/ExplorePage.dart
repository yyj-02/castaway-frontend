import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:multi_page_castaway/Preview.dart';
import 'ProfileDetails.dart' as profile;
import 'Preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(padding: EdgeInsets.all(35.0)),
      Row(children: [
        Flexible(
          flex: 1,
          child: TextField(
            cursorColor: const Color(0xffb257a84),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              hintText: 'Search',
              hintStyle:
                  const TextStyle(color: Color(0xffb257a84), fontSize: 18),
            ),
          ),
        ),
        // TextButton(
        //   onPressed: () {
        //     profile.displayName = "";
        //     profile.myRefreshToken = null;
        //     profile.myIdToken = null;
        //
        //     Navigator.pop(context);
        //   },
        //   child: const Text('Logout'),
        // ),
      ]),
      const Padding(padding: EdgeInsets.all(10.0)),
      CarouselSlider(
        options: CarouselOptions(height: 400.0),
        items: [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Card(
                color: const Color(0xffb257a84),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return  Previewpage();
                    }));
                  },
                  child: SizedBox(
                    width:300,
                    child: Column(
                      children: [
                        IconButton(
                          // width: MediaQuery.of(context).size.width,
                          // margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          //
                          // decoration: const BoxDecoration(
                          //     color: Color(0xffb257a84),
                          //     borderRadius: BorderRadius.all(Radius.circular(18))),
                          icon: const Icon(Icons.access_alarm),
                          onPressed: () {},
                          // child: Text(
                          //   '$i',
                          //   style: const TextStyle(fontSize: 16.0),
                          // )
                        ),
                    Text(
                      '$i',
                      style: const TextStyle(fontSize: 16.0),
                    )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
      const Padding(padding: EdgeInsets.all(8.0)),
      const Text('Click to select')
    ]);
  }
}
