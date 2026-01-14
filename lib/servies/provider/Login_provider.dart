
import 'package:chatapp/CustomWidgets/Utilities/ToastMessage.dart';
import 'package:chatapp/screen/dashboard_screen.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../CustomWidgets/Utilities/TrimMessage.dart';

class LoginProvider with ChangeNotifier{

  final _auth = FirebaseAuth.instance;

  bool _isloading = false;

  get loading =>_isloading;

  setLoading(bool value){
    _isloading = value;
    notifyListeners();
  }

  Future<void> FirebaseLogin(BuildContext context, String email, String password)async{
    setLoading(true);
    try{
      _auth.signInWithEmailAndPassword(email: email, password: password).then((value){
        setLoading(false);
        ToastMessage('Login Successfully', true);
        SessionController.userId =value.user!.uid.toString();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));

      }).onError((error,stackTrace){
        ToastMessage(TrimMessage(error.toString()), true);
        setLoading(false);
      });
    }on FirebaseAuthException catch(error){
      ToastMessage(TrimMessage(error.toString()), true);
      setLoading(false);
    }catch(error){
      ToastMessage(TrimMessage(error.toString()), true);
      setLoading(false);
    }
  }

}