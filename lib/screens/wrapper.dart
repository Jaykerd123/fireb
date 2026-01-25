import 'package:fireb/models/user.dart';
import 'package:fireb/screens/authenticate/initial_page.dart';
import 'package:fireb/screens/home/home.dart';
import 'package:fireb/screens/onboarding/avatar_selection_screen.dart';
import 'package:fireb/screens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    if (user == null) {
      return const InitialPage();
    } else {
      return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!;
            if (userData.onboardingCompleted) {
              return const Home();
            } else {
              return const AvatarSelectionScreen();
            }
          } else {
            return const AvatarSelectionScreen();
          }
        },
      );
    }
  }
}
