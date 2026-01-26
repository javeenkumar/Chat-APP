
import 'package:chatapp/screen/dashboard_screen.dart';
import 'package:chatapp/screen/login_screen.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../CustomWidgets/Utilities/getName.dart';

class SplashServices {


  void isloding(BuildContext context)async{
    final _auth = FirebaseAuth.instance;
    final _database = FirebaseDatabase.instance.ref('user');

    var user = _auth.currentUser;

    if(user == null){
      Future.delayed(Duration(seconds: 3),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      });
    }else{
      SessionController.userId = user.uid;
      UserService.loadUserName();
      Future.delayed(Duration(seconds: 3),(){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
      });
    }

  }

}