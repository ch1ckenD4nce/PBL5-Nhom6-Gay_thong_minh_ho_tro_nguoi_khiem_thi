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
//   double lat = 16.472882976645295; // Default latitude
//   double lng = 107.58835262399911; // Default longitude
//   bool loadingData = true; // Flag to indicate data loading

//   DatabaseReference reference = FirebaseDatabase.instance.ref('GPS').child('102210115');

//   @override
//   void initState() {
//     super.initState();
//     reference.onValue.listen((event) {
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
