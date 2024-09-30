import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class OtpVerificationController extends GetxController {
  RxBool isLoggingIn = RxBool(false);
  final prefs = GetStorage();

  Future<dynamic> otpVerification({
    required String pin,
    required String token,
    required String countryCode,
    required String phone,
  }) async {
    const apiEndPoint = APIEndPoints.otpVerification;
    isLoggingIn.value = true;
    debugPrint("---------- $apiEndPoint otpVerification Start ----------");

    try {
      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: {
          "otp": pin,
          "original_otp": token,
          "country_code": countryCode,
          "phone": phone,
        },
      );

      debugPrint("OtpVerificationController => otpVerification > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      prefs.write('TOKEN', response.data['_token']);
      prefs.write("IS_LOGGED_IN", true);

      return response.data;
    } catch (error) {
      debugPrint("---------- $apiEndPoint otpVerification End With Error ----------");
      debugPrint("OtpVerificationController => otpVerification > Error $error ");
    } finally {
      debugPrint("---------- $apiEndPoint otpVerification End ----------");
      isLoggingIn.value = false;
    }
  }
}
