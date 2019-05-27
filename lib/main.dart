import 'package:flutter/material.dart';

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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
              ),
            ),

            // For password
            SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
              ),
            ),

            // For Login Button
            SizedBox(height: 20.0),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    onPressed: email_login,
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
                    onPressed: email_register,
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
    );
  }


  // Login method using Firebase
  //Future<void> login() async {
    // Validate fields
    /**
     final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        // Create user
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword
          (email: _email, password: _password);

        // If login is successful, go to homepage
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
      } catch(e) {
        // Error message
        print(e.message);
      }

    }
     
    
  }
  */

  // Helper functions for register/login 
  void email_login() {
    print("Email login pressed.");
  }

  void face_login() {
    print("Face login pressed.");
  }

  void email_register() {
    print("Email register pressed.");
  }

  void face_register() {
    print("Face register pressed.");
  }
}
