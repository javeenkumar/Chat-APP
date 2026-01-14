import 'package:chatapp/screen/splash_screen.dart';
import 'package:chatapp/servies/provider/Bottom_nav_bar_provider/profile_images_Update_povider.dart';
import 'package:chatapp/servies/provider/Login_provider.dart';
import 'package:chatapp/servies/provider/button_provider.dart';
import 'package:chatapp/servies/provider/dashboard_provider.dart';
import 'package:chatapp/servies/provider/forgetPassword_provider.dart';
import 'package:chatapp/servies/provider/signup_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>ButtonProvider()),
      ChangeNotifierProvider(create: (context)=>SignupProvider()),
      ChangeNotifierProvider(create: (context)=>LoginProvider()),
      ChangeNotifierProvider(create: (context)=>Forget_passwordProvider()),
      ChangeNotifierProvider(create: (context)=>DashboardProvider()),
      ChangeNotifierProvider(create: (context)=>ProfileImagesUpdatePovider()),
    ],
      child: MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
    colorScheme: .fromSeed(seedColor: Colors.deepPurple),
    ),
    home: SplashScreen(),
    ),);
  }
}