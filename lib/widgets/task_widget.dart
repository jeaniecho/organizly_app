import 'package:flutter/material.dart';
import 'package:what_to_do/models/task_model.dart';

class TaskBox extends StatelessWidget {
  final TaskVM task;
  const TaskBox({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    Color completedColor = const Color(0xFFCDCDCD);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: task.completed ? completedColor : Colors.white,
              border: Border.all(color: completedColor, width: 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            task.text,
            style: TextStyle(
              color: task.completed ? completedColor : Colors.black,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<TaskVM> tasks;
  const TaskList({required this.tasks, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: ((context, index) {
          return TaskBox(task: tasks[index]);
        }),
        separatorBuilder: ((context, index) {
          return const SizedBox(height: 12);
        }),
        itemCount: tasks.length);
  }
}
