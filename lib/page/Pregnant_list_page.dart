import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PregnantListPage extends StatefulWidget {
  @override
  PregnantListPageState createState() => PregnantListPageState();
}
class MyHomePage extends StatefulWidget {

  @override
  PregnantListPageState createState() => PregnantListPageState();
}

class PregnantListPageState extends State<PregnantListPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //   title: 'OCR',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      title: 'Flutter Demo',
      home: MyHomePage(),

    );
  }
}