import 'package:agora_chat_app/chat_list.dart';
import 'package:agora_chat_app/chat_screen.dart';
import 'package:agora_chat_app/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SenderReceiver extends StatelessWidget {
  SenderReceiver({Key? key}) : super(key: key);

  ChatController getkar = Get.put(ChatController());
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sender and Reciever"),
      ),
      body: Column(
        children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    getkar.isSender = true;
                    await getkar
                        .signIn(
                            getkar.isSender!
                                ? AgoraChatConfig.userId
                                : AgoraChatConfig1.userId,
                            getkar.isSender!
                                ? AgoraChatConfig.agoraToken
                                : AgoraChatConfig1.agoraToken);
               
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatList(value: getkar.isSender,)),
                      );
                  
                  },
                  child: Text("Sender")),
              ElevatedButton(
                  onPressed: () async {
                    getkar.isSender = false;

                    await getkar
                        .signIn(
                            getkar.isSender!
                                ? AgoraChatConfig.userId
                                : AgoraChatConfig1.userId,
                            getkar.isSender!
                                ? AgoraChatConfig.agoraToken
                                : AgoraChatConfig1.agoraToken);
                  
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatList(value: getkar.isSender)),
                      );
                   
                  },
                  child: Text("Reveiver")),
            ],
          ),
          Spacer()
        ],
      ),
    );
  }
}
