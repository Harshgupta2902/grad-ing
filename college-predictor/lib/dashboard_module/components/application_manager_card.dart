import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:gradding/dashboard_module/controller/study_abroad_dashboard_controller.dart';
import 'package:ielts_dashboard/constants/ielts_assets_path.dart';
import 'package:study_abroad/navigation/study_abroad_go_paths.dart';
import 'package:utilities/app_change.dart';
import 'package:utilities/packages/smooth_rectangular_border.dart';

final studyAbroadDashboardController = Get.put(StudyAbroadDashboardController());

class ApplicationManagerCard extends StatefulWidget {
  const ApplicationManagerCard({
    super.key,
    required this.shortlisted,
    required this.applied,
    required this.title,
  });
  final String shortlisted;
  final String applied;
  final String title;

  @override
  State<ApplicationManagerCard> createState() => _ApplicationManagerCardState();
}

class _ApplicationManagerCardState extends State<ApplicationManagerCard> {
  @override
  void initState() {
    super.initState();
    studyAbroadDashboardController.getStudyAbroadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: SmoothBorderRadius(cornerRadius: 16),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            IeltsAssetPath.appManagerBackgroundBlue,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (AppConstants.appName != AppConstants.collegePredictor)
                GestureDetector(
                  onTap: () => context.pushNamed(StudyAbroadGoPaths.courseFinder),
                  child: const Icon(Icons.add_circle, color: Colors.white, size: 26),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => context
                    .pushNamed(StudyAbroadGoPaths.applicationManager, extra: {'tabIndex': 0}),
                child: Column(
                  children: [
                    Text(
                      widget.shortlisted,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Shortlisted",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
                child: VerticalDivider(
                  thickness: 2,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => context
                    .pushNamed(StudyAbroadGoPaths.applicationManager, extra: {'tabIndex': 1}),
                child: Column(
                  children: [
                    Text(
                      widget.applied,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Applied",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
