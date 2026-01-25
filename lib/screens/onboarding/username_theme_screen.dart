
import 'package:fireb/models/user.dart';
import 'package:fireb/screens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsernameThemeScreen extends StatefulWidget {
  final String avatar;
  const UsernameThemeScreen({super.key, required this.avatar});

  @override
  State<UsernameThemeScreen> createState() => _UsernameThemeScreenState();
}

class _UsernameThemeScreenState extends State<UsernameThemeScreen> {
  final _usernameController = TextEditingController();
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Enable Dark Mode'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (user != null) {
                  await DatabaseService(uid: user.uid).updateOnboardingData(
                    widget.avatar,
                    _usernameController.text,
                    _isDarkMode,
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                }
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
