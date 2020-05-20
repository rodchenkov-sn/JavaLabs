import 'package:autoclient/model/automobile.dart';
import 'package:autoclient/model/driver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutomobileInput extends StatefulWidget {

  final void Function(Automobile) onSubmit;
  final void Function() onCancel;
  final void Function(void Function(Driver)) pickDriver;

  AutomobileInput({Key key, this.onSubmit, this.onCancel, this.pickDriver}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AutomobileInputState();

}

class _AutomobileInputState extends State<AutomobileInput> {

  String _number = '';
  String _mark = '';
  String _color = '';

  String _validate(String value) => value.trim().isEmpty
      ? 'Must be not empty'
      : null;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
          'Driver edit'
      ),
    ),
    body: Column(
      children: <Widget>[
        Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.enter):
            Intent(NextFocusAction.key),
          },
          child: FocusTraversalGroup(
            child: Form(
              autovalidate: true,
              onChanged: () => Form.of(primaryFocus.context).save(),
              child: Wrap(
                children: <Widget> [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mark',
                      ),
                      onSaved: (String value) {
                        _mark = value.trim();
                      },
                      validator: _validate
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Color',
                      ),
                      onSaved: (String value) {
                        _color = value.trim();
                      },
                      validator: _validate
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Number',
                      ),
                      onSaved: (String value) {
                        _number = value.trim();
                      },
                      validator: _validate
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]
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
    if (_validate(_number) == null
        && _validate(_color) == null
        && _validate(_mark) == null
    ) {
      widget.pickDriver(
        (Driver driver) => widget.onSubmit(Automobile(
          num: _number,
          color: _color,
          mark: _mark,
          driverId: driver.id
        ))
      );
    }
  }

}
