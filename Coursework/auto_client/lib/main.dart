import 'package:autoclient/service/authentication.dart';
import 'package:autoclient/service/auto_service.dart';
import 'package:autoclient/view/root_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Login Demo',
        theme: new ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: new RootPage(auth: new Auth(), service: new AutoService(),)
    );
  }
}