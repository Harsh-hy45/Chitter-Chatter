import 'package:chitter_chatter/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chitter_chatter/constants.dart';
import 'package:chitter_chatter/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:edge_alert/edge_alert.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  String email;
  bool showSpinner=false;
  String password;


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
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors. white),
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
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPressed: () async{

                  if (password != null && email != null) {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final loggedUser =
                      await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (loggedUser != null) {
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(context,ChatScreen.id);
                      }
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      EdgeAlert.show(context,
                          title: 'Login Failed',
                          description: e.toString(),
                          gravity: EdgeAlert.BOTTOM,
                          icon: Icons.error,
                          backgroundColor: Colors.deepPurple[900]);
                    }
                  } else {
                    EdgeAlert.show(context,
                        title: 'Uh oh!',
                        description:
                        'Please enter the email and password.',
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
