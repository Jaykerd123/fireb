import 'package:fireb/screens/authenticate/register.dart';
import 'package:fireb/screens/authenticate/login_page.dart';
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

  void _showInitial() {
    setState(() => _view = 'initial');
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
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/app_logo/logo_black.png', height: 100),
                  const SizedBox(height: 20),
                  const Text(
                    'Higa',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'A Higaonon Language Translator',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _showSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: _showRegister,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        );
      case 'signin':
        return LoginPage(toggleView: _showInitial);
      case 'register':
        return Register(toggleView: toggleView);
      default:
        return Container();
    }
  }
}
