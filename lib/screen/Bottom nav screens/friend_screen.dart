import 'package:chatapp/screen/Bottom%20nav%20screens/Message/message_screen.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {

  DatabaseReference fatchData = FirebaseDatabase.instance.ref('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade300,
        title: Text(
          'Friends',
          style: TextStyle(fontSize: 24, color: Colors.black87),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: FirebaseAnimatedList(
          query: fatchData,
          itemBuilder: (context, snapshot, animation, index) {
            if (SessionController.userId ==
                snapshot.child('uid').value.toString()) {
              return Container();
            } else {
              return Card(
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                          receiverId: snapshot.child('uid').value.toString(),
                          username: snapshot.child('username').value.toString(),
                          email: snapshot.child('email').value.toString(),
                          img: snapshot.child('profile').value.toString(),
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: snapshot.child('profile').value.toString() != ''
                        ? NetworkImage(snapshot.child('profile').value.toString())
                        : null,
                    child: snapshot.child('profile').value.toString() == ''
                        ? const Icon(Icons.person_outline_rounded, color: Colors.black54)
                        : null,
                  ),

                  title: Text(snapshot.child('username').value.toString()),
                  subtitle: Text(snapshot.child('email').value.toString()),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
