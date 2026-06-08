// lib/screens/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('About', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // App icon placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD166),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD166).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.note_alt_rounded, size: 54, color: Colors.black),
            ),
            const SizedBox(height: 24),
            const Text(
              'Notely',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5),
            ),
            const SizedBox(height: 6),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
            ),
            const SizedBox(height: 40),
            _featureCard(
              Icons.save_outlined,
              'Local Storage',
              'All your notes are saved privately on your device — no internet required.',
            ),
            const SizedBox(height: 12),
            _featureCard(
              Icons.palette_outlined,
              'Colour Themes',
              'Personalise each note with a unique background colour.',
            ),
            const SizedBox(height: 12),
            _featureCard(
              Icons.push_pin_outlined,
              'Pin Notes',
              'Keep your most important notes right at the top.',
            ),
            const SizedBox(height: 12),
            _featureCard(
              Icons.search_rounded,
              'Quick Search',
              'Find any note instantly by title or content.',
            ),
            const SizedBox(height: 48),
            // Credits Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFFFD166).withOpacity(0.3), width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD166).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'CREDITS',
                      style: TextStyle(
                          color: Color(0xFFFFD166),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Made by',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Israel Olukayode',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.white.withOpacity(0.07)),
                  const SizedBox(height: 12),
                  Text(
                    'Built with Flutter & Dart',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© ${DateTime.now().year} Israel Olukayode. All rights reserved.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.25), fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD166).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFFD166), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
                const SizedBox(height: 3),
                Text(desc,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
