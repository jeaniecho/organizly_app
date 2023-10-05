import 'package:flutter/material.dart';

class TaskVM {
  final int id;
  int index;
  bool completed;
  String text;
  FocusNode? focusNode;

  TaskVM({
    required this.id,
    required this.index,
    required this.completed,
    required this.text,
    this.focusNode,
  });

  TaskVM copyWith({int? index, bool? completed, String? text}) {
    return TaskVM(
      id: id,
      index: index ?? this.index,
      completed: completed ?? this.completed,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_index': index,
      'completed': completed ? 1 : 0,
      'text': text,
    };
  }
}
