import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:gradding/utilities/navigation/route_generator.dart';
import 'package:ielts_dashboard/navigation/ielts_go_paths.dart';

class MyNavigator {
  static String? currentRoute;

  static void pushNamed(String? routeName, {Object? extra}) {
    try {
      goRouterConfig.pushNamed(routeName ?? IeltsGoPaths.ieltsDashboard, extra: extra);
    } catch (e) {
      debugPrint("+++++++++++++++++++++++++++++navigation  $e");
    }
    FirebaseAnalytics.instance.logEvent(name: 'increment_button_press');
  }

  static void go(String? routeName, {Object? extra}) {
    try {
      goRouterConfig.goNamed(routeName ?? IeltsGoPaths.ieltsDashboard, extra: extra);
    } catch (e) {
      debugPrint("+++++++++++++++++++++++++++++navigation  $e");
    }
    FirebaseAnalytics.instance.logEvent(name: 'increment_button_press');
  }

  static void pop() {
    goRouterConfig.pop();
  }

  static void popUntilAndPushNamed(String routeName, {Object? extra}) {
    try {
      while (goRouterConfig.canPop()) {
        goRouterConfig.pop();
      }
      goRouterConfig.pushReplacementNamed(routeName, extra: extra);
    } catch (e) {
      debugPrint("Navigation Error: $e");
    }
    FirebaseAnalytics.instance.logEvent(name: 'increment_button_press');
  }

  static void pushReplacementNamed(String? routeName, {Object? extra}) {
    try {
      goRouterConfig.pushReplacementNamed(routeName ?? IeltsGoPaths.ieltsDashboard, extra: extra);
    } catch (e) {
      debugPrint("+++++++++++++++++++++++++++++navigation  $e");
    }
    FirebaseAnalytics.instance.logEvent(name: 'increment_button_press');
  }
}
