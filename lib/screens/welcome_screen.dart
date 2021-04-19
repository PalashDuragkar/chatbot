import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/component/roundedbutton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id='welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    controller.forward();

    animation = animation =
        ColorTween(begin: Colors.lightBlueAccent, end: Colors.white).animate(
            controller);
    controller.addListener(() {
      setState(() {

      });
    });
  }
    @override
    void dispose(){
      controller.dispose();
    }



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag : 'logo',
                  child :Container(
                  child: Image.asset('images/logo.png'),
                  height: 60.0,
                ),
                ),
                TypewriterAnimatedTextKit(
                  text :['Chat Bot'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton( tittle: 'Log In', color: Colors.lightBlueAccent, onPressed: () {
              //Go to login screen.
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton( tittle: 'Register', color: Colors.blueAccent, onPressed: () {
              //Go to login screen.
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}


