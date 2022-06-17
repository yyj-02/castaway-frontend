import 'package:flutter/material.dart';
import 'FavPreview.dart';
import 'ProfileDetails.dart' as profile;

int count = 0;

class ViewCreationsPage extends StatefulWidget {
  const ViewCreationsPage({Key? key}) : super(key: key);

  @override
  State<ViewCreationsPage> createState() => _ViewCreationsPageState();
}

class _ViewCreationsPageState extends State<ViewCreationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            const Padding(padding: EdgeInsets.all(35.0)),
            SingleChildScrollView(
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Marvel at your creations",
                          style: TextStyle(
                            color: Color(0xffb257a84),
                            fontSize: 30,
                          )),
                      GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: profile.myCreations.map((i) {
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
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(18.0))),
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return Previewpage(
                                                    podcastdet: i);
                                              }));
                                            },
                                            child: SizedBox(
                                              width: 150,
                                              height: 150,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    i['title'],
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
                                                  ),

                                                  Text(
                                                    i['artistName'],
                                                    style: const TextStyle(
                                                        fontSize: 16.0),
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
                                    ],
                                  ),
                                );
                              },
                            );
                          }).toList()),
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
