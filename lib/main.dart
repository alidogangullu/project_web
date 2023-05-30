import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:project_web/restaurantMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_web/unauthorizedAction.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //String url = Uri.base.toString(); //url yi çekmek için
  //qr koddan gelen url path formatı = /?id="restaurantID"&tableNo="tableNo"
  //örnek url https://restaurantapp-2a43d.web.app/?id=qVu4d36x4BY9opVCDbtr&tableNo=1
  String? id = Uri.base.queryParameters["id"];
  String? tableNo = Uri.base.queryParameters["tableNo"];
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (id != null && tableNo != null) {
    runApp(MyApp(
      id: id,
      tableNo: tableNo,
    ));
  } else {
    //error case, also for testing
    runApp(MyApp(
      id: "GixzDeIROMDRAn2mAnMG",
      tableNo: "1",
    ));
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.id, required this.tableNo})
      : super(key: key);
  final String id, tableNo;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Location _location = Location();
  double? desiredLatitude;
  double? desiredLongitude;

  @override
  void initState() {
    super.initState();
    _fetchLocationData(widget.id);
  }

  static bool isDesiredLocation(LocationData? locationData, double desiredLatitude, double desiredLongitude) {
    double maxDistanceMeters = 99999;
    if (locationData == null) {
      return false;
    }

    double distanceInMeters = Geolocator.distanceBetween(
      desiredLatitude,
      desiredLongitude,
      locationData.latitude!,
      locationData.longitude!,
    );
    return distanceInMeters <= maxDistanceMeters;
  }

  Future<void> _fetchLocationData(String restaurantId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Restaurants")
        .doc(restaurantId)
        .get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

      if (data['position'] != null) {
        Map<String, dynamic> positionMap = data['position'];

        if (positionMap['geopoint'] != null) {
          // Get the GeoPoint
          GeoPoint geoPoint = positionMap['geopoint'];
          // Print it out or do anything you want with it
          desiredLatitude = geoPoint.latitude;
          desiredLongitude = geoPoint.longitude;
        }
      }
    }
  }

  Future<bool> locationChecker() async {
    LocationData? currentLocation;
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    currentLocation = await _location.getLocation();

    return isDesiredLocation(currentLocation, desiredLatitude!, desiredLongitude!);
  }

  final MaterialColor myColor = const MaterialColor(
    0xFF008C8C,
    <int, Color>{
      50: Color(0xFFE0F2F2),
      100: Color(0xFFB3CCCC),
      200: Color(0xFF80B2B2),
      300: Color(0xFF4D9999),
      400: Color(0xFF267F7F),
      500: Color(0xFF008C8C),
      600: Color(0xFF007474),
      700: Color(0xFF006060),
      800: Color(0xFF004C4C),
      900: Color(0xFF003838),
    },
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: locationChecker(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: myColor,
              ),
              home: MenuScreen(
                id: widget.id,
                tableNo: widget.tableNo,
              ),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: myColor,
              ),
              home: const UnauthorizedActionScreen(
                message: "You have to be at the restaurant to access the menu or you have to give location permission!",
              )
            );
          }
        }
        return const Center(child: CircularProgressIndicator(color: Color(0xFF008C8C),),);
      },
    );
  }
}