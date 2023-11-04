import 'dart:convert';

import 'package:what_to_do/models/task_model.dart';

class ProjectVM {
  int id;
  String title;
  List<TaskVM> tasks;
  DateTime? date;

  ProjectVM({
    required this.id,
    required this.title,
    required this.tasks,
    this.date,
  });

  ProjectVM copyWith(
      {int? id, String? title, List<TaskVM>? tasks, DateTime? date}) {
    return ProjectVM(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
      date: date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'tasks': jsonEncode(tasks.map((e) => e.toMap()).toList()),
      'date': date == null ? 0 : date!.millisecondsSinceEpoch,
    };
  }
}
