import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  final fieldController1 = TextEditingController();
  final fieldController2 = TextEditingController();
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: _showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: fieldController1,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your Email',
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: fieldController2,
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  color: Colors.blueAccent,
                  content: 'Log in',
                  onPressed: () async {
                    fieldController1.clear();
                    fieldController2.clear();
                    setState(() {
                      _showSpinner = true;
                    });
                    try {
                      var loggedInUserCredentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
                      var loggedInUserEmail = loggedInUserCredentials.user!.email;
                      if(loggedInUserEmail != null) {
                        Navigator.pushReplacementNamed(context, ChatScreen.id);
                      }
                    }
                    catch(e) {
                      throw 'Error while logging in';
                    }
                    setState(() {
                      _showSpinner = false;
                    });
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
