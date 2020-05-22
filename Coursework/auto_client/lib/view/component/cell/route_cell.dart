import 'package:autoclient/model/route.dart' as r;
import 'package:flutter/material.dart';

class RouteCell extends StatelessWidget {

  final r.Route route;
  final void Function(Widget) onTap;

  RouteCell({this.route, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(this),
      child: Card(
        elevation: 10,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.map,
                color: Colors.blueGrey,
              ),
              title: Text(route.name),
            ),
          ],
        ),
      ),
    );
  }

}
