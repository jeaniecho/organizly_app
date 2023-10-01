import 'package:flutter/material.dart';
import 'package:what_to_do/models/project_model.dart';

class ProjectBox extends StatelessWidget {
  final ProjectVM project;
  final bool isSelected;
  final int pendingTasks;
  final int completedTasks;
  const ProjectBox(
      {required this.project,
      required this.isSelected,
      required this.pendingTasks,
      required this.completedTasks,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
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
                  onTap: () {},
                  child: const Icon(
                    Icons.edit_note,
                    color: Colors.white,
                    size: 24,
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
                  Container(
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
