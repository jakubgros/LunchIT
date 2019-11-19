import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lunch_it/Components/ServerApi/ServerApi.dart';
import 'package:lunch_it/Routes.dart';

class LoginPage extends StatefulWidget {
  final String onSuccessPath;

  @override
  _LoginPageState createState() => _LoginPageState();

  LoginPage({@required this.onSuccessPath});
}

class _LoginPageState extends State<LoginPage> {
  String _email;

  String _password;

  bool _incorrectCredentials = false;
  bool _rememberCredentials = false;
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

                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _rememberCredentials,
                      onChanged: (value) => setState(()=> _rememberCredentials = value),
                    ),
                    Text("Remember me"),
                  ],
                ),

                RaisedButton(
                    child: Text("LOGIN"),
                    onPressed: () => _login(context)
                ),
                if(_incorrectCredentials) Text("Provided credentials are incorrect") else Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Text("Don't have account? "),
                      InkWell(
                        child: Text("Go to registration",
                        style: TextStyle(
                          color: Colors.blue[700]
                        ),),
                        onTap: () => Navigator.of(context).pushNamed(Routes.register),
                      )
                    ],
                  ),
                )
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

    bool isUserValid = await ServerApi().logIn(_email, _password, rememberCredentials: _rememberCredentials);

    if(isUserValid)
      Navigator.of(context).pushNamed(widget.onSuccessPath);
    else
      setState(() {
        _incorrectCredentials = true;
      });
  }
}
