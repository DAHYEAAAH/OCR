import 'dart:convert';
import 'package:flutter/material.dart';
import '../../views/chats/detail_screen.dart';
import 'package:get/get.dart' hide Response;

class ReceiverMessageCard extends StatelessWidget {
  const ReceiverMessageCard({Key? key, required this.name, this.message, required this.time, this.chatType, this.avatar}) : super(key: key);
  final String? name;
  final String? message;
  final String? chatType;
  final String? time;
  final String? avatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child:
            avatar != null && avatar != '' ?
            Image.network(
              avatar!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ) : Container(
              width: 50,
              height: 50,
              color: Colors.teal,
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white70,
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 180,
                    ),
                    child: Column(
                      children: [
                        if(chatType == 'text')
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.white,
                            margin: EdgeInsets.only(right: 5, left: 0, top: 5),
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
                            padding: const EdgeInsets.only(right: 5, left: 0, top: 5),
                            child: Image.asset(
                              message!,
                              width: 50,
                              height: 50,
                            ),
                          )
                        else if (chatType == 'image')
                            Padding(
                              padding: const EdgeInsets.only(right: 5, left: 0, top: 5),
                              child: GestureDetector(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.memory(
                                      base64.decode(message!),
                                      width: 500),
                                ),
                                onTap: () {
                                  Get.to(() => DetailScreen(sender: name, time: time,  url: message));
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
                  Text(
                    time!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
