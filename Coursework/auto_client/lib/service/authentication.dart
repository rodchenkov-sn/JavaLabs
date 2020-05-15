import 'dart:async';
import 'dart:convert';

import 'package:autoclient/model/user.dart';
import 'package:http/http.dart' as http;

abstract class BaseAuth {
  Future<User> signIn(String username, String password);

  User getCurrentUser();

}

class Auth implements BaseAuth {

  final url = 'http://192.168.17.1:8075/autoservice/auth/login';

  final headers = {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  };

  User currentUser;

  Future<User> signIn(String username, String password) async {
    var body = json.encode({"username": username,
                            "password": password});

    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode != 200) {
      return null;
    }
    final responseJson = json.decode(response.body);
    currentUser = User(
      username: responseJson['username'],
      token: responseJson['token']
    );
    return currentUser;
  }

  User getCurrentUser() {
    return currentUser;
  }

}