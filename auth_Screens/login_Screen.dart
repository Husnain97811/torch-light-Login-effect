import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                tileMode: TileMode.mirror,
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue.shade300,
              Colors.orange.shade300,
              Colors.purple.shade400,
              Colors.purple.shade200
            ])),
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              enabled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: BeamPainter(
                                  animationValue: _animation.value,
                                  showBeam: _showPassword,
                                ),
                                size: Size(
                                    MediaQuery.of(context).size.width * 0.8,
                                    40),
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                                if (_showPassword) {
                                  _controller.forward();
                                } else {
                                  _controller.reverse();
                                }
                              });
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // TODO: Add your login logic here
                            print('Username and password validated!');
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BeamPainter extends CustomPainter {
  final double animationValue;
  final bool showBeam;

  BeamPainter({required this.animationValue, required this.showBeam});

  @override
  void paint(Canvas canvas, Size size) {
    if (!showBeam) return;

    final paint = Paint()
      ..color = const Color.fromARGB(129, 255, 235, 57)
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width * animationValue; // Animated width
    path.moveTo(size.width, size.height / 2); // Start from right
    path.lineTo(size.width - width, size.height / 16); //Draw towards left

    // Add a curve - adjust these values to fine-tune the curve.
    path.quadraticBezierTo(
        size.width - width, 0, size.width - (width * 0.99), 0);
    path.quadraticBezierTo(size.width - (width * 0.9), size.height / 2,
        size.width - width, size.height);
    path.lineTo(size.width, size.height / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BeamPainter oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        showBeam != oldDelegate.showBeam;
  }
}

class LoginViewModel extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}
