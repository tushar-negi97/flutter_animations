import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/lottie/Animation4.json',
      'title': 'Welcome to ShopEase',
      'subtitle': 'Discover amazing products at unbeatable prices!',
    },
    {
      'image': 'assets/lottie/Animation3.json',
      'title': 'Fast Checkout',
      'subtitle': 'Experience a seamless and quick checkout process.',
    },
    {
      'image': 'assets/lottie/Animation2.json',
      'title': 'Speedy Delivery',
      'subtitle': 'Get your orders delivered to your doorstep in no time.',
    },
  ];

  void _goToNextPage() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _goToPreviousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Product Image
                  Center(
                    child: Lottie.asset(_onboardingData[index]['image']!),

                    // child: Image.asset(
                    //   _onboardingData[index]['image']!,
                    //   height: 300,
                    // ),
                  ),
                  const SizedBox(height: 20),

                  // Title Animation (from bottom to center)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedSlide(
                      offset: _currentIndex == index ? const Offset(0, 0) : const Offset(0, 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == index ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 700),
                        child: Text(
                          _onboardingData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle Animation (from bottom to center)
                  AnimatedSlide(
                    offset: _currentIndex == index ? const Offset(0, 0) : const Offset(0, 1),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: _currentIndex == index ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 700),
                      child: Text(
                        _onboardingData[index]['subtitle']!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Navigation Buttons
          if (_currentIndex > 0)
            Positioned(
              bottom: 50,
              left: 20,
              child: IconButton(
                onPressed: _goToPreviousPage,
                icon: const Icon(Icons.arrow_back_ios, size: 28),
                color: Colors.deepPurple,
              ),
            ),
          Positioned(
            bottom: 50,
            right: 20,
            child: IconButton(
              onPressed: _goToNextPage,
              icon: Icon(
                _currentIndex == _onboardingData.length - 1 ? Icons.check : Icons.arrow_forward_ios,
                size: 28,
              ),
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
