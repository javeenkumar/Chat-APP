
import 'package:chatapp/screen/dashboard_screen.dart';
import 'package:chatapp/screen/login_screen.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashServices {

  void isloding(BuildContext context){
    final _auth = FirebaseAuth.instance;
    var user = _auth.currentUser;
    if(user == null){
      Future.delayed(Duration(seconds: 3),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      });
    }else{
      SessionController.userId = _auth.currentUser!.uid;
      Future.delayed(Duration(seconds: 3),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
      });
    }

  }

}