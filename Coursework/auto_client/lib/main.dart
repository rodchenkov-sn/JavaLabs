import 'package:autoclient/service/authentication.dart';
import 'package:autoclient/service/auto_service.dart';
import 'package:autoclient/view/root_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'AutoClient Login',
    theme: ThemeData(
      primarySwatch: Colors.grey,
    ),
    home: new RootPage(auth: Auth(), service: AutoService())
  );

}