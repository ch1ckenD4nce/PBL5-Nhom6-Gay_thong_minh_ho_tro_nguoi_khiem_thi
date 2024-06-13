// import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/services.dart';
// import 'package:gpsapp3/src/components/drawer.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:geolocator/geolocator.dart';


// class MapPage extends StatefulWidget {
//  @override
//  _MapPageState createState() => _MapPageState();
// }


// class _MapPageState extends State<MapPage> {
//  MapboxMapController? controller;
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  User? _currentUser;
//  DatabaseReference dbuser = FirebaseDatabase.instance.ref();
//  DatabaseReference dbgps = FirebaseDatabase.instance.ref();
//  double lat = 16.472882976645295; // Default latitude
//  double lng = 107.58835262399911; // Default longitude
//  bool loadingData = true; // Flag to indicate data loading
//  String _seri = '';
//  List<LatLng> pathCoordinates = [];
//  List<Symbol> allSymbols = [];


//  @override
//  void initState() {
//    super.initState();
//    _getCurrentUser();
//  }


//  Future<void> _getCurrentUser() async {
//    User? user = _auth.currentUser;
//    // ignore: unused_local_variable
//    String seri = '';
//    if (user != null) {
//      setState(() {
//        _currentUser = user;
//        dbuser = FirebaseDatabase.instance.ref('Database').child(_currentUser!.uid);
//      });
//      _getSeri();
//    }
//  }

//  void _getSeri() {
//    dbuser.onValue.listen((event) {
//      final data = event.snapshot.value;
//      if (data != null && data is Map<dynamic, dynamic>) {
//        setState(() {
//          _seri = data['seri'] ?? ''; // Set default value if 'Seri' is missing
//          dbgps = FirebaseDatabase.instance.ref('GPS').child(_seri);
//        });
//        _listenForData();
//      }
//    });
//  }


//  void _listenForData() {
//    dbgps.onValue.listen((event) {
//      final data = event.snapshot.value;
//      if (data != null && data is Map<dynamic, dynamic>) {
//        setState(() {
//          lat = (data['LAT']) as double;
//          lng = (data['LNG']) as double;
//          loadingData = false; // Data loaded
//          print('LAT: $lat');
//          print('LNG: $lng');
//          pathCoordinates.add(LatLng(lat, lng));
//          print(pathCoordinates.length);
//          saveCoordinatesToFirebase(lat, lng);
//          addSymbolToMap(); 
//        });
//      }
//    });
//  }

//  void saveCoordinatesToFirebase(double lat, double lng) {
//     DatabaseReference dbLoc = FirebaseDatabase.instance.ref('loc');
//     dbLoc.push().set({
//       'lat': lat,
//       'lng': lng,
//     });
//   }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: const Text('Map Page',
//          style: TextStyle(color: Colors.white),
//        ),
//        backgroundColor: const Color(0xff000D2D),
//        iconTheme: const IconThemeData(
//          color: Colors.white, // Màu trắng cho biểu tượng menu
//        ),
//      ),
//      drawer: profileUser(),
//      body: loadingData
//          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
//          : crearMap(),
//      floatingActionButton: buttonAction(),
//    );
//  }

//  Column buttonAction() {
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.end,
//      children: [
//        FloatingActionButton(
//         heroTag: "btn_icon",
//          child: const Icon(Icons.location_on),
//          onPressed: () {
//            controller?.addSymbol(SymbolOptions(
//                geometry: LatLng(lat, lng),
//                iconSize: 3,
//                iconImage: 'marker-15'
//            ));
//          },
//        ),
//        const SizedBox(height: 5,),
//        FloatingActionButton(
//         heroTag: "btn_zoom",
//          child: const Icon(Icons.zoom_in),
//          onPressed: () {
//            controller?.animateCamera(CameraUpdate.zoomIn());
//          },
//        ),
//        const SizedBox(height: 5,),
//        FloatingActionButton(
//         heroTag: "btn_zoom_out",
//          child: const Icon(Icons.zoom_out),
//          onPressed: () {
//            controller?.animateCamera(CameraUpdate.zoomOut());
//          },
//        ),
//        const SizedBox(height: 5,),
//      ],
//    );
//  }

//   void addCurrentLocationToMap() async {
//     if (controller != null) {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//         print('LAT1: ${position.latitude}');
//         print('LNG1: ${position.longitude}');
//       controller!.addSymbol(SymbolOptions(
//         geometry: LatLng(position.latitude, position.longitude),
//         iconSize: 3,
//         iconImage: 'marker-15'
//       ));
//     }
//   }

//  MapboxMap crearMap () {
//    return MapboxMap(
//      accessToken:
//      'sk.eyJ1IjoiYmFvbG9jIiwiYSI6ImNsdmY2anN3bTBpMXgyaXA1NWdkOHY3OXAifQ.sS1ejJ6fIb8_lU9ob4u6Hw',
//      initialCameraPosition: CameraPosition(
//        target: LatLng(lat, lng),
//        zoom: 12.0,
//      ),
//      onMapCreated: (MapboxMapController controller) {
//           this.controller = controller;
//           // addCurrentLocationToMap();
//         },
//       onStyleLoadedCallback: addSymbolToMap, 
//       myLocationEnabled: true,
//    );
//  }

//   void addSymbolToMap() async {
//     if (controller != null) {
//       // Clear all symbols
//       for (Symbol symbol in allSymbols) {
//         await controller!.removeSymbol(symbol);
//       }
//       allSymbols.clear();
//       final ByteData byteData1 = await rootBundle.load('assets/images/location1.png');
//       final Uint8List bytes1 = byteData1.buffer.asUint8List();
//       await controller!.addImage('location1', bytes1);

//       final ByteData byteData2 = await rootBundle.load('assets/images/point1.png'); // Replace with your old location icon path
//       final Uint8List bytes2 = byteData2.buffer.asUint8List();
//       await controller!.addImage('point1', bytes2);

//       // for (int i = 0; i < pathCoordinates.length; i++) {
//       //   LatLng coordinates = pathCoordinates[i];
//       //   controller!.addSymbol(SymbolOptions(
//       //     geometry: coordinates,
//       //     iconImage: i == pathCoordinates.length - 1 ? 'location1' : 'point1', // Use 'location1' for the latest location, 'point1' for others
//       //     iconSize: 3,
//       //     textField: i == pathCoordinates.length - 1 ? "Here" : '', // Only show text for the latest point
//       //     textOffset: const Offset(0, -2), // Offset the text to the top of the icon
//       //   ));
//       //   allSymbols.add(symbol);
//       // }

//       // for (int i = 0; i < pathCoordinates.length; i++) {
//       //   LatLng coordinates = pathCoordinates[i];
//       //   Symbol symbol = await controller!.addSymbol(SymbolOptions(
//       //     geometry: coordinates,
//       //     iconImage: i == pathCoordinates.length - 1 ? 'location1' : 'point1', // Use 'location1' for the latest location, 'point1' for others
//       //     iconSize: 3,
//       //     textField: i == pathCoordinates.length - 1 ? "Here" : '', // Only show text for the latest point
//       //     textOffset: const Offset(0, -2), // Offset the text to the top of the icon
//       //   ));
//       //   allSymbols.add(symbol);
//       // }


//       DatabaseReference dbLoc = FirebaseDatabase.instance.ref('loc');
//       dbLoc.onValue.listen((event) {
//         final data = event.snapshot.value;
//         if (data != null && data is Map<dynamic, dynamic>) {
//           var lastKey = data.keys.last; // Get the last key
//           for (var key in data.keys) {
//             LatLng coordinates = LatLng(data[key]['lat'], data[key]['lng']);
//             controller!.addSymbol(SymbolOptions(
//               geometry: coordinates,
//               iconImage: key == lastKey ? 'location1' : 'point1', // Use 'location1' for the latest location, 'point1' for others
//               iconSize: 3,
//               textField: key == lastKey ? "Here" : '', // Only show text for the latest point
//               textOffset: const Offset(0, -2), // Offset the text to the top of the icon
//             )).then((symbol) {
//               allSymbols.add(symbol);
//             });
//           }
//         }
//       });
//     }
//   }
// }
