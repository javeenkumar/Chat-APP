
import 'package:flutter/material.dart';

class ButtonProvider with ChangeNotifier{
  bool _isvisibility = true;

  bool get isvisibility => _isvisibility;

  set isvisibility(bool value) {
    _isvisibility = value;
    notifyListeners();
  }
}