import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Routes.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPage createState() => _RegistrationPage();

  RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  String _email;
  String _password;

  bool _incorrectCredentials = false;
  final _registrationFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _registrationFormKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Registration Information',
                style: TextStyle(fontSize: 20),
              ),
              TextFormField(
                  onSaved: (value) => _email = value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address")),
              TextFormField(
                  onSaved: (value) => _password = value,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password")),

              RaisedButton(
                  child: Text("REGISTER ACCOUNT"),
                  onPressed: () => _register(context)
              ),
              if(_incorrectCredentials) Text("Can't create an account. User already exists") else Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async{
    final loginForm = _registrationFormKey.currentState;

    if(loginForm.validate() == false)
      return;
    else
      loginForm.save();

    bool isUserCreated = await ServerApi().registerUser(_email, _password);

    if(isUserCreated)
      Navigator.of(context).pushNamed(Routes.login);
    else
      setState(() => _incorrectCredentials = true);
  }
}
