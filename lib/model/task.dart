import 'package:ristask/utils/extension/string_extension.dart';

class Task {
  final int? id;
  final int isDone;
  final String? title;
  final String? date;
  final String? time;
  
  const Task({
    this.id,
    this.isDone = 0,
    this.title,
    this.date,
    this.time
  });

  Task copyWith({
    int? id,
    int? isDone,
    String? title,
    String? date,
    String? time
  }) =>
      Task(
        id: id ?? this.id,
        isDone: isDone ?? this.isDone,
        title: title ?? this.title,
        date: date ?? this.date,
        time: time ?? this.time
      );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    isDone: json['isDone'],
    title: json['title'],
    date: json['date'],
    time: json['time']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'isDone': isDone,
    'title': title,
    'date': date,
    'time': time
  };

  static DateTime toDateTime(Task task) {
    return DateTime.parse(
      '${task.date!} ${task.time!.getHour()}:${task.time!.getMinute()}:00'
    );
  }
}