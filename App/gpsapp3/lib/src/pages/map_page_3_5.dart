// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:gpsapp3/src/components/drawer.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   MapboxMapController? controller;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _currentUser;
//   DatabaseReference dbuser = FirebaseDatabase.instance.ref();
//   DatabaseReference dbgps = FirebaseDatabase.instance.ref();
//   double lat = 16.472882976645295; // Default latitude
//   double lng = 107.58835262399911; // Default longitude
//   bool loadingData = true; // Flag to indicate data loading
//   String _seri = '';

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   Future<void> _getCurrentUser() async {
//     User? user = _auth.currentUser;
//     String seri = '';
//     if (user != null) {
//       setState(() {
//         _currentUser = user;
//         dbuser = FirebaseDatabase.instance.ref('Database').child(_currentUser!.uid);
//       });

//       _getSeri();
//     }
//   }

//   void _getSeri() {
//     dbuser.onValue.listen((event) {
//       final data = event.snapshot.value;
//       if (data != null && data is Map<dynamic, dynamic>) {
//         setState(() {
//           _seri = data['seri'] ?? ''; // Set default value if 'Seri' is missing
//           dbgps = FirebaseDatabase.instance.ref('GPS').child(_seri);
//         });
//         _listenForData();
//       }
//     });
//   }

//   void _listenForData() {
//     dbgps.onValue.listen((event) {
//       final data = event.snapshot.value;
//       if (data != null && data is Map<dynamic, dynamic>) {
//         setState(() {
//           lat = (data['LAT']) as double;
//           lng = (data['LNG']) as double;
//           loadingData = false; // Data loaded
//           print('LAT: $lat');
//           print('LNG: $lng');

//           // Move camera to new location
//           if (controller != null) {
//             controller!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
//           }
//         });

//         // Add symbol when data is available
//         if (controller != null) {
//           controller!.addSymbol(SymbolOptions(
//             geometry: LatLng(lat, lng),
//             iconSize: 3,
//             iconImage: 'airport-15',
//           ));
//         }
//       }
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map Page',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: const Color(0xff000D2D),
//         iconTheme: IconThemeData(
//           color: Colors.white, // Màu trắng cho biểu tượng menu
//         ),
//       ),
//       drawer: profileUser(),
//       body: loadingData
//           ? Center(child: CircularProgressIndicator()) // Show loading indicator
//           : crearMap(),
//       floatingActionButton: buttonAction(),
//     );
//   }


//   Column buttonAction() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         FloatingActionButton(
//           child: Icon(Icons.location_on),
//           onPressed: () {
//             controller?.addSymbol(SymbolOptions(
//                 geometry: LatLng(lat, lng),
//                 iconSize: 3,
//                 iconImage: 'marker-15'
//             ));
//           },
//         ),
//         SizedBox(height: 5,),
//         FloatingActionButton(
//           child: Icon(Icons.zoom_in),
//           onPressed: () {
//             controller?.animateCamera(CameraUpdate.zoomIn());
//           },
//         ),
//         SizedBox(height: 5,),
//         FloatingActionButton(
//           child: Icon(Icons.zoom_out),
//           onPressed: () {
//             controller?.animateCamera(CameraUpdate.zoomOut());
//           },
//         ),
//         SizedBox(height: 5,),

//       ],
//     );
//   }

//   MapboxMap crearMap () {
//     return MapboxMap(
//       accessToken:
//       'sk.eyJ1IjoiYmFvbG9jIiwiYSI6ImNsdmY2anN3bTBpMXgyaXA1NWdkOHY3OXAifQ.sS1ejJ6fIb8_lU9ob4u6Hw',
//       initialCameraPosition: CameraPosition(
//         target: LatLng(lat, lng),
//         zoom: 12.0,
//       ),
//       onMapCreated: (MapboxMapController controller) {
//         this.controller = controller;
//         controller.addSymbol(SymbolOptions(
//           geometry: LatLng(lat, lng),
//           iconImage: 'airport-15', // Replace 'your-icon-image' with the name of your icon image
//           iconSize: 3,
//         ));
//         MyLocationEnabled: true;
//       },

//     );
//   }
// }
