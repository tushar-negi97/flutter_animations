// import 'package:bloc_app/homescreen.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(LoginScreenApp());

// class LoginScreenApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primaryColor: Colors.deepPurple,
//           scaffoldBackgroundColor: Colors.white10,
//           buttonTheme: const ButtonThemeData(buttonColor: Colors.white10)),
//       home: LoginScreen(),
//     );
//   }
// }

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
//   // Message animation
//   late AnimationController _messageController;
//   late Animation<Offset> _messageSlideAnimation;
//   late Animation<double> _messageFadeAnimation;

//   // Logo animation
//   late AnimationController _logoController;
//   late Animation<Offset> _logoSlideAnimation;
//   late Animation<double> _logoScaleAnimation;

//   // TextField animation
//   late AnimationController _textFieldController;
//   late Animation<double> _textFieldFadeAnimation;

//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   String? _message; // Stores the message text
//   Color _messageColor = Colors.red; // Color of the message (red for error, green for success)

//   @override
//   void initState() {
//     super.initState();

//     // Message animation controller
//     _messageController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _messageSlideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(
//       CurvedAnimation(parent: _messageController, curve: Curves.easeOut),
//     );

//     _messageFadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _messageController,
//       curve: Curves.easeIn,
//     ));

//     // Logo animation controller
//     _logoController = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );

//     _logoSlideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(
//       CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
//     );

//     _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
//       parent: _logoController,
//       curve: Curves.easeOutBack,
//     ));

//     // TextField animation controller
//     _textFieldController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _textFieldFadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
//       parent: _textFieldController,
//       curve: Curves.easeIn,
//     ));

//     // Start animations on screen load
//     _logoController.forward().whenComplete(() {
//       _textFieldController.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     _logoController.dispose();
//     _textFieldController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   _showMessage(String message, Color color) {
//     setState(() {
//       _message = message;
//       _messageColor = color;
//     });

//     // Show the message
//     _messageController.forward();

//     // Auto-hide the message after 3 seconds
//     Future.delayed(const Duration(seconds: 3), () {
//       _messageController.reverse();
//     });
//   }

//   void _handleLogin() async {
//     // Validate credentials
//     if (_passwordController.text == '12345') {
//       _showMessage('Login successful! Welcome back.', Colors.green);
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ShoppingHomeScreen()));
//     } else {
//       _showMessage('Invalid login credentials. Please try again.', Colors.red);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //  / backgroundColor: Colors.blue.shade100,
//       body: Stack(
//         children: [
//           // Login Form
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 100),

//               // Logo with Slide and Scale Transition
//               SlideTransition(
//                 position: _logoSlideAnimation,
//                 child: ScaleTransition(
//                   scale: _logoScaleAnimation,
//                   child: const CircleAvatar(
//                     backgroundColor: Colors.transparent,
//                     radius: 80,
//                     backgroundImage:
//                         NetworkImage('https://storage.googleapis.com/cms-storage-bucket/780e0e64d323aad2cdd5.png'),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // Login Form Container
//               FadeTransition(
//                 opacity: _textFieldFadeAnimation,
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                       )
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // Username Field
//                       TextField(
//                         controller: _usernameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Username',
//                           prefixIcon: Icon(Icons.person),
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // Password Field
//                       TextField(
//                         controller: _passwordController,
//                         decoration: const InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: Icon(Icons.lock),
//                           border: OutlineInputBorder(),
//                         ),
//                         obscureText: true,
//                       ),
//                       const SizedBox(height: 24),

//                       // Login Button
//                       ElevatedButton(
//                         onPressed: _handleLogin,
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size(double.infinity, 50),
//                           backgroundColor: Colors.deepPurple,
//                         ),
//                         child: const Text(
//                           'Login',
//                           style: TextStyle(fontSize: 18, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // Animated Message
//           Positioned(
//             top: 50,
//             left: 20,
//             right: 20,
//             child: SlideTransition(
//               position: _messageSlideAnimation,
//               child: FadeTransition(
//                 opacity: _messageFadeAnimation,
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: _messageColor,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         _messageColor == Colors.green ? Icons.check_circle : Icons.error,
//                         color: Colors.white,
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           _message ?? '',
//                           style: const TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:bloc_app/ecom/cart_screen.dart';
import 'package:bloc_app/ecom/login_screen.dart';
import 'package:bloc_app/ecom/onboarding_screen.dart';
import 'package:bloc_app/ecom/splash_screen.dart';
import 'package:bloc_app/ecom/test.dart';
import 'package:bloc_app/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

void main() {
  unawaited(RiveFile.initialize());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce Animation POC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
              iconTheme: IconThemeData(color: Colors.white))),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/homeScreen': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen()
      },
    );
  }
}
