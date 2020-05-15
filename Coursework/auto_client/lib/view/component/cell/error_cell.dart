import 'package:flutter/material.dart';

class ErrorCell extends StatelessWidget {

  final String error;

  ErrorCell(this.error);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Center(
        child: Text(
          error,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

}
