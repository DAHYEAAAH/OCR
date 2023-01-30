import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      
      child: Column(
        children: [
          Text('Result page',style: TextStyle(color: Colors.white,fontSize: 20),),

        ],
      ),
    );
  }
}
