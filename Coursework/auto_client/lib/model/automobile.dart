class Automobile {

  final int id;
  final String num;
  final String color;
  final String mark;
  final int driverId;
  final List<int> journalRecords;

  Automobile(
    this.id,
    this.num,
    this.color,
    this.mark,
    this.driverId,
    this.journalRecords
  );

  factory Automobile.fromJson(Map<String, dynamic> json) => Automobile(
    json['id'],
    json['num'],
    json['color'],
    json['mark'],
    json['driver_id'],
    json['journal_record_ids'].cast<int>()
  );

}
