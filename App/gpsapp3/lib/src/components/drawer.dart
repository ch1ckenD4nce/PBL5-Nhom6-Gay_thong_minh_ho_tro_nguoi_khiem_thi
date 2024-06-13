import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpsapp3/src/pages/home_page.dart';
import 'package:gpsapp3/src/pages/hometest.dart';
import 'package:gpsapp3/src/pages/map_page.dart';
import 'package:gpsapp3/src/pages/profile_user_page.dart';

class profileUser extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  profileUser({super.key});

  Future<void> _logOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[800],
      child: Column(
        children: [
          const DrawerHeader(
              child: Icon(
            Icons.person,
            color: Colors.white,
            size: 64,
          )),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapPage())),
            },
            title: const Text(
              'H O M E',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage())),
            },
            title: const Text(
              'P R O F I L E',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onTap: () => _logOut(context),
            title: const Text(
              'LOG OUT',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
