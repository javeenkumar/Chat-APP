import 'dart:async';

import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Message/message_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference chatRef = FirebaseDatabase.instance.ref('chat');
  final DatabaseReference userRef = FirebaseDatabase.instance.ref('user');

  Map<String, String> chatUsersLastMessage = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadChatUsers();
  }

  Future<void> _loadChatUsers() async {
    final currentUserId = SessionController.userId.toString();

    DataSnapshot snapshot = await chatRef.get();
    Map<String, String> tempMessages = {};

    for (var child in snapshot.children) {
      final senderId = child.child('senderId').value.toString();
      final reciverId = child.child('reciverId').value.toString();
      final message = child.child('message').value.toString();

      String chatUserId = '';
      if (senderId == currentUserId) {
        chatUserId = reciverId;
      } else if (reciverId == currentUserId) {
        chatUserId = senderId;
      } else {
        continue;
      }
      tempMessages[chatUserId] = message;
    }

    setState(() {
      chatUsersLastMessage = tempMessages;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade300,
        title: const Text(
          'Chats',
          style: TextStyle(fontSize: 24, color: Colors.black87),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 6, left: 3, right: 3),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : chatUsersLastMessage.isEmpty
            ? const Center(child: Text('No chats yet.'))
            : StreamBuilder(
          stream: userRef.onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.data?.snapshot.value == null) {
              return const Center();
            }

            Map<dynamic, dynamic> users =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

            final filteredUsers = users.entries
                .where((entry) =>
                chatUsersLastMessage.keys.contains(entry.key))
                .toList();

            return ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index].value;
                final userId = filteredUsers[index].key;
                final username = user['username'] ?? 'Unknown';
                final email = user['email'] ?? '';
                final img = user['profile'] ?? '';
                final lastMessage =
                    chatUsersLastMessage[userId] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreen(
                            receiverId: userId.toString(),
                            username: username,
                            email: email,
                            img: img,
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                      img.isNotEmpty ? NetworkImage(img) : null,
                      child: img.isEmpty
                          ? const Icon(Icons.person_outline_rounded)
                          : null,
                    ),
                    title: Text(username),
                    subtitle: Text(lastMessage),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
