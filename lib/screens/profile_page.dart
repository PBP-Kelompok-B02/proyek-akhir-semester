import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF592634),
      ),
      body: const Center(
        child: Text(
          'Halaman Profil',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
