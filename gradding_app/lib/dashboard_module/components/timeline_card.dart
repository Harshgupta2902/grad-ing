import 'package:flutter/material.dart';
import 'package:study_abroad/study_abroad_module/models/study_abroad_dashboard_model.dart';
import 'package:utilities/common/bottom_sheet/book_session_sheet.dart';
import 'package:utilities/packages/another_stepper.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';

class TimeLineCard extends StatelessWidget {
  const TimeLineCard({super.key, required this.timeline});

  final List<Timeline>? timeline;

  @override
  Widget build(BuildContext context) {
    bool showButton = timeline?.any((item) => item.name == "Student backed out / Dropped") ?? false;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: AppBoxDecoration.getBoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          AnotherStepper(
            timings: List.generate(timeline?.length ?? 0, (index) {
              return timeline?[index].createdDate;
            }),
            stepperList: List.generate(timeline?.length ?? 0, (index) {
              return StepperData(
                subtitle: StepperText(timeline?[index].name ?? ""),
              );
            }),
            activeBarColor: AppColors.darkMintGreen,
            inActiveBarColor: AppColors.cadetGrey,
            activeIndex: getFirstNullIndex(timeline),
            isError: showButton,
          ),
          if (showButton) ...[
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 42)),
              onPressed: () => bookSessionSheet(context, service: ""),
              child: const Text("Re-Inquiry"),
            ),
          ]
        ],
      ),
    );
  }
}

int getFirstNullIndex(List<Timeline>? timing) {
  for (int i = 0; i < (timing?.length ?? 0); i++) {
    if (timing?[i].createdDate == null) {
      return i - 1;
    }
  }
  return timing!.length;
}
