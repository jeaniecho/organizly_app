class TaskVM {
  int id;
  bool completed;
  String text;

  TaskVM({required this.id, required this.completed, required this.text});

  TaskVM copyWith({int? id, bool? completed, String? text}) {
    return TaskVM(
      id: id ?? this.id,
      completed: completed ?? this.completed,
      text: text ?? this.text,
    );
  }
}
