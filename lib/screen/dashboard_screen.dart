import 'package:chatapp/screen/Bottom%20nav%20screens/home_screen.dart';
import 'package:chatapp/screen/Bottom%20nav%20screens/profile_screen.dart';
import 'package:chatapp/servies/provider/dashboard_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../servies/session_controller.dart';
import 'Bottom nav screens/friend_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Widget> ScreenList = [HomeScreen(), FriendScreen(), ProfileScreen()];

  List<BottomNavigationBarItem> baritem = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
    BottomNavigationBarItem(
      icon: Icon(Icons.people_alt_outlined),
      label: 'Friend',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: ScreenList[provider.currentindex],

          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  items: baritem,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.yellowAccent,
                  currentIndex: provider.currentindex,
                  selectedItemColor: Colors.blueAccent,
                  unselectedItemColor: Colors.black54,
                  showUnselectedLabels: true,
                  selectedFontSize: 14,
                  unselectedFontSize: 12,
                  iconSize: 26,
                  elevation: 8,
                  onTap: (value) {
                    setState(() {
                      provider.Setcurrentindex = value;
                    });
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
