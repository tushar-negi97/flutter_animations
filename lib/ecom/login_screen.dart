// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:bloc_app/ecom/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  // Logo animation
  late AnimationController _logoController;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _logoScaleAnimation;

  // TextField animation
  late AnimationController _textFieldController;
  late Animation<double> _textFieldFadeAnimation;

  // Button Shake animation
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // Bouncing dots animation for loading
  late AnimationController _loadingController;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Track loading state
  bool _isShaking = false; // Track shake state

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoSlideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // TextField animation controller
    _textFieldController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textFieldFadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _textFieldController,
      curve: Curves.easeIn,
    ));

    // Shake animation controller
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimation =
        Tween<double>(begin: 0, end: 8).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    // Bouncing dots animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(); // Loop the animation

    // Start animations on screen load
    _logoController.forward().whenComplete(() {
      _textFieldController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textFieldController.dispose();
    _shakeController.dispose();
    _loadingController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _triggerShake() {
    setState(() {
      _isShaking = true;
    });

    _shakeController.forward().then((_) {
      _shakeController.reverse().then((_) {
        if (_isShaking) _triggerShake(); // Continue shaking for 3 seconds
      });
    });

    // Stop shaking after 3 seconds
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _isShaking = false;
      });
    });
  }

  void _handleLogin() async {
    // setState(() {
    //   _isLoading = true;
    // });
    CommonMethods.getLoadingIndicator(context);

    // Simulate an API call delay for login
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pop(context);

    if (_passwordController.text == '12345') {
      _showSnackBar('Login successful! Welcome back.', Colors.green);
      setState(() {
        _isLoading = false;
      });

      Navigator.popAndPushNamed(context, '/homeScreen');
    } else {
      _showSnackBar('Invalid login credentials. Please try again.', Colors.red);
      setState(() {
        _isLoading = false;
      });
      _triggerShake(); // Trigger shake animation on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),

              // Logo with Slide and Scale Transition
              SlideTransition(
                position: _logoSlideAnimation,
                child: ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 80,
                    backgroundImage:
                        NetworkImage('https://storage.googleapis.com/cms-storage-bucket/780e0e64d323aad2cdd5.png'),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Login Form Container
              FadeTransition(
                opacity: _textFieldFadeAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Username Field
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),

                      // Login Button with Shake Transition on Error
                      AnimatedBuilder(
                        animation: Listenable.merge([_shakeAnimation]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_isShaking ? _shakeAnimation.value : 0, 0),
                            child: child,
                          );
                        },
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin, // Disable button while loading
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.deepPurple,
                            disabledBackgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isLoading
                              ? _buildBouncingDots() // Show bouncing dots animation when loading
                              : const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build the Bouncing Dots Animation for loading state
  Widget _buildBouncingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _loadingController,
          builder: (context, child) {
            final bounce = (index * 0.2 + _loadingController.value) % 1;
            final scale = 1.0 + (0.5 * (1 - (bounce - 0.5).abs() * 2));
            return Transform.scale(
              scale: scale,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: const CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.white,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
