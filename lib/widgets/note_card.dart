// lib/widgets/note_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../screens/editor_screen.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onPinToggle;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onPinToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bg = kNoteColors[note.colorIndex];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title.isEmpty ? 'Untitled' : note.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  color: const Color(0xFF1E1E1E),
                  iconColor: Colors.white.withOpacity(0.3),
                  iconSize: 18,
                  padding: EdgeInsets.zero,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'pin',
                      child: Row(children: [
                        Icon(
                            note.isPinned
                                ? Icons.push_pin
                                : Icons.push_pin_outlined,
                            color: const Color(0xFFFFD166),
                            size: 18),
                        const SizedBox(width: 8),
                        Text(note.isPinned ? 'Unpin' : 'Pin',
                            style: const TextStyle(color: Colors.white)),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        const Icon(Icons.delete_outline,
                            color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        const Text('Delete',
                            style: TextStyle(color: Colors.redAccent)),
                      ]),
                    ),
                  ],
                  onSelected: (val) {
                    if (val == 'delete') onDelete();
                    if (val == 'pin') onPinToggle();
                  },
                ),
              ],
            ),
            if (note.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                note.content,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 13,
                    height: 1.5),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Text(
              DateFormat('MMM d, yyyy').format(note.updatedAt),
              style: TextStyle(
                  color: Colors.white.withOpacity(0.25),
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
