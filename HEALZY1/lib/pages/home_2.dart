import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healzy/pages/dance.dart';
import 'package:healzy/pages/home3_voice_inp.dart';

class MoodInputPage extends StatefulWidget {
  @override
  State<MoodInputPage> createState() => _MoodInputPageState();
}

class _MoodInputPageState extends State<MoodInputPage> {
  final TextEditingController moodController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !_hasFocused) {
        setState(() {
          _hasFocused = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    moodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6F3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Back arrow and title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black54),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.chevron_left, size: 28, color: Colors.black87),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Self Assessment',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: Colors.grey[300],
                  color: Colors.black87,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(height: 16),

              // Additional progress bar

              const SizedBox(height: 30),

              // Greeting
              Center(
                child: Text(
                  'Hey shalini, I was just\nthinking about you!\nHow was your day?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Subheading
              Text(
                'Type your moods',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Mood Input Box
              Container(
                padding: const EdgeInsets.all(16),
                height: 220,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.brown.shade500),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextField(
                  focusNode: _focusNode,
                  controller: moodController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: GoogleFonts.outfit(fontSize: 16),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: _hasFocused
                        ? ""
                        : "Hey...\n  don’t know, I just feel bad today.\nNothing major happened, but everything annoyed me.\nLittle things kept piling up and got under my skin.\nTried to stay calm, but it was hard.\nFelt like no one really got what I was feeling.\nJust mentally exhausted right now.",
                    hintStyle: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Voice button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VoiceInputPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AAF67),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: Text(
                    "Use voice instead",
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Continue Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DancePage(),));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A2E19),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}