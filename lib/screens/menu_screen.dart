import 'dart:io';

import 'package:fireb/models/user.dart';
import 'package:fireb/screens/home/settings_form.dart';
import 'package:fireb/screens/services/auth.dart';
import 'package:fireb/screens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  ImageProvider _getAvatarImage(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return const AssetImage('assets/sagiri.jpg'); // Default avatar
    }
    if (avatarUrl.startsWith('assets/')) {
      return AssetImage(avatarUrl);
    } else {
      return FileImage(File(avatarUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    final userData = Provider.of<UserData?>(context);
    final auth = Provider.of<AuthService>(context);

    void showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: const SettingsForm(),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            onPressed: () async {
              await auth.signOut();
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.settings),
            label: const Text('settings'),
            onPressed: () => showSettingsPanel(),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userData?.avatarUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: _getAvatarImage(userData!.avatarUrl),
              ),
            const SizedBox(height: 20),
            Text(
              userData?.name ?? 'User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: userData?.isDarkMode ?? false,
              onChanged: (value) {
                if (user != null) {
                  DatabaseService(uid: user.uid).updateTheme(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
