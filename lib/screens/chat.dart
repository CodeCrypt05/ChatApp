import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Flutter Chat',
          style: TextStyle(
            fontFamily: 'Rubik',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
          )
        ],
      ),
      body: Scaffold(
        backgroundColor: const Color.fromRGBO(245, 249, 255, 1),
        body: Column(
          children: const [
            Expanded(
              child: ChatMessage(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
