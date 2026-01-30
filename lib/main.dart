import 'package:chatapp/CustomWidgets/logo.dart';
import 'package:chatapp/screen/splash_screen.dart';
import 'package:chatapp/servies/provider/Bottom_nav_bar_provider/profile_images_Update_povider.dart';
import 'package:chatapp/servies/provider/Login_provider.dart';
import 'package:chatapp/servies/provider/button_provider.dart';
import 'package:chatapp/servies/provider/dashboard_provider.dart';
import 'package:chatapp/servies/provider/forgetPassword_provider.dart';
import 'package:chatapp/servies/provider/home_provider.dart';
import 'package:chatapp/servies/provider/signup_provider.dart';
import 'package:chatapp/servies/session_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
  String? initialToken = await FirebaseMessaging.instance.getToken();
  if (initialToken != null) {
    SessionController.token = initialToken;

    if (SessionController.userId != null) {
      await FirebaseDatabase.instance
          .ref("user/${SessionController.userId}")
          .update({"token": initialToken});
      print("✅ Initial token saved in Realtime DB: $initialToken");
    }
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    SessionController.token = newToken;
    if (SessionController.userId != null) {
      await FirebaseDatabase.instance
          .ref("user/${SessionController.userId}")
          .update({"token": newToken});
      print("🔄 Token updated in Realtime DB: $newToken");
    }
  });

}

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification?.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ButtonProvider()),
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => Forget_passwordProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(
          create: (context) => ProfileImagesUpdatePovider(),
        ),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChitChat',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: SplashScreen(),
      ),
    );
  }
}
