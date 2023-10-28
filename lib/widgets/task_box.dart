import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:what_to_do/models/task_model.dart';

class TaskBox extends StatelessWidget {
  final TaskVM task;
  final double boxWidth;
  final Function() toggle;
  final Function(String text) edit;
  final Function() remove;
  final bool? reordering;
  const TaskBox(
      {required this.task,
      required this.boxWidth,
      required this.edit,
      required this.toggle,
      required this.remove,
      this.reordering,
      super.key});

  @override
  Widget build(BuildContext context) {
    editTask() {
      showDialog(
          context: context,
          builder: (context) {
            TextEditingController taskController =
                TextEditingController(text: task.text);

            return SimpleDialog(
              backgroundColor: Theme.of(context).cardColor,
              elevation: 0,
              contentPadding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Task',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xff424242),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: taskController,
                  autofocus: true,
                  style: const TextStyle(height: 1),
                  decoration: const InputDecoration(
                    hintText: 'Task',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    edit(taskController.text);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                        fontSize: 14,
                        height: 1,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
              ],
            );
          });
    }

    return Dismissible(
      key: Key('task${task.id}'),
      onDismissed: (direction) {
        remove();
      },
      child: Container(
        width: boxWidth,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: reordering == true
                  ? const Color(0xff39A0FF).withOpacity(0.5)
                  : Colors.grey.withOpacity(0.25),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.date != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        DateFormat('MMMM d, E').format(task.date!),
                        style: TextStyle(
                            fontSize: 10,
                            color: task.completed
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: toggle,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: task.completed
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).colorScheme.primary,
                            border: Border.all(
                                color: Theme.of(context).disabledColor,
                                width: 1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task.text,
                          style: TextStyle(
                            color: task.completed
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).colorScheme.onPrimary,
                            fontSize: 12,
                            height: 1.5,
                            leadingDistribution: TextLeadingDistribution.even,
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onTap: () {
                  editTask();
                },
                child: Image.asset(
                  'assets/icons/menu_filled.png',
                  width: 18,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTaskBox extends StatelessWidget {
  final TaskVM task;
  final double boxWidth;
  final Function() toggle;
  const HomeTaskBox(
      {required this.task,
      required this.boxWidth,
      required this.toggle,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: task.completed
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
                border: Border.all(
                    color: Theme.of(context).disabledColor, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.text,
              style: TextStyle(
                color: task.completed
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
                height: 1.5,
                leadingDistribution: TextLeadingDistribution.even,
                decoration: task.completed ? TextDecoration.lineThrough : null,
                decorationColor: Theme.of(context).disabledColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
