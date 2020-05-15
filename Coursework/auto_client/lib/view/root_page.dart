import 'package:autoclient/service/auto_service.dart';
import 'package:flutter/material.dart';
import 'package:autoclient/view/login_page.dart';
import 'package:autoclient/view/home_page.dart';
import 'package:autoclient/service/authentication.dart';

import 'package:autoclient/model/user.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {

  final BaseAuth auth;
  final BaseService service;

  RootPage({this.auth, this.service});

  @override
  State<StatefulWidget> createState() => new _RootPageState();

}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.auth.getCurrentUser();
    setState(() {
      authStatus =
      _user == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
    });
  }

  void loginCallback() {
    _user = widget.auth.getCurrentUser();
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _user = null;
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
          return HomePage(_user, widget.service);
        break;
      default:
        return buildWaitingScreen();
    }
  }
}