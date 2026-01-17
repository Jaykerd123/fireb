import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<QuerySnapshot?>(context);

    if (users == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: users.docs.length,
      itemBuilder: (context, index) {
        final user = users.docs[index];
        final data = user.data() as Map<String, dynamic>?;

        return Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[data?['strength'] ?? 100],
            ),
            title: Text(data?['name'] ?? 'new user'),
            subtitle: Text('Takes ${data?['sugars'] ?? '0'} sugar(s)'),
          ),
        );
      },
    );
  }
}