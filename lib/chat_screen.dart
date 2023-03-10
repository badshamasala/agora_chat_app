import 'package:agora_chat_app/config.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final String name;
  ChatScreen({Key? key, required this.name}) : super(key: key);

  ChatController getkar = Get.put(ChatController());

  TextEditingController chatCont = TextEditingController();

  bool? isUserSender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        bottomSheet: Padding(
          padding: const EdgeInsets.all(0.0),
          child: GetBuilder<ChatController>(builder: (controller) {
            return TextField(
              onTap: () {
                print("dsddd--------------------------------------------");
                getkar.scrollUp();
              },
              onChanged: (msg) => getkar.messageContent = msg,
              controller: chatCont,
              autofocus: true,
              decoration: InputDecoration(
                  prefixIconConstraints: BoxConstraints(),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        await getkar.sendMessage(name, chatCont.text);
                        isUserSender = true;
                        chatCont.clear();
                        getkar.scrollUp();
                      },
                      icon: const Icon(Icons.send)),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.person),
                  ),
                  isDense: true,
                  hintText: "Enter Message",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10)),
            );
          }),
        ),
        appBar: AppBar(
          elevation: 0,
          title: Text(name),
        ),
        body: GetBuilder<ChatController>(
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 60),
              child: ListView.separated(
                  clipBehavior: Clip.none,
                  shrinkWrap: true,
                  controller: getkar.scrollController,
                  /*      reverse: true, */
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: isUserSender == true
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: const Color(0xffFCAFAF)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(getkar.logText[index]),
                            )),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 5,
                    );
                  },
                  itemCount: getkar.logText.length),
            );
          },
        ));
  }
}

class ChatController extends GetxController {
  bool? isSender;
  final RxList<dynamic> logText = [].obs;
  String? messageContent, chatId;
  RxString newText = "".obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    print(
        "--------------------------------onInIT Call Hua-----------------------------------");
    initSDK();
    addChatListener();

    super.onInit();
  }

  scrollUp() {
    update();
    return SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.fastOutSlowIn);
    });
  }

  signIn(userId, agoraToken) async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(userId, agoraToken);
      print("login succeed, userId: $userId");
      /*   logText.add("login succeed, userId: ${AgoraChatConfig.userId}"); */
    } on ChatError catch (e) {
      print("login failed, code: ${e.code}, desc: ${e.description}");
    }
    update();
  }

  signOut() async {
    try {
      await ChatClient.getInstance.logout(true);
      print("sign out succeed");
    } on ChatError catch (e) {
      print("sign out failed, code: ${e.code}, desc: ${e.description}");
    }
    update();
  }

  onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            print(
              "receive text message: ${body.content}, from: ${msg.from}",
            );
            logText.add(body.content);
          }

          break;
        case MessageType.IMAGE:
          {
            print(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            print(
              "receive video message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            print(
              "receive location message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            print(
              "receive voice message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.FILE:
          {
            print(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            print(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {
            // Receiving command messages does not trigger the `onMessagesReceived` event, but triggers the `onCmdMessagesReceived` event instead.
          }
          break;
      }
    }
    update();
  }

  sendMessage(chatId, messageContent) async {
    if (chatId == null || messageContent == null) {
      print("single chat id or message content is null");
      return;
    }

    var msg = ChatMessage.createTxtSendMessage(
      targetId: chatId!,
      content: messageContent!,
    );
    logText.add("$messageContent");

    msg.setMessageStatusCallBack(MessageStatusCallBack(
      onSuccess: () {
        print("send message: $messageContent");
      },
      onError: (e) {
        print(
          "send message failed, code: ${e.code}, desc: ${e.description}",
        );
      },
    ));
    ChatClient.getInstance.chatManager.sendMessage(msg);
    update();
  }

  initSDK() async {
    ChatOptions options = ChatOptions(
      appKey: AgoraChatConfig.appkey,
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);
    // Notify the SDK that the UI is ready. After the following method is executed, callbacks within `ChatRoomEventHandler`, ` ChatContactEventHandler`, and `ChatGroupEventHandler` can be triggered.
    await ChatClient.getInstance.startCallback();
    update();
  }

  addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
    update();
  }
}
