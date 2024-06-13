// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:gpsapp3/src/pages/home_page.dart';
// import 'package:gpsapp3/src/components/drawer.dart';
// import 'package:gpsapp3/src/pages/profile_user_page.dart';

// class HomeTest extends StatefulWidget {
//   @override
//   _HomeTestState createState() => _HomeTestState();
// }

// class _HomeTestState extends State<HomeTest> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _currentUser;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   Future<void> _getCurrentUser() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       setState(() {
//         _currentUser = user;
//       });
//     }
//   }

//   Future<void> _logOut(BuildContext context) async {
//     await _auth.signOut();
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => HomePage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'GPS APP',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color(0xff000D2D),
//         iconTheme: IconThemeData(
//           color: Colors.white, // Màu trắng cho biểu tượng menu
//         ),
//       ),
//       drawer: profileUser(),
//       body: Center(
//         child: Column(
//           children: [
//             IconButton(
//               onPressed: () => _logOut(context),
//               icon: const Icon(Icons.logout),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             if (_currentUser != null)
//               Center(
//                 child: Text('Email: ${_currentUser!.email}'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
