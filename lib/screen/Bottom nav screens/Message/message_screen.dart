import 'package:chatapp/CustomWidgets/Utilities/ToastMessage.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../../CustomWidgets/Utilities/getName.dart';
import '../../../servies/Notification/notificationApi.dart';

class MessageScreen extends StatefulWidget {
  final String receiverId;
  final String username;
  final String email;
  final String img;
  final String deviceToken;
  final String nameTittle;

  MessageScreen({
    super.key,
    required this.receiverId,
    required this.username,
    required this.email,
    required this.img,
    required this.deviceToken,
  }) : nameTittle = SessionController.name ?? "";

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}


class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController message = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('chat');
  final ScrollController _scrollController = ScrollController();
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    markMessagesSeen();
  }

  void markMessagesSeen() async {
    final currentUserId = SessionController.userId.toString();

    final snapshot = await ref.get();

    for (var child in snapshot.children) {
      final senderId = child.child('senderId').value?.toString();
      final receiverId = child.child('reciverId').value?.toString();
      final isSeen = child.child('isSeen').value ?? false;

      if (senderId == widget.receiverId &&
          receiverId == currentUserId &&
          isSeen != true) {
        await ref.child(child.key!).update({'isSeen': true});
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade300,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          widget.username,
          style: const TextStyle(fontSize: 22, color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              // reverse: false,
              query: ref,
              controller: _scrollController,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, snapshot, animation, index) {

                markMessagesSeen();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });
                final messageText = snapshot.child('message').value?.toString() ?? '';
                final senderId = snapshot.child('senderId').value?.toString() ?? '';
                final reciverId = snapshot.child('reciverId').value?.toString() ?? '';
                final currentUserId = SessionController.userId.toString();

                if ((senderId == currentUserId && reciverId == widget.receiverId) ||
                    (senderId == widget.receiverId && reciverId == currentUserId)) {
                  return Align(
                    alignment: senderId == currentUserId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: senderId == currentUserId
                            ? Colors.yellow.shade200
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                          messageText,
                          style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),

          Container(
            margin: const EdgeInsets.only(bottom: 10, left: 8, right: 8, top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: message,
                    maxLines: 5,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: SendMessage,

                    icon: const Icon(Icons.send, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void SendMessage() {
    if (message.text.trim().isEmpty) {
      ToastMessage('Please enter a message', false);
      return;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    ref.child(timestamp).set({
      'isSeen': false,
      'time': timestamp,
      'message': message.text.trim(),
      'senderId': SessionController.userId.toString(),
      'reciverId': widget.receiverId,
      'type': 'text',
    }).then((value) {

      UserService.loadUserName();

      sendNotificationFromFlutter(
          deviceToken: widget.deviceToken.toString(),
          title: widget.nameTittle,
          body: message.text,
          data: {
            'screen':'message_screen',
            'title': widget.nameTittle,
            'sms': message.text
          }
      );

      message.clear();

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      });
    }).onError((error, stacktrace) {
      ToastMessage(error.toString(), true);
      debugPrint(error.toString());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    message.dispose();
    super.dispose();
  }
}
