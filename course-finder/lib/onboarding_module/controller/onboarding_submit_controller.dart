import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class OnBoardingSubmitController extends GetxController {
  RxBool isSubmitting = RxBool(false);
  onBoardingSubmit({required Map<String, dynamic> postData}) async {
    isSubmitting.value = true;
    const apiEndPoint = APIEndPoints.onBoardingSubmit;
    debugPrint("---------- $apiEndPoint onBoardingSubmit Start ----------");

    try {
      final response = await postRequest(apiEndPoint: apiEndPoint, postData: postData);

      debugPrint("OnBoardingSubmitController => onBoardingSubmit > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }
    } catch (error) {
      debugPrint("---------- $apiEndPoint onBoardingSubmit End With Error ----------");
      debugPrint("OnBoardingSubmitController => onBoardingSubmit > Error $error ");
    } finally {
      debugPrint("---------- $apiEndPoint onBoardingSubmit End ----------");
      isSubmitting.value = false;

    }
  }
}
