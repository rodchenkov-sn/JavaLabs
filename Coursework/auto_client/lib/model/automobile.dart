import 'package:autoclient/model/deletable.dart';
import 'package:autoclient/model/postable.dart';

class Automobile implements Postable, Deleteble {

  final int id;
  final String num;
  final String color;
  final String mark;
  final int driverId;
  final List<int> journalRecords;

  Automobile({
    this.id,
    this.num,
    this.color,
    this.mark,
    this.driverId,
    this.journalRecords
  });

  factory Automobile.fromJson(Map<String, dynamic> json) => Automobile(
    id:             json['id'],
    num:            json['num'],
    color:          json['color'],
    mark:           json['mark'],
    driverId:       json['driver_id'],
    journalRecords: json['journal_record_ids'].cast<int>()
  );

  @override
  String get postUrl => 'automobiles';

  @override
  Map<String, dynamic> serialize() => {
    'num': num,
    'color': color,
    'mark': mark,
    'driver_id': driverId
  };

  @override
  String get deleteUrl => 'automobiles/$id';

}
