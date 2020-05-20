import 'package:autoclient/model/driver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:autoclient/model/driver.dart';

class DriverInput extends StatefulWidget {

  final void Function(Driver) onSubmit;
  final void Function() onCancel;

  DriverInput({Key key, this.onSubmit, this.onCancel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DriverInputState();

}

class _DriverInputState extends State<DriverInput> {

  String _firstName = '';
  String _lastName = '';
  String _fatherName = '';

  String _validateName(String name) {
    if (name.isEmpty) {
      return 'Must be not empty';
    }
    if (name.contains(RegExp(r'\W'))) {
      return 'Alphabetic only';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
          'Driver edit'
      ),
    ),
    body: Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        // Pressing enter on the field will now move to the next field.
        LogicalKeySet(LogicalKeyboardKey.enter):
        Intent(NextFocusAction.key),
      },
      child: FocusTraversalGroup(
        child: Form(
          autovalidate: true,
          onChanged: () {
            Form.of(primaryFocus.context).save();
          },
          child: Wrap(
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'First name',
                  ),
                  onSaved: (String value) {
                    _firstName = value;
                  },
                  validator: _validateName
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                    ),
                    onSaved: (String value) {
                      _lastName = value;
                    },
                    validator: _validateName
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Father name',
                    ),
                    onSaved: (String value) {
                      _fatherName = value;
                    },
                    validator: (value) => value.contains(RegExp(r'\W'))
                        ? 'Alphabetic only'
                        : null
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: ButtonBar(
      children: <Widget>[
        FlatButton(
          child: Text(
            'Cancel',
            style: TextStyle(
                fontSize: 20
            ),
          ),
          onPressed: widget.onCancel,
        ),
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

  void _validateAndSubmit() {
    if (_validateName(_firstName) == null
        && _validateName(_lastName) == null
        && !_fatherName.contains(RegExp(r'\W'))
    ) {
      widget.onSubmit(Driver(
        firstName: _firstName,
        lastName: _lastName,
        fatherName: _fatherName.isEmpty ? null : _fatherName
      ));
    }
  }

}
