class PinVerificationModel {
  PinVerificationModel({
    this.message,
    this.status,
    this.result,
  });

  PinVerificationModel.fromJson(dynamic json) {
    message = json['message'];
    status = json['status'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  String? message;
  num? status;
  Result? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['status'] = status;
    if (result != null) {
      map['result'] = result?.toJson();
    }
    return map;
  }
}

class Result {
  Result({
    this.token,
    this.path,
  });

  Result.fromJson(dynamic json) {
    token = json['_token'];
    path = json['path'];
  }
  String? token;
  String? path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_token'] = token;
    map['path'] = path;
    return map;
  }
}
