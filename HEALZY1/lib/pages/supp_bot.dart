import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert'; // Add this import for jsonEncode and jsonDecode



// API Service class to handle communication with the Python backend
class HealzyApiService {
  // Change to your server's address
  static const String baseUrl = 'http://172.16.58.119:5000';

  // Generate a unique ID for each user session
  static final String userId = const Uuid().v4();

  // Get welcome message
  static Future<String> getWelcomeMessage() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/welcome'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        return 'Could not connect to the server. Please try again later.';
      }
    } catch (e) {
      return 'Network error. Please check your connection.';
    }
  }

  // Send message to chatbot and get response
  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        return 'Could not connect to the server. Please try again later.';
      }
    } catch (e) {
      return 'Network error. Please check your connection.';
    }
  }
}

class ChatbotInterface extends StatefulWidget {
  const ChatbotInterface({Key? key}) : super(key: key);

  @override
  State<ChatbotInterface> createState() => _ChatbotInterfaceState();
}

class _ChatbotInterfaceState extends State<ChatbotInterface>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late AnimationController _colorAnimationController;
  bool _isTyping = false;
  double _heartSize = 1.0;
  bool _showEmojiPanel = false;
  Color _primaryColor = Colors.pink;
  List<Color> _availableColors = [
    Colors.pink,
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.blue,
  ];
  List<String> _emojis = ['❤️', '😊', '🌟', '🙏', '✨', '🎵', '🌈', '🌺', '🦋', '🌻'];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _colorAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Get welcome message from API instead of hardcoding
    _fetchWelcomeMessage();
  }

  void _fetchWelcomeMessage() async {
    setState(() {
      _isTyping = true;
    });

    final welcomeMessage = await HealzyApiService.getWelcomeMessage();

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: welcomeMessage,
          isUserMessage: false,
        ));
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    _colorAnimationController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) async {
    _messageController.clear();
    if (text.trim().isEmpty) return;

    _pulseHeart();

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUserMessage: true,
        color: _primaryColor.withOpacity(0.7),
      ));
      _isTyping = true;
      _showEmojiPanel = false;
    });

    _scrollToBottom();

    // Get response from API instead of the hardcoded responses
    final response = await HealzyApiService.sendMessage(text);

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: response,
          isUserMessage: false,
        ));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _pulseHeart() {
    setState(() {
      _heartSize = 1.3;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _heartSize = 0.8;
        });

        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              _heartSize = 1.0;
            });
          }
        });
      }
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _triggerHeartbeatAnimation() {
    setState(() {
      _heartSize = 1.4;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _heartSize = 0.7;
        });

        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              _heartSize = 1.2;
            });

            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted) {
                setState(() {
                  _heartSize = 0.9;
                });

                Future.delayed(const Duration(milliseconds: 200), () {
                  if (mounted) {
                    setState(() {
                      _heartSize = 1.0;
                    });
                  }
                });
              }
            });
          }
        });
      }
    });
  }

  void _insertEmoji(String emoji) {
    final currentText = _messageController.text;
    final selection = _messageController.selection;
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      emoji,
    );
    _messageController.text = newText;
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: selection.baseOffset + emoji.length),
    );
  }

  void _cycleThemeColor() {
    setState(() {
      int currentIndex = _availableColors.indexOf(_primaryColor);
      int nextIndex = (currentIndex + 1) % _availableColors.length;
      _primaryColor = _availableColors[nextIndex];
      _pulseHeart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isDarkMode ? Colors.grey.shade900 : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black87;
    final appBarColor = _isDarkMode ? Colors.grey.shade800 : Colors.white;
    final inputBackgroundColor = _isDarkMode
        ? Colors.grey.shade700
        : _primaryColor.withOpacity(0.1);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isDarkMode
                ? [Colors.black, Colors.grey.shade900]
                : [Colors.white, _primaryColor.withOpacity(0.05)],
          ),
        ),
        child: Stack(
          children: [
            // Animated gradient background for the heart
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _colorAnimationController,
                builder: (context, child) {
                  final colorValue = _colorAnimationController.value;
                  final color1 = Color.lerp(
                    _primaryColor.withOpacity(0.05),
                    _primaryColor.withOpacity(0.15),
                    math.sin(colorValue * math.pi * 2).abs(),
                  )!;
                  final color2 = Color.lerp(
                    _primaryColor.withOpacity(0.02),
                    _primaryColor.withOpacity(0.1),
                    math.cos(colorValue * math.pi * 2).abs(),
                  )!;

                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.8,
                        colors: [color1, color2],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Centered heart (now larger)
            GestureDetector(
              onTap: _pulseHeart,
              onDoubleTap: _triggerHeartbeatAnimation,
              child: Positioned.fill(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartSize,
                        child: _buildLayeredHeartBackground(),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Chat interface overlay
            Column(
              children: [
                // Simplified app bar
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                  decoration: BoxDecoration(
                    color: appBarColor,
                    border: Border(
                      bottom: BorderSide(
                        color: _isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Healzy Chat",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                              color: _primaryColor,
                              size: 24,
                            ),
                            onPressed: _toggleDarkMode,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.palette,
                              color: _primaryColor,
                              size: 24,
                            ),
                            onPressed: _cycleThemeColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Chat messages area
                Expanded(
                  child: Container(
                    color: backgroundColor.withOpacity(0.6),
                    child: Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 70),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _messages[index];
                          },
                        ),

                        if (_isTyping)
                          Positioned(
                            bottom: 16,
                            left: 24,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  _buildTypingDot(0),
                                  _buildTypingDot(1),
                                  _buildTypingDot(2),
                                ],
                              ),
                            ),
                          ),

                        if (_showEmojiPanel)
                          Positioned(
                            bottom: 70,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 70,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                border: Border(
                                  top: BorderSide(
                                    color: _isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _emojis.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => _insertEmoji(_emojis[index]),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          _emojis[index],
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Simplified input area with matching heart color
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: appBarColor,
                    border: Border(
                      top: BorderSide(
                        color: _isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Emoji button
                      IconButton(
                        icon: Icon(
                          _showEmojiPanel ? Icons.keyboard : Icons.emoji_emotions,
                          color: _primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _showEmojiPanel = !_showEmojiPanel;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      // Input field with heart color
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: inputBackgroundColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              hintText: "Type your message...",
                              hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onSubmitted: _handleSubmitted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Send button
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: _primaryColor,
                        ),
                        onPressed: () => _handleSubmitted(_messageController.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayeredHeartBackground() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final pulseValue = _animationController.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outermost heart (larger size)
            _buildHeartLayer(
                350 + (40 * pulseValue), // Increased from 280
                _primaryColor.withOpacity(0.15 + (0.05 * pulseValue)),
                8.0 + (4 * pulseValue)
            ),

            // Second heart layer (larger size)
            _buildHeartLayer(
                300 + (35 * pulseValue), // Increased from 230
                _primaryColor.withOpacity(0.2 + (0.05 * pulseValue)),
                6.0 + (3 * pulseValue)
            ),

            // Third heart layer (larger size)
            _buildHeartLayer(
                250 + (30 * pulseValue), // Increased from 190
                _primaryColor.withOpacity(0.25 + (0.05 * pulseValue)),
                5.0 + (2 * pulseValue)
            ),

            // Fourth heart layer (larger size)
            _buildHeartLayer(
                200 + (25 * pulseValue), // Increased from 150
                _primaryColor.withOpacity(0.3 + (0.1 * pulseValue)),
                4.0 + (2 * pulseValue)
            ),

            // Fifth heart layer (larger size)
            _buildHeartLayer(
                150 + (20 * pulseValue), // Increased from 120
                _primaryColor.withOpacity(0.4 + (0.1 * pulseValue)),
                3.0 + (1 * pulseValue)
            ),

            // Central heart (larger size)
            Container(
              width: 150 + (10 * pulseValue), // Increased from 100
              height: 150 + (10 * pulseValue), // Increased from 100
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: CustomPaint(
                size: Size(150 + (10 * pulseValue), 150 + (10 * pulseValue)),
                painter: HeartPainter(
                  color: _primaryColor,
                  strokeWidth: 0,
                  isFilled: true,
                  shadowBlur: 15 + (5 * pulseValue),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeartLayer(double size, Color color, double shadowBlur) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: HeartPainter(
          color: color,
          strokeWidth: 0,
          isFilled: true,
          shadowBlur: shadowBlur,
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final sinValue = math.sin((_animationController.value * math.pi * 2) + (index * 0.5));
        final size = 8.0 + (sinValue + 1) * 2;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: _primaryColor,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class HeartPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isFilled;
  final double shadowBlur;

  HeartPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.isFilled = false,
    this.shadowBlur = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (shadowBlur > 0) {
      paint.maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);
    }

    final double width = size.width;
    final double height = size.height;

    final Path path = Path();
    path.moveTo(width * 0.5, height * 0.35);
    path.cubicTo(
      width * 0.8, height * 0.1,
      width * 1.1, height * 0.4,
      width * 0.5, height * 0.85,
    );
    path.cubicTo(
      width * -0.1, height * 0.4,
      width * 0.2, height * 0.1,
      width * 0.5, height * 0.35,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final Color? color;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isUserMessage,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
        isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUserMessage)
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.pink.withOpacity(0.2),
                child: CustomPaint(
                  size: Size(24, 24),
                  painter: HeartPainter(
                    color: Colors.pink,
                    strokeWidth: 0,
                    isFilled: true,
                  ),
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUserMessage
                    ? color ?? Colors.blue
                    : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: isUserMessage ? const Radius.circular(20) : const Radius.circular(0),
                  bottomRight: !isUserMessage ? const Radius.circular(20) : const Radius.circular(0),
                ),
                border: !isUserMessage
                    ? Border.all(color: Colors.grey.withOpacity(0.2), width: 1)
                    : null,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUserMessage ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (isUserMessage)
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: (color ?? Colors.blue).withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: color ?? Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}