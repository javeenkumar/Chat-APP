import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../session_controller.dart';

class ChatProvider with ChangeNotifier {
  ChatProvider() {
    fetchUsers();
    fetchMessages();
  }

  final userRef = FirebaseDatabase.instance.ref('user');
  final chatRef = FirebaseDatabase.instance.ref('chat');

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> messages = [];

  bool usersLoaded = false;
  bool messagesLoaded = false;

  void fetchUsers() {
    userRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        users.clear();
        data.forEach((key, value) {
          if (value is Map) {
            users.add({
              'uid': value['uid']?.toString() ?? "",
              'username': value['username']?.toString() ?? "",
              'email': value['email']?.toString() ?? "",
              'phone': value['phone']?.toString() ?? "",
              'profile': value['profile']?.toString() ?? "",
              'onlineStatus': value['onlineStatus']?.toString() ?? "",
              'deviceToken': value['token']?.toString() ?? "",
            });
          }
        });
        usersLoaded = true;
        print("Users fetched: ${users.length}");
        notifyListeners();
      }
    });
  }

  void fetchMessages() {
    chatRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        messages.clear();

        data.forEach((msgId, value) {
          if (value is Map) {
            messages.add({
              'id': msgId,
              'message': value['message']?.toString() ?? "",
              'senderId': value['senderId']?.toString() ?? "",
              'reciverId': value['reciverId']?.toString() ?? "",
              'time': value['time']?.toString() ?? "0",
              'isSeen': value['isSeen'] ?? false,
              'type': value['type']?.toString() ?? "",
            });
          }
        });

        messages.sort((a, b) =>
            int.parse(a['time']).compareTo(int.parse(b['time'])));
      }
      messagesLoaded = true;
      print("Messages fetched: ${messages.length}");
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> getUsersWithChat() {
    if (!usersLoaded || !messagesLoaded) return [];

    final currentUserId = SessionController.userId.toString();
    List<Map<String, dynamic>> chatUsers = [];

    for (var user in users) {
      if (user['uid'] == currentUserId) continue;

      bool hasChat = messages.any((msg) =>
      (msg['senderId'] == currentUserId &&
          msg['reciverId'] == user['uid']) ||
          (msg['reciverId'] == currentUserId &&
              msg['senderId'] == user['uid']));

      if (hasChat) chatUsers.add(user);
    }

    chatUsers.sort((a, b) {
      final lastA = getLastMessageTime(a['uid']);
      final lastB = getLastMessageTime(b['uid']);
      return lastB.compareTo(lastA);
    });

    print("Chat users count: ${chatUsers.length}");
    return chatUsers;
  }

  String getLastMessage(String uid) {
    final currentUserId = SessionController.userId.toString();
    final userMessages = messages
        .where((msg) =>
    (msg['senderId'] == uid && msg['reciverId'] == currentUserId) ||
        (msg['senderId'] == currentUserId && msg['reciverId'] == uid))
        .toList();

    if (userMessages.isEmpty) return "";

    return userMessages.last['message'] ?? "";
  }

  int getLastMessageTime(String uid) {
    final currentUserId = SessionController.userId.toString();
    final userMessages = messages
        .where((msg) =>
    (msg['senderId'] == uid && msg['reciverId'] == currentUserId) ||
        (msg['senderId'] == currentUserId && msg['reciverId'] == uid))
        .toList();

    if (userMessages.isEmpty) return 0;

    return int.tryParse(userMessages.last['time'] ?? "0") ?? 0;
  }

  int getUnreadCount(String uid) {
    final currentUserId = SessionController.userId.toString();
    return messages
        .where((msg) =>
    msg['senderId'] == uid &&
        msg['reciverId'] == currentUserId &&
        (msg['isSeen'] == false || msg['isSeen'] == null))
        .length;
  }
}
