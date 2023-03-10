import 'package:agora_chat_app/sender_receiver.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SenderReceiver(),
    );
  }
}

/* class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _userId = TextEditingController();
  final _channelName = TextEditingController();

  AgoraRtmClient? _client;
  AgoraRtmChannel? _channel;
  LogController logController = LogController();

  @override
  void initState() {
    super.initState();
    _createClient();
  }

  void _createClient() async {
    _client = await AgoraRtmClient.createInstance("35f0706653e54c508de2e2e27249a234");
    _client!.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      logController.addLog("Private Message from " + peerId + ": " + message.text);
    };
    _client!.onConnectionStateChanged = (int state, int reason) {
      logController.addLog('Connection state changed: ' + state.toString() + ', reason: ' + reason.toString());
      if (state == 5) {
        _client!.logout();
        logController.addLog('Logout.');
      }
    };
  }

  void _login(BuildContext context) async {
    String userId = _userId.text;
    if (userId.isEmpty) {
      print('Please input your user id to login.');
      return;
    }

    try {
      await _client!.login("007eJxTYCiPmqi4stLD6U/chT1/Pv/m4bklvOXpJ62XVqmzs5oFbOoVGIxN0wzMDczMTI1TTU2STQ0sUlKNQNDcyMQy0cjY5NdK1pSGQEaG7K9XWBgZWBkYgRDEV2EwSbG0NE80NNBNSkpL1jU0TE3RtUhOS9M1TjO3NE+2NDc1Nk4CAOQpKM8=", userId);
      logController.addLog('Login success: ' + userId);
      _joinChannel(context);
    } catch (errorCode) {
      print('Login error: ' + errorCode.toString());
    }
  }

  void _joinChannel(BuildContext context) async {
    String channelId = _channelName.text;
    if (channelId.isEmpty) {
      logController.addLog('Please input channel id to join.');
      return;
    }

    try {
      _channel = await _createChannel(channelId);
      await _channel!.join();
      logController.addLog('Join channel success.');
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MessageScreen(
                    client: _client!,
                    channel: _channel!,
                    logController: logController,
                  )));
    } catch (errorCode) {
      print('Join channel error: ' + errorCode.toString());
    }
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel? channel = await _client!.createChannel(name);
    channel!.onMemberJoined = (AgoraRtmMember member) {
      logController.addLog("Member joined: " + member.userId + ', channel: ' + member.channelId);
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      logController.addLog("Member left: " + member.userId + ', channel: ' + member.channelId);
    };
    channel.onMessageReceived = (AgoraRtmMessage message, AgoraRtmMember member) {
      logController.addLog("Public Message from " + member.userId + ": " + message.text);
    };
    return channel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Real Time Message'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(controller: _userId, decoration: InputDecoration(hintText: 'User ID')),
            TextField(controller: _channelName, decoration: InputDecoration(hintText: 'Channel')),
            OutlinedButton(child: Text('Login'), onPressed: () => _login(context)),
          ],
        ),
      ),
    );
  }
} */