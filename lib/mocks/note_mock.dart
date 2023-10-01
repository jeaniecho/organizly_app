import 'package:what_to_do/models/note_model.dart';

NoteVM noteMock0 = NoteVM(
    id: 0,
    pinned: false,
    text:
        'This is note mock 0\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id ante pulvinar, accumsan sem et, placerat nibh. Vestibulum malesuada vel arcu placerat sollicitudin. Suspendisse eu velit ac nibh auctor faucibus.');
NoteVM noteMock1 = NoteVM(id: 1, pinned: false, text: 'This is note mock 1');
NoteVM noteMock2 = NoteVM(
    id: 2,
    pinned: true,
    text:
        'This is pinned note mock 2\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id ante pulvinar, accumsan sem et, placerat nibh. Vestibulum malesuada vel arcu placerat sollicitudin. Suspendisse eu velit ac nibh auctor faucibus.');
NoteVM noteMock3 = NoteVM(
    id: 3,
    pinned: false,
    text:
        'This is note mock 3\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sit amet maximus odio, et elementum est. Aenean venenatis lacus sit amet tortor pretium, et molestie velit tempus. Mauris at arcu commodo, venenatis nisl nec, interdum sapien. Praesent eget ipsum quis tortor gravida lacinia. Mauris condimentum quis ex ut efficitur. Mauris non quam pharetra, vehicula mauris ut, eleifend justo. Morbi ut nisi sollicitudin, tristique ligula et, pharetra tellus. Quisque vitae neque molestie diam sodales laoreet at eget erat. Donec ante nulla, dignissim at odio non, feugiat efficitur lacus. Vivamus convallis porta.');
NoteVM noteMock4 =
    NoteVM(id: 4, pinned: true, text: 'This is pinned note mock 4');

List<NoteVM> noteMockList0 = [
  noteMock0,
  noteMock1,
  noteMock2,
  noteMock3,
  noteMock4,
];
