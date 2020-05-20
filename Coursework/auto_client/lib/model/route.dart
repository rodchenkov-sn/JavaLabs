import 'package:autoclient/model/postable.dart';

class Route implements Postable {

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
  String postUrl() => 'routes';

  @override
  Map<String, dynamic> serialize() => {
    'name': name
  };

}
