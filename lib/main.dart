import 'package:find_a_flick/pages/email_reg.dart';
import 'package:find_a_flick/pages/homepage.dart';
import 'package:find_a_flick/screensize/sizeconfig.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Application',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(title: 'Find-a-Flick'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final toastKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          key: toastKey,
          body: Container(
            height:SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/login_bgimg.jpg"), // background image to fit whole page
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: ListView(
                //padding: EdgeInsets.symmetric(horizontal: 24.0),
                children: <Widget>[
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          // For App logo and name
                          Column(
                            children: <Widget>[
                              Image.asset("assets/app_logo.png"),                          
                            ],
                          ),

                          // For Email
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              filled: true,
                            ),
                            validator: (String email) {
                              if (email.trim().isEmpty) {
                                return 'Email is required';
                              }
                              else {
                                return null;
                              }
                            },
                            onSaved: (input) => _email = input,
                          ),

                          // For password
                          //SizedBox(height: 10.0),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              filled: true,
                            ),
                            validator: (String password) {
                              if (password.trim().isEmpty) {
                                return 'Password is required';
                              }
                              else {
                                return null;
                              }
                            },
                            onSaved: (input) => _password = input,
                          ),

                          // For Login and Register Button
                          SizedBox(height: 60.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: emailLogin,
                                      child: Text('Login'), color: Colors.orange,
                                    ),
                                  ],
                                )
                              ),
                              SizedBox(width: 20.0),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: emailRegister,
                                      child: Text('Register'), color: Colors.orange,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          // Copyright notice
                          SizedBox(height: 60.0),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: new Text('2020 \u00a9 Robien Marquez All Rights Reserved.', style: TextStyle(fontSize: 10)),
                          ) 
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Login method using Firebase
  Future<void> emailLogin() async {

    // Validate fields
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        // When user presses login button, show Modal Progress HUD
        setState(() {
          _isLoading = true;
        });

        // Create user
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

        // Add unique uid to firebase db collection after logging in
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        Firestore.instance.collection('users')
          .where("email", isEqualTo: user.email)
          .snapshots()
          .listen((data) => 
            data.documents.forEach((doc) {
              doc.reference.updateData({
                'uid' : user.uid
              });
            }));

        // After authenticating, hide Modal Progress HUD
        setState(() {
          _isLoading = false;
        });

        // If login is successful, go to homepage
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
      } catch(e) {
        // Hide Modal Progress HUD on unsuccessful login
        setState(() {
          _isLoading = false;
        });

        // Error message
        toastKey.currentState.showSnackBar(new SnackBar(
          content: new Text(e.message.toString()),
        ));
      }
    }
  }

  // Go to user registration page
  void emailRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return EmailRegistrationForm();
      }
    ));
  }
}
