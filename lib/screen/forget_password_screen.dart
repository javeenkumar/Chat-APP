import 'package:chatapp/CustomWidgets/logo.dart';
import 'package:chatapp/servies/provider/forgetPassword_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../CustomWidgets/button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final _key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    double width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),
      ),
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
                      SizedBox(height: 30),
                      logo(),
                      SizedBox(height: 20),
                      Align(
                        alignment: AlignmentGeometry.center,
                        child: Text(
                          'Reference site about Lorem Ipsum \n giving information on its origins.',
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
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
                  Consumer<Forget_passwordProvider>(builder: (context,provider,child){
                    return ElButton(
                        context,
                        Theme.of(context).colorScheme.primary,
                        fweight: FontWeight.bold,
                        text: 'Forget Password',
                        textColor: Colors.white,
                        fontSize: 18,
                        width: width * .75,
                        isloading: provider.loading,
                        onPressed: (){
                          if(_key.currentState!.validate()){
                            provider.FirebaseForgetPassword(context,email.text);
                          }
                        }
                    );
                  })
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
