class Route {

  final int id;
  final String name;
  final List<int> journalRecords;

  Route(this.id, this.name, this.journalRecords);

  factory Route.fromJson(Map<String, dynamic> json) => Route(
    json['id'],
    json['name'],
    json['journal_record_ids'].cast<int>()
  );

}
