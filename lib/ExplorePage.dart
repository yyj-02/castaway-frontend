import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:multi_page_castaway/Preview.dart';
import 'ProfileDetails.dart' as profile;
import 'Preview.dart';
import 'CustoSearchDelegate.dart';
import "SecondpagefromExplore.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    //Periodic refresh
    Timer.periodic(
        const Duration(seconds: 3600),
        (Timer t) =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SecondPage(title: 'SecondPage');
            })));
    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          AppBar(
            title: const Text("Search",
                style: TextStyle(
                  color: Color(0xffb257a84),
                )),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: const Icon(
                  Icons.search,
                  color: Color(0xffb257a84),
                ),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.all(35.0)),
          CarouselSlider(
            options: CarouselOptions(
              height: 400.0,
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
            ),
            items: profile.allPodcasts.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(i['imgUrl']),
                              fit: BoxFit.cover,
                            ),
                            shape: BoxShape.rectangle,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(18.0))),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.white10,
                                Colors.white24,
                                Colors.white38,
                                Colors.white54,
                                Colors.white60,
                                Colors.white70,
                                Colors.white,
                              ],
                              tileMode: TileMode.mirror,
                            ),
                          ),
                          child: Card(
                            elevation: 0,
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Previewpage(podcastdet: i);
                                }));
                              },
                              child: SizedBox(
                                width: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      i['title'],
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                    Text(
                                      i['description'],
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    Text(
                                      i['artistName'],
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    // Text(
                                    //   i['genres'] ,
                                    //   style: const TextStyle(fontSize: 16.0),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          const Padding(padding: EdgeInsets.all(8.0)),
          const Text('Click to select',
              style: TextStyle(
                color: Color(0xffb257a84),
              ))
        ]),
      ),
    );
  }
}
