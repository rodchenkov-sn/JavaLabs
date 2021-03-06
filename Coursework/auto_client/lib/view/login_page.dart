import 'package:flutter/material.dart';

import 'package:autoclient/model/user.dart';
import 'package:autoclient/service/authentication.dart';

class LoginPage extends StatefulWidget {

  final BaseAuth auth;
  final VoidCallback loginCallback;

  LoginPage({Key key, this.auth, this.loginCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoading;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _errorMessage = '';
        _isLoading = true;
      });
      User user;
      try {
        user = await widget.auth.signIn(_email, _password);
        if (user == null) {
          throw 'Invalid login and password.';
        }
        print('Signed in: ${user.username}');
        setState(() {
          _isLoading = false;
        });
        widget.loginCallback();
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Auto Service Login'),
    ),
    body: Stack(
      children: <Widget>[
        _showForm(),
        _showCircularProgress(),
      ],
    )
  );

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() => Container(
    padding: EdgeInsets.all(20.0),
    child: new Form(
      key: _formKey,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          showEmailInput(),
          showPasswordInput(),
          showPrimaryButton(),
          showErrorMessage(),
        ],
      ),
    )
  );

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
        child: Container(
          height: 40,
          child: Center(
            child: Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300
              ),
            ),
          ),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showEmailInput() => TextFormField(
    maxLines: 1,
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    decoration: new InputDecoration(
      hintText: 'Username',
      icon: new Icon(
        Icons.account_box,
        color: Colors.blueGrey,
      )
    ),
    validator: (value) => value.isEmpty ? 'Username can\'t be empty' : null,
    onSaved: (value) => _email = value.trim(),
  );

  Widget showPasswordInput() => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
    child: new TextFormField(
      maxLines: 1,
      obscureText: true,
      autofocus: false,
      decoration: new InputDecoration(
        hintText: 'Password',
        icon: new Icon(
          Icons.lock,
          color: Colors.blueGrey,
        )
      ),
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onSaved: (value) => _password = value.trim(),
    ),
  );

  Widget showPrimaryButton() => Padding(
    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
    child: SizedBox(
      height: 40.0,
      child: new RaisedButton(
        elevation: 5.0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5)),
        color: Colors.blueGrey,
        child: new Text(
            'LOGIN',
            style: new TextStyle(fontSize: 20.0, color: Colors.white)
        ),
        onPressed: validateAndSubmit,
      ),
    )
  );

}