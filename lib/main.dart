import 'package:flutter/material.dart';

void main() {

  String path = Uri.base.path.toString();
  path = path.substring(1);

  runApp(MyApp(title: path,));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Web',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Restaurant: ${widget.title.split("/").first}',
            ),
            Text(
              'Table No: ${widget.title.split("/").last}',
            ),
          ],
        ),
      ),
    );
  }
}