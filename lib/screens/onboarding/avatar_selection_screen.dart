
import 'dart:io';
import 'package:fireb/screens/onboarding/username_theme_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarSelectionScreen extends StatefulWidget {
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  final List<String> _avatars = [
    'assets/avatar/anby.webp',
    'assets/avatar/billy.webp',
    'assets/avatar/corin.webp',
    'assets/avatar/miyabi.webp',
    'assets/avatar/nicole.webp',
    'assets/avatar/lighter.webp',
    'assets/avatar/harumasa.webp',
    'assets/avatar/nekomata.webp',
  ];

  String? _selectedAvatar;
  File? _customAvatar;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _customAvatar = File(pickedFile.path);
        _selectedAvatar = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Avatar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _avatars.length,
                itemBuilder: (context, index) {
                  final avatar = _avatars[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = avatar;
                        _customAvatar = null;
                      });
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(avatar),
                      child: _selectedAvatar == avatar
                          ? const Icon(Icons.check_circle, size: 30)
                          : null,
                    ),
                  );
                },
              ),
            ),
            if (_customAvatar != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(_customAvatar!),
                child: const Icon(Icons.check_circle, size: 30),
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload Your Own'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsernameThemeScreen(
                      avatar: _selectedAvatar ?? _customAvatar!.path,
                    ),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
