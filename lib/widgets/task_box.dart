import 'package:flutter/material.dart';
import 'package:what_to_do/models/task_model.dart';

class TaskBox extends StatelessWidget {
  final TaskVM task;
  final double boxWidth;
  final Function() toggle;
  final Function(String text) submit;
  final Function() remove;
  final bool? reordering;
  const TaskBox(
      {required this.task,
      required this.boxWidth,
      required this.submit,
      required this.toggle,
      required this.remove,
      this.reordering,
      super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textController =
        TextEditingController(text: task.text);
    textController.selection =
        TextSelection.collapsed(offset: textController.text.length);

    FocusNode focusNode = task.focusNode ?? FocusNode();

    return Dismissible(
      key: Key('task${task.id}'),
      onDismissed: (direction) {
        remove();
      },
      child: Container(
        width: boxWidth,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: TextField(
                        focusNode: focusNode,
                        controller: textController,
                        enabled: !task.completed,
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
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        onSubmitted: submit,
                        onTapOutside: (event) {
                          if (focusNode.hasPrimaryFocus) {
                            submit(textController.text);
                            focusNode.unfocus();
                          }
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isCollapsed: true,
                          isDense: true,
                          // contentPadding: EdgeInsets.only(top: -4),
                        ),
                      ),
                    ),
                  ),
                  // if (!task.completed)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Image.asset(
                      'assets/icons/menu_filled.png',
                      width: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 2),
            // GestureDetector(
            //   onTap: remove,
            //   child: const Icon(
            //     Icons.close,
            //     size: 16,
            //     color: Colors.grey,
            //   ),
            // )
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
