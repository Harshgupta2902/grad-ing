import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gradding/onboarding_module/model/otp_sent_model.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class OtpSentController extends GetxController with StateMixin<OtpSentModel> {
  RxBool isLoggingIn = RxBool(false);

  Future<dynamic> otpSent({required Map<String, String> postData}) async {
    const apiEndPoint = APIEndPoints.otpSent;
    isLoggingIn.value = true;
    debugPrint("---------- $apiEndPoint otpSent Start ----------");

    try {
      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: postData,
      );

      debugPrint("OtpSentController => otpSent > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      final modal = OtpSentModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
      return response.data['status'];
    } catch (error) {
      debugPrint("---------- $apiEndPoint otpSent End With Error ----------");
      debugPrint("OtpSentController => otpSent > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint otpSent End ----------");
      isLoggingIn.value = false;
    }
  }
}
