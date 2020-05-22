import 'package:flutter/cupertino.dart';

class DynamicTable<T> extends StatefulWidget {

  final List<T> Function() dataProvider;
  final Future<int> Function() onUpdate;
  final Widget Function(T) cellBuilder;

  DynamicTable({this.dataProvider, this.onUpdate, this.cellBuilder});

  @override
  State<StatefulWidget> createState() => _DynamicTableState<T>();

}

class _DynamicTableState<T> extends State<DynamicTable<T>> {

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: widget.dataProvider().length,
    itemBuilder: (_, int row) {
      if (row == widget.dataProvider().length - 1) {
        widget.onUpdate().then((int value) {
          if (value != 0) {
            setState(() {});
          }
        });
      }
      return widget.cellBuilder(widget.dataProvider()[row]);
    },
  );

}
