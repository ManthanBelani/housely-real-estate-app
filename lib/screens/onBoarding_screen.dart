import 'package:flutter/material.dart';
import 'Auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildOnboardingPage(index);
            },
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildPaginationDots(),
                SizedBox(height: 30),
                _buildActionButton(),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen(),));
              },
              child: Text('Skip', style: TextStyle(color: Colors.grey[600])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    final List<String> titles = [
      'Find the perfect place for your future house',
      'Fast sell your property in just one click',
      'find your dream home with us'
    ];

    final List<String> subtitles = [
      'find the best place for your dream house with your family and loved ones',
      'Simplify the property sales process with just your smartphone',
      'Just search and select your favorite property you want to locate'
    ];

    final List<String> images = [
      'assets/images/onBoarding1.png',
      'assets/images/onBoarding2.png',
      'assets/images/onBoarding3.png'
    ];

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 270,
            width: 270,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            child: ClipRRect(
              child: Image.asset(
                images[index],
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          SizedBox(height: 40),
          Text(
            titles[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            subtitles[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Colors.purple
                : Colors.grey[300],
          ),
        );
      }),
    );
  }

  Widget _buildActionButton() {
    String buttonText = _currentPage == 2 ? 'Get Started' : 'Next';

    return ElevatedButton(
      onPressed: () {
        if (_currentPage == 2) {
          // Navigator.pushReplacementNamed(context, '/home');
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
        } else {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(buttonText, style: TextStyle(fontSize: 18)),
    );
  }
}