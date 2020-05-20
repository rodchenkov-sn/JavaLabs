import 'package:autoclient/model/postable.dart';

class JournalRecord implements Postable {

  final int id;
  final DateTime timeIn;
  final DateTime timeOut;
  final int automobileId;
  final int routeId;

  JournalRecord(this.id, this.timeIn, this.timeOut, this.automobileId, this.routeId);

  factory JournalRecord.fromJson(Map<String, dynamic> json) => JournalRecord(
    json['id'],
    DateTime.fromMicrosecondsSinceEpoch(json['time_in']),
    DateTime.fromMicrosecondsSinceEpoch(json['time_out']),
    json['automobile_id'],
    json['route_id']
  );

  @override
  String postUrl() => 'journal';

  @override
  Map<String, dynamic> serialize() => {
    'time_in': timeIn.microsecondsSinceEpoch,
    'time_out': timeOut.microsecondsSinceEpoch,
    'automobile_id': automobileId,
    'route_id': routeId
  };

}
