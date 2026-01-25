import 'package:fireb/screens/home/settings_form.dart';
import 'package:fireb/screens/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:fireb/screens/services/database.dart';
import 'package:provider/provider.dart';
import 'package:fireb/models/brew.dart';
import 'package:fireb/screens/home/user_list.dart';
import '../menu_screen.dart';
import '../translate_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    void showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: const SettingsForm(),
            );
          });
    }

    final List<Widget> screens = [
      const _HomeScreen(),
      const TranslateScreen(),
      const MenuScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Translate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    void showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: const SettingsForm(),
            );
          });
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
              onPressed: () => showSettingsPanel(),
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/teaparty.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: const UserList(),
        ),
      ),
    );
  }
}
