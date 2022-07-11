import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation colorAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    colorAnimation = ColorTween(begin: Colors.grey.shade300, end: Colors.white)
        .animate(animationController);
    animationController.forward();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnimation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 75.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                AnimatedTextKit(
                    animatedTexts: [
                  TypewriterAnimatedText(
                    'Flash Chat',
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 50.0,
                      fontWeight: FontWeight.w900,
                    ),
                    speed: const Duration(milliseconds: 150),
                  ),
                ]),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                content: 'Log In'),
            RoundedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                content: 'Register'),
          ],
        ),
      ),
    );
  }
}
