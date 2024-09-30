import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradding/dashboard_module/view/home_view.dart';
import 'package:gradding/dashboard_module/view/landing_view.dart';
import 'package:gradding/dashboard_module/view/onboarding_view.dart';
import 'package:gradding/onboarding_module/view/create_pin_view.dart';
import 'package:gradding/onboarding_module/view/login.dart';
import 'package:gradding/onboarding_module/view/onboarding_questions.dart';
import 'package:gradding/onboarding_module/view/onboarding_success.dart';
import 'package:gradding/onboarding_module/view/otp_view.dart';
import 'package:gradding/onboarding_module/view/show_services.dart';
import 'package:gradding/onboarding_module/view/splash_screen.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:guest_dashboard/navigation/guest_routes_list.dart';
import 'package:ielts_dashboard/navigation/ielts_routes_list.dart';
import 'package:study_abroad/navigation/study_abroad_routes_list.dart';
import 'package:utilities/components/policy_viewer.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState> ieltsShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'ielts-shell');
final GlobalKey<NavigatorState> guestShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'guest-shell');
final GoRouter goRouterConfig = GoRouter(
  initialLocation: GoPaths.splash,
  navigatorKey: rootNavigatorKey,
  routes: [
    ...ieltsRoutes(rootNavigatorKey: rootNavigatorKey, shellNavigatorKey: ieltsShellNavigatorKey),
    ...guestRoutes(rootNavigatorKey: rootNavigatorKey, shellNavigatorKey: ieltsShellNavigatorKey),
    ...studyAbroadRoutes(shellNavigatorKey: shellNavigatorKey, rootNavigatorKey: rootNavigatorKey),
    //
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return LandingView(
          child: child,
        );
      },
      routes: [
        GoRoute(
          parentNavigatorKey: shellNavigatorKey,
          path: GoPaths.home,
          name: GoPaths.home,
          builder: (context, state) {
            return const HomeScreenView();
          },
        ),
      ],
    ),

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.viewPolicy,
      name: GoPaths.viewPolicy,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final title = extras['title'];
        final policy = extras['policy'];
        return PolicyViewer(
          title: title,
          policy: policy,
        );
      },
    ),

    // ------------------      Welcome Page Routes      ---------------------------
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.splash,
      name: GoPaths.splash,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.onBoarding,
      name: GoPaths.onBoarding,
      builder: (context, state) {
        return const OnBoardingView();
      },
    ),

    // ------------------   Registration Page Routes   ---------------------------
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.login,
      name: GoPaths.login,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final number = extras['number'];
        return LoginView(number: number);
      },
    ),

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.otp,
      name: GoPaths.otp,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final phone = extras['phone'];
        final path = extras['path'];
        return OtpView(
          number: phone,
          path: path,
        );
      },
    ),

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.createPin,
      name: GoPaths.createPin,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final countryCode = extras['countryCode'];
        final number = extras['number'];
        return CreatePinView(
          countryCode: countryCode,
          number: number,
        );
      },
    ),

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.enterPin,
      name: GoPaths.enterPin,
      builder: (context, state) {
        return const EnterPinView();
      },
    ),
    // -------------------------------------- Onboarding Question Routes --------------------------------------

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.showServices,
      name: GoPaths.showServices,
      builder: (context, state) {
        return const ShowServices();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.onboardingQuestions,
      name: GoPaths.onboardingQuestions,
      builder: (context, state) {
        return const OnboardingQuestions();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.onboardingSuccess,
      name: GoPaths.onboardingSuccess,
      builder: (context, state) {
        return const OnBoardingSuccess();
      },
    ),
  ],
);
