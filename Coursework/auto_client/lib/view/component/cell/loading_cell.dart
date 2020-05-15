import 'package:flutter/material.dart';

class LoadingCell extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}