import 'package:flutter/material.dart';

class TaskVM {
  int id;
  bool completed;
  String text;
  FocusNode? focusNode;

  TaskVM({
    required this.id,
    required this.completed,
    required this.text,
    this.focusNode,
  });

  TaskVM copyWith({int? id, bool? completed, String? text}) {
    return TaskVM(
      id: id ?? this.id,
      completed: completed ?? this.completed,
      text: text ?? this.text,
    );
  }
}
