import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ielts_dashboard/navigation/ielts_go_paths.dart';
import 'package:utilities/common/controller/default_controller.dart';
import 'package:gradding/utilities/constants/assets_path.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:gradding/utilities/navigation/navigator.dart';
import 'package:utilities/common/controller/profile_controller.dart';

final _defaultController = Get.put(DefaultController());
final _profileController = Get.put(ProfileController());
final prefs = GetStorage();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _profileController.getProfileData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      bool isLoggedIn = prefs.read("IS_LOGGED_IN") ?? false;
      String? token = prefs.read("TOKEN");
      String path;

      if (isLoggedIn == false || token == null) {
        path = GoPaths.onBoarding;
        MyNavigator.go(path);
        return;
      }

      MyNavigator.go(
        _defaultController.state?.result?.path == null
            ? GoPaths.onBoarding
            : IeltsGoPaths.ieltsDashboard,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _animation,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AssetPath.collegePredictorLogo,
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
