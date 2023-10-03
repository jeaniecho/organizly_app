import 'dart:convert';

import 'package:what_to_do/models/task_model.dart';

class ProjectVM {
  int id;
  String title;
  List<TaskVM> tasks;

  ProjectVM({
    required this.id,
    required this.title,
    required this.tasks,
  });

  ProjectVM copyWith({int? id, String? title, List<TaskVM>? tasks}) {
    return ProjectVM(
      id: id ?? this.id,
      title: title ?? this.title,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'tasks': jsonEncode(tasks.map((e) => e.toMap()).toList()),
    };
  }
}
