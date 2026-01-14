import 'package:chatapp/CustomWidgets/Utilities/ToastMessage.dart';
import 'package:chatapp/CustomWidgets/Utilities/TrimMessage.dart';
import 'package:chatapp/screen/dashboard_screen.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier{

  final _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref('user');


  bool _isloading = false;

  get loading =>_isloading;

  setLoading(bool value){
    _isloading = value;
    notifyListeners();
  }

  Future<void> FirebaseSignup(BuildContext context,String Username, String email,String password)async{

    setLoading(true);
    _auth.createUserWithEmailAndPassword(
        email: email,
        password: password

    ).then((value){

      SessionController.userId = value.user!.uid.toString();

      ref.child(value.user!.uid.toString()).set({
        'uid':value.user!.uid.toString(),
        'username':Username,
        'email':value.user!.email.toString(),
        'onlineStatus':'noOne',
        'phone':'',
        'profile':'',

      }).then((value){

        setLoading(false);
        ToastMessage('Register Successfully', false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));

      }).onError((error,stackTrace){
        ToastMessage(TrimMessage(error.toString()), true);
        setLoading(false);
        print('========>'+error.toString());
      });

    }).onError((error,stackTrace){
      setLoading(false);
      ToastMessage(TrimMessage(error.toString()), true);
      print('========>'+error.toString());
    });
  }

}