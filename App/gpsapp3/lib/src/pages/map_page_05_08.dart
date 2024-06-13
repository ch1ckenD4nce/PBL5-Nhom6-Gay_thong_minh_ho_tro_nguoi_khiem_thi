// import 'package:flutter/material.dart';
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

//   @override
//   void initState() {
//     super.initState();
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
//       body: MapboxMap(
//         accessToken:
//         'sk.eyJ1IjoiYmFvbG9jIiwiYSI6ImNsdmY2anN3TBpMXgyaXA1NWdkOHY3OXAifQ.sS1ejJ6fIb8_lU9ob4u6Hw',
//         initialCameraPosition: CameraPosition(
//           target: LatLng(lat, lng),
//           zoom: 12.0,
//         ),
//         onMapCreated: (MapboxMapController controller) {
//           this.controller = controller;
//         },
//         onStyleLoadedCallback: addSymbolToMap, // Add symbol when map style is loaded
//       )
//     );
//   }

//   void addSymbolToMap() {
//     if (controller != null) {
//       controller!.addSymbol(SymbolOptions(
//         geometry: LatLng(lat, lng),
//         iconImage: 'airport-15', // Use a default icon
//         iconSize: 3,
//       ));
//     }
//   }
// }