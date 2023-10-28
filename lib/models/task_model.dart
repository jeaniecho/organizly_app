import 'package:flutter/material.dart';

class TaskVM {
  final int id;
  int index;
  bool completed;
  String text;
  DateTime? date;
  FocusNode? focusNode;

  TaskVM({
    required this.id,
    required this.index,
    required this.completed,
    required this.text,
    this.date,
    this.focusNode,
  });

  TaskVM copyWith({int? index, bool? completed, String? text, DateTime? date}) {
    return TaskVM(
      id: id,
      index: index ?? this.index,
      completed: completed ?? this.completed,
      text: text ?? this.text,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task_index': index,
      'completed': completed ? 1 : 0,
      'text': text,
      if (date != null) 'date': date!.millisecondsSinceEpoch,
    };
  }
}
