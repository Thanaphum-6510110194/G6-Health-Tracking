import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import หน้า Login ที่มีอยู่แล้ว
import 'splash_screen.dart'; // เพิ่ม import สำหรับ SplashScreen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // ข้อมูลสำหรับแต่ละหน้า Onboarding
  final List<Map<String, dynamic>> _onboardingPages = [
    {
      'image_icon': Icons.bar_chart,
      'icon_color': const Color(0xFF0ABAB5),
      'title_top': 'Track',
      'title_bottom': 'Everything',
      'main_title': 'Track Your Health Journey',
      'description': 'Monitor habits, meals, exercise, and mood with beautiful, simple tracking tools.',
    },
    {
      'image_icon': Icons.show_chart,
      'icon_color': const Color(0xFF0ABAB5),
      'title_top': 'Visualize',
      'title_bottom': 'Progress',
      'main_title': 'See Your Progress',
      'description': 'Beautiful charts and insights help you understand your health patterns and celebrate achievements',
    },
    {
      'image_icon': Icons.adjust,
      'icon_color': const Color(0xFF0ABAB5),
      'title_top': 'Achieve',
      'title_bottom': 'Goals',
      'main_title': 'Reach Your Goals',
      'description': 'Set meaningful goals, build healthy streaks, and get gentle reminders to stay on track',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  // ข้ามไปยังหน้า Login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingPages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final pageData = _onboardingPages[index];
                  return _buildOnboardingPage(
                    pageData['image_icon'],
                    pageData['icon_color'],
                    pageData['title_top'],
                    pageData['title_bottom'],
                    pageData['main_title'],
                    pageData['description'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingPages.length,
                      (index) => _buildDotIndicator(index == _currentPage),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildContinueButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget สำหรับสร้างแต่ละหน้า Onboarding
  Widget _buildOnboardingPage(IconData iconData, Color iconColor, String titleTop, String titleBottom, String mainTitle, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F7FA),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha((255 * 0.2).round()),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 80,
                color: iconColor,
              ),
              const SizedBox(height: 10),
              Text(
                titleTop,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                titleBottom,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Text(
          mainTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0ABAB5) : Colors.grey[300],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // Widget สำหรับสร้างปุ่ม Continue
  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: InkWell(
        onTap: () {
          if (_currentPage < _onboardingPages.length - 1) {
            // ไปยังหน้าถัดไป
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0ABAB5),
                Color(0xFF56DFCF),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0ABAB5).withAlpha((255 * 0.4).round()),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _currentPage < _onboardingPages.length - 1 ? 'Continue' : 'Get Started',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
