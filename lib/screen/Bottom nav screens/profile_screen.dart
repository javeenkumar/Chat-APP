import 'package:chatapp/CustomWidgets/button.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../CustomWidgets/Profile Widget/profile_dialogbox.dart';
import '../../CustomWidgets/Profile Widget/profile_firebase_services.dart';
import '../../CustomWidgets/Profile Widget/profile_reusable.dart';
import '../login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ref = FirebaseDatabase.instance.ref('user');
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .1),
        child: StreamBuilder(
          stream: ref.child(SessionController.userId.toString()).onValue,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('error...'));
              } else if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                Map<dynamic, dynamic> profiledata =
                    snapshot.data.snapshot.value;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            showDialogPickerDialog(context);
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black87,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child:
                                      profiledata['profile'] == null ||
                                          profiledata['profile']
                                              .toString()
                                              .isEmpty
                                      ? Center(
                                          child: Icon(
                                            Icons.person_outlined,
                                            size: 50,
                                            color: Colors.grey.shade700,
                                          ),
                                        )
                                      : Image.network(
                                          profiledata['profile'],
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                                strokeWidth: 2,
                                                color: Colors.blueAccent,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Center(
                                                    child: Icon(
                                                      Icons.person_outlined,
                                                      size: 50,
                                                      color:
                                                          Colors.grey.shade700,
                                                    ),
                                                  ),
                                        ),
                                ),
                              ),

                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.greenAccent.shade700,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(4),
                                  constraints: BoxConstraints(),
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          spacing: 10,
                          children: [
                            ReusableRow(
                              name: profiledata['username'],
                              value: "Username",
                              icon: const Icon(Icons.person),
                              onChanged: (newValue) async {
                                await FirebaseDatabaseService.updateUserField(
                                  context,
                                  'username',
                                  newValue,
                                );
                              },
                            ),
                            Divider(height: 1, color: Colors.black54),
                            ReusableRow(
                              name: profiledata['phone'] ?? "xxxx-xxxxxxx",
                              value: 'Phone',
                              icon: Icon(Icons.local_phone_outlined),
                              onChanged: (newValue) async {
                                await FirebaseDatabaseService.updateUserField(
                                  context,
                                  'phone',
                                  newValue,
                                );
                              },
                            ),
                            Divider(height: 1, color: Colors.black54),
                            ReusableRow(
                              name: profiledata['email'] ?? "-------",
                              value: 'Email',
                              icon: Icon(Icons.email_outlined),
                            ),
                            Divider(height: 1, color: Colors.black54),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      ElButton(
                        context,
                        Colors.white70,
                        text: 'Logout',
                        fontSize: 16,
                        borderWidth: 1,
                        borderColor: Colors.black,
                        width: MediaQuery.of(context).size.width * .9,
                        fweight: FontWeight.w500,
                        onPressed: () {
                          _auth.signOut().then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
