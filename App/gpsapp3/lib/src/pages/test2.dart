// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class MyPage extends StatefulWidget {
//   @override
//   _MyPageState createState() => _MyPageState();
// }

// class _MyPageState extends State<MyPage> {
//   String _textValue = '';
//   String _textMax = '';

//   DatabaseReference reference = FirebaseDatabase.instance.ref('GPS').child('thietbi1');

//   @override
//   void initState() {
//     super.initState();
//     reference.onValue.listen((event) {
//       final data = event.snapshot.value;
//       if (data != null && data is Map<dynamic, dynamic>) {
//         setState(() {
//           _textValue = (data['LAT'] ?? '').toString();
//           _textMax = (data['LNG'] ?? '').toString();
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Value: $_textValue',
//               style: TextStyle(fontSize: 20),
//             ),
//             Text(
//               'Max: $_textMax',
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
