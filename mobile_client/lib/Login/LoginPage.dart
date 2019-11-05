import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/ServerApi/ServerApi.dart';

class LoginPage extends StatelessWidget {
  String _email;
  String _password;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _loginFormKey,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Login Information',
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
                    child: Text("LOGIN"),
                    onPressed: () => _login(context)
                ),
              ],
            ),
          ),
        ),
        );
  }

  void _login(BuildContext context) async{
    final loginForm = _loginFormKey.currentState;

    if(loginForm.validate() == false)
      return;
    else
      loginForm.save();

    bool isUserValid = await ServerApi().checkUser(_email, _password);

    if(isUserValid)
      Navigator.of(context).pushNamed('/home');
    else
      ;//TODO display error
  }

}
