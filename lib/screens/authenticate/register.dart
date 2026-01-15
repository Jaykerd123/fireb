import 'package:fireb/screens/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _authService = AuthService();

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up t obrew crew'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Register'),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  print(email);
                  print(password);
                },
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
