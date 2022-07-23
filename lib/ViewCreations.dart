import 'package:flutter/material.dart';
import 'SecondPagefromCreate.dart';
import 'ProfileDetails.dart' as profile;
import 'DeleteCreation.dart';
import 'SecondpagefromProfile.dart';

int count = 0;

class ViewCreationsPage extends StatefulWidget {
  const ViewCreationsPage({Key? key}) : super(key: key);

  @override
  State<ViewCreationsPage> createState() => _ViewCreationsPageState();
}

class _ViewCreationsPageState extends State<ViewCreationsPage> {
  @override
  Widget build(BuildContext context) {
    if (profile.myCreations.isEmpty) {
      return Scaffold(
        body: Column(children: [
          const Padding(padding: EdgeInsets.all(35.0)),
          Row(
            children: [
              SizedBox(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SecondPage(title: "secondpage");
                      }));
                    },
                    child: const Text("<- Back",
                        style: TextStyle(
                          color: Color(0xffb257a84),
                        ))),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(15.0)),
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Go Create something \nbe you !",
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Color(0xffb257a84))))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SecondPageC(title: "create");
                      }));
                    },
                    child: const Text("Go to Create",
                        style: TextStyle(
                          fontSize: 23,
                        )),
                  ),
                ]),
          )
        ]),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              const Padding(padding: EdgeInsets.all(35.0)),
              Row(
                children: [
                  SizedBox(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SecondPage(title: "secondpage");
                          }));
                        },
                        child: const Text("<- Back",
                            style: TextStyle(
                              color: Color(0xffb257a84),
                            ))),
                  ),
                ],
              ),
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
                            physics: const ScrollPhysics(),
                            children: profile.myCreations.map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image:
                                                    NetworkImage(i['imgUrl']),
                                                fit: BoxFit.cover,
                                              ),
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                                tileMode: TileMode.mirror,
                                              ),
                                            ),
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
                                                    return DeleteCreationsPage(
                                                        podcastdet: i);
                                                  }));
                                                },
                                                child: SizedBox(
                                                  width: 150,
                                                  height: 150,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        i['title'],
                                                        style: const TextStyle(
                                                            fontSize: 18.0),
                                                      ),
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
}
