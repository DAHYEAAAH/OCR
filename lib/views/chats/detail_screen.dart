import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailScreen extends StatefulWidget {
  final String? sender;
  final String? time;
  final String? url;

  DetailScreen({Key? key, @required this.sender, @required this.url, this.time})
        : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
            color: Colors.white
        ),
        title: Column(
          children: [
            Text(widget.sender!, style: TextStyle(fontSize: 14,),),
            Text(widget.time!, style: TextStyle(fontSize: 14, color: Colors.grey),),
          ],
        ),
      ),
      body: GestureDetector(
        child: Center(
          child: Image.memory(
            base64.decode(widget.url!),
            fit: BoxFit.cover,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}