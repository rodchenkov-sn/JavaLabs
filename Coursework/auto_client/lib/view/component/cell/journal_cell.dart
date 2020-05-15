import 'package:autoclient/model/automobile.dart';
import 'package:autoclient/model/driver.dart';
import 'package:autoclient/model/journal_record.dart';
import 'package:autoclient/model/route.dart' as r;
import 'package:flutter/material.dart';

class JournalCell extends StatelessWidget {

  final JournalRecord journalRecord;
  final r.Route route;
  final Automobile automobile;
  final Driver driver;

  JournalCell({
    this.journalRecord,
    this.route,
    this.automobile,
    this.driver
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.access_time,
              color: Colors.blueGrey,
            ),
            title: Text(
              '${journalRecord.timeIn.day}.${journalRecord.timeIn.month}'
                  + ' ${journalRecord.timeIn.hour}'
                  + ':${journalRecord.timeIn.minute}'
            ),
            subtitle: Text(
                '${journalRecord.timeOut.day}.${journalRecord.timeOut.month}'
                    + ' ${journalRecord.timeOut.hour}'
                    + ':${journalRecord.timeOut.minute}'
            ),
          ),
          Divider(
            color: Colors.blueGrey,
          ),
          ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.blueGrey,
            ),
            title: Text(route.name),
          ),
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
    );
  }

}