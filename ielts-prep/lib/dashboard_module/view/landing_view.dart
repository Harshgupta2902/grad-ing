import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:utilities/common/controller/default_controller.dart';
import 'package:ielts_dashboard/navigation/ielts_go_paths.dart';
import 'package:utilities/common/bottom_sheet/force_update_sheet.dart';
import 'package:utilities/common/controller/profile_controller.dart';
import 'package:utilities/components/change_exam.dart';
import 'package:utilities/components/gradding_app_bar.dart';
import 'package:utilities/services/analytics_service.dart';
import 'package:utilities/side_drawer/default_app_drawer.dart';
import 'package:utilities/side_drawer/drawer_controller.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';

final _hiddenDrawerController = Get.put(HiddenDrawerController());
final _defaultController = Get.put(DefaultController());
final _profileController = Get.put(ProfileController());

class LandingView extends StatefulWidget {
  const LandingView({super.key, required this.child});

  final Widget child;

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  void initState() {
    super.initState();
    _defaultController.getDefaultData();
    FirebaseAnalyticsService().init(_profileController.state?.profile?.id?.toString());
    if (_defaultController.state?.result?.forceUpdate == 1) {
      Future.delayed(
        Duration.zero,
        () => appUpdateFunction(
          forceUpdate: _defaultController.state?.result?.forceUpdate,
          buildNo: _defaultController.state?.result?.buildNo,
          context: context,
          softUpdate: _defaultController.state?.result?.softUpdate,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => GestureDetector(
          onTap: () {
            if (_hiddenDrawerController.isDrawerOpen.value == false) {
              return;
            }
            _hiddenDrawerController.toggleDrawer();
          },
          child: AnimatedContainer(
            transform: Matrix4.translationValues(
              _hiddenDrawerController.xOffset.value,
              _hiddenDrawerController.yOffset.value,
              0,
            )..scale(
                _hiddenDrawerController.scaleFactor.value,
              ),
            duration: const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeInOut,
            decoration: AppBoxDecoration.getBoxDecoration(
              showShadow: true,
              color: AppColors.backgroundColor,
              borderRadius: _hiddenDrawerController.isDrawerOpen.value ? 40 : 0.0,
              spreadRadius: _hiddenDrawerController.isDrawerOpen.value ? 1 : 0,
              shadowColor: AppColors.white.withOpacity(0.5),
              blurRadius: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                _hiddenDrawerController.isDrawerOpen.value ? 24 : 0.0,
              ),
              child: IgnorePointer(
                ignoring: _hiddenDrawerController.isDrawerOpen.value,
                child: Scaffold(
                  key: _hiddenDrawerController.scaffoldKey,
                  appBar: GraddingAppBar(
                    openDrawer: () {
                      _hiddenDrawerController.scaffoldKey.currentState?.openDrawer();
                    },
                    showActions: true,
                  ),
                  body: widget.child,
                  drawer: DefaultCustomDrawer(
                    profile: () => context.pushNamed(IeltsGoPaths.profile),
                    changeExamCallBack: () => ChangeExam.changeExams(context: context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
