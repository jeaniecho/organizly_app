import 'dart:convert';

import 'package:what_to_do/models/task_model.dart';

class ProjectVM {
  final int id;
  int index;
  String title;
  List<TaskVM> tasks;
  DateTime? date;

  ProjectVM({
    required this.id,
    required this.index,
    required this.title,
    required this.tasks,
    this.date,
  });

  ProjectVM copyWith(
      {int? index, String? title, List<TaskVM>? tasks, DateTime? date}) {
    return ProjectVM(
      id: id,
      index: index ?? this.index,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
      date: date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_index': index,
      'title': title,
      'tasks': jsonEncode(tasks.map((e) => e.toMap()).toList()),
      'date': date == null ? 0 : date!.millisecondsSinceEpoch,
    };
  }
}
