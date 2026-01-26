
import 'package:chatapp/CustomWidgets/Utilities/ToastMessage.dart';
import 'package:chatapp/screen/dashboard_screen.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../CustomWidgets/Utilities/TrimMessage.dart';
import '../../CustomWidgets/Utilities/getName.dart';

class LoginProvider with ChangeNotifier{

  final _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref('user');

  bool _isloading = false;
  get isloading =>_isloading;
  setisLoading(bool value){
    _isloading = value;
    notifyListeners();
  }

  Future<void> FirebaseLogin(BuildContext context, String email, String password)async{
    setisLoading(true);
    try{
      _auth.signInWithEmailAndPassword(email: email, password: password).then((value){
        setisLoading(false);
        UserService.loadUserName();
        ToastMessage('Login Successfully', false);
        SessionController.userId =value.user!.uid.toString();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));

      }).onError((error,stackTrace){
        ToastMessage(TrimMessage(error.toString()), true);
        setisLoading(false);
      });
    }on FirebaseAuthException catch(error){
      ToastMessage(TrimMessage(error.toString()), true);
      setisLoading(false);
    }catch(error){
      ToastMessage(TrimMessage(error.toString()), true);
      setisLoading(false);
    }
  }

  Future<void> DirectGoogleSign(BuildContext context)async{

    String webClint = dotenv.env['WEBCLINT']!;

    try{

      GoogleSignIn signIn = GoogleSignIn.instance;

      await signIn.initialize(
        serverClientId: webClint,
      );

      GoogleSignInAccount account = await signIn.authenticate();
      GoogleSignInAuthentication googleAuth = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential).then((value){

        SessionController.userId = value.user!.uid.toString();
        UserService.loadUserName();
        print('=============> \n '+value.user!.displayName.toString()+'\n=============>');

        ref.child(value.user!.uid.toString()).set({
          'uid':value.user!.uid.toString(),
          'username':value.user!.displayName.toString() ?? '',
          'email':value.user!.email.toString(),
          'onlineStatus':'noOne',
          'phone':'',
          'profile':'',
          'token':SessionController.token

        }).then((value){
          ToastMessage('Register Successfully', false);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));

        }).onError((error,stackTrace){
          ToastMessage(TrimMessage(error.toString()), true);
        });

      }).onError((error,stackTrace){
        ToastMessage(TrimMessage(error.toString()), true);

      });
  }catch (e){
      ToastMessage(TrimMessage(e.toString()), true);
    }
  }

}