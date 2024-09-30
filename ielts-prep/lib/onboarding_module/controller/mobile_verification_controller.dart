import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gradding/onboarding_module/model/mobile_verification_model.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class MobileVerificationController extends GetxController with StateMixin<MobileVerificationModel> {
  RxBool isLoggingIn = RxBool(false);

  Future<dynamic> mobileVerification({required String country, required String number}) async {
    const apiEndPoint = APIEndPoints.mobileVerification;
    isLoggingIn.value = true;
    debugPrint("---------- $apiEndPoint mobileVerification Start ----------");

    try {
      final postData = {
        "country_code": country,
        "phone": number,
      };

      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: postData,
      );

      debugPrint("MobileVerificationController => mobileVerification > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      final modal = MobileVerificationModel.fromJson(response.data);
      change(modal, status: RxStatus.success());

      return response.data['status'];
    } catch (error) {
      debugPrint("---------- $apiEndPoint mobileVerification End With Error ----------");
      debugPrint("MobileVerificationController => mobileVerification > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint mobileVerification End ----------");
      isLoggingIn.value = false;
    }
  }
}
