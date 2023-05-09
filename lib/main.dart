import 'package:flutter/material.dart';
import 'package:project_web/restaurantMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //String url = Uri.base.toString(); //url yi çekmek için
  //qr koddan gelen url path formatı = /?id="restaurantID"&tableNo="tableNo"
  //örnek url https://restaurantapp-2a43d.web.app/?id=vAkYpJA6Pd6UTEPDysvj&tableNo=1
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
      id: "qVu4d36x4BY9opVCDbtr",
      tableNo: "1",
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.id, required this.tableNo});
  final String id, tableNo;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: myColor,
      ),
      home: MenuScreen(
        id: id,
        tableNo: tableNo,
      ),
    );
  }
}