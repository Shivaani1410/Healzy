import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:healzy/pages/rec_final_clap.dart'; // animate package

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(
        UrlSource("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
      );
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Widget _buildWaveformBars() {
    List<double> heights = [20, 35, 25, 40, 30];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(heights.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            width: 6,
            height: heights[index],
            decoration: BoxDecoration(
              color: const Color(0xFF6B6B6B),
              borderRadius: BorderRadius.circular(4),
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          ).moveY(
            duration: Duration(milliseconds: 500 + index * 100),
            curve: Curves.easeInOut,
            begin: 0,
            end: -10,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Decorative circles
            Positioned(top: 180, left: 20, child: _buildCircle(Colors.orange, 20)),
            Positioned(top: 160, right: 40, child: _buildCircle(Colors.green, 20)),
            Positioned(top: 240, right: 80, child: _buildCircle(Colors.orange, 20)),
            Positioned(top: 300, left: 60, child: _buildCircle(Colors.green, 20)),
            Positioned(top: 220, left: 110, child: _buildCircle(Colors.orange, 20)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Music image
                  Image.asset(
                    'images/music.png',
                    height: 240,
                  ),

                  const SizedBox(height: 24),

                  // Motivation text
                  const Text(
                    "Consider listening to this uplifting playlist I created especially for moments like this.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      color: Color(0xFF6B6B6B),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Waveform animation only when playing
                  if (isPlaying) ...[
                    _buildWaveformBars(),
                    const SizedBox(height: 20),
                  ],

                  // Play/pause button
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFDDE6C6),
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 30,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3C2A20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MotivationalScreen(),));
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
    );
  }
}