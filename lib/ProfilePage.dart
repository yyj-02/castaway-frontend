import 'package:flutter/material.dart';
import 'ProfileDetails.dart' as profile;
import 'package:settings_ui/settings_ui.dart';

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
                  children:[
                    Text("Welcome",
                        style: TextStyle(
                          color: Color(0xffb257a84),
                          fontSize: 40,
                        )),
                    Padding(padding: EdgeInsets.all(9.0)),
                    Text(profile.displayName,
                        style: TextStyle(
                          color: Color(0xffb257a84),
                          fontSize: 25,
                        )),
                    Padding(padding: EdgeInsets.all(15.0)),
                    settings()
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
            height: 520,
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: const Text('Common'),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(Icons.language),
                      title: const Text('Language'),
                      value: const Text('English'),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.person),
                      title: const Text('View personal information'),
                    ),
                    SettingsTile.switchTile(
                      onToggle: (value) {},
                      initialValue: true,
                      leading: const Icon(Icons.format_paint),
                      title: const Text('Enable dark mode'),
                    ),
                  ],
                ),
                SettingsSection(
                  title: const Text('Security'),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(Icons.privacy_tip),
                      title: const Text('Privacy'),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.security),
                      title: const Text('Account settings'),
                    ),
                  ],
                ),
                SettingsSection(
                  title: const Text('Sound and playback'),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(Icons.equalizer),
                      title: const Text('Equalizer'),
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.speaker),
                      title: const Text('Advanced settings'),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}