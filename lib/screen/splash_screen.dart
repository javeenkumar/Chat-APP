import 'package:chatapp/CustomWidgets/logo.dart';
import 'package:chatapp/servies/splash_services.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final GifController controller;

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isloding(context);
    controller = GifController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 15,
          children: [
            Gif(
              width: MediaQuery.of(context).size.width * .4,
              height: MediaQuery.of(context).size.height * .4,
              autostart: Autostart.loop,
              placeholder: (context) => Center(
                child: SizedBox(
                  child: Image(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.height * .4,
                    image: AssetImage('assets/images/chat.gif'),
                  ),
                ),
              ),
              image: const AssetImage('assets/images/chat.gif'),
            ),
            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: logo(),
            ),
          ],
        ),
      ),
    );
  }
}
