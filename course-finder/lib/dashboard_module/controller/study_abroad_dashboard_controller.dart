import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:study_abroad/study_abroad_module/models/study_abroad_dashboard_model.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class StudyAbroadDashboardController extends GetxController
    with StateMixin<StudyAbroadDashboardModel> {
  RxBool isLoading = RxBool(false);

  getStudyAbroadDashboardData() async {
    const apiEndPoint = APIEndPoints.studyAbroadDashboard;

    debugPrint("---------- $apiEndPoint getStudyAbroadDashboardData Start ----------");
    isLoading.value = true;
    try {
      final response = await getRequest(apiEndPoint: apiEndPoint);

      debugPrint(
          "StudyAbroadDashboardController =>  getStudyAbroadDashboardData > Success $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ';
      }

      final modal = StudyAbroadDashboardModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
    } catch (error) {
      debugPrint("---------- $apiEndPoint  getStudyAbroadDashboardData End With Error ----------");
      debugPrint(" StudyAbroadDashboardController =>  getStudyAbroadDashboardData > Error $error ");
      change(null, status: RxStatus.error(error.toString()));
    } finally {
      isLoading.value = false;
      debugPrint("---------- $apiEndPoint  getStudyAbroadDashboardData End ----------");
    }
  }
}
