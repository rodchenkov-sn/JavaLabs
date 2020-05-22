import 'package:autoclient/model/deletable.dart';
import 'package:autoclient/model/postable.dart';

import 'package:intl/intl.dart';

class JournalRecord implements Postable, Deleteble {

  final int id;
  final DateTime timeIn;
  final DateTime timeOut;
  final int automobileId;
  final int routeId;

  JournalRecord({this.id, this.timeIn, this.timeOut, this.automobileId, this.routeId});

  factory JournalRecord.fromJson(Map<String, dynamic> json) => JournalRecord(
    id:           json['id'],
    timeIn:       DateTime.fromMillisecondsSinceEpoch(json['time_in']),
    timeOut:      DateTime.fromMillisecondsSinceEpoch(json['time_out']),
    automobileId: json['automobile_id'],
    routeId:      json['route_id']
  );

  @override
  String get postUrl => 'journal';

  @override
  Map<String, dynamic> serialize() => {
    'time_in': timeIn.millisecondsSinceEpoch,
    'time_out': timeOut.millisecondsSinceEpoch,
    'automobile_id': automobileId,
    'route_id': routeId
  };

  @override
  String get deleteUrl => 'journal/$id';

  String get prettyTimeIn  => DateFormat('dd.MM.y HH:mm').format(timeIn);
  String get prettyTimeOut => DateFormat('dd.MM.y HH:mm').format(timeOut);

}
