import 'package:autoclient/view/component/cell/loading_cell.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {

  final String title;
  final Widget header;
  final void Function(String) onSelect;
  final Stream<Widget> dataProvider;


  DetailsScreen({this.title, this.header, this.onSelect, this.dataProvider});

  @override
  State<StatefulWidget> createState() => _DetailsScreenState();

}

class _DetailsScreenState extends State<DetailsScreen> {

  var _items = <Widget>[];

  @override
  void initState() {
    widget.dataProvider.forEach((element) {
      setState(() {
        _items.add(element);
      });
    });
    super.initState();
  }

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
                  PopupMenuItem(child: Text('Edit'), value: 'edit'),
                  PopupMenuItem(child: Text('Delete'), value: 'delete'),
                ];
              },
            ),
          ],
        ),
        body: _items.isEmpty ? Center(child: CircularProgressIndicator()) :
            ListView(
              children: _items,
            )
    );
  }
}
