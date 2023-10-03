import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:what_to_do/models/project_model.dart';

class ProjectBox extends StatelessWidget {
  final ProjectVM project;
  final bool isSelected;
  final int pendingTasks;
  final int completedTasks;
  final Function(String title) edit;
  final Function() remove;
  const ProjectBox(
      {required this.project,
      required this.isSelected,
      required this.pendingTasks,
      required this.completedTasks,
      required this.edit,
      required this.remove,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project.title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isSelected)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();

                    TextEditingController nameController =
                        TextEditingController(text: project.title);

                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            contentPadding: const EdgeInsets.all(24),
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          contentPadding:
                                              const EdgeInsets.all(24),
                                          children: [
                                            const Text('Edit Project Name'),
                                            TextField(
                                              autofocus: true,
                                              controller: nameController,
                                              decoration: const InputDecoration(
                                                hintText: 'Project Name',
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ElevatedButton(
                                              onPressed: () {
                                                edit(nameController.text);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Done'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: const Text('Edit Project Name'),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  remove();
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete Project'),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Icon(
                    Icons.more,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$pendingTasks tasks pending',
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${project.tasks.isEmpty ? 0 : ((completedTasks / project.tasks.length) * 100).round()}%',
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
          LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 4,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                if (project.tasks.isNotEmpty)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    width: constraints.maxWidth *
                        (completedTasks / project.tasks.length),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.grey[800] : Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
