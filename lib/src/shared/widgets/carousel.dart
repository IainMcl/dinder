import 'dart:async';

import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List<String> imageUrls = [
    // Add your image URLs here
    'assets/images/carousel/img1.jpg',
    'assets/images/carousel/img2.jpg',
    // 'assets/images/carousel/img3.jpg',
    // 'assets/images/carousel/img1.jpg',
    // 'assets/images/carousel/img1.jpg',
    // 'assets/images/carousel/img2.jpg',
    // 'assets/images/carousel/img3.jpg',
    // 'assets/images/carousel/img2.jpg',
    // 'assets/images/carousel/img3.jpg',
  ];

  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  static const int timerDurationSeconds = 3;
  static const int pageScrollTimeMiliseconds = 500;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: timerDurationSeconds), (_) {
      if (_currentPage < imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: pageScrollTimeMiliseconds),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Adjust the height as needed
      child: PageView.builder(
        controller: _pageController,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.4)).clamp(0.0, 1.0);
              }
              return Center(
                child: SizedBox(
                  height: Curves.easeOut.transform(value) * 160,
                  width: Curves.easeOut.transform(value) * 400,
                  child: child,
                ),
              );
            },
            child: ClipRRect(
              /* borderRadius: BorderRadius.circular(16), */
              child: Image.asset(imageUrls[index],
                fit: BoxFit.cover,
              )

            ),
          );
        },
      ),
    );
  }
}

