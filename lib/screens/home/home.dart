import 'package:fireb/screens/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fireb/screens/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fireb/screens/home/user_list.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    return StreamProvider<QuerySnapshot?>.value(
      initialData: null,
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
            )
          ],
        ),
        body: UserList(),
      ),
    );
  }
}
