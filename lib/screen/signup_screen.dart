import 'package:chatapp/screen/login_screen.dart';
import 'package:chatapp/servies/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CustomWidgets/button.dart';
import '../CustomWidgets/logo.dart';
import '../servies/provider/button_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _key = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController Username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    double width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios_new)),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    logo(),
                    SizedBox(height: 15),
                Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: Username,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon: Icon(Icons.person
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 30),
                   Consumer<SignupProvider>(
                       builder: (context,provider,child){
                     return  ElButton(
                         context,
                         Theme.of(context).colorScheme.primary,
                         fweight: FontWeight.bold,
                         text: 'Sign up',
                         textColor: Colors.white,
                         fontSize: 18,
                         width: width * .75,
                         isloading: provider.loading,
                       onPressed: (){
                           if(_key.currentState!.validate()){
                             provider.FirebaseSignup(
                                 context,
                                 Username.text,
                                 email.text,
                                 password.text
                             );
                           }
                       }
                     );
                   }),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'have you already an account?',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
