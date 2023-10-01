import 'package:flutter/material.dart';

class NoteVM {
  int id;
  bool pinned;
  String text;
  FocusNode? focusNode;

  NoteVM({
    required this.id,
    required this.pinned,
    required this.text,
    this.focusNode,
  });

  NoteVM copyWith({int? id, bool? pinned, String? text}) {
    return NoteVM(
      id: id ?? this.id,
      pinned: pinned ?? this.pinned,
      text: text ?? this.text,
    );
  }
}
