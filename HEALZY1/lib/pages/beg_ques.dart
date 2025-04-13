import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:healzy/pages/home_screen.dart';

class PersonalityTest extends StatefulWidget {
  @override
  _PersonalityTestState createState() => _PersonalityTestState();
}

class _PersonalityTestState extends State<PersonalityTest> with TickerProviderStateMixin {
  late AnimationController _leftCardController;
  late AnimationController _rightCardController;
  late AnimationController _pulseController;
  late AnimationController _backgroundController;

  late Animation<double> _leftCardRotation;
  late Animation<double> _rightCardRotation;
  late Animation<double> _leftCardSlide;
  late Animation<double> _rightCardSlide;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _backgroundAnimation;

  bool _isDragging = false;
  double _dragPosition = 0.0;

  // Personality scores
  int E = 0; // Extroversion
  int I = 0; // Introversion
  int S = 0; // Sensing
  int N = 0; // Intuition
  int T = 0; // Thinking
  int F = 0; // Feeling
  int J = 0; // Judging
  int P = 0; // Perceiving

  // Track answers for each question so we can adjust scores when going back
  List<String?> _answers = List.filled(12, null);

  // Define color schemes for each individual question
  final List<Map<String, Color>> _questionColors = [
    { // Question 1
      'primary': Color(0xFFA07055),
      'highlighted': Color(0xFFB18262),
      'arrow': Color(0xFF8B5E3C),
    },
    { // Question 2
      'primary': Color(0xFF5E8B8B),
      'highlighted': Color(0xFF72A6A6),
      'arrow': Color(0xFF2F4A4A),
    },
    { // Question 3
      'primary': Color(0xFF8B5E8B),
      'highlighted': Color(0xFFA672A6),
      'arrow': Color(0xFF4A2F4A),
    },
    { // Question 4
      'primary': Color(0xFF5E8B5E),
      'highlighted': Color(0xFF72A672),
      'arrow': Color(0xFF2F4A2F),
    },
    { // Question 5
      'primary': Color(0xFF7A55A0),
      'highlighted': Color(0xFF8F62B1),
      'arrow': Color(0xFF3C2F4A),
    },
    { // Question 6
      'primary': Color(0xFFA05564),
      'highlighted': Color(0xFFB16275),
      'arrow': Color(0xFF8B3C4A),
    },
    { // Question 7
      'primary': Color(0xFF55A076),
      'highlighted': Color(0xFF62B189),
      'arrow': Color(0xFF2F4A3C),
    },
    { // Question 8
      'primary': Color(0xFF5573A0),
      'highlighted': Color(0xFF6285B1),
      'arrow': Color(0xFF2F3C4A),
    },
    { // Question 9
      'primary': Color(0xFFA0A055),
      'highlighted': Color(0xFFB1B162),
      'arrow': Color(0xFF4A4A2F),
    },
    { // Question 10
      'primary': Color(0xFF7A8B5E),
      'highlighted': Color(0xFF8FA672),
      'arrow': Color(0xFF3C4A2F),
    },
    { // Question 11
      'primary': Color(0xFFA07685),
      'highlighted': Color(0xFFB18999),
      'arrow': Color(0xFF4A3C44),
    },
    { // Question 12
      'primary': Color(0xFF5E768B),
      'highlighted': Color(0xFF7289A6),
      'arrow': Color(0xFF2F3C4A),
    },
  ];

  // List of all questions
  final List<Map<String, dynamic>> _questions = [
    {
      'question': "1. When you're tired, what helps you feel better?",
      'leftOption': "Talking to someone or playing with friends",
      'rightOption': "Being alone, reading, or watching something quietly",
      'scoreType': 'EI', // Extroversion vs Introversion
      'emoji': '😴',
    },
    {
      'question': "2. At a birthday party, you usually...",
      'leftOption': "Talk to lots of people and have fun everywhere",
      'rightOption': "Stick with a few close friends or play by yourself",
      'scoreType': 'EI',
      'emoji': '🎂',
    },
    {
      'question': "3. In a group game, you like to...",
      'leftOption': "Be the leader or take charge",
      'rightOption': "Help quietly or play your own part",
      'scoreType': 'EI',
      'emoji': '🎮',
    },
    {
      'question': "4. Do you like stories that are...",
      'leftOption': "Real and simple",
      'rightOption': "Full of imagination or magic",
      'scoreType': 'SN', // Sensing vs Intuition
      'emoji': '📚',
    },
    {
      'question': "5. When learning something new, you like...",
      'leftOption': "Step by step with examples",
      'rightOption': "Big ideas and fun facts",
      'scoreType': 'SN',
      'emoji': '🧠',
    },
    {
      'question': "6. You mostly talk about...",
      'leftOption': "What's happening now",
      'rightOption': "What could happen or cool dreams",
      'scoreType': 'SN',
      'emoji': '💭',
    },
    {
      'question': "7. When you solve a problem, you use...",
      'leftOption': "Your brain – what makes sense",
      'rightOption': "Your heart – how people feel",
      'scoreType': 'TF', // Thinking vs Feeling
      'emoji': '🔍',
    },
    {
      'question': "8. If someone is sad, you...",
      'leftOption': "Help them fix the problem",
      'rightOption': "Try to make them feel better",
      'scoreType': 'TF',
      'emoji': '😢',
    },
    {
      'question': "9. People say you are...",
      'leftOption': "Smart and fair",
      'rightOption': "Kind and caring",
      'scoreType': 'TF',
      'emoji': '👤',
    },
    {
      'question': "10. Do you like to...",
      'leftOption': "Plan everything ahead",
      'rightOption': "Do things when you feel like it",
      'scoreType': 'JP', // Judging vs Perceiving
      'emoji': '📅',
    },
    {
      'question': "11. Homework time is...",
      'leftOption': "Now. I do it early",
      'rightOption': "Later. I'll do it when I feel ready",
      'scoreType': 'JP',
      'emoji': '📝',
    },
    {
      'question': "12. Going on a trip, you...",
      'leftOption': "Pack your bag and make a plan",
      'rightOption': "Just go! Figure it out as you go",
      'scoreType': 'JP',
      'emoji': '🧳',
    },
  ];

  int _currentQuestionIndex = 0;
  List<Particle> _confettiParticles = [];
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();

    // Initialize left card controller
    _leftCardController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize right card controller
    _rightCardController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize pulse animation controller
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize background animation controller
    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations with default values
    _leftCardRotation = Tween<double>(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(parent: _leftCardController, curve: Curves.easeOut)
    );

    _rightCardRotation = Tween<double>(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(parent: _rightCardController, curve: Curves.easeOut)
    );

    _leftCardSlide = Tween<double>(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(parent: _leftCardController, curve: Curves.easeOut)
    );

    _rightCardSlide = Tween<double>(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(parent: _rightCardController, curve: Curves.easeOut)
    );

    // Pulse animation for hints
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)
    );

    _leftCardController.addListener(() {
      setState(() {});
    });

    _rightCardController.addListener(() {
      setState(() {});
    });

    _pulseController.addListener(() {
      setState(() {});
    });

    // Listen for animation completion to move to next question
    _leftCardController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showConfettiEffect();
        Future.delayed(Duration(milliseconds: 500), () {
          _moveToNextQuestion();
        });
      }
    });

    _rightCardController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showConfettiEffect();
        Future.delayed(Duration(milliseconds: 500), () {
          _moveToNextQuestion();
        });
      }
    });
  }

  @override
  void dispose() {
    _leftCardController.dispose();
    _rightCardController.dispose();
    _pulseController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _showConfettiEffect() {
    // Generate random confetti particles
    _confettiParticles = List.generate(30, (index) {
      return Particle(
        position: Offset(MediaQuery.of(context).size.width / 2, 300),
        color: _getCurrentColorScheme()['primary']!,
        velocity: Offset(
          (math.Random().nextDouble() - 0.5) * 10,
          -math.Random().nextDouble() * 10 - 5,
        ),
      );
    });

    setState(() {
      _showConfetti = true;
    });

    // Animate background color
    _backgroundAnimation = ColorTween(
      begin: Color(0xFFFDFDFD),
      end: _getCurrentColorScheme()['primary']!.withOpacity(0.2),
    ).animate(
        CurvedAnimation(parent: _backgroundController, curve: Curves.easeOut)
    );

    _backgroundController.forward().then((_) {
      _backgroundController.reverse();
    });

    // Hide confetti after animation
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _showConfetti = false;
      });
    });
  }

  void _updateScore(bool isLeftCard) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final scoreType = currentQuestion['scoreType'];

    // Save the answer
    _answers[_currentQuestionIndex] = isLeftCard ? 'left' : 'right';

    if (scoreType == 'EI') {
      if (isLeftCard) {
        E += 1;
      } else {
        I += 1;
      }
    } else if (scoreType == 'SN') {
      if (isLeftCard) {
        S += 1;
      } else {
        N += 1;
      }
    } else if (scoreType == 'TF') {
      if (isLeftCard) {
        T += 1;
      } else {
        F += 1;
      }
    } else if (scoreType == 'JP') {
      if (isLeftCard) {
        J += 1;
      } else {
        P += 1;
      }
    }
  }

  void _removeScoreForPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      int prevIndex = _currentQuestionIndex - 1;
      String? prevAnswer = _answers[prevIndex];

      if (prevAnswer != null) {
        final prevQuestion = _questions[prevIndex];
        final scoreType = prevQuestion['scoreType'];

        bool wasLeftCard = prevAnswer == 'left';

        if (scoreType == 'EI') {
          if (wasLeftCard) {
            E -= 1;
          } else {
            I -= 1;
          }
        } else if (scoreType == 'SN') {
          if (wasLeftCard) {
            S -= 1;
          } else {
            N -= 1;
          }
        } else if (scoreType == 'TF') {
          if (wasLeftCard) {
            T -= 1;
          } else {
            F -= 1;
          }
        } else if (scoreType == 'JP') {
          if (wasLeftCard) {
            J -= 1;
          } else {
            P -= 1;
          }
        }

        // Clear the answer for this question
        _answers[prevIndex] = null;
      }
    }
  }

  void _moveToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _currentQuestionIndex++;
          _resetCards();
        });
      });
    } else {
      // Test completed - show results
      _showResults();
    }
  }

  void _moveToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      // Remove the score for the previous question
      _removeScoreForPreviousQuestion();

      setState(() {
        _currentQuestionIndex--;
        _resetCards();
      });
    }
  }

  void _handleBackArrow() {
    // If we're on the first question, exit the screen
    // Otherwise, go to the previous question
    if (_currentQuestionIndex == 0) {
      Navigator.of(context).pop();
    } else {
      _moveToPreviousQuestion();
    }
  }

  void _showResults() {
    // Create personality type string
    String personalityType = '';
    personalityType += (E > I) ? 'E' : 'I';
    personalityType += (S > N) ? 'S' : 'N';
    personalityType += (T > F) ? 'T' : 'F';
    personalityType += (J > P) ? 'J' : 'P';

    // Get personality descriptions
    Map<String, String> descriptions = {
      'INTJ': "The Architect - Strategic thinkers with a plan for everything",
      'INTP': "The Logician - Innovative inventors with an unquenchable thirst for knowledge",
      'ENTJ': "The Commander - Bold, imaginative and strong-willed leaders",
      'ENTP': "The Debater - Smart and curious thinkers who enjoy intellectual challenges",
      'INFJ': "The Advocate - Quiet and mystical, yet inspiring and tireless idealists",
      'INFP': "The Mediator - Poetic, kind and altruistic people, always eager to help",
      'ENFJ': "The Protagonist - Charismatic and inspiring leaders who mesmerize their listeners",
      'ENFP': "The Campaigner - Enthusiastic, creative and sociable free spirits",
      'ISTJ': "The Logistician - Practical and fact-minded individuals who value reliability",
      'ISFJ': "The Defender - Very dedicated and warm protectors, always ready to defend their loved ones",
      'ESTJ': "The Executive - Excellent administrators, unsurpassed at managing things or people",
      'ESFJ': "The Consul - Extraordinarily caring, social and popular people, always eager to help",
      'ISTP': "The Virtuoso - Bold and practical experimenters, masters of all kinds of tools",
      'ISFP': "The Adventurer - Flexible and charming artists, always ready to explore and experience something new",
      'ESTP': "The Entrepreneur - Smart, energetic and very perceptive people, who truly enjoy living on the edge",
      'ESFP': "The Entertainer - Spontaneous, energetic and enthusiastic people – life is never boring around them",
    };

    // Get emoji and color for personality type
    Map<String, Map<String, dynamic>> typeStyles = {
      'INTJ': {'emoji': '🧠', 'color': Color(0xFF5E8B8B)},
      'INTP': {'emoji': '🔬', 'color': Color(0xFF7A55A0)},
      'ENTJ': {'emoji': '👑', 'color': Color(0xFFA07055)},
      'ENTP': {'emoji': '💡', 'color': Color(0xFF5573A0)},
      'INFJ': {'emoji': '🦋', 'color': Color(0xFF8B5E8B)},
      'INFP': {'emoji': '🌟', 'color': Color(0xFFA07685)},
      'ENFJ': {'emoji': '🌈', 'color': Color(0xFF55A076)},
      'ENFP': {'emoji': '✨', 'color': Color(0xFFA0A055)},
      'ISTJ': {'emoji': '📊', 'color': Color(0xFF5E768B)},
      'ISFJ': {'emoji': '🛡️', 'color': Color(0xFF7A8B5E)},
      'ESTJ': {'emoji': '📋', 'color': Color(0xFFA05564)},
      'ESFJ': {'emoji': '🤝', 'color': Color(0xFF5E8B5E)},
      'ISTP': {'emoji': '🔧', 'color': Color(0xFF8B5E8B)},
      'ISFP': {'emoji': '🎨', 'color': Color(0xFF5E8B8B)},
      'ESTP': {'emoji': '🏄', 'color': Color(0xFFA07055)},
      'ESFP': {'emoji': '🎭', 'color': Color(0xFF5573A0)},
    };

    // Show results dialog with animations
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Results",
      pageBuilder: (context, animation1, animation2) {
        return Container(); // Not used
      },
      transitionBuilder: (context, animation1, animation2, child) {
        var curve = Curves.easeInOut;
        var tween = Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: curve)
        );
        var offsetAnimation = Tween(
            begin: Offset(0, 1),
            end: Offset.zero
        ).animate(animation1);

        return ScaleTransition(
          scale: animation1.drive(tween),
          child: FadeTransition(
            opacity: animation1,
            child: SlideTransition(
              position: offsetAnimation,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                contentPadding: EdgeInsets.zero,
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: typeStyles[personalityType]?['color'] ?? Color(0xFF5E8B8B),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              typeStyles[personalityType]?['emoji'] ?? '✨',
                              style: TextStyle(fontSize: 48),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'You are:',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              personalityType,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              descriptions[personalityType] ?? "A unique personality type!",
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Your preferences:',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildPreferenceBar('E', 'I', E, I),
                            SizedBox(height: 12),
                            _buildPreferenceBar('S', 'N', S, N),
                            SizedBox(height: 12),
                            _buildPreferenceBar('T', 'F', T, F),
                            SizedBox(height: 12),
                            _buildPreferenceBar('J', 'P', J, P),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'TAKE AGAIN',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        color: typeStyles[personalityType]?['color'] ?? Color(0xFF5E8B8B),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _resetTest();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: typeStyles[personalityType]?['color'] ?? Color(0xFF5E8B8B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      'DONE',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 500),
    );
  }

  Widget _buildPreferenceBar(String leftLabel, String rightLabel, int leftScore, int rightScore) {
    num total = rightScore + leftScore > 0 ? leftScore + rightScore : 1;
    double leftPercent = leftScore / total;

    return Column(
      children: [
        Row(
          children: [
            Text(
              leftLabel,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: _getCurrentColorScheme()['primary'],
              ),
            ),
            SizedBox(width: 4),
            Text('$leftScore', style: GoogleFonts.outfit(fontSize: 12)),
            Spacer(),
            Text('$rightScore', style: GoogleFonts.outfit(fontSize: 12)),
            SizedBox(width: 4),
            Text(
              rightLabel,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: _getCurrentColorScheme()['primary'],
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              Flexible(
                flex: (leftPercent * 100).toInt(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _getCurrentColorScheme()['primary'],
                  ),
                ),
              ),
              Flexible(
                flex: ((1 - leftPercent) * 100).toInt(),
                child: Container(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _resetTest() {
    setState(() {
      _currentQuestionIndex = 0;
      E = 0;
      I = 0;
      S = 0;
      N = 0;
      T = 0;
      F = 0;
      J = 0;
      P = 0;
      _answers = List.filled(12, null);
      _resetCards();
    });
  }

  void _resetCards() {
    _leftCardController.reset();
    _rightCardController.reset();
    _dragPosition = 0.0;
    _isDragging = false;
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition += details.delta.dx;

      // Update left card animations when dragging left
      if (_dragPosition < 0) {
        // Scale the rotation and slide based on drag distance
        double rotationValue = _dragPosition / 500;

        _leftCardRotation = Tween<double>(
          begin: 0.0,
          end: rotationValue,
        ).animate(CurvedAnimation(
          parent: _leftCardController,
          curve: Curves.easeOut,
        ));

        _leftCardSlide = Tween<double>(
          begin: 0.0,
          end: _dragPosition,
        ).animate(CurvedAnimation(
          parent: _leftCardController,
          curve: Curves.easeOut,
        ));
      }

      // Update right card animations when dragging right
      if (_dragPosition > 0) {
        // Scale the rotation and slide based on drag distance
        double rotationValue = _dragPosition / 500;

        _rightCardRotation = Tween<double>(
          begin: 0.0,
          end: rotationValue,
        ).animate(CurvedAnimation(
          parent: _rightCardController,
          curve: Curves.easeOut,
        ));

        _rightCardSlide = Tween<double>(
          begin: 0.0,
          end: _dragPosition,
        ).animate(CurvedAnimation(
          parent: _rightCardController,
          curve: Curves.easeOut,
        ));
      }
    });
  }


  void _onPanEnd(DragEndDetails details) {
    final threshold = 80.0; // Threshold to determine a swipe

    if (_dragPosition.abs() > threshold) {
      // Determine which card was selected
      bool isLeftCardSelected = _dragPosition > 0;

      // Update score based on selection
      _updateScore(isLeftCardSelected);

      if (isLeftCardSelected) {
        // Complete right card animation (swipe right animation)
        _rightCardRotation = Tween<double>(
          begin: _rightCardRotation.value,
          end: 0.3, // Final rotation angle
        ).animate(CurvedAnimation(
          parent: _rightCardController,
          curve: Curves.easeOut,
        ));

        _rightCardSlide = Tween<double>(
          begin: _rightCardSlide.value,
          end: 400.0, // Move off-screen
        ).animate(CurvedAnimation(
          parent: _rightCardController,
          curve: Curves.easeOut,
        ));

        _rightCardController.forward(from: 0.0);
      } else {
        // Complete left card animation (swipe left animation)
        _leftCardRotation = Tween<double>(
          begin: _leftCardRotation.value,
          end: -0.3, // Final rotation angle
        ).animate(CurvedAnimation(
          parent: _leftCardController,
          curve: Curves.easeOut,
        ));

        _leftCardSlide = Tween<double>(
          begin: _leftCardSlide.value,
          end: -400.0, // Move off-screen
        ).animate(CurvedAnimation(
          parent: _leftCardController,
          curve: Curves.easeOut,
        ));

        _leftCardController.forward(from: 0.0);
      }
    } else {
      // Spring back to center if not swiped far enough
      if (_dragPosition < 0) {
        _leftCardRotation = Tween<double>(
          begin: _leftCardRotation.value,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: _leftCardController,
          curve: Curves.elasticOut,
        ));

        _leftCardSlide = Tween<double>(
          begin: _leftCardSlide.value,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: _leftCardController,
          curve: Curves.elasticOut,
        ));

        _leftCardController.forward(from: 0.0);
      } else {
        _rightCardRotation = Tween<double>(
          begin: _rightCardRotation.value,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: _rightCardController,
          curve: Curves.elasticOut,
        ));

        _rightCardSlide = Tween<double>(
          begin: _rightCardSlide.value,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: _rightCardController,
          curve: Curves.elasticOut,
        ));

        _rightCardController.forward(from: 0.0);
      }

    }

    setState(() {
      _isDragging = false;
    });
  }

  // Get current question color scheme
  Map<String, Color> _getCurrentColorScheme() {
    // Use colors based on the current question index
    return _questionColors[_currentQuestionIndex];
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final colorScheme = _getCurrentColorScheme();

    // Animation for background color change if active
    final backgroundColor = _backgroundController.isAnimating && _backgroundAnimation != null
        ? _backgroundAnimation!.value ?? Color(0xFFFDFDFD)
        : Color(0xFFFDFDFD);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      // Main content
                      Column(
                        children: [
                          // Header section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            child: Row(
                              children: [
                                // Back button
                                GestureDetector(
                                  onTap: _handleBackArrow,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: colorScheme['primary']!, width: 1.5),
                                    ),
                                    child: Icon(Icons.keyboard_arrow_left,
                                      size: 24,
                                      color: colorScheme['primary'],
                                    ),
                                  ),
                                ),
                                // Center title
                                Expanded(
                                  child: Text(
                                    "Personality Quiz",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      color: colorScheme['primary'],
                                    ),
                                  ),
                                ),
                                // Help button
                                GestureDetector(
                                  onTap: () {
                                    _showHelpDialog(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: colorScheme['primary']!, width: 1.5),
                                    ),
                                    child: Icon(Icons.help_outline,
                                      size: 22,
                                      color: colorScheme['primary'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Question counter with emoji
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "QUESTION ${_currentQuestionIndex + 1} OF ${_questions.length}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme['primary'],
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Text(
                                    currentQuestion['emoji'],
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16),

                          // Progress indicator with animated fill
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: LinearProgressIndicator(
                                value: (_currentQuestionIndex + 1) / _questions.length,
                                minHeight: 8,
                                backgroundColor: Colors.grey[200],
                                color: colorScheme['primary'],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme['highlighted']!,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 30),

                          // Background decoration elements
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Decorative circles
                              Positioned(
                                top: -40,
                                left: -30,
                                child: Opacity(
                                  opacity: 0.05,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorScheme['primary'],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -20,
                                right: -10,
                                child: Opacity(
                                  opacity: 0.08,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorScheme['highlighted'],
                                    ),
                                  ),
                                ),
                              ),

                              // Actual question text
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  children: [
                                    Text(
                                      currentQuestion['question'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Swipe instruction with animation
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: _isDragging ? 0.0 : 1.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.swipe,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Swipe left or right to choose",
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 40),

                          // Card swiper section
                          GestureDetector(
                            onPanStart: _onPanStart,
                            onPanUpdate: _onPanUpdate,
                            onPanEnd: _onPanEnd,
                            child: Container(
                              height: 280,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Left option indicator
                                  Positioned(
                                    left: 20,
                                    child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: _dragPosition < -50 ? 1.0 : 0.0,
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: colorScheme['primary']!.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: colorScheme['arrow'],
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Right option indicator
                                  Positioned(
                                    right: 20,
                                    child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: _dragPosition > 50 ? 1.0 : 0.0,
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: colorScheme['primary']!.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: colorScheme['arrow'],
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Left option card
                                  Positioned(
                                    left: 30,
                                    child: Transform.translate(
                                      offset: Offset(_leftCardSlide.value, 0),
                                      child: Transform.rotate(
                                        angle: _leftCardRotation.value,
                                        alignment: Alignment.bottomCenter,
                                        child: OptionCard(
                                          text: currentQuestion['leftOption'],
                                          isHighlighted: _dragPosition < -50,
                                          primaryColor: colorScheme['primary']!,
                                          highlightedColor: colorScheme['highlighted']!,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Right option card
                                  Positioned(
                                    right: 30,
                                    child: Transform.translate(
                                      offset: Offset(_rightCardSlide.value, 0),
                                      child: Transform.rotate(
                                        angle: _rightCardRotation.value,
                                        alignment: Alignment.bottomCenter,
                                        child: OptionCard(
                                          text: currentQuestion['rightOption'],
                                          isHighlighted: _dragPosition > 50,
                                          primaryColor: colorScheme['primary']!,
                                          highlightedColor: colorScheme['highlighted']!,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Manual choice buttons for accessibility
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: colorScheme['primary'],
                                      elevation: 0,
                                      side: BorderSide(color: colorScheme['primary']!, width: 1.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    onPressed: () {
                                      _updateScore(false); // Left option
                                      _leftCardRotation = Tween<double>(
                                        begin: 0.0,
                                        end: -0.3,
                                      ).animate(CurvedAnimation(
                                        parent: _leftCardController,
                                        curve: Curves.easeOut,
                                      ));
                                      _leftCardSlide = Tween<double>(
                                        begin: 0.0,
                                        end: -400.0,
                                      ).animate(CurvedAnimation(
                                        parent: _leftCardController,
                                        curve: Curves.easeOut,
                                      ));
                                      _leftCardController.forward(from: 0.0);
                                    },
                                    child: Text("Left", style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme['primary'],
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    onPressed: () {
                                      _updateScore(true); // Right option
                                      _rightCardRotation = Tween<double>(
                                        begin: 0.0,
                                        end: 0.3,
                                      ).animate(CurvedAnimation(
                                        parent: _rightCardController,
                                        curve: Curves.easeOut,
                                      ));
                                      _rightCardSlide = Tween<double>(
                                        begin: 0.0,
                                        end: 400.0,
                                      ).animate(CurvedAnimation(
                                        parent: _rightCardController,
                                        curve: Curves.easeOut,
                                      ));
                                      _rightCardController.forward(from: 0.0);
                                    },
                                    child: Text("Right", style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Testing shortcut - only visible on last few questions
                          if (_currentQuestionIndex < _questions.length - 1 && _currentQuestionIndex >= _questions.length - 3)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _currentQuestionIndex = _questions.length - 1;
                                    _resetCards();
                                  });
                                },
                                child: Text(
                                  "Jump to last question",
                                  style: GoogleFonts.outfit(
                                    color: colorScheme['primary'],
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),

                          Spacer(),
                        ],
                      ),

                      // Confetti effect overlay
                      if (_showConfetti)
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                          painter: ConfettiPainter(_confettiParticles),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: _getCurrentColorScheme()['primary']),
            SizedBox(width: 10),
            Text('How to Play', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _helpItem('Swipe left or right to choose between options', Icons.swipe),
            SizedBox(height: 12),
            _helpItem('Tap the buttons below if you prefer not to swipe', Icons.touch_app),
            SizedBox(height: 12),
            _helpItem('Your answers help determine your personality type', Icons.psychology),
            SizedBox(height: 12),
            _helpItem('Use the back arrow to return to previous questions', Icons.arrow_back),
          ],
        ),
        actions: [
          TextButton(
            child: Text('OK', style: TextStyle(color: _getCurrentColorScheme()['primary'])),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _helpItem(String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: _getCurrentColorScheme()['primary']),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class OptionCard extends StatelessWidget {
  final String text;
  final bool isHighlighted;
  final Color primaryColor;
  final Color highlightedColor;

  const OptionCard({
    required this.text,
    this.isHighlighted = false,
    required this.primaryColor,
    required this.highlightedColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: 150,
      height: 250,
      decoration: BoxDecoration(
        color: isHighlighted ? highlightedColor : primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isHighlighted ? 0.3 : 0.2),
            blurRadius: isHighlighted ? 16 : 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated background patterns
          Positioned.fill(
            child: CustomPaint(
              painter: BubblePainter(isHighlighted: isHighlighted),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Text content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isHighlighted ? 40 : 20,
                  width: isHighlighted ? 40 : 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  text,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isHighlighted ? 1.0 : 0.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Select',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final bool isHighlighted;

  BubblePainter({this.isHighlighted = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(isHighlighted ? 0.2 : 0.1)
      ..style = PaintingStyle.fill;

    // Create a more dynamic bubble pattern
    final bubbleSizes = [8.0, 12.0, 15.0, 10.0, 18.0, 6.0, 14.0, 9.0];
    final positions = [
      Offset(size.width * 0.2, size.height * 0.15),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.85, size.height * 0.12),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.65, size.height * 0.5),
      Offset(size.width * 0.25, size.height * 0.4),
      Offset(size.width * 0.85, size.height * 0.75),
      Offset(size.width * 0.15, size.height * 0.65),
      Offset(size.width * 0.4, size.height * 0.85),
      Offset(size.width * 0.65, size.height * 0.9),
    ];

    for (int i = 0; i < positions.length; i++) {
      canvas.drawCircle(
          positions[i],
          bubbleSizes[i % bubbleSizes.length] * (isHighlighted ? 1.2 : 1.0),
          paint
      );
    }

    // Add decorative lines for more visual interest
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(isHighlighted ? 0.15 : 0.08)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width * 0.1, size.height * 0.8), radius: 30),
        0,
        3,
        false,
        linePaint
    );

    canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width * 0.9, size.height * 0.2), radius: 20),
        2,
        4,
        false,
        linePaint
    );
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) =>
      oldDelegate.isHighlighted != isHighlighted;
}

// Particle class for confetti effect
class Particle {
  Offset position;
  final Color color;
  final Offset velocity;
  double size = math.Random().nextDouble() * 8 + 2;

  Particle({
    required this.position,
    required this.color,
    required this.velocity,
  });

  void update() {
    position = position + velocity;
    size = math.max(0, size - 0.1); // Particles get smaller over time
  }
}

// Custom painter for confetti animation
class ConfettiPainter extends CustomPainter {
  final List<Particle> particles;

  ConfettiPainter(this.particles) {
    // Update particle positions
    for (var particle in particles) {
      particle.update();
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(math.min(1.0, particle.size / 5))
        ..style = PaintingStyle.fill;

      // Draw different shaped confetti pieces
      final random = math.Random(particles.indexOf(particle));
      final shape = random.nextInt(3);

      switch (shape) {
        case 0: // Circle
          canvas.drawCircle(
            particle.position,
            particle.size,
            paint,
          );
          break;
        case 1: // Square
          canvas.drawRect(
            Rect.fromCenter(
              center: particle.position,
              width: particle.size * 2,
              height: particle.size * 2,
            ),
            paint,
          );
          break;
        case 2: // Triangle
          final path = Path();
          path.moveTo(
            particle.position.dx,
            particle.position.dy - particle.size,
          );
          path.lineTo(
            particle.position.dx - particle.size,
            particle.position.dy + particle.size,
          );
          path.lineTo(
            particle.position.dx + particle.size,
            particle.position.dy + particle.size,
          );
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) => true;
}