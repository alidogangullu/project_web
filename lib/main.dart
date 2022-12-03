import 'package:flutter/material.dart';

void main() {

  String url = Uri.base.toString();
  String? para1 = Uri.base.queryParameters["para1"];
  String? para2 = Uri.base.queryParameters["para2"];
  if(para1!=null && para2!=null) {
    runApp(MyApp(para1: para1, para2: para2,));
  } else {
    runApp(const MyApp(para1: "para1", para2: "para2",));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.para1, required this.para2});
  final String para1, para2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Web',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(para1: para1, para2: para2,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.para1, required this.para2});

  final String para1;
  final String para2;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.para1+widget.para2),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Restaurant: ${widget.para1}',
            ),
            Text(
              'Table No: ${widget.para2}',
            ),
          ],
        ),
      ),
    );
  }
}