import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healzy/pages/home_2.dart';
import 'package:healzy/pages/supp_bot.dart';

void main(){
  runApp(MaterialApp(home: HomeScreen(),));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EEE9), // Light beige background
      body: Stack(
        children: [
          Column(
            children: [
              // Header container
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF5A3A24), // Dark brown header
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wed, Nov 16 2025',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Shalini!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "The Explorer - You're curious and full of ideas.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              // Main content
              Image.asset(
                'images/home_img.png',
                height: 200,
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'I was just thinking \n about you! How was your day?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF5A3A24),
                  ),
                ),
              ),

              const Spacer(),

              Padding(padding: EdgeInsets.symmetric(vertical: 10)),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB7CC61), // Green button
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MoodInputPage()));
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              Padding(padding: EdgeInsets.symmetric(vertical: 25)),
              SizedBox(height: 30),

              // Bottom navigation bar
              const CustomBottomNavBar(),
              const SizedBox(height: 20),
            ],
          ),

          // Add floating chat bot button - now correctly positioned in the Stack
          Positioned(
            bottom: 215, // Position above continue button
            right: 25, // Right padding
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to chatbot screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatbotInterface()));
              },
              backgroundColor: const Color(0xFF5A3A24), // Match header color
              child: const Icon(
                Icons.android, // Bot chat icon
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        NavBarItem(
          iconData: Icons.home_rounded,
          label: 'Home',
          isActive: true,
        ),
        NavBarItem(
          iconData: Icons.favorite_rounded,
          label: 'Comfort Box',
        ),
        NavBarItem(
          iconData: Icons.emoji_events_rounded,
          label: 'Soul-up',
        ),
        NavBarItem(
          iconData: Icons.timeline_rounded,
          label: 'Future self',
        ),
        NavBarItem(
          iconData: Icons.person_rounded,
          label: 'Profile',
        ),
      ],
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final bool isActive;

  const NavBarItem({
    super.key,
    required this.iconData,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF5A3A24);
    final Color inactiveColor = Colors.grey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: 24,
          color: isActive ? activeColor : inactiveColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ChatbotScreen class - this is the page the chat button will navigate to
class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Healzy'),
        backgroundColor: const Color(0xFF5A3A24),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1EEE9),
      body: const Center(
        child: Text('Chatbot interface will be here'),
      ),
    );
  }
}