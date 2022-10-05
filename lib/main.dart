import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyAppState extends State<MyApp> {
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

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("임신사")
                  ],
                ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: <Widget>[
                  OutlinedButton(
                      onPressed: (){},
                      child: const Text('OCR')
                  ),
                  OutlinedButton(
                      onPressed: (){},
                      child: const Text('기록')
                  ),
                  OutlinedButton(
                      onPressed: (){},
                      child: const Text('그래프')
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("분만사")
                ],
              ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlinedButton(
                        onPressed: (){},
                        child: const Text('OCR')
                    ),
                    OutlinedButton(
                        onPressed: (){},
                        child: const Text('기록')
                    ),
                    OutlinedButton(
                        onPressed: (){},
                        child: const Text('그래프')
                    ),
                  ],
                ),
              ]
        )
      )
    );
  }
}
