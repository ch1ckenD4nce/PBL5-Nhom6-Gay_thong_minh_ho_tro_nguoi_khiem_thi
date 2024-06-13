
import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:gpsapp3/src/components/drawer.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class MapPage extends StatefulWidget {
 @override
 _MapPageState createState() => _MapPageState();
}


class _MapPageState extends State<MapPage> {
 MapboxMapController? controller;
 final FirebaseAuth _auth = FirebaseAuth.instance;
 User? _currentUser;
 DatabaseReference dbuser = FirebaseDatabase.instance.ref();
 DatabaseReference dbgps = FirebaseDatabase.instance.ref();
//  double lat_root = 16.486982026328814; // Default latitude
//  double lng_root = 107.57884153749028; // Default longitude 
 double lat_root = 16.47113393041211; // Default latitude   16.47113393041211, 107.58760160609695
 double lng_root = 107.58760160609695; // Default longitude 
 bool loadingData = true; // Flag to indicate data loading
 String _seri = '';
 List<LatLng> pathCoordinates = [];
 Map map_latlng_key = {};
 List<Symbol> allSymbols = [];
 double lat_last = 0.0;
 double lng_last = 0.0;
 int number_point = 1;   // giới hạn số điểm lấy ra 
 String textFieldValue = '';
 String _address = '';
 String _address_location = '';
 String _address_icon = '';
 bool _cameraAnimated = false;
  late StreamSubscription _subscription;

 @override
 void initState() {
   super.initState();
   _getCurrentUser();
   _subscription = _listenForData();
  //  _listenForData();
 }

 @override
  void dispose() {
    // Cancel the stream subscription when the widget is disposed
    _subscription.cancel();
    super.dispose();
    print("=======================================================================================================");
    print("Mâpge Stop listen data --------------------------------------------------------------------------------");
    print("=======================================================================================================");
  }

 Future<void> _getCurrentUser() async {
   User? user = _auth.currentUser;
   // ignore: unused_local_variable
   String seri = '';
   if (user != null) {
     setState(() {
       _currentUser = user;
       dbuser = FirebaseDatabase.instance.ref('USER').child(_currentUser!.uid);
     });
     _getSeri();
   }
 }

 void _getSeri() {
   dbuser.onValue.listen((event) {
     final data = event.snapshot.value;
     if (data != null && data is Map<dynamic, dynamic>) {
       setState(() {
         _seri = data['seri'] ?? ''; // Set default value if 'Seri' is missing
         dbgps = FirebaseDatabase.instance.ref('GPS').child(_seri);
       });
       _readPoint();
      //  _focusLastPoint();
      //  addSymbolToMap();
     }
   });
 }

  // hàm đọc ra N điểm cuối cùng lấy ra 1 điểm cuối cùng để focus
  void _readPoint() {
    dbgps.once().then((DatabaseEvent event) {
      final data = event.snapshot.value;
      if(data != null && data is Map<dynamic, dynamic>) {
        var keys = data.keys.toList();
        keys.sort((a, b) => a.compareTo(b));

        var lastKey = keys.last;
        print("lastkey");
        print(lastKey);


        if(keys.length > number_point) {
          keys = keys.sublist(keys.length - number_point);
        }
        for(var key in keys){
          if (key == lastKey) {
            lat_last = data[key]['LAT'];
            lng_last = data[key]['LNG'];
          }
        }
        for(var key in keys){
          print("=================================: "+key);
          print(key.runtimeType);
          LatLng coordinates = LatLng(data[key]['LAT'], data[key]['LNG']);
          pathCoordinates.add(coordinates);
          map_latlng_key[coordinates] = key;
        }
        for(var a in pathCoordinates) {
          print("____________________"+a.toString());
        }
      }
      _loc(lat_last, lng_last);
    });
  }

  void _loc(double a, double b) {
     getAddressFromLatLng(LatLng(a, b)).then((address) {
        setState(() {
          _address = address;
        });
      _focusLastPoint();
      });
  }

  // focus vào điểm cuối cùng
  void _focusLastPoint() {
    // controller?.animateCamera(CameraUpdate.newLatLng(LatLng(lat_last, lng_last)));
    if (!_cameraAnimated) {
      controller?.animateCamera(CameraUpdate.newLatLng(LatLng(lat_last, lng_last)));
      _cameraAnimated = true; // Set the flag to true after the first animation
    }

    addSymbolToMap();
  }


  // hàm theo dõi sự thay đổi của firebase
  StreamSubscription  _listenForData() {
    return dbgps.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<dynamic, dynamic>) {
        setState(() {
          removeSymbolFromMap();
        });
      }
    });
  }

  // hàm thêm vị trí local
  void addCurrentLocationToMap() async {
    if (controller != null) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      controller!.addSymbol(SymbolOptions(
        geometry: LatLng(position.latitude, position.longitude),
        iconSize: 3,
        iconImage: 'marker-15'
      ));
    }
  }

  void _focusRootPoint() async{
    if (controller != null) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat_root = position.latitude;
      lng_root = position.longitude;
    }
    loadingData = false;
  }

  void removeSymbolFromMap() async {
    if (controller != null) {
      List<Symbol> symbolsCopy = List<Symbol>.from(allSymbols);
      for (Symbol symbol in symbolsCopy) {
        await controller!.removeSymbol(symbol);
      }
      allSymbols.clear();
    }
    removePathCoordinates();
  }

  void removePathCoordinates() {
    pathCoordinates.clear();
    _readPoint();
  }

  // hàm vẽ icon
  void addSymbolToMap() async {
    if (controller != null) {
      final ByteData byteData1 = await rootBundle.load('assets/images/location1.png');
      final Uint8List bytes1 = byteData1.buffer.asUint8List();
      await controller!.addImage('location1', bytes1);

      final ByteData byteData2 = await rootBundle.load('assets/images/point1.png'); // Replace with your old location icon path
      final Uint8List bytes2 = byteData2.buffer.asUint8List();
      await controller!.addImage('point1', bytes2);

      for (int i = 0; i < pathCoordinates.length; i++) {
        LatLng coordinates = pathCoordinates[i];
        Symbol symbol = await controller!.addSymbol(SymbolOptions(
          geometry: coordinates,
          iconImage: i == pathCoordinates.length - 1 ? 'location1' : 'point1', // Use 'location1' for the latest location, 'point1' for others
          iconSize: i == pathCoordinates.length - 1 ? 3 : 2,
          textField: i == pathCoordinates.length - 1 ? "Here" : '', // Only show text for the latest point
          textOffset: const Offset(0, -2),
          // màu đỏ
          textColor: '#ff0000',
        ));
        allSymbols.add(symbol);
      }
    }
  }

  Future<String> getAddressFromLatLng(LatLng coordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      if (place != null && place.street != null) {
        String street = place.street ?? '';
        String subLocality = place.subLocality ?? '';
        String locality = place.locality ?? '';
        String administrativeArea = place.administrativeArea ?? '';
        String country = place.country ?? '';

        String text = '';
        if (street != '') {
          text += street;
        } 
        if (subLocality != '') {
          text += ', $subLocality';
        }
        if (locality != '') {
          text += ', $locality';
        }
        if (administrativeArea != '') {
          text += ', $administrativeArea';
        } 
        if (country != '') {
          text += ', $country';
        }
        return text;
      }
    }
    return "Unknown location";
  }

  // Lấy địa chỉ khi nhấn vào Icon
  Future<String> getAddressFromIcon(LatLng coordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      if (place != null && place.street != null) {
        String street = place.street ?? '';
        return street;
      }
    }
    return "Unknown location";
  }

  Future<String> getAddressAndTimeFromIcon(LatLng coordinates) async {
    String keyString = map_latlng_key[coordinates];
    print("Key: $keyString");
    double keyDouble = double.parse(keyString);

    // Xử lý trường hợp key không được tìm thấy
    if (keyString == null) {
      return "Vị trí và thời gian không xác định";
    }

    // Chuyển đổi key sang milliseconds kể từ epoch
    int timestampMilliseconds = (keyDouble).toInt();

    // Chuyển đổi sang đối tượng DateTime
    DateTime datetimeObj = DateTime.fromMillisecondsSinceEpoch(timestampMilliseconds);

    String street = '';
    List<Placemark> placemarks = await placemarkFromCoordinates(coordinates.latitude, coordinates.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      if (place != null && place.street != null) {
        street = place.street ?? '';
      }
    }
    String time = datetimeObj.toString();
    // return street + time;
    return "$street vào lúc ${datetimeObj.toString()}";
  }



  

  // hàm lấy vị trí cụ thể hiện tại
  Future<String> getAddressLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      if (place != null && place.street != null) {
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
      }
    }
    return "Unknown location";
  }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Map Page',
         style: TextStyle(color: Colors.white),
       ),
       backgroundColor: const Color(0xff000D2D),
       iconTheme: const IconThemeData(
         color: Colors.white, // Màu trắng cho biểu tượng menu
       ),
     ),
     drawer: profileUser(),
    //  body: crearMap(),
    body: Stack(
      children: [
        crearMap(),
        Positioned(
          top: 10.0,
          left: 10.0,
          right: 10.0,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // This makes the corners rounded
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_pin, size: 30,), // Replace with your desired icon
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _address,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              _address_icon.isEmpty
              ? Container()
              : Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0), // This makes the corners rounded
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 30,), // Replace with your desired icon
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        _address_icon,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
     floatingActionButton: buttonAction(),
   );
 }

  MapboxMap crearMap () {
   return MapboxMap(
     accessToken:
     'sk.eyJ1IjoiYmFvbG9jIiwiYSI6ImNsdmY2anN3bTBpMXgyaXA1NWdkOHY3OXAifQ.sS1ejJ6fIb8_lU9ob4u6Hw',
     initialCameraPosition: CameraPosition(
       target: LatLng(lat_root, lng_root),
       zoom: 12.0,
     ),
     onMapCreated: (MapboxMapController controller) {
          this.controller = controller;
        // ================thêm sự kiện nhấn=====================
        controller.onSymbolTapped.add((symbol) async {
              // Get the index of the tapped symbol in the allSymbols list
              int symbolIndex = allSymbols.indexWhere((s) => s.id == symbol.id);

              // Call getAddressFromIcon with the symbol's LatLng
              LatLng symbolLatLng = allSymbols[symbolIndex].options.geometry ?? LatLng(0, 0);
              print('Geometry type: ${allSymbols[symbolIndex].options.geometry.runtimeType}');
              // String address = await getAddressFromIcon(symbolLatLng);
              String address = await getAddressAndTimeFromIcon(symbolLatLng);

              setState(() {
                _address_icon = address; // Replace with your desired address
              });
            });
     },
     onMapClick: (point, latLng) async {
        setState(() {
            _address_icon = ''; // Or set to an empty string: _address_icon = '';
          });
      },
      myLocationEnabled: true,
   );
 }


 Column buttonAction() {
   return Column(
     mainAxisAlignment: MainAxisAlignment.end,
     children: [
      FloatingActionButton(
        heroTag: "btn_up_time",
         child: const Icon(Icons.add),
         onPressed: () {
          number_point += 10;
          removeSymbolFromMap();
         },
       ),
       const SizedBox(height: 5,),
       FloatingActionButton(
        heroTag: "btn_down_time",
         child: const Icon(Icons.remove),
         onPressed: () {
          if(number_point <= 10) {
            number_point = 1;
          } else {
          number_point -= 10;
          }
          removeSymbolFromMap();
         },
       ),
       const SizedBox(height: 5,),
       FloatingActionButton(
        heroTag: "btn_zoom",
         child: const Icon(Icons.zoom_in),
         onPressed: () {
           controller?.animateCamera(CameraUpdate.zoomIn());
         },
       ),
       const SizedBox(height: 5,),
       FloatingActionButton(
        heroTag: "btn_zoom_out",
         child: const Icon(Icons.zoom_out),
         onPressed: () {
           controller?.animateCamera(CameraUpdate.zoomOut());
         },
       ),
       const SizedBox(height: 5,),
       
       FloatingActionButton(
        heroTag: "btn_back",
         child: const Icon(Icons.my_location),
         onPressed: () {
          controller!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(lat_last, lng_last),
            ),
          );
         },
       ),
       const SizedBox(height: 5,),
     ],
   );
 }
}


// 107.58855329400487
// 16.469277770943016