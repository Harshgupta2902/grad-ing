import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:utilities/common/controller/default_controller.dart';
import 'package:gradding/utilities/constants/assets_path.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:gradding/utilities/navigation/navigator.dart';
import 'package:utilities/common/controller/profile_controller.dart';
import 'package:utilities/theme/app_colors.dart';

final _defaultController = Get.put(DefaultController());
final _profileController = Get.put(ProfileController());
final prefs = GetStorage();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _profileController.getProfileData();

    Timer(const Duration(seconds: 5), () {
      bool isLoggedIn = prefs.read("IS_LOGGED_IN") == true;
      String? token = prefs.read("TOKEN");
      String path;

      if (!isLoggedIn || token == null) {
        path = GoPaths.onBoarding;
      } else if (_defaultController.state?.result?.forceUpdate == 1) {
        path = "/home";
      } else {
        path = _defaultController.state?.result?.path ?? "/home";
      }

      MyNavigator.go(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Lottie.asset(AssetPath.graddingSplash),
      ),
    );
  }
}
