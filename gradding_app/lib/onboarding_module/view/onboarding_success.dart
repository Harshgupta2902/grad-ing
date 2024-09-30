import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:utilities/common/controller/default_controller.dart';
import 'package:gradding/utilities/constants/assets_path.dart';

final _defaultController = Get.put(DefaultController());

class OnBoardingSuccess extends StatefulWidget {
  const OnBoardingSuccess({super.key});

  @override
  State<OnBoardingSuccess> createState() => _OnBoardingSuccessState();
}

class _OnBoardingSuccessState extends State<OnBoardingSuccess> {
  @override
  void initState() {
    super.initState();
    _defaultController.getDefaultData();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetPath.onboardSuccess,
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 20),
              Text(
                "Congratulations!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600, fontSize: 26),
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome to Gradding",
                style:
                    Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                "You've successfully onboarded",
                style:
                    Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
            ),
            onPressed: () async {
              String path = _defaultController.state?.result?.path ?? "/home";
              Future.delayed(
                Duration.zero,
                () => context.go(path),
              );
            },
            child: const Text("Let’s Get Started"),
          ),
        ),
      ),
    );
  }
}
