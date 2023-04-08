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
    runApp(MyApp( //daha sonra id ve tableNo parametre olarak verilecek şuan test için ayarlandı.
      id: "vAkYpJA6Pd6UTEPDysvj",
      tableNo: "1",
    ));
  } else {
    //error case
    runApp(const MyApp(
      id: "vAkYpJA6Pd6UTEPDysvj",
      tableNo: "1",
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.id, required this.tableNo});
  final String id, tableNo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(
        id: id,
        tableNo: tableNo,
      ),
    );
  }
}
