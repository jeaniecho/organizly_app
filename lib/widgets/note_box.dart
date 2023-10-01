import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:what_to_do/models/note_model.dart';

class NoteBox extends StatefulWidget {
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
  State<NoteBox> createState() => _NoteBoxState();
}

class _NoteBoxState extends State<NoteBox> {
  Color iconColor = const Color(0xFF424242);

  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textController.text = widget.note.text;
    textController.selection =
        TextSelection.collapsed(offset: textController.text.length);

    return Container(
        width: widget.boxWidth,
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
                  DateFormat('yyyy.MM.dd').format(widget.note.dateTime),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.remove,
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 16,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.pin,
                  child: Icon(
                    widget.note.pinned
                        ? Icons.push_pin
                        : Icons.push_pin_outlined,
                    size: 16,
                    color: widget.note.pinned ? Colors.blue : iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            TextField(
              focusNode: widget.note.focusNode,
              controller: textController,
              style: const TextStyle(
                fontSize: 14,
              ),
              minLines: 1,
              maxLines: 100,
              keyboardType: TextInputType.text,
              onSubmitted: widget.edit,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();

                if (textController.text.isEmpty) {
                  widget.remove();
                } else {
                  widget.edit(textController.text);
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

class SmallNoteBox extends StatelessWidget {
  final NoteVM note;
  final double boxWidth;
  const SmallNoteBox({required this.note, required this.boxWidth, super.key});

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
