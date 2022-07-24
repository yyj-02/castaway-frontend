import 'dart:async';
import 'package:flutter/material.dart';
import 'FavPreview.dart';
import 'ProfileDetails.dart' as profile;
import 'SecondpagefromExplore.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1000), (Timer t) => setState(() {}));
    if (profile.favePodcasts.isEmpty) {
      return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.all(70.0)),
              Center(
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(padding: EdgeInsets.all(80.0)),
                        const Text("Find something you like !",
                            style: TextStyle(
                              color: Color(0xffb257a84),
                              fontSize: 25,
                            )),
                        const Padding(padding: EdgeInsets.all(25.0)),
                        ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffb257a84)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Color(0xffb257a84))))),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const SecondPage(title: "explore");
                            }));
                          },
                          child: const Text("Go to Explore",
                              style: TextStyle(
                                fontSize: 20,
                              )),
                        ),

                      ]),
                ),
              )
            ]),
      );
    } else {
      return Column(children: [
        const Padding(padding: EdgeInsets.all(35.0)),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Only for you",
                  style: TextStyle(
                    color: Color(0xffb257a84),
                    fontSize: 33,
                  )),
              GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children:
                      profile.favePodcasts.where((s) => s != null).map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return SizedBox(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(i['imgUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: BoxShape.rectangle,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(18.0))),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18.0)),
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
                                        Colors.black12,
                                        Colors.black26,
                                        Colors.black38,
                                        Colors.black45,
                                        Colors.black54,
                                        Colors.black87,
                                        Colors.black,
                                      ],
                                      // Gradient from https://learnui.design/tools/gradient-generator.html
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
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Previewpage(podcastdet: i);
                                        }));
                                      },
                                      child: SizedBox(
                                        width: 160,
                                        height: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6.0, vertical: 3.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                i['title'],
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                ),
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
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList())
            ])
      ]);
    }
  }
}
