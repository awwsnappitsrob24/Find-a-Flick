import 'package:find_a_flick/pages/email_reg.dart';
import 'package:find_a_flick/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: toastKey,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // For App logo and name
                      SizedBox(height: 40.0),
                      Column(
                        children: <Widget>[
                          Image.asset("assets/app_logo.jpg"),
                          SizedBox(height: 20.0),
                          Text(
                            "Find-a-Flick",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),

                      // For Email
                      SizedBox(height: 30.0),
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
                        },
                        onSaved: (input) => _email = input,
                      ),

                      // For password
                      SizedBox(height: 10.0),
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
                        },
                        onSaved: (input) => _password = input,
                      ),

                      // For Login Button
                      SizedBox(height: 20.0),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: emailLogin,
                              child: Text('Login w/ Email'), color: Colors.orange,
                            ),
                            RaisedButton(
                              onPressed: face_login,
                              child: Text('Login w/ Face'), color: Colors.orange,
                            ),
                          ],
                        )
                      ),

                      SizedBox(height: 2.0),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: emailRegister,
                              child: Text('Register w/ Email'), color: Colors.orange,
                            ),
                            RaisedButton(
                              onPressed: face_register,
                              child: Text('Register w/ Face'), color: Colors.orange,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
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
        // Create user
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

        // If login is successful, go to homepage
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
      } catch(e) {
        // Error message
        toastKey.currentState.showSnackBar(new SnackBar(
          content: new Text(e.message.toString()),
        ));
      }
    }
  }

  void face_login() {
    print("Face login pressed.");
  }

  void emailRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return EmailRegistrationForm();
      }
    ));
  }

  void face_register() {
    print("Face register pressed.");
  }
}
