import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
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
                  hintText: 'Enter your email',
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
                    hintText: 'Enter your Password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  color: Colors.blueAccent,
                  content: 'Register',
                  onPressed: () async {
                    fieldController1.clear();
                    fieldController2.clear();
                    setState(() {
                      _showSpinner = true;
                    });
                   try {
                     var newUserCredentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                     var newUserEmail = newUserCredentials.user!.email;
                     if(newUserEmail != null) {
                       Navigator.pushReplacementNamed(context, ChatScreen.id);
                     }
                   }
                   catch(e) {
                     throw 'Error while creating new user';
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
