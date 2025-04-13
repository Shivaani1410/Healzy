import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:healzy/pages/home_2.dart';

import 'home_screen.dart';

class VoiceInputPage extends StatefulWidget {
  @override
  _VoiceInputPageState createState() => _VoiceInputPageState();
}

class _VoiceInputPageState extends State<VoiceInputPage> {
  bool isRecording = false;
  int seconds = 0;
  Timer? timer;

  void toggleRecording() {
    setState(() {
      isRecording = !isRecording;

      if (isRecording) {
        seconds = 0;
        timer = Timer.periodic(Duration(seconds: 1), (_) {
          setState(() {
            seconds++;
          });
        });
      } else {
        timer?.cancel();
      }
    });
  }

  String formatDuration(int seconds) {
    final Duration duration = Duration(seconds: seconds);
    return duration.toString().substring(2, 7); // mm:ss
  }

  List<Widget> _buildBars(double width) {
    List<double> barHeights = [30, 60, 80, 100, 80, 60, 30, 40, 70, 90, 60, 40, 20, 50, 75, 100];
    int count = barHeights.length;
    double totalSpacing = (count - 1) * 6;
    double barWidth = (width - totalSpacing) / count;

    return barHeights
        .map(
          (h) => AnimatedContainer(
        duration: Duration(milliseconds: 400),
        margin: EdgeInsets.symmetric(horizontal: 3),
        width: barWidth,
        height: isRecording ? h + (10 * (h % 2)) : h,
        decoration: BoxDecoration(
          color: Color(0xFFB3886B).withOpacity(h / 100),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    )
        .toList();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFFBF6F3),
      body: SafeArea(
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
                      icon: Icon(Icons.chevron_left, size: 28, color: Colors.black87), // more like a "V"
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MoodInputPage()),
                        );
                      },
                    ),
                  ),

                  SizedBox(width: 12),
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

            SizedBox(height: 24),

            // Main Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Today I had a hard time concentrating. I was very worried about '
                    'making mistakes, very angry',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: Colors.grey[800],
                ),
              ),
            ),

            SizedBox(height: 40),

            // Voice bars (only when recording)
            if (isRecording)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildBars(width - 60), // leave some padding to avoid overflow
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: Duration(seconds: 1), color: Colors.brown.shade200),

            SizedBox(height: isRecording ? 40 : 60),

            // Mic Button
            GestureDetector(
              onTap: toggleRecording,
              child: CircleAvatar(
                radius: 44,
                backgroundColor: Color(0xFF4A2E19),
                child: Icon(
                  isRecording ? Icons.stop : Icons.mic,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 12),

            // Timer
            Text(
              formatDuration(seconds),
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            Spacer(),

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFFF914D),
                    child: Icon(Icons.close, color: Colors.white),
                  ),

                  MaterialButton(
                    onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => MoodInputPage(),)); },
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFF9AAF67),
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}