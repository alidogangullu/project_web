import 'package:flutter/material.dart';
import 'package:project_web/restaurantMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {

  //String url = Uri.base.toString();
  //?para1=abc&para2=1
  String? para1 = Uri.base.queryParameters["para1"];
  String? para2 = Uri.base.queryParameters["para2"];
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(para1!=null && para2!=null) {
    runApp(MyApp(para1: para1, para2: para2,));
  } else {
    runApp(const MyApp(para1: "abc", para2: "para2",));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.para1, required this.para2});
  final String para1, para2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: para1,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(para1: para1, para2: para2,),
    );
  }
}