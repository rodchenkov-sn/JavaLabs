import 'dart:async';

import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {

  final String title;
  final Widget header;
  final void Function(String) onSelect;
  final Stream<List<Widget>> dataProvider;

  DetailsScreen({this.title, this.header, this.onSelect, this.dataProvider});

  @override
  State<StatefulWidget> createState() => _DetailsScreenState();

}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: widget.onSelect,
              child: Icon(Icons.more_vert),
              itemBuilder: (context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem(child: Text('Delete'), value: 'delete'),
                ];
              },
            ),
          ],
        ),
        body: StreamBuilder(
          stream: widget.dataProvider,
          builder: (context, snapshot) {
            final content = <Widget>[widget.header];
            if (snapshot != null && snapshot.hasData) {
              content.addAll(snapshot.data);
            }
            return ListView(
              children: content,
            );
          },
        )
    );
  }
}
