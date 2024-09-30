import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradding/onboarding_module/model/pin_verification_model.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class PinVerificationController extends GetxController with StateMixin<PinVerificationModel> {
  RxBool isLoggingIn = RxBool(false);
  final prefs = GetStorage();

  Future<dynamic> pinVerification({required String pin, required String token}) async {
    const apiEndPoint = APIEndPoints.pinVerification;
    isLoggingIn.value = true;
    debugPrint("---------- $apiEndPoint pinVerification Start ----------");

    try {
      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: {"pin": pin, "token": token},
      );

      debugPrint("PinVerificationController => pinVerification > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      if (response.data['status'] == 1) {
        prefs.write("IS_LOGGED_IN", true);
        prefs.write('TOKEN', response.data['result']['_token']);
      }
      final modal = PinVerificationModel.fromJson(response.data);
      change(modal, status: RxStatus.success());

      return response.data;
    } catch (error) {
      debugPrint("---------- $apiEndPoint pinVerification End With Error ----------");
      debugPrint("PinVerificationController => pinVerification > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint pinVerification End ----------");
      isLoggingIn.value = false;
    }
  }
}
