import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:find_a_flick/main.dart';


class ChangePasswordPage extends StatefulWidget {
 const ChangePasswordPage({Key key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final toastKey = new GlobalKey<ScaffoldState>();
  String _email, _newPassword;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: toastKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Change Password', style: TextStyle(color: Colors.white)),
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
                        return 'Email field is required';
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (input) => _email = input,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      filled: true,
                    ),
                    validator: (String newPassword) {
                      if (newPassword.trim().isEmpty) {
                        return 'New password is required';
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (input) => _newPassword = input,
                  ),
                  SizedBox(height: 50.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          changeUserPassword(_newPassword);
                        },
                        color: Colors.orange[300],
                        child: Text('Update'),
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

  // Update the user's password in firebase db then send them back to login page if successful.
  Future<void> changeUserPassword(String newPassword) async {

    final formState = _formKey.currentState;
    if(formState.validate()) {
      formState.save();
      try {
        // When user presses login button, show Modal Progress HUD
        setState(() {
          _isLoading = true;
        });

        // Update password in firebase db
        // Look in collection for a user with the email entered, then upate the password on that account
        

        // After updating, hide Modal Progress HUD
        setState(() {
          _isLoading = false;
        });

        // Log out and make user login again
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage())
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