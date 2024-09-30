import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:utilities/common/controller/default_controller.dart';
import 'package:utilities/components/button_loader.dart';
import 'package:utilities/packages/dialogs.dart';
import 'package:gradding/onboarding_module/controller/mobile_verification_controller.dart';
import 'package:gradding/onboarding_module/controller/otp_sent_controller.dart';
import 'package:gradding/onboarding_module/controller/pin_generate_controller.dart';
import 'package:gradding/onboarding_module/controller/pin_verification_controller.dart';
import 'package:gradding/utilities/constants/assets_path.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:gradding/utilities/navigation/navigator.dart';
import 'package:lottie/lottie.dart';
import 'package:utilities/components/gradding_app_bar.dart';
import 'package:utilities/form_fields/pinput_field.dart';
import 'package:utilities/theme/app_colors.dart';
import 'package:utilities/validators/generic_validator.dart';

final defaultController = Get.put(DefaultController());

class CreatePinView extends StatefulWidget {
  const CreatePinView({super.key, required this.countryCode, required this.number});

  final String countryCode;
  final String number;

  @override
  State<CreatePinView> createState() => _CreatePinViewState();
}

class _CreatePinViewState extends State<CreatePinView> {
  final TextEditingController pinController = TextEditingController();

  final _pinGenerateController = Get.put(PinGenerateController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GraddingAppBar(
        backButton: true,
        showActions: false,
        title: "Login Pin",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              Lottie.asset(AssetPath.lockLottie, height: 135),
              Text(
                "Create your 4 digit Login PIN",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkJungleGreen,
                    ),
              ),
              const SizedBox(height: 30),
              PinputField(
                controller: pinController,
                obscureText: true,
                validator: (value) {
                  return GenericValidator.required(value: value, message: "Please Enter Pin") ??
                      GenericValidator.checkLength(
                          value: value, length: 4, message: "Enter Valid Pin");
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "By continuing, you agree to our ",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.stormGrey,
                        ),
                    children: [
                      TextSpan(
                        text: "Terms of Service",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushNamed(
                              GoPaths.viewPolicy,
                              extra: {
                                "title": "Terms & Conditins",
                                "policy": defaultController.state?.result?.terms,
                                "leaveUrl": ""
                              },
                            );
                          },
                      ),
                      const TextSpan(
                        text: " and ",
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushNamed(
                              GoPaths.viewPolicy,
                              extra: {
                                "title": "Privacy Policy",
                                "policy": defaultController.state?.result?.privacy,
                                "leaveUrl": ""
                              },
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 60),
          ),
          onPressed: () async {
            if (_formKey.currentState?.validate() == false) {
              return;
            }
            await _pinGenerateController.pinGenerate(
              pin: pinController.text,
              countryCode: widget.countryCode,
              phone: widget.number,
            );
            MyNavigator.popUntilAndPushNamed(GoPaths.showServices);
          },
          child: ButtonLoader(
            isLoading: _pinGenerateController.isLoggingIn,
            loaderString: "Creating Pin",
            buttonString: "Continue",
          ),
        ),
      ),
    );
  }
}

class EnterPinView extends StatefulWidget {
  const EnterPinView({super.key});

  @override
  State<EnterPinView> createState() => _EnterPinViewState();
}

class _EnterPinViewState extends State<EnterPinView> {
  final TextEditingController pinController = TextEditingController();
  final _pinVerificationController = Get.put(PinVerificationController());
  final _mobileVerificationController = Get.put(MobileVerificationController());
  final _otpSentController = Get.put(OtpSentController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GraddingAppBar(
        backButton: true,
        showActions: false,
        title: "Login Pin",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              Lottie.asset(AssetPath.lockLottie, height: 135),
              Text(
                "Enter Your 4 digit Login Pin",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkJungleGreen,
                    ),
              ),
              const SizedBox(height: 30),
              PinputField(
                controller: pinController,
                obscureText: true,
                validator: (value) {
                  return GenericValidator.required(value: value, message: "Please Enter Pin") ??
                      GenericValidator.checkLength(
                          value: value, length: 4, message: "Enter Valid Pin");
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Forgot Pin? "),
                  GestureDetector(
                    onTap: () async {
                      if (_otpSentController.isLoggingIn.value == true) {
                        return;
                      }
                      final otpData = _mobileVerificationController.state?.result?.user;
                      await _otpSentController.otpSent(
                        postData: {
                          'country_code': otpData?.countryCode ?? "",
                          'phone': otpData?.phone ?? "",
                          'name': otpData?.name ?? "",
                          'last_name': otpData?.lastName ?? "",
                          'email': otpData?.email ?? "",
                          'reset': 'reset'
                        },
                      );
                      MyNavigator.pushNamed(
                        GoPaths.otp,
                        extra: {
                          'phone': otpData?.email ?? "",
                          'path': GoPaths.enterPin,
                        },
                      );
                    },
                    child: ButtonLoader(
                      isLoading: _otpSentController.isLoggingIn,
                      buttonString: "Reset",
                      loaderString: "Resetting",
                      textStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "By continuing, you agree to our ",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.stormGrey,
                        ),
                    children: [
                      TextSpan(
                        text: "Terms of Service",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushNamed(
                              GoPaths.viewPolicy,
                              extra: {
                                "title": "Terms & Conditins",
                                "policy": defaultController.state?.result?.terms,
                                "leaveUrl": ""
                              },
                            );
                          },
                      ),
                      const TextSpan(
                        text: " and ",
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.pushNamed(
                              GoPaths.viewPolicy,
                              extra: {
                                "title": "Privacy Policy",
                                "policy": defaultController.state?.result?.privacy,
                                "leaveUrl": ""
                              },
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width, 60),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() == false) {
              return;
            }
            _pinVerificationController
                .pinVerification(
              pin: pinController.text,
              token: _mobileVerificationController.state?.result?.token ?? "",
            )
                .then((value) {
              if (value['status'] == 1) {
                MyNavigator.popUntilAndPushNamed(value['result']['path']);
                return;
              }
              Dialogs.errorDialog(context, title: value['message']);
            });
          },
          child: ButtonLoader(
            isLoading: _pinVerificationController.isLoggingIn,
            loaderString: "Checking...",
            buttonString: "Continue",
          ),
        ),
      ),
    );
  }
}
