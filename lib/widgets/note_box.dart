import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:what_to_do/models/note_model.dart';

class NoteBox extends StatelessWidget {
  final NoteVM note;
  final double boxWidth;
  final Function() pin;
  final Function(String text) edit;
  final Function() remove;
  const NoteBox(
      {required this.note,
      required this.boxWidth,
      required this.pin,
      required this.edit,
      required this.remove,
      super.key});

  @override
  Widget build(BuildContext context) {
    Color iconColor = const Color(0xFF424242);

    TextEditingController textController =
        TextEditingController(text: note.text);
    textController.selection =
        TextSelection.collapsed(offset: textController.text.length);

    return Container(
        width: boxWidth,
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
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  DateFormat('yyyy.MM.dd').format(note.dateTime),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: remove,
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 16,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: pin,
                  child: Icon(
                    note.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 16,
                    color: note.pinned ? Colors.blue : iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              focusNode: note.focusNode,
              controller: textController,
              style: const TextStyle(
                fontSize: 14,
              ),
              minLines: 1,
              maxLines: 100,
              keyboardType: TextInputType.text,
              onSubmitted: edit,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();

                if (textController.text.isEmpty) {
                  remove();
                } else {
                  edit(textController.text);
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ));
  }
}

class HomeNoteBox extends StatelessWidget {
  final NoteVM note;
  final double boxWidth;
  const HomeNoteBox({required this.note, required this.boxWidth, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxWidth,
      height: boxWidth,
      margin: const EdgeInsets.symmetric(vertical: 12),
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
      child: Text(
        note.text,
        style: const TextStyle(fontSize: 10, height: 0),
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
