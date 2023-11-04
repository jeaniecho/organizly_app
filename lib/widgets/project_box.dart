import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:info_popup/info_popup.dart';
import 'package:intl/intl.dart';
import 'package:what_to_do/models/project_model.dart';
import 'package:what_to_do/styles/colors.dart';

class ProjectBox extends StatelessWidget {
  final ProjectVM project;
  final bool isSelected;
  final int pendingTasks;
  final int completedTasks;
  final Function(String title) edit;
  final Function(DateTime? date) editDate;
  final Function() remove;
  const ProjectBox(
      {required this.project,
      required this.isSelected,
      required this.pendingTasks,
      required this.completedTasks,
      required this.edit,
      required this.editDate,
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
        color: isSelected ? Colors.blue : Theme.of(context).cardColor,
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
              Expanded(
                child: Text(
                  project.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
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
                            elevation: 0,
                            contentPadding: const EdgeInsets.all(24),
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Color(0xff424242),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  project.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          elevation: 0,
                                          contentPadding:
                                              const EdgeInsets.all(24),
                                          children: [
                                            const Text('Edit Project Name'),
                                            TextField(
                                              autofocus: true,
                                              controller: nameController,
                                              style: const TextStyle(height: 1),
                                              decoration: const InputDecoration(
                                                hintText: 'Project Name',
                                                hintStyle: TextStyle(
                                                  color: Color(0xffaeaeae),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ElevatedButton(
                                              onPressed: () {
                                                edit(nameController.text);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Done',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    height: 1,
                                                    color: Color(0xff39A0FF)),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  'Edit Project Name',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2200),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: Theme.of(context)
                                                    .colorScheme,
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Theme.of(
                                                            context)
                                                        .colorScheme
                                                        .onPrimary, // button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        ).then((value) {
                                          if (value != null) {
                                            editDate(value);
                                          }
                                        });
                                      },
                                      child: Text(
                                        project.date == null
                                            ? 'Add Date'
                                            : 'Edit Date',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                      ),
                                    ),
                                  ),
                                  if (project.date != null)
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            editDate(null);
                                          },
                                          child: Text(
                                            'Delete Date',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  remove();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Delete Project',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Image.asset(
                    'assets/icons/edit.png',
                    width: 18,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$pendingTasks task${pendingTasks > 1 ? 's' : ''} pending',
            style: TextStyle(
              fontSize: 10,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          if (project.date != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  InfoPopupWidget(
                    contentTitle:
                        'Complete ${(project.tasks.length / (project.date!.difference(DateTime.now()).inDays)).ceil()} tasks today',
                    contentTheme: const InfoPopupContentTheme(
                        infoContainerBackgroundColor: OGColors.gray080,
                        infoTextStyle: TextStyle(color: OGColors.white),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    arrowTheme:
                        const InfoPopupArrowTheme(color: OGColors.gray080),
                    contentOffset: const Offset(48, 0),
                    child: Image.asset(
                      'assets/icons/projects.png',
                      width: 14,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('yyyy.MM.dd').format(project.date!),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${project.tasks.isEmpty ? 0 : ((completedTasks / project.tasks.length) * 100).round()}%',
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.tertiary,
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
