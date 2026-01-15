import 'package:fireb/models/user.dart';
import 'package:fireb/screens/authenticate/authenticate.dart';
import 'package:fireb/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<CustomUser?>(context);
    print(user);

    // return either Home or Authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return const Home();
    }
  }
}
