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
    if (profile.favePodcasts.length < 1) {
      return Column(children: [
        const Padding(padding: EdgeInsets.all(50.0)),
        Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Go find something \nyou like !",
                    style: TextStyle(
                      color: Color(0xffb257a84),
                      fontSize: 30,
                    )),
                const Padding(padding: EdgeInsets.all(25.0)),
                ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffb257a84)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  child: Text("Go to Explore",
                      style: TextStyle(
                        fontSize: 23,
                      )),
                ),
              ]),
        )
      ]);
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
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              i['title'],
                                              style: const TextStyle(
                                                  fontSize: 18.0),
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
