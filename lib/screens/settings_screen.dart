import 'dart:io';

import 'package:fireb/models/user.dart';
import 'package:fireb/screens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEffectsEnabled = false;
  bool _autoplayEnabled = true;
  bool _dailyReminderEnabled = false;
  bool _offlineModeEnabled = false;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _getAvatarImage(userData?.avatarUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  userData?.name ?? 'User',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'General',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Notifications'),
                subtitle: const Text('Enable push notifications'),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                secondary: const Icon(Icons.notifications_outlined),
              ),
              SwitchListTile(
                title: const Text('Sound Effect'),
                subtitle: const Text('Play audio feedback'),
                value: _soundEffectsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _soundEffectsEnabled = value;
                  });
                },
                secondary: const Icon(Icons.volume_up_outlined),
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                value: userData?.isDarkMode ?? false,
                onChanged: (value) {
                  if (user != null) {
                    DatabaseService(uid: user.uid).updateTheme(value);
                  }
                },
                secondary: const Icon(Icons.dark_mode_outlined),
              ),
              const SizedBox(height: 30),
              const Text(
                'Learning',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Autoplay'),
                subtitle: const Text('Automatically play pronunciations'),
                value: _autoplayEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _autoplayEnabled = value;
                  });
                },
                secondary: const Icon(Icons.play_circle_outline),
              ),
              SwitchListTile(
                title: const Text('Daily Reminder'),
                subtitle: const Text('Remind me to practice'),
                value: _dailyReminderEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _dailyReminderEnabled = value;
                  });
                },
                secondary: const Icon(Icons.notifications_active_outlined),
              ),
              SwitchListTile(
                title: const Text('Offline Mode'),
                subtitle: const Text('Download content for offline use'),
                value: _offlineModeEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _offlineModeEnabled = value;
                  });
                },
                secondary: const Icon(Icons.download_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
