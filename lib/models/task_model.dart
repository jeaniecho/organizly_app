class TaskVM {
  bool completed;
  String text;

  TaskVM({required this.completed, required this.text});

  TaskVM copyWith({bool? completed, String? text}) {
    return TaskVM(
      completed: completed ?? this.completed,
      text: text ?? this.text,
    );
  }
}
