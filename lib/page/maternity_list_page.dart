import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MaternitytListPage extends StatefulWidget {
  @override
  MaternitytListPageState createState() => MaternitytListPageState();
}
class MyHomePage extends StatefulWidget {

  @override
  MaternitytListPageState createState() => MaternitytListPageState();
}

class MaternitytListPageState extends State<MaternitytListPage> {
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