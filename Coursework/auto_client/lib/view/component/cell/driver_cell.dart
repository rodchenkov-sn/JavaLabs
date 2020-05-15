import 'package:autoclient/model/automobile.dart';
import 'package:autoclient/model/driver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverCell extends StatelessWidget {

  final Driver driver;
  final Widget Function(Widget) details;

  DriverCell({this.driver, this.details});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => details(this),
            )
        );
      },
      child: Card(
        elevation: 10,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: <Widget>[
            ListTile(
                leading: Icon(
                    Icons.account_box,
                    color: Colors.blueGrey
                ),
                title: Text(
                    '${driver.firstName} ${driver.lastName} ${
                        driver.fatherName == null ? '' : driver.fatherName
                    }'
                )
            ),
          ],
        ),
      ),
    );
  }

}