import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:utilities/components/button_loader.dart';
import 'package:gradding/onboarding_module/controller/otp_sent_controller.dart';
import 'package:gradding/onboarding_module/controller/otp_verification_controller.dart';
import 'package:gradding/utilities/navigation/go_paths.dart';
import 'package:gradding/utilities/navigation/navigator.dart';
import 'package:gradding/utilities/constants/assets_path.dart';
import 'package:utilities/components/gradding_app_bar.dart';
import 'package:utilities/theme/app_box_decoration.dart';
import 'package:utilities/theme/app_colors.dart';
import 'package:utilities/validators/generic_validator.dart';
import 'package:utilities/form_fields/pinput_field.dart';

final _otpVerificationController = Get.put(OtpVerificationController());
final _otpSentController = Get.put(OtpSentController());

class OtpView extends StatefulWidget {
  const OtpView({super.key, required this.number, required this.path});

  final String number;
  final String path;

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  int _start = 30;
  late Timer _timer;
  String? error;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    setState(() {
      error = "";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const GraddingAppBar(
          backButton: true,
          showActions: false,
          title: "Verification Code",
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetPath.otp,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                const SizedBox(height: 44),
                Text(
                  "Please enter 4 digit code sent to:",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkJungleGreen,
                      ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: AppBoxDecoration.getBorderBoxDecoration(
                    borderColor: AppColors.primaryColor,
                    borderRadius: 17,
                    color: Colors.transparent,
                    borderWidth: 1.5,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      SvgPicture.asset(AssetPath.sms),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "via ${widget.path == GoPaths.login ? 'SMS:' : 'Email:'}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: AppColors.paleSky,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.number,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => MyNavigator.popUntilAndPushNamed(GoPaths.login,
                            extra: {"number": widget.number}),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: AppBoxDecoration.getBoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.08),
                            borderRadius: 26,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                PinputField(
                  controller: otpController,
                  autofill: AndroidSmsAutofillMethod.smsUserConsentApi,
                  onChanged: (value) {
                    setState(() {
                      error = null;
                    });
                  },
                  onCompleted: (values) {
                    final otpData = _otpSentController.state?.result;
                    _otpVerificationController
                        .otpVerification(
                      pin: otpController.text,
                      token: otpData?.otp ?? "",
                      countryCode: otpData?.user?.countryCode ?? "",
                      phone: otpData?.user?.phone ?? "",
                    )
                        .then((value) {
                      if (value['status'].toString() == "1") {
                        setState(() {
                          error = "";
                        });
                        widget.path == GoPaths.login
                            ? MyNavigator.popUntilAndPushNamed(value['path'].toString())
                            : MyNavigator.popUntilAndPushNamed(
                                GoPaths.createPin,
                                extra: {
                                  'countryCode': otpData?.user?.countryCode ?? "",
                                  'number': otpData?.user?.phone ?? "",
                                },
                              );
                      } else {
                        debugPrint(value['message'].toString());
                        setState(() {
                          error = value['message'].toString();
                        });
                      }
                    });
                  },
                  validator: (value) {
                    return GenericValidator.required(
                          value: value,
                          message: "Please Enter Otp",
                        ) ??
                        GenericValidator.checkLength(
                          value: value,
                          length: 4,
                          message: "Enter Valid OTP",
                        );
                  },
                ),
                const SizedBox(height: 4),
                if (error != null && otpController.text != "" && otpController.text.length == 4)
                  Text(
                    "$error",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.cadmiumRed),
                  ),
                const SizedBox(height: 26),
                _start != 0
                    ? RichText(
                        text: TextSpan(
                          text: "Resend OTP in ",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.balticSea,
                                fontWeight: FontWeight.w400,
                              ),
                          children: [
                            TextSpan(
                              text: "00:$_start",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (_start == 0) {
                            _start = 30;
                            final data = _otpSentController.state?.result?.user;
                            _otpSentController.otpSent(
                              postData: {
                                'country_code': data?.countryCode ?? "",
                                'phone': data?.phone ?? "",
                                'name': data?.name ?? "",
                                'last_name': data?.lastName ?? "",
                                'country': data?.country ?? "",
                                'reset': 'reset',
                              },
                            );
                            otpController.clear();
                            error = "";
                            startTimer();
                          }
                        },
                        child: Text(
                          'Resend OTP',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
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
              final otpData = _otpSentController.state?.result;
              _otpVerificationController
                  .otpVerification(
                pin: otpController.text,
                token: otpData?.otp ?? "",
                countryCode: otpData?.user?.countryCode ?? "",
                phone: otpData?.user?.phone ?? "",
              )
                  .then((value) {
                if (value['status'].toString() == "1") {
                  setState(() {
                    error = "";
                  });
                  widget.path == GoPaths.login
                      ? MyNavigator.popUntilAndPushNamed(value['path'].toString())
                      : MyNavigator.popUntilAndPushNamed(
                          GoPaths.createPin,
                          extra: {
                            'countryCode': otpData?.user?.countryCode ?? "",
                            'number': otpData?.user?.phone ?? "",
                          },
                        );
                } else {
                  debugPrint(value['message'].toString());
                  setState(() {
                    error = value['message'].toString();
                  });
                }
              });
            },
            child: ButtonLoader(
              isLoading: _otpVerificationController.isLoggingIn,
              buttonString: "Verify & Continue",
              loaderString: "Verifying...",
            ),
          ),
        ),
      ),
    );
  }
}
