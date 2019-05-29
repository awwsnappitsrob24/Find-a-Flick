import 'package:find_a_flick/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailRegistrationForm extends StatefulWidget {
 const EmailRegistrationForm({Key key}) : super(key: key);

  @override
  _EmailRegistrationFormState createState() => _EmailRegistrationFormState();
}

class _EmailRegistrationFormState extends State<EmailRegistrationForm> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final toastKey = new GlobalKey<ScaffoldState>();
  bool _agreedToTOS = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: toastKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Register User', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
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
                      child: Text(
                        'I agree to the Terms of Services\n'
                        'and Privacy Policy',
                      ),
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
        // Create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);

        // If login is successful, go to login page
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch(e) {
        // Error message
        toastKey.currentState.showSnackBar(new SnackBar(
          content: new Text(e.message.toString()),
        ));
      }

    }
  }
}