import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gradding/onboarding_module/model/get_services_model.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class GetServicesController extends GetxController with StateMixin<GetServicesModel> {
  getServices() async {
    const apiEndPoint = APIEndPoints.getServices;
    debugPrint("---------- $apiEndPoint  Start ----------");

    try {
      final response = await getRequest(apiEndPoint: apiEndPoint);

      debugPrint("GetServicesController => getMenuItems > Success  ${response.data}");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      final modal = GetServicesModel.fromJson(response.data);
      change(modal, status: RxStatus.success());
    } catch (error) {
      debugPrint("---------- $apiEndPoint getMenuItems End With Error ----------");
      debugPrint("GetServicesController => getMenuItems > Error $error ");
      change(null, status: RxStatus.error());
    } finally {
      debugPrint("---------- $apiEndPoint getMenuItems End ----------");
    }
  }
}
