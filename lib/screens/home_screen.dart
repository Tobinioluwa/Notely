// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../services/notes_service.dart';
import '../widgets/note_card.dart';
import 'editor_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotesService _service = NotesService();
  List<Note> _notes = [];
  List<Note> _filtered = [];
  bool _isLoading = true;
  String _query = '';
  bool _gridView = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final notes = await _service.loadNotes();
    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    setState(() {
      _notes = notes;
      _filtered = notes;
      _isLoading = false;
    });
  }

  void _search(String q) {
    setState(() {
      _query = q;
      _filtered = q.isEmpty
          ? _notes
          : _notes
              .where((n) =>
                  n.title.toLowerCase().contains(q.toLowerCase()) ||
                  n.content.toLowerCase().contains(q.toLowerCase()))
              .toList();
    });
  }

  Future<void> _openEditor([Note? note]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditorScreen(existing: note)),
    );
    _load();
  }

  Future<void> _deleteNote(Note note) async {
    await _service.deleteNote(note.id);
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Note deleted'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinned = _filtered.where((n) => n.isPinned).toList();
    final others = _filtered.where((n) => !n.isPinned).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFFD166)))
                  : _filtered.isEmpty
                      ? _buildEmptyState()
                      : _buildNotesList(pinned, others),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        backgroundColor: const Color(0xFFFFD166),
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('New Note', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 8,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE').format(DateTime.now()),
                  style: const TextStyle(
                      color: Color(0xFFFFD166),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2),
                ),
                const Text(
                  'My Notes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5),
                ),
                Text(
                  '${_notes.length} note${_notes.length == 1 ? '' : 's'}',
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _gridView = !_gridView),
            icon: Icon(
              _gridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
            icon: Icon(Icons.info_outline, color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          onChanged: _search,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search notes...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.3)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList(List<Note> pinned, List<Note> others) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (pinned.isNotEmpty) ...[
          _sectionLabel('📌 Pinned'),
          _buildGrid(pinned),
          const SizedBox(height: 8),
        ],
        if (others.isNotEmpty) ...[
          if (pinned.isNotEmpty) _sectionLabel('Others'),
          _buildGrid(others),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
        child: Text(text,
            style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1)),
      );

  Widget _buildGrid(List<Note> notes) {
    if (_gridView) {
      return MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: notes.length,
        itemBuilder: (_, i) => NoteCard(
          note: notes[i],
          onTap: () => _openEditor(notes[i]),
          onDelete: () => _deleteNote(notes[i]),
          onPinToggle: () async {
            await NotesService()
                .updateNote(notes[i].copyWith(isPinned: !notes[i].isPinned));
            _load();
          },
        ),
      );
    } else {
      return Column(
        children: notes
            .map((n) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NoteCard(
                    note: n,
                    onTap: () => _openEditor(n),
                    onDelete: () => _deleteNote(n),
                    onPinToggle: () async {
                      await NotesService()
                          .updateNote(n.copyWith(isPinned: !n.isPinned));
                      _load();
                    },
                  ),
                ))
            .toList(),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined,
              size: 72, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            _query.isEmpty ? 'No notes yet' : 'No results found',
            style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            _query.isEmpty ? 'Tap + to create your first note' : 'Try a different keyword',
            style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
