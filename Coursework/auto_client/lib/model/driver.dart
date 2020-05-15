class Driver {

  final int id;
  final String firstName;
  final String lastName;
  final String fatherName;
  final List<int> automobiles;

  Driver(
    this.id,
    this.firstName,
    this.lastName,
    this.fatherName,
    this.automobiles
  );

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    json['id'],
    json['first_name'],
    json['last_name'],
    json['father_name'],
    json['automobile_ids'].cast<int>()
  );

}
