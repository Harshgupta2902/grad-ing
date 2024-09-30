import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradding/utilities/constants/assets_path.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:gradding/utilities/navigation/navigator.dart';
import 'package:utilities/components/gradding_app_bar.dart';
import 'package:utilities/theme/app_colors.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int activeIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GraddingAppBar(
        backButton: false,
        showActions: false,
        showLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: PageView(
              controller: _pageController,
              children: [
                buildPage(
                  "Welcome to Gradding",
                  "One-stop solution to conquer your study abroad dreams",
                  AssetPath.onboard1,
                ),
                buildPage(
                  "Study Abroad",
                  "Simplify Your Journey with India’s Top consultants",
                  AssetPath.onboard2,
                ),
                buildPage(
                  "Test Preparation",
                  "Get trained for the entrance exam by experienced trainers",
                  AssetPath.onboard3,
                ),
              ],
              onPageChanged: (value) {
                setState(() {
                  activeIndex = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          buildIndicator(),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: () {
              if (activeIndex == 2) {
                MyNavigator.popUntilAndPushNamed(GoPaths.login, extra: {'number': ""});
              } else {
                setState(() {
                  activeIndex++;
                });
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.linearToEaseOut,
                );
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  padding: const EdgeInsets.all(19),
                  child: const Icon(
                    Icons.arrow_forward_sharp,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                buildProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(String title, String subTitle, String image) {
    return Column(
      children: [
        const SizedBox(height: kBottomNavigationBarHeight - 16),
        SvgPicture.asset(
          image,
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.primaryColor,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) {
          final bool isActive = index == activeIndex;
          return AnimatedContainer(
            duration: const Duration(seconds: 1),
            width: isActive ? 34 : 8,
            height: 6,
            curve: Curves.linearToEaseOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: isActive ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.5),
            ),
          );
        },
      ),
    );
  }

  Widget buildProgressIndicator() {
    double progress = (activeIndex + 1) / 3; // Calculate progress
    return TweenAnimationBuilder(
      curve: Curves.linearToEaseOut,
      tween: Tween<double>(begin: 0.0, end: progress),
      duration: const Duration(seconds: 1), // Adjust duration as needed
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(
          scale: 2.5,
          child: CircularProgressIndicator(
            value: value,
            backgroundColor: AppColors.primaryColor.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            strokeWidth: 1,
          ),
        );
      },
    );
  }
}
