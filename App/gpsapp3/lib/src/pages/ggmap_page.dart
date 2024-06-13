// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// class FullMap extends StatefulWidget {
//   @override
//   State<FullMap> createState() => _FullMapState();
// }

// class _FullMapState extends State<FullMap> {
//   late MapboxMapController mapcontroller;

//   void _ontap(MapboxMapController controller) {
//     mapcontroller = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: MapboxMap(
//           initialCameraPosition:
//               const CameraPosition(target: LatLng(16.0746307, 108.1496210), zoom: 14)),
//     );
//   }
// }




// // class FullMapPage extends ExamplePage {
// //   FullMapPage() : super(const Icon(Icons.map), 'Full map');

// //   @override
// //   Widget build(BuildContext context) {
// //     return const FullMap();
// //   }
// // }

// // class FullMap extends StatefulWidget {
// //   const FullMap();

// //   @override
// //   State createState() => FullMapState();
// // }

// // class FullMapState extends State<FullMap> {
// //   MapboxMapController mapcontroller;

// //   void _on(MapboxMapController controller) {
// //     mapcontroller = controller;
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: MapboxMap(
// //         onMapCreated: _on,
// //         initialCameraPosition: ,
// //         const CameraPosition(target: LatLng(0.0, 0.0)),
// //       ),
// //     );
// //   }
// // }
