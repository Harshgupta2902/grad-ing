import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gradding/dashboard_module/components/application_manager_card.dart';
import 'package:gradding/dashboard_module/controller/study_abroad_dashboard_controller.dart';
import 'package:study_abroad/navigation/study_abroad_go_paths.dart';
import 'package:study_abroad/study_abroad_module/components/unifinder/recommend_universities.dart';
import 'package:utilities/app_change.dart';
import 'package:utilities/common/bottom_sheet/councellor_sheet.dart';
import 'package:utilities/components/blurry_container.dart';
import 'package:utilities/components/try_again.dart';
import 'package:utilities/packages/smooth_rectangular_border.dart';
import 'package:utilities/services/fcm_notification_service.dart';
import 'package:utilities/common/controller/default_controller.dart';
import 'package:gradding/utilities/constants/assets_path.dart';
import 'package:utilities/common/controller/profile_controller.dart';
import 'package:utilities/common/model/common_model.dart';
import 'package:utilities/side_drawer/default_app_drawer_controller.dart';
import 'package:utilities/common/bottom_sheet/book_session_sheet.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';
import 'package:get/get.dart';

final _defaultController = Get.put(DefaultController());
final _defaultCustomDrawerController = Get.put(GetMenuItemsController());
final _profileController = Get.put(ProfileController());
final studyAbroadDashboardController = Get.put(StudyAbroadDashboardController());

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  final services = [
    KeyValuePair(
      key: AssetPath.studyAbroad,
      value: "Study Abroad",
    ),
    KeyValuePair(
      key: AssetPath.testPrep,
      value: "Test Prep",
    ),
    KeyValuePair(
      key: AssetPath.visaServices,
      value: "Visa Services",
    ),
    KeyValuePair(
      key: AssetPath.loansFinance,
      value: "Loans",
    ),
    KeyValuePair(
      key: AssetPath.accommodation,
      value: "Accommodation",
    ),
    KeyValuePair(
      key: AssetPath.documentPrep,
      value: "Document Prep",
    ),
  ];

  int activeIndex = 0;
  final controller = CarouselController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      FCMNotificationService().updateFCMToken();

      await studyAbroadDashboardController.getStudyAbroadDashboardData();
      scrollController.addListener(_scrollListener);

      if (_defaultController.state?.result == null) {
        await _defaultController.getDefaultData();
      }
      await _defaultCustomDrawerController.getMenuItems(path: "home");
      await _profileController.getProfileData();
    });
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      debugPrint(scrollController.position.pixels.toString());
      debugPrint(scrollController.position.maxScrollExtent.toString());
      if (studyAbroadDashboardController.isLoading.value == false) {
        studyAbroadDashboardController.getStudyAbroadDashboardData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: studyAbroadDashboardController.obx(
        (state) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                CarouselSlider.builder(
                  carouselController: controller,
                  itemCount: state?.result?.cards?.length ?? 0,
                  itemBuilder: (context, index, realIndex) {
                    final data = state?.result?.cards?[index];
                    final asset = [
                      AssetPath.pinkBackground,
                      AssetPath.blueBackground,
                      AssetPath.greenBackground,
                    ];
                    return buildCarousel(
                      asset[index],
                      data?.title,
                      data?.description,
                      data?.btn,
                      data?.link,
                      state?.result?.counsellor?.number,
                      state?.result?.counsellor?.name,
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: AppConstants.appName == AppConstants.gradding ? true : false,
                    aspectRatio: 2 / 1,
                    enableInfiniteScroll: true,
                    disableCenter: true,
                    pauseAutoPlayOnTouch: false,
                    clipBehavior: Clip.hardEdge,
                    viewportFraction: 0.85,
                    enlargeCenterPage: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                    onPageChanged: (index, reason) => setState(() => activeIndex = index),
                    pageSnapping: true,
                    scrollDirection: Axis.horizontal,
                    scrollPhysics: const BouncingScrollPhysics(),
                  ),
                ),
                buildIndicator(state?.result?.cards?.length ?? 0),
                // if (state?.result?.courses?.isNotEmpty == true) ...[
                //   const SizedBox(height: 20),
                //   RecommendedCourses(
                //     courses: state?.result?.courses,
                //     counsellor: state?.result?.counsellor,
                //   ),
                // ],
                if (state?.result?.universities?.isNotEmpty == true) ...[
                  const SizedBox(height: 20),
                  RecommendedUniversities(university: state?.result?.universities),
                ],
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: services.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 14,
                    mainAxisExtent: 90,
                  ),
                  itemBuilder: (context, index) {
                    final data = services[index];
                    return GestureDetector(
                      onTap: () {
                        bookSessionSheet(context, service: data.value);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: AppBoxDecoration.getBoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              data.key,
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(height: 8),
                            Flexible(
                              child: Text(
                                data.value,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.darkJungleGreen),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if ((state?.result?.applications?.applied != 0 ||
                        state?.result?.applications?.shortlist != 0) &&
                    AppConstants.appName != AppConstants.gradding) ...[
                  const SizedBox(height: 20),
                  ApplicationManagerCard(
                    applied: "${state?.result?.applications?.applied}",
                    shortlisted: "${state?.result?.applications?.shortlist}",
                    title: "${state?.result?.applications?.title}",
                  ),
                ],
                const SizedBox(height: kBottomNavigationBarHeight + 20),
              ],
            ),
          );
        },
        onError: (error) => TryAgain(
          onTap: () => studyAbroadDashboardController.getStudyAbroadDashboardData(),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => counsellorSheet(
                  context,
                  phoneNumber:
                      studyAbroadDashboardController.state?.result?.counsellor?.number ?? "",
                  name: studyAbroadDashboardController.state?.result?.counsellor?.name ?? "",
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: SmoothBorderRadius(cornerRadius: 14),
                  ),
                  child: BlurredContainer(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AssetPath.callNow),
                        const SizedBox(width: 12),
                        Text(
                          "Call Us Now",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600, color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: GestureDetector(
                onTap: () => context.pushNamed(StudyAbroadGoPaths.universityFinder),
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: SmoothBorderRadius(cornerRadius: 14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AssetPath.startJourney),
                      const SizedBox(width: 12),
                      Text(
                        "Start Journey",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) {
          return Container(
            width: index == activeIndex ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: AppBoxDecoration.getBoxDecoration(
              borderRadius: 16,
              color: index == activeIndex
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withOpacity(
                      0.5,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCarousel(
    String urlImage,
    String? title,
    String? subtitle,
    String? buttonText,
    String? routePath,
    String? phoneNumber,
    String? name,
  ) {
    return GestureDetector(
      onTap: () {
        if (routePath?.startsWith("+91") == true) {
          debugPrint("$phoneNumber");
          debugPrint("$name");
          counsellorSheet(context, phoneNumber: "$phoneNumber", name: "$name");
          return;
        } else if (routePath == "/bookSessionSheet") {
          bookSessionSheet(context, service: "");
        } else {
          context.pushNamed(routePath ?? "");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(urlImage),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Text(
                subtitle ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white.withOpacity(0.7)),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (routePath?.startsWith("+91") == true) {
                  debugPrint("$phoneNumber");
                  debugPrint("$name");
                  counsellorSheet(context, phoneNumber: "$phoneNumber", name: "$name");
                  return;
                } else if (routePath == "/bookSessionSheet") {
                  bookSessionSheet(context, service: "");
                } else {
                  context.pushNamed(routePath ?? "");
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: AppBoxDecoration.getBoxDecoration(borderRadius: 10),
                child: Center(
                  child: Text(
                    buttonText ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: getColorFromAsset(urlImage), fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color getColorFromAsset(String assetPath) {
  switch (assetPath) {
    case AssetPath.pinkBackground:
      return Colors.pink;
    case AssetPath.blueBackground:
      return Colors.blue;
    case AssetPath.greenBackground:
      return Colors.green;
    default:
      return Colors.blue;
  }
}
