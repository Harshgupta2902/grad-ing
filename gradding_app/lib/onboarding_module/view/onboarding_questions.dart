import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradding/onboarding_module/controller/onboarding_submit_controller.dart';
import 'package:gradding/utilities/constants/assets_path.dart';
import 'package:utilities/app_change.dart';
import 'package:utilities/components/button_loader.dart';
import 'package:utilities/components/cupertino_date_picker.dart';
import 'package:utilities/common/bottom_sheet/search_dropdown.dart';
import 'package:utilities/common/controller/get_city_controller.dart';
import 'package:utilities/common/controller/get_states_controller.dart';
import 'package:gradding/onboarding_module/controller/onboarding_questions_controller.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:gradding/utilities/navigation/navigator.dart';
import 'package:intl/intl.dart';
import 'package:utilities/components/enums.dart';
import 'package:utilities/components/gradding_app_bar.dart';
import 'package:utilities/components/message_scaffold.dart';
import 'package:utilities/form_fields/custom_dropdown_fields.dart';
import 'package:utilities/form_fields/custom_text_fields.dart';
import 'package:utilities/packages/smooth_rectangular_border.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';
import 'package:utilities/validators/generic_validator.dart';
import 'package:utilities/validators/input_formatters.dart';

import 'package:gradding/onboarding_module/model/on_boarding_questions_model.dart';

final _onboardingQuestionsController = Get.put(OnBoardingQuestionsController());
final _onboardingSubmitController = Get.put(OnBoardingSubmitController());
final _getStatesController = Get.put(GetStatesController());
final _getCityController = Get.put(GetCityController());

class OnboardingQuestions extends StatefulWidget {
  const OnboardingQuestions({super.key});

  @override
  State<OnboardingQuestions> createState() => _OnboardingQuestionsState();
}

class _OnboardingQuestionsState extends State<OnboardingQuestions> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? selectedDateString;

  Map<String, String> selectedAnswers = {};
  bool showButton = false;
  int currentPageIndex = 0;
  String? replaceText;

  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController scoreController = TextEditingController();
  final TextEditingController appearedScoreController = TextEditingController();
  final TextEditingController academicController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedAnswers.clear();
    selectedAnswers['grade_type'] = "Percentage";

    if (AppConstants.appName == AppConstants.courseFinder) {
      _onboardingQuestionsController.onBoardingQuestions(services: ["Overseas Education"]);
    }
  }

  void nextPage({int? index}) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() == false) {
      return;
    }
    final key = _onboardingQuestionsController.state?.result?[index ?? currentPageIndex].key;
    final question = _onboardingQuestionsController.state?.result?[currentPageIndex].question;
    if (selectedAnswers.containsKey(key) == false) {
      debugPrint(currentPageIndex.toString());
      messageScaffold(
        content: "Select ${question?.replaceAll("***", replaceText ?? "")}",
        context: context,
        messageScaffoldType: MessageScaffoldType.error,
        isTop: false,
      );
      return;
    }
    if (_onboardingQuestionsController.state?.result?.length == (currentPageIndex + 1)) {
      await _onboardingSubmitController.onBoardingSubmit(postData: selectedAnswers);
      MyNavigator.popUntilAndPushNamed(GoPaths.onboardingSuccess);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.bounceInOut,
    );
  }

  void previousPage() {
    FocusScope.of(context).unfocus();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.bounceInOut,
    );
    showButton = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const GraddingAppBar(
          backButton: true,
          showActions: false,
        ),
        body: _onboardingQuestionsController.obx((state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildQuestionStepper(result: state?.result),
                  Flexible(
                    child: PageView.builder(
                      itemCount: state?.result?.length ?? 0,
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (int index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final questions = state?.result?[index];
                        final question = questions?.question?.replaceAll("***", replaceText ?? "");
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              if (questions?.key == "user_country_id") ...[
                                const SizedBox(height: 26),
                                Text(
                                  question ?? "-",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () => changeCountry(
                                    hintText: "Select Country",
                                    data: state?.result?[index].answers,
                                    onchange: (value) {
                                      countryController.text = value;
                                      showButton = true;
                                    },
                                    getNewData: (key) async {
                                      await _getStatesController.getStates(countyId: key);
                                      selectedAnswers['user_country_id'] = key;
                                      debugPrint(selectedAnswers.toString());
                                      stateController.clear();
                                      cityController.clear();
                                      setState(() {});
                                    },
                                    context: context,
                                  ),
                                  child: Obx(
                                    () => CustomTextFormField(
                                      hintText: "Select Country",
                                      controller: countryController,
                                      enabled: false,
                                      showEnabledBorder: true,
                                      suffix: _getStatesController.isLoggingIn.value == true
                                          ? const Padding(
                                              padding: EdgeInsets.all(16),
                                              child: CircularProgressIndicator(
                                                color: AppColors.primaryColor,
                                                backgroundColor: Colors.white,
                                              ),
                                            )
                                          : const Icon(Icons.arrow_drop_down),
                                      validator: (value) {
                                        return GenericValidator.required(
                                          value: value,
                                          message: "Select Country",
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                if (_getStatesController.state?.answers?.isNotEmpty == true) ...[
                                  const SizedBox(height: 20),
                                  _getStatesController.obx((state) {
                                    return GestureDetector(
                                      onTap: () => changeCountry(
                                        hintText: "Select State",
                                        data: state?.answers,
                                        onchange: (value) {
                                          stateController.text = value;
                                        },
                                        getNewData: (key) async {
                                          await _getCityController.getCities(stateId: key);
                                          selectedAnswers['user_state_id'] = key;
                                          debugPrint(selectedAnswers.toString());
                                          cityController.clear();
                                          setState(() {});
                                        },
                                        context: context,
                                      ),
                                      child: Obx(
                                        () => CustomTextFormField(
                                          hintText: "Select State",
                                          controller: stateController,
                                          enabled: false,
                                          showEnabledBorder: true,
                                          suffix: _getCityController.isLoggingIn.value == true
                                              ? const Padding(
                                                  padding: EdgeInsets.all(16),
                                                  child: CircularProgressIndicator(
                                                    color: AppColors.primaryColor,
                                                    backgroundColor: Colors.white,
                                                  ),
                                                )
                                              : const Icon(Icons.arrow_drop_down),
                                          validator: (value) {
                                            return GenericValidator.required(
                                              value: value,
                                              message: "Select State",
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                                if (_getStatesController.state?.answers?.isNotEmpty == true &&
                                    _getCityController.state?.answers?.isNotEmpty == true) ...[
                                  const SizedBox(height: 20),
                                  _getCityController.obx((state) {
                                    return GestureDetector(
                                      onTap: () => changeCountry(
                                        hintText: "Select City",
                                        data: state?.answers,
                                        onchange: (value) {
                                          cityController.text = value;
                                        },
                                        getNewData: (key) {
                                          selectedAnswers['user_city_id'] = key;
                                          debugPrint(selectedAnswers.toString());
                                        },
                                        context: context,
                                      ),
                                      child: CustomTextFormField(
                                        hintText: "Select City",
                                        controller: cityController,
                                        enabled: false,
                                        showEnabledBorder: true,
                                        suffix: const Icon(Icons.arrow_drop_down),
                                        validator: (value) {
                                          return GenericValidator.required(
                                            value: value,
                                            message: "Select City",
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ],
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  child: Image.asset(
                                    AssetPath.passportImg,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ] else ...[
                                const SizedBox(height: 26),
                                Text(
                                  question ?? "-",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 20),
                                Flexible(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state?.result?[index].answers?.length ?? 0,
                                    itemBuilder: (context, subIndex) {
                                      final answer = state?.result?[index].answers?[subIndex];
                                      if (selectedAnswers.containsKey(questions?.key)) {
                                        showButton = true;
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedAnswers[questions?.key ?? ""] =
                                                answer?.key ?? "";

                                            if (questions?.key == "eduexam") {
                                              replaceText = answer?.key;
                                            }

                                            if (selectedAnswers['examRequire'] == "Yes" &&
                                                !selectedAnswers.containsKey('test_score')) {
                                              showButton = true;
                                            } else if (selectedAnswers['timeDuration'] ==
                                                    "already-booked" &&
                                                !selectedAnswers.containsKey('exam_date')) {
                                              showButton = true;
                                            } else if (selectedAnswers['purpose'] == "Other" &&
                                                !selectedAnswers.containsKey('reason')) {
                                              showButton = true;
                                            } else if (selectedAnswers.containsKey('highedu')) {
                                              showButton = true;
                                            } else if (selectedAnswers.containsKey('exam') ||
                                                selectedAnswers['exam'] != "NT" ||
                                                selectedAnswers['exam'] != "others") {
                                              appearedScoreController.clear();
                                              showButton = true;
                                            } else if (selectedAnswers.containsKey('exam1') ||
                                                selectedAnswers['exam1'] != "NT" ||
                                                selectedAnswers['exam1'] != "others") {
                                              showButton = true;
                                            } else if (selectedAnswers.containsKey('country')) {
                                              showButton = true;
                                            }
                                          });
                                          appearedScoreController.clear();
                                          academicController.clear();
                                          debugPrint(selectedAnswers.toString());
                                        },
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(bottom: 28),
                                              padding: const EdgeInsets.symmetric(vertical: 18),
                                              decoration: AppBoxDecoration.getBorderBoxDecoration(
                                                borderRadius: 14,
                                                color:
                                                    selectedAnswers[questions?.key] == answer?.key
                                                        ? AppColors.primaryColor.withOpacity(0.1)
                                                        : Colors.white,
                                                borderColor:
                                                    selectedAnswers[questions?.key] == answer?.key
                                                        ? AppColors.primaryColor
                                                        : AppColors.frenchGrey,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  answer?.value ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: selectedAnswers[questions?.key] ==
                                                                answer?.key
                                                            ? AppColors.primaryColor
                                                            : AppColors.balticSea,
                                                        fontWeight:
                                                            selectedAnswers[questions?.key] ==
                                                                    answer?.key
                                                                ? FontWeight.w600
                                                                : null,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            if (selectedAnswers[questions?.key] == answer?.key)
                                              const Positioned(
                                                right: 6,
                                                top: 17,
                                                child: Icon(
                                                  Icons.verified,
                                                  color: AppColors.seaGreen,
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 26),
                                if (selectedAnswers.containsKey("examRequire") &&
                                    selectedAnswers["examRequire"] == "Yes" &&
                                    questions?.key == "examRequire") ...[
                                  CustomTextFormField(
                                    hintText: "Enter Score",
                                    controller: scoreController,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                      LengthLimitingTextInputFormatter(4),
                                      DecimalInputFormatter(decimalRange: 1),
                                      NumberRangeInputFormatter(
                                        min: 0.0,
                                        max: getMaxScore("$replaceText"),
                                      ),
                                    ],
                                    showEnabledBorder: true,
                                    onChanged: (value) {
                                      selectedAnswers['test_score'] = value;
                                      debugPrint(selectedAnswers.toString());
                                    },
                                    validator: (value) {
                                      return GenericValidator.required(
                                          value: value,
                                          message:
                                              "Please enter your previous $replaceText band score"
                                          // "Enter $replaceText Score (Max Score is ${getMaxScore("$replaceText")})",
                                          );
                                    },
                                  ),
                                ],
                                if (selectedAnswers.containsKey("exam1") &&
                                    selectedAnswers['exam1'] != "NT" &&
                                    selectedAnswers['exam1'] != "others" &&
                                    questions?.key == "exam1") ...[
                                  CustomTextFormField(
                                    hintText: "Enter Academic Score",
                                    controller: academicController,
                                    showEnabledBorder: true,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      NumberRangeInputFormatter(
                                          min: 0.0,
                                          max: getMaxScore("${selectedAnswers['exam1']}")),
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                      DecimalInputFormatter(decimalRange: 1),
                                      LengthLimitingTextInputFormatter(4),
                                    ],
                                    onChanged: (value) {
                                      selectedAnswers['academic_test_score'] = value;
                                      debugPrint(selectedAnswers.toString());
                                    },
                                    validator: (value) {
                                      return GenericValidator.required(
                                          value: value,
                                          message:
                                              "Please enter your previous ${selectedAnswers['exam1']} score");
                                    },
                                  ),
                                ],
                                if (selectedAnswers.containsKey("exam") &&
                                    selectedAnswers['exam'] != "NT" &&
                                    selectedAnswers['exam'] != "others" &&
                                    questions?.key == "exam") ...[
                                  CustomTextFormField(
                                    hintText: "Enter Language Score",
                                    controller: appearedScoreController,
                                    keyboardType: TextInputType.number,
                                    showEnabledBorder: true,
                                    inputFormatter: [
                                      NumberRangeInputFormatter(
                                        min: 0.0,
                                        max: getMaxScore("${selectedAnswers['exam']}"),
                                      ),
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                      DecimalInputFormatter(decimalRange: 1),
                                      LengthLimitingTextInputFormatter(4)
                                    ],
                                    onChanged: (value) {
                                      selectedAnswers['language_test_score'] = value;
                                      debugPrint(selectedAnswers.toString());
                                    },
                                    validator: (value) {
                                      return GenericValidator.required(
                                          value: value,
                                          message:
                                              "Please enter your previous ${selectedAnswers['exam']} score");
                                    },
                                  ),
                                ],
                                if (selectedAnswers.containsKey("highedu") &&
                                    questions?.key == "highedu") ...[
                                  CustomDropDownFormField(
                                    value: selectedAnswers['grade_type'],
                                    showEnabledBorder: true,
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Percentage",
                                        child: Text("Percentage"),
                                      ),
                                      DropdownMenuItem(
                                        value: "CGPA (4.0)",
                                        child: Text("CGPA (4.0)"),
                                      ),
                                      DropdownMenuItem(
                                        value: "CGPA (5.0)",
                                        child: Text("CGPA (5.0)"),
                                      ),
                                      DropdownMenuItem(
                                        value: "CGPA (10.0)",
                                        child: Text("CGPA (10.0)"),
                                      )
                                    ],
                                    hintText: "Select Grade Type",
                                    onChanged: (value) {
                                      selectedAnswers['grade_type'] = value.toString();
                                      debugPrint(selectedAnswers.toString());
                                    },
                                  ),
                                  const SizedBox(height: 6),
                                  CustomTextFormField(
                                    hintText: selectedAnswers['grade_type'] == 'Percentage'
                                        ? 'Enter Percentage'
                                        : 'Enter CGPA',
                                    controller: gradeController,
                                    showEnabledBorder: true,
                                    keyboardType: TextInputType.number,
                                    inputFormatter: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                      LengthLimitingTextInputFormatter(5),
                                    ],
                                    onChanged: (value) {
                                      selectedAnswers['grade'] = value;
                                      debugPrint(selectedAnswers.toString());
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return selectedAnswers['grade_type'] == 'Percentage'
                                            ? 'Enter Percentage'
                                            : 'Enter CGPA';
                                      }

                                      final score = double.tryParse(value);
                                      if (score == null) {
                                        return selectedAnswers['grade_type'] == 'Percentage'
                                            ? 'Invalid Percentage'
                                            : 'Invalid CGPA';
                                      }

                                      if (selectedAnswers['grade_type'] == 'Percentage') {
                                        if (score < 36 || score > 100) {
                                          return 'Percentage must be between 36 and 100';
                                        }
                                      } else {
                                        double maxScore;
                                        switch (selectedAnswers['grade_type']) {
                                          case 'CGPA (4.0)':
                                            maxScore = 4.0;
                                            break;
                                          case 'CGPA (5.0)':
                                            maxScore = 5.0;
                                            break;
                                          case 'CGPA (10.0)':
                                            maxScore = 10.0;
                                            break;
                                          default:
                                            return 'Select a valid grade type';
                                        }

                                        if (score < 0 || score > maxScore) {
                                          return 'CGPA must be between 0 and $maxScore';
                                        }
                                      }

                                      return null;
                                    },
                                  ),
                                ],
                                if (selectedAnswers.containsKey("timeDuration") &&
                                    selectedAnswers["timeDuration"] == "already-booked" &&
                                    questions?.key == "timeDuration") ...[
                                  GestureDetector(
                                    onTap: () => cupertinoCalenderDrawer(
                                      context: context,
                                      title: "Select Date",
                                      startDate: DateTime.now(),
                                      mode: CupertinoDatePickerMode.monthYear,
                                      endDate: DateTime.now().add(
                                        const Duration(days: 365 * 2),
                                      ),
                                      onSave: (date) {
                                        setState(() {
                                          selectedDate = date;
                                          selectedDateString =
                                              DateFormat('MM-yyyy').format(date); // Format the date
                                          dateController.text = selectedDateString!;
                                          selectedAnswers['exam_date'] = dateController.text;
                                          debugPrint(selectedAnswers.toString());
                                        });
                                      },
                                      initialDate: DateTime.now(),
                                    ),
                                    child: CustomTextFormField(
                                      hintText: "Select Date",
                                      controller: dateController,
                                      enabled: false,
                                      showEnabledBorder: true,
                                      validator: (value) {
                                        return GenericValidator.required(
                                          value: value,
                                          message: "Select Date",
                                        );
                                      },
                                    ),
                                  ),
                                ],
                                if (selectedAnswers.containsKey("purpose") &&
                                    selectedAnswers["purpose"] == "Other" &&
                                    questions?.key == "purpose") ...[
                                  CustomTextFormField(
                                    hintText: "Enter Reason",
                                    controller: reasonController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 4,
                                    showEnabledBorder: true,
                                    inputFormatter: [
                                      LengthLimitingTextInputFormatter(120),
                                      WhitespaceTextInputFormatter()
                                    ],
                                    onChanged: (value) {
                                      selectedAnswers['reason'] = value;
                                      debugPrint(selectedAnswers.toString());
                                    },
                                    validator: (value) {
                                      return GenericValidator.required(
                                        value: value?.trim(),
                                        message: "Enter Reason",
                                      );
                                    },
                                  ),
                                ],
                              ],
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        bottomNavigationBar: Container(
          color: AppColors.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (currentPageIndex != 0)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width / 2.5, 50),
                    ),
                    onPressed: () async {
                      previousPage();
                    },
                    child: const Text("Previous"),
                  ),
                ),
              if (showButton == true)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width / 2.5, 50),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == false) {
                        return;
                      }

                      nextPage();
                    },
                    child: ButtonLoader(
                      isLoading: _onboardingSubmitController.isSubmitting,
                      buttonString: "Save & Next",
                      loaderString: "Submitting...",
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _buildQuestionStepper({required List<Result>? result}) {
    return Row(
      children: List.generate(result?.length ?? 0, (index) {
        return Flexible(
          flex: currentPageIndex == index ? 6 : 1,
          child: GestureDetector(
            onTap: () {
              if (index > currentPageIndex) {
                nextPage(index: index);
                return;
              }
              if (index < currentPageIndex) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.bounceInOut,
                );
                // previousPage();
                return;
              }
            },
            child: Center(
              child: Column(
                children: [
                  AnimatedContainer(
                    height: 22,
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPageIndex == index
                          ? Colors.transparent
                          : currentPageIndex >= index
                              ? AppColors.primaryColor
                              : Colors.transparent,
                      border: Border.all(
                        color: currentPageIndex >= index ? AppColors.primaryColor : Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: currentPageIndex > index ? Colors.white : Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    // width: currentPageIndex == index ? 100 : 32,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      color: AppColors.primaryColor,
                      backgroundColor: AppColors.heather,
                      borderRadius: SmoothBorderRadius(cornerRadius: 24),
                      value: currentPageIndex >= index ? 1 : 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

double getMaxScore(String exam) {
  double maxScore;

  switch (exam) {
    case 'IELTS':
      maxScore = 9.0;
      break;
    case 'PTE':
      maxScore = 90.0;
      break;
    case 'TOEFL':
      maxScore = 120.0;
      break;
    case 'DUOLINGO':
      maxScore = 160.0;
      break;
    case 'ActRequired':
      maxScore = 36;
      break;
    case 'SatRequired':
      maxScore = 1600;
      break;
    case 'GRE':
      maxScore = 340;
      break;
    case 'GMAT':
      maxScore = 800;
      break;
    case 'German':
      maxScore = 100;
      break;
    case 'French':
      maxScore = 990;
      break;
    default:
      maxScore = 0;
      break;
  }

  return maxScore;
}
