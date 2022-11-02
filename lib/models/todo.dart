class Todo {
  Todo({required this.title, required this.dateTime, required this.index});

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['datetime']),
        isDone = json['isDone'] == 'true' ? true : false,
        index = DateTime.parse(json['index']);

  String title;
  DateTime dateTime;
  bool isDone = false;
  DateTime index;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'datetime': dateTime.toIso8601String(),
      'isDone': isDone.toString(),
      'index': index.toIso8601String(),
    };
  }
}
