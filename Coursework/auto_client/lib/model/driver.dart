import 'package:autoclient/model/deletable.dart';
import 'package:autoclient/model/postable.dart';

class Driver implements Postable, Deleteble {

  final int id;
  final String firstName;
  final String lastName;
  final String fatherName;
  final List<int> automobiles;

  Driver({
    this.id,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.automobiles
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    id:          json['id'],
    firstName:   json['first_name'],
    lastName:    json['last_name'],
    fatherName:  json['father_name'],
    automobiles: json['automobile_ids'].cast<int>()
  );

  @override
  String get postUrl => 'personnel';

  @override
  Map<String, dynamic> serialize() => fatherName == null ? {
    'first_name': firstName,
    'last_name': lastName
  } : {
    'first_name': firstName,
    'last_name': lastName,
    'father_name': fatherName
  };

  @override
  String get deleteUrl => 'personnel/$id';

}
