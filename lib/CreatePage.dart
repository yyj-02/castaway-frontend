import 'package:flutter/material.dart';
import 'CreateFromRecorded.dart';
import 'Livestream.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final myController = TextEditingController();
  final passController = TextEditingController();
  var imageID;
  var podcastID;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    passController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Padding(padding: EdgeInsets.all(35.0)),
        Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text("Something's Brewing",
                    style: TextStyle(
                      color: Color(0xffb257a84),
                      fontSize: 33,
                    )),
              ]),
        ),
        const Padding(padding: EdgeInsets.all(20.0)),
        SizedBox(
          width: 350,
          child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xffb257a84)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Color(0xffb257a84))))),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CreateRecordedPage();
              }));
            },
            child: Column(children: const [
              Icon(Icons.storage, size: 123.0),
              Text("Upload from storage",
                  style: TextStyle(
                    fontSize: 26,
                  )),
            ]),
          ),
        ),
        const Padding(padding: EdgeInsets.all(20.0)),
        SizedBox(
          width: 350,
          child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xffb257a84)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Color(0xffb257a84))))),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LiveStreamPage();
              }));
            },
            child: Column(children: const [
              Icon(Icons.mic, size: 123.0),
              Text("Go live ",
                  style: TextStyle(
                    fontSize: 26,
                  ))
            ]),
          ),
        ),
      ],
    ));
  }
}
