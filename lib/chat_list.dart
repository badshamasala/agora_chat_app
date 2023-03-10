import 'package:agora_chat_app/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  final value;
  ChatList({Key? key, required this.value}) : super(key: key);

  ChatController getkar = Get.put(ChatController());

  var list = [
    "rashid",
    "farhan",
  ];

  @override
  Widget build(BuildContext context) {
       print("-------------$value------------");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Chat Application"),
        actions: [
          IconButton(
              onPressed: () {
                getkar.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            name:   value ? list[1] : list[0],
                          )),
                );
              },
              tileColor: Color(0xffe2e2e2),
              title: Text(
                value ? list[1] : list[0],
                style: TextStyle(color: Colors.black),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: 1),
    );
  }
}
