import 'package:fireb/screens/authenticate/register.dart';
import 'package:fireb/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String _view = 'initial'; // 'initial', 'signin', 'register'

  void _showSignIn() {
    setState(() => _view = 'signin');
  }

  void _showRegister() {
    setState(() => _view = 'register');
  }

  void toggleView() {
    if (_view == 'signin') {
      setState(() => _view = 'register');
    } else {
      setState(() => _view = 'signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_view) {
      case 'initial':
        return Scaffold(
          appBar: AppBar(
            title: const Text('Welcome'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _showSignIn,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showRegister,
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        );
      case 'signin':
        return SignIn(toggleView: toggleView);
      case 'register':
        return Register(toggleView: toggleView);
      default:
        return Container();
    }
  }
}
