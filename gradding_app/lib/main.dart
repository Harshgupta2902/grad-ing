import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utilities/common/controller/default_controller.dart';
import 'package:gradding/utilities/navigation/route_generator.dart';
import 'package:utilities/app_change.dart';
import 'package:utilities/components/message_scaffold.dart';
import 'package:utilities/services/fcm_notification_service.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/packages/smooth_rectangular_border.dart';
import 'package:utilities/theme/app_colors.dart';
import 'package:utilities/utilities.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initGlobalKeys(scaffoldMessengerKey);
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA-uGAs_9fLLAYTa2YRia7o3JHJ4-BDrqI",
      appId: "1:605122150369:android:24a14717fbcad2df9edca0",
      messagingSenderId: "605122150369",
      projectId: "gradding-app",
    ),
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Error: ${details.exception}');
    debugPrint('Stack trace:${details.stack}');
  };

  await FCMNotificationService().initNotification();
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    try {
      final Map payload = message.data;
      FCMNotificationService().onNotificationClicked(
        payload: payload,
      );
    } catch (e) {
      debugPrint("onDidReceiveNotificationResponse error $e");
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      builder: (context, child) {
        final boldText = MediaQuery.boldTextOf(context);

        final newMediaQueryData = MediaQuery.of(context).copyWith(
          boldText: boldText,
          textScaler: const TextScaler.linear(1.0),
        );

        return MediaQuery(
          data: newMediaQueryData,
          child: child!,
        );
      },
      debugShowCheckedModeBanner: APIEndPoints.base == APIEndPoints.beta,
      title: "Gradding",
      routerConfig: goRouterConfig,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        useMaterial3: true,
        primaryColor: AppColors.primaryColor,
        fontFamily: 'Quicksand',
        switchTheme: const SwitchThemeData(
          splashRadius: 0,
        ),
        popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.white,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius.vertical(
              top: SmoothRadius(cornerRadius: 16, cornerSmoothing: 1.0),
            ),
          ),
          showDragHandle: true,
          dragHandleSize: Size(60, 4),
          clipBehavior: Clip.hardEdge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 10),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: SmoothBorderRadius(cornerRadius: 10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.alabaster,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.paleSky),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(cornerRadius: 10),
            ),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 10,
              ),
            ),
            foregroundColor: Colors.white,
            textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 0.15),
            backgroundColor: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
