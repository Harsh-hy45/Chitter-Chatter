import 'package:chitter_chatter/constants.dart';
import 'package:chitter_chatter/screens/chat_screen.dart';
//import 'package:chitter_chatter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chitter_chatter/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:edge_alert/edge_alert.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth=FirebaseAuth.instance;
  bool showSpinner=false;
  String email;
String password;
String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2F2B52),
      
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo1.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
               style: TextStyle(color: Colors. white),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  name=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your name',
                  prefixIcon: IconTheme(data: IconThemeData(
                      color: Colors.white
                  ), child: Icon(Icons.text_format,)
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors. white),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email',
                  prefixIcon: IconTheme(data: IconThemeData(
                      color: Colors.white
                  ), child: Icon(Icons.email,)
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors. white),
                onChanged: (value) {
                 password=value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password', prefixIcon: IconTheme(data: IconThemeData(
                    color: Colors.white
                ), child: Icon(Icons.lock,)
                ),),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () async{
                  if (name != null && password != null && email != null) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                      await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        UserUpdateInfo info = UserUpdateInfo();
                        info.displayName = name;
                        await newUser.user.updateProfile(info);

                        Navigator.pushNamed(context,ChatScreen.id);
                      }
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      EdgeAlert.show(context,
                          title: 'Signup Failed',
                          description: e.toString(),
                          gravity: EdgeAlert.BOTTOM,
                          icon: Icons.error,
                          backgroundColor: Colors.deepPurple[900]);
                    }
                  } else {
                    EdgeAlert.show(context,
                        title: 'Signup Failed',
                        description: 'All fields are required.',
                        gravity: EdgeAlert.BOTTOM,
                        icon: Icons.error,
                        backgroundColor: Colors.deepPurple[900]);
                  }
                    },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
