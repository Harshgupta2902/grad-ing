import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:utilities/dio/api_end_points.dart';
import 'package:utilities/dio/api_request.dart';

class PinGenerateController extends GetxController {
  RxBool isLoggingIn = RxBool(false);
  final prefs = GetStorage();

  Future<dynamic> pinGenerate({
    required String pin,
    required String countryCode,
    required String phone,
  }) async {
    const apiEndPoint = APIEndPoints.pinGenerate;
    isLoggingIn.value = true;
    debugPrint("---------- $apiEndPoint pinGenerate Start ----------");

    try {
      final response = await postRequest(
        apiEndPoint: apiEndPoint,
        postData: {
          "pin": pin,
          "country_code": countryCode,
          "phone": phone,
        },
      );

      debugPrint("PinGenerateController => pinGenerate > Success  $response");

      if (response.statusCode != 200) {
        throw 'API ERROR ${response.statusCode} Message ${response.statusMessage}';
      }

      if (response.data['status'] == 1) {
        prefs.write('TOKEN', response.data['result']['_token']);
        prefs.write("IS_LOGGED_IN", true);
      }
      var token = prefs.read('TOKEN');
      debugPrint("token::::::::::$token");
      return response.data;
    } catch (error) {
      debugPrint("---------- $apiEndPoint pinGenerate End With Error ----------");
      debugPrint("PinGenerateController => pinGenerate > Error $error ");
    } finally {
      debugPrint("---------- $apiEndPoint pinGenerate End ----------");
      isLoggingIn.value = false;
    }
  }
}
