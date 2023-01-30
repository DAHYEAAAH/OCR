import 'package:flutter/material.dart';

class NotificationMessageCard extends StatelessWidget {
  const NotificationMessageCard({Key? key, this.message, this.isDate}) : super(key: key);
  final String? message;
  final bool? isDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          color: Colors.blueGrey.withOpacity(0.2),
          margin: EdgeInsets.only(right: 15, left: 5, top: 15),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
            child: Row(
              children: [
                isDate! ?
                Icon(
                  Icons.date_range_outlined,
                  size: 20,
                  color: Colors.black87,
                ) : SizedBox.shrink(),
                SizedBox(width: 5,),
                Text(
                  message!,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
