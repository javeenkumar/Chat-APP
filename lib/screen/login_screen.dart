import 'package:chatapp/CustomWidgets/button.dart';
import 'package:chatapp/CustomWidgets/logo.dart';
import 'package:chatapp/screen/forget_password_screen.dart';
import 'package:chatapp/screen/signup_screen.dart';
import 'package:chatapp/servies/provider/Login_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../servies/provider/button_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    double width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Well Come',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      logo(),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          } else if (!value.contains('@')) {
                            return 'Invalide email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      Consumer<ButtonProvider>(
                        builder: (context, provider, child) {
                          return TextFormField(
                            controller: password,
                            obscureText: provider.isvisibility,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.password_sharp),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  onPressed: () {
                                    provider.isvisibility =
                                        !provider.isvisibility;
                                  },
                                  icon: provider.isvisibility
                                      ? Icon(Icons.visibility_off_outlined)
                                      : Icon(Icons.visibility_outlined),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Password';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: AlignmentGeometry.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordScreen()));
                          },
                          child: Text(
                            'Forget Password',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Consumer<LoginProvider>(builder: (context,provider,child){
                       return ElButton(
                          context,
                          Theme.of(context).colorScheme.primary,
                          fweight: FontWeight.bold,
                          text: 'Login',
                          textColor: Colors.white,
                          fontSize: 18,
                          width: width * .75,
                         isloading: provider.loading,
                         onPressed: (){
                            if(_key.currentState!.validate()){
                              provider.FirebaseLogin(context, email.text, password.text);
                            }
                         }
                        );
                      }),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Can\'t have an account?',
                            style: TextStyle(
                              fontSize: 16,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      ElButton(
                        context,
                        Colors.white,
                        fweight: FontWeight.bold,
                        text: 'Sign with Google',
                        textColor: Colors.black,
                        fontSize: 18,
                        width: width * .6,
                        borderColor: Colors.black,
                        borderWidth: 1,
                        onPressed: () async{
                          // try{
                          //   GoogleSignIn signIn = GoogleSignIn.instance;
                          //   await signIn.initialize(serverClientId: )
                          // }catch(e){
                          //
                          // }
                        }

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
