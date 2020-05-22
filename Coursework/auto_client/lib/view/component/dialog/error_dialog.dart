import 'package:flutter/material.dart';

void somethingWentWrong(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Something went wrong'),
          actions: <Widget>[
            FlatButton(
              child: Text('Bruh...'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );
}

void showDependenciesError(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Could not delete item'),
          content: Text('There are several item that depends on this one. '
              'Try removing them first.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );
}

void showPeriodError(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Invalid time period'),
          content: Text('Time in must be after time out'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
  );
}
