// import 'dart:html';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:gpsapp3/src/pages/home_page.dart';
// import 'package:gpsapp3/src/components/drawer.dart';
// import 'package:gpsapp3/src/pages/profile_user_page.dart';

// class HomeTest extends StatefulWidget {
//   @override
//   _HomeTestState createState() => _HomeTestState();
// }

// class _HomeTestState extends State<HomeTest> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
//       body: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('database')
//               .doc('123')
//               .snapshots(),
//           builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text('Something wrong!'),
//               );
//             }
//             if (snapshot.connectionState == ConnectionState.active) {
//               Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//               return Center(
//                 child: Column(
//                   children: [
//                     Text(data['name'], style: TextStyle(color: Colors.red),)
//                   ],
//                 ),
//               );
//             }
//             return const Center(
//               child: Text('Loading....'),
//             );
//           }),
//     );
//   }
// }
