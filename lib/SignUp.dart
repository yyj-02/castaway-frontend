import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'SecondPage.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffb7bb9b9),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Castaway",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 75,
                  )),
              const Padding(padding: EdgeInsets.all(10.0)),
              const Text("Be part of our family today",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  )),
              const MyCustomForm(),
              const Padding(padding: EdgeInsets.all(10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Login",
                          style: TextStyle(
                            color: Colors.white,
                          )))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();
  final nameController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    nameController.dispose();
    passController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(10.0)),
        const Text("Username",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        const Padding(padding: EdgeInsets.all(7.0)),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: myController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              labelText: '',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(10.0)),
        const Text("Display Name",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        const Padding(padding: EdgeInsets.all(7.0)),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              labelText: '',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(10.0)),
        const Text("Password",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        const Padding(padding: EdgeInsets.all(7.0)),
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: passController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              labelText: '',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(10.0)),
        ElevatedButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xffb257a84)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Color(0xffb257a84))))),
          onPressed: () async {
            var data = {
              'email': myController.text,
              'displayName': nameController.text,
              'password': passController.text,
            };
            final uri = Uri.parse(
                "https://us-central1-castaway-819d7.cloudfunctions.net/app/api/auth/signup");
            http.Response response = await http.post(
              uri,
              body: data,
            );
            var myidToken = await jsonDecode(response.body)['idToken'];
            var myrefreshToken =
                await jsonDecode(response.body)['refreshToken'];
            print(myidToken);
            print(myrefreshToken);
            if (myidToken != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const SecondPage(title: 'SecondPage');
              }));
            }
          },
          child: Text("   Sign up   ".toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ],
    );
  }
}