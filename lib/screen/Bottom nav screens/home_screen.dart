import 'package:chatapp/servies/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../servies/provider/home_provider.dart';
import 'Message/message_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          if (!provider.usersLoaded || !provider.messagesLoaded) {
            return Center(child: CircularProgressIndicator());
          }

          final chatUsers = provider
              .getUsersWithChat()
              .where((user) => user['uid'] != SessionController.userId)
              .toList();

          if (chatUsers.isEmpty) {
            return Center(child:  Text(
              "No chat yet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),);
          }

          return ListView.builder(
            itemCount: chatUsers.length,
            itemBuilder: (context, index) {
              final user = chatUsers[index];
              final lastMsg = provider.getLastMessage(user['uid']);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: ListTile(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                          receiverId: user['uid'].toString(),
                          username: user['username'].toString(),
                          email: user['email'].toString(),
                          img: user['profile'].toString(),
                          deviceToken: user['deviceToken'].toString(),

                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 23,
                    backgroundImage: (user['profile'] ?? "").isNotEmpty
                        ? NetworkImage(user['profile'])
                        : null,
                    child: (user['profile'] ?? "").isEmpty
                        ? Icon(Icons.person)
                        : null,
                  ),
                  title: Text(user['username'] ?? "Unknown"),
                  subtitle: Text(lastMsg,maxLines: 1,
                    overflow:TextOverflow.ellipsis,
                  ),
                  trailing: provider.getUnreadCount(user['uid']) > 0
                      ? CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blueAccent.shade200,
                    child: Text(
                      provider.getUnreadCount(user['uid']).toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
