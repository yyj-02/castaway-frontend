import 'package:flutter/material.dart';
import 'ProfileDetails.dart' as profile;
import 'package:settings_ui/settings_ui.dart';
import 'ViewProfile.dart';
import 'ChangeName.dart';
import 'ViewCreations.dart';
import 'Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          const Padding(padding: EdgeInsets.all(35.0)),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Welcome",
                    style: TextStyle(
                      color: Color(0xffb257a84),
                      fontSize: 33,
                    )),
                const Padding(padding: EdgeInsets.all(9.0)),
                Text(profile.displayName,
                    style: const TextStyle(
                      color: Color(0xffb257a84),
                      fontSize: 20,
                    )),
                const Padding(padding: EdgeInsets.all(15.0)),
                const settings()
              ])
        ]));
  }
}

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 350,
            child: SettingsList(sections: [
              SettingsSection(
                title: const Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.person),
                    title: const Text('View profile'),
                    onPressed: (context) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const viewProfilePage();
                      }));
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.upload),
                    title: const Text('View creations'),
                    onPressed: (context) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ViewCreationsPage();
                      }));
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.text_fields),
                    title: const Text('Change Display name'),
                    onPressed: (context) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const changeName();
                      }));
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Security'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onPressed: (context) async {
                      profile.myCreations = [];
                      profile.myIdToken = null;
                      profile.myRefreshToken = null;
                      profile.allPodcasts = [];
                      profile.displayName = "";
                      profile.favePodcasts = [];
                      profile.numFav = 0;
                      profile.numCre = 0;
                      profile.email = "";
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove('email');
                      prefs.remove("password");
                      prefs.setBool("val", false);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const FirstPage(title: "firstpage");
                      }));
                    },
                  ),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
