import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gradding/onboarding_module/model/on_boarding_questions_model.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class OnBoardingQuestionsController extends GetxController
    with StateMixin<OnBoardingQuestionsModel> {
  onBoardingQuestions({required List<String> services}) async {
    const apiEndPoint = APIEndPoints.onBoardingQuestions;
    debugPrint("---------- $apiEndPoint onBoardingQuestions Start ----------");

    try {
      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: {'services': jsonEncode(services)},
      );
      debugPrint("OnBoardingQuestionsController => onBoardingQuestions > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      final modal = OnBoardingQuestionsModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
    } catch (error) {
      debugPrint("---------- $apiEndPoint onBoardingQuestions End With Error ----------");
      debugPrint("OnBoardingQuestionsController => onBoardingQuestions > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint onBoardingQuestions End ----------");
    }
  }
}
