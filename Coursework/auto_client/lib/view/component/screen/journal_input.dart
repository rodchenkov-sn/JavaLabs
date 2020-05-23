import 'package:autoclient/model/automobile.dart';
import 'package:autoclient/model/journal_record.dart';
import 'package:autoclient/model/route.dart' as r;
import 'package:autoclient/view/component/dialog/error_dialog.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class JournalInput extends StatefulWidget {

  final void Function(JournalRecord) onSubmit;
  final void Function(void Function(Automobile)) pickAutomobile;
  final void Function(void Function(r.Route)) pickRoute;

  JournalInput({
    this.onSubmit,
    this.pickAutomobile,
    this.pickRoute
  });

  @override
  State<StatefulWidget> createState() => _JournalInputState();

}

class _JournalInputState extends State<JournalInput> {

  DateTime _timeIn;
  DateTime _timeOut;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
          'Journal edit'
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                  _timeOut == null
                      ? 'Select time out'
                      : DateFormat('dd.MM.y HH:mm').format(_timeOut)
              ),
              trailing: Icon(Icons.outlined_flag),
              onTap: () => _pickDateTime((time) => setState(() { _timeOut = time; })),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                  _timeIn == null
                      ? 'Select time in'
                      : DateFormat('dd.MM.y HH:mm').format(_timeIn)
              ),
              trailing: Icon(Icons.flag),
              onTap: () => _pickDateTime((time) {
                if (time.isAfter(_timeOut)) {
                  setState(() {
                    _timeIn = time;
                  });
                } else {
                  showPeriodError(context);
                }
              }),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: ButtonBar(
      children: <Widget>[
        FlatButton(
          child: Text(
            'Submit',
            style: TextStyle(
                fontSize: 20
            ),
          ),
          onPressed: _validateAndSubmit,
        )
      ],
    ),
  );

  Future<void> _pickDateTime(void Function(DateTime) onPicked) async {
    final now = DateTime.now();
    var date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDate: now,
    );
    if(date != null) {
      var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        onPicked(DateTime(
            date.year, date.month, date.day, time.hour, time.minute
        ));
      }
    }
  }

  void _validateAndSubmit() {
    if (_timeIn != null && _timeOut != null) {
      widget.pickAutomobile((Automobile automobile) {
        widget.pickRoute((r.Route route) {
          widget.onSubmit(JournalRecord(
            timeIn: _timeIn,
            timeOut: _timeOut,
            automobileId: automobile.id,
            routeId: route.id
          ));
        });
      });
    }
  }

}
