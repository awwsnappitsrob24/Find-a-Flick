import 'package:find_a_flick/main.dart';
import 'package:find_a_flick/pages/tos.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmailRegistrationForm extends StatefulWidget {
 const EmailRegistrationForm({Key key}) : super(key: key);

  @override
  _EmailRegistrationFormState createState() => _EmailRegistrationFormState();
}

class _EmailRegistrationFormState extends State<EmailRegistrationForm> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final toastKey = new GlobalKey<ScaffoldState>();
  bool _agreedToTOS = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: toastKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Register User', style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100.0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: _agreedToTOS,
                          onChanged: _setAgreedToTOS,
                        ),
                        GestureDetector(
                          onTap: () => _setAgreedToTOS(_agreedToTOS),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                new Text("I agree to the "),
                                new InkWell(
                                  child: Text("Terms of Services", style: TextStyle(color: Colors.blue)),
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => TOSPage())
                                    )
                                  } 
                                ),
                              ],
                            )
                          )       
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _submittable() ? registerUser : null,
                        color: Colors.orange[300],
                        child: Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }


  bool _submittable() {
    return _agreedToTOS;
  }

  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }

  Future<void> registerUser() async {
    // Validate fields
    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        // When user presses login button, show Modal Progress HUD
        setState(() {
          _isLoading = true;
        });

        // Create user in firebase db and add the document in the collection
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

        await Firestore.instance.collection("users").add({
          'email' : _email,
        });

        // After authenticating, hide Modal Progress HUD
        setState(() {
          _isLoading = false;
        });

        // If login is successful, go to login page and show toast message that user has been created
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));

        // Successful message in a toast
        Fluttertoast.showToast(
          msg: "User has been successfully created!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } catch(e) {
        // Hide Modal Progress HUD
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
}