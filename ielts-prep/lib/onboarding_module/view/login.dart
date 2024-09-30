import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:utilities/components/button_loader.dart';
import 'package:utilities/components/enums.dart';
import 'package:utilities/components/message_scaffold.dart';
import 'package:utilities/form_fields/custom_text_fields.dart';
import 'package:utilities/packages/smooth_rectangular_border.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';
import 'package:utilities/form_fields/intl_text_field.dart';
import 'package:gradding/onboarding_module/controller/mobile_verification_controller.dart';
import 'package:gradding/onboarding_module/controller/otp_sent_controller.dart';
import 'package:gradding/utilities/constants/assets_path.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:gradding/utilities/navigation/navigator.dart';
import 'package:utilities/validators/generic_validator.dart';
import 'package:utilities/validators/input_formatters.dart';
import 'package:utilities/validators/my_regex.dart';

final _mobileVerificationController = Get.put(MobileVerificationController());
final _optSentController = Get.put(OtpSentController());

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.number});

  final String? number;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String countryCode = "91";
  String selectedName = "India";
  int maxLength = 10;
  bool show = false;
  bool checked = true;

  @override
  void initState() {
    super.initState();
    debugPrint("widget.number::::::::::::::${widget.number}");
    setState(() {
      phoneController.text = widget.number ?? "";
    });
    firstNameController.clear();
    lastNameController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
  }

  bool isMaxLengthReached() {
    return phoneController.text.length == maxLength;
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
  }

  void verifyMobileNumber() {
    _mobileVerificationController
        .mobileVerification(
      country: countryCode,
      number: phoneController.text.trim(),
    )
        .then((value) {
      debugPrint(value.toString());
      updateShowState(value.toString() == '0');
    });
  }

  void updateShowState(bool newState) {
    if (show != newState) {
      setState(() {
        show = newState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: kToolbarHeight),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: SvgPicture.asset(
                  AssetPath.login,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 26),
                color: Colors.grey.withOpacity(0.2),
              ),
              const SizedBox(height: 22),
              Text(
                "Certified by",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.asset(
                  AssetPath.certifiedBy,
                ),
              ),
              SizedBox(height: show == true ? 40 : 64),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: AppBoxDecoration.getBoxDecoration(borderRadius: 14, showShadow: false),
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Obx(
                          () => IntlTextField(
                            controller: phoneController,
                            suffixIcon: _mobileVerificationController.isLoggingIn.value == true
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                          backgroundColor: AppColors.white,
                                          strokeWidth: 2.0),
                                    ),
                                  )
                                : null,
                            onCountryChanged: (value) {
                              debugPrint(value.dialCode);
                              debugPrint(value.name);
                              debugPrint(value.maxLength.toString());
                              setState(() {
                                countryCode = value.dialCode;
                                selectedName = value.name;
                                maxLength = value.maxLength;
                              });
                              phoneController.clear();
                            },
                            onChanged: (value) {
                              if (isMaxLengthReached()) {
                                verifyMobileNumber();
                              }
                            },
                            validator: (value) {
                              return GenericValidator.required(
                                    value: value,
                                    message: "Enter Number",
                                  ) ??
                                  GenericValidator.checkLength(
                                    value: value,
                                    length: maxLength,
                                    message: "Invalid Number",
                                  );
                            },
                            hintText: 'Mobile Number',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (show) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: CustomTextFormField(
                                  hintText: "First Name",
                                  controller: firstNameController,
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(20),
                                    TextOnlyFormatter()
                                  ],
                                  validator: (value) {
                                    return GenericValidator.required(
                                      value: value,
                                      message: "Enter First Name",
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: CustomTextFormField(
                                  hintText: "Last Name",
                                  controller: lastNameController,
                                  inputFormatter: [
                                    LengthLimitingTextInputFormatter(11),
                                    TextOnlyFormatter()
                                  ],
                                  validator: (value) {
                                    return GenericValidator.required(
                                      value: value,
                                      message: "Enter Last Name",
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (show && countryCode != "91") ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: CustomTextFormField(
                            hintText: "Email",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return GenericValidator.required(
                                    value: value,
                                    message: "Enter email",
                                  ) ??
                                  GenericValidator.regexMatch(
                                    value: value,
                                    regex: MyRegex.emailPattern,
                                    message: "Invalid E-mail",
                                  );
                            },
                          ),
                        )
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: checked,
                            splashRadius: 0,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            onChanged: (value) {
                              setState(() {
                                checked = !checked;
                              });
                            },
                            activeColor: AppColors.primaryColor,
                            shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(cornerRadius: 4),
                              side: const BorderSide(
                                color: AppColors.blueHaze,
                                strokeAlign: 5,
                                width: 5,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              "I agree to receive whatsapp messages",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.paleSky, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(MediaQuery.of(context).size.width, 60),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();

                            if (_formKey.currentState?.validate() == false) {
                              return;
                            }

                            final postData = {
                              'country_code': countryCode,
                              'phone': phoneController.text,
                              'name': firstNameController.text,
                              'last_name': lastNameController.text,
                              'country': selectedName,
                              'email': emailController.text,
                              "reset": "reset",
                            };
                            final value = await _optSentController.otpSent(postData: postData);
                            debugPrint(value.toString());
                            if (value == 500) {
                              Future.delayed(
                                Duration.zero,
                                () => messageScaffold(
                                  context: context,
                                  content: "Something Went Wrong",
                                  messageScaffoldType: MessageScaffoldType.error,
                                ),
                              );
                            }
                            if (countryCode == "91") {
                              if (value.toString() == "1") {
                                MyNavigator.pushNamed(
                                  GoPaths.otp,
                                  extra: {
                                    'phone': phoneController.text,
                                    'path': GoPaths.login,
                                  },
                                );
                              }
                            } else {
                              final route = show ? GoPaths.createPin : GoPaths.enterPin;
                              final extra = show
                                  ? {
                                      'countryCode': countryCode,
                                      'number': phoneController.text,
                                    }
                                  : null;

                              MyNavigator.pushNamed(route, extra: extra);
                            }
                          },
                          child: ButtonLoader(
                            isLoading: _optSentController.isLoggingIn,
                            buttonString: "Continue",
                            loaderString:
                                (show && countryCode != "91") ? "Validating" : "Sending OTP",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
