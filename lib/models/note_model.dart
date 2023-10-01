import 'package:flutter/material.dart';

class NoteVM {
  int id;
  bool pinned;
  String text;
  DateTime dateTime;
  FocusNode? focusNode;

  NoteVM({
    required this.id,
    required this.pinned,
    required this.text,
    required this.dateTime,
    this.focusNode,
  });

  NoteVM copyWith({int? id, bool? pinned, String? text, DateTime? dateTime}) {
    return NoteVM(
      id: id ?? this.id,
      pinned: pinned ?? this.pinned,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
