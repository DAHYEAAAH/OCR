import 'dart:convert';
import '../../views/chats/detail_screen.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({Key? key, this.message, required this.time, this.chatType, this.name}) : super(key: key);
  final String? name;
  final String? message;
  final String? chatType;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 80,
          ),
          child: Column(
            children: [
              if(chatType == 'text')
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  // color: Color(0xFFcfe6ff),
                  color: Color(0xFFfef01b),
                  margin: EdgeInsets.only(right: 15, left: 5, top: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      message!,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ),
                )
              else if(chatType == 'emoji')
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 5, top: 15),
                  child: Image.asset(
                    message!,
                    width: 50,
                    height: 50,
                  ),
                )
              else if (chatType == 'image')
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 5, top: 15),
                child: GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.memory(
                        base64.decode(message!),
                        ),
                  ),
                  onTap: () {
                    Get.to(() => DetailScreen(sender: name, time: time,  url: message));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
