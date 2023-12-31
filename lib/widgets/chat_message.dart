import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUSer = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapShots) {
        if (chatSnapShots.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapShots.hasData || chatSnapShots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No message found....'),
          );
        }

        if (chatSnapShots.hasError) {
          return const Center(
            child: Text('Something went wrong....'),
          );
        }

        final loadMessage = chatSnapShots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadMessage.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadMessage[index].data();
            final nextChatMessage = index + 1 < loadMessage.length
                ? loadMessage[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUSer.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['userImage'],
                userName: chatMessage['userName'],
                message: chatMessage['text'],
                isMe: authenticatedUSer.uid == currentMessageUserId,
              );
            }
          },
        );
      },
    );
  }
}
