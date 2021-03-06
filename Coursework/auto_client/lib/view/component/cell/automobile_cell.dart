import 'package:autoclient/model/automobile.dart';
import 'package:autoclient/model/driver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutomobileCell extends StatelessWidget {

  final Automobile automobile;
  final Driver driver;
  final void Function(Widget) onTap;

  AutomobileCell({this.automobile, this.driver, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onTap(this),
    child: Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.drive_eta,
              color: Colors.blueGrey,
            ),
            title: Text('${automobile.color} ${automobile.mark}'),
            subtitle: Text(automobile.num),
          ),
          ListTile(
            leading: Icon(
              Icons.account_box,
              color: Colors.blueGrey,
            ),
            title: Text(
                '${driver.firstName} ${driver.lastName} ${
                    driver.fatherName == null ? '' : driver.fatherName
                }'
            ),
          ),
        ],
      ),
    ),
  );

}