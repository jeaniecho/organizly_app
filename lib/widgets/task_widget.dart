import 'package:flutter/material.dart';
import 'package:what_to_do/models/task_model.dart';

class TaskBox extends StatelessWidget {
  final TaskVM task;
  final Function() toggle;
  final Function(String text) edit;
  const TaskBox(
      {required this.task,
      required this.edit,
      required this.toggle,
      super.key});

  @override
  Widget build(BuildContext context) {
    Color completedColor = const Color(0xFFCDCDCD);

    TextEditingController textController =
        TextEditingController(text: task.text);

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
          GestureDetector(
            onTap: toggle,
            child: Container(
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
          ),
          const SizedBox(width: 8),
          IntrinsicWidth(
            child: TextField(
              controller: textController,
              style: TextStyle(
                color: task.completed ? completedColor : Colors.black,
                fontSize: 12,
              ),
              onSubmitted: edit,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
