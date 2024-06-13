import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gpsapp3/src/pages/map_page.dart';
import 'package:gpsapp3/src/pages/home_page.dart';

import 'package:gpsapp3/src/pages/hometest.dart';
import 'package:gpsapp3/src/pages/signin_page.dart';

class AuthState extends StatelessWidget {
  const AuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            return MapPage();
          } else {
            return SigninPage();
          }
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('failed'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return HomePage();
      },
    );
  }
}
