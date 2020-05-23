import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:autoclient/model/route.dart' as r;

class RouteInput extends StatefulWidget {

  final void Function(r.Route) onSubmit;

  RouteInput({Key key, this.onSubmit}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RouteInputState();

}

class _RouteInputState extends State<RouteInput> {

  String _routeName = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        'Route edit'
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
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.map),
                    labelText: 'Name',
                  ),
                  onSaved: (String value) {
                    _routeName = value.trim();
                  },
                  validator: (String value) {
                    return value.trim().isEmpty ? 'Name must be not empty' : null;
                  },
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
    if (_routeName.isNotEmpty) {
      widget.onSubmit(r.Route(
        name: _routeName
      ));
    }
  }

}
