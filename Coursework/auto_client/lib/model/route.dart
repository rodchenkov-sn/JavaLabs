import 'package:autoclient/model/deletable.dart';
import 'package:autoclient/model/postable.dart';

class Route implements Postable, Deleteble {

  final int id;
  final String name;
  final List<int> journalRecords;

  Route({this.id, this.name, this.journalRecords});

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    id:             json['id'],
    name:           json['name'],
    journalRecords: json['journal_record_ids'].cast<int>()
  );

  @override
  String get postUrl => 'routes';

  @override
  Map<String, dynamic> serialize() => {
    'name': name
  };

  @override
  String get deleteUrl => 'routes/$id';

}
