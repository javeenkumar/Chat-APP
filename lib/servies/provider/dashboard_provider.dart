import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier{

  int _currentindex = 0;

  int get currentindex => _currentindex;

  set Setcurrentindex(int value) {
    _currentindex = value;
    notifyListeners();
  }
}