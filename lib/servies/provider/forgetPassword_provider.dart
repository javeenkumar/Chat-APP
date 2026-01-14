import 'package:chatapp/CustomWidgets/Utilities/ToastMessage.dart';
import 'package:chatapp/CustomWidgets/Utilities/TrimMessage.dart';
import 'package:chatapp/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Forget_passwordProvider with ChangeNotifier{
  final _auth = FirebaseAuth.instance;

  bool _isloading = false;

  get loading =>_isloading;

  setLoading(bool value){
    _isloading = value;
    notifyListeners();
  }

  Future<void> FirebaseForgetPassword(BuildContext context, String email,)async {
    setLoading(true);
    try{
      _auth.sendPasswordResetEmail(email: email).then((value){
        ToastMessage('Successfully', false);
        setLoading(false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      });
    } on FirebaseAuthException catch(e){
      ToastMessage(TrimMessage(e.toString()), true);
      print('+++++++++>>>>${e.toString()}');
    }
  }
}