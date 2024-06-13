import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gpsapp3/src/eventhandler/auth_state.dart';
import 'package:gpsapp3/src/pages/ggmap_page.dart';
import 'package:gpsapp3/src/pages/home_page.dart';
import 'package:gpsapp3/src/pages/hometest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthState(),
    );
  }
}
