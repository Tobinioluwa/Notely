// lib/screens/editor_screen.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../services/notes_service.dart';

const List<Color> kNoteColors = [
  Color(0xFF1E1E1E),
  Color(0xFF1A2F3A),
  Color(0xFF2A1F3A),
  Color(0xFF1F2E1A),
  Color(0xFF3A2A1A),
  Color(0xFF2A1A1A),
];

class EditorScreen extends StatefulWidget {
  final Note? existing;
  const EditorScreen({super.key, this.existing});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late int _colorIndex;
  late bool _isPinned;
  final _service = NotesService();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.existing?.content ?? '');
    _colorIndex = widget.existing?.colorIndex ?? 0;
    _isPinned = widget.existing?.isPinned ?? false;

    _titleCtrl.addListener(() => _hasChanges = true);
    _contentCtrl.addListener(() => _hasChanges = true);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final now = DateTime.now();
    if (widget.existing != null) {
      await _service.updateNote(widget.existing!.copyWith(
        title: title.isEmpty ? 'Untitled' : title,
        content: content,
        updatedAt: now,
        colorIndex: _colorIndex,
        isPinned: _isPinned,
      ));
    } else {
      await _service.addNote(Note(
        id: const Uuid().v4(),
        title: title.isEmpty ? 'Untitled' : title,
        content: content,
        createdAt: now,
        updatedAt: now,
        colorIndex: _colorIndex,
        isPinned: _isPinned,
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bg = kNoteColors[_colorIndex];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: _save,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: _isPinned ? const Color(0xFFFFD166) : Colors.white.withOpacity(0.5),
            ),
            onPressed: () => setState(() => _isPinned = !_isPinned),
          ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline, color: Color(0xFFFFD166)),
            onPressed: _save,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildColorPicker(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                children: [
                  TextField(
                    controller: _titleCtrl,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.25),
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                    maxLines: 1,
                  ),
                  Divider(color: Colors.white.withOpacity(0.1)),
                  Expanded(
                    child: TextField(
                      controller: _contentCtrl,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 15,
                          height: 1.7),
                      decoration: InputDecoration(
                        hintText: 'Start writing...',
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.2), fontSize: 15),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text('Color  ',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.4), fontSize: 12)),
          ...List.generate(
            kNoteColors.length,
            (i) => GestureDetector(
              onTap: () => setState(() => _colorIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                width: _colorIndex == i ? 28 : 22,
                height: _colorIndex == i ? 28 : 22,
                decoration: BoxDecoration(
                  color: kNoteColors[i],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _colorIndex == i
                        ? const Color(0xFFFFD166)
                        : Colors.white.withOpacity(0.2),
                    width: _colorIndex == i ? 2.5 : 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
