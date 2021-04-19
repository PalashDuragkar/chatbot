import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/component/roundedbutton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class LoginScreen extends StatefulWidget {
  static const String id='login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth =FirebaseAuth.instance;
  bool showSpin=false;
  String email;
  String pwd;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpin,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag : 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email=value;
                },
                decoration: kTextfieldDecoration.copyWith(hintText: 'Enter your Email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  pwd=value;
                },
                decoration: kTextfieldDecoration.copyWith(hintText: 'Enter your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
             RoundedButton(tittle : 'Log In', color: Colors.lightBlueAccent ,onPressed: () async {
               setState(() {
                 showSpin=true;
               });
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: pwd);

                  if (user != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                                    }
                    setState(() {
                      showSpin=false;
                    });
                    }
                catch(e){
                  print(e);
                }
             },),
            ],
          ),
        ),
      ),
    );
  }
}
