import 'package:fireb/screens/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fireb/screens/services/database.dart';
import 'package:provider/provider.dart';
import 'package:fireb/screens/home/user_list.dart';
import 'package:fireb/models/brew.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    void _showSettingsPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            child: Text('bottom panel'),
          );
        }
      );
    }

    return StreamProvider<List<Brew>>.value(
      initialData: const [],
      value: DatabaseService().users,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
              onPressed: () => _showSettingsPanel(),
            )
          ],
        ),
        body: const UserList(),
      ),
    );
  }
}
