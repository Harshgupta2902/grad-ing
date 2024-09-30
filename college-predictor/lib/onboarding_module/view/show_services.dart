import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradding/onboarding_module/controller/onboarding_submit_controller.dart';
import 'package:utilities/components/button_loader.dart';
import 'package:gradding/onboarding_module/controller/get_services_controller.dart';
import 'package:gradding/onboarding_module/controller/onboarding_questions_controller.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:gradding/utilities/navigation/navigator.dart';
import 'package:utilities/components/custom_header_delegate.dart';
import 'package:utilities/components/enums.dart';
import 'package:utilities/components/gradding_app_bar.dart';
import 'package:utilities/components/message_scaffold.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';

final _getServicesController = Get.put(GetServicesController());
final _getQuestionsController = Get.put(OnBoardingQuestionsController());
final _onboardingSubmitController = Get.put(OnBoardingSubmitController());

class ShowServices extends StatefulWidget {
  const ShowServices({super.key});

  @override
  State<ShowServices> createState() => _ShowServicesState();
}

class _ShowServicesState extends State<ShowServices> {
  @override
  void initState() {
    _getServicesController.getServices();
    super.initState();
  }

  List<String> selectedServices = [];

  void _toggleSelection(String serviceName) {
    setState(() {
      if (selectedServices.contains(serviceName)) {
        selectedServices.remove(serviceName);
      } else {
        selectedServices.add(serviceName);
      }
    });
    debugPrint(selectedServices.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GraddingAppBar(
        backButton: true,
        showActions: false,
        centerTitle: true,
        title: "Select Services",
      ),
      body: _getServicesController.obx((state) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverPersistentHeader(
              pinned: true,
              delegate: CustomHeaderDelegate(
                minExtent: 65,
                maxExtent: 65,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: AppColors.backgroundColor,
                  child: Text(
                    "Select services for better assistance",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
          body: ListView.builder(
            itemCount: state?.result?.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
            itemBuilder: (context, index) {
              final data = state?.result?[index];
              final isSelected = selectedServices.contains(data);
              return GestureDetector(
                onTap: () => _toggleSelection(data ?? ""),
                child: Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 28),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: AppBoxDecoration.getBorderBoxDecoration(
                    borderRadius: 14,
                    borderColor: isSelected ? AppColors.primaryColor : AppColors.blueHaze,
                    color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      data ?? "",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected ? AppColors.primaryColor : AppColors.balticSea,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
          floatHeaderSlivers: true,
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 60),
          ),
          onPressed: () async {
            if (selectedServices.isEmpty) {
              messageScaffold(
                context: context,
                content: "Select Services",
                messageScaffoldType: MessageScaffoldType.error,
              );
              return;
            }
            await _getQuestionsController.onBoardingQuestions(services: selectedServices);
            if (_getQuestionsController.state?.result?.isNotEmpty == true) {
              MyNavigator.pushNamed(GoPaths.onboardingQuestions);
            } else {
              await _onboardingSubmitController.onBoardingSubmit(postData: {});
              MyNavigator.pushNamed(GoPaths.onboardingSuccess);
            }
          },
          child: ButtonLoader(
            isLoading: RxBool(false),
            buttonString: "Save & Next",
            loaderString: "Submitting...",
          ),
        ),
      ),
    );
  }
}
