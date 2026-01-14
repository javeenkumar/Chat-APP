
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void ToastMessage(String message,bool iserror){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 6,
      backgroundColor: iserror ? Colors.red :Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 16.0
  );
}